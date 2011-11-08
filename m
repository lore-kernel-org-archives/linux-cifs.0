From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Add descriptions to the brlock cache functions
Date: Tue, 8 Nov 2011 14:13:47 -0600
Message-ID: <CAH2r5mtMrP8WRcUbMqdJkkBiCJfBY+gWX=h+o3uuwjSOHxC7WA@mail.gmail.com>
References: <1320671484-6222-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1320671484-6222-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged

On Mon, Nov 7, 2011 at 7:11 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> w=
rote:
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/file.c | =A0 26 ++++++++++++++++++++++++++
> =A01 files changed, 26 insertions(+), 0 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index cf0b153..4dd9283 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -702,6 +702,13 @@ cifs_find_lock_conflict(struct cifsInodeInfo *ci=
node, struct cifsLockInfo *lock,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 lock->type, lock->netfid, conf_lock);
> =A0}
>
> +/*
> + * Check if there is another lock that prevents us to set the lock (=
mandatory
> + * style). If such a lock exists, update the flock structure with it=
s
> + * properties. Otherwise, set the flock type to F_UNLCK if we can ca=
che brlocks
> + * or leave it the same if we can't. Returns 0 if we don't need to r=
equest to
> + * the server or 1 otherwise.
> + */
> =A0static int
> =A0cifs_lock_test(struct cifsInodeInfo *cinode, __u64 offset, __u64 l=
ength,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u8 type, __u16 netfid, struct file_lock=
 *flock)
> @@ -739,6 +746,12 @@ cifs_lock_add(struct cifsInodeInfo *cinode, stru=
ct cifsLockInfo *lock)
> =A0 =A0 =A0 =A0mutex_unlock(&cinode->lock_mutex);
> =A0}
>
> +/*
> + * Set the byte-range lock (mandatory style). Returns:
> + * 1) 0, if we set the lock and don't need to request to the server;
> + * 2) 1, if no locks prevent us but we need to request to the server=
;
> + * 3) -EACCESS, if there is a lock that prevents us and wait is fals=
e.
> + */
> =A0static int
> =A0cifs_lock_add_if(struct cifsInodeInfo *cinode, struct cifsLockInfo=
 *lock,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bool wait)
> @@ -778,6 +791,13 @@ try_again:
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> +/*
> + * Check if there is another lock that prevents us to set the lock (=
posix
> + * style). If such a lock exists, update the flock structure with it=
s
> + * properties. Otherwise, set the flock type to F_UNLCK if we can ca=
che brlocks
> + * or leave it the same if we can't. Returns 0 if we don't need to r=
equest to
> + * the server or 1 otherwise.
> + */
> =A0static int
> =A0cifs_posix_lock_test(struct file *file, struct file_lock *flock)
> =A0{
> @@ -800,6 +820,12 @@ cifs_posix_lock_test(struct file *file, struct f=
ile_lock *flock)
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> +/*
> + * Set the byte-range lock (posix style). Returns:
> + * 1) 0, if we set the lock and don't need to request to the server;
> + * 2) 1, if we need to request to the server;
> + * 3) <0, if the error occurs while setting the lock.
> + */
> =A0static int
> =A0cifs_posix_lock_set(struct file *file, struct file_lock *flock)
> =A0{
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
