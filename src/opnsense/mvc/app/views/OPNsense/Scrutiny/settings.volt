<script>
function setval(opt, val) {
    document.getElementById(`Scrutiny.settings.${opt}`).innerHTML = val;
};

$(document).ready(() => {
    const form = mapDataToFormUI({'settings': '/api/scrutiny/settings/get'}),
    installBtnData = 'data-endpoint="/api/scrutiny/service/download" data-label="Install v{{ versions.latest }}"',
    installBtn = `<button id="install" class="btn btn-xs btn-primary" ${installBtnData}></button>`;

    form.done((data) => {
        setval('smart_version', '{{ versions.smartctl }}');

        if ('{{ versions.scrutiny }}' == 'not detected') {
            setval('collector_version', installBtn);
        } else {
            let btn = '', colour = 'danger', status = 'An update is available!';

            if ('{{ versions.scrutiny }}'.split(' ')[2] != '{{ versions.latest }}') {
                btn = installBtn.replace('Install', 'Update to').replace('><', ' style="margin-top: 6px;"><');
            } else {
                status = "You're up to date!";
                colour = 'success';
            }

            setval('collector_version', `{{ versions.scrutiny }}<br><span class="text-${colour}"><b>${status}</b></span><br>${btn}`);
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

                setval('collector_version', val.replaceAll('\n', '<br>'));
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
    {{ partial('layout_partials/base_form', ['fields': form, 'id': 'settings', 'apply_btn_id': 'save']) }}
</div>
