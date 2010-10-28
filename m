From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] cifs: store pointer to master tlink in superblock
 (try #2)
Date: Thu, 28 Oct 2010 14:22:58 -0500
Message-ID: <AANLkTi=SEJdvKtSi17d7h+8yVO-+nqcae-ks4R9GY-R7@mail.gmail.com>
References: <1288287218-25100-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1288287218-25100-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Oct 28, 2010 at 12:33 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> This is the second version of this patch, the only difference between
> it and the first one is that this explicitly makes cifs_sb_master_tli=
nk
> a static inline.
>
> Instead of keeping a tag on the master tlink in the tree, just keep a
> pointer to the master in the superblock. That eliminates the need for
> using the radix tree to look up a tagged entry.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifs_fs_sb.h | =A0 =A02 +-
> =A0fs/cifs/connect.c =A0 =A0| =A0 20 ++++----------------
> =A02 files changed, 5 insertions(+), 17 deletions(-)
>
> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
> index 525ba59..79576da 100644
> --- a/fs/cifs/cifs_fs_sb.h
> +++ b/fs/cifs/cifs_fs_sb.h
> @@ -43,8 +43,8 @@
>
> =A0struct cifs_sb_info {
> =A0 =A0 =A0 =A0struct radix_tree_root tlink_tree;
> -#define CIFS_TLINK_MASTER_TAG =A0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 /* is=
 "master" (mount) tcon */
> =A0 =A0 =A0 =A0spinlock_t tlink_tree_lock;
> + =A0 =A0 =A0 struct tcon_link *master_tlink;
> =A0 =A0 =A0 =A0struct nls_table *local_nls;
> =A0 =A0 =A0 =A0unsigned int rsize;
> =A0 =A0 =A0 =A0unsigned int wsize;
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 469c3dd..cd644ce 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2917,11 +2917,11 @@ remote_path_check:
>
> =A0 =A0 =A0 =A0spin_lock(&cifs_sb->tlink_tree_lock);
> =A0 =A0 =A0 =A0radix_tree_insert(&cifs_sb->tlink_tree, pSesInfo->linu=
x_uid, tlink);
> - =A0 =A0 =A0 radix_tree_tag_set(&cifs_sb->tlink_tree, pSesInfo->linu=
x_uid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_TLINK_MASTE=
R_TAG);
> =A0 =A0 =A0 =A0spin_unlock(&cifs_sb->tlink_tree_lock);
> =A0 =A0 =A0 =A0radix_tree_preload_end();
>
> + =A0 =A0 =A0 cifs_sb->master_tlink =3D tlink;
> +
> =A0 =A0 =A0 =A0queue_delayed_work(system_nrt_wq, &cifs_sb->prune_tlin=
ks,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0TLINK_=
IDLE_EXPIRE);
>
> @@ -3272,22 +3272,10 @@ out:
> =A0 =A0 =A0 =A0return tcon;
> =A0}
>
> -static struct tcon_link *
> +static inline struct tcon_link *
> =A0cifs_sb_master_tlink(struct cifs_sb_info *cifs_sb)
> =A0{
> - =A0 =A0 =A0 struct tcon_link *tlink;
> - =A0 =A0 =A0 unsigned int ret;
> -
> - =A0 =A0 =A0 spin_lock(&cifs_sb->tlink_tree_lock);
> - =A0 =A0 =A0 ret =3D radix_tree_gang_lookup_tag(&cifs_sb->tlink_tree=
, (void **)&tlink,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 0, 1, CIFS_TLINK_MASTER_TAG);
> - =A0 =A0 =A0 spin_unlock(&cifs_sb->tlink_tree_lock);
> -
> - =A0 =A0 =A0 /* the master tcon should always be present */
> - =A0 =A0 =A0 if (ret =3D=3D 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG();
> -
> - =A0 =A0 =A0 return tlink;
> + =A0 =A0 =A0 return cifs_sb->master_tlink;
> =A0}
>
> =A0struct cifsTconInfo *
> --
> 1.7.2.3
>
>

Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
