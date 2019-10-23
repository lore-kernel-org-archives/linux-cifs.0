Return-Path: <SRS0=Yjbq=YQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF733CA9EB6
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Oct 2019 13:56:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9001521925
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Oct 2019 13:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406206AbfJWN45 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Oct 2019 09:56:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52410 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405260AbfJWN44 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 23 Oct 2019 09:56:56 -0400
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C6029C057EC6
        for <linux-cifs@vger.kernel.org>; Wed, 23 Oct 2019 13:56:54 +0000 (UTC)
Received: by mail-qk1-f199.google.com with SMTP id j10so12378015qka.10
        for <linux-cifs@vger.kernel.org>; Wed, 23 Oct 2019 06:56:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3CJUkQnh//w+BFCNzjUTJOv2nOk+7AGOeeI2gqCAi+A=;
        b=Hjabi/IUMXAGCVJZVU1R/InsOj5zHqTayfr044JZYxmTe1XO8ED3nzys2cUkqM9xyB
         Rrubuf5QrLf5Vy1xT3wG6gBH77hdkd+QxE7xCnMRg7+87B9ab5mpiVh1dp6/YN5tBF5C
         VQc7qd0zN7ZJ+OGb4e4sxeGZdWf3swRH+/97C6j1wRBa7XmBFSAcMOYGsV/0yaYxvYKf
         NW3WMMLmnmpqSYftSTBj8n9yr4SeWngqvowBFXkcNxJovX4GUeNEt7oCYyeihb/DVizy
         uv/94+Edh3lCYZ1CmHYeHjMytd2YG/FOLOl5LSqcwKA2dBYZ6VkSrfg2c4nn10+24u7K
         lxYA==
X-Gm-Message-State: APjAAAX13vJWi8a0+bLM9+DftGXrUZAxwmSgcTQ/LxETZeZ3ORJHxNAW
        pugafqppg8elaT4clzuqdPw7/5NDy0OzHM1P5yxGyJMKynsdIO4+xULJ1Rqy9SNUY5jGvI55Wds
        tcIBa1XNSnJVq3YN90WN+dOdc+6UCYIaCN7zZCA==
X-Received: by 2002:a0c:ee86:: with SMTP id u6mr9019968qvr.48.1571839013949;
        Wed, 23 Oct 2019 06:56:53 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy8lxh9KPNvMUeqY9g1gymQbmzuskJtIiX6xRStRLnY/cen89u6WB9j7OoRPXNk0Mh+AIDH8tEU69mD7GjcoMM=
X-Received: by 2002:a0c:ee86:: with SMTP id u6mr9019934qvr.48.1571839013610;
 Wed, 23 Oct 2019 06:56:53 -0700 (PDT)
MIME-Version: 1.0
References: <1571776423-32000-1-git-send-email-dwysocha@redhat.com>
 <1786263555.8106229.1571806248056.JavaMail.zimbra@redhat.com>
 <CALF+zO=4Y1kAYWAkP0A-6h7m4bxrm-fVvzeogMvN06uzQB-EBQ@mail.gmail.com> <147861584.8131501.1571821314367.JavaMail.zimbra@redhat.com>
