From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Allow nfsd over cifs
Date: Mon, 28 Feb 2011 23:17:10 -0600
Message-ID: <AANLkTi=S4VFekw1zLi8ftUKJtEES=FRv0KO8fMg6bpVv@mail.gmail.com>
References: <1298929961-5541-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1298929961-5541-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Feb 28, 2011 at 3:52 PM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>
> Define structure cifs_fid to span 64 bits of inode ids.
> Allow nfsd over cifs.
> Add export ops encode_fh and fh_to_dentry.
> Add a function to find inodes off of a superblock, using only id.
>
>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/cifsfs.c =A0 =A0| =A0 =A04 +-
> =A0fs/cifs/cifsfs.h =A0 =A0| =A0 =A04 +-
> =A0fs/cifs/cifsglob.h =A0| =A0 =A05 ++++
> =A0fs/cifs/cifsproto.h | =A0 =A02 +
> =A0fs/cifs/dir.c =A0 =A0 =A0 | =A0 16 +++++--------
> =A0fs/cifs/export.c =A0 =A0| =A0 58 +++++++++++++++++++++++++++++++++=
++++-------------
> =A0fs/cifs/inode.c =A0 =A0 | =A0 15 ++++++++++++-
> =A07 files changed, 74 insertions(+), 30 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 13b3999..29ff05c 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -187,12 +187,12 @@ cifs_read_super(struct super_block *sb, void *d=
ata,
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sb->s_d_op =3D &cifs_dentry_ops;
>
> -#ifdef CIFS_NFSD_EXPORT
> +#ifdef CONFIG_CIFS_NFSD_EXPORT
> =A0 =A0 =A0 =A0if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) =
{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "export ops supported");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sb->s_export_op =3D &cifs_export_ops;
> =A0 =A0 =A0 =A0}
> -#endif /* CIFS_NFSD_EXPORT */
> +#endif /* CONFIG_CIFS_NFSD_EXPORT */
>
> =A0 =A0 =A0 =A0return 0;
>
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index 371d021..1d8185d 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -123,9 +123,9 @@ extern ssize_t =A0 =A0 =A0cifs_getxattr(struct de=
ntry *, const char *, void *, size_t);
> =A0extern ssize_t cifs_listxattr(struct dentry *, char *, size_t);
> =A0extern long cifs_ioctl(struct file *filep, unsigned int cmd, unsig=
ned long arg);
>
> -#ifdef CIFS_NFSD_EXPORT
> +#ifdef CONFIG_CIFS_NFSD_EXPORT
> =A0extern const struct export_operations cifs_export_ops;
> -#endif /* CIFS_NFSD_EXPORT */
> +#endif /* CONFIG_CIFS_NFSD_EXPORT */
>
> =A0#define CIFS_VERSION =A0 "1.71"
> =A0#endif =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* _CIFSFS_=
H */
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index e1098c3..c7faac6 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -672,6 +672,11 @@ static inline void free_dfs_info_array(struct df=
s_info3_param *param,
> =A0 =A0 =A0 =A0kfree(param);
> =A0}
>
> +struct cifs_fid {
> + =A0 =A0 =A0 u64 cino;
> + =A0 =A0 =A0 u64 cpino;
> +};
> +
> =A0#define =A0 MID_FREE 0
> =A0#define =A0 MID_REQUEST_ALLOCATED 1
> =A0#define =A0 MID_REQUEST_SUBMITTED 2
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index da7a492..0d0afd2 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -432,6 +432,8 @@ extern int mdfour(unsigned char *, unsigned char =
*, int);
> =A0extern int E_md4hash(const unsigned char *passwd, unsigned char *p=
16);
> =A0extern void SMBencrypt(unsigned char *passwd, const unsigned char =
*c8,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned char *p24);
> +extern int cifs_find_inode_id(struct inode *, void *);
> +extern int cifs_init_inode(struct inode *, void *);
> =A0extern void E_P16(unsigned char *p14, unsigned char *p16);
> =A0extern void E_P24(unsigned char *p21, const unsigned char *c8,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned char *p24);
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index dd5f229..4e9c38f 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -491,6 +491,7 @@ cifs_lookup(struct inode *parent_dir_inode, struc=
t dentry *direntry,
> =A0 =A0 =A0 =A0struct inode *newInode =3D NULL;
> =A0 =A0 =A0 =A0char *full_path =3D NULL;
> =A0 =A0 =A0 =A0struct file *filp;
> + =A0 =A0 =A0 struct dentry *spdirentry =3D NULL;
>
> =A0 =A0 =A0 =A0xid =3D GetXid();
>
> @@ -586,7 +587,9 @@ cifs_lookup(struct inode *parent_dir_inode, struc=
t dentry *direntry,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0parent=
_dir_inode->i_sb, xid, NULL);
>
> =A0 =A0 =A0 =A0if ((rc =3D=3D 0) && (newInode !=3D NULL)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 d_add(direntry, newInode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spdirentry =3D d_splice_alias(newInode,=
 direntry);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (spdirentry)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return spdirentry;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (posix_open) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0filp =3D lookup_instan=
tiate_filp(nd, direntry,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 generic_file_open);
> @@ -631,7 +634,7 @@ lookup_out:
> =A0static int
> =A0cifs_d_revalidate(struct dentry *direntry, struct nameidata *nd)
> =A0{
> - =A0 =A0 =A0 if (nd->flags & LOOKUP_RCU)
> + =A0 =A0 =A0 if (nd && nd->flags & LOOKUP_RCU)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ECHILD;
>
> =A0 =A0 =A0 =A0if (direntry->d_inode) {
> @@ -642,18 +645,11 @@ cifs_d_revalidate(struct dentry *direntry, stru=
ct nameidata *nd)
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0/*
> - =A0 =A0 =A0 =A0* This may be nfsd (or something), anyway, we can't =
see the
> - =A0 =A0 =A0 =A0* intent of this. So, since this can be for creation=
, drop it.
> - =A0 =A0 =A0 =A0*/
> - =A0 =A0 =A0 if (!nd)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> -
> - =A0 =A0 =A0 /*
> =A0 =A0 =A0 =A0 * Drop the negative dentry, in order to make sure to =
use the
> =A0 =A0 =A0 =A0 * case sensitive name which is specified by user if t=
his is
> =A0 =A0 =A0 =A0 * for creation.
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 if (!(nd->flags & (LOOKUP_CONTINUE | LOOKUP_PARENT))) {
> + =A0 =A0 =A0 if (nd && !(nd->flags & (LOOKUP_CONTINUE | LOOKUP_PAREN=
T))) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (nd->flags & (LOOKUP_CREATE | LOOKU=
P_RENAME_TARGET))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0}
> diff --git a/fs/cifs/export.c b/fs/cifs/export.c
> index 55d87ac..fd8397f 100644
> --- a/fs/cifs/export.c
> +++ b/fs/cifs/export.c
> @@ -44,24 +44,52 @@
> =A0#include "cifsglob.h"
> =A0#include "cifs_debug.h"
> =A0#include "cifsfs.h"
> +#include "cifsproto.h"
>
> -#ifdef CIFS_NFSD_EXPORT
> -static struct dentry *cifs_get_parent(struct dentry *dentry)
> +#ifdef CONFIG_CIFS_NFSD_EXPORT
> +static int cifs_encode_fh(struct dentry *dentry, __u32 *fh, int *len=
p,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int con=
nectable)
> =A0{
> - =A0 =A0 =A0 /* BB need to add code here eventually to enable export=
 via NFSD */
> - =A0 =A0 =A0 cFYI(1, "get parent for %p", dentry);
> - =A0 =A0 =A0 return ERR_PTR(-EACCES);
> + =A0 =A0 =A0 struct cifs_fid *cfid =3D (struct cifs_fid *)fh;
> + =A0 =A0 =A0 struct inode *inode =3D dentry->d_inode;
> +
> + =A0 =A0 =A0 cfid->cino =3D inode->i_ino;

This should be
 cfid->cino =3D CIFS_I(inode)->uniqueid;
instead.
Does not address the estale issue though.

> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* There is not a type to send ino32_gen32_parentino3=
2_gen32 to
> + =A0 =A0 =A0 =A0* accomodate two 64 bit inode numbers. So always ret=
urn this type.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 return FILEID_INO32_GEN;
> =A0}
>
> -const struct export_operations cifs_export_ops =3D {
> - =A0 =A0 =A0 .get_parent =3D cifs_get_parent,
> -/* =A0 =A0 Following five export operations are unneeded so far and =
can default:
> - =A0 =A0 =A0 .get_dentry =3D
> - =A0 =A0 =A0 .get_name =3D
> - =A0 =A0 =A0 .find_exported_dentry =3D
> - =A0 =A0 =A0 .decode_fh =3D
> - =A0 =A0 =A0 .encode_fs =3D =A0*/
> -};
> +static struct dentry *
> +cifs_fh_to_dentry(struct super_block *sb, struct fid *fh,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int fh_len, int fh_type=
)
> +{
> + =A0 =A0 =A0 struct cifs_fid *cfid =3D (struct cifs_fid *)fh;
> + =A0 =A0 =A0 struct inode *inode =3D NULL;
> + =A0 =A0 =A0 struct cifs_fattr fattr;
> +
>
> -#endif /* CIFS_NFSD_EXPORT */
> + =A0 =A0 =A0 if (fh_type !=3D FILEID_INO32_GEN && fh_type !=3D FILEI=
D_INO32_GEN_PARENT) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: Can't handle fh type: %d=
", __func__, fh_type);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(-EINVAL);
> + =A0 =A0 =A0 }
>
> + =A0 =A0 =A0 if (!cfid->cino)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(-ESTALE);
> +
> + =A0 =A0 =A0 fattr.cf_uniqueid =3D cfid->cino;
> + =A0 =A0 =A0 inode =3D iget5_locked(sb, cfid->cino, cifs_find_inode_=
id,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 cifs_init_inode, &fattr);
> + =A0 =A0 =A0 if (IS_ERR(inode))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ERR_CAST(inode);
> +
> + =A0 =A0 =A0 return d_obtain_alias(inode);
> +}
> +
> +const struct export_operations cifs_export_ops =3D {
> + =A0 =A0 =A0 .encode_fh =3D cifs_encode_fh,
> + =A0 =A0 =A0 .fh_to_dentry =3D cifs_fh_to_dentry
> +};
> +#endif /* CONFIG_CIFS_NFSD_EXPORT */
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 196ef60..9c86535 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -777,6 +777,19 @@ char *cifs_build_path_to_root(struct cifs_sb_inf=
o *cifs_sb,
> =A0 =A0 =A0 =A0return full_path;
> =A0}
>
> +int
> +cifs_find_inode_id(struct inode *inode, void *opaque)
> +{
> + =A0 =A0 =A0 int rc =3D 0;
> + =A0 =A0 =A0 struct cifs_fattr *fattr =3D (struct cifs_fattr *) opaq=
ue;
> +
> + =A0 =A0 =A0 /* match inode with uniqueid */
> + =A0 =A0 =A0 if (CIFS_I(inode)->uniqueid =3D=3D fattr->cf_uniqueid)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 1;
> +
> + =A0 =A0 =A0 return rc;
> +}
> +
> =A0static int
> =A0cifs_find_inode(struct inode *inode, void *opaque)
> =A0{
> @@ -801,7 +814,7 @@ cifs_find_inode(struct inode *inode, void *opaque=
)
> =A0 =A0 =A0 =A0return 1;
> =A0}
>
> -static int
> +int
> =A0cifs_init_inode(struct inode *inode, void *opaque)
> =A0{
> =A0 =A0 =A0 =A0struct cifs_fattr *fattr =3D (struct cifs_fattr *) opa=
que;
> --
> 1.6.0.2
>
>
