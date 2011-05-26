From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [v2 4/4] CIFS: Migrate to shared superblock model
Date: Thu, 26 May 2011 10:06:16 +0400
Message-ID: <BANLkTik4YD7XJKQi8nVmd4J_oQhBA6aOqw@mail.gmail.com>
References: <1304589314-1147-1-git-send-email-piastry@etersoft.ru>
	<1304589314-1147-4-git-send-email-piastry@etersoft.ru>
	<20110524072250.7337d434@corrin.poochiereds.net>
	<BANLkTi=Y8qx_d4S5YJev61mtavZKtr0B7w@mail.gmail.com>
	<20110525153626.294d2c89@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110525153626.294d2c89-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/5/25 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Wed, 25 May 2011 23:10:33 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> 2011/5/24 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> > On Thu, =A05 May 2011 13:55:14 +0400
>> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>> >
>> >> Add cifs_match_super to use in sget to share superblock between m=
ounts
>> >> that have the same //server/sharename, credentials and mount opti=
ons.
>> >> It helps us to improve performance on work with future SMB2.1 lea=
ses.
>> >>
>> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> >> ---
>> >> =A0fs/cifs/cifsfs.c =A0 | =A0 18 ++++++++++-
>> >> =A0fs/cifs/cifsglob.h | =A0 =A05 +++
>> >> =A0fs/cifs/connect.c =A0| =A0 90 ++++++++++++++++++++++++++++++++=
++++++++++++++++++++
>> >> =A03 files changed, 112 insertions(+), 1 deletions(-)
>> >>
>> >> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> >> index 446b5c2..ba0b7ae 100644
>> >> --- a/fs/cifs/cifsfs.c
>> >> +++ b/fs/cifs/cifsfs.c
>> >> @@ -644,6 +644,7 @@ cifs_do_mount(struct file_system_type *fs_typ=
e,
>> >> =A0 =A0 =A0 struct super_block *sb;
>> >> =A0 =A0 =A0 struct cifs_sb_info *cifs_sb;
>> >> =A0 =A0 =A0 struct smb_vol *volume_info;
>> >> + =A0 =A0 struct cifs_mnt_data mnt_data;
>> >> =A0 =A0 =A0 struct dentry *root;
>> >> =A0 =A0 =A0 char *copied_data =3D NULL;
>> >>
>> >> @@ -661,13 +662,21 @@ cifs_do_mount(struct file_system_type *fs_t=
ype,
>> >>
>> >> =A0 =A0 =A0 cifs_setup_cifs_sb(volume_info, cifs_sb);
>> >>
>> >> - =A0 =A0 sb =3D sget(fs_type, NULL, set_anon_super, NULL);
>> >> + =A0 =A0 mnt_data.vol =3D volume_info;
>> >> + =A0 =A0 mnt_data.cifs_sb =3D cifs_sb;
>> >> +
>> >> + =A0 =A0 sb =3D sget(fs_type, cifs_match_super, set_anon_super, =
&mnt_data);
>> >> =A0 =A0 =A0 if (IS_ERR(sb)) {
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(cifs_sb);
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 root =3D ERR_CAST(sb);
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> >> =A0 =A0 =A0 }
>> >>
>> >> + =A0 =A0 if (sb->s_fs_info) {
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Use existing superblock");
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 goto out_shared;
>> >> + =A0 =A0 }
>> >> +
>> >> =A0 =A0 =A0 sb->s_flags =3D flags;
>> >>
>> >> =A0 =A0 =A0 /*
>> >> @@ -700,6 +709,13 @@ out:
>> >> =A0 =A0 =A0 cifs_cleanup_volume_info(&volume_info);
>> >> =A0 =A0 =A0 return root;
>> >>
>> >> +out_shared:
>> >> + =A0 =A0 root =3D cifs_get_root(volume_info, sb);
>> >> + =A0 =A0 if (root)
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "dentry root is: %p", root);
>> >> + =A0 =A0 cifs_cleanup_volume_info(&volume_info);
>> >> + =A0 =A0 return root;
>> >> +
>> >> =A0err_out:
>> >> =A0 =A0 =A0 kfree(cifs_sb);
>> >> =A0 =A0 =A0 deactivate_locked_super(sb);
>> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> >> index 7ad7d69..55901b0 100644
>> >> --- a/fs/cifs/cifsglob.h
>> >> +++ b/fs/cifs/cifsglob.h
>> >> @@ -211,6 +211,11 @@ struct smb_vol {
>> >> =A0 =A0 =A0 struct nls_table *local_nls;
>> >> =A0};
>> >>
>> >> +struct cifs_mnt_data {
>> >> + =A0 =A0 struct cifs_sb_info *cifs_sb;
>> >> + =A0 =A0 struct smb_vol *vol;
>> >> +};
>> >> +
>> >> =A0struct TCP_Server_Info {
>> >> =A0 =A0 =A0 struct list_head tcp_ses_list;
>> >> =A0 =A0 =A0 struct list_head smb_ses_list;
>> >> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> >> index 1cacfaa..1d39dcf 100644
>> >> --- a/fs/cifs/connect.c
>> >> +++ b/fs/cifs/connect.c
>> >> @@ -2135,6 +2135,96 @@ cifs_put_tlink(struct tcon_link *tlink)
>> >> =A0 =A0 =A0 return;
>> >> =A0}
>> >>
>> >> +static inline struct tcon_link *
>> >> +cifs_sb_master_tlink(struct cifs_sb_info *cifs_sb);
>> >> +
>> >> +static const u32 ACTUAL_MOUNT_FLAGS =3D CIFS_MOUNT_NO_PERM | CIF=
S_MOUNT_SET_UID |
>> >> + =A0 =A0 CIFS_MOUNT_SERVER_INUM | CIFS_MOUNT_DIRECT_IO | CIFS_MO=
UNT_NO_XATTR |
>> >> + =A0 =A0 CIFS_MOUNT_MAP_SPECIAL_CHR | CIFS_MOUNT_UNX_EMUL | CIFS=
_MOUNT_NO_BRL |
>> >> + =A0 =A0 CIFS_MOUNT_CIFS_ACL | CIFS_MOUNT_OVERR_UID | CIFS_MOUNT=
_OVERR_GID |
>> >> + =A0 =A0 CIFS_MOUNT_DYNPERM | CIFS_MOUNT_NOPOSIXBRL | CIFS_MOUNT=
_NOSSYNC |
>> >> + =A0 =A0 CIFS_MOUNT_FSCACHE | CIFS_MOUNT_MF_SYMLINKS | CIFS_MOUN=
T_MULTIUSER |
>> >> + =A0 =A0 CIFS_MOUNT_STRICT_IO;
>> >> +
>> >> +static int
>> >> +compare_mount_options(struct cifs_sb_info *old, struct cifs_sb_i=
nfo *new)
>> >> +{
>> >> + =A0 =A0 if ((old->mnt_cifs_flags & ACTUAL_MOUNT_FLAGS) !=3D
>> >> + =A0 =A0 =A0 =A0 (new->mnt_cifs_flags & ACTUAL_MOUNT_FLAGS))
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> >> +
>> >> + =A0 =A0 if (old->rsize !=3D new->rsize || old->wsize !=3D new->=
wsize)
>> >> + =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> >> +
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^
>> > The rsize and wsize are negotiated -- you can't know what this is =
until
>> > you talk to the server. Doesn't this check always fail?
>>
>> If we don't specify wsize and rsize they are set to default values
>> (16384 and 57344) in both mounts, this check succeed.
>>
>
> Ahh then this will likely be broken if/when the wsize negotiation pat=
ch
> goes in. I suppose we'll have to see which patch (if any) Steve decid=
es
> to commit first and then try to fix this up afterward.
>
> The brokenness shouldn't be too bad, you just won't be able to actual=
ly
> share superblocks until it's fixed.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

Updated patch 4/4 with wsize changes and posted to the list.

--=20
Best regards,
Pavel Shilovsky.
