From: Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH] CIFS: remove local xattr definitions
Date: Thu, 11 Aug 2011 15:29:34 -0400
Message-ID: <CACLa4ptNaOvwFX-2VPBve=PBvnB7X85tzTnTPSLtprbT8vSGgw@mail.gmail.com>
References: <1313090079-25859-1-git-send-email-zohar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
	David Safford <safford@watson.ibm.com>,
	Mimi Zohar <zohar@us.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1313090079-25859-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Not that this patch is wrong, but shouldn't cifs include xattr.h
directly rather than rely on such an obscure indirect callchain as
well?

-Eric

On Thu, Aug 11, 2011 at 3:14 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> =
wrote:
> Local XATTR_TRUSTED_PREFIX_LEN and XATTR_SECURITY_PREFIX_LEN definiti=
ons
> redefined ones in 'linux/xattr.h'. This was caused by commit 9d8f13ba=
3f48
> ("security: new security_inode_init_security API adds function callba=
ck")
> including 'linux/xattr.h' in 'linux/security.h'.
>
> In file included from include/linux/security.h:39,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 from include/net/sock.h:54,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 from fs/cifs/cifspdu.h:25,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 from fs/cifs/xattr.c:26:
>
> This patch removes the local definitions.
>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> ---
> =A0fs/cifs/xattr.c | =A0 39 +++++++++++++++++----------------------
> =A01 files changed, 17 insertions(+), 22 deletions(-)
>
> diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
> index 2a22fb2..7f23f3c 100644
> --- a/fs/cifs/xattr.c
> +++ b/fs/cifs/xattr.c
> @@ -31,16 +31,8 @@
> =A0#define MAX_EA_VALUE_SIZE 65535
> =A0#define CIFS_XATTR_DOS_ATTRIB "user.DosAttrib"
> =A0#define CIFS_XATTR_CIFS_ACL "system.cifs_acl"
> -#define CIFS_XATTR_USER_PREFIX "user."
> -#define CIFS_XATTR_SYSTEM_PREFIX "system."
> -#define CIFS_XATTR_OS2_PREFIX "os2."
> -#define CIFS_XATTR_SECURITY_PREFIX "security."
> -#define CIFS_XATTR_TRUSTED_PREFIX "trusted."
> -#define XATTR_TRUSTED_PREFIX_LEN =A08
> -#define XATTR_SECURITY_PREFIX_LEN 9
> -/* BB need to add server (Samba e.g) support for security and truste=
d prefix */
> -
>
> +/* BB need to add server (Samba e.g) support for security and truste=
d prefix */
>
> =A0int cifs_removexattr(struct dentry *direntry, const char *ea_name)
> =A0{
> @@ -76,8 +68,8 @@ int cifs_removexattr(struct dentry *direntry, const=
 char *ea_name)
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0if (ea_name =3D=3D NULL) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Null xattr names not supporte=
d");
> - =A0 =A0 =A0 } else if (strncmp(ea_name, CIFS_XATTR_USER_PREFIX, 5)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 && (strncmp(ea_name, CIFS_XATTR_OS2_PRE=
=46IX, 4))) {
> + =A0 =A0 =A0 } else if (strncmp(ea_name, XATTR_USER_PREFIX, XATTR_US=
ER_PREFIX_LEN)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 && (strncmp(ea_name, XATTR_OS2_PREFIX, =
XATTR_OS2_PREFIX_LEN))) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "illegal xattr request %s (on=
ly user namespace supported)",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ea_name);
> @@ -88,7 +80,7 @@ int cifs_removexattr(struct dentry *direntry, const=
 char *ea_name)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (cifs_sb->mnt_cifs_flags & CIFS_MOU=
NT_NO_XATTR)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto remove_ea_exit;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ea_name +=3D 5; /* skip past user. pref=
ix */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ea_name +=3D XATTR_USER_PREFIX_LEN; /* =
skip past user. prefix */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBSetEA(xid, pTcon, full_p=
ath, ea_name, NULL,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(__u16)0, cifs_sb->loc=
al_nls,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->mnt_cifs_flag=
s & CIFS_MOUNT_MAP_SPECIAL_CHR);
> @@ -149,21 +141,23 @@ int cifs_setxattr(struct dentry *direntry, cons=
t char *ea_name,
>
> =A0 =A0 =A0 =A0if (ea_name =3D=3D NULL) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Null xattr names not supporte=
d");
> - =A0 =A0 =A0 } else if (strncmp(ea_name, CIFS_XATTR_USER_PREFIX, 5) =
=3D=3D 0) {
> + =A0 =A0 =A0 } else if (strncmp(ea_name, XATTR_USER_PREFIX, XATTR_US=
ER_PREFIX_LEN)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (cifs_sb->mnt_cifs_flags & CIFS_MOU=
NT_NO_XATTR)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto set_ea_exit;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (strncmp(ea_name, CIFS_XATTR_DOS_AT=
TRIB, 14) =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "attempt to se=
t cifs inode metadata");
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ea_name +=3D 5; /* skip past user. pref=
ix */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ea_name +=3D XATTR_USER_PREFIX_LEN; /* =
skip past user. prefix */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBSetEA(xid, pTcon, full_p=
ath, ea_name, ea_value,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(__u16)value_size, cif=
s_sb->local_nls,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->mnt_cifs_flag=
s & CIFS_MOUNT_MAP_SPECIAL_CHR);
> - =A0 =A0 =A0 } else if (strncmp(ea_name, CIFS_XATTR_OS2_PREFIX, 4) =3D=
=3D 0) {
> + =A0 =A0 =A0 } else if (strncmp(ea_name, XATTR_OS2_PREFIX, XATTR_OS2=
_PREFIX_LEN)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (cifs_sb->mnt_cifs_flags & CIFS_MOU=
NT_NO_XATTR)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto set_ea_exit;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ea_name +=3D 4; /* skip past os2. prefi=
x */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ea_name +=3D XATTR_OS2_PREFIX_LEN; /* s=
kip past os2. prefix */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBSetEA(xid, pTcon, full_p=
ath, ea_name, ea_value,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(__u16)value_size, cif=
s_sb->local_nls,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->mnt_cifs_flag=
s & CIFS_MOUNT_MAP_SPECIAL_CHR);
> @@ -269,7 +263,8 @@ ssize_t cifs_getxattr(struct dentry *direntry, co=
nst char *ea_name,
> =A0 =A0 =A0 =A0/* return alt name if available as pseudo attr */
> =A0 =A0 =A0 =A0if (ea_name =3D=3D NULL) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Null xattr names not supporte=
d");
> - =A0 =A0 =A0 } else if (strncmp(ea_name, CIFS_XATTR_USER_PREFIX, 5) =
=3D=3D 0) {
> + =A0 =A0 =A0 } else if (strncmp(ea_name, XATTR_USER_PREFIX, XATTR_US=
ER_PREFIX_LEN)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (cifs_sb->mnt_cifs_flags & CIFS_MOU=
NT_NO_XATTR)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto get_ea_exit;
>
> @@ -277,15 +272,15 @@ ssize_t cifs_getxattr(struct dentry *direntry, =
const char *ea_name,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "attempt to qu=
ery cifs inode metadata");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* revalidate/getattr =
then populate from inode */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} /* BB add else when above is impleme=
nted */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ea_name +=3D 5; /* skip past user. pref=
ix */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ea_name +=3D XATTR_USER_PREFIX_LEN; /* =
skip past user. prefix */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBQAllEAs(xid, pTcon, full=
_path, ea_name, ea_value,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0buf_size, cifs_sb->loc=
al_nls,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->mnt_cifs_flag=
s & CIFS_MOUNT_MAP_SPECIAL_CHR);
> - =A0 =A0 =A0 } else if (strncmp(ea_name, CIFS_XATTR_OS2_PREFIX, 4) =3D=
=3D 0) {
> + =A0 =A0 =A0 } else if (strncmp(ea_name, XATTR_OS2_PREFIX, XATTR_OS2=
_PREFIX_LEN) =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (cifs_sb->mnt_cifs_flags & CIFS_MOU=
NT_NO_XATTR)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto get_ea_exit;
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ea_name +=3D 4; /* skip past os2. prefi=
x */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ea_name +=3D XATTR_OS2_PREFIX_LEN; /* s=
kip past os2. prefix */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBQAllEAs(xid, pTcon, full=
_path, ea_name, ea_value,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0buf_size, cifs_sb->loc=
al_nls,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->mnt_cifs_flag=
s & CIFS_MOUNT_MAP_SPECIAL_CHR);
> @@ -339,10 +334,10 @@ ssize_t cifs_getxattr(struct dentry *direntry, =
const char *ea_name,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Query CIFS ACL not supported =
yet");
> =A0#endif /* CONFIG_CIFS_ACL */
> =A0 =A0 =A0 =A0} else if (strncmp(ea_name,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_XATTR_TRUSTED_PREFIX, XATTR_TR=
USTED_PREFIX_LEN) =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 XATTR_TRUSTED_PREFIX, XATTR_TRUSTED=
_PREFIX_LEN) =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Trusted xattr namespace not s=
upported yet");
> =A0 =A0 =A0 =A0} else if (strncmp(ea_name,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_XATTR_SECURITY_PREFIX, XATTR_S=
ECURITY_PREFIX_LEN) =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 XATTR_SECURITY_PREFIX, XATTR_SECURI=
TY_PREFIX_LEN) =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Security xattr namespace not =
supported yet");
> =A0 =A0 =A0 =A0} else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1,
> --
> 1.7.3.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/
>
--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
