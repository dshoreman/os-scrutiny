<?php

namespace OPNsense\Scrutiny;

class SettingsController extends \OPNsense\Base\IndexController
{
    public function indexAction()
    {
        $this->view->title = 'Services: Scrutiny: Settings';
        $this->view->description = 'Configure how the Scrutiny collector runs and logs data.';

        $this->view->form = $this->getForm('settings');
        $this->view->versions = (object) [
            'smartctl' => trim(shell_exec('{ smartctl -V || echo not installed; } | head -n1')),
        ];

        $this->view->pick('OPNsense/Scrutiny/settings');
    }
}
