From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: make cifs_ioctl handle NULL filp->private_data correctly
Date: Mon, 8 Nov 2010 09:02:13 -0600
Message-ID: <AANLkTimLmY2exgUU-tKNENu4SGwR0cCGifu-eYK_=0EO@mail.gmail.com>
References: <1289219312-21396-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sjayaraman-l3A5Bk7waGM@public.gmane.org, kjella79-eZNTXLQAfP4@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289219312-21396-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Makes sense - will do some tests today and merge

On Mon, Nov 8, 2010 at 6:28 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Commit 13cfb7334e made cifs_ioctl use the tlink attached to the
> cifsFileInfo for a filp. This ignores the case of an open directory
> however, which in CIFS can have a NULL private_data until a readdir
> is done on it.
>
> This patch re-adds the NULL pointer checks that were removed in commi=
t
> 50ae28f01 and moves the setting of tcon and "caps" variables lower.
>
> Long term, a better fix would be to establish a f_op->open routine fo=
r
> directories that populates that field at open time, but that requires
> some other changes to how readdir calls are handled.
>
> Reported-by: Kjell Rune Skaaraas <kjella79-eZNTXLQAfP4@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/ioctl.c | =A0 12 ++++++++++--
> =A01 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
> index 2fa22f2..0c98672 100644
> --- a/fs/cifs/ioctl.c
> +++ b/fs/cifs/ioctl.c
> @@ -38,10 +38,10 @@ long cifs_ioctl(struct file *filep, unsigned int =
command, unsigned long arg)
> =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb;
> =A0#ifdef CONFIG_CIFS_POSIX
> =A0 =A0 =A0 =A0struct cifsFileInfo *pSMBFile =3D filep->private_data;
> - =A0 =A0 =A0 struct cifsTconInfo *tcon =3D tlink_tcon(pSMBFile->tlin=
k);
> + =A0 =A0 =A0 struct cifsTconInfo *tcon;
> =A0 =A0 =A0 =A0__u64 =A0 ExtAttrBits =3D 0;
> =A0 =A0 =A0 =A0__u64 =A0 ExtAttrMask =3D 0;
> - =A0 =A0 =A0 __u64 =A0 caps =3D le64_to_cpu(tcon->fsUnixInfo.Capabil=
ity);
> + =A0 =A0 =A0 __u64 =A0 caps;
> =A0#endif /* CONFIG_CIFS_POSIX */
>
> =A0 =A0 =A0 =A0xid =3D GetXid();
> @@ -62,6 +62,10 @@ long cifs_ioctl(struct file *filep, unsigned int c=
ommand, unsigned long arg)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0#ifdef CONFIG_CIFS_POSIX
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case FS_IOC_GETFLAGS:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pSMBFile =3D=3D NUL=
L)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tcon =3D tlink_tcon(pSM=
BFile->tlink);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 caps =3D le64_to_cpu(tc=
on->fsUnixInfo.Capability);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (CIFS_UNIX_EXTATTR_=
CAP & caps) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D=
 CIFSGetExtAttr(xid, tcon, pSMBFile->netfid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0&ExtAttrBits, &ExtAttrMask);
> @@ -73,6 +77,10 @@ long cifs_ioctl(struct file *filep, unsigned int c=
ommand, unsigned long arg)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case FS_IOC_SETFLAGS:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pSMBFile =3D=3D NUL=
L)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tcon =3D tlink_tcon(pSM=
BFile->tlink);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 caps =3D le64_to_cpu(tc=
on->fsUnixInfo.Capability);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (CIFS_UNIX_EXTATTR_=
CAP & caps) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ge=
t_user(ExtAttrBits, (int __user *)arg)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0rc =3D -EFAULT;
> --
> 1.7.2.3
>
>



--=20
Thanks,

Steve
