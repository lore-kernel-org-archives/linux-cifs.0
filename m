From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/4] CIFS: Invalidate inode pages on the last close
Date: Thu, 4 Nov 2010 14:23:19 +0300
Message-ID: <AANLkTingEbr0K=1TMTUXYS2uFeS2QmYP3HLdnrj9o-0i@mail.gmail.com>
References: <1288727061-18759-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1288727061-18759-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/11/2 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On strict cache mode when we close the last file handle of the inode =
we
> should invalidate itt o prevent data coherency problem when we open i=
t
> again but it has been modified by other clients.
>
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/cifs_fs_sb.h | =A0 =A01 +
> =A0fs/cifs/file.c =A0 =A0 =A0 | =A0 =A06 ++++++
> =A02 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
> index e9a393c..be7b159 100644
> --- a/fs/cifs/cifs_fs_sb.h
> +++ b/fs/cifs/cifs_fs_sb.h
> @@ -40,6 +40,7 @@
> =A0#define CIFS_MOUNT_FSCACHE =A0 =A0 0x8000 /* local caching enabled=
 */
> =A0#define CIFS_MOUNT_MF_SYMLINKS 0x10000 /* Minshall+French Symlinks=
 enabled */
> =A0#define CIFS_MOUNT_MULTIUSER =A0 0x20000 /* multiuser mount */
> +#define CIFS_MOUNT_STRICT_IO =A0 0x40000 /* strict cache mode */
>
> =A0struct cifs_sb_info {
> =A0 =A0 =A0 =A0struct rb_root tlink_tree;
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 71185d1..81ec50e 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -264,7 +264,9 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_f=
ile)
> =A0 =A0 =A0 =A0struct inode *inode =3D cifs_file->dentry->d_inode;
> =A0 =A0 =A0 =A0struct cifsTconInfo *tcon =3D tlink_tcon(cifs_file->tl=
ink);
> =A0 =A0 =A0 =A0struct cifsInodeInfo *cifsi =3D CIFS_I(inode);
> + =A0 =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
> =A0 =A0 =A0 =A0struct cifsLockInfo *li, *tmp;
> + =A0 =A0 =A0 bool last_open_file =3D false;
>
> =A0 =A0 =A0 =A0spin_lock(&cifs_file_list_lock);
> =A0 =A0 =A0 =A0if (--cifs_file->count > 0) {
> @@ -279,10 +281,14 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs=
_file)
> =A0 =A0 =A0 =A0if (list_empty(&cifsi->openFileList)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "closing last open instance fo=
r inode %p",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_file->dentry->d_i=
node);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 last_open_file =3D true;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_set_oplock_level(inode, 0);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0spin_unlock(&cifs_file_list_lock);
>
> + =A0 =A0 =A0 if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) &&=
 last_open_file)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 invalidate_remote_inode(inode);
> +
> =A0 =A0 =A0 =A0if (!tcon->need_reconnect && !cifs_file->invalidHandle=
) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int xid, rc;
>
> --
> 1.7.2.3
>
>

What's about this and patch number 2 (New read logic)?

--=20
Best regards,
Pavel Shilovsky.
