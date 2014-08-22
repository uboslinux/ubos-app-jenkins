#!/usr/bin/perl
#
# Move plugins directory out of folder being backed up
#

use strict;

use UBOS::Logging;
use UBOS::Utils;

my $ret  = 1;
my $dir  = $config->getResolveOrNull( 'appconfig.tomcat7.dir' );
my $home = "$dir/jenkins-home";
my $oldPlugins = "$home/plugins";
my $newPlugins = "$dir/jenkins-plugins";

if( 'install' eq $operation ) {
    if( -e $oldPlugins ) {
        if( -d $oldPlugins ) {
            UBOS::Utils::myexec( "mv $oldPlugins/* $newPlugins/" );
            unless( UBOS::Utils::rmdir( $oldPlugins )) {
                error( 'Plugins directory could not be removed: ', $oldPlugins );
            }
        } else {
            unless( UBOS::Utils::deleteFile( $oldPlugins )) {
                error( 'Plugins file/symlink could not be removed: ', $oldPlugins );
            }
        }
    }
    unless( UBOS::Utils::symlink( $newPlugins, $oldPlugins )) {
        error( 'Symlink could not be created:', $newPlugins, $oldPlugins );
    }
}
if( 'uninstall' eq $operation ) {
    if( -e $oldPlugins ) {
        unless( UBOS::Utils::deleteFile( $oldPlugins )) {
            error( 'Plugins symlink could not be removed: ', $oldPlugins );
        }
    }
}
$ret;
