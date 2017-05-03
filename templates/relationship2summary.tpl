<script>
    var relationship2summaryContactId = {$contactId};
    var relationship2summaryLink = '{crmURL p='civicrm/contact/view' q="reset=1&cid=$contactId&selectedChild=rel" absolute=true}';
    {literal}

    cj(function($){
        if ($(".crm-contact_type_label").length == 0) {
            CRM.alert("Someone has changed the summary layout, relationships can't be displayed properly");
            return;
        }

        $(".crm-summary-demographic-block").append('<div class="crm-summary-relationships-block crm-inline-edit">' +
            '<div class="crm-edit-help" id="relationshipLink"><span class="crm-i fa-pencil"></span>&nbsp; <span onclick="window.location = \''+relationship2summaryLink+'\';" title="'+ts('Relationships')+'">'+ts('Relationships')+'</span></div>' +
            '<div class="crm-clear crm-inline-block-content" title="{/literal}{ts}Relationships{/ts}{literal}"></div></div>');
        relationship2summaryLoad();

        $("a[href='#contact-summary']").click(relationship2summaryLoad);

    });

    function relationship2summaryLoad() {
        var params = {
            'sequential': 1,
            'contact_id': relationship2summaryContactId,
            'is_active': 1,
            'options': {'limit':10}
        };

        cj(".crm-summary-relationships-block .crm-inline-block-content").html('');
        CRM.api3('Relationship', 'getcount', params).success(function(result) {
            var totalRelationships = result.result;
            CRM.api3('Relationship', 'get', params, { success: function (data) {
                cj.each(data.values, function (key) {
                    var is_active = true;
                    if (data.values[key].end_date) {
                        var endDate = new Date(data.values[key].end_date);
                        var today = new Date();
                        if (endDate <= today) {
                            is_active = false;
                        }
                    }
                    if (data.values[key].case_id) {
                        is_active = false;
                    }
                    if (is_active) {
                        var url = CRM.url('civicrm/contact/view', {'cid': data.values[key].cid, 'reset': '1'});
                        var relationship = '<div class="crm-summary-row relationship-' + data.values[key].id + '">';
                        relationship = relationship + '<div class="crm-label">' + data.values[key].relation + '</div>';
                        relationship = relationship + '<div class="crm-content"><a href="' + url + '">' + data.values[key].display_name + '</a></div>';
                        relationship = relationship + '</div>';

                        cj(".crm-summary-relationships-block .crm-inline-block-content").append(relationship);
                    }
                });
                if (totalRelationships > 10) {
                    cj(".crm-summary-relationships-block .crm-inline-block-content").append('<div class="crm-summary-row relationship-count"><div class="crm-label"></div><div class="crm-content"><a href="'+relationship2summaryLink+'" title="'+ts('View relationships')+'">'+ts('View all other relationships (%1)', {1:totalRelationships})+'</a></div></div>');
                }
            }});
        });
    }

    {/literal}

</script>