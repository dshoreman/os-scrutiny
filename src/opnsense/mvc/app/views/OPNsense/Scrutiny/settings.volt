<script>
function setVersion(opt, val) {
    document.getElementById(`Scrutiny.version.${opt}`).innerHTML = val;
};

$(document).ready(() => {
    mapDataToFormUI({'settings': '/api/scrutiny/settings/get'});
    mapDataToFormUI({'status': '/api/scrutiny/status/get'}).done((data) => {
        const versions = data.settings.Scrutiny.version,
            installBtnData = `data-endpoint="/api/scrutiny/service/download" data-label="Install v${versions.latest}"`,
            installBtn = `<button id="install" class="btn btn-xs btn-primary" ${installBtnData}></button>`;

        if (versions.collector == 'not detected') {
            setVersion('collector', installBtn);
        } else {
            let btn = '', colour = 'danger', status = 'An update is available!';

            if (versions.collector.split(' ')[2] != versions.latest) {
                btn = installBtn.replace('Install', 'Update to').replace('><', ' style="margin-top: 6px;"><');
            } else {
                status = "You're up to date!";
                colour = 'success';
            }

            setVersion('collector', `${versions.collector}<br><span class="text-${colour}"><b>${status}</b></span><br>${btn}`);
        }

        $('#install').SimpleActionButton({
            onAction: (data) => {
                let val = data['message'];

                if ('version' in data && data['success']) {
                    $('#response').html(`<code class="text-info">${data['message'].replaceAll('\n', '<br>')}</code>`);
                    val = data['version'];
                } else {
                    $('#response').removeClass('alert-info').addClass('alert-danger').text('Install failed.');
                }

                setVersion('collector', val.replaceAll('\n', '<br>'));
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
