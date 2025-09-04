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

        $this->view->pick('OPNsense/Scrutiny/settings');
    }
}
