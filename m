From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [v2 4/4] CIFS: Migrate to shared superblock model
Date: Wed, 25 May 2011 23:10:33 +0400
Message-ID: <BANLkTi=Y8qx_d4S5YJev61mtavZKtr0B7w@mail.gmail.com>
References: <1304589314-1147-1-git-send-email-piastry@etersoft.ru>
	<1304589314-1147-4-git-send-email-piastry@etersoft.ru>
	<20110524072250.7337d434@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110524072250.7337d434-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/5/24 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Thu, =A05 May 2011 13:55:14 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Add cifs_match_super to use in sget to share superblock between moun=
ts
>> that have the same //server/sharename, credentials and mount options=
=2E
>> It helps us to improve performance on work with future SMB2.1 leases=
=2E
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsfs.c =A0 | =A0 18 ++++++++++-
>> =A0fs/cifs/cifsglob.h | =A0 =A05 +++
>> =A0fs/cifs/connect.c =A0| =A0 90 +++++++++++++++++++++++++++++++++++=
+++++++++++++++++
>> =A03 files changed, 112 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index 446b5c2..ba0b7ae 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -644,6 +644,7 @@ cifs_do_mount(struct file_system_type *fs_type,
>> =A0 =A0 =A0 struct super_block *sb;
>> =A0 =A0 =A0 struct cifs_sb_info *cifs_sb;
>> =A0 =A0 =A0 struct smb_vol *volume_info;
>> + =A0 =A0 struct cifs_mnt_data mnt_data;
>> =A0 =A0 =A0 struct dentry *root;
>> =A0 =A0 =A0 char *copied_data =3D NULL;
>>
>> @@ -661,13 +662,21 @@ cifs_do_mount(struct file_system_type *fs_type=
,
>>
>> =A0 =A0 =A0 cifs_setup_cifs_sb(volume_info, cifs_sb);
>>
>> - =A0 =A0 sb =3D sget(fs_type, NULL, set_anon_super, NULL);
>> + =A0 =A0 mnt_data.vol =3D volume_info;
>> + =A0 =A0 mnt_data.cifs_sb =3D cifs_sb;
>> +
>> + =A0 =A0 sb =3D sget(fs_type, cifs_match_super, set_anon_super, &mn=
t_data);
>> =A0 =A0 =A0 if (IS_ERR(sb)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(cifs_sb);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 root =3D ERR_CAST(sb);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> =A0 =A0 =A0 }
>>
>> + =A0 =A0 if (sb->s_fs_info) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Use existing superblock");
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out_shared;
>> + =A0 =A0 }
>> +
>> =A0 =A0 =A0 sb->s_flags =3D flags;
>>
>> =A0 =A0 =A0 /*
>> @@ -700,6 +709,13 @@ out:
>> =A0 =A0 =A0 cifs_cleanup_volume_info(&volume_info);
>> =A0 =A0 =A0 return root;
>>
>> +out_shared:
>> + =A0 =A0 root =3D cifs_get_root(volume_info, sb);
>> + =A0 =A0 if (root)
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "dentry root is: %p", root);
>> + =A0 =A0 cifs_cleanup_volume_info(&volume_info);
>> + =A0 =A0 return root;
>> +
>> =A0err_out:
>> =A0 =A0 =A0 kfree(cifs_sb);
>> =A0 =A0 =A0 deactivate_locked_super(sb);
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 7ad7d69..55901b0 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -211,6 +211,11 @@ struct smb_vol {
>> =A0 =A0 =A0 struct nls_table *local_nls;
>> =A0};
>>
>> +struct cifs_mnt_data {
>> + =A0 =A0 struct cifs_sb_info *cifs_sb;
>> + =A0 =A0 struct smb_vol *vol;
>> +};
>> +
>> =A0struct TCP_Server_Info {
>> =A0 =A0 =A0 struct list_head tcp_ses_list;
>> =A0 =A0 =A0 struct list_head smb_ses_list;
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 1cacfaa..1d39dcf 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -2135,6 +2135,96 @@ cifs_put_tlink(struct tcon_link *tlink)
>> =A0 =A0 =A0 return;
>> =A0}
>>
>> +static inline struct tcon_link *
>> +cifs_sb_master_tlink(struct cifs_sb_info *cifs_sb);
>> +
>> +static const u32 ACTUAL_MOUNT_FLAGS =3D CIFS_MOUNT_NO_PERM | CIFS_M=
OUNT_SET_UID |
>> + =A0 =A0 CIFS_MOUNT_SERVER_INUM | CIFS_MOUNT_DIRECT_IO | CIFS_MOUNT=
_NO_XATTR |
>> + =A0 =A0 CIFS_MOUNT_MAP_SPECIAL_CHR | CIFS_MOUNT_UNX_EMUL | CIFS_MO=
UNT_NO_BRL |
>> + =A0 =A0 CIFS_MOUNT_CIFS_ACL | CIFS_MOUNT_OVERR_UID | CIFS_MOUNT_OV=
ERR_GID |
>> + =A0 =A0 CIFS_MOUNT_DYNPERM | CIFS_MOUNT_NOPOSIXBRL | CIFS_MOUNT_NO=
SSYNC |
>> + =A0 =A0 CIFS_MOUNT_FSCACHE | CIFS_MOUNT_MF_SYMLINKS | CIFS_MOUNT_M=
ULTIUSER |
>> + =A0 =A0 CIFS_MOUNT_STRICT_IO;
>> +
>> +static int
>> +compare_mount_options(struct cifs_sb_info *old, struct cifs_sb_info=
 *new)
>> +{
>> + =A0 =A0 if ((old->mnt_cifs_flags & ACTUAL_MOUNT_FLAGS) !=3D
>> + =A0 =A0 =A0 =A0 (new->mnt_cifs_flags & ACTUAL_MOUNT_FLAGS))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 if (old->rsize !=3D new->rsize || old->wsize !=3D new->wsi=
ze)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^
> The rsize and wsize are negotiated -- you can't know what this is unt=
il
> you talk to the server. Doesn't this check always fail?

If we don't specify wsize and rsize they are set to default values
(16384 and 57344) in both mounts, this check succeed.

>
> The wsize at least is never negotiated up. We only ever negotiate dow=
n,
> so what may be best is to see whether the wsize was actually specifie=
d
> in the mount options and if it's smaller than the existing one. If it
> is then don't match.
>
> I plan to fix the rsize negotiation in a similar fashion once I do a
> readpages overhaul.

Ok, when it is done, we can change compare_mount_options appropriately.

>
>> + =A0 =A0 if (old->mnt_uid !=3D new->mnt_uid || old->mnt_gid !=3D ne=
w->mnt_gid)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 if (old->mnt_file_mode !=3D new->mnt_file_mode ||
>> + =A0 =A0 =A0 =A0 old->mnt_dir_mode !=3D new->mnt_dir_mode)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 if (strcmp(old->local_nls->charset, new->local_nls->charse=
t))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 if (old->actimeo !=3D new->actimeo)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 return 1;
>> +}
>> +
>> +int
>> +cifs_match_super(struct super_block *sb, void *data)
>> +{
>> + =A0 =A0 struct cifs_mnt_data *mnt_data =3D (struct cifs_mnt_data *=
)data;
>> + =A0 =A0 struct smb_vol *volume_info;
>> + =A0 =A0 struct cifs_sb_info *cifs_sb, *new_cifs_sb;
>> + =A0 =A0 struct TCP_Server_Info *tcp_srv;
>> + =A0 =A0 struct cifsSesInfo *ses;
>> + =A0 =A0 struct cifsTconInfo *tcon;
>> + =A0 =A0 struct tcon_link *tlink;
>> + =A0 =A0 struct sockaddr_storage addr;
>> + =A0 =A0 int rc =3D 0;
>> +
>> + =A0 =A0 memset(&addr, 0, sizeof(struct sockaddr_storage));
>> +
>> + =A0 =A0 spin_lock(&cifs_tcp_ses_lock);
>> + =A0 =A0 cifs_sb =3D CIFS_SB(sb);
>> + =A0 =A0 tlink =3D cifs_get_tlink(cifs_sb_master_tlink(cifs_sb));
>> + =A0 =A0 if (IS_ERR(tlink)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&cifs_tcp_ses_lock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>> + =A0 =A0 tcon =3D tlink_tcon(tlink);
>> + =A0 =A0 ses =3D tcon->ses;
>> + =A0 =A0 tcp_srv =3D ses->server;
>> +
>> + =A0 =A0 volume_info =3D mnt_data->vol;
>> + =A0 =A0 new_cifs_sb =3D mnt_data->cifs_sb;
>> +
>> + =A0 =A0 if (!volume_info->UNCip || !volume_info->UNC)
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> +
>> + =A0 =A0 rc =3D cifs_fill_sockaddr((struct sockaddr *)&addr,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 volume_inf=
o->UNCip,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 strlen(vol=
ume_info->UNCip),
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 volume_inf=
o->port);
>> + =A0 =A0 if (!rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> +
>> + =A0 =A0 if (!match_server(tcp_srv, (struct sockaddr *)&addr, volum=
e_info) ||
>> + =A0 =A0 =A0 =A0 !match_session(ses, volume_info) ||
>> + =A0 =A0 =A0 =A0 !match_tcon(tcon, volume_info->UNC)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 rc =3D compare_mount_options(cifs_sb, new_cifs_sb);
>> +out:
>> + =A0 =A0 cifs_put_tlink(tlink);
>> + =A0 =A0 spin_unlock(&cifs_tcp_ses_lock);
>> + =A0 =A0 return rc;
>> +}
>> +
>> =A0int
>> =A0get_dfs_path(int xid, struct cifsSesInfo *pSesInfo, const char *o=
ld_path,
>> =A0 =A0 =A0 =A0 =A0 =A0const struct nls_table *nls_codepage, unsigne=
d int *pnum_referrals,
>
>
> Other than the problem with the rsize/wsize, this looks ok. I don't s=
ee
> that as a show-stopper either, so I suggest we merge this and let Pav=
el
> fix that after the merge window closes.
>
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



--=20
Best regards,
Pavel Shilovsky.
