From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 2/3] CIFS: Fix write after setting a read lock for read
 oplock files
Date: Wed, 2 Jan 2013 22:09:52 +0400
Message-ID: <CAKywueQVTUEMnWbahgxtjS4SZfzGA30krQi3vFV3Na2DHjrvpA@mail.gmail.com>
References: <1356537234-11507-1-git-send-email-piastry@etersoft.ru>
	<1356537234-11507-3-git-send-email-piastry@etersoft.ru>
	<20130101061413.0915b205@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130101061413.0915b205-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2013/1/1 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Wed, 26 Dec 2012 19:53:53 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> If we have a read oplock and set a read lock in it, we can't write to the
>> locked area - so, filemap_fdatawrite may fail with a no information for a
>> userspace application even if we request a write to non-locked area. Fix
>> this by writing directly to the server and then breaking oplock level from
>> level2 to None.
>>
>> Also remove CONFIG_CIFS_SMB2 ifdefs because it's suitable for both CIFS
>> and SMB2 protocols.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>>  fs/cifs/file.c | 48 ++++++++++++++++++++----------------------------
>>  1 file changed, 20 insertions(+), 28 deletions(-)
>>
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 1b322d0..22c3725 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -2505,42 +2505,34 @@ cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
>>       struct cifsFileInfo *cfile = (struct cifsFileInfo *)
>>                                               iocb->ki_filp->private_data;
>>       struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
>> +     ssize_t written;
>>
>> -#ifdef CONFIG_CIFS_SMB2
>> -     /*
>> -      * If we have an oplock for read and want to write a data to the file
>> -      * we need to store it in the page cache and then push it to the server
>> -      * to be sure the next read will get a valid data.
>> -      */
>> -     if (!cinode->clientCanCacheAll && cinode->clientCanCacheRead) {
>> -             ssize_t written;
>> -             int rc;
>> -
>> -             written = generic_file_aio_write(iocb, iov, nr_segs, pos);
>> -             rc = filemap_fdatawrite(inode->i_mapping);
>> -             if (rc)
>> -                     return (ssize_t)rc;
>> -
>> -             return written;
>> +     if (cinode->clientCanCacheAll) {
>> +             if (cap_unix(tcon->ses) &&
>> +             (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability))
>> +                 && ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
>> +                     return generic_file_aio_write(iocb, iov, nr_segs, pos);
>> +             return cifs_writev(iocb, iov, nr_segs, pos);
>>       }
>> -#endif
>> -
>>       /*
>>        * For non-oplocked files in strict cache mode we need to write the data
>>        * to the server exactly from the pos to pos+len-1 rather than flush all
>>        * affected pages because it may cause a error with mandatory locks on
>>        * these pages but not on the region from pos to ppos+len-1.
>>        */
>> -
>> -     if (!cinode->clientCanCacheAll)
>> -             return cifs_user_writev(iocb, iov, nr_segs, pos);
>> -
>> -     if (cap_unix(tcon->ses) &&
>> -         (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
>> -         ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
>> -             return generic_file_aio_write(iocb, iov, nr_segs, pos);
>> -
>> -     return cifs_writev(iocb, iov, nr_segs, pos);
>> +     written = cifs_user_writev(iocb, iov, nr_segs, pos);
>> +     if (written > 0 && cinode->clientCanCacheRead) {
>> +             /*
>> +              * Windows 7 server can delay breaking level2 oplock if a write
>> +              * request comes - break it on the client to prevent reading
>> +              * an old data.
>> +              */
>> +             cifs_invalidate_mapping(inode);
>> +             cFYI(1, "Set no oplock for inode=%p after a write operation",
>> +                  inode);
>> +             cinode->clientCanCacheRead = false;
>
>                 In the above case, do we also need to inform the server
>                 that we're dropping the oplock here and that it doesn't
>                 need to be recalled? Is there a way to send an
>                 unsolicited "I'm dropping this oplock" to the server?

I don't think we have any possibilities to do this. Even if we try to
break it on the server with an extra open request (with RequestOplock
= 0) the server will send OplockBreak to this fid.

>
>                 Also, I'm still not 100% comfortable with the lack of
>                 locking around these clientCanCache* flags. It seems
>                 unlikely but could we end up racing with the grant of a
>                 CanCacheAll oplock here?

In SMB2.1 protocol this situation may happen. There are two possible scenarios:
1) we set CanCachRead to False, then open code sets both CanCache*
values to true - seems no problem because we have already invalidated
inode mapping - the next read will call readpages that will request a
new data from the server.
2) open code sets both CanCache* values to true, then we set
CanCacheRead to false - the only bad thing here is that we will not do
pagereading that can hurt performance, but the data coherency should
be fine.

>
>> +     }
>> +     return written;
>>  }
>>
>>  static struct cifs_readdata *
>
> Looks like a much nicer scheme than you originally had. Even with the
> lack of locking around the CanCache* flags, I think this doesn't make
> things any worse.
>
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks for reviewing these patches!

-- 
Best regards,
Pavel Shilovsky.
