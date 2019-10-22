Return-Path: <SRS0=KUb6=YP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5339CA9EA0
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Oct 2019 19:01:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BDCD205ED
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Oct 2019 19:01:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732436AbfJVTBN convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Oct 2019 15:01:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53718 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731740AbfJVTBM (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 22 Oct 2019 15:01:12 -0400
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E81188535C
        for <linux-cifs@vger.kernel.org>; Tue, 22 Oct 2019 19:01:11 +0000 (UTC)
Received: by mail-qk1-f200.google.com with SMTP id m189so13073518qkc.7
        for <linux-cifs@vger.kernel.org>; Tue, 22 Oct 2019 12:01:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=m0uQfwab9wXQGZliJMi0dJdYLUqBkhW/GM6RvKE7hN4=;
        b=MtWJ+3x7dcf41qyxQ9GRbbxbjWqjmVc2uF2Lo8iFgNfgsfnbKkL0rH7T/Dy0xPiIdX
         smRc7heNFzctqpGsKWpQ0c2iN4KzqrKOcqtDMLN1GsVD3+HzTaqeC44BsWNvD3JbAXQF
         Z2ny1pzuRMF0U9yM7MJ4rJvQiliKFJG7/9fgxgcwKim7VqnPUinx6oBvySj6M/6+T4VH
         baINSD4KztdRPzasDYSjF5sS7mPeMHkT2xQGI1eE4r/RXbPMnBrSKwUa8hNmPxjyzDS4
         WpcHyDTC3GKTEscSiGdh+DbV/6nJgOPqgRInVOKlo9uP8OsMM40GlQccQ4XPkoqin1v3
         yRMQ==
X-Gm-Message-State: APjAAAVuQll368VsLBSj8smMilDkcsq7/2knbmOXEjc2e0Z4DEGbVK1U
        Ac3xjgFdfT+/5LiZLsY/45D2b/1miXUwX7hQJ9Ta9oXJJmzH4C/r2tiXuK0QCnFD1LGgbn6/Dww
        cMyhWw0XY7cZlZKUp1Rhk9F3QL0SbgBHF1F3XwQ==
X-Received: by 2002:a0c:da8b:: with SMTP id z11mr4947873qvj.126.1571770870993;
        Tue, 22 Oct 2019 12:01:10 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzatGTCf5m++1+wHdjVE0Cg3mSZVSeVujD6iEjsHIgnytvfhkqBmNCNCeGi3TY7BnbLMHosgA0OGZS6fEZtFAQ=
X-Received: by 2002:a0c:da8b:: with SMTP id z11mr4947817qvj.126.1571770870413;
 Tue, 22 Oct 2019 12:01:10 -0700 (PDT)
MIME-Version: 1.0
References: <CALF+zOmFsykoOWHy6Yt6dH6i-Cn9XWWCMsnsdPZaKuLE6jjO7w@mail.gmail.com>
 <CAKywueQRnmAuXJq+5ZER3ir6BhUgNFaaFCG6aZE7ep=qe=qbmQ@mail.gmail.com>
 <CALF+zO=UaXnrwn1X0MnZ9Gn4g5qOZ4_SdH=WDyQ3Uc1fpWtD_Q@mail.gmail.com>
 <CAKywueRo=uD+J2C0LxSgRG6TtvwL5XALiy-qBoxXf5ETQhdmHg@mail.gmail.com> <CALF+zOkqMLL05W6i_VZf17G+exz2PNObNwATVeU2GAZFFQyE6A@mail.gmail.com>
In-Reply-To: <CALF+zOkqMLL05W6i_VZf17G+exz2PNObNwATVeU2GAZFFQyE6A@mail.gmail.com>
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Tue, 22 Oct 2019 15:00:34 -0400
Message-ID: <CALF+zOkrxNMAr==jFdfqOfojbg9thjY4bKLuO2s4m_gs3jEr=Q@mail.gmail.com>
Subject: Re: Easily reproducible deadlock on 5.4-rc4 with cifsInodeInfo.lock_sem
 semaphore after network disruption or smb restart
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Oct 22, 2019 at 12:43 PM David Wysochanski <dwysocha@redhat.com> wrote:
>
> On Tue, Oct 22, 2019 at 12:09 PM Pavel Shilovsky <piastryyy@gmail.com> wrote:
> >
> > пн, 21 окт. 2019 г. в 20:05, David Wysochanski <dwysocha@redhat.com>:
> > > > ? If yes, then we can create another work queue that will be
> > > > re-locking files that have been re-opened. In this case
> > > > cifs_reopen_file will simply submit the "re-lock" request to the queue
> > > > without the need to grab the lock one more time.
> > > >
> > > I think you're approach of a work queue may work but it would have to
> > > be on a per-pid basis, as would any solution.
> >
> > Why do you think we should have a queue per pid? What are possible
> > problems to have a single queue per SMB connection or Share (Tree)
> > connection?
> >
>
> What you're proposing may work but would have to see the code and how
> lock_sem would be used.  If you're serializing the relocking to only
> one pid it should be fine.
>
> I can describe what I tried (attached patch) and why it did not work.
> Here's the problem code path.  Note that down_read(lock_sem) #2 is
> only a problem if down_write(lock_sem) happens between #1 and #2, but
> we're trying to avoid #2 to avoid the deadlock.
>
> PID: 5464   TASK: ffff9862640b2f80  CPU: 1   COMMAND: "python3-openloo"
>  #0 [ffffbd2d81203a20] __schedule at ffffffff9aa629e3
>  #1 [ffffbd2d81203ac0] schedule at ffffffff9aa62fe8
>  #2 [ffffbd2d81203ac8] rwsem_down_read_failed at ffffffff9aa660cd
>  #3 [ffffbd2d81203b58] cifs_reopen_file at ffffffffc0529dce [cifs]
> <--- down_read (lock_sem) #2
>  #4 [ffffbd2d81203c00] cifs_read.constprop.46 at ffffffffc052bbe0 [cifs]
>  #5 [ffffbd2d81203ca8] cifs_readpage_worker at ffffffffc052c0a7 [cifs]
>  #6 [ffffbd2d81203ce0] cifs_readpage at ffffffffc052c427 [cifs]
>  #7 [ffffbd2d81203d20] generic_file_buffered_read at ffffffff9a40f2b1
>  #8 [ffffbd2d81203e10] cifs_strict_readv at ffffffffc0533a7b [cifs]
> <---- down_read (lock_sem) #1
>  #9 [ffffbd2d81203e40] new_sync_read at ffffffff9a4b6e21
> #10 [ffffbd2d81203ec8] vfs_read at ffffffff9a4b9671
> #11 [ffffbd2d81203f00] ksys_read at ffffffff9a4b9aaf
> #12 [ffffbd2d81203f38] do_syscall_64 at ffffffff9a2041cb
>
> Note that each of these down_read() calls are per-pid (each pid has to
> get the sem).   I tried this patch:
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1404,6 +1404,7 @@ struct cifsInodeInfo {
>  #define CIFS_INO_DELETE_PENDING                  (3) /* delete
> pending on server */
>  #define CIFS_INO_INVALID_MAPPING         (4) /* pagecache is invalid */
>  #define CIFS_INO_LOCK                    (5) /* lock bit for synchronization */
> +#define CIFS_LOCK_SEM_HELD               (6) /* the lock_sem is held */
>         unsigned long flags;
>         spinlock_t writers_lock;
>         unsigned int writers;           /* Number of writers on this inode */
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 5ad15de2bb4f..153adcd3ad16 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -620,11 +620,15 @@ cifs_relock_file(struct cifsFileInfo *cfile)
>         struct cifsInodeInfo *cinode = CIFS_I(d_inode(cfile->dentry));
>         struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
>         int rc = 0;
> +       int lock_sem_held = 0;
>
> -       down_read_nested(&cinode->lock_sem, SINGLE_DEPTH_NESTING);
> +       lock_sem_held = test_bit(CIFS_LOCK_SEM_HELD, &cinode->flags);
> +       if (!lock_sem_held)
> +               down_read_nested(&cinode->lock_sem, SINGLE_DEPTH_NESTING);
>         if (cinode->can_cache_brlcks) {
>                 /* can cache locks - no need to relock */
> -               up_read(&cinode->lock_sem);
> +               if (!lock_sem_held)
> +                       up_read(&cinode->lock_sem);
>                 return rc;
>         }
>
> @@ -635,7 +639,8 @@ cifs_relock_file(struct cifsFileInfo *cfile)
>         else
>                 rc = tcon->ses->server->ops->push_mand_locks(cfile);
>
> -       up_read(&cinode->lock_sem);
> +       if (!lock_sem_held)
> +               up_read(&cinode->lock_sem);
>         return rc;
>  }
>
> @@ -3888,11 +3893,13 @@ cifs_strict_readv(struct kiocb *iocb, struct
> iov_iter *to)
>          * with a brlock that prevents reading.
>          */
>         down_read(&cinode->lock_sem);
> +       set_bit(CIFS_LOCK_SEM_HELD, &cinode->flags);
>         if (!cifs_find_lock_conflict(cfile, iocb->ki_pos, iov_iter_count(to),
>                                      tcon->ses->server->vals->shared_lock_type,
>                                      0, NULL, CIFS_READ_OP))
>                 rc = generic_file_read_iter(iocb, to);
>         up_read(&cinode->lock_sem);
> +       clear_bit(CIFS_LOCK_SEM_HELD, &cinode->flags);
>         return rc;
>  }
>
>
> Note that the bit is associated with the cifsInodeInfo file, and we
> only have one file but multiple pids so it's not an effective
> solution.  To describe, the patch doesn't work because when the server
> goes down, you have many processes all having passed down_read() #1,
> and they are blocked waiting for a response.  When the server comes
> back at least one will see the bit is set and will skip down_read()
> #2, but then it will proceed to finish the cifs_strict_readv(), and so
> clear the bit, and other pids may not see the bit set anymore, and
> will call down_read() #2, leading to the same deadlock.


