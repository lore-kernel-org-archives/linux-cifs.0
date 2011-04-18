From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: guard against entries being deleted from open file list
Date: Mon, 18 Apr 2011 09:24:10 -0500
Message-ID: <BANLkTint+YFGjTX0ccjtr5FW-aKsfr-0nA@mail.gmail.com>
References: <1303134275-12587-1-git-send-email-shirishpargaonkar@gmail.com>
	<BANLkTi=dVQt1GQmrG+x0PF8Akq_hbvE7cQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTi=dVQt1GQmrG+x0PF8Akq_hbvE7cQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Apr 18, 2011 at 9:21 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> Is there a reproduction scenario or bug report for this (or was it
> noted by inspection)?
>
> On Mon, Apr 18, 2011 at 8:44 AM, =A0<shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> It is possible that a close can occur while a file is
>> being reopened which can result in list entry deleted
>> from the list and an oops.
>> Use list_for_each_entry_safe instead.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/file.c | =A0 =A05 +++--
>> =A01 files changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index faf5952..aa29167 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -1056,7 +1056,7 @@ struct cifsFileInfo *find_readable_file(struct=
 cifsInodeInfo *cifs_inode,
>> =A0struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cif=
s_inode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0bool fsuid_only)
>> =A0{
>> - =A0 =A0 =A0 struct cifsFileInfo *open_file;
>> + =A0 =A0 =A0 struct cifsFileInfo *open_file, *tmpf;
>> =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb;
>> =A0 =A0 =A0 =A0bool any_available =3D false;
>> =A0 =A0 =A0 =A0int rc;
>> @@ -1079,7 +1079,8 @@ struct cifsFileInfo *find_writable_file(struct=
 cifsInodeInfo *cifs_inode,
>>
>> =A0 =A0 =A0 =A0spin_lock(&cifs_file_list_lock);
>> =A0refind_writable:
>> - =A0 =A0 =A0 list_for_each_entry(open_file, &cifs_inode->openFileLi=
st, flist) {
>> + =A0 =A0 =A0 list_for_each_entry_safe(open_file, tmpf, &cifs_inode-=
>openFileList,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 flist) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!any_available && open_file->pid =
!=3D current->tgid)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (fsuid_only && open_file->uid !=3D=
 current_fsuid())
>> --
>> 1.6.0.2
>>
>>
>
>
>
> --
> Thanks,
>
> Steve
>

Steve,

IBM internal bugzilla 71379.

I think a stressed CIFS/SMB server can make cifs client this way!
Perhaps harder to recreate strating 1.69 version of cifs
(which has Jeff's patches for a slow server).

Regards,

Shirish
