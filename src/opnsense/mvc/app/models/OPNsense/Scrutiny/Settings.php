<?php

namespace OPNsense\Scrutiny;

use OPNsense\Base\BaseModel;

class Settings extends BaseModel
{
    private const LATEST_URI = 'https://github.com/AnalogJ/scrutiny/releases/latest';
    private const SRCFILE = 'scrutiny-collector-metrics-freebsd-amd64';

    public static function latestReleaseLink(): string
    {
        $ch = curl_init(self::LATEST_URI);

        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, false);
        curl_exec($ch) || throw new \Exception('Failed retrieving release');

        return curl_getinfo($ch, CURLINFO_REDIRECT_URL);
    }

    public static function latestVersion(): string
    {
        return preg_replace('!.*/v(.*)$!', '\1', self::latestReleaseLink());
    }

    public static function linkFromTagPage(string $link): string
    {
        return str_replace('/tag/', '/download/', $link) . '/' . self::SRCFILE;
    }
}
