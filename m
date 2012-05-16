From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix oops while traversing open file list (try #2)
Date: Wed, 16 May 2012 15:41:24 -0500
Message-ID: <CADT32eJ1VuL52DLnc=SuNjiSEzwMHXOtM4VJXfYZrmTSUoDQYA@mail.gmail.com>
References: <1337188413-28947-1-git-send-email-shirishpargaonkar@gmail.com>
	<20120516135548.2acb454a@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120516135548.2acb454a-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, May 16, 2012 at 12:55 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
> On Wed, 16 May 2012 12:13:33 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> While traversing the linked list of open file handles, if the identf=
ied
>> file handle is invalid, a reopen is attempted and if it fails, we
>> resume traversing where we stopped and cifs can oops while accessing
>> invalid next element, for list might have changed.
>>
>> So mark the invalid file handle and attempt reopen if no
>> valid file handle is found in rest of the list.
>> Move the invalid file handle to the end of the list and
>> if reopen fails for that file handle, start traversing the list agai=
n
>> from the begining.
>> Repeat this four times before giving up and returning an error if
>> file reopen keeps failing.
>>
>>
>> Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsglob.h | =A0 =A01 +
>> =A0fs/cifs/file.c =A0 =A0 | =A0 54 ++++++++++++++++++++++++++++-----=
------------------
>> =A02 files changed, 31 insertions(+), 24 deletions(-)
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 4ff6313..73fea28 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -43,6 +43,7 @@
>>
>> =A0#define CIFS_MIN_RCV_POOL 4
>>
>> +#define MAX_REOPEN_ATT =A0 =A0 =A0 5 /* these many maximum attempts=
 to reopen a file */
>> =A0/*
>> =A0 * default attribute cache timeout (jiffies)
>> =A0 */
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 81725e9..88407ad 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -1539,10 +1539,11 @@ struct cifsFileInfo *find_readable_file(stru=
ct cifsInodeInfo *cifs_inode,
>> =A0struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cif=
s_inode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 bool fsuid_only)
>> =A0{
>> - =A0 =A0 struct cifsFileInfo *open_file;
>> + =A0 =A0 struct cifsFileInfo *open_file, *inv_file =3D NULL;
>> =A0 =A0 =A0 struct cifs_sb_info *cifs_sb;
>> =A0 =A0 =A0 bool any_available =3D false;
>> =A0 =A0 =A0 int rc;
>> + =A0 =A0 unsigned int refind =3D 0;
>>
>> =A0 =A0 =A0 /* Having a null inode here (because mapping->host was s=
et to zero by
>> =A0 =A0 =A0 the VFS or MM) should not happen but we had reports of o=
n oops (due to
>> @@ -1562,40 +1563,25 @@ struct cifsFileInfo *find_writable_file(stru=
ct cifsInodeInfo *cifs_inode,
>>
>> =A0 =A0 =A0 spin_lock(&cifs_file_list_lock);
>> =A0refind_writable:
>> + =A0 =A0 if (refind > MAX_REOPEN_ATT) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&cifs_file_list_lock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
>> + =A0 =A0 }
>> =A0 =A0 =A0 list_for_each_entry(open_file, &cifs_inode->openFileList=
, flist) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!any_available && open_file->pid !=3D=
 current->tgid)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (fsuid_only && open_file->uid !=3D cu=
rrent_fsuid())
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (OPEN_FMODE(open_file->f_flags) & FMO=
DE_WRITE) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsFileInfo_get(open_file=
);
>> -
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!open_file->invalidH=
andle) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* found=
 a good writable file */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsFileIn=
fo_get(open_file);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unl=
ock(&cifs_file_list_lock);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return o=
pen_file;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!inv_f=
ile)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 inv_file =3D open_file;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&cifs_file_lis=
t_lock);
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Had to unlock since fol=
lowing call can block */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_reopen_file(op=
en_file, false);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!rc)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ope=
n_file;
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* if it fails, try anothe=
r handle if possible */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "wp failed on reop=
en file");
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsFileInfo_put(open_file=
);
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&cifs_file_list_=
lock);
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* else we simply continue=
 to the next entry. Thus
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0we do not loop on r=
eopen errors. =A0If we
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0can not reopen the =
file, for example if we
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0reconnected to a se=
rver with another client
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0racing to delete or=
 lock the file we would not
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0make progress if we=
 restarted before the beginning
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0of the loop here. *=
/
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 }
>> =A0 =A0 =A0 /* couldn't find useable FH with same pid, try any avail=
able */
>> @@ -1603,7 +1589,27 @@ refind_writable:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 any_available =3D true;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto refind_writable;
>> =A0 =A0 =A0 }
>> +
>> + =A0 =A0 if (inv_file) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 any_available =3D false;
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifsFileInfo_get(inv_file);
>> + =A0 =A0 =A0 =A0 =A0 =A0 list_move_tail(&inv_file->flist, &cifs_ino=
de->openFileList);
>> + =A0 =A0 }
>> +
>
> Hmm...now that I think about this, do we really want to move this to
> the end of the list here? If this turns out to be reclaimable we will
> have moved it to the end of the list, and then it will be the *last*
> one found on the next pass into this function.

yes, but we need to keep this element on the list while reclaimation
is going on.  If we keep where it is and reclaim fails, we may oops
for we are not sure if the next element is still intact (that is the re=
ason
of the oops in the first place) since we will continue down the list
looking for another file handle.

>
>> =A0 =A0 =A0 spin_unlock(&cifs_file_list_lock);
>> +
>> + =A0 =A0 if (inv_file) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_reopen_file(inv_file, false);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return inv_file;
>> + =A0 =A0 =A0 =A0 =A0 =A0 else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&cifs_file_list_=
lock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsFileInfo_put(inv_file)=
;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Here's where I have to rescind my Ack =
-- sorry :(
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0This is going to deadlock -- the first=
 thing
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0that cifsFileInfo_put() does is lock t=
he
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_file_list_lock.

Agree.  Thanks. I think reversing the order of the calls
spin_lock() and cifsFileInfo_put(), should take care of that.

>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0It seems to me that moving the file to=
 the end of the
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list here would make more sense. IOW, =
we should only do
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0that if it turned out not to be reclai=
mable. Right?

But the problem would remain.  We are reclaiming without lock
so we have to consider the possibility that reclaim could fail, so
list move could fail if the next element has become stale/invalid.

>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++refind;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto refind_writable;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> +
>> =A0 =A0 =A0 return NULL;
>> =A0}
>>
>
> Also, should we go ahead and abandon the ordering of the openFileList=
?

I am ok with that if Steve would consider OK.

>
> From cifs_new_fileinfo:
>
> =A0 =A0 =A0 =A0/* if readable file instance put first in list*/
> =A0 =A0 =A0 =A0if (file->f_mode & FMODE_READ)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_add(&pCifsFile->flist, &pCifsInod=
e->openFileList);
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_add_tail(&pCifsFile->flist, &pCif=
sInode->openFileList);
>
> ...I'll note that nothing walks this list backward, so it's a pointle=
ss
> "optimization". Ordering the list by "availability" might make more
> sense.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
