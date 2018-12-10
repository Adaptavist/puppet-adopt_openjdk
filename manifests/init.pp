class adopt_openjdk(
    $versions               = $adopt_openjdk::params::versions,
    $default_ver            = $adopt_openjdk::params::default_ver,
    $version_details        = $adopt_openjdk::params::version_details,
    $install_dir            = $adopt_openjdk::params::install_dir,
    $tmp_dir                = $adopt_openjdk::params::tmp_dir,
    $create_link_to_path    = $adopt_openjdk::params::create_link_to_path
) inherits  adopt_openjdk::params {

    validate_array($versions)

    if ($default_ver) {
        if member($versions, $default_ver) {
            if defined('oracle_java') {
                Adopt_openjdk::Java_install<| |> -> Oracle_java::Set_default<| |> -> Adopt_openjdk::Set_default<| |>
            } else {
                Adopt_openjdk::Java_install<| |> -> Adopt_openjdk::Set_default<| |>
            }
            adopt_openjdk::set_default { "jdk-${default_ver}":
                install_dir => $install_dir
            }
        } else {
            err("Could not find default version '${default_ver}' in versions to be installed.")
        }
    }

    file { [$tmp_dir, $install_dir]:
        ensure => 'directory',
    }
    -> adopt_openjdk::java_install { $versions:
        version_details     => $version_details,
        install_dir         => $install_dir,
        create_link_to_path => $create_link_to_path,
        tmp_dir             => $tmp_dir
    }

}
