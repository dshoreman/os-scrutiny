<?php

namespace OPNsense\Scrutiny\Api;

use \OPNsense\Base\ApiMutableModelControllerBase as BaseController;
use \OPNsense\Core\Backend;
use \OPNsense\Scrutiny\Scrutiny;

class ServiceController extends BaseController
{
    private const BINDIR = '/opt/scrutiny/bin';
    private const OUTFILE = self::BINDIR . '/collector';

    protected static $internalModelClass = 'OPNsense\Scrutiny\Settings';
    protected static $internalModelName = 'Scrutiny';

    public function reloadAction(): array
    {
        if (!$this->request->isPost()) {
            return ['status' => 'failed'];
        }

        $backend = new Backend();
        $result = $backend->configdRun('template reload OPNsense/Scrutiny');

        if (trim($result) == 'OK') {
            $result = $backend->configdRun('cron restart');
        }

        return ['status' => trim($result)];
    }

    public function downloadAction(): array
    {
        if (!$this->request->isPost()) {
            return ['message' => 'action unavailable'];
        }

        try {
            $latest = Scrutiny::latestReleaseLink();
            $release = Scrutiny::linkFromTagPage($latest);
            $message = "Latest version found at {$latest}...\n";
        } catch (\Exception $e) {
            return ['message' => $e->getMessage()];
        }

        if (!is_dir(self::BINDIR) && !mkdir(self::BINDIR, recursive: true)) {
            return ['message' => $message . 'Failed creating ' . self::BINDIR];
        }

        $message .= "Downloading from {$release}...\n";
        $message .= shell_exec(sprintf('fetch -amo "%s" "%s"', self::OUTFILE, $release));

        if (!is_file(self::OUTFILE)) {
            return ['message' => $message . 'Download failed or could not write ' . self::OUTFILE];
        }

        if (!is_executable(self::OUTFILE)) {
            $message .= "File downloaded. Making it executable...\n";
            $message .= shell_exec(sprintf("chmod -vv +x '%s'", self::OUTFILE));
        }

        $canRun = is_executable(self::OUTFILE);

        return [
            'message' => $message . ($canRun ? '[DONE]' : 'Failed setting execute bit.'),
            'version' => shell_exec(self::OUTFILE . ' -v'),
            'success' => $canRun,
        ];
    }
}
