<?php

/**
 * custom helper
 */

/**
 * asset() -> asset_x()
 * minifyされたアセットを開発用に戻す
 */
if (! function_exists('asset_x')) {
    function asset_x($path)
    {
        $asset = asset($path);
        if (config('app.debug')) {
            $asset = preg_replace('/\.min\./', '.', $asset);
        }

        return $asset;
    }
}

/**
 * json_encode() -> json_encode_x()
 * JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE
 */
if (! function_exists('json_encode_x')) {
    function json_encode_x($json)
    {
        return json_encode($json, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
    }
}
