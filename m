From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: Add mount options for backup intent [try #2]
Date: Wed, 21 Sep 2011 08:43:47 -0400
Message-ID: <20110921084347.13f7c140@corrin.poochiereds.net>
References: <1316543210-12069-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110921074345.5d007d2c@corrin.poochiereds.net>
	<CADT32eL6EKoVeU9513bLG4p2bdYfcm3o1Lkg-i8vX=bd-X2f-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eL6EKoVeU9513bLG4p2bdYfcm3o1Lkg-i8vX=bd-X2f-Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 21 Sep 2011 07:35:06 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Sep 21, 2011 at 6:43 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
> > On Tue, 20 Sep 2011 13:26:50 -0500
> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >
> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >>
> >> Add mount options backupuid and backugid.
> >>
> >> It allows an authenticated user to access files with the intent to=
 back them
> >> up including their ACLs, who may not have access permission but ha=
s
> >> "Backup files and directories user right" on them (by virtue of be=
ing part
> >> of the built-in group Backup Operators.
> >>
> >> When mount options backupuid is specified, cifs client restricts t=
he
> >> use of backup intents to the user whose effective user id is speci=
fied
> >> along with the mount option.
> >>
> >> When mount options backupgid is specified, cifs client restricts t=
he
> >> use of backup intents to the users whose effective user id belongs=
 to the
> >> group id specified along with the mount option.
> >>
> >> These mount options are mutually excluisve to mount option =A0muli=
tuser.
> >>
> >> If an authenticated user is not part of the built-in group Backup =
Operators
> >> at the server, access to such files is denied, even if allowed by =
the client.
> >>
> >>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =A0fs/cifs/cifs_fs_sb.h | =A0 =A03 +++
> >> =A0fs/cifs/cifsacl.c =A0 =A0| =A0 23 ++++++++++++++++++-----
> >> =A0fs/cifs/cifsglob.h =A0 | =A0 =A06 +++++-
> >> =A0fs/cifs/connect.c =A0 =A0| =A0 14 ++++++++++++++
> >> =A0fs/cifs/dir.c =A0 =A0 =A0 =A0| =A0 22 +++++++++++++++++++---
> >> =A0fs/cifs/file.c =A0 =A0 =A0 | =A0 24 ++++++++++++++++++++++--
> >> =A0fs/cifs/link.c =A0 =A0 =A0 | =A0 23 ++++++++++++++++++-----
> >> =A07 files changed, 99 insertions(+), 16 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
> >> index 7260e11..f5483c8 100644
> >> --- a/fs/cifs/cifs_fs_sb.h
> >> +++ b/fs/cifs/cifs_fs_sb.h
> >> @@ -43,6 +43,7 @@
> >> =A0#define CIFS_MOUNT_STRICT_IO 0x40000 /* strict cache mode */
> >> =A0#define CIFS_MOUNT_RWPIDFORWARD =A0 =A0 =A00x80000 /* use pid f=
orwarding for rw */
> >> =A0#define CIFS_MOUNT_POSIXACL =A00x100000 /* mirror of MS_POSIXAC=
L in mnt_cifs_flags */
> >> +#define CIFS_MOUNT_CIFS_BACKUP =A0 =A0 =A0 0x200000 /* open file =
with backup intent bit */
> >>
> >> =A0struct cifs_sb_info {
> >> =A0 =A0 =A0 struct rb_root tlink_tree;
> >> @@ -55,6 +56,8 @@ struct cifs_sb_info {
> >> =A0 =A0 =A0 atomic_t active;
> >> =A0 =A0 =A0 uid_t =A0 mnt_uid;
> >> =A0 =A0 =A0 gid_t =A0 mnt_gid;
> >> + =A0 =A0 uid_t =A0 mnt_backupuid;
> >> + =A0 =A0 gid_t =A0 mnt_backupgid;
> >> =A0 =A0 =A0 mode_t =A0mnt_file_mode;
> >> =A0 =A0 =A0 mode_t =A0mnt_dir_mode;
> >> =A0 =A0 =A0 unsigned int mnt_cifs_flags;
> >> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> >> index d0f59fa..a0af87a 100644
> >> --- a/fs/cifs/cifsacl.c
> >> +++ b/fs/cifs/cifsacl.c
> >> @@ -945,7 +945,7 @@ static struct cifs_ntsd *get_cifs_acl_by_path(=
struct cifs_sb_info *cifs_sb,
> >> =A0{
> >> =A0 =A0 =A0 struct cifs_ntsd *pntsd =3D NULL;
> >> =A0 =A0 =A0 int oplock =3D 0;
> >> - =A0 =A0 int xid, rc;
> >> + =A0 =A0 int xid, rc, create_options =3D 0;
> >> =A0 =A0 =A0 __u16 fid;
> >> =A0 =A0 =A0 struct cifs_tcon *tcon;
> >> =A0 =A0 =A0 struct tcon_link *tlink =3D cifs_sb_tlink(cifs_sb);
> >> @@ -956,9 +956,18 @@ static struct cifs_ntsd *get_cifs_acl_by_path=
(struct cifs_sb_info *cifs_sb,
> >> =A0 =A0 =A0 tcon =3D tlink_tcon(tlink);
> >> =A0 =A0 =A0 xid =3D GetXid();
> >>
> >> - =A0 =A0 rc =3D CIFSSMBOpen(xid, tcon, path, FILE_OPEN, READ_CONT=
ROL, 0,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&fid, &oplock, NULL, =
cifs_sb->local_nls,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->mnt_cifs_fla=
gs & CIFS_MOUNT_MAP_SPECIAL_CHR);
> >> + =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL &&
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags =
& CIFS_MOUNT_CIFS_BACKUP) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if ((cifs_sb->mnt_backupuid !=3D NO_CHAN=
GE_32 &&
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb-=
>mnt_backupuid =3D=3D current_euid()) ||
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (cifs_sb->mnt_backupgid =
!=3D NO_CHANGE_32 &&
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 in_group_p(cifs_sb->mnt_backupgid)))
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 create_o=
ptions |=3D CREATE_OPEN_BACKUP_INTENT;
> >> + =A0 =A0 }
> >> +
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^^^^
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Ugh, please put the ugliness above i=
n a helper
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0function. Maybe something like:
> >
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (backup_cred(cifs_sb))
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0create_options |=3D =
CREATE_OPEN_BACKUP_INTENT;
> >
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Also, why is this dependent on CIFS_=
MOUNT_CIFS_ACL?
> >
> >> + =A0 =A0 rc =3D CIFSSMBOpen(xid, tcon, path, FILE_OPEN, READ_CONT=
ROL,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 create_options, &fid, &o=
plock, NULL, cifs_sb->local_nls,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags =
& CIFS_MOUNT_MAP_SPECIAL_CHR);
> >> =A0 =A0 =A0 if (!rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBGetCIFSACL(xid, tcon, fi=
d, &pntsd, pacllen);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFSSMBClose(xid, tcon, fid);
> >> @@ -995,7 +1004,7 @@ static int set_cifs_acl_by_path(struct cifs_s=
b_info *cifs_sb, const char *path,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_ntsd *pnntsd, u32 acllen)
> >> =A0{
> >> =A0 =A0 =A0 int oplock =3D 0;
> >> - =A0 =A0 int xid, rc;
> >> + =A0 =A0 int xid, rc, create_options =3D 0;
> >> =A0 =A0 =A0 __u16 fid;
> >> =A0 =A0 =A0 struct cifs_tcon *tcon;
> >> =A0 =A0 =A0 struct tcon_link *tlink =3D cifs_sb_tlink(cifs_sb);
> >> @@ -1006,6 +1015,10 @@ static int set_cifs_acl_by_path(struct cifs=
_sb_info *cifs_sb, const char *path,
> >> =A0 =A0 =A0 tcon =3D tlink_tcon(tlink);
> >> =A0 =A0 =A0 xid =3D GetXid();
> >>
> >> + =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL &&
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags =
& CIFS_MOUNT_CIFS_BACKUP)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 create_options |=3D CREATE_OPEN_BACKUP_I=
NTENT;
> >> +
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^^
> > =A0 =A0 =A0 =A0Why aren't you checking the user/group here?
> >
> >> =A0 =A0 =A0 rc =3D CIFSSMBOpen(xid, tcon, path, FILE_OPEN, WRITE_D=
AC, 0,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&fid, &oplock, NULL=
, cifs_sb->local_nls,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->mnt_cifs_f=
lags & CIFS_MOUNT_MAP_SPECIAL_CHR);
> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >> index 95dad9d..cd0d7fa 100644
> >> --- a/fs/cifs/cifsglob.h
> >> +++ b/fs/cifs/cifsglob.h
> >> @@ -167,6 +167,8 @@ struct smb_vol {
> >> =A0 =A0 =A0 uid_t cred_uid;
> >> =A0 =A0 =A0 uid_t linux_uid;
> >> =A0 =A0 =A0 gid_t linux_gid;
> >> + =A0 =A0 uid_t backupuid;
> >> + =A0 =A0 gid_t backupgid;
> >> =A0 =A0 =A0 mode_t file_mode;
> >> =A0 =A0 =A0 mode_t dir_mode;
> >> =A0 =A0 =A0 unsigned secFlg;
> >> @@ -179,6 +181,7 @@ struct smb_vol {
> >> =A0 =A0 =A0 bool noperm:1;
> >> =A0 =A0 =A0 bool no_psx_acl:1; /* set if posix acl support should =
be disabled */
> >> =A0 =A0 =A0 bool cifs_acl:1;
> >> + =A0 =A0 bool cifs_backup:1; /* to indicates backup intent during=
 file open */
> >> =A0 =A0 =A0 bool no_xattr:1; =A0 /* set if xattr (EA) support shou=
ld be disabled*/
> >> =A0 =A0 =A0 bool server_ino:1; /* use inode numbers from server ie=
 UniqueId */
> >> =A0 =A0 =A0 bool direct_io:1;
> >> @@ -219,7 +222,8 @@ struct smb_vol {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_MOUNT_OVERR_GI=
D | CIFS_MOUNT_DYNPERM | \
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_MOUNT_NOPOSIXB=
RL | CIFS_MOUNT_NOSSYNC | \
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_MOUNT_FSCACHE =
| CIFS_MOUNT_MF_SYMLINKS | \
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_MOUNT_MULTIUSER =
| CIFS_MOUNT_STRICT_IO)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_MOUNT_MULTIUSER =
| CIFS_MOUNT_STRICT_IO | \
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_MOUNT_CIFS_BACKU=
P)
> >>
> >> =A0#define CIFS_MS_MASK (MS_RDONLY | MS_MANDLOCK | MS_NOEXEC | MS_=
NOSUID | \
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MS_NODEV | MS_SYNCHRONOUS)
> >> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >> index f4af4cc..a56624a 100644
> >> --- a/fs/cifs/connect.c
> >> +++ b/fs/cifs/connect.c
> >> @@ -854,6 +854,8 @@ cifs_parse_mount_options(const char *mountdata=
, const char *devname,
> >> =A0 =A0 =A0 vol->cred_uid =3D current_uid();
> >> =A0 =A0 =A0 vol->linux_uid =3D current_uid();
> >> =A0 =A0 =A0 vol->linux_gid =3D current_gid();
> >> + =A0 =A0 vol->backupuid =3D NO_CHANGE_32;
> >> + =A0 =A0 vol->backupgid =3D NO_CHANGE_32;
> >>
> >> =A0 =A0 =A0 /* default to only allowing write access to owner of t=
he mount */
> >> =A0 =A0 =A0 vol->dir_mode =3D vol->file_mode =3D S_IRUGO | S_IXUGO=
 | S_IWUSR;
> >> @@ -883,6 +885,7 @@ cifs_parse_mount_options(const char *mountdata=
, const char *devname,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Null separato=
r not allowed");
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> =A0 =A0 =A0 }
> >> + =A0 =A0 vol->cifs_backup =3D 0; /* no backup intent */
> >>
> >> =A0 =A0 =A0 while ((data =3D strsep(&options, separator)) !=3D NUL=
L) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!*data)
> >> @@ -1405,6 +1408,8 @@ cifs_parse_mount_options(const char *mountda=
ta, const char *devname,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->rwpidforward =3D =
1;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (strnicmp(data, "cifsacl", 7=
) =3D=3D 0) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->cifs_acl =3D 1;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 } else if (strnicmp(data, "backup", 7) =3D=
=3D 0) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->cifs_backup =3D 1;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (strnicmp(data, "nocifsacl",=
 9) =3D=3D 0) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->cifs_acl =3D 0;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (strnicmp(data, "acl", 3) =3D=
=3D 0) {
> >> @@ -1442,6 +1447,10 @@ cifs_parse_mount_options(const char *mountd=
ata, const char *devname,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->mfsymlinks =3D tr=
ue;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (strnicmp(data, "multiuser",=
 8) =3D=3D 0) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->multiuser =3D tru=
e;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 } else if (!strnicmp(data, "backupuid", =
9) && value && *value) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kstrtouint(value, 0, &vo=
l->backupuid);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 } else if (!strnicmp(data, "backupgid", =
9) && value && *value) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kstrtouint(value, 0, &vo=
l->backupgid);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_WARNING "C=
IFS: Unknown mount option %s\n",
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 data);
> >> @@ -2733,6 +2742,8 @@ void cifs_setup_cifs_sb(struct smb_vol *pvol=
ume_info,
> >>
> >> =A0 =A0 =A0 cifs_sb->mnt_uid =3D pvolume_info->linux_uid;
> >> =A0 =A0 =A0 cifs_sb->mnt_gid =3D pvolume_info->linux_gid;
> >> + =A0 =A0 cifs_sb->mnt_backupuid =3D pvolume_info->backupuid;
> >> + =A0 =A0 cifs_sb->mnt_backupgid =3D pvolume_info->backupgid;
> >> =A0 =A0 =A0 cifs_sb->mnt_file_mode =3D pvolume_info->file_mode;
> >> =A0 =A0 =A0 cifs_sb->mnt_dir_mode =3D pvolume_info->dir_mode;
> >> =A0 =A0 =A0 cFYI(1, "file mode: 0x%x =A0dir mode: 0x%x",
> >> @@ -2763,6 +2774,9 @@ void cifs_setup_cifs_sb(struct smb_vol *pvol=
ume_info,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags |=3D CIFS_MOUN=
T_RWPIDFORWARD;
> >> =A0 =A0 =A0 if (pvolume_info->cifs_acl)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags |=3D CIFS_MOUN=
T_CIFS_ACL;
> >> + =A0 =A0 if (pvolume_info->backupuid !=3D NO_CHANGE_32 ||
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pvolume_info->backupgid =
!=3D NO_CHANGE_32)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags |=3D CIFS_MOUNT_=
CIFS_BACKUP;
> >> =A0 =A0 =A0 if (pvolume_info->override_uid)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags |=3D CIFS_MOUN=
T_OVERR_UID;
> >> =A0 =A0 =A0 if (pvolume_info->override_gid)
> >> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> >> index 72d448b..8a2bff6 100644
> >> --- a/fs/cifs/dir.c
> >> +++ b/fs/cifs/dir.c
> >> @@ -243,7 +243,14 @@ cifs_create(struct inode *inode, struct dentr=
y *direntry, int mode,
> >> =A0 =A0 =A0 =A0*/
> >> =A0 =A0 =A0 if (!tcon->unix_ext && (mode & S_IWUGO) =3D=3D 0)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 create_options |=3D CREATE_OPTION_READ=
ONLY;
> >> -
> >> + =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL &&
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags =
& CIFS_MOUNT_CIFS_BACKUP) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if ((cifs_sb->mnt_backupuid !=3D NO_CHAN=
GE_32 &&
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb-=
>mnt_backupuid =3D=3D current_euid()) ||
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (cifs_sb->mnt_backupgid =
!=3D NO_CHANGE_32 &&
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 in_group_p(cifs_sb->mnt_backupgid)))
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 create_o=
ptions |=3D CREATE_OPEN_BACKUP_INTENT;
> >> + =A0 =A0 }
> >> =A0 =A0 =A0 if (tcon->ses->capabilities & CAP_NT_SMBS)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBOpen(xid, tcon, full_pat=
h, disposition,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0desiredAccess, crea=
te_options,
> >> @@ -357,6 +364,7 @@ int cifs_mknod(struct inode *inode, struct den=
try *direntry, int mode,
> >> =A0{
> >> =A0 =A0 =A0 int rc =3D -EPERM;
> >> =A0 =A0 =A0 int xid;
> >> + =A0 =A0 int create_options =3D CREATE_NOT_DIR | CREATE_OPTION_SP=
ECIAL;
> >> =A0 =A0 =A0 struct cifs_sb_info *cifs_sb;
> >> =A0 =A0 =A0 struct tcon_link *tlink;
> >> =A0 =A0 =A0 struct cifs_tcon *pTcon;
> >> @@ -431,9 +439,17 @@ int cifs_mknod(struct inode *inode, struct de=
ntry *direntry, int mode,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> >> =A0 =A0 =A0 }
> >>
> >> - =A0 =A0 /* FIXME: would WRITE_OWNER | WRITE_DAC be better? */
> >> + =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL &&
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags =
& CIFS_MOUNT_CIFS_BACKUP) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if ((cifs_sb->mnt_backupuid !=3D NO_CHAN=
GE_32 &&
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb-=
>mnt_backupuid =3D=3D current_euid()) ||
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (cifs_sb->mnt_backupgid =
!=3D NO_CHANGE_32 &&
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 in_group_p(cifs_sb->mnt_backupgid)))
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 create_o=
ptions |=3D CREATE_OPEN_BACKUP_INTENT;
> >> + =A0 =A0 }
> >> +
> >> =A0 =A0 =A0 rc =3D CIFSSMBOpen(xid, pTcon, full_path, FILE_CREATE,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0GENERIC_WRITE, CREATE=
_NOT_DIR | CREATE_OPTION_SPECIAL,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0GENERIC_WRITE, create=
_options,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&fileHandle, &oploc=
k, buf, cifs_sb->local_nls,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->mnt_cifs_f=
lags & CIFS_MOUNT_MAP_SPECIAL_CHR);
> >> =A0 =A0 =A0 if (rc)
> >> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> >> index 9f41a10..12eed36 100644
> >> --- a/fs/cifs/file.c
> >> +++ b/fs/cifs/file.c
> >> @@ -174,6 +174,7 @@ cifs_nt_open(char *full_path, struct inode *in=
ode, struct cifs_sb_info *cifs_sb,
> >> =A0 =A0 =A0 int rc;
> >> =A0 =A0 =A0 int desiredAccess;
> >> =A0 =A0 =A0 int disposition;
> >> + =A0 =A0 int create_options =3D CREATE_NOT_DIR;
> >> =A0 =A0 =A0 FILE_ALL_INFO *buf;
> >>
> >> =A0 =A0 =A0 desiredAccess =3D cifs_convert_flags(f_flags);
> >> @@ -210,9 +211,18 @@ cifs_nt_open(char *full_path, struct inode *i=
node, struct cifs_sb_info *cifs_sb,
> >> =A0 =A0 =A0 if (!buf)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> >>
> >> + =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL &&
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags =
& CIFS_MOUNT_CIFS_BACKUP) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if ((cifs_sb->mnt_backupuid !=3D NO_CHAN=
GE_32 &&
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb-=
>mnt_backupuid =3D=3D current_euid()) ||
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (cifs_sb->mnt_backupgid =
!=3D NO_CHANGE_32 &&
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 in_group_p(cifs_sb->mnt_backupgid)))
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 create_o=
ptions |=3D CREATE_OPEN_BACKUP_INTENT;
> >> + =A0 =A0 }
> >> +
> >> =A0 =A0 =A0 if (tcon->ses->capabilities & CAP_NT_SMBS)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBOpen(xid, tcon, full_pat=
h, disposition,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0desiredAccess, CREATE=
_NOT_DIR, pnetfid, poplock, buf,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0desiredAccess, create=
_options, pnetfid, poplock, buf,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->local_nls,=
 cifs_sb->mnt_cifs_flags
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0& C=
IFS_MOUNT_MAP_SPECIAL_CHR);
> >> =A0 =A0 =A0 else
> >> @@ -465,6 +475,7 @@ static int cifs_reopen_file(struct cifsFileInf=
o *pCifsFile, bool can_flush)
> >> =A0 =A0 =A0 char *full_path =3D NULL;
> >> =A0 =A0 =A0 int desiredAccess;
> >> =A0 =A0 =A0 int disposition =3D FILE_OPEN;
> >> + =A0 =A0 int create_options =3D CREATE_NOT_DIR;
> >> =A0 =A0 =A0 __u16 netfid;
> >>
> >> =A0 =A0 =A0 xid =3D GetXid();
> >> @@ -524,6 +535,15 @@ static int cifs_reopen_file(struct cifsFileIn=
fo *pCifsFile, bool can_flush)
> >>
> >> =A0 =A0 =A0 desiredAccess =3D cifs_convert_flags(pCifsFile->f_flag=
s);
> >>
> >> + =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL &&
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags =
& CIFS_MOUNT_CIFS_BACKUP) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if ((cifs_sb->mnt_backupuid !=3D NO_CHAN=
GE_32 &&
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb-=
>mnt_backupuid =3D=3D current_euid()) ||
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (cifs_sb->mnt_backupgid =
!=3D NO_CHANGE_32 &&
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 in_group_p(cifs_sb->mnt_backupgid)))
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 create_o=
ptions |=3D CREATE_OPEN_BACKUP_INTENT;
> >> + =A0 =A0 }
> >> +
> >> =A0 =A0 =A0 /* Can not refresh inode by passing in file_info buf t=
o be returned
> >> =A0 =A0 =A0 =A0 =A0by SMBOpen and then calling get_inode_info with=
 returned buf
> >> =A0 =A0 =A0 =A0 =A0since file might have write behind data that ne=
eds to be flushed
> >> @@ -531,7 +551,7 @@ static int cifs_reopen_file(struct cifsFileInf=
o *pCifsFile, bool can_flush)
> >> =A0 =A0 =A0 =A0 =A0that inode was not dirty locally we could do th=
is */
> >>
> >> =A0 =A0 =A0 rc =3D CIFSSMBOpen(xid, tcon, full_path, disposition, =
desiredAccess,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CREATE_NOT_DIR, &netf=
id, &oplock, NULL,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0create_options, &netf=
id, &oplock, NULL,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->local_nls,=
 cifs_sb->mnt_cifs_flags &
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_M=
OUNT_MAP_SPECIAL_CHR);
> >> =A0 =A0 =A0 if (rc) {
> >> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
> >> index db3f18c..81b6bf9 100644
> >> --- a/fs/cifs/link.c
> >> +++ b/fs/cifs/link.c
> >> @@ -183,14 +183,20 @@ CIFSFormatMFSymlink(u8 *buf, unsigned int bu=
f_len, const char *link_str)
> >> =A0static int
> >> =A0CIFSCreateMFSymLink(const int xid, struct cifs_tcon *tcon,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *fromName, const ch=
ar *toName,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *nls_code=
page, int remap)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_sb_info *cifs_sb)
> >> =A0{
> >> =A0 =A0 =A0 int rc;
> >> =A0 =A0 =A0 int oplock =3D 0;
> >> + =A0 =A0 int remap;
> >> + =A0 =A0 int create_options =3D CREATE_NOT_DIR;
> >> =A0 =A0 =A0 __u16 netfid =3D 0;
> >> =A0 =A0 =A0 u8 *buf;
> >> =A0 =A0 =A0 unsigned int bytes_written =3D 0;
> >> =A0 =A0 =A0 struct cifs_io_parms io_parms;
> >> + =A0 =A0 struct nls_table *nls_codepage;
> >> +
> >> + =A0 =A0 nls_codepage =3D cifs_sb->local_nls;
> >> + =A0 =A0 remap =3D cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECI=
AL_CHR;
> >>
> >> =A0 =A0 =A0 buf =3D kmalloc(CIFS_MF_SYMLINK_FILE_SIZE, GFP_KERNEL)=
;
> >> =A0 =A0 =A0 if (!buf)
> >> @@ -202,8 +208,17 @@ CIFSCreateMFSymLink(const int xid, struct cif=
s_tcon *tcon,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> >> =A0 =A0 =A0 }
> >>
> >> + =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL &&
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags =
& CIFS_MOUNT_CIFS_BACKUP) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if ((cifs_sb->mnt_backupuid !=3D NO_CHAN=
GE_32 &&
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb-=
>mnt_backupuid =3D=3D current_euid()) ||
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (cifs_sb->mnt_backupgid =
!=3D NO_CHANGE_32 &&
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 in_group_p(cifs_sb->mnt_backupgid)))
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 create_o=
ptions |=3D CREATE_OPEN_BACKUP_INTENT;
> >> + =A0 =A0 }
> >> +
> >> =A0 =A0 =A0 rc =3D CIFSSMBOpen(xid, tcon, fromName, FILE_CREATE, G=
ENERIC_WRITE,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CREATE_NOT_DIR, &netf=
id, &oplock, NULL,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0create_options, &netf=
id, &oplock, NULL,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0nls_codepage, remap=
);
> >> =A0 =A0 =A0 if (rc !=3D 0) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(buf);
> >> @@ -559,9 +574,7 @@ cifs_symlink(struct inode *inode, struct dentr=
y *direntry, const char *symname)
> >> =A0 =A0 =A0 /* BB what if DFS and this volume is on different shar=
e? BB */
> >> =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSCreateMFSymLink(xid, pTcon,=
 full_path, symname,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0cifs_sb->local_nls,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0cifs_sb->mnt_cifs_flags &
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 CIFS_MOUNT_MAP_SPECIAL_CHR);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 cifs_sb);
> >> =A0 =A0 =A0 else if (pTcon->unix_ext)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSUnixCreateSymLink(xid, pTco=
n, full_path, symname,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0cifs_sb->local_nls);
> >
> >
> > --
> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> >
>=20
> Jeff, Thanks. Will correct these.  We probably should
> check in kernel that the options multiuser and either or
> both of  backupuid and backupgid are not specified
> at the same time besides checking them in mount.cifs.
>=20

Why? I see no reason why this must be mutually exclusive with multiuser=
=2E

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
