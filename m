From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v6 2/7] VFS: Add O_DENYDELETE support for VFS
Date: Tue, 11 Jun 2013 16:18:00 +0400
Message-ID: <CAKywueRn58fouJba8rUwAf78FmNn9kdRDrx+GC36BXdfC-jHLg@mail.gmail.com>
References: <1366977861-27678-1-git-send-email-piastry@etersoft.ru>
	<1366977861-27678-3-git-send-email-piastry@etersoft.ru>
	<20130611080906.5a9d0384@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Linux NFS Mailing list <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130611080906.5a9d0384-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2013/6/11 Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>:
> On Fri, 26 Apr 2013 16:04:16 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Introduce new LOCK_DELETE flock flag that is suggested to be used
>> internally only to map O_DENYDELETE open flag:
>>
>> !O_DENYDELETE -> LOCK_DELETE | LOCK_MAND.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>>  fs/locks.c                       | 53 +++++++++++++++++++++++++++++++++-------
>>  fs/namei.c                       |  3 +++
>>  include/linux/fs.h               |  6 +++++
>>  include/uapi/asm-generic/fcntl.h |  1 +
>>  4 files changed, 54 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/locks.c b/fs/locks.c
>> index dbc5557..1cc68a9 100644
>> --- a/fs/locks.c
>> +++ b/fs/locks.c
>> @@ -269,7 +269,7 @@ EXPORT_SYMBOL(locks_copy_lock);
>>
>>  static inline int flock_translate_cmd(int cmd) {
>>       if (cmd & LOCK_MAND)
>> -             return cmd & (LOCK_MAND | LOCK_RW);
>> +             return cmd & (LOCK_MAND | LOCK_RW | LOCK_DELETE);
>>       switch (cmd) {
>>       case LOCK_SH:
>>               return F_RDLCK;
>> @@ -614,6 +614,8 @@ deny_flags_to_cmd(unsigned int flags)
>>               cmd |= LOCK_READ;
>>       if (!(flags & O_DENYWRITE))
>>               cmd |= LOCK_WRITE;
>> +     if (!(flags & O_DENYDELETE))
>> +             cmd |= LOCK_DELETE;
>>
>>       return cmd;
>>  }
>> @@ -836,6 +838,31 @@ out:
>>       return error;
>>  }
>>
>> +int
>> +sharelock_may_delete(struct dentry *dentry)
>> +{
>> +     struct file_lock **before;
>> +     int rc = 0;
>> +
>> +     if (!IS_SHARELOCK(dentry->d_inode))
>> +             return rc;
>> +
>> +     lock_flocks();
>> +     for_each_lock(dentry->d_inode, before) {
>> +             struct file_lock *fl = *before;
>> +             if (IS_POSIX(fl))
>> +                     break;
>> +             if (IS_LEASE(fl))
>> +                     continue;
>> +             if (fl->fl_type & LOCK_DELETE)
>> +                     continue;
>
> Are you sure this logic is right? What if I have a normal non-LOCK_MAND
> lock on this file. Won't that prevent me from deleting it with this
> patch?
>

It is a bug, thank you for pointing it out. We need to skip all
non-LOCK_MAND locks here.

--
Best regards,
Pavel Shilovsky.
