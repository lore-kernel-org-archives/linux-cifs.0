From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] cifs: Fix bug when checking error condition in cifs_rename_pending_delete()
Date: Wed, 6 Mar 2013 19:39:04 +0400
Message-ID: <CAKywueSkjTv9-Ufw2z0cw1ST2i+TobS=ei_PHrAJid4Nm=SV_Q@mail.gmail.com>
References: <1362511557-22607-1-git-send-email-sprabhu@redhat.com>
	<1362511557-22607-2-git-send-email-sprabhu@redhat.com>
	<20130306073515.0015029b@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130306073515.0015029b-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2013/3/6 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Tue,  5 Mar 2013 19:25:55 +0000
> Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> Fix check for error condition after setting attributes with
>> CIFSSMBSetFileInfo().
>>
>> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  fs/cifs/inode.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
>> index ed6208f..a183b9d 100644
>> --- a/fs/cifs/inode.c
>> +++ b/fs/cifs/inode.c
>> @@ -1014,7 +1014,7 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
>>                                       current->tgid);
>>               /* although we would like to mark the file hidden
>>                  if that fails we will still try to rename it */
>> -             if (rc != 0)
>> +             if (!rc)
>>                       cifsInode->cifsAttrs = dosattr;
>>               else
>>                       dosattr = origattr; /* since not able to change them */
>
> Nice catch
>
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

-- 
Best regards,
Pavel Shilovsky.
