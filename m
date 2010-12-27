From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/6] CIFS: Implement cifs_strict_readv (try #3)
Date: Mon, 27 Dec 2010 11:03:28 -0500
Message-ID: <20101227110328.1d3032a1@tlielax.poochiereds.net>
References: <1293357858-10006-1-git-send-email-piastryyy@gmail.com>
	<20101227103556.20f329d1@tlielax.poochiereds.net>
	<AANLkTimnraAMo=t0sPT5+wfKw3wp6YE2J0zXuQKUwagO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimnraAMo=t0sPT5+wfKw3wp6YE2J0zXuQKUwagO-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 27 Dec 2010 18:38:56 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2010/12/27 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > On Sun, 26 Dec 2010 13:04:17 +0300
> > Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> Read from the cache if we have at least Level II oplock - otherwis=
e
> >> read from the server. Add cifs_user_readv to let the client read i=
nto
> >> iovec buffers.
> >>
> >> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =A0fs/cifs/cifsfs.c | =A0 =A04 +-
> >> =A0fs/cifs/cifsfs.h | =A0 =A06 ++-
> >> =A0fs/cifs/file.c =A0 | =A0112 +++++++++++++++++++++++++++++++++++=
+++---------------
> >> =A03 files changed, 87 insertions(+), 35 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> >> index 2b52020..0d6b005 100644
> >> --- a/fs/cifs/cifsfs.c
> >> +++ b/fs/cifs/cifsfs.c
> >> @@ -714,7 +714,7 @@ const struct file_operations cifs_file_ops =3D=
 {
> >> =A0const struct file_operations cifs_file_strict_ops =3D {
> >> =A0 =A0 =A0 .read =3D do_sync_read,
> >> =A0 =A0 =A0 .write =3D do_sync_write,
> >> - =A0 =A0 .aio_read =3D generic_file_aio_read,
> >> + =A0 =A0 .aio_read =3D cifs_strict_readv,
> >> =A0 =A0 =A0 .aio_write =3D cifs_file_aio_write,
> >> =A0 =A0 =A0 .open =3D cifs_open,
> >> =A0 =A0 =A0 .release =3D cifs_close,
> >> @@ -770,7 +770,7 @@ const struct file_operations cifs_file_nobrl_o=
ps =3D {
> >> =A0const struct file_operations cifs_file_strict_nobrl_ops =3D {
> >> =A0 =A0 =A0 .read =3D do_sync_read,
> >> =A0 =A0 =A0 .write =3D do_sync_write,
> >> - =A0 =A0 .aio_read =3D generic_file_aio_read,
> >> + =A0 =A0 .aio_read =3D cifs_strict_readv,
> >> =A0 =A0 =A0 .aio_write =3D cifs_file_aio_write,
> >> =A0 =A0 =A0 .open =3D cifs_open,
> >> =A0 =A0 =A0 .release =3D cifs_close,
> >> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> >> index 657738f..6ff3ca2 100644
> >> --- a/fs/cifs/cifsfs.h
> >> +++ b/fs/cifs/cifsfs.h
> >> @@ -81,7 +81,11 @@ extern int cifs_open(struct inode *inode, struc=
t file *file);
> >> =A0extern int cifs_close(struct inode *inode, struct file *file);
> >> =A0extern int cifs_closedir(struct inode *inode, struct file *file=
);
> >> =A0extern ssize_t cifs_user_read(struct file *file, char __user *r=
ead_data,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size_t read_size, lof=
f_t *poffset);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 size_t read_=
size, loff_t *poffset);
> >> +extern ssize_t cifs_user_readv(struct kiocb *iocb, const struct i=
ovec *iov,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned =
long nr_segs, loff_t pos);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^
> > =A0 =A0 =A0 =A0this can be static. There are no callers of cifs_use=
r_readv.
> >
> >> +extern ssize_t cifs_strict_readv(struct kiocb *iocb, const struct=
 iovec *iov,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsig=
ned long nr_segs, loff_t pos);
> >> =A0extern ssize_t cifs_user_write(struct file *file, const char __=
user *write_data,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size_t write_size, =
loff_t *poffset);
> >> =A0extern int cifs_lock(struct file *, int, struct file_lock *);
> >> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> >> index d48723c..c3bc65c 100644
> >> --- a/fs/cifs/file.c
> >> +++ b/fs/cifs/file.c
> >> @@ -1677,20 +1677,27 @@ int cifs_flush(struct file *file, fl_owner=
_t id)
> >> =A0 =A0 =A0 return rc;
> >> =A0}
> >>
> >> -ssize_t cifs_user_read(struct file *file, char __user *read_data,
> >> - =A0 =A0 size_t read_size, loff_t *poffset)
> >> +static ssize_t
> >> +cifs_iovec_read(struct file *file, const struct iovec *iov,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned long nr_segs, loff_t *poffse=
t)
> >> =A0{
> >> - =A0 =A0 int rc =3D -EACCES;
> >> - =A0 =A0 unsigned int bytes_read =3D 0;
> >> - =A0 =A0 unsigned int total_read =3D 0;
> >> - =A0 =A0 unsigned int current_read_size;
> >> + =A0 =A0 int rc;
> >> + =A0 =A0 int xid;
> >> + =A0 =A0 unsigned int total_read, bytes_read =3D 0;
> >> + =A0 =A0 size_t len, cur_len;
> >> + =A0 =A0 int iov_offset =3D 0;
> >> =A0 =A0 =A0 struct cifs_sb_info *cifs_sb;
> >> =A0 =A0 =A0 struct cifsTconInfo *pTcon;
> >> - =A0 =A0 int xid;
> >> =A0 =A0 =A0 struct cifsFileInfo *open_file;
> >> - =A0 =A0 char *smb_read_data;
> >> - =A0 =A0 char __user *current_offset;
> >> =A0 =A0 =A0 struct smb_com_read_rsp *pSMBr;
> >> + =A0 =A0 char *read_data;
> >> +
> >> + =A0 =A0 if (!nr_segs)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> >> +
> >> + =A0 =A0 len =3D iov_length(iov, nr_segs);
> >> + =A0 =A0 if (!len)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> >>
> >> =A0 =A0 =A0 xid =3D GetXid();
> >> =A0 =A0 =A0 cifs_sb =3D CIFS_SB(file->f_path.dentry->d_sb);
> >> @@ -1700,19 +1707,18 @@ ssize_t cifs_user_read(struct file *file, =
char __user *read_data,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 FreeXid(xid);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> >> =A0 =A0 =A0 }
> >> +
> >> =A0 =A0 =A0 open_file =3D file->private_data;
> >> =A0 =A0 =A0 pTcon =3D tlink_tcon(open_file->tlink);
> >>
> >> =A0 =A0 =A0 if ((file->f_flags & O_ACCMODE) =3D=3D O_WRONLY)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "attempting read on write only=
 file instance");
> >>
> >> - =A0 =A0 for (total_read =3D 0, current_offset =3D read_data;
> >> - =A0 =A0 =A0 =A0 =A0read_size > total_read;
> >> - =A0 =A0 =A0 =A0 =A0total_read +=3D bytes_read, current_offset +=3D=
 bytes_read) {
> >> - =A0 =A0 =A0 =A0 =A0 =A0 current_read_size =3D min_t(const int, r=
ead_size - total_read,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 cifs_sb->rsize);
> >> + =A0 =A0 for (total_read =3D 0; total_read < len; total_read +=3D=
 bytes_read) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 cur_len =3D min_t(const size_t, len - to=
tal_read, cifs_sb->rsize);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EAGAIN;
> >> - =A0 =A0 =A0 =A0 =A0 =A0 smb_read_data =3D NULL;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 read_data =3D NULL;
> >> +
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 while (rc =3D=3D -EAGAIN) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int buf_type =3D CIFS_=
NO_BUFFER;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (open_file->invalid=
Handle) {
> >> @@ -1720,27 +1726,25 @@ ssize_t cifs_user_read(struct file *file, =
char __user *read_data,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc=
 !=3D 0)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 break;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBRead(xid, =
pTcon,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0open_file->netfid,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0current_read_size, *poffset,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0&bytes_read, &smb_read_data,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0&buf_type);
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMBr =3D (struct smb_co=
m_read_rsp *)smb_read_data;
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (smb_read_data) {
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (copy=
_to_user(current_offset,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 smb_read_data +
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 4 /* RFC1001 length field */ +
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 le16_to_cpu(pSMBr->DataOffset),
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 bytes_read))
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBRead(xid, =
pTcon, open_file->netfid,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0cur_len, *poffset, &bytes_read,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0&read_data, &buf_type);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMBr =3D (struct smb_co=
m_read_rsp *)read_data;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (read_data) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *da=
ta_offset =3D read_data + 4 +
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 le16_to_cpu(pSMBr->DataOffset);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (memc=
py_toiovecend(iov, data_offset,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov_offset, bytes_read))
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0^^^^^
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Much better. It's al=
ways better to use existing
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0infrastructure.
> >
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 rc =3D -EFAULT;
> >> -
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (bu=
f_type =3D=3D CIFS_SMALL_BUFFER)
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 cifs_small_buf_release(smb_read_data);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 cifs_small_buf_release(read_data);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else i=
f (buf_type =3D=3D CIFS_LARGE_BUFFER)
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 cifs_buf_release(smb_read_data);
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 smb_read=
_data =3D NULL;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 cifs_buf_release(read_data);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 read_dat=
a =3D NULL;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov_offs=
et +=3D bytes_read;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> +
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || (bytes_read =3D=3D 0)) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (total_read) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> >> @@ -1753,13 +1757,57 @@ ssize_t cifs_user_read(struct file *file, =
char __user *read_data,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *poffset +=3D bytes_re=
ad;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> =A0 =A0 =A0 }
> >> +
> >> =A0 =A0 =A0 FreeXid(xid);
> >> =A0 =A0 =A0 return total_read;
> >> =A0}
> >>
> >> +ssize_t cifs_user_read(struct file *file, char __user *read_data,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size_t read_size, loff_t =
*poffset)
> >> +{
> >> + =A0 =A0 struct iovec iov;
> >> + =A0 =A0 iov.iov_base =3D read_data;
> >> + =A0 =A0 iov.iov_len =3D read_size;
> >> +
> >> + =A0 =A0 return cifs_iovec_read(file, &iov, 1, poffset);
> >> +}
> >> +
> >> +ssize_t cifs_user_readv(struct kiocb *iocb, const struct iovec *i=
ov,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long nr_segs, l=
off_t pos)
> >> +{
> >> + =A0 =A0 ssize_t read;
> >> +
> >> + =A0 =A0 read =3D cifs_iovec_read(iocb->ki_filp, iov, nr_segs, &p=
os);
> >> + =A0 =A0 if (read > 0)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 iocb->ki_pos =3D pos;
> >> +
> >> + =A0 =A0 return read;
> >> +}
> >> +
> >
> > Again, I'd make the above static. If you do that, the compiler will
> > likely just inline the function into the only caller below.
> >
> >> +ssize_t cifs_strict_readv(struct kiocb *iocb, const struct iovec =
*iov,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long nr_seg=
s, loff_t pos)
> >> +{
> >> + =A0 =A0 struct inode *inode;
> >> +
> >> + =A0 =A0 inode =3D iocb->ki_filp->f_path.dentry->d_inode;
> >> +
> >> + =A0 =A0 if (CIFS_I(inode)->clientCanCacheRead)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 return generic_file_aio_read(iocb, iov, =
nr_segs, pos);
> >> +
> >> + =A0 =A0 /*
> >> + =A0 =A0 =A0* In strict cache mode we need to read from the serve=
r all the time
> >> + =A0 =A0 =A0* if we don't have level II oplock because the server=
 can delay mtime
> >> + =A0 =A0 =A0* change - so we can't make a decision about inode in=
validating.
> >> + =A0 =A0 =A0* And we can also fail with pagereading if there are =
mandatory locks
> >> + =A0 =A0 =A0* on pages affected by this read but not on the regio=
n from pos to
> >> + =A0 =A0 =A0* pos+len-1.
> >> + =A0 =A0 =A0*/
> >> +
> >> + =A0 =A0 return cifs_user_readv(iocb, iov, nr_segs, pos);
> >> +}
> >>
> >> =A0static ssize_t cifs_read(struct file *file, char *read_data, si=
ze_t read_size,
> >> - =A0 =A0 loff_t *poffset)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0loff_t *poffset)
> >> =A0{
> >> =A0 =A0 =A0 int rc =3D -EACCES;
> >> =A0 =A0 =A0 unsigned int bytes_read =3D 0;
> >
> >
> > Nice work. Other than making that function static, this looks good =
to
> > me, so you can add my Reviewed-by once that's been fixed...
> >
> > --
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >
>=20
> Jeff, I want to add cifs_user_readv/cifs_user_writev to direct_ops
> structure further - that's why I did these functions global.
>=20

Makes sense, but in general, it would be better to go ahead and make
it static and then convert it to a global when you have callers that
need it. That way we're not left with extra global symbols if that
conversion gets put off for some reason. Linux CIFS is rife with
examples of future plans that didn't pan out. :)

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
