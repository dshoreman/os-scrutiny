<?php

namespace OPNsense\Scrutiny\Api;

use \OPNsense\Base\ApiMutableModelControllerBase;

class SettingsController extends ApiMutableModelControllerBase
{
    protected static $internalModelClass = \OPNsense\Scrutiny\Settings::class;
    protected static $internalModelName = 'Scrutiny';
}
