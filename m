From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 5/5] CIFS: Fix write after setting a read lock for read
 oplock files
Date: Tue, 27 Nov 2012 18:57:22 +0400
Message-ID: <CAKywueSb3q3-6whESnqrvPc2o0ka8GZepz0JmQGTzyRki4Bh1Q@mail.gmail.com>
References: <1353999029-3975-1-git-send-email-piastry@etersoft.ru>
	<1353999029-3975-6-git-send-email-piastry@etersoft.ru>
	<20121127075203.7b0d8de6@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121127075203.7b0d8de6-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/11/27 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Tue, 27 Nov 2012 10:50:28 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> If we have a read oplock and set a read lock in it, we can't write to the
>> locked area - so, filemap_fdatawrite may fail with a no information for a
>> userspace application even if we request a write to non-locked area. Fix
>> this by replacing it with filemap_write_and_wait call and sending non-page
>> write in a error case.
>>
>> While this may end up with two write requests to the server, we can be sure
>> that our data will be the same at the server and the page cache - the next read
>> on this file gets the valid data.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>>  fs/cifs/file.c |   10 ++++------
>>  1 file changed, 4 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index f8fe1bd..89efd85 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -2511,14 +2511,12 @@ cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
>>        */
>>       if (!cinode->clientCanCacheAll && cinode->clientCanCacheRead) {
>>               ssize_t written;
>> -             int rc;
>>
>>               written = generic_file_aio_write(iocb, iov, nr_segs, pos);
>> -             rc = filemap_fdatawrite(inode->i_mapping);
>> -             if (rc)
>> -                     return (ssize_t)rc;
>> -
>> -             return written;
>> +             /* try page write at first */
>> +             if (!filemap_write_and_wait(inode->i_mapping))
>> +                     return written;
>> +             /* page write failed - try from pos to pos+len-1 */
>>       }
>>  #endif
>>
>
> Bleh -- nasty. I guess this will work though...
>
> Wonder if there's some way to populate the cache and then just mark the
> pages clean without sending out writes? That would be a better solution
> IMO, but I guess we can live with this for now...
>
> Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks for reviewing the patchset.

As for this patch I have the followon patch:

http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=commitdiff;h=11673376e6840c686f0c6e51892b16ad1945887e

that allows us to populate the page cache without making pages dirty.
I didn't have enough time to test it well (that's why I haven't posted
it yet)  - going to do it tomorrow. But you are welcome to comment the
approach.

-- 
Best regards,
Pavel Shilovsky.
