From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: add FL_CLOSE to fl_flags mask in cifs_read_flock
Date: Sat, 15 Sep 2012 15:54:33 -0500
Message-ID: <CAH2r5ms2OQZqqvHvTD_knKtKdYyKgM4jPOha7JUkZtNtoMnLvA@mail.gmail.com>
References: <1347568691-24628-1-git-send-email-jlayton@redhat.com>
	<CAKywueRVT6YNoQaX-wraMuB7CeD51x4_6yfKKkujAaFWO-2pfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	abokovoy-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRVT6YNoQaX-wraMuB7CeD51x4_6yfKKkujAaFWO-2pfA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Merged into cifs-2.6.git

On Fri, Sep 14, 2012 at 6:36 AM, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 2012/9/14 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> FL_CLOSE is quite common when you close a file on which you hold a
>> lock. The spurious "Unknown lock flags" message in cFYI is
>> confusing in this case.
>>
>> Reported-by: Alexander Bokovoy <abokovoy-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  fs/cifs/file.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 093f5a3..33158cd 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -1173,7 +1173,8 @@ cifs_read_flock(struct file_lock *flock, __u32 *type, int *lock, int *unlock,
>>         if (flock->fl_flags & FL_LEASE)
>>                 cFYI(1, "Lease on file - not implemented yet");
>>         if (flock->fl_flags &
>> -           (~(FL_POSIX | FL_FLOCK | FL_SLEEP | FL_ACCESS | FL_LEASE)))
>> +           (~(FL_POSIX | FL_FLOCK | FL_SLEEP |
>> +              FL_ACCESS | FL_LEASE | FL_CLOSE)))
>>                 cFYI(1, "Unknown lock flags 0x%x", flock->fl_flags);
>>
>>         *type = server->vals->large_lock_type;
>> --
>> 1.7.11.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>
> --
> Best regards,
> Pavel Shilovsky.



-- 
Thanks,

Steve
