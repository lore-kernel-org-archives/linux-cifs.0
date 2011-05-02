From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 2/4] CIFS: Simplify mount code for further shared sb capability
Date: Mon, 2 May 2011 18:01:05 +0400
Message-ID: <BANLkTimOMO3FXq+jNt6bHwnYEAfkSbYLRw@mail.gmail.com>
References: <1302850916-13947-1-git-send-email-piastry@etersoft.ru>
	<20110502082350.6d0cbc77@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110502082350.6d0cbc77-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/5/2 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> On Fri, 15 Apr 2011 11:01:54 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Reorganize code to get mount option at first and when get a superblo=
ck.
>> This lets us use shared superblock model further for equal mounts.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsfs.c =A0 =A0| =A0 88 ++++++++++++++++++++++++++++++++=
------------------
>> =A0fs/cifs/cifsproto.h | =A0 =A08 ++++-
>> =A0fs/cifs/connect.c =A0 | =A0 89 ++++++++++++++++++++++++++++------=
----------------
>> =A03 files changed, 114 insertions(+), 71 deletions(-)
>>
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index 9cfbfd2..3227db6 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -109,19 +109,16 @@ cifs_sb_deactive(struct super_block *sb)
>> =A0}
>>
>> =A0static int
>> -cifs_read_super(struct super_block *sb, void *data,
>> - =A0 =A0 =A0 =A0 =A0 =A0 const char *devname, int silent)
>> +cifs_read_super(struct super_block *sb, struct cifs_sb_info *cifs_s=
b,
>> + =A0 =A0 =A0 =A0 =A0 =A0 void *data, struct smb_vol *volume_info, c=
onst char *devname,
>> + =A0 =A0 =A0 =A0 =A0 =A0 int silent)
>> =A0{
>> =A0 =A0 =A0 struct inode *inode;
>> - =A0 =A0 struct cifs_sb_info *cifs_sb;
>> =A0 =A0 =A0 int rc =3D 0;
>>
>> =A0 =A0 =A0 /* BB should we make this contingent on mount parm? */
>> =A0 =A0 =A0 sb->s_flags |=3D MS_NODIRATIME | MS_NOATIME;
>> - =A0 =A0 sb->s_fs_info =3D kzalloc(sizeof(struct cifs_sb_info), GFP=
_KERNEL);
>> - =A0 =A0 cifs_sb =3D CIFS_SB(sb);
>> - =A0 =A0 if (cifs_sb =3D=3D NULL)
>> - =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> + =A0 =A0 sb->s_fs_info =3D cifs_sb;
>>
>> =A0 =A0 =A0 spin_lock_init(&cifs_sb->tlink_tree_lock);
>> =A0 =A0 =A0 cifs_sb->tlink_tree =3D RB_ROOT;
>> @@ -133,22 +130,10 @@ cifs_read_super(struct super_block *sb, void *=
data,
>> =A0 =A0 =A0 }
>> =A0 =A0 =A0 cifs_sb->bdi.ra_pages =3D default_backing_dev_info.ra_pa=
ges;
>>
>> - =A0 =A0 /*
>> - =A0 =A0 =A0* Copy mount params to sb for use in submounts. Better =
to do
>> - =A0 =A0 =A0* the copy here and deal with the error before cleanup =
gets
>> - =A0 =A0 =A0* complicated post-mount.
>> - =A0 =A0 =A0*/
>> - =A0 =A0 if (data) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mountdata =3D kstrndup(data, PAGE=
_SIZE, GFP_KERNEL);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (cifs_sb->mountdata =3D=3D NULL) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bdi_destroy(&cifs_sb->bdi)=
;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(sb->s_fs_info);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sb->s_fs_info =3D NULL;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 }
>> + =A0 =A0 if (data)
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mountdata =3D data;
>>
>> - =A0 =A0 rc =3D cifs_mount(sb, cifs_sb, devname);
>> + =A0 =A0 rc =3D cifs_mount(sb, cifs_sb, volume_info, devname);
>>
>> =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!silent)
>> @@ -566,27 +551,68 @@ static const struct super_operations cifs_supe=
r_ops =3D {
>>
>> =A0static struct dentry *
>> =A0cifs_do_mount(struct file_system_type *fs_type,
>> - =A0 =A0 =A0 =A0 int flags, const char *dev_name, void *data)
>> + =A0 =A0 =A0 =A0 =A0 int flags, const char *dev_name, void *data)
>> =A0{
>> =A0 =A0 =A0 int rc;
>> =A0 =A0 =A0 struct super_block *sb;
>> -
>> - =A0 =A0 sb =3D sget(fs_type, NULL, set_anon_super, NULL);
>> + =A0 =A0 struct cifs_sb_info *cifs_sb;
>> + =A0 =A0 struct smb_vol *volume_info;
>> + =A0 =A0 struct dentry *root;
>> + =A0 =A0 char *copied_data =3D NULL;
>>
>> =A0 =A0 =A0 cFYI(1, "Devname: %s flags: %d ", dev_name, flags);
>>
>> - =A0 =A0 if (IS_ERR(sb))
>> - =A0 =A0 =A0 =A0 =A0 =A0 return ERR_CAST(sb);
>> + =A0 =A0 rc =3D cifs_setup_volume_info(&volume_info, (char *)data, =
dev_name);
>> + =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(rc);
>> +
>> + =A0 =A0 cifs_sb =3D kzalloc(sizeof(struct cifs_sb_info), GFP_KERNE=
L);
>> + =A0 =A0 if (cifs_sb =3D=3D NULL) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 root =3D ERR_PTR(-ENOMEM);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 cifs_setup_cifs_sb(volume_info, cifs_sb);
>> +
>> + =A0 =A0 sb =3D sget(fs_type, NULL, set_anon_super, NULL);
>> + =A0 =A0 if (IS_ERR(sb)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 kfree(cifs_sb);
>> + =A0 =A0 =A0 =A0 =A0 =A0 root =3D ERR_CAST(sb);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 }
>>
>> =A0 =A0 =A0 sb->s_flags =3D flags;
>>
>> - =A0 =A0 rc =3D cifs_read_super(sb, data, dev_name, flags & MS_SILE=
NT ? 1 : 0);
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* Copy mount params for use in submounts. Better to do
>> + =A0 =A0 =A0* the copy here and deal with the error before cleanup =
gets
>> + =A0 =A0 =A0* complicated post-mount.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 copied_data =3D kstrndup(data, PAGE_SIZE, GFP_KERNEL);
>> + =A0 =A0 if (copied_data =3D=3D NULL) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 root =3D ERR_PTR(-ENOMEM);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto err_out;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 rc =3D cifs_read_super(sb, cifs_sb, copied_data, volume_in=
fo, dev_name,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flags & MS_SILE=
NT ? 1 : 0);
>> =A0 =A0 =A0 if (rc) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 deactivate_locked_super(sb);
>> - =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 root =3D ERR_PTR(rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto err_out;
>> =A0 =A0 =A0 }
>> +
>> =A0 =A0 =A0 sb->s_flags |=3D MS_ACTIVE;
>> - =A0 =A0 return dget(sb->s_root);
>> +
>> + =A0 =A0 root =3D dget(sb->s_root);
>> +out:
>> + =A0 =A0 cifs_cleanup_volume_info(&volume_info);
>> + =A0 =A0 return root;
>> +
>> +err_out:
>> + =A0 =A0 kfree(cifs_sb);
>> + =A0 =A0 deactivate_locked_super(sb);
>> + =A0 =A0 cifs_cleanup_volume_info(&volume_info);
>> + =A0 =A0 return root;
>> =A0}
>>
>> =A0static ssize_t cifs_file_aio_write(struct kiocb *iocb, const stru=
ct iovec *iov,
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index 9985f99..ffd16c8 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -146,8 +146,14 @@ extern struct cifs_ntsd *get_cifs_acl(struct ci=
fs_sb_info *, struct inode *,
>> =A0extern int set_cifs_acl(struct cifs_ntsd *, __u32, struct inode *=
,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const ch=
ar *);
>>
>> +extern void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct cifs=
_sb_info *cifs_sb);
>> +extern int cifs_match_super(struct super_block *, void *);
>> +extern void cifs_cleanup_volume_info(struct smb_vol **pvolume_info)=
;
>> +extern int cifs_setup_volume_info(struct smb_vol **pvolume_info,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *=
mount_data, const char *devname);
>> =A0extern int cifs_mount(struct super_block *, struct cifs_sb_info *=
,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct smb_vol *, const char *=
);
>> =A0extern int cifs_umount(struct super_block *, struct cifs_sb_info =
*);
>> =A0extern void cifs_dfs_release_automount_timer(void);
>> =A0void cifs_proc_init(void);
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 990c3e0..0b41f75 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -2626,8 +2626,8 @@ convert_delimiter(char *path, char delim)
>> =A0 =A0 =A0 }
>> =A0}
>>
>> -static void setup_cifs_sb(struct smb_vol *pvolume_info,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_sb_info *c=
ifs_sb)
>> +void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_sb_info *cifs_=
sb)
>> =A0{
>> =A0 =A0 =A0 INIT_DELAYED_WORK(&cifs_sb->prune_tlinks, cifs_prune_tli=
nks);
>>
>> @@ -2683,6 +2683,7 @@ static void setup_cifs_sb(struct smb_vol *pvol=
ume_info,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_file_mode, cifs_sb->mnt_dir=
_mode);
>>
>> =A0 =A0 =A0 cifs_sb->actimeo =3D pvolume_info->actimeo;
>> + =A0 =A0 cifs_sb->local_nls =3D pvolume_info->local_nls;
>>
>> =A0 =A0 =A0 if (pvolume_info->noperm)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags |=3D CIFS_MOUNT_=
NO_PERM;
>> @@ -2754,8 +2755,8 @@ is_path_accessible(int xid, struct cifs_tcon *=
tcon,
>> =A0 =A0 =A0 return rc;
>> =A0}
>>
>> -static void
>> -cleanup_volume_info(struct smb_vol **pvolume_info)
>> +void
>> +cifs_cleanup_volume_info(struct smb_vol **pvolume_info)
>> =A0{
>> =A0 =A0 =A0 struct smb_vol *volume_info;
>>
>> @@ -2861,40 +2862,13 @@ expand_dfs_referral(int xid, struct cifs_ses=
 *pSesInfo,
>> =A0}
>> =A0#endif
>>
>> -int
>> -cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
>> - =A0 =A0 =A0 =A0 =A0 =A0 const char *devname)
>> +int cifs_setup_volume_info(struct smb_vol **pvolume_info, char *mou=
nt_data,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const char *devname=
)
>> =A0{
>> - =A0 =A0 int rc;
>> - =A0 =A0 int xid;
>> =A0 =A0 =A0 struct smb_vol *volume_info;
>> - =A0 =A0 struct cifs_ses *pSesInfo;
>> - =A0 =A0 struct cifs_tcon *tcon;
>> - =A0 =A0 struct TCP_Server_Info *srvTcp;
>> - =A0 =A0 char =A0 *full_path;
>> - =A0 =A0 struct tcon_link *tlink;
>> -#ifdef CONFIG_CIFS_DFS_UPCALL
>> - =A0 =A0 int referral_walks_count =3D 0;
>> -try_mount_again:
>> - =A0 =A0 /* cleanup activities if we're chasing a referral */
>> - =A0 =A0 if (referral_walks_count) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (tcon)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_put_tcon(tcon);
>> - =A0 =A0 =A0 =A0 =A0 =A0 else if (pSesInfo)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_put_smb_ses(pSesInfo)=
;
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 cleanup_volume_info(&volume_info);
>> - =A0 =A0 =A0 =A0 =A0 =A0 FreeXid(xid);
>> - =A0 =A0 }
>> -#endif
>> - =A0 =A0 rc =3D 0;
>> - =A0 =A0 tcon =3D NULL;
>> - =A0 =A0 pSesInfo =3D NULL;
>> - =A0 =A0 srvTcp =3D NULL;
>> - =A0 =A0 full_path =3D NULL;
>> - =A0 =A0 tlink =3D NULL;
>> + =A0 =A0 int rc =3D 0;
>>
>> - =A0 =A0 xid =3D GetXid();
>> + =A0 =A0 *pvolume_info =3D NULL;
>>
>> =A0 =A0 =A0 volume_info =3D kzalloc(sizeof(struct smb_vol), GFP_KERN=
EL);
>> =A0 =A0 =A0 if (!volume_info) {
>> @@ -2902,7 +2876,7 @@ try_mount_again:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 if (cifs_parse_mount_options(cifs_sb->mountdata, devname,
>> + =A0 =A0 if (cifs_parse_mount_options(mount_data, devname,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0volume_info)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EINVAL;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> @@ -2935,7 +2909,46 @@ try_mount_again:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 }
>> - =A0 =A0 cifs_sb->local_nls =3D volume_info->local_nls;
>> +
>> + =A0 =A0 *pvolume_info =3D volume_info;
>> + =A0 =A0 return rc;
>> +out:
>> + =A0 =A0 cifs_cleanup_volume_info(&volume_info);
>> + =A0 =A0 return rc;
>> +}
>> +
>> +int
>> +cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
>> + =A0 =A0 =A0 =A0struct smb_vol *volume_info, const char *devname)
>> +{
>> + =A0 =A0 int rc =3D 0;
>> + =A0 =A0 int xid;
>> + =A0 =A0 struct cifs_ses *pSesInfo;
>> + =A0 =A0 struct cifs_tcon *tcon;
>> + =A0 =A0 struct TCP_Server_Info *srvTcp;
>> + =A0 =A0 char =A0 *full_path;
>> + =A0 =A0 struct tcon_link *tlink;
>> +#ifdef CONFIG_CIFS_DFS_UPCALL
>> + =A0 =A0 int referral_walks_count =3D 0;
>> +try_mount_again:
>> + =A0 =A0 /* cleanup activities if we're chasing a referral */
>> + =A0 =A0 if (referral_walks_count) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (tcon)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_put_tcon(tcon);
>> + =A0 =A0 =A0 =A0 =A0 =A0 else if (pSesInfo)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_put_smb_ses(pSesInfo)=
;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_cleanup_volume_info(&volume_info);
>> + =A0 =A0 =A0 =A0 =A0 =A0 FreeXid(xid);
>> + =A0 =A0 }
>> +#endif
>> + =A0 =A0 tcon =3D NULL;
>> + =A0 =A0 pSesInfo =3D NULL;
>> + =A0 =A0 srvTcp =3D NULL;
>> + =A0 =A0 full_path =3D NULL;
>> + =A0 =A0 tlink =3D NULL;
>> +
>> + =A0 =A0 xid =3D GetXid();
>>
>> =A0 =A0 =A0 /* get a reference to a tcp session */
>> =A0 =A0 =A0 srvTcp =3D cifs_get_tcp_session(volume_info);
>> @@ -2952,7 +2965,6 @@ try_mount_again:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto mount_fail_check;
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 setup_cifs_sb(volume_info, cifs_sb);
>> =A0 =A0 =A0 if (pSesInfo->capabilities & CAP_LARGE_FILES)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sb->s_maxbytes =3D MAX_LFS_FILESIZE;
>> =A0 =A0 =A0 else
>> @@ -3108,7 +3120,6 @@ mount_fail_check:
>> =A0 =A0 =A0 password will be freed at unmount time) */
>> =A0out:
>> =A0 =A0 =A0 /* zero out password before freeing */
>> - =A0 =A0 cleanup_volume_info(&volume_info);
>> =A0 =A0 =A0 FreeXid(xid);
>> =A0 =A0 =A0 return rc;
>> =A0}
>
> Again, looks like a reasonable change, but you'll probably need to wo=
rk
> with Sean or just rebase your patches on top of his since he's made
> some changes to this area recently.
>

I create this patchset on top of Sean's DFS related patchset - so, it
seems like no problems in this case.

--=20
Best regards,
Pavel Shilovsky.
