From: Steve French <smfrench@gmail.com>
Subject: Re: config files and how to have persistent Linux kernel Driver/File
 System configuration info saved
Date: Fri, 29 Jun 2018 14:53:22 -0500
Message-ID: <CAH2r5ms3zp8s48FcPYCPJRZCR9mq=XMc=qOUG8N85jNpL1VRwA@mail.gmail.com>
References: <CAH2r5msV1hBAGgqtMFh6P=OGPV3RKjVAER=5bg-6Y+vW5BEJwQ@mail.gmail.com>
 <20180628225857.GB1231@thunk.org> <CAN05THStuq+RLzb_oNiD2TvN6MjMMnTdCxNiHuYWHRueQ46=_A@mail.gmail.com>
 <CAH2r5mui9WLBC6ne+iqVeYDGKEMKTabHPTf57STM9_aPGfM0sA@mail.gmail.com> <20180629044440.GK19934@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: ronnie sahlberg <ronniesahlberg@gmail.com>,
        Theodore Tso <tytso@mit.edu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180629044440.GK19934@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, Jun 28, 2018 at 11:44 PM Dave Chinner <david@fromorbit.com> wrote:
>
> On Thu, Jun 28, 2018 at 06:24:59PM -0500, Steve French wrote:
> > On Thu, Jun 28, 2018 at 6:21 PM ronnie sahlberg
> > <ronniesahlberg@gmail.com> wrote:
> > >
> > > On Fri, Jun 29, 2018 at 8:58 AM, Theodore Y. Ts'o via samba-technical
> > > <samba-technical@lists.samba.org> wrote:
> > > > On Thu, Jun 28, 2018 at 05:37:15PM -0500, Steve French wrote:
> > > >> Ronnie brought up an interesting point about the problems consistently
> > > >> configuring file systems (or any Linux module for that matter) so that
> > > >> reboot doesn't wipe away security or performance tuning changes.
> > > >
> > > > In general it's considered best practice to make the file system
> > > > auto-tune itself as much as possible, because the sad fact is that
> > > > 99.9999% of the customers aren't going to bother to add any tuning
> > > > parameters.  So there hasn't been a push to try to create something
> > > > more complex, because it's generally not needed.
> > >
> > > True, but in these cases I think we are more looking at server or
> > > mountpoint specific options than
> > > actual fs tuning.
> > >
> > > For example nfsmount.conf can be used to say "only use NFSv4 when
> > > accessing server abc" etc.
> > > For the case of CIFS I could imagine that an administrator might want
> > > to set "disable smb1 protocol globally"
> >
> > Or perhaps
> >   "disable smb1 on " ... various public networks but allow it on
> > private networks
>
> The way the policy is configured depends on the mechanism used to
> configure the policy. If it's a sysctl or a mount option, then we've
> already got everything we need. If it's something dynamic in sysfs,
> then I think you're on your own.
>
> FYI, I have been looking at making sysctl be able to work on /sys
> rather than just /proc/sys (I have a 10 line hack to enable it) so
> we could re-use it with custom per-mount ...
<snip>
> So, really, I'm probably just going roll our own sysfs config file
> mechanism into xfs_spaceman (probably based on the new config file
> parser we have for mkfs.xfs) and hide the mess with a nice, simple
> xfs_admin interface for udev to call. i.e. roll our own :)

Since we don't really have a registry, or equivalent (unless Samba is
installed),
probably will have to do something like that for other file systems too :)
Am now thinking that we need an "smb3_admin" (or "cifs_admin") tool,
ala Samba's "net" (especially "net  conf setparm <section> <parameter> <value>")
because it makes it possible to configure the ultra-confusing /etc config files
and /proc and /sys config pseudo files more sanely and less error prone.



-- 
Thanks,

Steve
