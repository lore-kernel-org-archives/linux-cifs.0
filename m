From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/5] cifs: allow for larger rsize= options and change defaults
Date: Tue, 11 Oct 2011 13:17:20 +0400
Message-ID: <CAKywueTHW1mR1gpO27Kxhxuy++bpMu4R8V=inr4-+gtDWa3ceQ@mail.gmail.com>
References: <1315319241-21637-1-git-send-email-jlayton@redhat.com>
	<1315319241-21637-5-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1315319241-21637-5-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/9/6 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Currently we cap the rsize at a value that fits in CIFSMaxBufSize. Th=
at's
> not needed any longer for readpages. Allow the use of larger values f=
or
> readpages. cifs_iovec_read and cifs_read however are still limited to=
 the
> CIFSMaxBufSize. Make sure they don't exceed that.
>
> The patch also changes the rsize defaults. The default when unix
> extensions are enabled is set to 1M for parity with the wsize, and th=
ere
> is a hard cap of ~16M.
>
> When unix extensions are not enabled, the default is set to 60k. Acco=
rding
> to MS-CIFS, Windows servers can only send a max of 60k at a time, so
> this is more efficient than requesting a larger size. If the user wis=
hes
> however, the max can be extended up to 128k - the length of the READ_=
RSP
> header.
>
> Really old servers however require a special hack to ensure that we d=
on't
> request too large a read.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0118 ++++++++++++++++++++++++++++++++-------=
--------------
> =A0fs/cifs/file.c =A0 =A0| =A0 12 +++++-
> =A02 files changed, 82 insertions(+), 48 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 6f663ea..02bc0e2 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2292,16 +2292,16 @@ compare_mount_options(struct super_block *sb,=
 struct cifs_mnt_data *mnt_data)
