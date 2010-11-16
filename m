From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH] cifs: add attribute cache timeout (actimeo)
 tunable
Date: Tue, 16 Nov 2010 15:22:34 -0500
Message-ID: <20101116152234.71f06a6f@corrin.poochiereds.net>
References: <1289902177-12963-1-git-send-email-sjayaraman@suse.de>
	<20101116140302.6efd2e3d@corrin.poochiereds.net>
	<AANLkTinJhXfjca1ck9Q4xPCcoWyzLv3zNdw=GXXXaAoh@mail.gmail.com>
	<20101116144245.10c63c3c@corrin.poochiereds.net>
	<AANLkTi=ikz9k6jbnOOfQy91omK477xB2eZ3PfNX73eOc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=ikz9k6jbnOOfQy91omK477xB2eZ3PfNX73eOc-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 16 Nov 2010 14:13:52 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Nov 16, 2010 at 1:42 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Tue, 16 Nov 2010 13:25:37 -0600
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Tue, Nov 16, 2010 at 1:03 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
> >> > On Tue, 16 Nov 2010 15:39:37 +0530
> >> > Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
> >> >
> >> >> Currently, the attribute cache timeout for CIFS is 1 sec. This =
means that the
> >> >> client might have to issue a QPATHINFO/QFILEINFO call every 1 s=
ec to verify if
> >> >> something has changed, which seems too expensive. On the otherh=
and, increasing
> >> >> this value further may not work well for all the users.
> >> >>
> >> >> This patch introduces a tunable mount option 'actimeo' that can=
 be used to tune
