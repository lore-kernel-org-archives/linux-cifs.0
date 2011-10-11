From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5] cifs: allow for larger rsize= options and change
 defaults
Date: Tue, 11 Oct 2011 06:20:24 -0400
Message-ID: <20111011062024.39f8ada8@tlielax.poochiereds.net>
References: <1315319241-21637-1-git-send-email-jlayton@redhat.com>
	<1315319241-21637-5-git-send-email-jlayton@redhat.com>
	<CAKywueTHW1mR1gpO27Kxhxuy++bpMu4R8V=inr4-+gtDWa3ceQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueTHW1mR1gpO27Kxhxuy++bpMu4R8V=inr4-+gtDWa3ceQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 11 Oct 2011 13:17:20 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2011/9/6 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > Currently we cap the rsize at a value that fits in CIFSMaxBufSize. =
That's
> > not needed any longer for readpages. Allow the use of larger values=
 for
> > readpages. cifs_iovec_read and cifs_read however are still limited =
to the
> > CIFSMaxBufSize. Make sure they don't exceed that.
> >
> > The patch also changes the rsize defaults. The default when unix
> > extensions are enabled is set to 1M for parity with the wsize, and =
there
> > is a hard cap of ~16M.
> >
> > When unix extensions are not enabled, the default is set to 60k. Ac=
cording
> > to MS-CIFS, Windows servers can only send a max of 60k at a time, s=
o
> > this is more efficient than requesting a larger size. If the user w=
ishes
> > however, the max can be extended up to 128k - the length of the REA=
D_RSP
> > header.
> >
> > Really old servers however require a special hack to ensure that we=
 don't
