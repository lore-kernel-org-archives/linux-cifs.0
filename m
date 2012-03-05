From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: possible memory leak in xattr.
Date: Mon, 5 Mar 2012 07:40:46 -0600
Message-ID: <CADT32eK-3jKZRfa60Ki6cbfmV1RTkxZ_vE07NMsQV_nSn-nmNQ@mail.gmail.com>
References: <1330669046-13738-1-git-send-email-santoshprasadnayak@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: santosh nayak <santoshprasadnayak-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1330669046-13738-1-git-send-email-santoshprasadnayak-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Mar 2, 2012 at 12:17 AM, santosh nayak
<santoshprasadnayak-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Santosh Nayak <santoshprasadnayak-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> Memory is allocated irrespective of whether CIFS_ACL is configured
> or not. But free is happenning only if CIFS_ACL is set. This is a
> possible memory leak scenario.
>
> Fix is:
> Allocate and free memory only if CIFS_ACL is configured.
>
> Signed-off-by: Santosh Nayak <santoshprasadnayak-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/xattr.c | =A0 =A06 +++---
> =A01 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
> index 45f07c4..10d92cf 100644
> --- a/fs/cifs/xattr.c
> +++ b/fs/cifs/xattr.c
> @@ -105,7 +105,6 @@ int cifs_setxattr(struct dentry *direntry, const =
char *ea_name,
> =A0 =A0 =A0 =A0struct cifs_tcon *pTcon;
> =A0 =A0 =A0 =A0struct super_block *sb;
> =A0 =A0 =A0 =A0char *full_path;
> - =A0 =A0 =A0 struct cifs_ntsd *pacl;
>
> =A0 =A0 =A0 =A0if (direntry =3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EIO;
> @@ -164,23 +163,24 @@ int cifs_setxattr(struct dentry *direntry, cons=
t char *ea_name,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->mnt_cifs_flag=
s & CIFS_MOUNT_MAP_SPECIAL_CHR);
> =A0 =A0 =A0 =A0} else if (strncmp(ea_name, CIFS_XATTR_CIFS_ACL,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0strlen(CIFS_XATTR_CIFS=
_ACL)) =3D=3D 0) {
> +#ifdef CONFIG_CIFS_ACL
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_ntsd *pacl;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pacl =3D kmalloc(value_size, GFP_KERNE=
L);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!pacl) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "%s: Can't all=
ocate memory for ACL",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0__func__);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -ENOMEM;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> -#ifdef CONFIG_CIFS_ACL
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memcpy(pacl, ea_value,=
 value_size);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D set_cifs_acl(pa=
cl, value_size,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dirent=
ry->d_inode, full_path, CIFS_ACL_DACL);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc =3D=3D 0) /* fo=
rce revalidate of the inode */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_I=
(direntry->d_inode)->time =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kfree(pacl);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0#else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Set CIFS ACL =
not supported yet");
> =A0#endif /* CONFIG_CIFS_ACL */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int temp;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0temp =3D strncmp(ea_name, POSIX_ACL_XA=
TTR_ACCESS,
> --
> 1.7.4.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html

Looks correct.

Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
