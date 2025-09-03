<?php

function scrutiny_cron()
{
    return [
        ['autocron' => ['/opt/scrutiny/bin/collector run', '*/15']],
    ];
}