> =A0 =A0 =A0 =A0 =A0 =A0(new->mnt_cifs_flags & CIFS_MOUNT_MASK))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
>
> - =A0 =A0 =A0 if (old->rsize !=3D new->rsize)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> -
> =A0 =A0 =A0 =A0/*
> - =A0 =A0 =A0 =A0* We want to share sb only if we don't specify wsize=
 or specified wsize
> - =A0 =A0 =A0 =A0* is greater or equal than existing one.
> + =A0 =A0 =A0 =A0* We want to share sb only if we don't specify an r/=
wsize or
> + =A0 =A0 =A0 =A0* specified r/wsize is greater than or equal to exis=
ting one.
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0if (new->wsize && new->wsize < old->wsize)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
>
> + =A0 =A0 =A0 if (new->rsize && new->rsize < old->rsize)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> +
> =A0 =A0 =A0 =A0if (old->mnt_uid !=3D new->mnt_uid || old->mnt_gid !=3D=
 new->mnt_gid)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
>
> @@ -2739,14 +2739,6 @@ void reset_cifs_unix_caps(int xid, struct cifs=
_tcon *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0CIFS_MOUNT_POSIX_PATHS;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cifs_sb && (cifs_sb->rsize > 127 * =
1024)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((cap & CIFS_UNIX_LA=
RGE_READ_CAP) =3D=3D 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb=
->rsize =3D 127 * 1024;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(DB=
G2, "larger reads not supported by srv");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> -
> -
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Negotiate caps 0x%x", (int)ca=
p);
> =A0#ifdef CONFIG_CIFS_DEBUG2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (cap & CIFS_UNIX_FCNTL_CAP)
> @@ -2791,27 +2783,11 @@ void cifs_setup_cifs_sb(struct smb_vol *pvolu=
me_info,
> =A0 =A0 =A0 =A0spin_lock_init(&cifs_sb->tlink_tree_lock);
> =A0 =A0 =A0 =A0cifs_sb->tlink_tree =3D RB_ROOT;
>
> - =A0 =A0 =A0 if (pvolume_info->rsize > CIFSMaxBufSize) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "rsize %d too large, using Ma=
xBufSize",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pvolume_info->rsize);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->rsize =3D CIFSMaxBufSize;
> - =A0 =A0 =A0 } else if ((pvolume_info->rsize) &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (pvolume_info->rsize <=3D=
 CIFSMaxBufSize))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->rsize =3D pvolume_info->rsize;
> - =A0 =A0 =A0 else /* default */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->rsize =3D CIFSMaxBufSize;
> -
> - =A0 =A0 =A0 if (cifs_sb->rsize < 2048) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->rsize =3D 2048;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Windows ME may prefer this */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "readsize set to minimum: 2048"=
);
> - =A0 =A0 =A0 }
> -
> =A0 =A0 =A0 =A0/*
> - =A0 =A0 =A0 =A0* Temporarily set wsize for matching superblock. If =
we end up using
> - =A0 =A0 =A0 =A0* new sb then cifs_negotiate_wsize will later negoti=
ate it downward
> - =A0 =A0 =A0 =A0* if needed.
> + =A0 =A0 =A0 =A0* Temporarily set r/wsize for matching superblock. I=
f we end up using
> + =A0 =A0 =A0 =A0* new sb then client will later negotiate it downwar=
d if needed.
> =A0 =A0 =A0 =A0 */
> + =A0 =A0 =A0 cifs_sb->rsize =3D pvolume_info->rsize;
> =A0 =A0 =A0 =A0cifs_sb->wsize =3D pvolume_info->wsize;
>
> =A0 =A0 =A0 =A0cifs_sb->mnt_uid =3D pvolume_info->linux_uid;
> @@ -2878,29 +2854,41 @@ void cifs_setup_cifs_sb(struct smb_vol *pvolu=
me_info,
> =A0}
>
> =A0/*
> - * When the server supports very large writes via POSIX extensions, =
we can
> - * allow up to 2^24-1, minus the size of a WRITE_AND_X header, not i=
ncluding
> - * the RFC1001 length.
> + * When the server supports very large reads and writes via POSIX ex=
tensions,
> + * we can allow up to 2^24-1, minus the size of a READ/WRITE_AND_X h=
eader, not
> + * including the RFC1001 length.
> =A0*
> =A0* Note that this might make for "interesting" allocation problems =
during
> =A0* writeback however as we have to allocate an array of pointers fo=
r the
> =A0* pages. A 16M write means ~32kb page array with PAGE_CACHE_SIZE =3D=
=3D 4096.
> + *
> + * For reads, there is a similar problem as we need to allocate an a=
rray
> + * of kvecs to handle the receive, though that should only need to b=
e done
> + * once.
> =A0*/
> =A0#define CIFS_MAX_WSIZE ((1<<24) - 1 - sizeof(WRITE_REQ) + 4)
> +#define CIFS_MAX_RSIZE ((1<<24) - sizeof(READ_RSP) + 4)

May be (1<<24) - 1 for rsize too as it is for wsize?
>
> =A0/*
> - * When the server doesn't allow large posix writes, only allow a ws=
ize of
> - * 128k minus the size of the WRITE_AND_X header. That allows for a =
write up
> + * When the server doesn't allow large posix writes, only allow a rs=
ize/wsize of
> + * 128k minus the size of the call header. That allows for a read or=
 write up
> =A0* to the maximum size described by RFC1002.
> =A0*/
> =A0#define CIFS_MAX_RFC1002_WSIZE (128 * 1024 - sizeof(WRITE_REQ) + 4=
)
> +#define CIFS_MAX_RFC1002_RSIZE (128 * 1024 - sizeof(READ_RSP) + 4)

The same issue I reported about for the write. But as it's disable for
iovec_read it should be hit - anyway, better to fix this.

