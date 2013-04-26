From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Poor write performance -- Xen hypervisor issue?
Date: Fri, 26 Apr 2013 16:06:29 -0500
Message-ID: <CAH2r5mssMzGc_9uvzgr1K010zdA=CrMpQX4AgEuAaQr_4D-zDQ@mail.gmail.com>
References: <CAGaXCDQ4F3UQeReWWhNnEumn=uTjxCpk42j2xfhj_zNd-BoQ=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Coppit <david-jJBghJZ9yacdnm+yROfE0A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGaXCDQ4F3UQeReWWhNnEumn=uTjxCpk42j2xfhj_zNd-BoQ=Q@mail.gmail.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

You are running a very old kernel - although you would probably be
fine with the latest RHEL updates (since they include some backports
of performance improvements).  See below note (reposted):

You will need a more recent kernel (probably based on the 3.2 kernel
or later) to see the dramatic improvements in cifs
read speeds (with the redesign of the read code
to add more parallelism on i/o to the same file) although RedHat may
have backported some of Jeff's excellent performance improvements to
some of the older distros.  See slides 21 through 26 of my
presentation at

 http://www.snia.org/sites/default/files2/SDC2012/presentations/Revisions/SteveFrench_Linux_CIFS-SMB2-year-in-review-revision.pdf

Slides 23 and 24 list the cifs performance and functional enhancements
by kernel release.  Buffered, sequential read (e.g. file copy from a
server) got much faster in 3.2 kernel, especially to Samba and other
server which support the Unix extensions (due to support for larger
i/o sizes than 64K).

Similarly note that cifs write speed was dramatically improved
starting at kernel version 3.0 (1.5 to 2 years ago) due to the
addition of more async parallelism to the design of the cifs write
code (writing to the server from the cifs client) by making the i/o
sizes larger and allowing more async dispatch of writes (previously to
use a network interface fully you would need to be reading and or
writing to multiple different files simultaneously).

