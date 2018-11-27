class adopt_openjdk(
    $versions               = $adopt_openjdk::params::versions,
    $default_ver            = $adopt_openjdk::params::default_ver,
    $version_details        = $adopt_openjdk::params::version_details,
    $install_dir            = $adopt_openjdk::params::install_dir,
) inherits  adopt_openjdk::params {

    validate_array($versions)

    $default_version = $default_ver ? {
        undef        => $versions[0],
        $default_ver => $default_ver
    }

    if member($versions, $default_version) {

        if defined('oracle_java') {
            Adopt_openjdk::Java_install<| |> -> Oracle_java::Set_default<| |> -> Adopt_openjdk::Set_default<| |>
        } else {
            Adopt_openjdk::Java_install<| |> -> Adopt_openjdk::Set_default<| |>
        }
        adopt_openjdk::java_install { $versions:
            version_details => $version_details,
            install_dir     => $install_dir
        }

        adopt_openjdk::set_default { "jdk-${default_version}":
            install_dir     => $install_dir
        }
    } else {
        err("Could not find default version '${default_version}' in versions to be installed.")
    }
}