> >> >> the attribute cache timeout. This patch takes a conservative ap=
proach and sets
> >> >> the default timeout is set to 3 seconds while limiting maximum =
timeout to 60
> >> >> seconds. Ideally, it is preferred to set attribute cache timeou=
ts separately
> >> >> for files and directories like how NFS does. However, I think i=
t is better to
> >> >> keep it simple without too many options, introduce the option t=
o users, get
> >> >> feedback from them and then decide what is working better for C=
IFS.
> >> >>
> >> >> This patch has been tested lightly and no adverse effects were =
seen.
> >> >>
> >> >> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> >> >> ---
> >> >> =A0fs/cifs/cifs_fs_sb.h | =A0 =A01 +
> >> >> =A0fs/cifs/cifsglob.h =A0 | =A0 =A03 +++
> >> >> =A0fs/cifs/connect.c =A0 =A0| =A0 16 ++++++++++++++++
> >> >> =A0fs/cifs/inode.c =A0 =A0 =A0| =A0 =A06 +++---
> >> >> =A04 files changed, 23 insertions(+), 3 deletions(-)
> >> >>
> >> >> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
> >> >> index e9a393c..efd2d73 100644
> >> >> --- a/fs/cifs/cifs_fs_sb.h
> >> >> +++ b/fs/cifs/cifs_fs_sb.h
> >> >> @@ -48,6 +48,7 @@ struct cifs_sb_info {
> >> >> =A0 =A0 =A0 struct nls_table *local_nls;
> >> >> =A0 =A0 =A0 unsigned int rsize;
> >> >> =A0 =A0 =A0 unsigned int wsize;
> >> >> + =A0 =A0 unsigned int actimeo;
> >> >> =A0 =A0 =A0 atomic_t active;
> >> >> =A0 =A0 =A0 uid_t =A0 mnt_uid;
> >> >> =A0 =A0 =A0 gid_t =A0 mnt_gid;
> >> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >> >> index b577bf0..eb22130 100644
> >> >> --- a/fs/cifs/cifsglob.h
> >> >> +++ b/fs/cifs/cifsglob.h
> >> >> @@ -44,6 +44,9 @@
> >> >>
> >> >> =A0#define CIFS_MIN_RCV_POOL 4
> >> >>
> >> >> +#define CIFS_DEF_ACTIMEO (3) /* default attribute cache timeou=
t (seconds) */
> >> >> +#define CIFS_MAX_ACTIMEO (60) =A0 =A0 =A0 =A0/* max allowed at=
tribute cache timeout */
> >> >> +
> >> >> =A0/*
> >> >> =A0 * MAX_REQ is the maximum number of requests that WE will se=
nd
> >> >> =A0 * on one socket concurrently. It also matches the most comm=
on
> >> >> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >> >> index 251a17c..39edc54 100644
> >> >> --- a/fs/cifs/connect.c
> >> >> +++ b/fs/cifs/connect.c
> >> >> @@ -103,6 +103,7 @@ struct smb_vol {
> >> >> =A0 =A0 =A0 bool multiuser:1;
> >> >> =A0 =A0 =A0 unsigned int rsize;
> >> >> =A0 =A0 =A0 unsigned int wsize;
> >> >> + =A0 =A0 unsigned int actimeo; /* attribute cache timeout */
> >> >> =A0 =A0 =A0 bool sockopt_tcp_nodelay:1;
> >> >> =A0 =A0 =A0 unsigned short int port;
> >> >> =A0 =A0 =A0 char *prepath;
> >> >> @@ -1214,6 +1215,10 @@ cifs_parse_mount_options(char *options, =
const char *devname,
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 printk(KERN_WARNING "CIFS: server net"
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 "biosname longer than 15 truncated.\n");
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 } else if (strnicmp(data, "actimeo", =
7) =3D=3D 0) {
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (value && *value)
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->=
actimeo =3D
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 simple_strtoul(value, &value, 0);
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (strnicmp(data, "credenti=
als", 4) =3D=3D 0) {
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* ignore */
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (strnicmp(data, "version"=
, 3) =3D=3D 0) {
> >> >> @@ -2566,6 +2571,17 @@ static void setup_cifs_sb(struct smb_vol=
 *pvolume_info,
> >> >> =A0 =A0 =A0 cFYI(1, "file mode: 0x%x =A0dir mode: 0x%x",
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_file_mode, cifs_sb->mn=
t_dir_mode);
> >> >>
> >> >> + =A0 =A0 if ((pvolume_info->actimeo) &&
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (pvolume_info->actime=
o < CIFS_MAX_ACTIMEO))
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->actimeo =3D pvolume_info->ac=
timeo;
> >> >> + =A0 =A0 else if ((pvolume_info->actimeo) &&
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (pvolume_info->actime=
o >=3D CIFS_MAX_ACTIMEO)) {
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->actimeo =3D CIFS_MAX_ACTIMEO=
;
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "actimeo %d too large, usin=
g %d instead",
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pvolu=
me_info->actimeo, CIFS_MAX_ACTIMEO);
> >> >> + =A0 =A0 } else /* default */
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->actimeo =3D CIFS_DEF_ACTIMEO=
;
> >> >> +
> >> >> =A0 =A0 =A0 if (pvolume_info->noperm)
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags |=3D CIFS_M=
OUNT_NO_PERM;
> >> >> =A0 =A0 =A0 if (pvolume_info->setuids)
> >> >> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> >> >> index ff7d299..f30700d 100644
> >> >> --- a/fs/cifs/inode.c
> >> >> +++ b/fs/cifs/inode.c
> >> >> @@ -1648,6 +1648,7 @@ static bool
> >> >> =A0cifs_inode_needs_reval(struct inode *inode)
> >> >> =A0{
> >> >> =A0 =A0 =A0 struct cifsInodeInfo *cifs_i =3D CIFS_I(inode);
> >> >> + =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb)=
;
> >> >>
> >> >> =A0 =A0 =A0 if (cifs_i->clientCanCacheRead)
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return false;
> >> >> @@ -1658,12 +1659,11 @@ cifs_inode_needs_reval(struct inode *in=
ode)
> >> >> =A0 =A0 =A0 if (cifs_i->time =3D=3D 0)
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return true;
> >> >>
> >> >> - =A0 =A0 /* FIXME: the actimeo should be tunable */
> >> >> - =A0 =A0 if (time_after_eq(jiffies, cifs_i->time + HZ))
> >> >> + =A0 =A0 if (time_after_eq(jiffies, cifs_i->time + (cifs_sb->a=
ctimeo * HZ)))
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return true;
> >> >>
> >> >> =A0 =A0 =A0 /* hardlinked files w/ noserverino get "special" tr=
eatment */
> >> >> - =A0 =A0 if (!(CIFS_SB(inode->i_sb)->mnt_cifs_flags & CIFS_MOU=
NT_SERVER_INUM) &&
> >> >> + =A0 =A0 if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INU=
M) &&
> >> >> =A0 =A0 =A0 =A0 =A0 S_ISREG(inode->i_mode) && inode->i_nlink !=3D=
 1)
> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return true;
> >> >>
> >> >
> >> > I too think that the 1s actimeo is too aggressive in general, bu=
t I'm a
> >> > little leery that changing the default here might mean subtle
> >> > regressions. Cache consistency is really hard to get right, so w=
e need
> >> > to take great care when we change its behavior.
> >> >
> >> > What do you think about respinning this patch and leaving the de=
fault
> >> > at 1s? We could consider increasing it later if we can prove to
> >> > ourselves that it won't cause problems.
> >>
> >> This patch could be helpful.
> >>
> >> Yes.
> >>
> >> Also probably should allow maximum that is longer than 60 seconds
> >> timeout (perhaps an hour? a day?).
> >>
> >> IIRC there is no maximum specified for DirectoryCacheTimeout in
> >> Windows - and there are cases where I can imagine longer than 60
> >> seconds being useful.
> >>
> >>
> >>
> >
> > Agreed. I don't see any reason not to allow someone to shoot themse=
lves
> > in the foot. I see no need for an arbitrary limit. If you do that
> > though, you probably do want to limit it to 2^31 jiffies or so to a=
void
> > wraparound issues on 32 bit arches.
> >
> > It also wouldn't hurt to store the value internally in terms of
> > jiffies. You should also update the function that displays options
> > in /proc/mounts to show this value too.
>=20
> Yes - might as well.  1 second is a very long time in today's world .=
=2E.
>=20
> So if we default to equivalent of 1 second (in jiffies), max would be
> 2^31 jiffies ie about 100 days - which should be long enough for most
> people :)
>=20
>=20

2^31 jiffies / 1000 jiffies/s / 86400 s/day =3D 24.85513481481481481481

So I calculate 25 days or so...but it depends on what HZ is set to on
your machine really...
--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
