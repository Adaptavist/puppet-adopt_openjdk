define adopt_openjdk::java_install(
    $version_details,
    $install_dir     = '/usr/java',
    $tmp_dir         = '/tmp',
    ) {

    $package_name=$name
    # get version defaults
    $java_version_details = $version_details[$name]
    $version_feature=$java_version_details['version_feature']
    $version_update=$java_version_details['version_update']
    $version="${name}.${version_feature}.${version_update}"

    $version_patch=$java_version_details['version_patch']
    $download_url = $name ? {
        '10' => "https://github.com/AdoptOpenJDK/openjdk${name}-releases/releases/download/jdk-${version}%2B${version_patch}/OpenJDK${name}_x64_Linux_jdk-${version}.${version_patch}.tar.gz",
        default => "https://github.com/AdoptOpenJDK/openjdk${name}-binaries/releases/download/jdk-${version}%2B${version_patch}/OpenJDK${name}U-jdk_x64_linux_hotspot_${version}_${version_patch}.tar.gz"
    }

    exec {
        "download_openjdk_tar_${name}":
            command   => "wget ${download_url}",
            logoutput => on_failure,
            cwd       => $tmp_dir
    } -> exec {
        "extract_openjdk_tar_${name}":
            command   => "tar -C ${install_dir} -xf $(ls ${tmp_dir} | grep OpenJDK${name} | sort -V | tail -1)",
            logoutput => on_failure,
            cwd       => $tmp_dir
    }

    if $::osfamily == 'RedHat'{
        $alt_cmd_java="alternatives --install /usr/bin/java java ${install_dir}/$(ls ${install_dir}/ | grep jdk-${name} | sort -V| tail -1)/bin/java 200000"
        $alt_cmd_javac="alternatives --install /usr/bin/javac javac ${install_dir}/$(ls ${install_dir}/ | grep jdk-${name} | sort -V| tail -1)/bin/javac 200000"
        exec { "Install alternatives for java ${name}":
            command  => $alt_cmd_java,
            provider => shell,
            require  => Exec["extract_openjdk_tar_${name}"],
        } -> exec { "Install alternatives for javac ${name}":
            command  => $alt_cmd_javac,
            provider => shell,
        }
        exec { "Create symlink for jdk in /var/lib/jvm/jdk${name}":
            command  => "ln -sf ${install_dir}/$(ls ${install_dir}/ | grep jdk-${name} | sort | tail -1) /usr/lib/jvm/jdk${name}",
            provider => shell,
            require  => [Exec["extract_openjdk_tar_${name}"]]
        }
    }
}