One other thing to think about here is this.  The other part of the
deadlock, as seen in the reproducer, is due to this process:

PID: 5411   TASK: ffff9862788fc740  CPU: 3   COMMAND: "python3-openloo"
 #0 [ffffbd2d80fbfc60] __schedule at ffffffff9aa629e3
 #1 [ffffbd2d80fbfd00] schedule at ffffffff9aa62fe8
 #2 [ffffbd2d80fbfd08] rwsem_down_write_failed at ffffffff9aa65dbc
 #3 [ffffbd2d80fbfda8] down_write at ffffffff9aa65be9
 #4 [ffffbd2d80fbfdb8] _cifsFileInfo_put at ffffffffc052da65 [cifs]
 #5 [ffffbd2d80fbfe98] cifs_close at ffffffffc052dd3f [cifs]
 #6 [ffffbd2d80fbfea8] __fput at ffffffff9a4ba5c7
 #7 [ffffbd2d80fbfee8] task_work_run at ffffffff9a2d1c5a
 #8 [ffffbd2d80fbff20] exit_to_usermode_loop at ffffffff9a203b4b
 #9 [ffffbd2d80fbff38] do_syscall_64 at ffffffff9a2042f2
#10 [ffffbd2d80fbff50] entry_SYSCALL_64_after_hwframe at ffffffff9ac000ad


