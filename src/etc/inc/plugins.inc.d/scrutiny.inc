<?php

function scrutiny_cron()
{
    $model = new \OPNsense\Scrutiny\Scrutiny();

    if ('1' !== (string) $model->settings->enabled) {
        return [];
    }

    $args = ('1' === (string) $model->settings->debug) ? 'run --debug' : 'run';

    if ('1' === (string) $model->settings->syslog) {
        $args .= ' 2>&1 | logger -t scrutiny';
    }

    return [
        ['autocron' => [sprintf('/opt/scrutiny/bin/collector %s', $args), '*/15']],
    ];
}
