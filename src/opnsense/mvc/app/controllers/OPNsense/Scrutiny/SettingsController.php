<?php

namespace OPNsense\Scrutiny;

class SettingsController extends \OPNsense\Base\IndexController
{
    public function indexAction()
    {
        $this->view->title = 'Services: Scrutiny: Settings';
        $this->view->description = 'Configure how the Scrutiny collector runs and logs data.';

        $this->view->settingsForm = $this->getForm('settings');
        $this->view->statusForm = $this->getForm('status');
        $this->view->versions = (object) [
            'scrutiny' => $this->printVersion('scrutiny', 'tail'),
            'smartctl' => $this->printVersion('smartctl', 'head'),
            'latest' => Settings::latestVersion(),
        ];

        $this->view->pick('OPNsense/Scrutiny/settings');
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
