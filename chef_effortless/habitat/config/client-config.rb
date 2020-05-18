ENV['PATH'] = "/sbin:/usr/sbin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:#{ENV['PATH']}"

policy_name 'base'
policy_group 'local'

use_policyfile true
policy_document_native_api true

cache_path "{{pkg.svc_data_path}}/cache"
node_path "{{pkg.svc_data_path}}/nodes"
role_path "{{pkg.svc_data_path}}/roles"
chef_zero.enabled true

ssl_verify_mode {{cfg.ssl_verify_mode}}

node_name "{{sys.hostname}}"

{{#if cfg.data_collector.enable ~}}
chef_guid "{{sys.member_id}}"
data_collector.token "{{cfg.data_collector.token}}"
data_collector.server_url "{{cfg.data_collector.server_url}}"
{{/if ~}}