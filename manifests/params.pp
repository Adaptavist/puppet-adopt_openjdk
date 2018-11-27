# provides default params
class adopt_openjdk::params {
    $versions               = [ '9' ]
    $default_ver            = undef
    $version_details = {
        '9' => { 'version_feature' => '0', 'version_update' => '4', 'version_patch' => '11' },
        '10' => { 'version_feature' => '0', 'version_update' => '2', 'version_patch' => '13' },
        '11' => { 'version_feature' => '0', 'version_update' => '1', 'version_patch' => '13' }
    }
}