In-Reply-To: <147861584.8131501.1571821314367.JavaMail.zimbra@redhat.com>
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Wed, 23 Oct 2019 09:56:15 -0400
Message-ID: <CALF+zOk67c4pBLY=0zUQ+erAzJf5N_8ObxYT4J_OzAVth2149A@mail.gmail.com>
Subject: Re: [RFC PATCH] cifs: Fix cifsInodeInfo lock_sem deadlock with
 multiple readers
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Oct 23, 2019 at 5:01 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
>
>
>
>
> ----- Original Message -----
> > From: "David Wysochanski" <dwysocha@redhat.com>
> > To: "Ronnie Sahlberg" <lsahlber@redhat.com>
> > Cc: "linux-cifs" <linux-cifs@vger.kernel.org>
> > Sent: Wednesday, 23 October, 2019 6:35:34 PM
> > Subject: Re: [RFC PATCH] cifs: Fix cifsInodeInfo lock_sem deadlock with multiple readers
> >
> > On Wed, Oct 23, 2019 at 12:50 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
> > >
> > >
> > >
> > >
> > >
> > > ----- Original Message -----
> > > > From: "Dave Wysochanski" <dwysocha@redhat.com>
> > > > To: linux-cifs@vger.kernel.org
> > > > Sent: Wednesday, 23 October, 2019 6:33:43 AM
> > > > Subject: [RFC PATCH] cifs: Fix cifsInodeInfo lock_sem deadlock with
> > > > multiple readers
> > > >
> > > > NOTE: I have verified this fixes the problem but have not run
> > > > locking tests yet.
> > > >
> > > > There's a deadlock that is possible that can easily be seen with
> > > > multiple readers open/read/close of the same file.  The deadlock
> > > > is due to a reader calling down_read(lock_sem) and holding
> > > > it across the full IO, even if a network or server disruption
> > > > occurs and the session has to be reconnected.  Upon reconnect,
> > > > cifs_relock_file is called where down_read(lock_sem) is called
> > > > a second time.  Normally this is not a problem, but if there is
> > > > another process that calls down_write(lock_sem) in between the
> > > > first and second reader call to down_read(lock_sem), this will
> > > > cause a deadlock.  The caller of down_write (often either
> > > > _cifsFileInfo_put that is just removing and freeing cifsLockInfo
> > > > structures from the list of locks, or cifs_new_fileinfo, which
> > > > is just attaching cifs_fid_locks to cifsInodeInfo->llist), will
> > > > block due to the reader's first down_read(lock_sem) that obtains
> > > > the semaphore (read IO in flight).  And then when the server
> > > > comes back up, the reader that holds calls down_read(lock_sem)
> > > > a second time, and this time is blocked too because of the
> > > > blocked in down_write (rw_semaphores would starve writers if
> > > > this was not the case).  Interestingly enough, the callers of
> > > > down_write in the simple test case was not adding a
> > > > conflicting lock at all, just either opening or closing the
> > > > file, and modifying the list of locks attached to cifsInodeInfo,
> > > > this ends up tripping up the reader process and causing the
> > > > deadlock.
> > > >
> > > > The root of the problem is that lock_sem both protects the
> > > > cifsInodeInfo fields (such as the lllist - the list of locks),
> > > > but is also being re-used to avoid a conflicting lock coming
> > > > in while IO is in flight.  Add a new semaphore that tracks
> > > > just the IO in flight, and must be obtained before adding
> > > > a new lock.  While this does add another layer of complexity
> > > > and a semaphore ordering that must be obeyed to avoid new
> > > > deadlocks, it does clealy solve the underlying problem.
> > >
> > > The patch is hard to read(not your fault) since "patch" decided that almost
> > > all changes are in cifs_closedir() :-(
> > >
> >
> > Sorry I should have also said in the header that the patch was built
> > on top of 5.4-rc4 plus Pavel's patch:
> > "CIFS: Fix retry mid list corruption on reconnects"
> >
> > Also, there is an obvious bug in this patch where I am taking lock_sem
> > inside cifs_find_lock_conflict but that
> > does not work for obvious reasons - needs to be moved back to callers.
> > FWIW, I have a v2 patch that fixes
> > that and I have started some locking tests on.
> >
> > >
> > > You are reverting 560d388950. it is unfortunate because I think we should
> > > make either cifs_reopen_file() or cifs_strict_readv()
> > > using down_read_nested() to suppress the warnings from the validator or
> > > else we will get a lot of these log entries in dmesg
> > > (almost) everytime we get a reconnect.
> > >
> >
> > I think you misunderstood the patch or the header didn't explain that
> > part.  It is actually removing the top level holding of
> > lock_sem across the IO, because that leads to the deadlock - the root
> > is that one process calls down_read twice, which
> > IMO is erroneous.
> >
> > Instead of leaving the code paths where down_read can be called twice,
> > there is a new rw_semaphore, inflight_io_sem, that
> > protects the IO from someone adding a brlock that would restrict the
> > IO.  The lock_sem still protects the same fields from
> > modification, it just does not cover "preventing someone from adding a
> > conflicting brlock during IO".
> >
> >
> > > A different approach, could be to change _cifsFileInfo_put() to use a
> > > down_write_trylock()-sleep() loop instead of a blocking down_write() call.
> > >
> > > I.e. something like this ?
> > > (and then the same at the other places where we have a deadlock vulnerable
> > > down_write() call)
> > >
> >
> > Yes your approach is less lines way to go about preventing the
> > deadlock.  The biggest downsides I see is that it does not
> > remove the code paths which call down_read twice (which is dangerous
> > for the reason here), and it does not eliminate
> > (but does reduce) the lock contention due to multi-use nature of
> > lock_sem (not only does it protect modification to the
> > fields, it also doubles as preventing the conflicting brlock during
> > IO).  I agree it is simpler and avoids adding another
> > semaphore so it may be a better approach.
> >
> > For your suggested approach, I'm not sure how many places there are
> > that really matter as far as calls to down_write.
> > Looks like there are 9 different calls to down_write(cifsi->lock_sem),
> > and I know in the reproducer at least 2 of them matter.
>
>
>
> > I would say we should do all 9 to be thorough, not leave anything to
> > chance, and have consistent handling of lock_sem.
> > What do you think?
>
> I agree 100%.
>
> Lets do it for all 9 instances and add a comment to the header where we specify that
> we must always use a down_write_trylock()/msleep() instead of down_write() for this because we may need to call down_read() recursively in some
> codepaths.
>
Ok.

> Doing it for all places whether we strictly need to or not, today, is most future proof since the number of places where we MUST
> do this can change in the future with semi-unrelated patches and then we would accidentally reintroduce the deadlock.
>
Yes that is right, I agree.

>
> Can you try a simple patch where we do this for all 9 places and see if fixes the deadlock?
> And send to the list if it works?
>
> Since the patch is so trivial being just a
> - down_write()
> + if (!down_write_trylock())
> +      msleep()
> it will be trivial to backport it to earlier versions.
>
>

Yes I already did the sample patch like this changing all 9 places and
anticipating it may be a preferred patch.
I'm testing it now and if it all goes well I'll write-up a nice header
and post it.


>
> regards
> ronnie sahlberg
>
>
> >
> >
> > > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > > index 936e03892e2a..530af080dc61 100644
> > > --- a/fs/cifs/file.c
> > > +++ b/fs/cifs/file.c
> > > @@ -464,7 +464,8 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file,
> > > bool wait_oplock_handler)
> > >          * Delete any outstanding lock records. We'll lose them when the
> > >          file
> > >          * is closed anyway.
> > >          */
> > > -       down_write(&cifsi->lock_sem);
> > > +       while (!down_write_trylock(&cifsi->lock_sem))
> > > +               msleep(125);
> > >         list_for_each_entry_safe(li, tmp, &cifs_file->llist->locks, llist)
> > >         {
> > >                 list_del(&li->llist);
> > >                 cifs_del_lock_waiters(li);
> > >
> > >
> > >
> > >
> > > >
> > > > Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
> > > > ---
> > > >  fs/cifs/cifsfs.c   |  1 +
> > > >  fs/cifs/cifsglob.h |  1 +
> > > >  fs/cifs/file.c     | 24 +++++++++++++++++++-----
> > > >  3 files changed, 21 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > > > index c049c7b3aa87..10f614324e4e 100644
> > > > --- a/fs/cifs/cifsfs.c
> > > > +++ b/fs/cifs/cifsfs.c
> > > > @@ -1336,6 +1336,7 @@ static ssize_t cifs_copy_file_range(struct file
> > > > *src_file, loff_t off,
> > > >
> > > >       inode_init_once(&cifsi->vfs_inode);
> > > >       init_rwsem(&cifsi->lock_sem);
> > > > +     init_rwsem(&cifsi->io_inflight_sem);
> > > >  }
> > > >
> > > >  static int __init
> > > > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > > > index 50dfd9049370..40e8358dc1cc 100644
> > > > --- a/fs/cifs/cifsglob.h
> > > > +++ b/fs/cifs/cifsglob.h
> > > > @@ -1392,6 +1392,7 @@ struct cifsInodeInfo {
> > > >       bool can_cache_brlcks;
> > > >       struct list_head llist; /* locks helb by this inode */
> > > >       struct rw_semaphore lock_sem;   /* protect the fields above */
> > > > +     struct rw_semaphore io_inflight_sem; /* Used to avoid lock
> > > > conflicts  */
> > > >       /* BB add in lists for dirty pages i.e. write caching info for
> > > >       oplock */
> > > >       struct list_head openFileList;
> > > >       spinlock_t      open_file_lock; /* protects openFileList */
> > > > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > > > index 5ad15de2bb4f..417baa7f5dd3 100644
> > > > --- a/fs/cifs/file.c
> > > > +++ b/fs/cifs/file.c
> > > > @@ -621,7 +621,7 @@ int cifs_open(struct inode *inode, struct file *file)
> > > >       struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
> > > >       int rc = 0;
> > > >
> > > > -     down_read_nested(&cinode->lock_sem, SINGLE_DEPTH_NESTING);
> > > > +     down_read(&cinode->lock_sem);
> > > >       if (cinode->can_cache_brlcks) {
> > > >               /* can cache locks - no need to relock */
> > > >               up_read(&cinode->lock_sem);
> > > > @@ -973,6 +973,7 @@ int cifs_closedir(struct inode *inode, struct file
> > > > *file)
> > > >       struct cifs_fid_locks *cur;
> > > >       struct cifsInodeInfo *cinode = CIFS_I(d_inode(cfile->dentry));
> > > >
> > > > +     down_read(&cinode->lock_sem);
> > > >       list_for_each_entry(cur, &cinode->llist, llist) {
> > > >               rc = cifs_find_fid_lock_conflict(cur, offset, length, type,
> > > >                                                flags, cfile, conf_lock,
> > > > @@ -980,6 +981,7 @@ int cifs_closedir(struct inode *inode, struct file
> > > > *file)
> > > >               if (rc)
> > > >                       break;
> > > >       }
> > > > +     up_read(&cinode->lock_sem);
> > > >
> > > >       return rc;
> > > >  }
> > > > @@ -1027,9 +1029,11 @@ int cifs_closedir(struct inode *inode, struct file
> > > > *file)
> > > >  cifs_lock_add(struct cifsFileInfo *cfile, struct cifsLockInfo *lock)
> > > >  {
> > > >       struct cifsInodeInfo *cinode = CIFS_I(d_inode(cfile->dentry));
> > > > +     down_write(&cinode->io_inflight_sem);
> > > >       down_write(&cinode->lock_sem);
> > > >       list_add_tail(&lock->llist, &cfile->llist->locks);
> > > >       up_write(&cinode->lock_sem);
> > > > +     up_write(&cinode->io_inflight_sem);
> > > >  }
> > > >
> > > >  /*
> > > > @@ -1049,6 +1053,7 @@ int cifs_closedir(struct inode *inode, struct file
> > > > *file)
> > > >
> > > >  try_again:
> > > >       exist = false;
> > > > +     down_write(&cinode->io_inflight_sem);
> > > >       down_write(&cinode->lock_sem);
> > > >
> > > >       exist = cifs_find_lock_conflict(cfile, lock->offset, lock->length,
> > > > @@ -1057,6 +1062,7 @@ int cifs_closedir(struct inode *inode, struct file
> > > > *file)
> > > >       if (!exist && cinode->can_cache_brlcks) {
> > > >               list_add_tail(&lock->llist, &cfile->llist->locks);
> > > >               up_write(&cinode->lock_sem);
> > > > +             up_write(&cinode->io_inflight_sem);
> > > >               return rc;
> > > >       }
> > > >
> > > > @@ -1077,6 +1083,7 @@ int cifs_closedir(struct inode *inode, struct file
> > > > *file)
> > > >       }
> > > >
> > > >       up_write(&cinode->lock_sem);
> > > > +     up_write(&cinode->io_inflight_sem);
> > > >       return rc;
> > > >  }
> > > >
> > > > @@ -1125,14 +1132,17 @@ int cifs_closedir(struct inode *inode, struct
> > > > file
> > > > *file)
> > > >               return rc;
> > > >
> > > >  try_again:
> > > > +     down_write(&cinode->io_inflight_sem);
> > > >       down_write(&cinode->lock_sem);
> > > >       if (!cinode->can_cache_brlcks) {
> > > >               up_write(&cinode->lock_sem);
> > > > +             down_write(&cinode->io_inflight_sem);
> > > >               return rc;
> > > >       }
> > > >
> > > >       rc = posix_lock_file(file, flock, NULL);
> > > >       up_write(&cinode->lock_sem);
> > > > +     up_write(&cinode->io_inflight_sem);
> > > >       if (rc == FILE_LOCK_DEFERRED) {
> > > >               rc = wait_event_interruptible(flock->fl_wait,
> > > >               !flock->fl_blocker);
> > > >               if (!rc)
> > > > @@ -1331,6 +1341,7 @@ struct lock_to_push {
> > > >       int rc = 0;
> > > >
> > > >       /* we are going to update can_cache_brlcks here - need a write
> > > >       access */
> > > > +     down_write(&cinode->io_inflight_sem);
> > > >       down_write(&cinode->lock_sem);
> > > >       if (!cinode->can_cache_brlcks) {
> > > >               up_write(&cinode->lock_sem);
> > > > @@ -1346,6 +1357,7 @@ struct lock_to_push {
> > > >
> > > >       cinode->can_cache_brlcks = false;
> > > >       up_write(&cinode->lock_sem);
> > > > +     up_write(&cinode->io_inflight_sem);
> > > >       return rc;
> > > >  }
> > > >
> > > > @@ -1522,6 +1534,7 @@ struct lock_to_push {
> > > >       if (!buf)
> > > >               return -ENOMEM;
> > > >
> > > > +     down_write(&cinode->io_inflight_sem);
> > > >       down_write(&cinode->lock_sem);
> > > >       for (i = 0; i < 2; i++) {
> > > >               cur = buf;
> > > > @@ -1593,6 +1606,7 @@ struct lock_to_push {
> > > >       }
> > > >
> > > >       up_write(&cinode->lock_sem);
> > > > +     up_write(&cinode->io_inflight_sem);
> > > >       kfree(buf);
> > > >       return rc;
> > > >  }
> > > > @@ -3148,7 +3162,7 @@ ssize_t cifs_user_writev(struct kiocb *iocb, struct
> > > > iov_iter *from)
> > > >        * We need to hold the sem to be sure nobody modifies lock list
> > > >        * with a brlock that prevents writing.
> > > >        */
> > > > -     down_read(&cinode->lock_sem);
> > > > +     down_read(&cinode->io_inflight_sem);
> > > >
> > > >       rc = generic_write_checks(iocb, from);
> > > >       if (rc <= 0)
> > > > @@ -3161,7 +3175,7 @@ ssize_t cifs_user_writev(struct kiocb *iocb, struct
> > > > iov_iter *from)
> > > >       else
> > > >               rc = -EACCES;
> > > >  out:
> > > > -     up_read(&cinode->lock_sem);
> > > > +     up_read(&cinode->io_inflight_sem);
> > > >       inode_unlock(inode);
> > > >
> > > >       if (rc > 0)
> > > > @@ -3887,12 +3901,12 @@ ssize_t cifs_user_readv(struct kiocb *iocb,
> > > > struct
> > > > iov_iter *to)
> > > >        * We need to hold the sem to be sure nobody modifies lock list
> > > >        * with a brlock that prevents reading.
> > > >        */
> > > > -     down_read(&cinode->lock_sem);
> > > > +     down_read(&cinode->io_inflight_sem);
> > > >       if (!cifs_find_lock_conflict(cfile, iocb->ki_pos,
> > > >       iov_iter_count(to),
> > > >                                    tcon->ses->server->vals->shared_lock_type,
> > > >                                    0, NULL, CIFS_READ_OP))
> > > >               rc = generic_file_read_iter(iocb, to);
> > > > -     up_read(&cinode->lock_sem);
> > > > +     up_read(&cinode->io_inflight_sem);
> > > >       return rc;
> > > >  }
> > > >
> > > > --
> > > > 1.8.3.1
> > > >
> > > >
> >
