From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3] CIFS: Do not kmalloc under the flocks spinlock
Date: Tue, 6 Mar 2012 21:50:59 -0600
Message-ID: <CAH2r5mv2uPh91yGpbSJxe4GgYi1qKNkmsfqZHeZH_CCrrk0cRQ@mail.gmail.com>
References: <1330929560-1955-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1330929560-1955-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git

On Mon, Mar 5, 2012 at 12:39 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> =
wrote:
> Reorganize the code to make the memory already allocated before
> spinlock'ed loop.
>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/file.c | =A0 69 ++++++++++++++++++++++++++++++++++++++++++=
+++----------
> =A01 files changed, 56 insertions(+), 13 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 4dd9283..5e64748 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -920,16 +920,26 @@ cifs_push_mandatory_locks(struct cifsFileInfo *=
cfile)
> =A0 =A0 =A0 =A0for (lockp =3D &inode->i_flock; *lockp !=3D NULL; \
> =A0 =A0 =A0 =A0 =A0 =A0 lockp =3D &(*lockp)->fl_next)
>
> +struct lock_to_push {
> + =A0 =A0 =A0 struct list_head llist;
> + =A0 =A0 =A0 __u64 offset;
> + =A0 =A0 =A0 __u64 length;
> + =A0 =A0 =A0 __u32 pid;
> + =A0 =A0 =A0 __u16 netfid;
> + =A0 =A0 =A0 __u8 type;
> +};
> +
> =A0static int
> =A0cifs_push_posix_locks(struct cifsFileInfo *cfile)
> =A0{
> =A0 =A0 =A0 =A0struct cifsInodeInfo *cinode =3D CIFS_I(cfile->dentry-=
>d_inode);
> =A0 =A0 =A0 =A0struct cifs_tcon *tcon =3D tlink_tcon(cfile->tlink);
> =A0 =A0 =A0 =A0struct file_lock *flock, **before;
> - =A0 =A0 =A0 struct cifsLockInfo *lck, *tmp;
> + =A0 =A0 =A0 unsigned int count =3D 0, i =3D 0;
> =A0 =A0 =A0 =A0int rc =3D 0, xid, type;
> + =A0 =A0 =A0 struct list_head locks_to_send, *el;
> + =A0 =A0 =A0 struct lock_to_push *lck, *tmp;
> =A0 =A0 =A0 =A0__u64 length;
> - =A0 =A0 =A0 struct list_head locks_to_send;
>
> =A0 =A0 =A0 =A0xid =3D GetXid();
>
> @@ -940,29 +950,55 @@ cifs_push_posix_locks(struct cifsFileInfo *cfil=
e)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 lock_flocks();
> + =A0 =A0 =A0 cifs_for_each_lock(cfile->dentry->d_inode, before) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((*before)->fl_flags & FL_POSIX)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 count++;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 unlock_flocks();
> +
> =A0 =A0 =A0 =A0INIT_LIST_HEAD(&locks_to_send);
>
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Allocating count locks is enough because no locks =
can be added to
> + =A0 =A0 =A0 =A0* the list while we are holding cinode->lock_mutex t=
hat protects
> + =A0 =A0 =A0 =A0* locking operations of this inode.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 for (; i < count; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 lck =3D kmalloc(sizeof(struct lock_to_p=
ush), GFP_KERNEL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!lck) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto err_out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_add_tail(&lck->llist, &locks_to_se=
nd);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 i =3D 0;
> + =A0 =A0 =A0 el =3D locks_to_send.next;
> =A0 =A0 =A0 =A0lock_flocks();
> =A0 =A0 =A0 =A0cifs_for_each_lock(cfile->dentry->d_inode, before) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (el =3D=3D &locks_to_send) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* something is really =
wrong */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Can't push a=
ll brlocks!");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flock =3D *before;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((flock->fl_flags & FL_POSIX) =3D=3D=
 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0length =3D 1 + flock->fl_end - flock->=
fl_start;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (flock->fl_type =3D=3D F_RDLCK || f=
lock->fl_type =3D=3D F_SHLCK)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0type =3D CIFS_RDLCK;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0type =3D CIFS_WRLCK;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 lck =3D cifs_lock_init(flock->fl_start,=
 length, type,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0cfile->netfid);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!lck) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto send_locks;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 lck =3D list_entry(el, struct lock_to_p=
ush, llist);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0lck->pid =3D flock->fl_pid;
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_add_tail(&lck->llist, &locks_to_se=
nd);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 lck->netfid =3D cfile->netfid;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 lck->length =3D length;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 lck->type =3D type;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 lck->offset =3D flock->fl_start;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 i++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 el =3D el->next;
> =A0 =A0 =A0 =A0}
> -
> -send_locks:
> =A0 =A0 =A0 =A0unlock_flocks();
>
> =A0 =A0 =A0 =A0list_for_each_entry_safe(lck, tmp, &locks_to_send, lli=
st) {
> @@ -979,11 +1015,18 @@ send_locks:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kfree(lck);
> =A0 =A0 =A0 =A0}
>
> +out:
> =A0 =A0 =A0 =A0cinode->can_cache_brlcks =3D false;
> =A0 =A0 =A0 =A0mutex_unlock(&cinode->lock_mutex);
>
> =A0 =A0 =A0 =A0FreeXid(xid);
> =A0 =A0 =A0 =A0return rc;
> +err_out:
> + =A0 =A0 =A0 list_for_each_entry_safe(lck, tmp, &locks_to_send, llis=
t) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del(&lck->llist);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(lck);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 goto out;
> =A0}
>
> =A0static int
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
