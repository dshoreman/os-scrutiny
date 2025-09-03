<?php

function scrutiny_cron()
{
    $settings = new \OPNsense\Scrutiny\Settings();

    if ('1' !== (string) $settings->enabled) {
        return [];
    }

    $args = ('1' === (string) $settings->debug) ? 'run --debug' : 'run';

    if ('1' === (string) $settings->syslog) {
        $args .= ' 2>&1 | logger -t scrutiny';
    }

    return [
        ['autocron' => [sprintf('/opt/scrutiny/bin/collector %s', $args), '*/15']],
    ];
}
