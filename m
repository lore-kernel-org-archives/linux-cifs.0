From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] cifs: Return EBUSY instead of ETXTBSY in cifs_rename_pending_delete()
Date: Wed, 6 Mar 2013 18:32:46 -0600
Message-ID: <CAH2r5muN23HcNAwSkgFHg9rWfLw4mV=TaVUiKG71bsH_-M22yA@mail.gmail.com>
References: <1362511557-22607-1-git-send-email-sprabhu@redhat.com>
	<1362511557-22607-4-git-send-email-sprabhu@redhat.com>
	<20130306073902.729a62cd@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130306073902.729a62cd-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Does someone have a good explanation of the difference between text
file busy and device busy?  almost seems like we should be returning
EXTBUSY more based on the description

On Wed, Mar 6, 2013 at 6:39 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue,  5 Mar 2013 19:25:57 +0000
> Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> Instead of remapping ETXTBSY errors to EBUSY in cifs_unlink, replace all
>> cases of ETXTBSY in cifs_rename_pending_delete() with EBUSY.
>>
>> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  fs/cifs/inode.c | 6 ++----
>>  1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
>> index fee2d40..0ab0328 100644
>> --- a/fs/cifs/inode.c
>> +++ b/fs/cifs/inode.c
>> @@ -1034,7 +1034,7 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
>>                                  cifs_sb->mnt_cifs_flags &
>>                                           CIFS_MOUNT_MAP_SPECIAL_CHR);
>>       if (rc != 0) {
>> -             rc = -ETXTBSY;
>> +             rc = -EBUSY;
>>               goto undo_setattr;
>>       }
>>
>> @@ -1053,7 +1053,7 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
>>               if (rc == -ENOENT)
>>                       rc = 0;
>>               else if (rc != 0) {
>> -                     rc = -ETXTBSY;
>> +                     rc = -EBUSY;
>>                       goto undo_rename;
>>               }
>>               cifsInode->delete_pending = true;
>> @@ -1167,8 +1167,6 @@ psx_del_no_retry:
>>                       if (rc == 0)
>>                               cifs_drop_nlink(inode);
>>               }
>> -             if (rc == -ETXTBSY)
>> -                     rc = -EBUSY;
>
>
>
> This doesn't look quite right. If ->rename_pending_delete isn't set,
> then rc will still stay -ETXTBSY. I think this is a good cleanup, but
> we need to consider changing the mapping for
> NT_STATUS_SHARING_VIOLATION to -EBUSY as well, and fix all of the
> places that look for -ETXTBSY in the cifs code.
>
>
>>       } else if ((rc == -EACCES) && (dosattr == 0) && inode) {
>>               attrs = kzalloc(sizeof(*attrs), GFP_KERNEL);
>>               if (attrs == NULL) {
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
