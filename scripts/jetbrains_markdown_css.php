<?php

/**
 * ~/.config/jetbrains/markdown-preview.css を JetBrains IDE の Markdown プレビュー用 Custom CSS として適用する。
 *
 * Custom CSS はプロジェクト単位の設定でありアプリ全体の設定項目がないため、以下の 2 箇所に書き込む。
 * - 既存プロジェクト: ~/git, ~/dev 配下の .idea/markdown.xml
 * - 新規プロジェクトの既定値: インストール済みの各 IDE の最新バージョン設定ディレクトリの options/project.default.xml
 *
 * 書き込むのは MarkdownSettings の customStylesheetText / useCustomStylesheetText のみで、他の設定は保持する。
 * 起動中の IDE は終了時に設定を書き戻し、.idea は IDE 間で共有されるため、対象 IDE のいずれかが起動中なら中止する。
 * 書き込み前に対象ファイルを一覧表示し、確認を取る。
 */

const CSS_PATH = '/.config/jetbrains/markdown-preview.css';
const PROJECT_ROOTS = ['/git', '/dev'];
// ~/git/<org>/<repo>/.idea および ~/git/<org>/<repo>/<sub>/.idea まで探索する
const MAX_PROJECT_DEPTH = 3;
const JETBRAINS_CONFIG_DIR = '/Library/Application Support/JetBrains';
// 設定ディレクトリ名の接頭辞 => 起動判定に使う実行ファイルのパス
const IDES = [
    'PhpStorm' => 'PhpStorm.app/Contents/MacOS/phpstorm',
    'GoLand' => 'GoLand.app/Contents/MacOS/goland',
];

const COMPONENT_NAME = 'MarkdownSettings';
const OPTION_TEXT = 'customStylesheetText';
const OPTION_USE_TEXT = 'useCustomStylesheetText';

$home = getenv('HOME');

$runningIdes = findRunningIdes();
if ($runningIdes !== []) {
    fwrite(STDERR, implode(', ', $runningIdes) . " が起動中です。終了してから再実行してください。\n");
    exit(1);
}

$cssFile = $home . CSS_PATH;
if (! is_file($cssFile)) {
    fwrite(STDERR, "CSS が見つかりません: {$cssFile}\n");
    exit(1);
}
$css = file_get_contents($cssFile);

$targets = [];
foreach (findProjectIdeaDirs($home) as $ideaDir) {
    $targets[] = new ProjectMarkdownXml($ideaDir . '/markdown.xml');
}
$optionsDirs = findLatestOptionsDirs($home);
if ($optionsDirs === []) {
    fwrite(STDERR, '対象 IDE (' . implode(', ', array_keys(IDES)) . ") の設定ディレクトリが見つかりません。\n");
    exit(1);
}
foreach ($optionsDirs as $optionsDir) {
    $targets[] = new DefaultProjectXml($optionsDir . '/project.default.xml');
}

$pending = array_values(array_filter($targets, fn (SettingsFile $t) => ! $t->isUpToDate($css)));

if ($pending === []) {
    echo "すべて適用済みです。\n";
    exit(0);
}

echo "以下のファイルに Custom CSS を書き込みます:\n";
foreach ($pending as $target) {
    printf("  [%s] %s\n", $target->exists() ? '更新' : '新規', $target->path);
}
printf("適用済みでスキップ: %d 件\n", count($targets) - count($pending));

echo "\n実行しますか？ [y/N]: ";
if (strtolower(trim((string) fgets(STDIN))) !== 'y') {
    echo "キャンセルしました。\n";
    exit(0);
}

foreach ($pending as $target) {
    $target->apply($css);
    echo "書き込み: {$target->path}\n";
}

/**
 * @return list<string> 起動中の IDE 名
 */
function findRunningIdes(): array
{
    $running = [];
    foreach (IDES as $ide => $processPattern) {
        exec('pgrep -f ' . escapeshellarg($processPattern), $output, $status);
        if ($status === 0) {
            $running[] = $ide;
        }
    }

    return $running;
}

/**
 * @return list<string>
 */
function findProjectIdeaDirs(string $home): array
{
    $dirs = [];
    foreach (PROJECT_ROOTS as $root) {
        for ($depth = 1; $depth <= MAX_PROJECT_DEPTH; $depth++) {
            $pattern = $home . $root . str_repeat('/*', $depth) . '/.idea';
            $dirs = array_merge($dirs, glob($pattern, GLOB_ONLYDIR) ?: []);
        }
    }
    sort($dirs);

    return $dirs;
}

/**
 * 旧バージョンの設定ディレクトリは IDE 更新時に引き継ぎ元として残るだけなので、最新バージョンのみを返す。
 *
 * @return list<string> 設定ディレクトリが存在する IDE ごとの options ディレクトリ
 */
