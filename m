From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Add shared superblock capability
Date: Sun, 10 Apr 2011 11:54:08 +0400
Message-ID: <BANLkTinNuvCGcKTd_j9RZFcVORqJVvZ1Yg@mail.gmail.com>
References: <1302098613-7586-1-git-send-email-piastry@etersoft.ru>
	<20110408094317.71acd67c@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110408094317.71acd67c-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/4/8 Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>:
> On Wed, =A06 Apr 2011 18:03:33 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Now we can share super block if server, session, tree connect and
>> mount options match requested ones.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>
> At the risk of being blunt -- so what? What problem does this solve?

It let us use the same inode cache for several mounts with the same
//server/sharename and creds. This improve performance for future
SMB2.1 implementation where we can share cache between several fids on
one connection (smb2.1 leases).

>
> There's also no description of what you're changing, and the approach
> that you're taking to do these changes.

Ok, I will fix this. I also noticed that Sean Finney's set change code
that my patch touches - so, I think I should base it on the top of it.

>
> Finally, this patch is huge. Might it make sense to break it up into =
a
> set of more incremental changes so that when regressions are found in
> it that we can reasonably bisect them down?

Yes, will post the set later.

>
>> ---
>> =A0fs/cifs/cifsfs.c =A0 =A0| =A0 51 ++++++----
>> =A0fs/cifs/cifsglob.h =A0| =A0 =A01 +
>> =A0fs/cifs/cifsproto.h | =A0 =A08 +-
>> =A0fs/cifs/connect.c =A0 | =A0277 ++++++++++++++++++++++++++++++++++=
+++--------------
>> =A04 files changed, 242 insertions(+), 95 deletions(-)
>>
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index fb6a2ad..4425bfc 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -109,7 +109,7 @@ cifs_sb_deactive(struct super_block *sb)
>> =A0}
>>
>> =A0static int
>> -cifs_read_super(struct super_block *sb, void *data,
>> +cifs_read_super(struct super_block *sb, void *data, struct smb_vol =
*volume_info,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *devname, int silent)
>> =A0{
>> =A0 =A0 =A0 struct inode *inode;
>> @@ -141,21 +141,11 @@ cifs_read_super(struct super_block *sb, void *=
data,
>> =A0 =A0 =A0 =A0* complex operation (mount), and in case of fail
>> =A0 =A0 =A0 =A0* just exit instead of doing mount and attempting
>> =A0 =A0 =A0 =A0* undo it if this copy fails?*/
>> - =A0 =A0 if (data) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 int len =3D strlen(data);
>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mountdata =3D kzalloc(len + 1, GF=
P_KERNEL);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (cifs_sb->mountdata =3D=3D NULL) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bdi_destroy(&cifs_sb->bdi)=
;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(sb->s_fs_info);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sb->s_fs_info =3D NULL;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 strncpy(cifs_sb->mountdata, data, len + 1)=
;
>> - =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mountdata[len] =3D '\0';
>> - =A0 =A0 }
>> + =A0 =A0 if (data)
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mountdata =3D data;
>> =A0#endif
>>
>> - =A0 =A0 rc =3D cifs_mount(sb, cifs_sb, data, devname);
>> + =A0 =A0 rc =3D cifs_mount(sb, cifs_sb, volume_info, devname);
>>
>> =A0 =A0 =A0 if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!silent)
>> @@ -581,23 +571,46 @@ cifs_do_mount(struct file_system_type *fs_type=
,
>> =A0{
>> =A0 =A0 =A0 int rc;
>> =A0 =A0 =A0 struct super_block *sb;
>> -
>> - =A0 =A0 sb =3D sget(fs_type, NULL, set_anon_super, NULL);
>> -
>> + =A0 =A0 struct smb_vol *volume_info;
>> + =A0 =A0 char *copied_data =3D NULL;
>> +#ifdef CONFIG_CIFS_DFS_UPCALL
>> + =A0 =A0 int len =3D strlen(data);
>> + =A0 =A0 copied_data =3D kzalloc(len + 1, GFP_KERNEL);
>> + =A0 =A0 if (copied_data =3D=3D NULL)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(-ENOMEM);
>> + =A0 =A0 strncpy(copied_data, data, len + 1);
>> + =A0 =A0 copied_data[len] =3D '\0';
>> +#endif
>> =A0 =A0 =A0 cFYI(1, "Devname: %s flags: %d ", dev_name, flags);
>>
>> - =A0 =A0 if (IS_ERR(sb))
>> + =A0 =A0 rc =3D cifs_setup_volume_info(&volume_info, (char *)data, =
dev_name);
>> + =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(rc);
>> +
>> + =A0 =A0 sb =3D sget(fs_type, cifs_match_super, set_anon_super, vol=
ume_info);
>> + =A0 =A0 if (IS_ERR(sb)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_cleanup_volume_info(&volume_info);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ERR_CAST(sb);
>> + =A0 =A0 }
>> +
>> + =A0 =A0 if (sb->s_fs_info)
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>>
>> =A0 =A0 =A0 sb->s_flags =3D flags;
>>
>> - =A0 =A0 rc =3D cifs_read_super(sb, data, dev_name, flags & MS_SILE=
NT ? 1 : 0);
>> + =A0 =A0 rc =3D cifs_read_super(sb, copied_data, volume_info, dev_n=
ame,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flags & MS_SILE=
NT ? 1 : 0);
>> =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_cleanup_volume_info(&volume_info);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 deactivate_locked_super(sb);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(rc);
>> =A0 =A0 =A0 }
>> +
>> +out:
>> + =A0 =A0 cifs_cleanup_volume_info(&volume_info);
>> =A0 =A0 =A0 sb->s_flags |=3D MS_ACTIVE;
>> =A0 =A0 =A0 return dget(sb->s_root);
>> +
>> =A0}
>>
>> =A0static ssize_t cifs_file_aio_write(struct kiocb *iocb, const stru=
ct iovec *iov,
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index ccbac61..f3279bf 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -444,6 +444,7 @@ cifs_get_tlink(struct tcon_link *tlink)
>> =A0/* This function is always expected to succeed */
>> =A0extern struct cifs_tcon *cifs_sb_master_tcon(struct cifs_sb_info =
*cifs_sb);
>>
>> +extern struct tcon_link *cifs_sb_master_tlink(struct cifs_sb_info *=
cifs_sb);
>> =A0/*
>> =A0 * This info hangs off the cifsFileInfo structure, pointed to by =
llist.
>> =A0 * This is used to track byte stream locks on the file
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index 76c4dc7..3336c2d 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -146,8 +146,12 @@ extern struct cifs_ntsd *get_cifs_acl(struct ci=
fs_sb_info *, struct inode *,
>> =A0extern int set_cifs_acl(struct cifs_ntsd *, __u32, struct inode *=
,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const ch=
ar *);
>>
>> -extern int cifs_mount(struct super_block *, struct cifs_sb_info *, =
char *,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *);
>> +extern int cifs_match_super(struct super_block *, void *);
>> +extern void cifs_cleanup_volume_info(struct smb_vol **pvolume_info)=
;
>> +extern int cifs_setup_volume_info(struct smb_vol **pvolume_info,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *=
mount_data, const char *devname);
>> +extern int cifs_mount(struct super_block *, struct cifs_sb_info *,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct smb_vol *, const char *=
);
>> =A0extern int cifs_umount(struct super_block *, struct cifs_sb_info =
*);
>> =A0extern void cifs_dfs_release_automount_timer(void);
>> =A0void cifs_proc_init(void);
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 94e60c5..c2431d0 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -1603,32 +1603,41 @@ match_security(struct TCP_Server_Info *serve=
r, struct smb_vol *vol)
>> =A0 =A0 =A0 return true;
>> =A0}
>>
>> -static struct TCP_Server_Info *
>> -cifs_find_tcp_session(struct sockaddr *addr, struct smb_vol *vol)
>> +static int match_server(struct TCP_Server_Info *server, struct sock=
addr *addr,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct smb_vol *vol)
>> =A0{
>> - =A0 =A0 struct TCP_Server_Info *server;
>> -
>> - =A0 =A0 spin_lock(&cifs_tcp_ses_lock);
>> - =A0 =A0 list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_li=
st) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (!net_eq(cifs_net_ns(server), current->=
nsproxy->net_ns))
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> + =A0 =A0 if (!net_eq(cifs_net_ns(server), current->nsproxy->net_ns)=
)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (!match_address(server, addr,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(st=
ruct sockaddr *)&vol->srcaddr))
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> + =A0 =A0 if (!match_address(server, addr,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct sockaddr *)=
&vol->srcaddr))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>>
>> =A0#ifdef CONFIG_CIFS_SMB2
>> - =A0 =A0 =A0 =A0 =A0 =A0 if ((server->is_smb2 =3D=3D true) && (vol-=
>use_smb2 =3D=3D false))
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> + =A0 =A0 if ((server->is_smb2 =3D=3D true) && (vol->use_smb2 =3D=3D=
 false))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 if ((server->is_smb2 =3D=3D false) && (vol=
->use_smb2 =3D=3D true))
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> + =A0 =A0 if ((server->is_smb2 =3D=3D false) && (vol->use_smb2 =3D=3D=
 true))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> =A0#endif /* CONFIG_CIFS_SMB2 */
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (!match_port(server, addr))
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> + =A0 =A0 if (!match_port(server, addr))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (!match_security(server, vol))
>> + =A0 =A0 if (!match_security(server, vol))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 return 1;
>> +}
>> +
>> +static struct TCP_Server_Info *
>> +cifs_find_tcp_session(struct sockaddr *addr, struct smb_vol *vol)
>> +{
>> + =A0 =A0 struct TCP_Server_Info *server;
>> +
>> + =A0 =A0 spin_lock(&cifs_tcp_ses_lock);
>> + =A0 =A0 list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_li=
st) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!match_server(server, addr, vol))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++server->srv_count;
>> @@ -1828,6 +1837,30 @@ out_err:
>> =A0 =A0 =A0 return ERR_PTR(rc);
>> =A0}
>>
>> +static int match_session(struct cifs_ses *ses, struct smb_vol *vol)
>> +{
>> + =A0 =A0 switch (ses->server->secType) {
>> + =A0 =A0 case Kerberos:
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (vol->cred_uid !=3D ses->cred_uid)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 default:
>> + =A0 =A0 =A0 =A0 =A0 =A0 /* anything else takes username/password *=
/
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (ses->user_name =3D=3D NULL)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (strncmp(ses->user_name, vol->username,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MAX_USERNAME_SIZE)=
)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (strlen(vol->username) !=3D 0 &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->password !=3D NULL &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 strncmp(ses->password,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->password ? vo=
l->password : "",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MAX_PASSWORD_SIZE)=
)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> + =A0 =A0 }
>> + =A0 =A0 return 1;
>> +}
>> +
>> =A0static struct cifs_ses *
>> =A0cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb_vol =
*vol)
>> =A0{
>> @@ -1835,25 +1868,8 @@ cifs_find_smb_ses(struct TCP_Server_Info *ser=
ver, struct smb_vol *vol)
>>
>> =A0 =A0 =A0 spin_lock(&cifs_tcp_ses_lock);
>> =A0 =A0 =A0 list_for_each_entry(ses, &server->smb_ses_list, smb_ses_=
list) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 switch (server->secType) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 case Kerberos:
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (vol->cred_uid !=3D ses=
->cred_uid)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> - =A0 =A0 =A0 =A0 =A0 =A0 default:
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* anything else takes use=
rname/password */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ses->user_name =3D=3D =
NULL)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (strncmp(ses->user_name=
, vol->username,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MA=
X_USERNAME_SIZE))
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (strlen(vol->username) =
!=3D 0 &&
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->password !=3D=
 NULL &&
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 strncmp(ses->passw=
ord,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vo=
l->password ? vol->password : "",
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 MA=
X_PASSWORD_SIZE))
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!match_session(ses, vol))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++ses->ses_count;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&cifs_tcp_ses_lock);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ses;
>> @@ -1996,6 +2012,15 @@ get_ses_fail:
>> =A0 =A0 =A0 return ERR_PTR(rc);
>> =A0}
>>
>> +static int match_tcon(struct cifs_tcon *tcon, const char *unc)
>> +{
>> + =A0 =A0 if (tcon->tidStatus =3D=3D CifsExiting)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> + =A0 =A0 if (strncmp(tcon->treeName, unc, MAX_TREE_SIZE))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> + =A0 =A0 return 1;
>> +}
>> +
>> =A0static struct cifs_tcon *
>> =A0cifs_find_tcon(struct cifs_ses *ses, const char *unc)
>> =A0{
>> @@ -2005,11 +2030,8 @@ cifs_find_tcon(struct cifs_ses *ses, const ch=
ar *unc)
>> =A0 =A0 =A0 spin_lock(&cifs_tcp_ses_lock);
>> =A0 =A0 =A0 list_for_each(tmp, &ses->tcon_list) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 tcon =3D list_entry(tmp, struct cifs_tco=
n, tcon_list);
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (tcon->tidStatus =3D=3D CifsExiting)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (strncmp(tcon->treeName, unc, MAX_TREE_=
SIZE))
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!match_tcon(tcon, unc))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> -
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++tcon->tc_count;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&cifs_tcp_ses_lock);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return tcon;
>> @@ -2136,6 +2158,101 @@ cifs_put_tlink(struct tcon_link *tlink)
>> =A0 =A0 =A0 return;
>> =A0}
>>
>> +static void setup_cifs_sb(struct smb_vol *vol, struct cifs_sb_info =
*sb);
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
>> +compare_mount_options(struct super_block *sb, struct smb_vol *vol)
>> +{
>> + =A0 =A0 struct cifs_sb_info *old =3D CIFS_SB(sb), new;
>> +
>> + =A0 =A0 setup_cifs_sb(vol, &new);
>> +
>> + =A0 =A0 cFYI(1, "before mount option check");
>> + =A0 =A0 cFYI(1, "%d %d", old->mnt_cifs_flags, new.mnt_cifs_flags);
>> +
>> + =A0 =A0 if ((old->mnt_cifs_flags & ACTUAL_MOUNT_FLAGS) !=3D
>> + =A0 =A0 =A0 =A0 (new.mnt_cifs_flags & ACTUAL_MOUNT_FLAGS))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> + =A0 =A0 cFYI(1, "flags =3D=3D flags");
>> +
>> + =A0 =A0 if (old->rsize !=3D new.rsize || old->wsize !=3D new.wsize=
)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 if (old->mnt_uid !=3D new.mnt_uid || old->mnt_gid !=3D new=
=2Emnt_gid)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 if (old->mnt_file_mode !=3D new.mnt_file_mode ||
>> + =A0 =A0 =A0 =A0 old->mnt_dir_mode !=3D new.mnt_dir_mode)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 if (old->prepathlen !=3D new.prepathlen ||
>> + =A0 =A0 =A0 =A0 strncmp(old->prepath, new.prepath, old->prepathlen=
))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 if (strcmp(old->local_nls->charset, vol->local_nls->charse=
t))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 cFYI(1, "size =3D=3D size");
>> + =A0 =A0 if (old->actimeo !=3D new.actimeo)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> +
>> + =A0 =A0 cFYI(1, "time =3D=3D time");
>> + =A0 =A0 return 1;
>> +}
>> +
>> +int
>> +cifs_match_super(struct super_block *sb, void *data)
>> +{
>> + =A0 =A0 struct smb_vol *volume_info =3D (struct smb_vol *) data;
>> + =A0 =A0 struct TCP_Server_Info *tcp_srv;
>> + =A0 =A0 struct cifs_ses *ses;
>> + =A0 =A0 struct cifs_tcon *tcon;
>> + =A0 =A0 struct cifs_sb_info *cifs_sb;
>> + =A0 =A0 struct tcon_link *tlink;
>> + =A0 =A0 struct sockaddr_storage addr;
>> + =A0 =A0 int rc =3D 0;
>> +
>> + =A0 =A0 memset(&addr, 0, sizeof(struct sockaddr_storage));
>> +
>> + =A0 =A0 spin_lock(&cifs_tcp_ses_lock);
>> + =A0 =A0 cifs_sb =3D CIFS_SB(sb);
>> + =A0 =A0 tlink =3D cifs_get_tlink(cifs_sb_master_tlink(cifs_sb));
>> + =A0 =A0 if (IS_ERR(tlink))
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 tcon =3D tlink_tcon(tlink);
>> + =A0 =A0 ses =3D tcon->ses;
>> + =A0 =A0 tcp_srv =3D ses->server;
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
>> + =A0 =A0 =A0 =A0 !match_tcon(tcon, volume_info->UNC))
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 0;
>> +
>> + =A0 =A0 rc =3D compare_mount_options(sb, volume_info);
>> +out:
>> + =A0 =A0 cifs_put_tlink(tlink);
>> + =A0 =A0 spin_unlock(&cifs_tcp_ses_lock);
>> + =A0 =A0 return rc;
>> +}
>> +
>> =A0int
>> =A0get_dfs_path(int xid, struct cifs_ses *pSesInfo, const char *old_=
path,
>> =A0 =A0 =A0 =A0 =A0 =A0const struct nls_table *nls_codepage, unsigne=
d int *pnum_referrals,
>> @@ -2695,8 +2812,8 @@ is_path_accessible(int xid, struct cifs_tcon *=
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
>> @@ -2744,33 +2861,13 @@ build_unc_path_to_root(const struct smb_vol =
*volume_info,
>> =A0}
>> =A0#endif
>>
>> -int
>> -cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
>> - =A0 =A0 =A0 =A0 =A0 =A0 char *mount_data_global, const char *devna=
me)
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
>> - =A0 =A0 char *mount_data =3D mount_data_global;
>> - =A0 =A0 struct tcon_link *tlink;
>> -#ifdef CONFIG_CIFS_DFS_UPCALL
>> - =A0 =A0 struct dfs_info3_param *referrals =3D NULL;
>> - =A0 =A0 unsigned int num_referrals =3D 0;
>> - =A0 =A0 int referral_walks_count =3D 0;
>> -try_mount_again:
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
>> @@ -2810,6 +2907,41 @@ try_mount_again:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 }
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
>> + =A0 =A0 int rc;
>> + =A0 =A0 int xid;
>> + =A0 =A0 struct cifs_ses *pSesInfo;
>> + =A0 =A0 struct cifs_tcon *tcon;
>> + =A0 =A0 struct TCP_Server_Info *srvTcp;
>> + =A0 =A0 char =A0 *full_path;
>> + =A0 =A0 char *mount_data =3D NULL;
>> + =A0 =A0 struct tcon_link *tlink;
>> +#ifdef CONFIG_CIFS_DFS_UPCALL
>> + =A0 =A0 struct dfs_info3_param *referrals =3D NULL;
>> + =A0 =A0 unsigned int num_referrals =3D 0;
>> + =A0 =A0 int referral_walks_count =3D 0;
>> +try_mount_again:
>> +#endif
>> + =A0 =A0 rc =3D 0;
>> + =A0 =A0 tcon =3D NULL;
>> + =A0 =A0 pSesInfo =3D NULL;
>> + =A0 =A0 srvTcp =3D NULL;
>> + =A0 =A0 full_path =3D NULL;
>> + =A0 =A0 tlink =3D NULL;
>> +
>> + =A0 =A0 xid =3D GetXid();
>> +
>> =A0 =A0 =A0 cifs_sb->local_nls =3D volume_info->local_nls;
>>
>> =A0 =A0 =A0 /* get a reference to a tcp session */
>> @@ -2920,8 +3052,7 @@ remote_path_check:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!rc && num_referrals > 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *fake_devname =3D N=
ULL;
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mount_data !=3D mount_=
data_global)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(moun=
t_data);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(mount_data);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mount_data =3D cifs_comp=
ose_mount_options(
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 cifs_sb->mountdata, full_path + 1,
>> @@ -2942,7 +3073,7 @@ remote_path_check:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (pSesInfo)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_put=
_smb_ses(pSesInfo);
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cleanup_volume_info(&volum=
e_info);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_cleanup_volume_info(&=
volume_info);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 referral_walks_count++;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 FreeXid(xid);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto try_mount_again;
>> @@ -2979,8 +3110,7 @@ remote_path_check:
>> =A0mount_fail_check:
>> =A0 =A0 =A0 /* on error free sesinfo and tcon struct if needed */
>> =A0 =A0 =A0 if (rc) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (mount_data !=3D mount_data_global)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(mount_data);
>> + =A0 =A0 =A0 =A0 =A0 =A0 kfree(mount_data);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* If find_unc succeeded then rc =3D=3D =
0 so we can not end */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* up accidently freeing someone elses t=
con struct */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (tcon)
>> @@ -2998,7 +3128,6 @@ mount_fail_check:
>> =A0 =A0 =A0 password will be freed at unmount time) */
>> =A0out:
>> =A0 =A0 =A0 /* zero out password before freeing */
>> - =A0 =A0 cleanup_volume_info(&volume_info);
>> =A0 =A0 =A0 FreeXid(xid);
>> =A0 =A0 =A0 return rc;
>> =A0}
>> @@ -3338,7 +3467,7 @@ out:
>> =A0 =A0 =A0 return tcon;
>> =A0}
>>
>> -static inline struct tcon_link *
>> +inline struct tcon_link *
>> =A0cifs_sb_master_tlink(struct cifs_sb_info *cifs_sb)
>> =A0{
>> =A0 =A0 =A0 return cifs_sb->master_tlink;
>
>
> --
> Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
Pavel Shilovsky.