> > request too large a read.
> >
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> > =C2=A0fs/cifs/connect.c | =C2=A0118 +++++++++++++++++++++++++++++++=
+---------------------
> > =C2=A0fs/cifs/file.c =C2=A0 =C2=A0| =C2=A0 12 +++++-
> > =C2=A02 files changed, 82 insertions(+), 48 deletions(-)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 6f663ea..02bc0e2 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -2292,16 +2292,16 @@ compare_mount_options(struct super_block *s=
b, struct cifs_mnt_data *mnt_data)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(new->mnt_cifs_flags & CIF=
S_MOUNT_MASK))
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> >
> > - =C2=A0 =C2=A0 =C2=A0 if (old->rsize !=3D new->rsize)
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> > -
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0* We want to share sb only if we don't=
 specify wsize or specified wsize
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0* is greater or equal than existing on=
e.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* We want to share sb only if we don't=
 specify an r/wsize or
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* specified r/wsize is greater than or=
 equal to existing one.
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (new->wsize && new->wsize < old->wsiz=
e)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> >
> > + =C2=A0 =C2=A0 =C2=A0 if (new->rsize && new->rsize < old->rsize)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> > +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (old->mnt_uid !=3D new->mnt_uid || ol=
d->mnt_gid !=3D new->mnt_gid)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> >
> > @@ -2739,14 +2739,6 @@ void reset_cifs_unix_caps(int xid, struct ci=
fs_tcon *tcon,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0C=
IFS_MOUNT_POSIX_PATHS;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (cifs_sb && (=
cifs_sb->rsize > 127 * 1024)) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if ((cap & CIFS_UNIX_LARGE_READ_CAP) =3D=3D 0) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_sb->rsize =3D 127 * 1024;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(DBG2, "larger reads not sup=
ported by srv");
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > -
> > -
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cFYI(1, "Neg=
otiate caps 0x%x", (int)cap);
> > =C2=A0#ifdef CONFIG_CIFS_DEBUG2
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (cap & CI=
=46S_UNIX_FCNTL_CAP)
> > @@ -2791,27 +2783,11 @@ void cifs_setup_cifs_sb(struct smb_vol *pvo=
lume_info,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock_init(&cifs_sb->tlink_tree_lock=
);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0cifs_sb->tlink_tree =3D RB_ROOT;
> >
> > - =C2=A0 =C2=A0 =C2=A0 if (pvolume_info->rsize > CIFSMaxBufSize) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cERROR(1, "rsize=
 %d too large, using MaxBufSize",
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 pvolume_info->rsize);
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_sb->rsize =3D=
 CIFSMaxBufSize;
> > - =C2=A0 =C2=A0 =C2=A0 } else if ((pvolume_info->rsize) &&
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 (pvolume_info->rsize <=3D CIFSMaxBufSize))
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_sb->rsize =3D=
 pvolume_info->rsize;
> > - =C2=A0 =C2=A0 =C2=A0 else /* default */
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_sb->rsize =3D=
 CIFSMaxBufSize;
> > -
> > - =C2=A0 =C2=A0 =C2=A0 if (cifs_sb->rsize < 2048) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_sb->rsize =3D=
 2048;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Windows ME ma=
y prefer this */
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "readsiz=
e set to minimum: 2048");
> > - =C2=A0 =C2=A0 =C2=A0 }
> > -
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/*
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0* Temporarily set wsize for matching s=
uperblock. If we end up using
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0* new sb then cifs_negotiate_wsize wil=
l later negotiate it downward
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0* if needed.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* Temporarily set r/wsize for matching=
 superblock. If we end up using
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* new sb then client will later negoti=
ate it downward if needed.
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> > + =C2=A0 =C2=A0 =C2=A0 cifs_sb->rsize =3D pvolume_info->rsize;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0cifs_sb->wsize =3D pvolume_info->wsize;
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0cifs_sb->mnt_uid =3D pvolume_info->linux=
_uid;
> > @@ -2878,29 +2854,41 @@ void cifs_setup_cifs_sb(struct smb_vol *pvo=
lume_info,
> > =C2=A0}
> >
> > =C2=A0/*
> > - * When the server supports very large writes via POSIX extensions=
, we can
> > - * allow up to 2^24-1, minus the size of a WRITE_AND_X header, not=
 including
> > - * the RFC1001 length.
> > + * When the server supports very large reads and writes via POSIX =
extensions,
> > + * we can allow up to 2^24-1, minus the size of a READ/WRITE_AND_X=
 header, not
> > + * including the RFC1001 length.
> > =C2=A0*
> > =C2=A0* Note that this might make for "interesting" allocation prob=
lems during
> > =C2=A0* writeback however as we have to allocate an array of pointe=
rs for the
> > =C2=A0* pages. A 16M write means ~32kb page array with PAGE_CACHE_S=
IZE =3D=3D 4096.
> > + *
> > + * For reads, there is a similar problem as we need to allocate an=
 array
> > + * of kvecs to handle the receive, though that should only need to=
 be done
> > + * once.
> > =C2=A0*/
> > =C2=A0#define CIFS_MAX_WSIZE ((1<<24) - 1 - sizeof(WRITE_REQ) + 4)
> > +#define CIFS_MAX_RSIZE ((1<<24) - sizeof(READ_RSP) + 4)
>=20
> May be (1<<24) - 1 for rsize too as it is for wsize?

The '- 1' here is to account for the bogus "Pad" field in the
WRITE_REQ. READ_RSP doesn't have that due to patch #1 in this series.

> >
> > =C2=A0/*
> > - * When the server doesn't allow large posix writes, only allow a =
wsize of
> > - * 128k minus the size of the WRITE_AND_X header. That allows for =
a write up
> > + * When the server doesn't allow large posix writes, only allow a =
rsize/wsize of
> > + * 128k minus the size of the call header. That allows for a read =
or write up
> > =C2=A0* to the maximum size described by RFC1002.
> > =C2=A0*/
> > =C2=A0#define CIFS_MAX_RFC1002_WSIZE (128 * 1024 - sizeof(WRITE_REQ=
) + 4)
> > +#define CIFS_MAX_RFC1002_RSIZE (128 * 1024 - sizeof(READ_RSP) + 4)
>=20
> The same issue I reported about for the write. But as it's disable fo=
r
> iovec_read it should be hit - anyway, better to fix this.
>=20

Agreed. I can respin this.

