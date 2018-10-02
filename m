From: Rodrigo Freire <rfreire@redhat.com>
Subject: Re: [PATCH v2] CIFS: Print message when attempting a mount
Date: Tue, 2 Oct 2018 17:53:46 -0400 (EDT)
Message-ID: <633521295.32428133.1538517226400.JavaMail.zimbra@redhat.com>
References: <ad6b338c900a17c4ecb1655a42b954221f242be2.1538480816.git.rfreire@redhat.com> <CAH2r5mtu9XbQfR=QevDqu36ZRYah1hrRGSQyynCfr82PRyunwQ@mail.gmail.com> <194690850.32402710.1538508513975.JavaMail.zimbra@redhat.com> <CAH2r5ms814MUNWVZNfCTuSO2LQZsmCs5N1nwgdVuhxtMctRE3Q@mail.gmail.com> <697659653.32427271.1538515234390.JavaMail.zimbra@redhat.com> <CAH2r5muV-vC6twZbNQQ3DHoXJTdaUwhzZi7YH+rhxr0BiMseJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAH2r5muV-vC6twZbNQQ3DHoXJTdaUwhzZi7YH+rhxr0BiMseJQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi hi again Steve \o

I do see potential for a ftrace rewrite for the cifs_dbg messages.

But for the original post, I am aiming for a message to be printed
and found in dmesg, helping to correlate and troubleshoot events in
production systems.

So given the debugging nature of ftrace, this is not of help for my
patch request.

So, ACK for v2, using cifs_dbg(VFS) which actually translates to a
pr_warn(), or request a V3 using pr_info() (which I am absolutely fine
with) or...?

Let me know.

I appreciate your time and review!

- RF.

----- Original Message ----- 

> From: "Steve French" <smfrench@gmail.com>
> To: rfreire@redhat.com
> Cc: "LKML" <linux-kernel@vger.kernel.org>, "Steve French"
> <sfrench@samba.org>, "CIFS" <linux-cifs@vger.kernel.org>, "Pavel Shilovsky"
> <piastryyy@gmail.com>
> Sent: Tuesday, October 2, 2018 6:25:46 PM
> Subject: Re: [PATCH v2] CIFS: Print message when attempting a mount