What's that process doing?  Well it is blocked on down_write()
deleting and freeing all entries on cifs_file->llist->locks
void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, bool wait_oplock_handler)

    /*
     * Delete any outstanding lock records. We'll lose them when the file
     * is closed anyway.
     */
    down_write(&cifsi->lock_sem);
    list_for_each_entry_safe(li, tmp, &cifs_file->llist->locks, llist) {
        list_del(&li->llist);
        cifs_del_lock_waiters(li);
        kfree(li);
    }


The other trace we see where someone is trying to down_write is here:

PID: 14207  TASK: ffff8ac1f3369e40  CPU: 6   COMMAND: "python3-openloo"
 #0 [ffff9cfc41ccb990] __schedule at ffffffff9f9d2d29
 #1 [ffff9cfc41ccba20] schedule at ffffffff9f9d31a9
 #2 [ffff9cfc41ccba38] rwsem_down_write_slowpath at ffffffff9f131b0a
 #3 [ffff9cfc41ccbb08] cifs_new_fileinfo at ffffffffc065833a [cifs]
 #4 [ffff9cfc41ccbb78] cifs_open at ffffffffc0658a8c [cifs]
 #5 [ffff9cfc41ccbcd0] do_dentry_open at ffffffff9f2f09ca
 #6 [ffff9cfc41ccbd00] path_openat at ffffffff9f3050ad
 #7 [ffff9cfc41ccbdd8] do_filp_open at ffffffff9f307431
 #8 [ffff9cfc41ccbee0] do_sys_open at ffffffff9f2f2154
 #9 [ffff9cfc41ccbf38] do_syscall_64 at ffffffff9f0042bb
#10 [ffff9cfc41ccbf50] entry_SYSCALL_64_after_hwframe at ffffffff9fa0008c

What is that process doing?  It is creating a new empty list of
cifs_fid_locks and adding that onto cinode->llist:
cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
          struct tcon_link *tlink, __u32 oplock)
...
    cfile = kzalloc(sizeof(struct cifsFileInfo), GFP_KERNEL);
    if (cfile == NULL)
        return cfile;

    fdlocks = kzalloc(sizeof(struct cifs_fid_locks), GFP_KERNEL);
    if (!fdlocks) {
        kfree(cfile);
        return NULL;
    }

    INIT_LIST_HEAD(&fdlocks->locks);
    fdlocks->cfile = cfile;
    cfile->llist = fdlocks;
    down_write(&cinode->lock_sem);
    list_add(&fdlocks->llist, &cinode->llist);
    up_write(&cinode->lock_sem);



So back to the reader, why did he down_read() and hold the semaphore
and go to sleep waiting for the read response (or a reconnect)?
cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to)
...
    /*
     * We need to hold the sem to be sure nobody modifies lock list
     * with a brlock that prevents reading.
     */
    down_read(&cinode->lock_sem);
    if (!cifs_find_lock_conflict(cfile, iocb->ki_pos, iov_iter_count(to),
                     tcon->ses->server->vals->shared_lock_type,
                     0, NULL, CIFS_READ_OP))
        rc = generic_file_read_iter(iocb, to);
    up_read(&cinode->lock_sem);


Neither of the above two callers of down_write() are doing the
operation that down_read #1 is meaning to avoid - "modify the lock
list with a brlock that prevents reading".
So if there is some way to pull that piece out, then you can solve the
deadlock.  The existing use of lock_sem to both a) protect reads
against a lock that prevents reading, and b) protect modifications to
cinode->llist causes unnecessary contention of the semaphore and this
deadlock.
