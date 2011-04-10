From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 3/3] CIFS: Migrate to shared superblock model
Date: Sun, 10 Apr 2011 23:13:13 +0400
Message-ID: <BANLkTi=2-HsiaoPuf8NbfTMUZuGP2MS6Jg@mail.gmail.com>
References: <1302429954-9927-1-git-send-email-piastry@etersoft.ru>
	<1302429954-9927-3-git-send-email-piastry@etersoft.ru>
	<20110410103143.7312409b@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110410103143.7312409b-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/4/10 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Sun, 10 Apr 2011 14:05:54 +0400
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
>> =A0fs/cifs/cifsfs.c =A0| =A0 =A06 ++-
>> =A0fs/cifs/connect.c | =A0 93 ++++++++++++++++++++++++++++++++++++++=
+++++++++++++++
>> =A02 files changed, 97 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index c40c1f4..abc8436 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -577,14 +577,16 @@ cifs_do_mount(struct file_system_type *fs_type=
,
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(rc);
>>
>> - =A0 =A0 sb =3D sget(fs_type, NULL, set_anon_super, NULL);
>> + =A0 =A0 sb =3D sget(fs_type, cifs_match_super, set_anon_super, vol=
ume_info);
>> =A0 =A0 =A0 if (IS_ERR(sb)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_cleanup_volume_info(&volume_info);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ERR_CAST(sb);
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 if (sb->s_fs_info)
>> + =A0 =A0 if (sb->s_fs_info) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Use existing superblock");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 }
>>
>> =A0 =A0 =A0 sb->s_flags =3D flags;
>>
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 53b79e7..7c98c36 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -2193,6 +2193,99 @@ cifs_put_tlink(struct tcon_link *tlink)
>> =A0 =A0 =A0 return;
>> =A0}
>>
>> +static void setup_cifs_sb(struct smb_vol *vol, struct cifs_sb_info =
*sb);
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
>> +compare_mount_options(struct super_block *sb, struct smb_vol *vol)
>> +{
>> + =A0 =A0 struct cifs_sb_info *old =3D CIFS_SB(sb), new;
>> +
>> + =A0 =A0 setup_cifs_sb(vol, &new);
>> +
>> + =A0 =A0 if ((old->mnt_cifs_flags & ACTUAL_MOUNT_FLAGS) !=3D
>> + =A0 =A0 =A0 =A0 (new.mnt_cifs_flags & ACTUAL_MOUNT_FLAGS))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
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
>
> I don't think this is really what you want...
>
> Suppose I mount the same share twice, but with 2 different prepaths.
> For instance:
>
> //server/share/foo
>
> ...and...
>
> //server/share/foo/bar
>
> ...shouldn't the inodes for files/directories accessable via both
> mounts be shared in that case?
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

I understand that sharing superblock in your case is a good idea, but
it can be another task, I think, - we can always add this capability
later.

Now I suggest to discuss mount option list - are you agree with it? or
we can drop/add something?

--=20
Best regards,
Pavel Shilovsky.
