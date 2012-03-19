From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix a spurious error in cifs_push_posix_locks
Date: Mon, 19 Mar 2012 10:20:57 -0500
Message-ID: <CAH2r5ms4SkkxvdtNxSrBntFKNEPx1vNVsGytEWTg0LR2qoXkNA@mail.gmail.com>
References: <1331966815-3124-1-git-send-email-piastry@etersoft.ru>
	<20120317061006.68c0305e@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120317061006.68c0305e-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged

On Sat, Mar 17, 2012 at 5:10 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Sat, 17 Mar 2012 09:46:55 +0300
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/file.c | =A0 19 ++++++++++---------
>> =A01 files changed, 10 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 4aa6080..159fcc5 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -960,9 +960,9 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile=
)
>> =A0 =A0 =A0 INIT_LIST_HEAD(&locks_to_send);
>>
>> =A0 =A0 =A0 /*
>> - =A0 =A0 =A0* Allocating count locks is enough because no locks can=
 be added to
>> - =A0 =A0 =A0* the list while we are holding cinode->lock_mutex that=
 protects
>> - =A0 =A0 =A0* locking operations of this inode.
>> + =A0 =A0 =A0* Allocating count locks is enough because no FL_POSIX =
locks can be
>> + =A0 =A0 =A0* added to the list while we are holding cinode->lock_m=
utex that
>> + =A0 =A0 =A0* protects locking operations of this inode.
>> =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 for (; i < count; i++) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 lck =3D kmalloc(sizeof(struct lock_to_pu=
sh), GFP_KERNEL);
>> @@ -973,18 +973,20 @@ cifs_push_posix_locks(struct cifsFileInfo *cfi=
le)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_add_tail(&lck->llist, &locks_to_sen=
d);
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 i =3D 0;
>> =A0 =A0 =A0 el =3D locks_to_send.next;
>> =A0 =A0 =A0 lock_flocks();
>> =A0 =A0 =A0 cifs_for_each_lock(cfile->dentry->d_inode, before) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 flock =3D *before;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if ((flock->fl_flags & FL_POSIX) =3D=3D 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (el =3D=3D &locks_to_send) {
>
> Nit: a clearer way to do this would be to list_del the locks as you u=
se
> them, and then check for list_empty(&locks_to_send). This works too,
> but is not as self documenting. It's not a big deal though...
>
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* something is really wro=
ng */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* The list ended. We do=
n't have enough allocated
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* structures - somethin=
g is really wrong.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Can't push al=
l brlocks!");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 flock =3D *before;
>> - =A0 =A0 =A0 =A0 =A0 =A0 if ((flock->fl_flags & FL_POSIX) =3D=3D 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 length =3D 1 + flock->fl_end - flock->fl=
_start;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (flock->fl_type =3D=3D F_RDLCK || flo=
ck->fl_type =3D=3D F_SHLCK)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 type =3D CIFS_RDLCK;
>> @@ -996,7 +998,6 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile=
)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 lck->length =3D length;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 lck->type =3D type;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 lck->offset =3D flock->fl_start;
>> - =A0 =A0 =A0 =A0 =A0 =A0 i++;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 el =3D el->next;
>> =A0 =A0 =A0 }
>> =A0 =A0 =A0 unlock_flocks();
>
>
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> ...you might also want to add:
>
> Reported-by: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