> It is an interesting question - my gut reaction is that messages that
> need more immediate attention should be logged as KERN_ERR (similar to
> cifs_dbg(VFS ...) but given how easy it is now to use dynamic tracing
> and better to read, if a developer would need it ... probably best to
> use ftrace (trace-cmd). Note that xfs has more than 570 (!) dynamic
> trace point callouts now vs. fewer than 30 for xfs_notice
> On Tue, Oct 2, 2018 at 4:20 PM Rodrigo Freire <rfreire@redhat.com> wrote:
> >
> > Hi Steve o/
> >
> > I personally like more a pr_info() instead of a cifs_dbg (which wraps to a
> > pr_warn). But in order to keep in line with the general CIFS coding style
> > I stuck to cifs_dbg
> >
> > But I would happily rewrite the cifs_dbg to pr_info a v3: That would be
> > good enough too.
> >
> > Ah for what is worth my test/target systems are CentOS/Red Hat Enterprise
> > Linux.
> >
> > Thoughts?
> >
> > Thanks!
> >
> > - RF.
> >
> > ----- Original Message -----
> > > From: "Steve French" <smfrench@gmail.com>
> > > To: rfreire@redhat.com
> > > Cc: "LKML" <linux-kernel@vger.kernel.org>, "Steve French"
> > > <sfrench@samba.org>, "CIFS" <linux-cifs@vger.kernel.org>, "Pavel
> > > Shilovsky"
> > > <piastryyy@gmail.com>
> > > Sent: Tuesday, October 2, 2018 5:35:49 PM
> > > Subject: Re: [PATCH v2] CIFS: Print message when attempting a mount
> >
> > > I noticed that on at least the first system I looked at (Ubuntu 18.04)
> > > it defaults to KERN_WARNING (ie 4) so wouldn't have shown a KERN_INFO
> > > which is level 6 (as the mount example from ext4) by default
> > > or the xfs_notice (which is level 5)
> >
> > > https://elinux.org/Debugging_by_printing
> >
> > > On Tue, Oct 2, 2018 at 2:28 PM Rodrigo Freire <rfreire@redhat.com> wrote:
> > > >
> > > > Hi Steve,
> > > >
> > > > ----- Original Message -----
> > > > > From: "Steve French" <smfrench@gmail.com>
> > > > > To: rfreire@redhat.com
> > > > > Cc: "LKML" <linux-kernel@vger.kernel.org>, "Steve French"
> > > > > <sfrench@samba.org>, "CIFS" <linux-cifs@vger.kernel.org>, "Pavel
> > > > > Shilovsky"
> > > > > <piastryyy@gmail.com>
> > > > > Sent: Tuesday, October 2, 2018 4:17:02 PM
> > > > > Subject: Re: [PATCH v2] CIFS: Print message when attempting a mount
> > > > >
> > > > > Are you sure that these aren't logged by the automounter (for ext4,
> > > > > xfs etc.). When I looked in my dmesg logs I didn't find matching log
> > > > > entries in the file systems themselves. Do you have an example?
> > > >
> > > > I'm positive about it. Check it out:
> > > >
> > > > [rfreire@rf ~]$ cd git/upstream/fs/ext4/
> > > > [rfreire@rf ext4]$
> > > > [rfreire@rf ext4]$
> > > > [rfreire@rf ext4]$ grep -r "mounted filesystem with"
> > > > super.c: ext4_msg(sb, KERN_INFO, "mounted filesystem with%s. "
> > > >
> > > >
> > > > [rfreire@rf ext4]$ dmesg | grep mount
> > > > [ 21.550897] EXT4-fs (dm-1): mounted filesystem with ordered data mode.
> > > > Opts: (null)
> > > > [ 22.216213] EXT4-fs (dm-1): re-mounted. Opts: discard
> > > > [ 22.598267] EXT4-fs (sda1): mounted filesystem with ordered data mode.
> > > > Opts: (null)
> > > > [ 22.605225] EXT4-fs (sdc): mounted filesystem without journal. Opts:
> > > > discard
> > > > [ 24.029161] EXT4-fs (dm-2): mounted filesystem with ordered data mode.
> > > > Opts: (null)
> > > > [ 24.047777] EXT4-fs (dm-4): mounted filesystem without journal. Opts:
> > > > (null)
> > > >
> > > > XFS sample dmesg (from
> > > > https://www.reddit.com/r/archlinux/comments/40b9r9/xfs_partition_is_mounted_during_boot_and_then/):
> > > >
> > > > [ 2.764491] XFS (sdb1): Mounting V5 Filesystem
> > > > [ 3.200886] XFS (sdb1): Ending clean mount
> > > > [ 5.384218] XFS (sdb1): Unmounting Filesystem
> > > >
> > > > Relevant code:
> > > >
> > > > [rfreire@rf ~]$ cd ../xfs
> > > >
> > > > [rfreire@rf xfs]$ grep "Mounting V" *.c
> > > > xfs_log.c: xfs_notice(mp, "Mounting V%d Filesystem",
> > > >
> > > >
> > > > > On the idea of adding cifsFYI logging here - I slightly prefer using
> > > > > ftrace (trace-cmd, ie dynamic tracing) so there is less overhead and
> > > > > easier to turn on/off following the example of xfs, f2fs, nfs, nfsd
> > > > > etc.
> > > >
> > > > Remember that cifsFYI already exists; I just moved it inside a if
> > > > clause
> > > > to print it only when running under debug. (they way it is originally).
> > > >
> > > > > On Tue, Oct 2, 2018 at 6:57 AM Rodrigo Freire <rfreire@redhat.com>
> > > > > wrote:
> > > > > >
> > > > > > Currently, no messages are printed when mounting a CIFS filesystem
> > > > > > and
> > > > > > no debug configuration is enabled.
> > > > > >
> > > > > > However, a CIFS mount information is valuable when troubleshooting
> > > > > > and/or forensic analyzing a system and finding out if was a CIFS
> > > > > > endpoint mount attempted.
> > > > > >
> > > > > > Other filesystems such as XFS, EXT* does issue a printk() when
> > > > > > mounting
> > > > > > their filesystems.
> > > >
> > > >
> > > > > --
> > > > > Thanks,
> > > >
> > > > Thank You! o/
> >
> > > --
> > > Thanks,
> >
> > > Steve

> --
> Thanks,

> Steve
