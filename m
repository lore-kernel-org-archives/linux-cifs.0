From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: Add mount options for backup intent [try #2]
Date: Wed, 21 Sep 2011 12:16:53 -0400
Message-ID: <20110921121653.4b5fdef5@tlielax.poochiereds.net>
References: <1316543210-12069-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110921074345.5d007d2c@corrin.poochiereds.net>
	<CADT32eL6EKoVeU9513bLG4p2bdYfcm3o1Lkg-i8vX=bd-X2f-Q@mail.gmail.com>
	<20110921084347.13f7c140@corrin.poochiereds.net>
	<CADT32eJyMxfwPG5w9EMfo0hdrF6mUKtXm_F9WNnkk9wmLSAR8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eJyMxfwPG5w9EMfo0hdrF6mUKtXm_F9WNnkk9wmLSAR8A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 21 Sep 2011 10:10:16 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Sep 21, 2011 at 7:43 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
> > On Wed, 21 Sep 2011 07:35:06 -0500
> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Wed, Sep 21, 2011 at 6:43 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> w=
rote:
> >> > On Tue, 20 Sep 2011 13:26:50 -0500
> >> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >> >
> >> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> >>
> >> >>
> >> >> Add mount options backupuid and backugid.
> >> >>
> >> >> It allows an authenticated user to access files with the intent=
 to back them
> >> >> up including their ACLs, who may not have access permission but=
 has
> >> >> "Backup files and directories user right" on them (by virtue of=
 being part
> >> >> of the built-in group Backup Operators.
> >> >>
> >> >> When mount options backupuid is specified, cifs client restrict=
s the
> >> >> use of backup intents to the user whose effective user id is sp=
ecified
> >> >> along with the mount option.
> >> >>
> >> >> When mount options backupgid is specified, cifs client restrict=
s the
> >> >> use of backup intents to the users whose effective user id belo=
ngs to the
> >> >> group id specified along with the mount option.
> >> >>
> >> >> These mount options are mutually excluisve to mount option =C2=A0=
mulituser.
> >> >>
> >> >> If an authenticated user is not part of the built-in group Back=
up Operators
> >> >> at the server, access to such files is denied, even if allowed =
by the client.
> >> >>
> >> >>
> >> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> >> ---
> >> >> =C2=A0fs/cifs/cifs_fs_sb.h | =C2=A0 =C2=A03 +++
> >> >> =C2=A0fs/cifs/cifsacl.c =C2=A0 =C2=A0| =C2=A0 23 ++++++++++++++=
++++-----
> >> >> =C2=A0fs/cifs/cifsglob.h =C2=A0 | =C2=A0 =C2=A06 +++++-
> >> >> =C2=A0fs/cifs/connect.c =C2=A0 =C2=A0| =C2=A0 14 ++++++++++++++
> >> >> =C2=A0fs/cifs/dir.c =C2=A0 =C2=A0 =C2=A0 =C2=A0| =C2=A0 22 ++++=
+++++++++++++++---
> >> >> =C2=A0fs/cifs/file.c =C2=A0 =C2=A0 =C2=A0 | =C2=A0 24 +++++++++=
+++++++++++++--
> >> >> =C2=A0fs/cifs/link.c =C2=A0 =C2=A0 =C2=A0 | =C2=A0 23 +++++++++=
+++++++++-----
> >> >> =C2=A07 files changed, 99 insertions(+), 16 deletions(-)
> >> >>
> >> >> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
> >> >> index 7260e11..f5483c8 100644
> >> >> --- a/fs/cifs/cifs_fs_sb.h
> >> >> +++ b/fs/cifs/cifs_fs_sb.h
> >> >> @@ -43,6 +43,7 @@
> >> >> =C2=A0#define CIFS_MOUNT_STRICT_IO 0x40000 /* strict cache mode=
 */
> >> >> =C2=A0#define CIFS_MOUNT_RWPIDFORWARD =C2=A0 =C2=A0 =C2=A00x800=
00 /* use pid forwarding for rw */
> >> >> =C2=A0#define CIFS_MOUNT_POSIXACL =C2=A00x100000 /* mirror of M=
S_POSIXACL in mnt_cifs_flags */
> >> >> +#define CIFS_MOUNT_CIFS_BACKUP =C2=A0 =C2=A0 =C2=A0 0x200000 /=
* open file with backup intent bit */
> >> >>
> >> >> =C2=A0struct cifs_sb_info {
> >> >> =C2=A0 =C2=A0 =C2=A0 struct rb_root tlink_tree;
> >> >> @@ -55,6 +56,8 @@ struct cifs_sb_info {
> >> >> =C2=A0 =C2=A0 =C2=A0 atomic_t active;
> >> >> =C2=A0 =C2=A0 =C2=A0 uid_t =C2=A0 mnt_uid;
> >> >> =C2=A0 =C2=A0 =C2=A0 gid_t =C2=A0 mnt_gid;
> >> >> + =C2=A0 =C2=A0 uid_t =C2=A0 mnt_backupuid;
> >> >> + =C2=A0 =C2=A0 gid_t =C2=A0 mnt_backupgid;
> >> >> =C2=A0 =C2=A0 =C2=A0 mode_t =C2=A0mnt_file_mode;
> >> >> =C2=A0 =C2=A0 =C2=A0 mode_t =C2=A0mnt_dir_mode;
> >> >> =C2=A0 =C2=A0 =C2=A0 unsigned int mnt_cifs_flags;
> >> >> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> >> >> index d0f59fa..a0af87a 100644
> >> >> --- a/fs/cifs/cifsacl.c
> >> >> +++ b/fs/cifs/cifsacl.c
> >> >> @@ -945,7 +945,7 @@ static struct cifs_ntsd *get_cifs_acl_by_pa=
th(struct cifs_sb_info *cifs_sb,
> >> >> =C2=A0{
> >> >> =C2=A0 =C2=A0 =C2=A0 struct cifs_ntsd *pntsd =3D NULL;
> >> >> =C2=A0 =C2=A0 =C2=A0 int oplock =3D 0;
> >> >> - =C2=A0 =C2=A0 int xid, rc;
> >> >> + =C2=A0 =C2=A0 int xid, rc, create_options =3D 0;
> >> >> =C2=A0 =C2=A0 =C2=A0 __u16 fid;
> >> >> =C2=A0 =C2=A0 =C2=A0 struct cifs_tcon *tcon;
> >> >> =C2=A0 =C2=A0 =C2=A0 struct tcon_link *tlink =3D cifs_sb_tlink(=
cifs_sb);
> >> >> @@ -956,9 +956,18 @@ static struct cifs_ntsd *get_cifs_acl_by_p=
ath(struct cifs_sb_info *cifs_sb,
> >> >> =C2=A0 =C2=A0 =C2=A0 tcon =3D tlink_tcon(tlink);
> >> >> =C2=A0 =C2=A0 =C2=A0 xid =3D GetXid();
> >> >>
> >> >> - =C2=A0 =C2=A0 rc =3D CIFSSMBOpen(xid, tcon, path, FILE_OPEN, =
READ_CONTROL, 0,
> >> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0&fid, &oplock, NULL, cifs_sb->local_nls,
> >> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
> >> >> + =C2=A0 =C2=A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_A=
CL &&
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUP) {
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((cifs_sb->mnt_b=
ackupuid !=3D NO_CHANGE_32 &&
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_sb->mnt_backupuid =3D=3D curre=
nt_euid()) ||
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 (cifs_sb->mnt_backupgid !=3D NO_CHANGE_32 &&
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 in_grou=
p_p(cifs_sb->mnt_backupgid)))
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 create_options |=3D CREATE_OPEN_BAC=
KUP_INTENT;
> >> >> + =C2=A0 =C2=A0 }
> >> >> +
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0^^^^^^^^^^^^^^
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Ugh, plea=
se put the ugliness above in a helper
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0function.=
 Maybe something like:
> >> >
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (backu=
p_cred(cifs_sb))
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0create_options |=3D CREATE_OPEN_BACKUP_INTENT;
> >> >
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Also, why=
 is this dependent on CIFS_MOUNT_CIFS_ACL?
> >> >
> >> >> + =C2=A0 =C2=A0 rc =3D CIFSSMBOpen(xid, tcon, path, FILE_OPEN, =
READ_CONTROL,
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 create_options, &fid, &oplock, NULL, cifs_sb->local_nls,
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
> >> >> =C2=A0 =C2=A0 =C2=A0 if (!rc) {
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D CIFSSMB=
GetCIFSACL(xid, tcon, fid, &pntsd, pacllen);
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CIFSSMBClose(x=
id, tcon, fid);
> >> >> @@ -995,7 +1004,7 @@ static int set_cifs_acl_by_path(struct cif=
s_sb_info *cifs_sb, const char *path,
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct cifs_nt=
sd *pnntsd, u32 acllen)
> >> >> =C2=A0{
> >> >> =C2=A0 =C2=A0 =C2=A0 int oplock =3D 0;
> >> >> - =C2=A0 =C2=A0 int xid, rc;
> >> >> + =C2=A0 =C2=A0 int xid, rc, create_options =3D 0;
> >> >> =C2=A0 =C2=A0 =C2=A0 __u16 fid;
> >> >> =C2=A0 =C2=A0 =C2=A0 struct cifs_tcon *tcon;
> >> >> =C2=A0 =C2=A0 =C2=A0 struct tcon_link *tlink =3D cifs_sb_tlink(=
cifs_sb);
> >> >> @@ -1006,6 +1015,10 @@ static int set_cifs_acl_by_path(struct c=
ifs_sb_info *cifs_sb, const char *path,
> >> >> =C2=A0 =C2=A0 =C2=A0 tcon =3D tlink_tcon(tlink);
> >> >> =C2=A0 =C2=A0 =C2=A0 xid =3D GetXid();
> >> >>
> >> >> + =C2=A0 =C2=A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_A=
CL &&
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUP)
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 create_options |=3D=
 CREATE_OPEN_BACKUP_INTENT;
> >> >> +
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^^^^^^^^^=
^^^
> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0Why aren't you checking the user/grou=
p here?
> >> >
> >> >> =C2=A0 =C2=A0 =C2=A0 rc =3D CIFSSMBOpen(xid, tcon, path, FILE_O=
PEN, WRITE_DAC, 0,
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0&fid, &oplock, NULL, cifs_sb->local_nls,
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CH=
R);
> >> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >> >> index 95dad9d..cd0d7fa 100644
> >> >> --- a/fs/cifs/cifsglob.h
> >> >> +++ b/fs/cifs/cifsglob.h
> >> >> @@ -167,6 +167,8 @@ struct smb_vol {
> >> >> =C2=A0 =C2=A0 =C2=A0 uid_t cred_uid;
> >> >> =C2=A0 =C2=A0 =C2=A0 uid_t linux_uid;
> >> >> =C2=A0 =C2=A0 =C2=A0 gid_t linux_gid;
> >> >> + =C2=A0 =C2=A0 uid_t backupuid;
> >> >> + =C2=A0 =C2=A0 gid_t backupgid;
> >> >> =C2=A0 =C2=A0 =C2=A0 mode_t file_mode;
> >> >> =C2=A0 =C2=A0 =C2=A0 mode_t dir_mode;
> >> >> =C2=A0 =C2=A0 =C2=A0 unsigned secFlg;
> >> >> @@ -179,6 +181,7 @@ struct smb_vol {
> >> >> =C2=A0 =C2=A0 =C2=A0 bool noperm:1;
> >> >> =C2=A0 =C2=A0 =C2=A0 bool no_psx_acl:1; /* set if posix acl sup=
port should be disabled */
> >> >> =C2=A0 =C2=A0 =C2=A0 bool cifs_acl:1;
> >> >> + =C2=A0 =C2=A0 bool cifs_backup:1; /* to indicates backup inte=
nt during file open */
> >> >> =C2=A0 =C2=A0 =C2=A0 bool no_xattr:1; =C2=A0 /* set if xattr (E=
A) support should be disabled*/
> >> >> =C2=A0 =C2=A0 =C2=A0 bool server_ino:1; /* use inode numbers fr=
om server ie UniqueId */
> >> >> =C2=A0 =C2=A0 =C2=A0 bool direct_io:1;
> >> >> @@ -219,7 +222,8 @@ struct smb_vol {
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0CIFS_MOUNT_OVERR_GID | CIFS_MOUNT_DYNPERM | \
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0CIFS_MOUNT_NOPOSIXBRL | CIFS_MOUNT_NOSSYNC | \
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0CIFS_MOUNT_FSCACHE | CIFS_MOUNT_MF_SYMLINKS | \
> >> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0CIFS_MOUNT_MULTIUSER | CIFS_MOUNT_STRICT_IO)
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0CIFS_MOUNT_MULTIUSER | CIFS_MOUNT_STRICT_IO | \
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0CIFS_MOUNT_CIFS_BACKUP)
> >> >>
> >> >> =C2=A0#define CIFS_MS_MASK (MS_RDONLY | MS_MANDLOCK | MS_NOEXEC=
 | MS_NOSUID | \
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 MS_NODEV | MS_SYNCHRONOUS)
> >> >> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >> >> index f4af4cc..a56624a 100644
> >> >> --- a/fs/cifs/connect.c
> >> >> +++ b/fs/cifs/connect.c
> >> >> @@ -854,6 +854,8 @@ cifs_parse_mount_options(const char *mountd=
ata, const char *devname,
> >> >> =C2=A0 =C2=A0 =C2=A0 vol->cred_uid =3D current_uid();
> >> >> =C2=A0 =C2=A0 =C2=A0 vol->linux_uid =3D current_uid();
> >> >> =C2=A0 =C2=A0 =C2=A0 vol->linux_gid =3D current_gid();
> >> >> + =C2=A0 =C2=A0 vol->backupuid =3D NO_CHANGE_32;
> >> >> + =C2=A0 =C2=A0 vol->backupgid =3D NO_CHANGE_32;
> >> >>
> >> >> =C2=A0 =C2=A0 =C2=A0 /* default to only allowing write access t=
o owner of the mount */
> >> >> =C2=A0 =C2=A0 =C2=A0 vol->dir_mode =3D vol->file_mode =3D S_IRU=
GO | S_IXUGO | S_IWUSR;
> >> >> @@ -883,6 +885,7 @@ cifs_parse_mount_options(const char *mountd=
ata, const char *devname,
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 cFYI(1, "Null separator not allowed");
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> >> =C2=A0 =C2=A0 =C2=A0 }
> >> >> + =C2=A0 =C2=A0 vol->cifs_backup =3D 0; /* no backup intent */
> >> >>
> >> >> =C2=A0 =C2=A0 =C2=A0 while ((data =3D strsep(&options, separato=
r)) !=3D NULL) {
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!*data)
> >> >> @@ -1405,6 +1408,8 @@ cifs_parse_mount_options(const char *moun=
tdata, const char *devname,
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 vol->rwpidforward =3D 1;
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (str=
nicmp(data, "cifsacl", 7) =3D=3D 0) {
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 vol->cifs_acl =3D 1;
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (strnicmp=
(data, "backup", 7) =3D=3D 0) {
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 vol->cifs_backup =3D 1;
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (str=
nicmp(data, "nocifsacl", 9) =3D=3D 0) {
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 vol->cifs_acl =3D 0;
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (str=
nicmp(data, "acl", 3) =3D=3D 0) {
> >> >> @@ -1442,6 +1447,10 @@ cifs_parse_mount_options(const char *mou=
ntdata, const char *devname,
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 vol->mfsymlinks =3D true;
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (str=
nicmp(data, "multiuser", 8) =3D=3D 0) {
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 vol->multiuser =3D true;
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (!strnicm=
p(data, "backupuid", 9) && value && *value) {
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 kstrtouint(value, 0, &vol->backupuid);
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (!strnicm=
p(data, "backupgid", 9) && value && *value) {
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 kstrtouint(value, 0, &vol->backupgid);
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 printk(KERN_WARNING "CIFS: Unknown mount option %s\n",
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 data);
> >> >> @@ -2733,6 +2742,8 @@ void cifs_setup_cifs_sb(struct smb_vol *p=
volume_info,
> >> >>
> >> >> =C2=A0 =C2=A0 =C2=A0 cifs_sb->mnt_uid =3D pvolume_info->linux_u=
id;
> >> >> =C2=A0 =C2=A0 =C2=A0 cifs_sb->mnt_gid =3D pvolume_info->linux_g=
id;
> >> >> + =C2=A0 =C2=A0 cifs_sb->mnt_backupuid =3D pvolume_info->backup=
uid;
> >> >> + =C2=A0 =C2=A0 cifs_sb->mnt_backupgid =3D pvolume_info->backup=
gid;
> >> >> =C2=A0 =C2=A0 =C2=A0 cifs_sb->mnt_file_mode =3D pvolume_info->f=
ile_mode;
> >> >> =C2=A0 =C2=A0 =C2=A0 cifs_sb->mnt_dir_mode =3D pvolume_info->di=
r_mode;
> >> >> =C2=A0 =C2=A0 =C2=A0 cFYI(1, "file mode: 0x%x =C2=A0dir mode: 0=
x%x",
> >> >> @@ -2763,6 +2774,9 @@ void cifs_setup_cifs_sb(struct smb_vol *p=
volume_info,
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_sb->mnt_c=
ifs_flags |=3D CIFS_MOUNT_RWPIDFORWARD;
> >> >> =C2=A0 =C2=A0 =C2=A0 if (pvolume_info->cifs_acl)
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_sb->mnt_c=
ifs_flags |=3D CIFS_MOUNT_CIFS_ACL;
> >> >> + =C2=A0 =C2=A0 if (pvolume_info->backupuid !=3D NO_CHANGE_32 |=
|
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 pvolume_info->backupgid !=3D NO_CHANGE_32)
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_sb->mnt_cifs_f=
lags |=3D CIFS_MOUNT_CIFS_BACKUP;
> >> >> =C2=A0 =C2=A0 =C2=A0 if (pvolume_info->override_uid)
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_sb->mnt_c=
ifs_flags |=3D CIFS_MOUNT_OVERR_UID;
> >> >> =C2=A0 =C2=A0 =C2=A0 if (pvolume_info->override_gid)
> >> >> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> >> >> index 72d448b..8a2bff6 100644
> >> >> --- a/fs/cifs/dir.c
> >> >> +++ b/fs/cifs/dir.c
> >> >> @@ -243,7 +243,14 @@ cifs_create(struct inode *inode, struct de=
ntry *direntry, int mode,
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> >> >> =C2=A0 =C2=A0 =C2=A0 if (!tcon->unix_ext && (mode & S_IWUGO) =3D=
=3D 0)
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 create_options=
 |=3D CREATE_OPTION_READONLY;
> >> >> -
> >> >> + =C2=A0 =C2=A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_A=
CL &&
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUP) {
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((cifs_sb->mnt_b=
ackupuid !=3D NO_CHANGE_32 &&
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_sb->mnt_backupuid =3D=3D curre=
nt_euid()) ||
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 (cifs_sb->mnt_backupgid !=3D NO_CHANGE_32 &&
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 in_grou=
p_p(cifs_sb->mnt_backupgid)))
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 create_options |=3D CREATE_OPEN_BAC=
KUP_INTENT;
> >> >> + =C2=A0 =C2=A0 }
> >> >> =C2=A0 =C2=A0 =C2=A0 if (tcon->ses->capabilities & CAP_NT_SMBS)
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D CIFSSMB=
Open(xid, tcon, full_path, disposition,
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0desiredAccess, create_options,
> >> >> @@ -357,6 +364,7 @@ int cifs_mknod(struct inode *inode, struct =
dentry *direntry, int mode,
> >> >> =C2=A0{
> >> >> =C2=A0 =C2=A0 =C2=A0 int rc =3D -EPERM;
> >> >> =C2=A0 =C2=A0 =C2=A0 int xid;
> >> >> + =C2=A0 =C2=A0 int create_options =3D CREATE_NOT_DIR | CREATE_=
OPTION_SPECIAL;
> >> >> =C2=A0 =C2=A0 =C2=A0 struct cifs_sb_info *cifs_sb;
> >> >> =C2=A0 =C2=A0 =C2=A0 struct tcon_link *tlink;
> >> >> =C2=A0 =C2=A0 =C2=A0 struct cifs_tcon *pTcon;
> >> >> @@ -431,9 +439,17 @@ int cifs_mknod(struct inode *inode, struct=
 dentry *direntry, int mode,
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> >> >> =C2=A0 =C2=A0 =C2=A0 }
> >> >>
> >> >> - =C2=A0 =C2=A0 /* FIXME: would WRITE_OWNER | WRITE_DAC be bett=
er? */
> >> >> + =C2=A0 =C2=A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_A=
CL &&
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUP) {
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((cifs_sb->mnt_b=
ackupuid !=3D NO_CHANGE_32 &&
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_sb->mnt_backupuid =3D=3D curre=
nt_euid()) ||
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 (cifs_sb->mnt_backupgid !=3D NO_CHANGE_32 &&
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 in_grou=
p_p(cifs_sb->mnt_backupgid)))
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 create_options |=3D CREATE_OPEN_BAC=
KUP_INTENT;
> >> >> + =C2=A0 =C2=A0 }
> >> >> +
> >> >> =C2=A0 =C2=A0 =C2=A0 rc =3D CIFSSMBOpen(xid, pTcon, full_path, =
=46ILE_CREATE,
> >> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0GENERIC_WRITE, CREATE_NOT_DIR | CREATE_OPTION_SPECIAL,
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0GENERIC_WRITE, create_options,
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0&fileHandle, &oplock, buf, cifs_sb->local_nls,
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CH=
R);
> >> >> =C2=A0 =C2=A0 =C2=A0 if (rc)
> >> >> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> >> >> index 9f41a10..12eed36 100644
> >> >> --- a/fs/cifs/file.c
> >> >> +++ b/fs/cifs/file.c
> >> >> @@ -174,6 +174,7 @@ cifs_nt_open(char *full_path, struct inode =
*inode, struct cifs_sb_info *cifs_sb,
> >> >> =C2=A0 =C2=A0 =C2=A0 int rc;
> >> >> =C2=A0 =C2=A0 =C2=A0 int desiredAccess;
> >> >> =C2=A0 =C2=A0 =C2=A0 int disposition;
> >> >> + =C2=A0 =C2=A0 int create_options =3D CREATE_NOT_DIR;
> >> >> =C2=A0 =C2=A0 =C2=A0 FILE_ALL_INFO *buf;
> >> >>
> >> >> =C2=A0 =C2=A0 =C2=A0 desiredAccess =3D cifs_convert_flags(f_fla=
gs);
> >> >> @@ -210,9 +211,18 @@ cifs_nt_open(char *full_path, struct inode=
 *inode, struct cifs_sb_info *cifs_sb,
> >> >> =C2=A0 =C2=A0 =C2=A0 if (!buf)
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENOMEM=
;
> >> >>
> >> >> + =C2=A0 =C2=A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_A=
CL &&
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUP) {
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((cifs_sb->mnt_b=
ackupuid !=3D NO_CHANGE_32 &&
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_sb->mnt_backupuid =3D=3D curre=
nt_euid()) ||
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 (cifs_sb->mnt_backupgid !=3D NO_CHANGE_32 &&
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 in_grou=
p_p(cifs_sb->mnt_backupgid)))
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 create_options |=3D CREATE_OPEN_BAC=
KUP_INTENT;
> >> >> + =C2=A0 =C2=A0 }
> >> >> +
> >> >> =C2=A0 =C2=A0 =C2=A0 if (tcon->ses->capabilities & CAP_NT_SMBS)
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D CIFSSMB=
Open(xid, tcon, full_path, disposition,
> >> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0desiredAccess, CREATE_NOT_DIR, pnetfid, poplock, buf,
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0desiredAccess, create_options, pnetfid, poplock, buf,
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0cifs_sb->local_nls, cifs_sb->mnt_cifs_flags
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0& CIFS_MOUNT_MAP_SPECIA=
L_CHR);
> >> >> =C2=A0 =C2=A0 =C2=A0 else
> >> >> @@ -465,6 +475,7 @@ static int cifs_reopen_file(struct cifsFile=
Info *pCifsFile, bool can_flush)
> >> >> =C2=A0 =C2=A0 =C2=A0 char *full_path =3D NULL;
> >> >> =C2=A0 =C2=A0 =C2=A0 int desiredAccess;
> >> >> =C2=A0 =C2=A0 =C2=A0 int disposition =3D FILE_OPEN;
> >> >> + =C2=A0 =C2=A0 int create_options =3D CREATE_NOT_DIR;
> >> >> =C2=A0 =C2=A0 =C2=A0 __u16 netfid;
> >> >>
> >> >> =C2=A0 =C2=A0 =C2=A0 xid =3D GetXid();
> >> >> @@ -524,6 +535,15 @@ static int cifs_reopen_file(struct cifsFil=
eInfo *pCifsFile, bool can_flush)
> >> >>
> >> >> =C2=A0 =C2=A0 =C2=A0 desiredAccess =3D cifs_convert_flags(pCifs=
=46ile->f_flags);
> >> >>
> >> >> + =C2=A0 =C2=A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_A=
CL &&
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUP) {
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((cifs_sb->mnt_b=
ackupuid !=3D NO_CHANGE_32 &&
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_sb->mnt_backupuid =3D=3D curre=
nt_euid()) ||
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 (cifs_sb->mnt_backupgid !=3D NO_CHANGE_32 &&
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 in_grou=
p_p(cifs_sb->mnt_backupgid)))
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 create_options |=3D CREATE_OPEN_BAC=
KUP_INTENT;
> >> >> + =C2=A0 =C2=A0 }
> >> >> +
> >> >> =C2=A0 =C2=A0 =C2=A0 /* Can not refresh inode by passing in fil=
e_info buf to be returned
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0by SMBOpen and then calling g=
et_inode_info with returned buf
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0since file might have write b=
ehind data that needs to be flushed
> >> >> @@ -531,7 +551,7 @@ static int cifs_reopen_file(struct cifsFile=
Info *pCifsFile, bool can_flush)
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0that inode was not dirty loca=
lly we could do this */
> >> >>
> >> >> =C2=A0 =C2=A0 =C2=A0 rc =3D CIFSSMBOpen(xid, tcon, full_path, d=
isposition, desiredAccess,
> >> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0CREATE_NOT_DIR, &netfid, &oplock, NULL,
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0create_options, &netfid, &oplock, NULL,
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0cifs_sb->local_nls, cifs_sb->mnt_cifs_flags &
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CIFS_MOUNT_MAP_SPECIAL_CHR);
> >> >> =C2=A0 =C2=A0 =C2=A0 if (rc) {
> >> >> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
> >> >> index db3f18c..81b6bf9 100644
> >> >> --- a/fs/cifs/link.c
> >> >> +++ b/fs/cifs/link.c
> >> >> @@ -183,14 +183,20 @@ CIFSFormatMFSymlink(u8 *buf, unsigned int=
 buf_len, const char *link_str)
> >> >> =C2=A0static int
> >> >> =C2=A0CIFSCreateMFSymLink(const int xid, struct cifs_tcon *tcon=
,
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
const char *fromName, const char *toName,
> >> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const=
 struct nls_table *nls_codepage, int remap)
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struc=
t cifs_sb_info *cifs_sb)
> >> >> =C2=A0{
> >> >> =C2=A0 =C2=A0 =C2=A0 int rc;
> >> >> =C2=A0 =C2=A0 =C2=A0 int oplock =3D 0;
> >> >> + =C2=A0 =C2=A0 int remap;
> >> >> + =C2=A0 =C2=A0 int create_options =3D CREATE_NOT_DIR;
> >> >> =C2=A0 =C2=A0 =C2=A0 __u16 netfid =3D 0;
> >> >> =C2=A0 =C2=A0 =C2=A0 u8 *buf;
> >> >> =C2=A0 =C2=A0 =C2=A0 unsigned int bytes_written =3D 0;
> >> >> =C2=A0 =C2=A0 =C2=A0 struct cifs_io_parms io_parms;
> >> >> + =C2=A0 =C2=A0 struct nls_table *nls_codepage;
> >> >> +
> >> >> + =C2=A0 =C2=A0 nls_codepage =3D cifs_sb->local_nls;
> >> >> + =C2=A0 =C2=A0 remap =3D cifs_sb->mnt_cifs_flags & CIFS_MOUNT_=
MAP_SPECIAL_CHR;
> >> >>
> >> >> =C2=A0 =C2=A0 =C2=A0 buf =3D kmalloc(CIFS_MF_SYMLINK_FILE_SIZE,=
 GFP_KERNEL);
> >> >> =C2=A0 =C2=A0 =C2=A0 if (!buf)
> >> >> @@ -202,8 +208,17 @@ CIFSCreateMFSymLink(const int xid, struct =
cifs_tcon *tcon,
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> >> >> =C2=A0 =C2=A0 =C2=A0 }
> >> >>
> >> >> + =C2=A0 =C2=A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_A=
CL &&
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUP) {
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((cifs_sb->mnt_b=
ackupuid !=3D NO_CHANGE_32 &&
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_sb->mnt_backupuid =3D=3D curre=
nt_euid()) ||
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 (cifs_sb->mnt_backupgid !=3D NO_CHANGE_32 &&
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 in_grou=
p_p(cifs_sb->mnt_backupgid)))
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 create_options |=3D CREATE_OPEN_BAC=
KUP_INTENT;
> >> >> + =C2=A0 =C2=A0 }
> >> >> +
> >> >> =C2=A0 =C2=A0 =C2=A0 rc =3D CIFSSMBOpen(xid, tcon, fromName, FI=
LE_CREATE, GENERIC_WRITE,
> >> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0CREATE_NOT_DIR, &netfid, &oplock, NULL,
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0create_options, &netfid, &oplock, NULL,
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0nls_codepage, remap);
> >> >> =C2=A0 =C2=A0 =C2=A0 if (rc !=3D 0) {
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree(buf);
> >> >> @@ -559,9 +574,7 @@ cifs_symlink(struct inode *inode, struct de=
ntry *direntry, const char *symname)
> >> >> =C2=A0 =C2=A0 =C2=A0 /* BB what if DFS and this volume is on di=
fferent share? BB */
> >> >> =C2=A0 =C2=A0 =C2=A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_M=
=46_SYMLINKS)
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D CIFSCre=
ateMFSymLink(xid, pTcon, full_path, symname,
> >> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0c=
ifs_sb->local_nls,
> >> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0c=
ifs_sb->mnt_cifs_flags &
> >> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 CIFS_MOUNT_MAP_SPECIAL_CHR);
> >> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifs_sb=
);
> >> >> =C2=A0 =C2=A0 =C2=A0 else if (pTcon->unix_ext)
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D CIFSUni=
xCreateSymLink(xid, pTcon, full_path, symname,
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0cifs_sb->local_nls);
> >> >
> >> >
> >> > --
> >> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> >> >
> >>
> >> Jeff, Thanks. Will correct these. =C2=A0We probably should
> >> check in kernel that the options multiuser and either or
> >> both of =C2=A0backupuid and backupgid are not specified
> >> at the same time besides checking them in mount.cifs.
> >>
> >
> > Why? I see no reason why this must be mutually exclusive with multi=
user.
> >
> > --
> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> >
>=20
> By making mulituser mount option mutually exclusive with either/or
> backupuid and backupgid, we are trying to prevent a session without
> backup intent right from using file handles created by another sessio=
n
> with the backup intent right.

The whole point of making this a per-uid/gid thing is to allow it to
work in conjunction with multiuser mounts.

A filehandle is subordinate to a tcon, and that's subordinate to a
session. So, another session should already never have access to such a
filehandle.

If you think this opens an attack vector though, perhaps you could
describe it in detail?

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