>
> =A0/*
> =A0* The default wsize is 1M. find_get_pages seems to return a maximu=
m of 256
> =A0* pages in a single call. With PAGE_CACHE_SIZE =3D=3D 4k, this mea=
ns we can fill
> =A0* a single wsize request with a single call.
> =A0*/
> -#define CIFS_DEFAULT_WSIZE (1024 * 1024)
> +#define CIFS_DEFAULT_IOSIZE (1024 * 1024)
> +
> +/*
> + * Windows only supports a max of 60k reads. Default to that when po=
six
> + * extensions aren't in force.
> + */
> +#define CIFS_DEFAULT_NON_POSIX_RSIZE (60 *1024)
>
> =A0static unsigned int
> =A0cifs_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *pvolu=
me_info)
> @@ -2908,7 +2896,7 @@ cifs_negotiate_wsize(struct cifs_tcon *tcon, st=
ruct smb_vol *pvolume_info)
> =A0 =A0 =A0 =A0__u64 unix_cap =3D le64_to_cpu(tcon->fsUnixInfo.Capabi=
lity);
> =A0 =A0 =A0 =A0struct TCP_Server_Info *server =3D tcon->ses->server;
> =A0 =A0 =A0 =A0unsigned int wsize =3D pvolume_info->wsize ? pvolume_i=
nfo->wsize :
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_DE=
=46AULT_WSIZE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_DE=
=46AULT_IOSIZE;
>
> =A0 =A0 =A0 =A0/* can server support 24-bit write sizes? (via UNIX ex=
tensions) */
> =A0 =A0 =A0 =A0if (!tcon->unix_ext || !(unix_cap & CIFS_UNIX_LARGE_WR=
ITE_CAP))
> @@ -2931,6 +2919,50 @@ cifs_negotiate_wsize(struct cifs_tcon *tcon, s=
truct smb_vol *pvolume_info)
> =A0 =A0 =A0 =A0return wsize;
> =A0}
>
> +static unsigned int
> +cifs_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *pvolume=
_info)
> +{
> + =A0 =A0 =A0 __u64 unix_cap =3D le64_to_cpu(tcon->fsUnixInfo.Capabil=
ity);
> + =A0 =A0 =A0 struct TCP_Server_Info *server =3D tcon->ses->server;
> + =A0 =A0 =A0 unsigned int rsize, defsize;
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Set default value...
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* HACK alert! Ancient servers have very small buffer=
s. Even though
> + =A0 =A0 =A0 =A0* MS-CIFS indicates that servers are only limited by=
 the client's
> + =A0 =A0 =A0 =A0* bufsize for reads, testing against win98se shows t=
hat it throws
> + =A0 =A0 =A0 =A0* INVALID_PARAMETER errors if you try to request too=
 large a read.
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* If the server advertises a MaxBufferSize of less t=
han one page,
> + =A0 =A0 =A0 =A0* assume that it also can't satisfy reads larger tha=
n that either.
> + =A0 =A0 =A0 =A0*
> + =A0 =A0 =A0 =A0* FIXME: Is there a better heuristic for this?
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (tcon->unix_ext && (unix_cap & CIFS_UNIX_LARGE_READ_=
CAP))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 defsize =3D CIFS_DEFAULT_IOSIZE;
> + =A0 =A0 =A0 else if (server->capabilities & CAP_LARGE_READ_X)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 defsize =3D CIFS_DEFAULT_NON_POSIX_RSIZ=
E;
> + =A0 =A0 =A0 else if (server->maxBuf >=3D PAGE_CACHE_SIZE)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 defsize =3D CIFSMaxBufSize;
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 defsize =3D server->maxBuf - sizeof(REA=
D_RSP);
> +
> + =A0 =A0 =A0 rsize =3D pvolume_info->rsize ? pvolume_info->rsize : d=
efsize;
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* no CAP_LARGE_READ_X? Then MS-CIFS states that we m=
ust limit this to
> + =A0 =A0 =A0 =A0* the client's MaxBufferSize.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (!(server->capabilities & CAP_LARGE_READ_X))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rsize =3D min_t(unsigned int, CIFSMaxBu=
fSize, rsize);
> +
> + =A0 =A0 =A0 /* hard limit of CIFS_MAX_RSIZE */
> + =A0 =A0 =A0 rsize =3D min_t(unsigned int, rsize, CIFS_MAX_RSIZE);
> +
> + =A0 =A0 =A0 return rsize;
> +}
> +
> =A0static int
> =A0is_path_accessible(int xid, struct cifs_tcon *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_sb_info *cifs_sb, con=
st char *full_path)
> @@ -3208,14 +3240,8 @@ try_mount_again:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFSSMBQFSAttributeInfo(xid, tcon);
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 if ((tcon->unix_ext =3D=3D 0) && (cifs_sb->rsize > (102=
4 * 127))) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->rsize =3D 1024 * 127;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(DBG2, "no very large read support,=
 rsize now 127K");
> - =A0 =A0 =A0 }
> - =A0 =A0 =A0 if (!(tcon->ses->capabilities & CAP_LARGE_READ_X))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->rsize =3D min(cifs_sb->rsize, =
CIFSMaxBufSize);
> -
> =A0 =A0 =A0 =A0cifs_sb->wsize =3D cifs_negotiate_wsize(tcon, volume_i=
nfo);
> + =A0 =A0 =A0 cifs_sb->rsize =3D cifs_negotiate_rsize(tcon, volume_in=
fo);
>
> =A0remote_path_check:
> =A0#ifdef CONFIG_CIFS_DFS_UPCALL
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index ba3ef1b..a855ff1 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1715,6 +1715,7 @@ cifs_iovec_read(struct file *file, const struct=
 iovec *iov,
> =A0 =A0 =A0 =A0struct smb_com_read_rsp *pSMBr;
> =A0 =A0 =A0 =A0struct cifs_io_parms io_parms;
> =A0 =A0 =A0 =A0char *read_data;
> + =A0 =A0 =A0 unsigned int rsize;
> =A0 =A0 =A0 =A0__u32 pid;
>
> =A0 =A0 =A0 =A0if (!nr_segs)
> @@ -1727,6 +1728,9 @@ cifs_iovec_read(struct file *file, const struct=
 iovec *iov,
> =A0 =A0 =A0 =A0xid =3D GetXid();
> =A0 =A0 =A0 =A0cifs_sb =3D CIFS_SB(file->f_path.dentry->d_sb);
>
> + =A0 =A0 =A0 /* FIXME: set up handlers for larger reads and/or conve=
rt to async */
> + =A0 =A0 =A0 rsize =3D min_t(unsigned int, cifs_sb->rsize, CIFSMaxBu=
fSize);
> +
> =A0 =A0 =A0 =A0open_file =3D file->private_data;
> =A0 =A0 =A0 =A0pTcon =3D tlink_tcon(open_file->tlink);
>
> @@ -1739,7 +1743,7 @@ cifs_iovec_read(struct file *file, const struct=
 iovec *iov,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "attempting read on write only=
 file instance");
>
> =A0 =A0 =A0 =A0for (total_read =3D 0; total_read < len; total_read +=3D=
 bytes_read) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cur_len =3D min_t(const size_t, len - t=
otal_read, cifs_sb->rsize);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cur_len =3D min_t(const size_t, len - t=
otal_read, rsize);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EAGAIN;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0read_data =3D NULL;
>
> @@ -1831,6 +1835,7 @@ static ssize_t cifs_read(struct file *file, cha=
r *read_data, size_t read_size,
> =A0 =A0 =A0 =A0unsigned int bytes_read =3D 0;
> =A0 =A0 =A0 =A0unsigned int total_read;
> =A0 =A0 =A0 =A0unsigned int current_read_size;
> + =A0 =A0 =A0 unsigned int rsize;
> =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb;
> =A0 =A0 =A0 =A0struct cifs_tcon *pTcon;
> =A0 =A0 =A0 =A0int xid;
> @@ -1843,6 +1848,9 @@ static ssize_t cifs_read(struct file *file, cha=
r *read_data, size_t read_size,
> =A0 =A0 =A0 =A0xid =3D GetXid();
> =A0 =A0 =A0 =A0cifs_sb =3D CIFS_SB(file->f_path.dentry->d_sb);
>
> + =A0 =A0 =A0 /* FIXME: set up handlers for larger reads and/or conve=
rt to async */
> + =A0 =A0 =A0 rsize =3D min_t(unsigned int, cifs_sb->rsize, CIFSMaxBu=
fSize);
> +
> =A0 =A0 =A0 =A0if (file->private_data =3D=3D NULL) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EBADF;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0FreeXid(xid);
> @@ -1863,7 +1871,7 @@ static ssize_t cifs_read(struct file *file, cha=
r *read_data, size_t read_size,
> =A0 =A0 =A0 =A0 =A0 =A0 read_size > total_read;
> =A0 =A0 =A0 =A0 =A0 =A0 total_read +=3D bytes_read, current_offset +=3D=
 bytes_read) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0current_read_size =3D min_t(const int,=
 read_size - total_read,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 cifs_sb->rsize);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 rsize);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* For windows me and 9x we do not wan=
t to request more
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0than it negotiated since it will refus=
e the read then */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((pTcon->ses) &&
> --
> 1.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
Pavel Shilovsky.
