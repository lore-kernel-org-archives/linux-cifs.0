From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Fix match_prepath()
Date: Thu, 27 Apr 2017 15:09:08 -0500
Message-ID: <CAH2r5mt5PN2zX+g-Ybnux0tNcfG_W1WECX5cXRuaD=Jj+-DazA@mail.gmail.com>
References: <20170426130546.4493-1-sprabhu@redhat.com> <CAKywueQLpqdj9erZOPPbr-B6mROi6wPpBszASLoev8Uis-pr7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQLpqdj9erZOPPbr-B6mROi6wPpBszASLoev8Uis-pr7w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git for-next

On Wed, Apr 26, 2017 at 5:15 PM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 2017-04-26 6:05 GMT-07:00 Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> Incorrect return value for shares not using the prefix patch means that
>> we will never match superblocks for these shares.
>>
>> Fixes: commit c1d8b24d1819 ("Compare prepaths when comparing superblocks")
>> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  fs/cifs/connect.c | 14 ++++++--------
>>  1 file changed, 6 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index d82467c..d95744d 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -2912,16 +2912,14 @@ match_prepath(struct super_block *sb, struct cifs_mnt_data *mnt_data)
>>  {
>>         struct cifs_sb_info *old = CIFS_SB(sb);
>>         struct cifs_sb_info *new = mnt_data->cifs_sb;
>> +       bool old_set = old->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH;
>> +       bool new_set = new->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH;
>>
>> -       if (old->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH) {
>> -               if (!(new->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH))
>> -                       return 0;
>> -               /* The prepath should be null terminated strings */
>> -               if (strcmp(new->prepath, old->prepath))
>> -                       return 0;
>> -
>> +       if (old_set && new_set && !strcmp(new->prepath, old->prepath))
>>                 return 1;
>> -       }
>> +       else if (!old_set && !new_set)
>> +               return 1;
>> +
>>         return 0;
>>  }
>>
>> --
>> 2.9.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>
> --
> Best regards,
> Pavel Shilovsky
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
