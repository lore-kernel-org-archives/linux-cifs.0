From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 10/15] cifs: have find_readable/writable_file filter by fsuid
Date: Thu, 23 Sep 2010 01:11:31 -0500
Message-ID: <AANLkTimjyreVfJLHXvnL=bapwmc-V3SytdMmmUC9V96-@mail.gmail.com>
References: <1285023704-2159-1-git-send-email-jlayton@redhat.com>
	<1285023704-2159-11-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1285023704-2159-11-git-send-email-jlayton@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

This one looked ok (other than the earlier comment that
the series is bigger change than I expected).

On Mon, Sep 20, 2010 at 6:01 PM, Jeff Layton <jlayton@redhat.com> wrote=
:
> When we implement multiuser mounts, we'll need to filter filehandles
> by fsuid. Add a flag for multiuser mounts and code to filter by
> fsuid when it's set.
>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
> =A0fs/cifs/cifs_fs_sb.h | =A0 =A03 ++-
> =A0fs/cifs/cifsacl.c =A0 =A0| =A0 =A04 ++--
> =A0fs/cifs/cifsproto.h =A0| =A0 =A04 ++--
> =A0fs/cifs/dir.c =A0 =A0 =A0 =A0| =A0 =A01 +
> =A0fs/cifs/file.c =A0 =A0 =A0 | =A0 30 +++++++++++++++++++++++-------
> =A0fs/cifs/inode.c =A0 =A0 =A0| =A0 =A06 +++---
> =A06 files changed, 33 insertions(+), 15 deletions(-)
>
> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
> index ba0afd3..e04e692 100644
> --- a/fs/cifs/cifs_fs_sb.h
> +++ b/fs/cifs/cifs_fs_sb.h
> @@ -37,6 +37,7 @@
> =A0#define CIFS_MOUNT_NOSSYNC =A0 =A0 =A00x4000 /* don't do slow SMBf=
lush on every sync*/
> =A0#define CIFS_MOUNT_FSCACHE =A0 =A0 0x8000 /* local caching enabled=
 */
> =A0#define CIFS_MOUNT_MF_SYMLINKS 0x10000 /* Minshall+French Symlinks=
 enabled */
