From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] cifs: Wait for writebacks to complete before
 attempting write.
Date: Thu, 6 Mar 2014 11:08:25 -0600
Message-ID: <CAH2r5muZQ0k6qHLaNvm1tG=f3hT=9qA2sQz1p8Km_4oTWT+DZA@mail.gmail.com>
References: <1393958157-29986-1-git-send-email-sprabhu@redhat.com> <20140304135147.222d9078@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140304135147.222d9078-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

FYI -

I sent Sachin some feedback on this today - looks like may have a
similar change needed to smb2_is_valid_oplock_break

On Tue, Mar 4, 2014 at 12:51 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue,  4 Mar 2014 18:35:57 +0000
> Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> Problem reported in Red Hat bz 1040329 for strict writes where we cache
>> only when we hold oplock and write direct to the server when we don't.
>>
>> When we receive an oplock break, we first change the oplock value for
>> the inode in cifsInodeInfo->oplock to indicate that we no longer hold
>> the oplock before we enqueue a task to flush changes to the backing
>> device. Once we have completed flushing the changes, we return the
>> oplock to the server.
>>
>> There are 2 ways here where we can have data corruption
>> 1) While we flush changes to the backing device as part of the oplock
>> break, we can have processes write to the file. These writes check for
>> the oplock, find none and attempt to write directly to the server.
>> These direct writes made while we are flushing from cache could be
>> overwritten by data being flushed from the cache causing data
>> corruption.
>> 2) While a thread runs in cifs_strict_writev, the machine could receive
>> and process an oplock break after the thread has checked the oplock and
>> found that it allows us to cache and before we have made changes to the
>> cache. In that case, we end up with a dirty page in cache when we
>> shouldn't have any. This will be flushed later and will overwrite all
>> subsequent writes to the part of the file represented by this page.
>>
>> Before making any writes to the server, we need to confirm that we are
>> not in the process of flushing data to the server and if we are, we
>> should wait until the process is complete before we attempt the write.
>> We should also wait for existing writes to complete before we process
>> an oplock break request which changes oplock values.
>>
>> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>  fs/cifs/cifsfs.c    | 14 +++++++++-
>>  fs/cifs/cifsglob.h  |  6 +++++
>>  fs/cifs/cifsproto.h |  3 +++
>>  fs/cifs/file.c      | 32 ++++++++++++++++++++---
>>  fs/cifs/misc.c      | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++--
>>  5 files changed, 123 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index 849f613..7c6b73c 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -253,6 +253,11 @@ cifs_alloc_inode(struct super_block *sb)
>>       cifs_set_oplock_level(cifs_inode, 0);
>>       cifs_inode->delete_pending = false;
>>       cifs_inode->invalid_mapping = false;
>> +     clear_bit(CIFS_INODE_PENDING_OPLOCK_BREAK, &cifs_inode->flags);
>> +     clear_bit(CIFS_INODE_PENDING_WRITERS, &cifs_inode->flags);
>> +     clear_bit(CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2, &cifs_inode->flags);
>> +     spin_lock_init(&cifs_inode->writers_lock);
>> +     cifs_inode->writers = 0;
>>       cifs_inode->vfs_inode.i_blkbits = 14;  /* 2**14 = CIFS_MAX_MSGSIZE */
>>       cifs_inode->server_eof = 0;
>>       cifs_inode->uniqueid = 0;
>> @@ -731,19 +736,26 @@ static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
>>                                  unsigned long nr_segs, loff_t pos)
>>  {
>>       struct inode *inode = file_inode(iocb->ki_filp);
>> +     struct cifsInodeInfo *cinode = CIFS_I(inode);
>>       ssize_t written;
>>       int rc;
>>
>> +     written = cifs_get_writer(cinode);
>> +     if (written)
>> +             return written;
>> +
>>       written = generic_file_aio_write(iocb, iov, nr_segs, pos);
>>
>>       if (CIFS_CACHE_WRITE(CIFS_I(inode)))
>> -             return written;
>> +             goto out;
>>
>>       rc = filemap_fdatawrite(inode->i_mapping);
>>       if (rc)
>>               cifs_dbg(FYI, "cifs_file_aio_write: %d rc on %p inode\n",
>>                        rc, inode);
>>
>> +out:
>> +     cifs_put_writer(cinode);
>>       return written;
>>  }
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index cf32f03..2a3a1cc 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -1113,6 +1113,12 @@ struct cifsInodeInfo {
>>       unsigned int epoch;             /* used to track lease state changes */
>>       bool delete_pending;            /* DELETE_ON_CLOSE is set */
>>       bool invalid_mapping;           /* pagecache is invalid */
>> +     unsigned long flags;
>> +#define CIFS_INODE_PENDING_OPLOCK_BREAK   (0) /* oplock break in progress */
>> +#define CIFS_INODE_PENDING_WRITERS     (1) /* Writes in progress */
>> +#define CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2 (2) /* Downgrade oplock to L2 */
>> +     spinlock_t writers_lock;
>> +     unsigned int writers;           /* Number of writers on this inode */
>>       unsigned long time;             /* jiffies of last update of inode */
>>       u64  server_eof;                /* current file size on server -- protected by i_lock */
>>       u64  uniqueid;                  /* server inode number */
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index acc4ee8..ca7980a 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -127,6 +127,9 @@ extern u64 cifs_UnixTimeToNT(struct timespec);
>>  extern struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time,
>>                                     int offset);
>>  extern void cifs_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock);
>> +extern int cifs_get_writer(struct cifsInodeInfo *cinode);
>> +extern void cifs_put_writer(struct cifsInodeInfo *cinode);
>> +extern void cifs_done_oplock_break(struct cifsInodeInfo *cinode);
>>  extern int cifs_unlock_range(struct cifsFileInfo *cfile,
>>                            struct file_lock *flock, const unsigned int xid);
>>  extern int cifs_push_mandatory_locks(struct cifsFileInfo *cfile);
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 53c1507..f281e28 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -2620,12 +2620,20 @@ cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
>>       struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
>>       ssize_t written;
>>
>> +     written = cifs_get_writer(cinode);
>> +     if (written)
>> +             return written;
>> +
>>       if (CIFS_CACHE_WRITE(cinode)) {
>>               if (cap_unix(tcon->ses) &&
>>               (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability))
>> -                 && ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
>> -                     return generic_file_aio_write(iocb, iov, nr_segs, pos);
>> -             return cifs_writev(iocb, iov, nr_segs, pos);
>> +               && ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0)) {
>> +                     written = generic_file_aio_write(
>> +                                     iocb, iov, nr_segs, pos);
>> +                     goto out;
>> +             }
>> +             written = cifs_writev(iocb, iov, nr_segs, pos);
>> +             goto out;
>>       }
>>       /*
>>        * For non-oplocked files in strict cache mode we need to write the data
>> @@ -2645,6 +2653,8 @@ cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
>>                        inode);
>>               cinode->oplock = 0;
>>       }
>> +out:
>> +     cifs_put_writer(cinode);
>>       return written;
>>  }
>>
>> @@ -3656,6 +3666,13 @@ static int cifs_launder_page(struct page *page)
>>       return rc;
>>  }
>>
>> +static int
>> +cifs_pending_writers_wait(void *unused)
>> +{
>> +     schedule();
>> +     return 0;
>> +}
>> +
>>  void cifs_oplock_break(struct work_struct *work)
>>  {
>>       struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
>> @@ -3665,6 +3682,14 @@ void cifs_oplock_break(struct work_struct *work)
>>       struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
>>       int rc = 0;
>>
>> +     wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
>> +                     cifs_pending_writers_wait, TASK_UNINTERRUPTIBLE);
>> +
>> +     if (test_bit(CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2, &cinode->flags))
>> +             cifs_set_oplock_level(cinode, OPLOCK_READ);
>> +     else
>> +             cifs_set_oplock_level(cinode, 0);
>> +
>>       if (!CIFS_CACHE_WRITE(cinode) && CIFS_CACHE_READ(cinode) &&
>>                                               cifs_has_mand_locks(cinode)) {
>>               cifs_dbg(FYI, "Reset oplock to None for inode=%p due to mand locks\n",
>> @@ -3701,6 +3726,7 @@ void cifs_oplock_break(struct work_struct *work)
>>                                                            cinode);
>>               cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
>>       }
>> +     cifs_done_oplock_break(cinode);
>>  }
>>
>>  /*
>> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
>> index 2f9f379..3b0c62e 100644
>> --- a/fs/cifs/misc.c
>> +++ b/fs/cifs/misc.c
>> @@ -466,8 +466,22 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
>>                               cifs_dbg(FYI, "file id match, oplock break\n");
>>                               pCifsInode = CIFS_I(netfile->dentry->d_inode);
>>
>> -                             cifs_set_oplock_level(pCifsInode,
>> -                                     pSMB->OplockLevel ? OPLOCK_READ : 0);
>> +                             set_bit(CIFS_INODE_PENDING_OPLOCK_BREAK,
>> +                                     &pCifsInode->flags);
>> +
>> +                             /*
>> +                              * Set flag if the server downgrades the oplock
>> +                              * to L2 else clear.
>> +                              */
>> +                             if (pSMB->OplockLevel)
>> +                                     set_bit(
>> +                                        CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
>> +                                        &pCifsInode->flags);
>> +                             else
>> +                                     clear_bit(
>> +                                        CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
>> +                                        &pCifsInode->flags);
>> +
>>                               queue_work(cifsiod_wq,
>>                                          &netfile->oplock_break);
>>                               netfile->oplock_break_cancelled = false;
>> @@ -551,6 +565,62 @@ void cifs_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock)
>>               cinode->oplock = 0;
>>  }
>>
>> +static int
>> +cifs_oplock_break_wait(void *unused)
>> +{
>> +     schedule();
>> +     return signal_pending(current) ? -ERESTARTSYS : 0;
>> +}
>> +
>> +/*
>> + * We wait for oplock breaks to be processed before we attempt to perform
>> + * writes.
>> + */
>> +int cifs_get_writer(struct cifsInodeInfo *cinode)
>> +{
>> +     int rc;
>> +
>> +start:
>> +     rc = wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_OPLOCK_BREAK,
>> +                                cifs_oplock_break_wait, TASK_KILLABLE);
>> +     if (rc)
>> +             return rc;
>> +
>> +     spin_lock(&cinode->writers_lock);
>> +     if (!cinode->writers)
>> +             set_bit(CIFS_INODE_PENDING_WRITERS, &cinode->flags);
>> +     cinode->writers++;
>> +     /* Check to see if we have started servicing an oplock break */
>> +     if (test_bit(CIFS_INODE_PENDING_OPLOCK_BREAK, &cinode->flags)) {
>> +             cinode->writers--;
>> +             if (cinode->writers == 0) {
>> +                     clear_bit(CIFS_INODE_PENDING_WRITERS, &cinode->flags);
>> +                     wake_up_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS);
>> +             }
>> +             spin_unlock(&cinode->writers_lock);
>> +             goto start;
>> +     }
>> +     spin_unlock(&cinode->writers_lock);
>> +     return 0;
>> +}
>> +
>> +void cifs_put_writer(struct cifsInodeInfo *cinode)
>> +{
>> +     spin_lock(&cinode->writers_lock);
>> +     cinode->writers--;
>> +     if (cinode->writers == 0) {
>> +             clear_bit(CIFS_INODE_PENDING_WRITERS, &cinode->flags);
>> +             wake_up_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS);
>> +     }
>> +     spin_unlock(&cinode->writers_lock);
>> +}
>> +
>> +void cifs_done_oplock_break(struct cifsInodeInfo *cinode)
>> +{
>> +     clear_bit(CIFS_INODE_PENDING_OPLOCK_BREAK, &cinode->flags);
>> +     wake_up_bit(&cinode->flags, CIFS_INODE_PENDING_OPLOCK_BREAK);
>> +}
>> +
>>  bool
>>  backup_cred(struct cifs_sb_info *cifs_sb)
>>  {
>
> Looks reasonable. There's probably some way to do this that doesn't
> require spinlocking at all, but that's probably more fragile and
> definitely less trivial.
>
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
