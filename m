From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] handle extended attribute name cifsacl to generate cifs
 acl blob
Date: Tue, 12 Oct 2010 08:45:37 -0500
Message-ID: <AANLkTinn-n8TSVXe_oAno+RxV=r6wBMq2O0r=JEYbrbU@mail.gmail.com>
References: <1286460207-4024-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101012132635.GA2567@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101012132635.GA2567-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Oct 12, 2010 at 8:26 AM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> =
wrote:
> On Thu, Oct 07, 2010 at 09:03:27AM -0500, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org=
 wrote:
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Add extended attribute name system.cifsacl
>>
>> Get/generate cifs/ntfs acl blob and hand over to the invoker however
>> it wants to parse/process it.
>>
>> Stop generating cifs/ntfs acl blob for xattr name system.posix_acl_a=
ccess
>
> Please don't make the cifs code even more messy than it already is.
> If you add new attrs please switch to split handlers like in the patc=
h
> I posted some month ago.
>

Christoph, I posted another version of this patch.  Do your comment sta=
nd
wrt that patch also?

>
> Below is the lastest version I could find on my laptop:
>
> ---
> From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Subject: [PATCH] cifs: use xattr handlers
>
> Rewrite the cifs xattr code to use the generic xattr dispatch handler=
s
> and clean up the code using it.
>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
>
> Index: linux-2.6/fs/cifs/Makefile
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/fs/cifs/Makefile =A0 =A0 2010-06-29 16:58:41.63825=
4185 +0200
> +++ linux-2.6/fs/cifs/Makefile =A02010-06-29 16:59:11.105253486 +0200
> @@ -5,9 +5,9 @@ obj-$(CONFIG_CIFS) +=3D cifs.o
>
> =A0cifs-y :=3D cifsfs.o cifssmb.o cifs_debug.o connect.o dir.o file.o=
 inode.o \