> >
> > =C2=A0/*
> > =C2=A0* The default wsize is 1M. find_get_pages seems to return a m=
aximum of 256
> > =C2=A0* pages in a single call. With PAGE_CACHE_SIZE =3D=3D 4k, thi=
s means we can fill
> > =C2=A0* a single wsize request with a single call.
> > =C2=A0*/
> > -#define CIFS_DEFAULT_WSIZE (1024 * 1024)
> > +#define CIFS_DEFAULT_IOSIZE (1024 * 1024)
> > +
> > +/*
> > + * Windows only supports a max of 60k reads. Default to that when =
posix
> > + * extensions aren't in force.
> > + */
> > +#define CIFS_DEFAULT_NON_POSIX_RSIZE (60 *1024)
> >
> > =C2=A0static unsigned int
> > =C2=A0cifs_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *=
pvolume_info)
> > @@ -2908,7 +2896,7 @@ cifs_negotiate_wsize(struct cifs_tcon *tcon, =
struct smb_vol *pvolume_info)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0__u64 unix_cap =3D le64_to_cpu(tcon->fsU=
nixInfo.Capability);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct TCP_Server_Info *server =3D tcon-=
>ses->server;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int wsize =3D pvolume_info->wsi=
ze ? pvolume_info->wsize :
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CIFS_DEFAULT_WSIZE;
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CIFS_DEFAULT_IOSIZE;
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* can server support 24-bit write sizes=
? (via UNIX extensions) */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!tcon->unix_ext || !(unix_cap & CIFS=
_UNIX_LARGE_WRITE_CAP))
> > @@ -2931,6 +2919,50 @@ cifs_negotiate_wsize(struct cifs_tcon *tcon,=
 struct smb_vol *pvolume_info)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0return wsize;
> > =C2=A0}
> >
> > +static unsigned int
> > +cifs_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *pvolu=
me_info)
> > +{
> > + =C2=A0 =C2=A0 =C2=A0 __u64 unix_cap =3D le64_to_cpu(tcon->fsUnixI=
nfo.Capability);
> > + =C2=A0 =C2=A0 =C2=A0 struct TCP_Server_Info *server =3D tcon->ses=
->server;
> > + =C2=A0 =C2=A0 =C2=A0 unsigned int rsize, defsize;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 /*
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* Set default value...
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0*
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* HACK alert! Ancient servers have ver=
y small buffers. Even though
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* MS-CIFS indicates that servers are o=
nly limited by the client's
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* bufsize for reads, testing against w=
in98se shows that it throws
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* INVALID_PARAMETER errors if you try =
to request too large a read.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0*
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* If the server advertises a MaxBuffer=
Size of less than one page,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* assume that it also can't satisfy re=
ads larger than that either.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0*
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* FIXME: Is there a better heuristic f=
or this?
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> > + =C2=A0 =C2=A0 =C2=A0 if (tcon->unix_ext && (unix_cap & CIFS_UNIX_=
LARGE_READ_CAP))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 defsize =3D CIFS=
_DEFAULT_IOSIZE;
> > + =C2=A0 =C2=A0 =C2=A0 else if (server->capabilities & CAP_LARGE_RE=
AD_X)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 defsize =3D CIFS=
_DEFAULT_NON_POSIX_RSIZE;
> > + =C2=A0 =C2=A0 =C2=A0 else if (server->maxBuf >=3D PAGE_CACHE_SIZE=
)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 defsize =3D CIFS=
MaxBufSize;
> > + =C2=A0 =C2=A0 =C2=A0 else
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 defsize =3D serv=
er->maxBuf - sizeof(READ_RSP);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 rsize =3D pvolume_info->rsize ? pvolume_info=
->rsize : defsize;
> > +
> > + =C2=A0 =C2=A0 =C2=A0 /*
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* no CAP_LARGE_READ_X? Then MS-CIFS st=
ates that we must limit this to
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0* the client's MaxBufferSize.
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> > + =C2=A0 =C2=A0 =C2=A0 if (!(server->capabilities & CAP_LARGE_READ_=
X))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rsize =3D min_t(=
unsigned int, CIFSMaxBufSize, rsize);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 /* hard limit of CIFS_MAX_RSIZE */
> > + =C2=A0 =C2=A0 =C2=A0 rsize =3D min_t(unsigned int, rsize, CIFS_MA=
X_RSIZE);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 return rsize;
> > +}
> > +
> > =C2=A0static int
> > =C2=A0is_path_accessible(int xid, struct cifs_tcon *tcon,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 stru=
ct cifs_sb_info *cifs_sb, const char *full_path)
> > @@ -3208,14 +3240,8 @@ try_mount_again:
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CIFSSMBQFSAt=
tributeInfo(xid, tcon);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0}
> >
> > - =C2=A0 =C2=A0 =C2=A0 if ((tcon->unix_ext =3D=3D 0) && (cifs_sb->r=
size > (1024 * 127))) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_sb->rsize =3D=
 1024 * 127;
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(DBG2, "no v=
ery large read support, rsize now 127K");
> > - =C2=A0 =C2=A0 =C2=A0 }
> > - =C2=A0 =C2=A0 =C2=A0 if (!(tcon->ses->capabilities & CAP_LARGE_RE=
AD_X))
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_sb->rsize =3D=
 min(cifs_sb->rsize, CIFSMaxBufSize);
