From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix oops while traversing open file list
Date: Wed, 16 May 2012 08:39:25 -0500
Message-ID: <CADT32eLzgHoom5Fp0BVGnZ6+H12J+TAHDyxLrbmGzsO62jbDbg@mail.gmail.com>
References: <1337093239-23409-1-git-send-email-shirishpargaonkar@gmail.com>
	<20120515125525.19ef9cc8@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120515125525.19ef9cc8-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, May 15, 2012 at 11:55 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> On Tue, 15 May 2012 09:47:19 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
>> =A0fs/cifs/file.c =A0 =A0 | =A0 55 +++++++++++++++++++++++++++++----=
------------------
>> =A02 files changed, 32 insertions(+), 24 deletions(-)
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
>
>
> I don't know about this...
>
> What happens if we have a long network partition, and then make 5
> attempts to open the file that time out? AFAICT, we'll end up returni=
ng
> NULL, and see the dreaded "No writable handles for inode" and then
> we end up with people complaining about "corrupt data" on writeback.
>

Jeff, that could happen with existing code as well, right?
This patch is fixing the oops part, where cifs could trip on an element
in the list that does not exist while lock was not being held.

> Is that really the outcome we want with this? That doesn't seem like
> very resilient behavior for a network filesystem.
>
>> =A0/*
>> =A0 * default attribute cache timeout (jiffies)
>> =A0 */
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 81725e9..52da2d2 100644
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
>> @@ -1603,7 +1589,28 @@ refind_writable:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 any_available =3D true;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto refind_writable;
>> =A0 =A0 =A0 }
>> +
>> + =A0 =A0 if (inv_file) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 any_available =3D false;
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifsFileInfo_get(inv_file);
>> + =A0 =A0 =A0 =A0 =A0 =A0 list_del(&inv_file->flist);
>> + =A0 =A0 =A0 =A0 =A0 =A0 list_add_tail(&inv_file->flist, &cifs_inod=
e->openFileList);
>> + =A0 =A0 }
>> +
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
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++refind;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto refind_writable;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> +
>> =A0 =A0 =A0 return NULL;
>> =A0}
>>
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