function findLatestOptionsDirs(string $home): array
{
    $optionsDirs = [];
    foreach (array_keys(IDES) as $ide) {
        $dirs = glob($home . JETBRAINS_CONFIG_DIR . '/' . $ide . '[0-9]*', GLOB_ONLYDIR) ?: [];
        if ($dirs === []) {
            continue;
        }
        natsort($dirs);
        $optionsDirs[] = end($dirs) . '/options';
    }

    return $optionsDirs;
}

/**
 * MarkdownSettings コンポーネントを含む IDE 設定ファイル。
 * サブクラスはファイルが存在しない場合の雛形と、コンポーネントの配置先を定義する。
 */
abstract class SettingsFile
{
    public function __construct(public readonly string $path)
    {
    }

    public function exists(): bool
    {
        return is_file($this->path);
    }

    public function isUpToDate(string $css): bool
    {
        if (! $this->exists()) {
            return false;
        }
        $component = $this->findComponent($this->load());

        return $component !== null
            && $this->optionValue($component, OPTION_TEXT) === $css
            && $this->optionValue($component, OPTION_USE_TEXT) === 'true';
    }

    public function apply(string $css): void
    {
        $doc = $this->load();
        $component = $this->findComponent($doc) ?? $this->createComponent($doc);
        $this->setOption($component, OPTION_TEXT, $css);
        $this->setOption($component, OPTION_USE_TEXT, 'true');

        file_put_contents($this->path, $this->serialize($doc));
    }

    abstract protected function skeleton(): string;

    abstract protected function componentParent(DOMDocument $doc): DOMElement;

    abstract protected function serialize(DOMDocument $doc): string;

    private function load(): DOMDocument
    {
        $doc = new DOMDocument();
        $doc->preserveWhiteSpace = false;
        $doc->formatOutput = true;
        $xml = $this->exists() ? file_get_contents($this->path) : $this->skeleton();
        if (! $doc->loadXML($xml)) {
            throw new RuntimeException("XML を解析できません: {$this->path}");
        }
        // 宣言のない XML でも日本語を文字参照に変換せず出力するため
        $doc->encoding = 'UTF-8';

        return $doc;
    }

    private function findComponent(DOMDocument $doc): ?DOMElement
    {
        foreach ($this->componentParent($doc)->childNodes as $node) {
            if ($node instanceof DOMElement && $node->tagName === 'component' && $node->getAttribute('name') === COMPONENT_NAME) {
                return $node;
            }
        }

        return null;
    }

    private function createComponent(DOMDocument $doc): DOMElement
    {
        $component = $doc->createElement('component');
        $component->setAttribute('name', COMPONENT_NAME);

        return $this->componentParent($doc)->appendChild($component);
    }

    private function findOption(DOMElement $component, string $name): ?DOMElement
    {
        foreach ($component->childNodes as $node) {
            if ($node instanceof DOMElement && $node->tagName === 'option' && $node->getAttribute('name') === $name) {
                return $node;
            }
        }

        return null;
    }

    private function optionValue(DOMElement $component, string $name): ?string
    {
        return $this->findOption($component, $name)?->getAttribute('value');
    }

    private function setOption(DOMElement $component, string $name, string $value): void
    {
        $option = $this->findOption($component, $name);
        if ($option === null) {
            $option = $component->ownerDocument->createElement('option');
            $option->setAttribute('name', $name);
            $component->appendChild($option);
        }
        $option->setAttribute('value', $value);
    }
}

/**
 * プロジェクトの .idea/markdown.xml。
 */
final class ProjectMarkdownXml extends SettingsFile
{
    protected function skeleton(): string
    {
        return '<?xml version="1.0" encoding="UTF-8"?><project version="4"/>';
    }

    protected function componentParent(DOMDocument $doc): DOMElement
    {
        return $doc->documentElement;
    }

    protected function serialize(DOMDocument $doc): string
    {
        return $doc->saveXML();
    }
}

/**
 * 新規プロジェクトの既定値を保持する options/project.default.xml。
 * IDE が出力する形式に合わせて XML 宣言なしで保存する。
 */
final class DefaultProjectXml extends SettingsFile
{
    protected function skeleton(): string
    {
        return '<application><component name="ProjectManager"><defaultProject/></component></application>';
    }

    protected function componentParent(DOMDocument $doc): DOMElement
    {
        $nodes = (new DOMXPath($doc))->query('/application/component[@name="ProjectManager"]/defaultProject');
        if ($nodes->length !== 1) {
            throw new RuntimeException("defaultProject 要素が見つかりません: {$this->path}");
        }

        return $nodes->item(0);
    }

    protected function serialize(DOMDocument $doc): string
    {
        return $doc->saveXML($doc->documentElement) . "\n";
    }
}
