From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 3/4] CIFS: Migrate from prefixpath logic
Date: Mon, 2 May 2011 18:10:01 +0400
Message-ID: <BANLkTimOSURKGNrukzNDcN0KLo3dsmyYMg@mail.gmail.com>
References: <1302850916-13947-1-git-send-email-piastry@etersoft.ru>
	<1302850916-13947-2-git-send-email-piastry@etersoft.ru>
	<20110429111720.1f3a49d8@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110429111720.1f3a49d8-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/4/29 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Fri, 15 Apr 2011 11:01:55 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Now we point superblock to a server share root and set a root dentry
>> appropriately. This let us share superblock between mounts like
>> //server/sharename/foo/bar and //server/sharename/foo further.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/cifs_fs_sb.h | =A0 =A02 -
>> =A0fs/cifs/cifsfs.c =A0 =A0 | =A0 95 +++++++++++++++++++++++++++++++=
++++-
>> =A0fs/cifs/cifsglob.h =A0 | =A0 76 +++++++++++++++++++++++++++++
>> =A0fs/cifs/cifsproto.h =A0| =A0 =A05 +-
>> =A0fs/cifs/connect.c =A0 =A0| =A0129 ++-----------------------------=
-------------------
>> =A0fs/cifs/dir.c =A0 =A0 =A0 =A0| =A0 =A07 +--
>> =A0fs/cifs/inode.c =A0 =A0 =A0| =A0 15 +++---
>> =A07 files changed, 186 insertions(+), 143 deletions(-)
>>
>> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
>> index adecd36..a18ba37 100644
>> --- a/fs/cifs/cifs_fs_sb.h
>> +++ b/fs/cifs/cifs_fs_sb.h
>> @@ -58,8 +58,6 @@ struct cifs_sb_info {
>> =A0 =A0 =A0 mode_t =A0mnt_file_mode;
>> =A0 =A0 =A0 mode_t =A0mnt_dir_mode;
>> =A0 =A0 =A0 unsigned int mnt_cifs_flags;
>> - =A0 =A0 int =A0 =A0 prepathlen;
>> - =A0 =A0 char =A0 *prepath; /* relative path under the share to mou=
nt to */
>> =A0 =A0 =A0 char =A0 *mountdata; /* options received at mount time o=
r via DFS refs */
>> =A0 =A0 =A0 struct backing_dev_info bdi;
>> =A0 =A0 =A0 struct delayed_work prune_tlinks;
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index 3227db6..44394c8 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -434,8 +434,6 @@ cifs_show_options(struct seq_file *s, struct vfs=
mount *m)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",nocase");
>> =A0 =A0 =A0 if (tcon->retry)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",hard");
>> - =A0 =A0 if (cifs_sb->prepath)
>> - =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",prepath=3D%s", cifs_sb->pr=
epath);
>> =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",posixpaths");
>> =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID)
>> @@ -549,6 +547,92 @@ static const struct super_operations cifs_super=
_ops =3D {
>> =A0#endif
>> =A0};
>>
>> +/*
>> + * Get root dentry from superblock according to prefix path mount o=
ption.
>> + * Return dentry with refcount + 1 on success and NULL otherwise.
>> + */
>> +static struct dentry *
>> +cifs_get_root(struct smb_vol *vol, struct super_block *sb)
>> +{
>> + =A0 =A0 int xid, rc;
>> + =A0 =A0 struct inode *inode;
>> + =A0 =A0 struct qstr name;
>> + =A0 =A0 struct dentry *dparent =3D NULL, *dchild =3D NULL;
>> + =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(sb);
>> + =A0 =A0 unsigned int i, full_len, len;
>> + =A0 =A0 char *full_path =3D NULL, *pstart;
>> + =A0 =A0 char sep;
>> +
>> + =A0 =A0 full_path =3D cifs_build_path_to_root(vol, cifs_sb,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 cifs_sb_master_tcon(cifs_sb));
>> + =A0 =A0 if (full_path =3D=3D NULL)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
>> +
>> + =A0 =A0 cFYI(1, "Get root dentry for %s", full_path);
>> +
>> + =A0 =A0 xid =3D GetXid();
>> + =A0 =A0 sep =3D CIFS_DIR_SEP(cifs_sb);
>> + =A0 =A0 dparent =3D dget(sb->s_root);
>> + =A0 =A0 full_len =3D strlen(full_path);
>> + =A0 =A0 full_path[full_len] =3D sep;
>> + =A0 =A0 pstart =3D full_path + 1;
>> +
>> + =A0 =A0 for (i =3D 1, len =3D 0; i <=3D full_len; i++) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (full_path[i] !=3D sep || !len) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 len++;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 full_path[i] =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "get dentry for %s", pstart);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 name.name =3D pstart;
>> + =A0 =A0 =A0 =A0 =A0 =A0 name.len =3D len;
>> + =A0 =A0 =A0 =A0 =A0 =A0 name.hash =3D full_name_hash(pstart, len);
>> + =A0 =A0 =A0 =A0 =A0 =A0 dchild =3D d_lookup(dparent, &name);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (dchild =3D=3D NULL) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "not exists");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dchild =3D d_alloc(dparent=
, &name);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (dchild =3D=3D NULL) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dput(dpare=
nt);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dparent =3D=
 NULL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "get inode");
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (dchild->d_inode =3D=3D NULL) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "not exists");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode =3D NULL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cifs_sb_master_tcon(CI=
=46S_SB(sb))->unix_ext)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cif=
s_get_inode_info_unix(&inode, full_path,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sb, xid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cif=
s_get_inode_info(&inode, full_path,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0NULL, sb, xid, NULL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dput(dchil=
d);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dput(dpare=
nt);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dparent =3D=
 NULL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 d_add(dchild, inode);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Is this racy? Could an=
other dentry have been
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0added between the time=
 that you did the initial
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lookup and here? I thi=
nk there are functions
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0that guard against tha=
t possibility.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0d_materialise_unique m=
aybe?
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "parent %p, child %p", dparent, dc=
hild);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 dput(dparent);
>> + =A0 =A0 =A0 =A0 =A0 =A0 dparent =3D dchild;
>> + =A0 =A0 =A0 =A0 =A0 =A0 len =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 pstart =3D full_path + i + 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 full_path[i] =3D sep;
>> + =A0 =A0 }
>> +out:
>> + =A0 =A0 _FreeXid(xid);
>> + =A0 =A0 full_path[full_len] =3D 0;
> =A0 =A0 =A0 =A0^^^ that's unnecessary, you free this just afterward.
>
>> + =A0 =A0 kfree(full_path);
>> + =A0 =A0 return dparent;
>> +}
>> +
>> =A0static struct dentry *
>> =A0cifs_do_mount(struct file_system_type *fs_type,
>> =A0 =A0 =A0 =A0 =A0 =A0 int flags, const char *dev_name, void *data)
>> @@ -603,7 +687,12 @@ cifs_do_mount(struct file_system_type *fs_type,
>>
>> =A0 =A0 =A0 sb->s_flags |=3D MS_ACTIVE;
>>
>> - =A0 =A0 root =3D dget(sb->s_root);
>> + =A0 =A0 root =3D cifs_get_root(volume_info, sb);
>> + =A0 =A0 if (root =3D=3D NULL) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 kfree(copied_data);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto err_out;
>> + =A0 =A0 }
>> + =A0 =A0 cFYI(1, "dentry root is: %p", root);
>> =A0out:
>> =A0 =A0 =A0 cifs_cleanup_volume_info(&volume_info);
>> =A0 =A0 =A0 return root;
>
> [...]
>
>> @@ -887,16 +887,17 @@ struct inode *cifs_root_iget(struct super_bloc=
k *sb)
>> =A0 =A0 =A0 char *full_path;
>> =A0 =A0 =A0 struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
>>
>> - =A0 =A0 full_path =3D cifs_build_path_to_root(cifs_sb, tcon);
>> + =A0 =A0 full_path =3D kmalloc(1, GFP_KERNEL);
>> =A0 =A0 =A0 if (full_path =3D=3D NULL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(-ENOMEM);
>> + =A0 =A0 full_path[0] =3D 0;
>>
>
> Don't kmalloc 1 byte, just pass "" or do it on the stack instead.
>
>> =A0 =A0 =A0 xid =3D GetXid();
>> =A0 =A0 =A0 if (tcon->unix_ext)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_get_inode_info_unix(&inode, =
full_path, sb, xid);
>> =A0 =A0 =A0 else
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_get_inode_info(&inode, full_pa=
th, NULL, sb,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 xid, NULL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_get_inode_info(&inode, full_pa=
th, NULL, sb, xid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0NULL);
>>
>> =A0 =A0 =A0 if (!inode) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 inode =3D ERR_PTR(rc);
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

Thanks! Good points - I will respin this patch.

--=20
Best regards,
Pavel Shilovsky.
