<script>
const UPDATE_URI = '/api/scrutiny/service/download';

function checkUpdateStatus(status, versions) {
    const collectorVersion = versions.collector.split(' ')[2],
        target = 'data-toggle="modal" data-target="#updater"',
        installBtnData = `data-endpoint="${UPDATE_URI}" data-label="Install v${versions.latest}"`,
        installBtn = `<button ${target} id="install" class="btn btn-xs btn-primary" ${installBtnData}></button>`;

    if (versions.collector == 'not detected') {
        $('#updaterLabel').text(`Installing scrutiny-collector v${versions.latest}`);

        return status.html(installBtn);
    } else if (versions.latest == collectorVersion) {
        return status.append(statusText('success', "You're up to date!"));
    }

    status.append(statusText('danger', 'An update is available!') + '<br>'
        + installBtn.replace('Install', 'Update to')
            .replace('><', ' style="margin-top: 6px;"><'));

    $('#updaterLabel').text(`Updating scrutiny-collector (v${collectorVersion} -> ${versions.latest})`);
}

function statusText(colour, status) {
    return `<br><span class="text-${colour}"><b>${status}</b></span>`
}

$(document).ready(() => {
    mapDataToFormUI({
        'status': '/api/scrutiny/status/get',
        'settings': '/api/scrutiny/settings/get'
    }).done(({ status: { Scrutiny: { version: versions }}}) => {
        const status = $('span[id="Scrutiny.version.collector"]');

        checkUpdateStatus(status, versions);

        $('#install').SimpleActionButton({ onAction: (data) => {
            const output = data.message.replaceAll('\n', '<br>');

            $('#updater .modal-body').html(`<pre class="bootstrap-dialog-body">${output}</pre>`);

            if ('version' in data && data['success']) {
                status.text(data['version']);
                checkUpdateStatus(status, { collector: data['version'], latest: versions.latest });
            }
        }});
    });

    $('#save').prop('type', 'submit').click(() =>
        saveFormToEndpoint('/api/scrutiny/settings/set', 'settings', () => {
            ajaxCall('/api/scrutiny/service/reload');
        })
    );
});
</script>

<div class="content-box">
    {{ partial('layout_partials/base_form', ['fields': statusForm, 'id': 'status']) }}
</div>
<div class="content-box __mt">
    {{ partial('layout_partials/base_form', ['fields': settingsForm, 'id': 'settings', 'apply_btn_id': 'save']) }}
</div>
{{ partial('layout_partials/base_dialog', [ 'id': 'updater', 'fields': [], 'label': '', 'hasSaveBtn': 'no' ]) }}
