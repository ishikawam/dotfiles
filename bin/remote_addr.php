<?php
// jitakuにて

$str = file_get_contents('http://parmcheck.boobie.jp/check.php');

preg_match('/.*REMOTE_ADDR.*?([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)/', $str, $output);

if (! $output[1]) exit;

$file = '/home/m_ishikawa/Dropbox/IP_Address/remote_addr-' . gethostname() . '.txt';
$remote_addr = file_get_contents($file);
if ($remote_addr == $output[1]) exit;

// IPが更新されたら通知＆保存
mb_internal_encoding('UTF-8');
mb_send_mail('masayuki_ishikawa@softbank.ne.jp, ishikawam@nifty.com', 'jitaku のIPが変わった！', $output[1]);
file_put_contents($file, $output[1]);
exec(sprintf('dropbox-api put %s dropbox:/IP_Address/', $file));
echo(sprintf('dropbox-api put %s dropbox:/IP_Address/', $file));

// DynamicDNS MyDNSへ送信
$mydns_list = array(
    'http://mydns040570:wfkQaRupiAg@www.mydns.jp/login.html', // osae.me
    'http://mydns161604:hYGmbCUv64F@www.mydns.jp/login.html', // didit.jp
    'http://mydns213815:xBZNwX7WMX9@www.mydns.jp/login.html', // boobie.jp
    'http://mydns172842:QY3LVBSMG3o@www.mydns.jp/login.html', // windserver.jp
);
$log = '---- ' . date('Y-m-d H:i:s', time()) . " --------------\n";
foreach ($mydns_list as $mydns) {
    $log .= file_get_contents($mydns);
}
$log .= "\n";
$file = '/home/m_ishikawa/Dropbox/IP_Address/mydns.log';
file_put_contents($file, $log);
exec(sprintf('dropbox-api put %s dropbox:/IP_Address/', $file));
echo(sprintf('dropbox-api put %s dropbox:/IP_Address/', $file));
