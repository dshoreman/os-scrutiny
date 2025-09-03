<?php

function scrutiny_cron()
{
    $model = new \OPNsense\Scrutiny\Scrutiny();

    if ('1' !== (string) $model->settings->enabled) {
        return [];
    }

    $args = ('1' === (string) $model->settings->debug) ? 'run --debug' : 'run';

    return [
        ['autocron' => [sprintf('/opt/scrutiny/bin/collector %s', $args), '*/15']],
    ];
}
