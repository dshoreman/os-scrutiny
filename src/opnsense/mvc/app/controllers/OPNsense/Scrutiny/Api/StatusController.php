<?php

namespace OPNsense\Scrutiny\Api;

use \OPNsense\Base\ApiControllerBase as BaseController;
use \OPNsense\Scrutiny\Scrutiny;

class StatusController extends BaseController
{
    public function getAction(): array
    {
        return ['Scrutiny' => ['version' => [
            'smart' => $this->printVersion('smartctl', 'head'),
            'collector' => $this->printVersion('scrutiny', 'tail'),
            'latest' => Scrutiny::latestVersion(),
        ]]];
    }

    private function printVersion(string $binary, string $headOrTail): string
    {
        $map = [
            'scrutiny' => '/opt/scrutiny/bin/collector -v',
            'smartctl' => 'smartctl -V',
        ];

        return trim(shell_exec(sprintf(
            '{ %s || echo not detected; } | %s -n1',
            $map[$binary],
            $headOrTail,
        )));
    }
}
