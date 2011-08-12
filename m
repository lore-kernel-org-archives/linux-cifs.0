From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Add mount option named backup
Date: Fri, 12 Aug 2011 12:19:21 -0500
Message-ID: <CAH2r5mvyD8zTnUAxyqyYHQW5VqyreP94EDgvhznoJMANL7B8mg@mail.gmail.com>
References: <1313166821-9172-1-git-send-email-shirishpargonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, manoj-6kx38NOBMPqrIzol8Bc5pA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1313166821-9172-1-git-send-email-shirishpargonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Shirish or Manoj,
Could you give a little more detail on the failure scenario
and which files and information can not be accessed?

A mount option may be the only choice, since there is
no equivalent for "open for backup intent" open flag,
and presumably no easy way to query whether a user is a member
of the "backup operators" group, but would a mount option be
a problem for other users of the same mount who don't have
backup operator privilege trying to open other files?

On Fri, Aug 12, 2011 at 11:33 AM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>
> Add mount option backup.
>
> It allows an authenticated user to access files with the intent to ba=
ck them
> up including their ACLs, who may not have access permission but has
> "Backup files and directories user right" on them (by virtue of being=
 part
> of the built-in group Backup Operators.
>
> If an authenticated user is not part of the built-in group Backup Ope=
rators
> at the server, access to such files is denied.
>
>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/cifs_fs_sb.h | =A0 =A01 +
> =A0fs/cifs/cifsacl.c =A0 =A0| =A0 18 +++++++++++++-----
> =A0fs/cifs/cifsglob.h =A0 | =A0 =A04 +++-
> =A0fs/cifs/connect.c =A0 =A0| =A0 =A05 +++++
> =A0fs/cifs/dir.c =A0 =A0 =A0 =A0| =A0 11 +++++++++--
> =A0fs/cifs/file.c =A0 =A0 =A0 | =A0 14 ++++++++++++--
> =A0fs/cifs/link.c =A0 =A0 =A0 | =A0 18 +++++++++++++-----
> =A07 files changed, 56 insertions(+), 15 deletions(-)
>
> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
> index 7260e11..8ba1b44 100644
> --- a/fs/cifs/cifs_fs_sb.h
> +++ b/fs/cifs/cifs_fs_sb.h
> @@ -43,6 +43,7 @@
> =A0#define CIFS_MOUNT_STRICT_IO =A0 0x40000 /* strict cache mode */
> =A0#define CIFS_MOUNT_RWPIDFORWARD =A0 =A0 =A0 =A00x80000 /* use pid =
forwarding for rw */
> =A0#define CIFS_MOUNT_POSIXACL =A0 =A00x100000 /* mirror of MS_POSIXA=
CL in mnt_cifs_flags */
> +#define CIFS_MOUNT_CIFS_BACKUP 0x200000 /* open file with backup int=
ent bit */
>
> =A0struct cifs_sb_info {
> =A0 =A0 =A0 =A0struct rb_root tlink_tree;
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index d0f59fa..24bc2dd 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -945,7 +945,7 @@ static struct cifs_ntsd *get_cifs_acl_by_path(str=
uct cifs_sb_info *cifs_sb,
> =A0{
> =A0 =A0 =A0 =A0struct cifs_ntsd *pntsd =3D NULL;
> =A0 =A0 =A0 =A0int oplock =3D 0;
> - =A0 =A0 =A0 int xid, rc;
> + =A0 =A0 =A0 int xid, rc, create_options =3D 0;
> =A0 =A0 =A0 =A0__u16 fid;
> =A0 =A0 =A0 =A0struct cifs_tcon *tcon;
> =A0 =A0 =A0 =A0struct tcon_link *tlink =3D cifs_sb_tlink(cifs_sb);
> @@ -956,9 +956,13 @@ static struct cifs_ntsd *get_cifs_acl_by_path(st=
ruct cifs_sb_info *cifs_sb,
> =A0 =A0 =A0 =A0tcon =3D tlink_tcon(tlink);
> =A0 =A0 =A0 =A0xid =3D GetXid();
>
> - =A0 =A0 =A0 rc =3D CIFSSMBOpen(xid, tcon, path, FILE_OPEN, READ_CON=
TROL, 0,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&fid, &oplock, NULL,=
 cifs_sb->local_nls,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->mnt_cifs_fl=
ags & CIFS_MOUNT_MAP_SPECIAL_CHR);
> + =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags=
 & CIFS_MOUNT_CIFS_BACKUP)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 create_options |=3D CREATE_OPEN_BACKUP_=
INTENT;
> +
> + =A0 =A0 =A0 rc =3D CIFSSMBOpen(xid, tcon, path, FILE_OPEN, READ_CON=
TROL,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 create_options, &fid, &=
oplock, NULL, cifs_sb->local_nls,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags=
 & CIFS_MOUNT_MAP_SPECIAL_CHR);
> =A0 =A0 =A0 =A0if (!rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBGetCIFSACL(xid, tcon, fi=
d, &pntsd, pacllen);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFSSMBClose(xid, tcon, fid);
> @@ -995,7 +999,7 @@ static int set_cifs_acl_by_path(struct cifs_sb_in=
fo *cifs_sb, const char *path,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct cifs_ntsd *pnntsd, u32 acllen)
> =A0{
> =A0 =A0 =A0 =A0int oplock =3D 0;
> - =A0 =A0 =A0 int xid, rc;
> + =A0 =A0 =A0 int xid, rc, create_options =3D 0;
> =A0 =A0 =A0 =A0__u16 fid;
> =A0 =A0 =A0 =A0struct cifs_tcon *tcon;
> =A0 =A0 =A0 =A0struct tcon_link *tlink =3D cifs_sb_tlink(cifs_sb);
> @@ -1006,6 +1010,10 @@ static int set_cifs_acl_by_path(struct cifs_sb=
_info *cifs_sb, const char *path,
> =A0 =A0 =A0 =A0tcon =3D tlink_tcon(tlink);
> =A0 =A0 =A0 =A0xid =3D GetXid();
>
> + =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags=
 & CIFS_MOUNT_CIFS_BACKUP)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 create_options |=3D CREATE_OPEN_BACKUP_=
INTENT;
> +
> =A0 =A0 =A0 =A0rc =3D CIFSSMBOpen(xid, tcon, path, FILE_OPEN, WRITE_D=
AC, 0,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &fid, &oplock, NULL, =
cifs_sb->local_nls,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_fla=
gs & CIFS_MOUNT_MAP_SPECIAL_CHR);
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 95dad9d..3c6fd56 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -179,6 +179,7 @@ struct smb_vol {
> =A0 =A0 =A0 =A0bool noperm:1;
> =A0 =A0 =A0 =A0bool no_psx_acl:1; /* set if posix acl support should =
be disabled */
> =A0 =A0 =A0 =A0bool cifs_acl:1;
> + =A0 =A0 =A0 bool cifs_backup:1; /* to indicates backup intent durin=
g file open */
> =A0 =A0 =A0 =A0bool no_xattr:1; =A0 /* set if xattr (EA) support shou=
ld be disabled*/
> =A0 =A0 =A0 =A0bool server_ino:1; /* use inode numbers from server ie=
 UniqueId */
> =A0 =A0 =A0 =A0bool direct_io:1;
> @@ -219,7 +220,8 @@ struct smb_vol {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_MOUNT_OVERR_GID =
| CIFS_MOUNT_DYNPERM | \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_MOUNT_NOPOSIXBRL=
 | CIFS_MOUNT_NOSSYNC | \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_MOUNT_FSCACHE | =
CIFS_MOUNT_MF_SYMLINKS | \
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_MOUNT_MULTIUSER=
 | CIFS_MOUNT_STRICT_IO)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_MOUNT_MULTIUSER=
 | CIFS_MOUNT_STRICT_IO | \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_MOUNT_CIFS_BACK=
UP)
>
> =A0#define CIFS_MS_MASK (MS_RDONLY | MS_MANDLOCK | MS_NOEXEC | MS_NOS=
UID | \
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0MS_NODEV | MS_SYNCHRONOUS)
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 80c2e3a..352d6d6 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -883,6 +883,7 @@ cifs_parse_mount_options(const char *mountdata, c=
onst char *devname,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Null separato=
r not allowed");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 vol->cifs_backup =3D 0; /* no backup intent */
>
> =A0 =A0 =A0 =A0while ((data =3D strsep(&options, separator)) !=3D NUL=
L) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!*data)
> @@ -1405,6 +1406,8 @@ cifs_parse_mount_options(const char *mountdata,=
 const char *devname,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0vol->rwpidforward =3D =
1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (strnicmp(data, "cifsacl", 7=
) =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0vol->cifs_acl =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (strnicmp(data, "backup", 7) =
=3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->cifs_backup =3D 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (strnicmp(data, "nocifsacl",=
 9) =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0vol->cifs_acl =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (strnicmp(data, "acl", 3) =3D=
=3D 0) {
> @@ -2763,6 +2766,8 @@ void cifs_setup_cifs_sb(struct smb_vol *pvolume=
_info,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->mnt_cifs_flags |=3D CIFS_MOUN=
T_RWPIDFORWARD;
> =A0 =A0 =A0 =A0if (pvolume_info->cifs_acl)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->mnt_cifs_flags |=3D CIFS_MOUN=
T_CIFS_ACL;
> + =A0 =A0 =A0 if (pvolume_info->cifs_backup)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags |=3D CIFS_MOUNT=
_CIFS_BACKUP;
> =A0 =A0 =A0 =A0if (pvolume_info->override_uid)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->mnt_cifs_flags |=3D CIFS_MOUN=
T_OVERR_UID;
> =A0 =A0 =A0 =A0if (pvolume_info->override_gid)
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index ae576fb..fbecde6 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -243,6 +243,9 @@ cifs_create(struct inode *inode, struct dentry *d=
irentry, int mode,
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0if (!tcon->unix_ext && (mode & S_IWUGO) =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0create_options |=3D CREATE_OPTION_READ=
ONLY;
> + =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags=
 & CIFS_MOUNT_CIFS_BACKUP)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 create_options |=3D CREATE_OPEN_BACKUP_=
INTENT;
>
> =A0 =A0 =A0 =A0if (tcon->ses->capabilities & CAP_NT_SMBS)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBOpen(xid, tcon, full_pat=
h, disposition,
> @@ -357,6 +360,7 @@ int cifs_mknod(struct inode *inode, struct dentry=
 *direntry, int mode,
> =A0{
> =A0 =A0 =A0 =A0int rc =3D -EPERM;
> =A0 =A0 =A0 =A0int xid;
> + =A0 =A0 =A0 int create_options =3D CREATE_NOT_DIR | CREATE_OPTION_S=
PECIAL;
> =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb;
> =A0 =A0 =A0 =A0struct tcon_link *tlink;
> =A0 =A0 =A0 =A0struct cifs_tcon *pTcon;
> @@ -431,9 +435,12 @@ int cifs_mknod(struct inode *inode, struct dentr=
y *direntry, int mode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 /* FIXME: would WRITE_OWNER | WRITE_DAC be better? */
> + =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags=
 & CIFS_MOUNT_CIFS_BACKUP)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 create_options |=3D CREATE_OPEN_BACKUP_=
INTENT;
> +
> =A0 =A0 =A0 =A0rc =3D CIFSSMBOpen(xid, pTcon, full_path, FILE_CREATE,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0GENERIC_WRITE, CREAT=
E_NOT_DIR | CREATE_OPTION_SPECIAL,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0GENERIC_WRITE, creat=
e_options,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &fileHandle, &oplock,=
 buf, cifs_sb->local_nls,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_fla=
gs & CIFS_MOUNT_MAP_SPECIAL_CHR);
> =A0 =A0 =A0 =A0if (rc)
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 9f41a10..39b06c4 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -174,6 +174,7 @@ cifs_nt_open(char *full_path, struct inode *inode=
, struct cifs_sb_info *cifs_sb,
> =A0 =A0 =A0 =A0int rc;
> =A0 =A0 =A0 =A0int desiredAccess;
> =A0 =A0 =A0 =A0int disposition;
> + =A0 =A0 =A0 int create_options =3D CREATE_NOT_DIR;
> =A0 =A0 =A0 =A0FILE_ALL_INFO *buf;
>
> =A0 =A0 =A0 =A0desiredAccess =3D cifs_convert_flags(f_flags);
> @@ -210,9 +211,13 @@ cifs_nt_open(char *full_path, struct inode *inod=
e, struct cifs_sb_info *cifs_sb,
> =A0 =A0 =A0 =A0if (!buf)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOMEM;
>
> + =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags=
 & CIFS_MOUNT_CIFS_BACKUP)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 create_options |=3D CREATE_OPEN_BACKUP_=
INTENT;
> +
> =A0 =A0 =A0 =A0if (tcon->ses->capabilities & CAP_NT_SMBS)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBOpen(xid, tcon, full_pat=
h, disposition,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0desiredAccess, CREAT=
E_NOT_DIR, pnetfid, poplock, buf,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0desiredAccess, creat=
e_options, pnetfid, poplock, buf,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->local_nls, c=
ifs_sb->mnt_cifs_flags
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 & CIF=
S_MOUNT_MAP_SPECIAL_CHR);
> =A0 =A0 =A0 =A0else
> @@ -465,6 +470,7 @@ static int cifs_reopen_file(struct cifsFileInfo *=
pCifsFile, bool can_flush)
> =A0 =A0 =A0 =A0char *full_path =3D NULL;
> =A0 =A0 =A0 =A0int desiredAccess;
> =A0 =A0 =A0 =A0int disposition =3D FILE_OPEN;
> + =A0 =A0 =A0 int create_options =3D CREATE_NOT_DIR;
> =A0 =A0 =A0 =A0__u16 netfid;
>
> =A0 =A0 =A0 =A0xid =3D GetXid();
> @@ -524,6 +530,10 @@ static int cifs_reopen_file(struct cifsFileInfo =
*pCifsFile, bool can_flush)
>
> =A0 =A0 =A0 =A0desiredAccess =3D cifs_convert_flags(pCifsFile->f_flag=
s);
>
> + =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags=
 & CIFS_MOUNT_CIFS_BACKUP)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 create_options |=3D CREATE_OPEN_BACKUP_=
INTENT;
> +
> =A0 =A0 =A0 =A0/* Can not refresh inode by passing in file_info buf t=
o be returned
> =A0 =A0 =A0 =A0 =A0 by SMBOpen and then calling get_inode_info with r=
eturned buf
> =A0 =A0 =A0 =A0 =A0 since file might have write behind data that need=
s to be flushed
> @@ -531,7 +541,7 @@ static int cifs_reopen_file(struct cifsFileInfo *=
pCifsFile, bool can_flush)
> =A0 =A0 =A0 =A0 =A0 that inode was not dirty locally we could do this=
 */
>
> =A0 =A0 =A0 =A0rc =3D CIFSSMBOpen(xid, tcon, full_path, disposition, =
desiredAccess,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CREATE_NOT_DIR, &net=
fid, &oplock, NULL,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0create_options, &net=
fid, &oplock, NULL,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->local_nls, c=
ifs_sb->mnt_cifs_flags &
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_M=
OUNT_MAP_SPECIAL_CHR);
> =A0 =A0 =A0 =A0if (rc) {
> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
> index db3f18c..67e51b8 100644
> --- a/fs/cifs/link.c
> +++ b/fs/cifs/link.c
> @@ -183,14 +183,20 @@ CIFSFormatMFSymlink(u8 *buf, unsigned int buf_l=
en, const char *link_str)
> =A0static int
> =A0CIFSCreateMFSymLink(const int xid, struct cifs_tcon *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const char *fromName, const ch=
ar *toName,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *nls_cod=
epage, int remap)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_sb_info *cifs_sb)
> =A0{
> =A0 =A0 =A0 =A0int rc;
> =A0 =A0 =A0 =A0int oplock =3D 0;
> + =A0 =A0 =A0 int remap;
> + =A0 =A0 =A0 int create_options =3D CREATE_NOT_DIR;
> =A0 =A0 =A0 =A0__u16 netfid =3D 0;
> =A0 =A0 =A0 =A0u8 *buf;
> =A0 =A0 =A0 =A0unsigned int bytes_written =3D 0;
> =A0 =A0 =A0 =A0struct cifs_io_parms io_parms;
> + =A0 =A0 =A0 struct nls_table *nls_codepage;
> +
> + =A0 =A0 =A0 nls_codepage =3D cifs_sb->local_nls;
> + =A0 =A0 =A0 remap =3D cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPEC=
IAL_CHR;
>
> =A0 =A0 =A0 =A0buf =3D kmalloc(CIFS_MF_SYMLINK_FILE_SIZE, GFP_KERNEL)=
;
> =A0 =A0 =A0 =A0if (!buf)
> @@ -202,8 +208,12 @@ CIFSCreateMFSymLink(const int xid, struct cifs_t=
con *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags=
 & CIFS_MOUNT_CIFS_BACKUP)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 create_options |=3D CREATE_OPEN_BACKUP_=
INTENT;
> +
> =A0 =A0 =A0 =A0rc =3D CIFSSMBOpen(xid, tcon, fromName, FILE_CREATE, G=
ENERIC_WRITE,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CREATE_NOT_DIR, &net=
fid, &oplock, NULL,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0create_options, &net=
fid, &oplock, NULL,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nls_codepage, remap);
> =A0 =A0 =A0 =A0if (rc !=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kfree(buf);
> @@ -559,9 +569,7 @@ cifs_symlink(struct inode *inode, struct dentry *=
direntry, const char *symname)
> =A0 =A0 =A0 =A0/* BB what if DFS and this volume is on different shar=
e? BB */
> =A0 =A0 =A0 =A0if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSCreateMFSymLink(xid, pTcon,=
 full_path, symname,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0cifs_sb->local_nls,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0cifs_sb->mnt_cifs_flags &
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_MOUNT_MAP_SPECIAL_CHR);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 cifs_sb);
> =A0 =A0 =A0 =A0else if (pTcon->unix_ext)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSUnixCreateSymLink(xid, pTco=
n, full_path, symname,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 cifs_sb->local_nls);
> --
> 1.6.0.2
>
>



--=20
Thanks,

Steve