> =A0 =A0 =A0 =A0 =A0link.o misc.o netmisc.o smbdes.o smbencrypt.o tran=
sport.o asn1.o \
> - =A0 =A0 =A0 =A0 md4.o md5.o cifs_unicode.o nterr.o xattr.o cifsencr=
ypt.o \
> + =A0 =A0 =A0 =A0 md4.o md5.o cifs_unicode.o nterr.o cifsencrypt.o \
> =A0 =A0 =A0 =A0 =A0readdir.o ioctl.o sess.o export.o cifsacl.o
>
> +cifs-$(CONFIG_CIFS_XATTR) +=3D xattr.o
> =A0cifs-$(CONFIG_CIFS_UPCALL) +=3D cifs_spnego.o
> -
> =A0cifs-$(CONFIG_CIFS_DFS_UPCALL) +=3D dns_resolve.o cifs_dfs_ref.o
> Index: linux-2.6/fs/cifs/xattr.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/fs/cifs/xattr.c =A0 =A0 =A02010-06-29 16:58:41.646=
254045 +0200
> +++ linux-2.6/fs/cifs/xattr.c =A0 2010-06-29 17:13:33.386284428 +0200
> @@ -22,356 +22,272 @@
> =A0#include <linux/fs.h>
> =A0#include <linux/posix_acl_xattr.h>
> =A0#include <linux/slab.h>
> +#include <linux/xattr.h>
> =A0#include "cifsfs.h"
> =A0#include "cifspdu.h"
> =A0#include "cifsglob.h"
> =A0#include "cifsproto.h"
> =A0#include "cifs_debug.h"
>
> -#define MAX_EA_VALUE_SIZE 65535
> -#define CIFS_XATTR_DOS_ATTRIB "user.DosAttrib"
> -#define CIFS_XATTR_USER_PREFIX "user."
> -#define CIFS_XATTR_SYSTEM_PREFIX "system."
> -#define CIFS_XATTR_OS2_PREFIX "os2."
> -#define CIFS_XATTR_SECURITY_PREFIX ".security"
> -#define CIFS_XATTR_TRUSTED_PREFIX "trusted."
> -#define XATTR_TRUSTED_PREFIX_LEN =A08
> -#define XATTR_SECURITY_PREFIX_LEN 9
> -/* BB need to add server (Samba e.g) support for security and truste=
d prefix */
> +#define MAX_EA_VALUE_SIZE =A0 =A0 =A065535
> +#define CIFS_XATTR_OS2_PREFIX =A0"os2."
>
> -
> -
> -int cifs_removexattr(struct dentry *direntry, const char *ea_name)
> +/*
> + * TODO (maybe):
> + * =A0 =A0 - return dos attributes as pseudo xattr
> + * =A0 =A0 - return alt name if available as pseudo attr
> + * =A0 =A0 - if proc/fs/cifs/streamstoxattr is set then search serve=
r for
> + * =A0 =A0 =A0 EAs or streams to returns as xattrs
> + * =A0 =A0 - need to add server (Samba e.g) support for security and
> + * =A0 =A0 =A0 trusted prefix
> + */
> +
> +static int
> +cifs_xattr_set(struct dentry *dentry, const char *name, const void *=
value,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 size_t size, int flags, int xflags)
> =A0{
> - =A0 =A0 =A0 int rc =3D -EOPNOTSUPP;
> -#ifdef CONFIG_CIFS_XATTR
> - =A0 =A0 =A0 int xid;
> - =A0 =A0 =A0 struct cifs_sb_info *cifs_sb;
> - =A0 =A0 =A0 struct cifsTconInfo *pTcon;
> - =A0 =A0 =A0 struct super_block *sb;
> + =A0 =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(dentry->d_inod=
e->i_sb);
> =A0 =A0 =A0 =A0char *full_path;
> + =A0 =A0 =A0 int xid;
> + =A0 =A0 =A0 int rc;
>
> - =A0 =A0 =A0 if (direntry =3D=3D NULL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> - =A0 =A0 =A0 if (direntry->d_inode =3D=3D NULL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> - =A0 =A0 =A0 sb =3D direntry->d_inode->i_sb;
> - =A0 =A0 =A0 if (sb =3D=3D NULL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> - =A0 =A0 =A0 xid =3D GetXid();
> + =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EOPNOTSUPP;
>
> - =A0 =A0 =A0 cifs_sb =3D CIFS_SB(sb);
> - =A0 =A0 =A0 pTcon =3D cifs_sb->tcon;
> + =A0 =A0 =A0 if (strcmp(name, "") =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>
> - =A0 =A0 =A0 full_path =3D build_path_from_dentry(direntry);
> - =A0 =A0 =A0 if (full_path =3D=3D NULL) {
> + =A0 =A0 =A0 xid =3D GetXid();
> + =A0 =A0 =A0 full_path =3D build_path_from_dentry(dentry);
> + =A0 =A0 =A0 if (!full_path) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -ENOMEM;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 FreeXid(xid);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_free_xid;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 if (ea_name =3D=3D NULL) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Null xattr names not supported=
");
> - =A0 =A0 =A0 } else if (strncmp(ea_name, CIFS_XATTR_USER_PREFIX, 5)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 && (strncmp(ea_name, CIFS_XATTR_OS2_PRE=
=46IX, 4))) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"illegal xattr request %s (o=
nly user namespace supported)",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ea_name);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB what if no namespace prefix? */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Should we just pass them to server, =
except for
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 system and perhaps security prefixes? *=
/
> - =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUN=
T_NO_XATTR)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto remove_ea_exit;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ea_name +=3D 5; /* skip past user. pref=
ix */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBSetEA(xid, pTcon, full_pa=
th, ea_name, NULL,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (__u16)0, cifs_sb->loca=
l_nls,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags=
 & CIFS_MOUNT_MAP_SPECIAL_CHR);
> +
> + =A0 =A0 =A0 /* make sure size is set to zero for remove requests */
> + =A0 =A0 =A0 if (!value)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 size =3D 0;
> +
> + =A0 =A0 =A0 if (size > MAX_EA_VALUE_SIZE) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "size of EA value too large");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EOPNOTSUPP;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_free_path;
> =A0 =A0 =A0 =A0}
> -remove_ea_exit:
> +
> + =A0 =A0 =A0 rc =3D CIFSSMBSetEA(xid, cifs_sb->tcon, full_path, name=
, value, size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->local_nls,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_f=
lags & CIFS_MOUNT_MAP_SPECIAL_CHR);
> +
> +out_free_path:
> =A0 =A0 =A0 =A0kfree(full_path);
> +out_free_xid:
> =A0 =A0 =A0 =A0FreeXid(xid);
> -#endif
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> -int cifs_setxattr(struct dentry *direntry, const char *ea_name,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const void *ea_value, size_t value_=
size, int flags)
> +static int
> +cifs_xattr_get(struct dentry *dentry, const char *name,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 void *value, size_t size, int type)
> =A0{
> - =A0 =A0 =A0 int rc =3D -EOPNOTSUPP;
> -#ifdef CONFIG_CIFS_XATTR
> - =A0 =A0 =A0 int xid;
> - =A0 =A0 =A0 struct cifs_sb_info *cifs_sb;
> - =A0 =A0 =A0 struct cifsTconInfo *pTcon;
> - =A0 =A0 =A0 struct super_block *sb;
> + =A0 =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(dentry->d_inod=
e->i_sb);
> =A0 =A0 =A0 =A0char *full_path;
> + =A0 =A0 =A0 ssize_t rc;
> + =A0 =A0 =A0 int xid;
>
> - =A0 =A0 =A0 if (direntry =3D=3D NULL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> - =A0 =A0 =A0 if (direntry->d_inode =3D=3D NULL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> - =A0 =A0 =A0 sb =3D direntry->d_inode->i_sb;
> - =A0 =A0 =A0 if (sb =3D=3D NULL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> - =A0 =A0 =A0 xid =3D GetXid();
> + =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EOPNOTSUPP;
>
> - =A0 =A0 =A0 cifs_sb =3D CIFS_SB(sb);
> - =A0 =A0 =A0 pTcon =3D cifs_sb->tcon;
> + =A0 =A0 =A0 if (strcmp(name, "") =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>
> - =A0 =A0 =A0 full_path =3D build_path_from_dentry(direntry);
> - =A0 =A0 =A0 if (full_path =3D=3D NULL) {
> + =A0 =A0 =A0 xid =3D GetXid();
> +
> + =A0 =A0 =A0 full_path =3D build_path_from_dentry(dentry);
> + =A0 =A0 =A0 if (!full_path) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -ENOMEM;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 FreeXid(xid);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_free_xid;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 /* return dos attributes as pseudo xattr */
> - =A0 =A0 =A0 /* return alt name if available as pseudo attr */
> + =A0 =A0 =A0 rc =3D CIFSSMBQAllEAs(xid, cifs_sb->tcon, full_path, na=
me, value, size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->local_=
nls,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_ci=
fs_flags &
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 CIFS_MOUNT_MAP_SPECIAL_CHR);
> + =A0 =A0 =A0 if (rc =3D=3D -EINVAL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EOPNOTSUPP;
>
> - =A0 =A0 =A0 /* if proc/fs/cifs/streamstoxattr is set then
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 search server for EAs or streams to
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 returns as xattrs */
> - =A0 =A0 =A0 if (value_size > MAX_EA_VALUE_SIZE) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "size of EA value too large");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(full_path);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 FreeXid(xid);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EOPNOTSUPP;
> - =A0 =A0 =A0 }
> + =A0 =A0 =A0 kfree(full_path);
> +out_free_xid:
> + =A0 =A0 =A0 FreeXid(xid);
> + =A0 =A0 =A0 return rc;
> +}
> +
> +static struct xattr_handler cifs_xattr_user_handler =3D {
> + =A0 =A0 =A0 .prefix =3D XATTR_USER_PREFIX,
> + =A0 =A0 =A0 .get =A0 =A0=3D cifs_xattr_get,
> + =A0 =A0 =A0 .set =A0 =A0=3D cifs_xattr_set,
> +};
> +
> +static struct xattr_handler cifs_xattr_os2_handler =3D {
> + =A0 =A0 =A0 .prefix =3D CIFS_XATTR_OS2_PREFIX,
> + =A0 =A0 =A0 .get =A0 =A0=3D cifs_xattr_get,
> + =A0 =A0 =A0 .set =A0 =A0=3D cifs_xattr_set,
> +};
>
> - =A0 =A0 =A0 if (ea_name =3D=3D NULL) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Null xattr names not supported=
");
> - =A0 =A0 =A0 } else if (strncmp(ea_name, CIFS_XATTR_USER_PREFIX, 5) =
=3D=3D 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUN=
T_NO_XATTR)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto set_ea_exit;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (strncmp(ea_name, CIFS_XATTR_DOS_ATT=
RIB, 14) =3D=3D 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "attempt to set=
 cifs inode metadata");
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ea_name +=3D 5; /* skip past user. pref=
ix */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBSetEA(xid, pTcon, full_pa=
th, ea_name, ea_value,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (__u16)value_size, cifs=
_sb->local_nls,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags=
 & CIFS_MOUNT_MAP_SPECIAL_CHR);
> - =A0 =A0 =A0 } else if (strncmp(ea_name, CIFS_XATTR_OS2_PREFIX, 4) =3D=
=3D 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUN=
T_NO_XATTR)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto set_ea_exit;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ea_name +=3D 4; /* skip past os2. prefi=
x */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBSetEA(xid, pTcon, full_pa=
th, ea_name, ea_value,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (__u16)value_size, cifs=
_sb->local_nls,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags=
 & CIFS_MOUNT_MAP_SPECIAL_CHR);
> - =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 int temp;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 temp =3D strncmp(ea_name, POSIX_ACL_XAT=
TR_ACCESS,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 strlen(POSIX_ACL_XATTR_=
ACCESS));
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (temp =3D=3D 0) {
> =A0#ifdef CONFIG_CIFS_POSIX
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sb->s_flags & MS_PO=
SIXACL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D =
CIFSSMBSetPosixACL(xid, pTcon, full_path,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 ea_value, (const int)value_size,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 ACL_TYPE_ACCESS, cifs_sb->local_nls,
> +static int
> +cifs_xattr_acl_get(struct dentry *dentry, const char *name,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 void *value, size_t size, int type)
> +{
> + =A0 =A0 =A0 struct super_block *sb =3D dentry->d_inode->i_sb;
> + =A0 =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(sb);
> + =A0 =A0 =A0 struct cifsTconInfo *tcon =3D cifs_sb->tcon;
> + =A0 =A0 =A0 ssize_t rc =3D -EOPNOTSUPP;
> + =A0 =A0 =A0 char *full_path;
> + =A0 =A0 =A0 int xid;
> +
> + =A0 =A0 =A0 xid =3D GetXid();
> + =A0 =A0 =A0 if (strcmp(name, "") =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_free_xid;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 full_path =3D build_path_from_dentry(dentry);
> + =A0 =A0 =A0 if (!full_path) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_free_xid;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (sb->s_flags & MS_POSIXACL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBGetPosixACL(xid, tcon, fu=
ll_path, value, size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 type, cifs_sb->local_nls,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0cifs_sb->mnt_cifs_flags &
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0CIFS_MOUNT_MAP_SPECIAL_CHR);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "set POSIX ACL =
rc %d", rc);
> -#else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "set POSIX ACL =
not supported");
> -#endif
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (strncmp(ea_name, POSIX_ACL_X=
ATTR_DEFAULT,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
strlen(POSIX_ACL_XATTR_DEFAULT)) =3D=3D 0) {
> -#ifdef CONFIG_CIFS_POSIX
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sb->s_flags & MS_PO=
SIXACL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D =
CIFSSMBSetPosixACL(xid, pTcon, full_path,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 ea_value, (const int)value_size,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 ACL_TYPE_DEFAULT, cifs_sb->local_nls,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 cifs_sb->mnt_cifs_flags &
> +#ifdef CONFIG_CIFS_EXPERIMENTAL
> + =A0 =A0 =A0 } else if (type =3D=3D ACL_TYPE_ACCESS && experimEnable=
d &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(cifs_sb->mnt_cifs_flags & CIFS_=
MOUNT_CIFS_ACL)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_ntsd *pacl =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int oplock =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 u32 buflen =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 u16 fid;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBOpen(xid, tcon, full_path=
, FILE_OPEN, GENERIC_READ,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00, &=
fid, &oplock, NULL, cifs_sb->local_nls,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs=
_sb->mnt_cifs_flags &
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0CIFS_MOUNT_MAP_SPECIAL_CHR);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "set POSIX defa=
ult ACL rc %d", rc);
> -#else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "set default PO=
SIX ACL not supported");
> -#endif
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "illegal xattr =
request %s (only user namespace"
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 " suppo=
rted)", ea_name);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB what if no namespace prefix? =
*/
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Should we just pass them to serv=
er, except for
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 system and perhaps security prefixe=
s? */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBGetCIFSACL(xid, tcon, fid=
, &pacl, &buflen);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFSSMBClose(xid, tcon, fid);
> +#endif /* CONFIG_CIFS_EXPERIMENTAL */
> =A0 =A0 =A0 =A0}
>
> -set_ea_exit:
> +out:
> + =A0 =A0 =A0 if (rc =3D=3D -EINVAL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EOPNOTSUPP;
> =A0 =A0 =A0 =A0kfree(full_path);
> +out_free_xid:
> =A0 =A0 =A0 =A0FreeXid(xid);
> -#endif
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> -ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
> - =A0 =A0 =A0 void *ea_value, size_t buf_size)
> +static int
> +cifs_xattr_acl_set(struct dentry *dentry, const char *name,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 const void *value, size_t size, int fla=
gs, int type)
> =A0{
> - =A0 =A0 =A0 ssize_t rc =3D -EOPNOTSUPP;
> -#ifdef CONFIG_CIFS_XATTR
> - =A0 =A0 =A0 int xid;
> - =A0 =A0 =A0 struct cifs_sb_info *cifs_sb;
> - =A0 =A0 =A0 struct cifsTconInfo *pTcon;
> - =A0 =A0 =A0 struct super_block *sb;
> + =A0 =A0 =A0 struct super_block *sb =3D dentry->d_inode->i_sb;
> + =A0 =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(sb);
> + =A0 =A0 =A0 struct cifsTconInfo *tcon =3D cifs_sb->tcon;
> + =A0 =A0 =A0 int rc =3D -EOPNOTSUPP;
> =A0 =A0 =A0 =A0char *full_path;
> + =A0 =A0 =A0 int xid;
>
> - =A0 =A0 =A0 if (direntry =3D=3D NULL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> - =A0 =A0 =A0 if (direntry->d_inode =3D=3D NULL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> - =A0 =A0 =A0 sb =3D direntry->d_inode->i_sb;
> - =A0 =A0 =A0 if (sb =3D=3D NULL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> + =A0 =A0 =A0 if (strcmp(name, "") =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>
> - =A0 =A0 =A0 xid =3D GetXid();
> + =A0 =A0 =A0 /* we do not support removing ACLs */
> + =A0 =A0 =A0 if (!value)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EOPNOTSUPP;
>
> - =A0 =A0 =A0 cifs_sb =3D CIFS_SB(sb);
> - =A0 =A0 =A0 pTcon =3D cifs_sb->tcon;
> + =A0 =A0 =A0 xid =3D GetXid();
>
> - =A0 =A0 =A0 full_path =3D build_path_from_dentry(direntry);
> - =A0 =A0 =A0 if (full_path =3D=3D NULL) {
> + =A0 =A0 =A0 full_path =3D build_path_from_dentry(dentry);
> + =A0 =A0 =A0 if (!full_path) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -ENOMEM;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 FreeXid(xid);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_free_xid;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 /* return dos attributes as pseudo xattr */
> - =A0 =A0 =A0 /* return alt name if available as pseudo attr */
> - =A0 =A0 =A0 if (ea_name =3D=3D NULL) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Null xattr names not supported=
");
> - =A0 =A0 =A0 } else if (strncmp(ea_name, CIFS_XATTR_USER_PREFIX, 5) =
=3D=3D 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUN=
T_NO_XATTR)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto get_ea_exit;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (strncmp(ea_name, CIFS_XATTR_DOS_ATT=
RIB, 14) =3D=3D 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "attempt to que=
ry cifs inode metadata");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* revalidate/getattr t=
hen populate from inode */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 } /* BB add else when above is implemen=
ted */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ea_name +=3D 5; /* skip past user. pref=
ix */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBQAllEAs(xid, pTcon, full_=
path, ea_name, ea_value,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 buf_size, cifs_sb->loca=
l_nls,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags=
 & CIFS_MOUNT_MAP_SPECIAL_CHR);
> - =A0 =A0 =A0 } else if (strncmp(ea_name, CIFS_XATTR_OS2_PREFIX, 4) =3D=
=3D 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUN=
T_NO_XATTR)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto get_ea_exit;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ea_name +=3D 4; /* skip past os2. prefi=
x */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBQAllEAs(xid, pTcon, full_=
path, ea_name, ea_value,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 buf_size, cifs_sb->loca=
l_nls,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags=
 & CIFS_MOUNT_MAP_SPECIAL_CHR);
> - =A0 =A0 =A0 } else if (strncmp(ea_name, POSIX_ACL_XATTR_ACCESS,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 strlen(POSIX_ACL_XA=
TTR_ACCESS)) =3D=3D 0) {
> -#ifdef CONFIG_CIFS_POSIX
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sb->s_flags & MS_POSIXACL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBGetPosixA=
CL(xid, pTcon, full_path,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ea_valu=
e, buf_size, ACL_TYPE_ACCESS,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb=
->local_nls,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb=
->mnt_cifs_flags &
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 CIFS_MOUNT_MAP_SPECIAL_CHR);
> -#ifdef CONFIG_CIFS_EXPERIMENTAL
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (cifs_sb->mnt_cifs_flags & CIFS=
_MOUNT_CIFS_ACL) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u16 fid;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int oplock =3D 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_ntsd *pacl =
=3D NULL;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 buflen =3D 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (experimEnabled)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D =
CIFSSMBOpen(xid, pTcon, full_path,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 FILE_OPEN, GENERIC_READ, 0, &fid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 &oplock, NULL, cifs_sb->local_nls,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 cifs_sb->mnt_cifs_flags &
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 CIFS_MOUNT_MAP_SPECIAL_CHR);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* else rc is EOPNOTSUP=
P from above */
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc =3D=3D 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D =
CIFSSMBGetCIFSACL(xid, pTcon, fid, &pacl,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &buflen);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFSSMB=
Close(xid, pTcon, fid);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> -#endif /* EXPERIMENTAL */
> -#else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "query POSIX ACL not supported =
yet");
> -#endif /* CONFIG_CIFS_POSIX */
> - =A0 =A0 =A0 } else if (strncmp(ea_name, POSIX_ACL_XATTR_DEFAULT,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 strlen(POSIX_ACL_XA=
TTR_DEFAULT)) =3D=3D 0) {
> -#ifdef CONFIG_CIFS_POSIX
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sb->s_flags & MS_POSIXACL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBGetPosixA=
CL(xid, pTcon, full_path,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ea_valu=
e, buf_size, ACL_TYPE_DEFAULT,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb=
->local_nls,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb=
->mnt_cifs_flags &
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 CIFS_MOUNT_MAP_SPECIAL_CHR);
> -#else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "query POSIX default ACL not su=
pported yet");
> -#endif
> - =A0 =A0 =A0 } else if (strncmp(ea_name,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_XATTR_TRUSTED_PREFIX, XATTR_TR=
USTED_PREFIX_LEN) =3D=3D 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Trusted xattr namespace not su=
pported yet");
> - =A0 =A0 =A0 } else if (strncmp(ea_name,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_XATTR_SECURITY_PREFIX, XATTR_S=
ECURITY_PREFIX_LEN) =3D=3D 0) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Security xattr namespace not s=
upported yet");
> - =A0 =A0 =A0 } else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "illegal xattr request %s (only=
 user namespace supported)",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ea_name);
> -
> - =A0 =A0 =A0 /* We could add an additional check for streams ie
> - =A0 =A0 =A0 =A0 =A0 if proc/fs/cifs/streamstoxattr is set then
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 search server for EAs or streams to
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 returns as xattrs */
> + =A0 =A0 =A0 if (size > MAX_EA_VALUE_SIZE) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "size of EA value too large");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EOPNOTSUPP;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_free_path;
> + =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 if (rc =3D=3D -EINVAL)
> + =A0 =A0 =A0 if (!(sb->s_flags & MS_POSIXACL)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EOPNOTSUPP;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_free_path;
> + =A0 =A0 =A0 }
>
> -get_ea_exit:
> + =A0 =A0 =A0 rc =3D CIFSSMBSetPosixACL(xid, tcon, full_path, value, =
size, type,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb=
->local_nls, cifs_sb->mnt_cifs_flags &
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 CIFS_MOUNT_MAP_SPECIAL_CHR);
> +
> +out_free_path:
> =A0 =A0 =A0 =A0kfree(full_path);
> +out_free_xid:
> =A0 =A0 =A0 =A0FreeXid(xid);
> -#endif
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> -ssize_t cifs_listxattr(struct dentry *direntry, char *data, size_t b=
uf_size)
> +static struct xattr_handler cifs_xattr_acl_access_handler =3D {
> + =A0 =A0 =A0 .prefix =3D POSIX_ACL_XATTR_ACCESS,
> + =A0 =A0 =A0 .flags =A0=3D ACL_TYPE_ACCESS,
> + =A0 =A0 =A0 .get =A0 =A0=3D cifs_xattr_acl_get,
> + =A0 =A0 =A0 .set =A0 =A0=3D cifs_xattr_acl_set,
> +};
> +
> +static struct xattr_handler cifs_xattr_acl_default_handler =3D {
> + =A0 =A0 =A0 .prefix =3D POSIX_ACL_XATTR_DEFAULT,
> + =A0 =A0 =A0 .flags =A0=3D ACL_TYPE_DEFAULT,
> + =A0 =A0 =A0 .get =A0 =A0=3D cifs_xattr_acl_get,
> + =A0 =A0 =A0 .set =A0 =A0=3D cifs_xattr_acl_set,
> +};
> +#endif /* CONFIG_CIFS_POSIX */
> +
> +ssize_t cifs_listxattr(struct dentry *dentry, char *data, size_t buf=
_size)
> =A0{
> - =A0 =A0 =A0 ssize_t rc =3D -EOPNOTSUPP;
> -#ifdef CONFIG_CIFS_XATTR
> - =A0 =A0 =A0 int xid;
> - =A0 =A0 =A0 struct cifs_sb_info *cifs_sb;
> - =A0 =A0 =A0 struct cifsTconInfo *pTcon;
> - =A0 =A0 =A0 struct super_block *sb;
> + =A0 =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(dentry->d_inod=
e->i_sb);
> =A0 =A0 =A0 =A0char *full_path;
> -
> - =A0 =A0 =A0 if (direntry =3D=3D NULL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> - =A0 =A0 =A0 if (direntry->d_inode =3D=3D NULL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> - =A0 =A0 =A0 sb =3D direntry->d_inode->i_sb;
> - =A0 =A0 =A0 if (sb =3D=3D NULL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> -
> - =A0 =A0 =A0 cifs_sb =3D CIFS_SB(sb);
> - =A0 =A0 =A0 pTcon =3D cifs_sb->tcon;
> + =A0 =A0 =A0 ssize_t rc;
> + =A0 =A0 =A0 int xid;
>
> =A0 =A0 =A0 =A0if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EOPNOTSUPP;
>
> =A0 =A0 =A0 =A0xid =3D GetXid();
>
> - =A0 =A0 =A0 full_path =3D build_path_from_dentry(direntry);
> + =A0 =A0 =A0 full_path =3D build_path_from_dentry(dentry);
> =A0 =A0 =A0 =A0if (full_path =3D=3D NULL) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -ENOMEM;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 FreeXid(xid);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_free_xid;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 /* return dos attributes as pseudo xattr */
> - =A0 =A0 =A0 /* return alt name if available as pseudo attr */
>
> - =A0 =A0 =A0 /* if proc/fs/cifs/streamstoxattr is set then
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 search server for EAs or streams to
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 returns as xattrs */
> - =A0 =A0 =A0 rc =3D CIFSSMBQAllEAs(xid, pTcon, full_path, NULL, data=
,
> + =A0 =A0 =A0 rc =3D CIFSSMBQAllEAs(xid, cifs_sb->tcon, full_path, NU=
LL, data,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0buf_si=
ze, cifs_sb->local_nls,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_s=
b->mnt_cifs_flags &
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0CIFS_MOUNT_MAP_SPECIAL_CHR);
>
> =A0 =A0 =A0 =A0kfree(full_path);
> +out_free_xid:
> =A0 =A0 =A0 =A0FreeXid(xid);
> -#endif
> =A0 =A0 =A0 =A0return rc;
> =A0}
> +
> +const struct xattr_handler *cifs_xattr_handlers[] =3D {
> + =A0 =A0 =A0 &cifs_xattr_user_handler,
> + =A0 =A0 =A0 &cifs_xattr_os2_handler,
> +#ifdef CONFIG_CIFS_POSIX
> + =A0 =A0 =A0 &cifs_xattr_acl_access_handler,
> + =A0 =A0 =A0 &cifs_xattr_acl_default_handler,
> +#endif
> + =A0 =A0 =A0 NULL
> +};
> Index: linux-2.6/fs/cifs/cifsfs.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/fs/cifs/cifsfs.c =A0 =A0 2010-06-29 16:58:41.65225=
3975 +0200
> +++ linux-2.6/fs/cifs/cifsfs.c =A02010-06-29 16:59:11.108282611 +0200
> @@ -35,6 +35,7 @@
> =A0#include <linux/delay.h>
> =A0#include <linux/kthread.h>
> =A0#include <linux/freezer.h>
> +#include <linux/xattr.h>
> =A0#include <linux/smp_lock.h>
> =A0#include "cifsfs.h"
> =A0#include "cifspdu.h"
> @@ -136,6 +137,9 @@ cifs_read_super(struct super_block *sb,
> =A0 =A0 =A0 =A0sb->s_magic =3D CIFS_MAGIC_NUMBER;
> =A0 =A0 =A0 =A0sb->s_op =3D &cifs_super_ops;
> =A0 =A0 =A0 =A0sb->s_bdi =3D &cifs_sb->bdi;
> +#ifdef CONFIG_CIFS_XATTR
> + =A0 =A0 =A0 sb->s_xattr =3D cifs_xattr_handlers;
> +#endif
> =A0/* =A0 =A0 if (cifs_sb->tcon->ses->server->maxBuf > MAX_CIFS_HDR_S=
IZE + 512)
> =A0 =A0 =A0 =A0 =A0 =A0sb->s_blocksize =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->tcon->ses->server->maxBuf - M=
AX_CIFS_HDR_SIZE; */
> @@ -606,10 +610,10 @@ const struct inode_operations cifs_dir_i
> =A0 =A0 =A0 =A0.symlink =3D cifs_symlink,
> =A0 =A0 =A0 =A0.mknod =A0 =3D cifs_mknod,
> =A0#ifdef CONFIG_CIFS_XATTR
> - =A0 =A0 =A0 .setxattr =3D cifs_setxattr,
> - =A0 =A0 =A0 .getxattr =3D cifs_getxattr,
> + =A0 =A0 =A0 .setxattr =3D generic_setxattr,
> + =A0 =A0 =A0 .getxattr =3D generic_getxattr,
> + =A0 =A0 =A0 .removexattr =3D generic_removexattr,
> =A0 =A0 =A0 =A0.listxattr =3D cifs_listxattr,
> - =A0 =A0 =A0 .removexattr =3D cifs_removexattr,
> =A0#endif
> =A0};
>
> @@ -620,10 +624,10 @@ const struct inode_operations cifs_file_
> =A0 =A0 =A0 =A0.rename =3D cifs_rename,
> =A0 =A0 =A0 =A0.permission =3D cifs_permission,
> =A0#ifdef CONFIG_CIFS_XATTR
> - =A0 =A0 =A0 .setxattr =3D cifs_setxattr,
> - =A0 =A0 =A0 .getxattr =3D cifs_getxattr,
> + =A0 =A0 =A0 .setxattr =3D generic_setxattr,
> + =A0 =A0 =A0 .getxattr =3D generic_getxattr,
> + =A0 =A0 =A0 .removexattr =3D generic_removexattr,
> =A0 =A0 =A0 =A0.listxattr =3D cifs_listxattr,
> - =A0 =A0 =A0 .removexattr =3D cifs_removexattr,
> =A0#endif
> =A0};
>
> @@ -636,10 +640,10 @@ const struct inode_operations cifs_symli
> =A0 =A0 =A0 =A0/* revalidate: cifs_revalidate,
> =A0 =A0 =A0 =A0 =A0 setattr: =A0 =A0cifs_notify_change, *//* BB do we=
 need notify change */
> =A0#ifdef CONFIG_CIFS_XATTR
> - =A0 =A0 =A0 .setxattr =3D cifs_setxattr,
> - =A0 =A0 =A0 .getxattr =3D cifs_getxattr,
> + =A0 =A0 =A0 .setxattr =3D generic_setxattr,
> + =A0 =A0 =A0 .getxattr =3D generic_getxattr,
> + =A0 =A0 =A0 .removexattr =3D generic_removexattr,
> =A0 =A0 =A0 =A0.listxattr =3D cifs_listxattr,
> - =A0 =A0 =A0 .removexattr =3D cifs_removexattr,
> =A0#endif
> =A0};
>
> Index: linux-2.6/fs/cifs/cifsfs.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/fs/cifs/cifsfs.h =A0 =A0 2010-06-29 16:58:41.66425=
4464 +0200
> +++ linux-2.6/fs/cifs/cifsfs.h =A02010-06-29 17:13:38.882284776 +0200
> @@ -103,11 +103,10 @@ extern int cifs_readlink(struct dentry *
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int buflen);
> =A0extern int cifs_symlink(struct inode *inode, struct dentry *dirent=
ry,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const char *symname);
> -extern int =A0 =A0 cifs_removexattr(struct dentry *, const char *);
> -extern int =A0 =A0 cifs_setxattr(struct dentry *, const char *, cons=
t void *,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 size_t, int);
> -extern ssize_t cifs_getxattr(struct dentry *, const char *, void *, =
size_t);
> +
> =A0extern ssize_t cifs_listxattr(struct dentry *, char *, size_t);
> +extern const struct xattr_handler *cifs_xattr_handlers[];
> +
> =A0extern long cifs_ioctl(struct file *filep, unsigned int cmd, unsig=
ned long arg);
>
> =A0#ifdef CONFIG_CIFS_EXPERIMENTAL
>
