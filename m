From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/5] CIFS: Invalidate inode pages on the last close
Date: Tue, 2 Nov 2010 14:26:59 -0500
Message-ID: <AANLkTika0teNKgPBqWi23X-iAXvfjuxdOz=p0HJ6Fo-3@mail.gmail.com>
References: <AANLkTikE-QfKh8AYe=NZtQOKPhJ_LGQ+K5xcGb6wBfbw@mail.gmail.com>
	<20101102111932.7377e2bb@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101102111932.7377e2bb-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeff's point looks correct.  Also note when you fix this up - the
local variable for cifs_sb from the previous patch (which caused a
build warning for unused variable) needs to be readded back to this
patch.

On Tue, Nov 2, 2010 at 10:19 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Tue, 2 Nov 2010 12:01:17 +0300
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On strict cache mode when we close the last file handle of the inode=
 we
>> should invalidate this inode to prevent data coherency problem when =
we
>> open it again but it has been modified by other clients.
>>
>> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifs_fs_sb.h | =A0 =A01 +
>> =A0fs/cifs/file.c =A0 =A0 =A0 | =A0 =A03 +++
>> =A02 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
>> index 525ba59..3690c50 100644
>> --- a/fs/cifs/cifs_fs_sb.h
>> +++ b/fs/cifs/cifs_fs_sb.h
>> @@ -40,6 +40,7 @@
>> =A0#define CIFS_MOUNT_FSCACHE =A0 0x8000 /* local caching enabled */
>> =A0#define CIFS_MOUNT_MF_SYMLINKS =A0 =A0 =A0 0x10000 /* Minshall+Fr=
ench Symlinks enabled */
>> =A0#define CIFS_MOUNT_MULTIUSER 0x20000 /* multiuser mount */
>> +#define CIFS_MOUNT_STRICT_IO 0x40000 /* strict cache mode */
>>
>> =A0struct cifs_sb_info {
>> =A0 =A0 =A0 struct radix_tree_root tlink_tree;
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index a566f15..3970e68 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -284,6 +284,9 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_=
file)
>> =A0 =A0 =A0 }
>> =A0 =A0 =A0 spin_unlock(&cifs_file_list_lock);
>>
>> + =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
>> + =A0 =A0 =A0 =A0 =A0 =A0 invalidate_remote_inode(inode);
>> +
>> =A0 =A0 =A0 if (!tcon->need_reconnect && !cifs_file->invalidHandle) =
{
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 int xid, rc;
>>
>
> Suppose I have this file open twice and have r/o oplocks on both
> filehandles. I close one of those file descriptors and the cache is
> invalidated. Is that really what we want here?
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
