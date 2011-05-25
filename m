From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [v2 4/4] CIFS: Migrate to shared superblock model
Date: Wed, 25 May 2011 15:36:26 -0400
Message-ID: <20110525153626.294d2c89@tlielax.poochiereds.net>
References: <1304589314-1147-1-git-send-email-piastry@etersoft.ru>
	<1304589314-1147-4-git-send-email-piastry@etersoft.ru>
	<20110524072250.7337d434@corrin.poochiereds.net>
	<BANLkTi=Y8qx_d4S5YJev61mtavZKtr0B7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTi=Y8qx_d4S5YJev61mtavZKtr0B7w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 25 May 2011 23:10:33 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 2011/5/24 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > On Thu, =C2=A05 May 2011 13:55:14 +0400
> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >
> >> Add cifs_match_super to use in sget to share superblock between mo=
unts
> >> that have the same //server/sharename, credentials and mount optio=
ns.
> >> It helps us to improve performance on work with future SMB2.1 leas=
es.
> >>
> >> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >> ---
> >> =C2=A0fs/cifs/cifsfs.c =C2=A0 | =C2=A0 18 ++++++++++-
> >> =C2=A0fs/cifs/cifsglob.h | =C2=A0 =C2=A05 +++
> >> =C2=A0fs/cifs/connect.c =C2=A0| =C2=A0 90 ++++++++++++++++++++++++=
++++++++++++++++++++++++++++
> >> =C2=A03 files changed, 112 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> >> index 446b5c2..ba0b7ae 100644
> >> --- a/fs/cifs/cifsfs.c
> >> +++ b/fs/cifs/cifsfs.c
> >> @@ -644,6 +644,7 @@ cifs_do_mount(struct file_system_type *fs_type=
,
> >> =C2=A0 =C2=A0 =C2=A0 struct super_block *sb;
> >> =C2=A0 =C2=A0 =C2=A0 struct cifs_sb_info *cifs_sb;
> >> =C2=A0 =C2=A0 =C2=A0 struct smb_vol *volume_info;
> >> + =C2=A0 =C2=A0 struct cifs_mnt_data mnt_data;
> >> =C2=A0 =C2=A0 =C2=A0 struct dentry *root;
> >> =C2=A0 =C2=A0 =C2=A0 char *copied_data =3D NULL;
> >>
> >> @@ -661,13 +662,21 @@ cifs_do_mount(struct file_system_type *fs_ty=
pe,
> >>
> >> =C2=A0 =C2=A0 =C2=A0 cifs_setup_cifs_sb(volume_info, cifs_sb);
> >>
> >> - =C2=A0 =C2=A0 sb =3D sget(fs_type, NULL, set_anon_super, NULL);
> >> + =C2=A0 =C2=A0 mnt_data.vol =3D volume_info;
> >> + =C2=A0 =C2=A0 mnt_data.cifs_sb =3D cifs_sb;
> >> +
> >> + =C2=A0 =C2=A0 sb =3D sget(fs_type, cifs_match_super, set_anon_su=
per, &mnt_data);
> >> =C2=A0 =C2=A0 =C2=A0 if (IS_ERR(sb)) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree(cifs_sb);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 root =3D ERR_CAST=
(sb);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
> >> =C2=A0 =C2=A0 =C2=A0 }
> >>
> >> + =C2=A0 =C2=A0 if (sb->s_fs_info) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "Use existing =
superblock");
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out_shared;
> >> + =C2=A0 =C2=A0 }
> >> +
> >> =C2=A0 =C2=A0 =C2=A0 sb->s_flags =3D flags;
> >>
> >> =C2=A0 =C2=A0 =C2=A0 /*
> >> @@ -700,6 +709,13 @@ out:
> >> =C2=A0 =C2=A0 =C2=A0 cifs_cleanup_volume_info(&volume_info);
> >> =C2=A0 =C2=A0 =C2=A0 return root;
> >>
> >> +out_shared:
> >> + =C2=A0 =C2=A0 root =3D cifs_get_root(volume_info, sb);
> >> + =C2=A0 =C2=A0 if (root)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "dentry root i=
s: %p", root);
> >> + =C2=A0 =C2=A0 cifs_cleanup_volume_info(&volume_info);
> >> + =C2=A0 =C2=A0 return root;
> >> +
> >> =C2=A0err_out:
> >> =C2=A0 =C2=A0 =C2=A0 kfree(cifs_sb);
> >> =C2=A0 =C2=A0 =C2=A0 deactivate_locked_super(sb);
> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >> index 7ad7d69..55901b0 100644
> >> --- a/fs/cifs/cifsglob.h
> >> +++ b/fs/cifs/cifsglob.h
> >> @@ -211,6 +211,11 @@ struct smb_vol {
> >> =C2=A0 =C2=A0 =C2=A0 struct nls_table *local_nls;
> >> =C2=A0};
> >>
> >> +struct cifs_mnt_data {
> >> + =C2=A0 =C2=A0 struct cifs_sb_info *cifs_sb;
> >> + =C2=A0 =C2=A0 struct smb_vol *vol;
> >> +};
> >> +
> >> =C2=A0struct TCP_Server_Info {
> >> =C2=A0 =C2=A0 =C2=A0 struct list_head tcp_ses_list;
> >> =C2=A0 =C2=A0 =C2=A0 struct list_head smb_ses_list;
> >> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >> index 1cacfaa..1d39dcf 100644
> >> --- a/fs/cifs/connect.c
> >> +++ b/fs/cifs/connect.c
> >> @@ -2135,6 +2135,96 @@ cifs_put_tlink(struct tcon_link *tlink)
> >> =C2=A0 =C2=A0 =C2=A0 return;
> >> =C2=A0}
> >>
> >> +static inline struct tcon_link *
> >> +cifs_sb_master_tlink(struct cifs_sb_info *cifs_sb);
> >> +
> >> +static const u32 ACTUAL_MOUNT_FLAGS =3D CIFS_MOUNT_NO_PERM | CIFS=
_MOUNT_SET_UID |
> >> + =C2=A0 =C2=A0 CIFS_MOUNT_SERVER_INUM | CIFS_MOUNT_DIRECT_IO | CI=
=46S_MOUNT_NO_XATTR |
> >> + =C2=A0 =C2=A0 CIFS_MOUNT_MAP_SPECIAL_CHR | CIFS_MOUNT_UNX_EMUL |=
 CIFS_MOUNT_NO_BRL |
> >> + =C2=A0 =C2=A0 CIFS_MOUNT_CIFS_ACL | CIFS_MOUNT_OVERR_UID | CIFS_=
MOUNT_OVERR_GID |
> >> + =C2=A0 =C2=A0 CIFS_MOUNT_DYNPERM | CIFS_MOUNT_NOPOSIXBRL | CIFS_=
MOUNT_NOSSYNC |
> >> + =C2=A0 =C2=A0 CIFS_MOUNT_FSCACHE | CIFS_MOUNT_MF_SYMLINKS | CIFS=
_MOUNT_MULTIUSER |
> >> + =C2=A0 =C2=A0 CIFS_MOUNT_STRICT_IO;
> >> +
> >> +static int
> >> +compare_mount_options(struct cifs_sb_info *old, struct cifs_sb_in=
fo *new)
> >> +{
> >> + =C2=A0 =C2=A0 if ((old->mnt_cifs_flags & ACTUAL_MOUNT_FLAGS) !=3D
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 (new->mnt_cifs_flags & ACTUAL_MOUNT_=
=46LAGS))
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> >> +
> >> + =C2=A0 =C2=A0 if (old->rsize !=3D new->rsize || old->wsize !=3D =
new->wsize)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> >> +
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^^^^^^^^^^
> > The rsize and wsize are negotiated -- you can't know what this is u=
ntil
> > you talk to the server. Doesn't this check always fail?
>=20
> If we don't specify wsize and rsize they are set to default values
> (16384 and 57344) in both mounts, this check succeed.
>=20

Ahh then this will likely be broken if/when the wsize negotiation patch
goes in. I suppose we'll have to see which patch (if any) Steve decides
to commit first and then try to fix this up afterward.

The brokenness shouldn't be too bad, you just won't be able to actually
share superblocks until it's fixed.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
