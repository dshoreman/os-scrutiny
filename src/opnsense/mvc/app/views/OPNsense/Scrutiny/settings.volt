{{ partial('layout_partials/base_form', ['fields': form, 'id': 'settings']) }}

<script>
function setval(opt, val) {
    document.getElementById(`scrutiny.settings.${opt}`).innerText = val;
};

(() => {
    const form = mapDataToFormUI({'settings': '/api/scrutiny/settings/get'});

    form.done((data) => {
        setval('SmartVersion', '{{ versions.smartctl }}');
    });
})();
</script>
