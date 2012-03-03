From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 12/17] CIFS: Move locks to file structure
Date: Sat, 3 Mar 2012 13:50:25 +0400
Message-ID: <CAKywueQxOk0Joq4xsj3dUshm9Z=rMTnZ5aaHfKSjGQKhn9jvAA@mail.gmail.com>
References: <1330767438-19469-1-git-send-email-piastry@etersoft.ru>
	<1330767438-19469-13-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1330767438-19469-13-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/3/3 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/cifsfs.c =A0 | =A0 =A01 -
> =A0fs/cifs/cifsglob.h | =A0 =A02 +-
> =A0fs/cifs/file.c =A0 =A0 | =A0 98 ++++++++++++++++++++++++++++++++--=
------------------
> =A03 files changed, 61 insertions(+), 40 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index a9b483b..62413f9 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -940,7 +940,6 @@ cifs_init_once(void *inode)
> =A0 =A0 =A0 =A0struct cifsInodeInfo *cifsi =3D inode;
>
> =A0 =A0 =A0 =A0inode_init_once(&cifsi->vfs_inode);
> - =A0 =A0 =A0 INIT_LIST_HEAD(&cifsi->llist);
> =A0 =A0 =A0 =A0mutex_init(&cifsi->lock_mutex);
> =A0}
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 8755724..e5179d4 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -578,6 +578,7 @@ struct cifs_search_info {
> =A0struct cifsFileInfo {
> =A0 =A0 =A0 =A0struct list_head tlist; /* pointer to next fid owned b=
y tcon */
> =A0 =A0 =A0 =A0struct list_head flist; /* next fid (file instance) fo=
r this inode */
> + =A0 =A0 =A0 struct list_head llist; /* brlocks held by this fid */
> =A0 =A0 =A0 =A0unsigned int uid; =A0 =A0 =A0 /* allows finding which =
=46ileInfo structure */
> =A0 =A0 =A0 =A0__u32 pid; =A0 =A0 =A0 =A0 =A0 =A0 =A0/* process id wh=
o opened file */
> =A0 =A0 =A0 =A0__u16 netfid; =A0 =A0 =A0 =A0 =A0 /* file id from remo=
te */
         ^^^
This is no need to keep this value here - resent as v2 version.

--=20
Best regards,
Pavel Shilovsky.
