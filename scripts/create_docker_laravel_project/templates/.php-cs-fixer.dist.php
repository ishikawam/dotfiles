<?php

$finder = PhpCsFixer\Finder::create()
    ->exclude('storage')
    ->exclude('bootstrap/cache')
    ->in(__DIR__);

return (new PhpCsFixer\Config())
    ->setRules([
        '@PhpCsFixer' => true,
        // https://mlocati.github.io/php-cs-fixer-configurator/

        'php_unit_method_casing' => [
            'case' => 'snake_case',
        ],  // testのfunctionのcaseはsnake_case
        'no_unused_imports' => false,  // laravelであえて置いてあるのもある
        'single_line_comment_style' => false,  // laravel configがいじられてしまう
        'new_with_braces' => [
            'anonymous_class' => false,
            'named_class' => false,
        ],  // laravel仕様に
        'no_empty_comment' => false,  // 空コメントを区切り線にしてるので
        'multiline_whitespace_before_semicolons' => [
            'strategy' => 'no_multi_line',
        ],  // 多分デフォルトが効いていないバグ。
        'phpdoc_summary' => false,  // 勝手に句読点。絶対やらない
        'phpdoc_to_comment' => false,  // swaggerあるのでやらない
        'single_trait_insert_per_statement' => false,  // laravel的にはfalse
        'phpdoc_types_order' => [
            'null_adjustment' => 'always_last',
            'sort_algorithm' => 'none',
        ],  // laravel仕様に
        'not_operator_with_successor_space' => true,  // laravel的にはtrue
        'class_definition' => [
            'inline_constructor_arguments' => true,
            'space_before_parenthesis' => true,
            'single_line' => true,
        ],  // 厳格に

//        'braces' => false,  // /* */コメントアウトを強制インデントされてしまうのはやりたくないが、役に立つので。。有効にして様子見
    ])
    ->setRiskyAllowed(true)
    ->setUsingCache(false)
    ->setFinder($finder);
