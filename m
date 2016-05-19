From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Remove some obsolete comments
Date: Thu, 19 May 2016 19:31:49 +0100
Message-ID: <1463682709.3144.1.camel@redhat.com>
References: <1463623053-117056-1-git-send-email-smfrench@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>,
	Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
	Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1463623053-117056-1-git-send-email-smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2016-05-18 at 20:57 -0500, Steve French wrote:
> Remove some obsolete comments in the cifs inode_operations
> structs that were pointed out by Stephen Rothwell.
>=20
> CC: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
> CC: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> Signed-off-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>

Acked-By: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

> ---
> =C2=A0fs/cifs/cifsfs.c | 7 +------
> =C2=A01 file changed, 1 insertion(+), 6 deletions(-)
>=20
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 67f622d..5d8b7ed 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -890,7 +890,6 @@ const struct inode_operations cifs_dir_inode_ops
> =3D {
> =C2=A0	.rmdir =3D cifs_rmdir,
> =C2=A0	.rename2 =3D cifs_rename2,
> =C2=A0	.permission =3D cifs_permission,
> -/*	revalidate:cifs_revalidate,=C2=A0=C2=A0=C2=A0*/
> =C2=A0	.setattr =3D cifs_setattr,
> =C2=A0	.symlink =3D cifs_symlink,
> =C2=A0	.mknod=C2=A0=C2=A0=C2=A0=3D cifs_mknod,
> @@ -901,9 +900,8 @@ const struct inode_operations cifs_dir_inode_ops
> =3D {
> =C2=A0};
> =C2=A0
> =C2=A0const struct inode_operations cifs_file_inode_ops =3D {
> -/*	revalidate:cifs_revalidate, */
> =C2=A0	.setattr =3D cifs_setattr,
> -	.getattr =3D cifs_getattr, /* do we need this anymore? */
> +	.getattr =3D cifs_getattr,
> =C2=A0	.permission =3D cifs_permission,
> =C2=A0	.setxattr =3D generic_setxattr,
> =C2=A0	.getxattr =3D generic_getxattr,
> @@ -915,9 +913,6 @@ const struct inode_operations
> cifs_symlink_inode_ops =3D {
> =C2=A0	.readlink =3D generic_readlink,
> =C2=A0	.get_link =3D cifs_get_link,
> =C2=A0	.permission =3D cifs_permission,
> -	/* BB add the following two eventually */
> -	/* revalidate: cifs_revalidate,
> -	=C2=A0=C2=A0=C2=A0setattr:=C2=A0=C2=A0=C2=A0=C2=A0cifs_notify_chang=
e, *//* BB do we need notify
> change */
> =C2=A0	.setxattr =3D generic_setxattr,
> =C2=A0	.getxattr =3D generic_getxattr,
> =C2=A0	.listxattr =3D cifs_listxattr,