> > -
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0cifs_sb->wsize =3D cifs_negotiate_wsize(=
tcon, volume_info);
> > + =C2=A0 =C2=A0 =C2=A0 cifs_sb->rsize =3D cifs_negotiate_rsize(tcon=
, volume_info);
> >
> > =C2=A0remote_path_check:
> > =C2=A0#ifdef CONFIG_CIFS_DFS_UPCALL
> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > index ba3ef1b..a855ff1 100644
> > --- a/fs/cifs/file.c
> > +++ b/fs/cifs/file.c
> > @@ -1715,6 +1715,7 @@ cifs_iovec_read(struct file *file, const stru=
ct iovec *iov,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct smb_com_read_rsp *pSMBr;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct cifs_io_parms io_parms;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0char *read_data;
> > + =C2=A0 =C2=A0 =C2=A0 unsigned int rsize;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0__u32 pid;
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!nr_segs)
> > @@ -1727,6 +1728,9 @@ cifs_iovec_read(struct file *file, const stru=
ct iovec *iov,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0xid =3D GetXid();
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0cifs_sb =3D CIFS_SB(file->f_path.dentry-=
>d_sb);
> >
> > + =C2=A0 =C2=A0 =C2=A0 /* FIXME: set up handlers for larger reads a=
nd/or convert to async */
> > + =C2=A0 =C2=A0 =C2=A0 rsize =3D min_t(unsigned int, cifs_sb->rsize=
, CIFSMaxBufSize);
> > +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0open_file =3D file->private_data;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0pTcon =3D tlink_tcon(open_file->tlink);
> >
> > @@ -1739,7 +1743,7 @@ cifs_iovec_read(struct file *file, const stru=
ct iovec *iov,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cFYI(1, "att=
empting read on write only file instance");
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0for (total_read =3D 0; total_read < len;=
 total_read +=3D bytes_read) {
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cur_len =3D min_=
t(const size_t, len - total_read, cifs_sb->rsize);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cur_len =3D min_=
t(const size_t, len - total_read, rsize);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D -EAGA=
IN;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0read_data =3D=
 NULL;
> >
> > @@ -1831,6 +1835,7 @@ static ssize_t cifs_read(struct file *file, c=
har *read_data, size_t read_size,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int bytes_read =3D 0;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int total_read;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned int current_read_size;
> > + =C2=A0 =C2=A0 =C2=A0 unsigned int rsize;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct cifs_sb_info *cifs_sb;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0struct cifs_tcon *pTcon;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0int xid;
> > @@ -1843,6 +1848,9 @@ static ssize_t cifs_read(struct file *file, c=
har *read_data, size_t read_size,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0xid =3D GetXid();
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0cifs_sb =3D CIFS_SB(file->f_path.dentry-=
>d_sb);
> >
> > + =C2=A0 =C2=A0 =C2=A0 /* FIXME: set up handlers for larger reads a=
nd/or convert to async */
> > + =C2=A0 =C2=A0 =C2=A0 rsize =3D min_t(unsigned int, cifs_sb->rsize=
, CIFSMaxBufSize);
> > +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (file->private_data =3D=3D NULL) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D -EBAD=
=46;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FreeXid(xid)=
;
> > @@ -1863,7 +1871,7 @@ static ssize_t cifs_read(struct file *file, c=
har *read_data, size_t read_size,
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 read_size > total_read;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 total_read +=3D bytes_rea=
d, current_offset +=3D bytes_read) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0current_read=
_size =3D min_t(const int, read_size - total_read,
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 cifs_sb->rsize);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 rsize);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* For windo=
ws me and 9x we do not want to request more
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0than it nego=
tiated since it will refuse the read then */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((pTcon->=
ses) &&
> > --
> > 1.7.6
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
> >
>=20
>=20
>=20


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
