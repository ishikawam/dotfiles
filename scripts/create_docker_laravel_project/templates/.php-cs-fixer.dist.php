<?php

$finder = PhpCsFixer\Finder::create()
    ->exclude('storage')
    ->exclude('bootstrap/cache')
    ->in(__DIR__);

return (new PhpCsFixer\Config())
    ->setRules([
        '@PSR2' => true,
        'strict_param' => false, // in_array() の3番目にtrue入れられちゃうのでno
        'array_syntax' => ['syntax' => 'short'],  // array() -> []
        'function_typehint_space' => true,  // typehintの空白
        'include' => true,  // include, require, ファイルパスは、単一のスペースで区切る

        // phpdoc系
        'phpdoc_no_access' => true,
        'phpdoc_scalar' => true,

        'space_after_semicolon' => true,
        'standardize_not_equals' => true,
    ])
    ->setRiskyAllowed(true)
    ->setUsingCache(false)
    ->setFinder($finder);
