From: Steve French <smfrench@gmail.com>
Subject: config files and how to have persistent Linux kernel Driver/File
 System configuration info saved
Date: Thu, 28 Jun 2018 17:37:15 -0500
Message-ID: <CAH2r5msV1hBAGgqtMFh6P=OGPV3RKjVAER=5bg-6Y+vW5BEJwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Ronnie brought up an interesting point about the problems consistently
configuring file systems (or any Linux module for that matter) so that
reboot doesn't wipe away security or performance tuning changes.

Linux file systems typically allow configuration via various ways (I
may have left some out) for example:
- module load parameters (modprobe etc. e.g. for cachefs
"deferecreate" or "deferlookup" can be configured, as can various
parms in the nfs or cifs/smb3 modules)
- Settings via /proc/fs/ or /sys/fs (e.g. /sys/fs/ext4/features)
- Settings via mount parms

Other than /etc/fstab which is fairly limited,  AFAIK the only file
system that has persistent configuration in text files is nfs - which
allows a limited number of mount related settings to be set to
defaults via nfsmount.conf

Are there good examples of either text based configuration of Linux
kernel (preferably file system drivers) e.g. something vaguely like
/etc/btrfs or an /etc/xfs to set default security or performance
related parameters consistently over reboot of machine, or even better
something vaguely like Samba's "net conf" tools for setting
keyword=value for various types of settings in a somewhat safer way
(in a registry, which in Samba's case is cluster safe, and fairly
robust)

What is the recommended way to persist configuration settings for
Linux drivers across reboot?

-- 
Thanks,

Steve