> +#define CIFS_MOUNT_MULTIUSER =A0 0x20000 /* multiuser mount */
>
> =A0struct cifs_sb_info {
> =A0 =A0 =A0 =A0struct cifsTconInfo *ptcon; =A0 =A0 /* primary mount *=
/
> @@ -48,7 +49,7 @@ struct cifs_sb_info {
> =A0 =A0 =A0 =A0gid_t =A0 mnt_gid;
> =A0 =A0 =A0 =A0mode_t =A0mnt_file_mode;
> =A0 =A0 =A0 =A0mode_t =A0mnt_dir_mode;
> - =A0 =A0 =A0 int =A0 =A0 mnt_cifs_flags;
> + =A0 =A0 =A0 unsigned int mnt_cifs_flags;
> =A0 =A0 =A0 =A0int =A0 =A0 prepathlen;
> =A0 =A0 =A0 =A0char =A0 *prepath; /* relative path under the share to=
 mount to */
> =A0#ifdef CONFIG_CIFS_DFS_UPCALL
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index 2647ea4..c9b4792 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -615,7 +615,7 @@ static struct cifs_ntsd *get_cifs_acl(struct cifs=
_sb_info *cifs_sb,
> =A0 =A0 =A0 =A0struct cifsFileInfo *open_file =3D NULL;
>
> =A0 =A0 =A0 =A0if (inode)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 open_file =3D find_readable_file(CIFS_I=
(inode));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 open_file =3D find_readable_file(CIFS_I=
(inode), true);
> =A0 =A0 =A0 =A0if (!open_file)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return get_cifs_acl_by_path(cifs_sb, p=
ath, pacllen);
>
> @@ -685,7 +685,7 @@ static int set_cifs_acl(struct cifs_ntsd *pnntsd,=
 __u32 acllen,
>
> =A0 =A0 =A0 =A0cFYI(DBG2, "set ACL for %s from mode 0x%x", path, inod=
e->i_mode);
>
> - =A0 =A0 =A0 open_file =3D find_readable_file(CIFS_I(inode));
> + =A0 =A0 =A0 open_file =3D find_readable_file(CIFS_I(inode), true);
> =A0 =A0 =A0 =A0if (!open_file)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return set_cifs_acl_by_path(cifs_sb, p=
ath, pnntsd, acllen);
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 18ee991..0e76b20 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -78,9 +78,9 @@ extern int checkSMB(struct smb_hdr *smb, __u16 mid,=
 unsigned int length);
> =A0extern bool is_valid_oplock_break(struct smb_hdr *smb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0st=
ruct TCP_Server_Info *);
> =A0extern bool is_size_safe_to_change(struct cifsInodeInfo *, __u64 e=
of);
> -extern struct cifsFileInfo *find_writable_file(struct cifsInodeInfo =
*);
> +extern struct cifsFileInfo *find_writable_file(struct cifsInodeInfo =
*, bool);
> =A0#ifdef CONFIG_CIFS_EXPERIMENTAL
> -extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo =
*);
> +extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo =
*, bool);
> =A0#endif
> =A0extern unsigned int smbCalcSize(struct smb_hdr *ptr);
> =A0extern unsigned int smbCalcSize_LE(struct smb_hdr *ptr);
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index 5adf47f..e249b56 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -144,6 +144,7 @@ cifs_new_fileinfo(struct inode *newinode, __u16 f=
ileHandle, struct file *file,
>
> =A0 =A0 =A0 =A0pCifsFile->netfid =3D fileHandle;
> =A0 =A0 =A0 =A0pCifsFile->pid =3D current->tgid;
> + =A0 =A0 =A0 pCifsFile->uid =3D current_fsuid();
> =A0 =A0 =A0 =A0pCifsFile->pInode =3D igrab(newinode);
> =A0 =A0 =A0 =A0pCifsFile->mnt =3D mnt;
> =A0 =A0 =A0 =A0pCifsFile->pfile =3D file;
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 023d348..d9b8652 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1168,9 +1168,15 @@ static ssize_t cifs_write(struct file *file, c=
onst char *write_data,
> =A0}
>
> =A0#ifdef CONFIG_CIFS_EXPERIMENTAL
> -struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_i=
node)
> +struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_i=
node,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 bool fsuid_only)
> =A0{
> =A0 =A0 =A0 =A0struct cifsFileInfo *open_file =3D NULL;
> + =A0 =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(cifs_inode->vf=
s_inode.i_sb);
> +
> + =A0 =A0 =A0 /* only filter by fsuid on multiuser mounts */
> + =A0 =A0 =A0 if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fsuid_only =3D false;
>
> =A0 =A0 =A0 =A0read_lock(&GlobalSMBSeslock);
> =A0 =A0 =A0 =A0/* we could simply get the first_list_entry since writ=
e-only entries
> @@ -1179,6 +1185,8 @@ struct cifsFileInfo *find_readable_file(struct =
cifsInodeInfo *cifs_inode)
> =A0 =A0 =A0 =A0list_for_each_entry(open_file, &cifs_inode->openFileLi=
st, flist) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (open_file->closePend)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (fsuid_only && open_file->uid !=3D c=
urrent_fsuid())
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (open_file->pfile && ((open_file->p=
file->f_flags & O_RDWR) ||
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(open_file->pfile->f_flags & O=
_RDONLY))) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!open_file->invali=
dHandle) {
> @@ -1198,9 +1206,11 @@ struct cifsFileInfo *find_readable_file(struct=
 cifsInodeInfo *cifs_inode)
> =A0}
> =A0#endif
>
> -struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_i=
node)
> +struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs_i=
node,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 bool fsuid_only)
> =A0{
> =A0 =A0 =A0 =A0struct cifsFileInfo *open_file;
> + =A0 =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(cifs_inode->vf=
s_inode.i_sb);
> =A0 =A0 =A0 =A0bool any_available =3D false;
> =A0 =A0 =A0 =A0int rc;
>
> @@ -1214,13 +1224,19 @@ struct cifsFileInfo *find_writable_file(struc=
t cifsInodeInfo *cifs_inode)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return NULL;
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 /* only filter by fsuid on multiuser mounts */
> + =A0 =A0 =A0 if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fsuid_only =3D false;
> +
> =A0 =A0 =A0 =A0read_lock(&GlobalSMBSeslock);
> =A0refind_writable:
> =A0 =A0 =A0 =A0list_for_each_entry(open_file, &cifs_inode->openFileLi=
st, flist) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (open_file->closePend ||
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (!any_available && open_file->p=
id !=3D current->tgid))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (open_file->closePend)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!any_available && open_file->pid !=3D=
 current->tgid)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (fsuid_only && open_file->uid !=3D c=
urrent_fsuid())
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> -
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (open_file->pfile &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0((open_file->pfile->f_flags & =
O_RDWR) ||
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (open_file->pfile->f_flags & =
O_WRONLY))) {
> @@ -1315,7 +1331,7 @@ static int cifs_partialpagewrite(struct page *p=
age, unsigned from, unsigned to)
> =A0 =A0 =A0 =A0if (mapping->host->i_size - offset < (loff_t)to)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0to =3D (unsigned)(mapping->host->i_siz=
e - offset);
>
> - =A0 =A0 =A0 open_file =3D find_writable_file(CIFS_I(mapping->host))=
;
> + =A0 =A0 =A0 open_file =3D find_writable_file(CIFS_I(mapping->host),=
 false);
> =A0 =A0 =A0 =A0if (open_file) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bytes_written =3D cifs_write(open_file=
->pfile, write_data,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 to-from, &offset);
> @@ -1388,7 +1404,7 @@ static int cifs_writepages(struct address_space=
 *mapping,
> =A0 =A0 =A0 =A0 * but it'll at least handle the return. Maybe it shou=
ld be
> =A0 =A0 =A0 =A0 * a BUG() instead?
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 open_file =3D find_writable_file(CIFS_I(mapping->host))=
;
> + =A0 =A0 =A0 open_file =3D find_writable_file(CIFS_I(mapping->host),=
 false);
> =A0 =A0 =A0 =A0if (!open_file) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kfree(iov);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return generic_writepages(mapping, wbc=
);
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index cca0d52..dcd0886 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -969,7 +969,7 @@ cifs_set_file_info(struct inode *inode, struct ia=
ttr *attrs, int xid,
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * If the file is already open for write, just use tha=
t fileid
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 open_file =3D find_writable_file(cifsInode);
> + =A0 =A0 =A0 open_file =3D find_writable_file(cifsInode, true);
> =A0 =A0 =A0 =A0if (open_file) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0netfid =3D open_file->netfid;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0netpid =3D open_file->pid;
> @@ -1819,7 +1819,7 @@ cifs_set_file_size(struct inode *inode, struct =
iattr *attrs,
> =A0 =A0 =A0 =A0 * writebehind data than the SMB timeout for the SetPa=
thInfo
> =A0 =A0 =A0 =A0 * request would allow
> =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 open_file =3D find_writable_file(cifsInode);
> + =A0 =A0 =A0 open_file =3D find_writable_file(cifsInode, true);
> =A0 =A0 =A0 =A0if (open_file) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u16 nfid =3D open_file->netfid;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u32 npid =3D open_file->pid;
> @@ -1984,7 +1984,7 @@ cifs_setattr_unix(struct dentry *direntry, stru=
ct iattr *attrs)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0args->ctime =3D NO_CHANGE_64;
>
> =A0 =A0 =A0 =A0args->device =3D 0;
> - =A0 =A0 =A0 open_file =3D find_writable_file(cifsInode);
> + =A0 =A0 =A0 open_file =3D find_writable_file(cifsInode, true);
> =A0 =A0 =A0 =A0if (open_file) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u16 nfid =3D open_file->netfid;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0u32 npid =3D open_file->pid;
> --
> 1.7.2.3
>
>



--=20
Thanks,

Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
