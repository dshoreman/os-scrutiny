<?php

namespace OPNsense\Scrutiny\Api;

use \OPNsense\Base\ApiMutableModelControllerBase;

class ServiceController extends ApiMutableModelControllerBase
{
    private const BINDIR = '/opt/scrutiny/bin';
    private const OUTFILE = self::BINDIR . '/collector';
    private const SRCFILE = 'scrutiny-collector-metrics-freebsd-amd64';

    protected static $internalModelClass = 'OPNsense\Scrutiny\Scrutiny';
    protected static $internalModelName = 'scrutiny';

    public function downloadAction(): array
    {
        if (!$this->request->isPost()) {
            return ['message' => 'action unavailable'];
        }

        $ch = curl_init('https://github.com/AnalogJ/scrutiny/releases/latest');
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, false);

        if (!curl_exec($ch)) {
            return ['message' => 'failed checking latest version'];
        }

        $latest = curl_getinfo($ch, CURLINFO_REDIRECT_URL);
        $release = str_replace('/tag/', '/download/', $latest) . '/' . self::SRCFILE;
        $message = "Latest version found at {$latest}...\n";

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

        return [
            'message' => $message . (is_executable(self::OUTFILE) ? 'DONE' : 'ERROR'),
        ];
    }
}
