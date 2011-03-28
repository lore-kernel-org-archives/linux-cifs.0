From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: don't allow mmap'ed pages to be dirtied while under
 writeback (try #2)
Date: Mon, 28 Mar 2011 15:51:35 -0500
Message-ID: <AANLkTinm0i8Unw2=LQD3CFZXadbEm7tu+ViWM3hcmSmW@mail.gmail.com>
References: <AANLkTin2Kzg=g+m3j66uLyaWRx6jn8j37Kg9C0zxCWhd@mail.gmail.com>
	<1301342949-25330-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1301342949-25330-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reviewed and merged into cifs-2.6.git

This looks like nice work.

On Mon, Mar 28, 2011 at 3:09 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> If a process has a dirty page mapped into its page tables, then it ha=
s
> the ability to change it while the client is trying to write the data
> out to the server. If that happens after the signature has been
> calculated then that signature will then be wrong, and the server wil=
l
> likely reset the TCP connection.
>
> This patch adds a page_mkwrite handler for CIFS that simply takes the
> page lock. Because the page lock is held over the life of writepage a=
nd
> writepages, this prevents the page from becoming writeable until
> the write call has completed.
>
> With this, we can also remove the "sign_zero_copy" module option and
> always inline the pages when writing.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsfs.c =A0 | =A0 =A04 ---
> =A0fs/cifs/cifsglob.h | =A0 =A01 -
> =A0fs/cifs/file.c =A0 =A0 | =A0 64 ++++++++++++++++++++++++++--------=
-----------------
> =A03 files changed, 33 insertions(+), 36 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index de49fbb..1af2470 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -81,10 +81,6 @@ module_param(echo_retries, ushort, 0644);
> =A0MODULE_PARM_DESC(echo_retries, "Number of echo attempts before giv=
ing up and "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "reconnec=
ting server. Default: 5. 0 means "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "never re=
connect.");
> -bool sign_zero_copy; =A0/* globals init to false automatically */
> -module_param(sign_zero_copy, bool, 0644);
> -MODULE_PARM_DESC(sign_zero_copy, "Don't copy pages on write with sig=
ning "
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"ena=
bled. Default: N");
> =A0extern mempool_t *cifs_sm_req_poolp;
> =A0extern mempool_t *cifs_req_poolp;
> =A0extern mempool_t *cifs_mid_poolp;
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 2c52c14..ccbac61 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -907,7 +907,6 @@ GLOBAL_EXTERN unsigned int CIFSMaxBufSize; =A0/* =
max size not including hdr */
> =A0GLOBAL_EXTERN unsigned int cifs_min_rcv; =A0 =A0/* min size of big=
 ntwrk buf pool */
> =A0GLOBAL_EXTERN unsigned int cifs_min_small; =A0/* min size of small=
 buf pool */
> =A0GLOBAL_EXTERN unsigned int cifs_max_pending; /* MAX requests at on=
ce to server*/
> -GLOBAL_EXTERN bool sign_zero_copy; /* don't copy written pages with =
signing */
>
> =A0/* reconnect after this many failed echo attempts */
> =A0GLOBAL_EXTERN unsigned short echo_retries;
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index b9731c9..da53246 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -881,6 +881,9 @@ static ssize_t cifs_write(struct cifsFileInfo *op=
en_file,
> =A0 =A0 =A0 =A0 =A0 =A0 total_written +=3D bytes_written) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EAGAIN;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0while (rc =3D=3D -EAGAIN) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct kvec iov[2];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int len;
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (open_file->invalid=
Handle) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* we =
could deadlock if we called
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 f=
ilemap_fdatawait from here so tell
> @@ -890,31 +893,14 @@ static ssize_t cifs_write(struct cifsFileInfo *=
open_file,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc=
 !=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sign_zero_copy || (=
pTcon->ses->server &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((pTcon=
->ses->server->sec_mode &
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (SECMOD=
E_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D=3D =
0))) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct =
kvec iov[2];
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigne=
d int len;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D=
 min((size_t)cifs_sb->wsize,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 write_size - total_written);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* iov[=
0] is reserved for smb header */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].=
iov_base =3D (char *)write_data +
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 total_written;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].=
iov_len =3D len;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D =
CIFSSMBWrite2(xid, pTcon,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 open_file->netfid, len,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 *poffset, &bytes_written,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 iov, 1, 0);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D =
CIFSSMBWrite(xid, pTcon,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0open_file->netfid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0min_t(const int, cifs_sb->wsize,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0write_size - total_written),
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0*poffset, &bytes_written,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0write_data + total_written,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0NULL, 0);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len =3D min((size_t)cif=
s_sb->wsize,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wri=
te_size - total_written);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* iov[0] is reserved f=
or smb header */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].iov_base =3D (ch=
ar *)write_data + total_written;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].iov_len =3D len;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite2(xi=
d, pTcon, open_file->netfid, len,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 *poffset, &bytes_written, iov, 1, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc || (bytes_written =3D=3D 0)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (total_written)
> @@ -1151,12 +1137,6 @@ static int cifs_writepages(struct address_spac=
e *mapping,
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0tcon =3D tlink_tcon(open_file->tlink);
> - =A0 =A0 =A0 if (!sign_zero_copy && tcon->ses->server->sec_mode &
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (SECMODE_SIGN_REQUIRED =
| SECMODE_SIGN_ENABLED)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsFileInfo_put(open_file);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(iov);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return generic_writepages(mapping, wbc)=
;
> - =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0cifsFileInfo_put(open_file);
>
> =A0 =A0 =A0 =A0xid =3D GetXid();
> @@ -1909,6 +1889,24 @@ static ssize_t cifs_read(struct file *file, ch=
ar *read_data, size_t read_size,
> =A0 =A0 =A0 =A0return total_read;
> =A0}
>
> +/*
> + * If the page is mmap'ed into a process' page tables, then we need =
to make
> + * sure that it doesn't change while being written back.
> + */
> +static int
> +cifs_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> +{
> + =A0 =A0 =A0 struct page *page =3D vmf->page;
> +
> + =A0 =A0 =A0 lock_page(page);
> + =A0 =A0 =A0 return VM_FAULT_LOCKED;
> +}
> +
> +static struct vm_operations_struct cifs_file_vm_ops =3D {
> + =A0 =A0 =A0 .fault =3D filemap_fault,
> + =A0 =A0 =A0 .page_mkwrite =3D cifs_page_mkwrite,
> +};
> +
> =A0int cifs_file_strict_mmap(struct file *file, struct vm_area_struct=
 *vma)
> =A0{
> =A0 =A0 =A0 =A0int rc, xid;
> @@ -1920,6 +1918,8 @@ int cifs_file_strict_mmap(struct file *file, st=
ruct vm_area_struct *vma)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_invalidate_mapping(inode);
>
> =A0 =A0 =A0 =A0rc =3D generic_file_mmap(file, vma);
> + =A0 =A0 =A0 if (rc =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 vma->vm_ops =3D &cifs_file_vm_ops;
> =A0 =A0 =A0 =A0FreeXid(xid);
> =A0 =A0 =A0 =A0return rc;
> =A0}
> @@ -1936,6 +1936,8 @@ int cifs_file_mmap(struct file *file, struct vm=
_area_struct *vma)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0rc =3D generic_file_mmap(file, vma);
> + =A0 =A0 =A0 if (rc =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 vma->vm_ops =3D &cifs_file_vm_ops;
> =A0 =A0 =A0 =A0FreeXid(xid);
> =A0 =A0 =A0 =A0return rc;
> =A0}
> --
> 1.7.4
>
>



--=20
Thanks,

Steve
