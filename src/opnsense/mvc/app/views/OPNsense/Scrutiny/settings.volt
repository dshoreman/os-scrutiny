<script>
const UPDATE_URI = '/api/scrutiny/service/download';

function checkUpdateStatus(status, versions) {
    const installBtnData = `data-endpoint="${UPDATE_URI}" data-label="Install v${versions.latest}"`,
        installBtn = `<button id="install" class="btn btn-xs btn-primary" ${installBtnData}></button>`;

    if (versions.collector == 'not detected') {
        return status.html(installBtn);
    } else if (versions.latest == versions.collector.split(' ')[2]) {
        return status.append(statusText('success', "You're up to date!"));
    }

    status.append(statusText('danger', 'An update is available!') + '<br>'
        + installBtn.replace('Install', 'Update to')
            .replace('><', ' style="margin-top: 6px;"><'));
}

function statusText(colour, status) {
    return `<br><span class="text-${colour}"><b>${status}</b></span>`
}

$(document).ready(() => {
    mapDataToFormUI({
        'status': '/api/scrutiny/status/get',
        'settings': '/api/scrutiny/settings/get'
    }).done((data) => {
        const status = $('span[id="Scrutiny.version.collector"]');

        checkUpdateStatus(status, data.status.Scrutiny.version);

        $('#install').SimpleActionButton({
            onAction: (data) => {
                let val = data['message'];

                if ('version' in data && data['success']) {
                    $('#response').html(`<code class="text-info">${data['message'].replaceAll('\n', '<br>')}</code>`);
                    val = data['version'];
                } else {
                    $('#response').removeClass('alert-info').addClass('alert-danger').text('Install failed.');
                }

                status.html(val.replaceAll('\n', '<br>'));
                $('#response').fadeIn();
            }
        });
    });

    $('#save').prop('type', 'submit').click(() =>
        saveFormToEndpoint('/api/scrutiny/settings/set', 'settings', () => {
            ajaxCall('/api/scrutiny/service/reload');
        })
    );
});
</script>

<div class="alert alert-info" role="alert" style="display: none;" id="response"></div>

<div class="content-box">
    {{ partial('layout_partials/base_form', ['fields': statusForm, 'id': 'status']) }}
</div>
<div class="content-box __mt">
    {{ partial('layout_partials/base_form', ['fields': settingsForm, 'id': 'settings', 'apply_btn_id': 'save']) }}
</div>
