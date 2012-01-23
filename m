From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 50/50] CIFS: Change Makefile to support CONFIG_CIFS_SMB2
Date: Mon, 23 Jan 2012 09:34:36 -0600
Message-ID: <CAH2r5mug39QJGADRv1cyb-QgtZN56Gx8sWRTpHeWWYNAYihNOQ@mail.gmail.com>
References: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
	<1327048511-2342-50-git-send-email-piastry@etersoft.ru>
	<20120123063634.4aa95a1d@tlielax.poochiereds.net>
	<CAKywueQ1CZ-dt6xvuJi9jk=N+XGPo6bYLbvMwjHWkNCaucrvOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQ1CZ-dt6xvuJi9jk=N+XGPo6bYLbvMwjHWkNCaucrvOg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Jan 23, 2012 at 7:40 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> =
wrote:
>
> 2012/1/23 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > On Fri, 20 Jan 2012 12:35:11 +0400
> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >
> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >> ---
> >> =A0fs/cifs/Makefile | =A0 =A04 ++++
> >> =A01 files changed, 4 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
> >> index 005d524..0f72f14 100644
> >> --- a/fs/cifs/Makefile
> >> +++ b/fs/cifs/Makefile
> >> @@ -15,3 +15,7 @@ cifs-$(CONFIG_CIFS_UPCALL) +=3D cifs_spnego.o
> >> =A0cifs-$(CONFIG_CIFS_DFS_UPCALL) +=3D dns_resolve.o cifs_dfs_ref.=
o
> >>
> >> =A0cifs-$(CONFIG_CIFS_FSCACHE) +=3D fscache.o cache.o
> >> +
> >> +cifs-$(CONFIG_CIFS_SMB2) +=3D smb2pdu.o smb2misc.o smb2transport.=
o maperror.o \
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb2inode.o smb2=
dir.o smb2file.o smb2readdir.o \
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb2link.o
> >
> >
> > I'm a bit concerned about the order of the patches. The idea here
> > seems to be: "merge all of the code needed to support SMB2 with it
> > disabled, and then flip a switch to turn it all on". Experience has
> > shown that that strategy of merging large scale changes tends to be
> > problematic.
> >
> > Bugs that creep in, but because the "switch" is in the last few pat=
ches
> > we can't bisect to narrow down the cause. What might be better is t=
o
> > move the last few patches earlier in the series. That would allow
> > someone to mount a SMB2 filesystem, even if some things on it don't
> > actually work yet.
> >
> > If, for instance, an oops creeps in and we're not sure what's causi=
ng
> > it, we could bisect down to an earlier patch and narrow down the am=
ount
> > of changes that we'll need to look at.
> >
> > --
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> I agree with you. The only reason why 48,49 and 50 patches are going
> at last is that: they have been already merged in mainline before but
> then reverted back here
> http://comments.gmane.org/gmane.linux.kernel.cifs/3315.
>
> If nobody objects, I suggest them to be merged after the 01/50 patch
> (that doesn't not include any CONFIG_CIFS_SMB2 ifdefs).

Sounds fine



--
Thanks,

Steve