On Fri, Apr 26, 2013 at 2:43 PM, David Coppit <david-jJBghJZ9yacdnm+yROfE0A@public.gmane.org> wrote:
> Hi all,
>
> I'm trying to figure out why write performance to a cifs mount is so
> very very bad:
>
> # dd if=/dev/zero of=mount/test bs=256K count=10
> 10+0 records in
> 10+0 records out
> 2621440 bytes (2.6 MB) copied, 73.5463 seconds, 35.6 kB/s
>
> Ouch!
>
> Read performance is fine:
>
> # dd if=mount/test of=/dev/null bs=256K count=10
> 10+0 records in
> 10+0 records out
> 2621440 bytes (2.6 MB) copied, 0.0222379 seconds, 118 MB/s
>
> I can also hop on the Windows machine and use psftp to transfer a
> large file from the Linux box fairly quickly.
>
> One possible issue is that the Linux machine is a Xen hypervisor, and
> the Windows machine is actually a VM. I can mount the same Windows
> share on a Linux VM running on the same hypervisor and performance is
> fine (8.3 MB/s).
>
> The Windows box is running Windows Server 2008 R2. Here are specs for
> the problematic Xen hypervisor:
>
> # uname -r
> 2.6.32.12-0.7.1.xs1.4.90.530.170661xen
>
> # mount.cifs -V
> mount.cifs version: 1.12RH
>
> # yum list | grep samba
> samba.i386                                3.0.33-3.39.el5_8            installed
> samba-client.i386                         3.0.33-3.39.el5_8            installed
> samba-common.i386                         3.0.33-3.39.el5_8            installed
> samba-swat.i386                           3.0.33-3.39.el5_8            base
> samba3x.i386                              3.6.6-0.129.el5              base
> samba3x-client.i386                       3.6.6-0.129.el5              base
> samba3x-common.i386                       3.6.6-0.129.el5              base
> samba3x-doc.i386                          3.6.6-0.129.el5              base
> samba3x-domainjoin-gui.i386               3.6.6-0.129.el5              base
> samba3x-swat.i386                         3.6.6-0.129.el5              base
> samba3x-winbind.i386                      3.6.6-0.129.el5              base
> samba3x-winbind-devel.i386                3.6.6-0.129.el5              base
> sblim-cmpi-samba.i386                     1:1.0-49.el5                 base
> sblim-cmpi-samba-devel.i386               1:1.0-49.el5                 base
> sblim-cmpi-samba-test.i386                1:1.0-49.el5                 base
> system-config-samba.noarch                1.2.41-5.el5                 base
>
> I just installed this version of samba-client with yum. For
> comparison, here's the Linux VM:
>
> # uname -r
> 2.6.32-279.9.1.el6.x86_64
>
> # mount.cifs -V
> mount.cifs version: 4.8.1
>
> # yum list | grep samba
> samba.x86_64                          3.5.10-125.el6           @base
> samba-client.x86_64                   3.5.10-125.el6           @base
> samba-common.x86_64                   3.5.10-125.el6           @base
> samba-winbind-clients.x86_64          3.5.10-125.el6           @base
> samba4-libs.x86_64                    4.0.0-23.alpha11.el6     @base/$releasever
> samba.x86_64                          3.6.9-151.el6            base
> samba-client.x86_64                   3.6.9-151.el6            base
> samba-common.i686                     3.6.9-151.el6            base
> samba-common.x86_64                   3.6.9-151.el6            base
> samba-doc.x86_64                      3.6.9-151.el6            base
> samba-domainjoin-gui.x86_64           3.6.9-151.el6            base
> samba-swat.x86_64                     3.6.9-151.el6            base
> samba-winbind.x86_64                  3.6.9-151.el6            base
> samba-winbind-clients.i686            3.6.9-151.el6            base
> samba-winbind-clients.x86_64          3.6.9-151.el6            base
> samba-winbind-devel.i686              3.6.9-151.el6            base
> samba-winbind-devel.x86_64            3.6.9-151.el6            base
> samba-winbind-krb5-locator.x86_64     3.6.9-151.el6            base
> samba4.x86_64                         4.0.0-55.el6.rc4         base
> samba4-client.x86_64                  4.0.0-55.el6.rc4         base
> samba4-common.x86_64                  4.0.0-55.el6.rc4         base
> samba4-dc.x86_64                      4.0.0-55.el6.rc4         base
> samba4-dc-libs.x86_64                 4.0.0-55.el6.rc4         base
> samba4-devel.i686                     4.0.0-23.alpha11.el6     base
> samba4-devel.x86_64                   4.0.0-55.el6.rc4         base
> samba4-libs.i686                      4.0.0-23.alpha11.el6     base
> samba4-libs.x86_64                    4.0.0-55.el6.rc4         base
> samba4-pidl.x86_64                    4.0.0-55.el6.rc4         base
> samba4-python.x86_64                  4.0.0-55.el6.rc4         base
> samba4-swat.x86_64                    4.0.0-55.el6.rc4         base
> samba4-test.x86_64                    4.0.0-55.el6.rc4         base
> samba4-winbind.x86_64                 4.0.0-55.el6.rc4         base
> samba4-winbind-clients.x86_64         4.0.0-55.el6.rc4         base
> samba4-winbind-krb5-locator.x86_64    4.0.0-55.el6.rc4         base
> sblim-cmpi-samba.i686                 1.0-1.el6                base
> sblim-cmpi-samba.x86_64               1.0-1.el6                base
> sblim-cmpi-samba-devel.i686           1.0-1.el6                base
> sblim-cmpi-samba-devel.x86_64         1.0-1.el6                base
> sblim-cmpi-samba-test.x86_64          1.0-1.el6                base
>
> Should I be concerned about the samba-client versus samba3x-client?
> Should I try to get yum to install a newer version of mount.cifs, or
> build it from source? Sorry, I'm a bit clueless here.
>
> Thanks,
> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
