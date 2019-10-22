Return-Path: <SRS0=KUb6=YP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D402CA9EA0
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Oct 2019 16:44:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F220F20684
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Oct 2019 16:44:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731320AbfJVQoF convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Oct 2019 12:44:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1944 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728768AbfJVQoF (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 22 Oct 2019 12:44:05 -0400
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 24E9583F3D
        for <linux-cifs@vger.kernel.org>; Tue, 22 Oct 2019 16:44:05 +0000 (UTC)
Received: by mail-qk1-f199.google.com with SMTP id w67so9419903qkb.4
        for <linux-cifs@vger.kernel.org>; Tue, 22 Oct 2019 09:44:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ahTqrI+t9Y3cyaUoS74mgv7KWvBN0HdBQHVIcoq1Quo=;
        b=Epq9bExavzDJuh+hKHloXFZAdPFI9BUzCdIS7XOyhzMbqq7SAHh8wDxIfP1JCCqIoo
         H3d6645zL8+xPDLAhaZQCfZ8NGgDzDHib8MPzR25fJckYStHjPIm7V+HVu12XZBOPzxv
         if9ZtGVb3EGzbK9RBeonwuPJYeY+xC6kU0Jktw0VpQaqrzhmQ+EiTFZBSsUABafrAQlF
         FC4Qqg4ZiruFO11G6kaadPahJe8bmMRTzdfuZiywewCHM7HYcJyE3pFGLaMpdNwIZdBP
         2Blm9Hda/wE18Ap1zDMRZwPxfAWOAD9MoXbgQDd3pc1UtO52E0/giR+16EOlr21c7oY5
         67qA==
X-Gm-Message-State: APjAAAWfzCE2gG/hqkT8ERnY75WDtCiCqxTAS6OXki1Vd/LsVrVZKSfB
        1nps1Km8c+5xve8tD+Xj7xZPlf18RzZ7yE86rV+qi+nauc+7qrtIKc7YrKHctYn9klF2QoE4+bl
        LS8XCGBE7iEW/Et48G6JWvci2Jjuu+i72u47R0w==
X-Received: by 2002:a37:68b:: with SMTP id 133mr3753667qkg.315.1571762644375;
        Tue, 22 Oct 2019 09:44:04 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx4ZWOMA/0vGoLShQKF7ObrjPtL37b319p5xyMN+TKl0i5NDcq2h9Jy1rJaSrc6FNAcPRZwy6VzYDhOGkUgadw=
X-Received: by 2002:a37:68b:: with SMTP id 133mr3753640qkg.315.1571762644008;
 Tue, 22 Oct 2019 09:44:04 -0700 (PDT)
MIME-Version: 1.0
References: <CALF+zOmFsykoOWHy6Yt6dH6i-Cn9XWWCMsnsdPZaKuLE6jjO7w@mail.gmail.com>
 <CAKywueQRnmAuXJq+5ZER3ir6BhUgNFaaFCG6aZE7ep=qe=qbmQ@mail.gmail.com>
 <CALF+zO=UaXnrwn1X0MnZ9Gn4g5qOZ4_SdH=WDyQ3Uc1fpWtD_Q@mail.gmail.com> <CAKywueRo=uD+J2C0LxSgRG6TtvwL5XALiy-qBoxXf5ETQhdmHg@mail.gmail.com>
In-Reply-To: <CAKywueRo=uD+J2C0LxSgRG6TtvwL5XALiy-qBoxXf5ETQhdmHg@mail.gmail.com>
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Tue, 22 Oct 2019 12:43:26 -0400
Message-ID: <CALF+zOkqMLL05W6i_VZf17G+exz2PNObNwATVeU2GAZFFQyE6A@mail.gmail.com>
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

On Tue, Oct 22, 2019 at 12:09 PM Pavel Shilovsky <piastryyy@gmail.com> wrote:
>
> пн, 21 окт. 2019 г. в 20:05, David Wysochanski <dwysocha@redhat.com>:
> > > ? If yes, then we can create another work queue that will be
> > > re-locking files that have been re-opened. In this case
> > > cifs_reopen_file will simply submit the "re-lock" request to the queue
> > > without the need to grab the lock one more time.
> > >
> > I think you're approach of a work queue may work but it would have to
> > be on a per-pid basis, as would any solution.
>
> Why do you think we should have a queue per pid? What are possible
> problems to have a single queue per SMB connection or Share (Tree)
> connection?
>

What you're proposing may work but would have to see the code and how
lock_sem would be used.  If you're serializing the relocking to only
one pid it should be fine.

I can describe what I tried (attached patch) and why it did not work.
Here's the problem code path.  Note that down_read(lock_sem) #2 is
only a problem if down_write(lock_sem) happens between #1 and #2, but
we're trying to avoid #2 to avoid the deadlock.

PID: 5464   TASK: ffff9862640b2f80  CPU: 1   COMMAND: "python3-openloo"
 #0 [ffffbd2d81203a20] __schedule at ffffffff9aa629e3
 #1 [ffffbd2d81203ac0] schedule at ffffffff9aa62fe8
 #2 [ffffbd2d81203ac8] rwsem_down_read_failed at ffffffff9aa660cd
 #3 [ffffbd2d81203b58] cifs_reopen_file at ffffffffc0529dce [cifs]
<--- down_read (lock_sem) #2
 #4 [ffffbd2d81203c00] cifs_read.constprop.46 at ffffffffc052bbe0 [cifs]
 #5 [ffffbd2d81203ca8] cifs_readpage_worker at ffffffffc052c0a7 [cifs]
 #6 [ffffbd2d81203ce0] cifs_readpage at ffffffffc052c427 [cifs]
 #7 [ffffbd2d81203d20] generic_file_buffered_read at ffffffff9a40f2b1
 #8 [ffffbd2d81203e10] cifs_strict_readv at ffffffffc0533a7b [cifs]
<---- down_read (lock_sem) #1
 #9 [ffffbd2d81203e40] new_sync_read at ffffffff9a4b6e21
#10 [ffffbd2d81203ec8] vfs_read at ffffffff9a4b9671
#11 [ffffbd2d81203f00] ksys_read at ffffffff9a4b9aaf
#12 [ffffbd2d81203f38] do_syscall_64 at ffffffff9a2041cb

Note that each of these down_read() calls are per-pid (each pid has to
get the sem).   I tried this patch:
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1404,6 +1404,7 @@ struct cifsInodeInfo {
 #define CIFS_INO_DELETE_PENDING                  (3) /* delete
pending on server */
 #define CIFS_INO_INVALID_MAPPING         (4) /* pagecache is invalid */
 #define CIFS_INO_LOCK                    (5) /* lock bit for synchronization */
+#define CIFS_LOCK_SEM_HELD               (6) /* the lock_sem is held */
        unsigned long flags;
        spinlock_t writers_lock;
        unsigned int writers;           /* Number of writers on this inode */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 5ad15de2bb4f..153adcd3ad16 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -620,11 +620,15 @@ cifs_relock_file(struct cifsFileInfo *cfile)
        struct cifsInodeInfo *cinode = CIFS_I(d_inode(cfile->dentry));
        struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
        int rc = 0;
+       int lock_sem_held = 0;

-       down_read_nested(&cinode->lock_sem, SINGLE_DEPTH_NESTING);
+       lock_sem_held = test_bit(CIFS_LOCK_SEM_HELD, &cinode->flags);
+       if (!lock_sem_held)
+               down_read_nested(&cinode->lock_sem, SINGLE_DEPTH_NESTING);
        if (cinode->can_cache_brlcks) {
                /* can cache locks - no need to relock */
-               up_read(&cinode->lock_sem);
+               if (!lock_sem_held)
+                       up_read(&cinode->lock_sem);
                return rc;
        }

@@ -635,7 +639,8 @@ cifs_relock_file(struct cifsFileInfo *cfile)
        else
                rc = tcon->ses->server->ops->push_mand_locks(cfile);

-       up_read(&cinode->lock_sem);
+       if (!lock_sem_held)
+               up_read(&cinode->lock_sem);
        return rc;
 }

@@ -3888,11 +3893,13 @@ cifs_strict_readv(struct kiocb *iocb, struct
iov_iter *to)
         * with a brlock that prevents reading.
         */
        down_read(&cinode->lock_sem);
+       set_bit(CIFS_LOCK_SEM_HELD, &cinode->flags);
        if (!cifs_find_lock_conflict(cfile, iocb->ki_pos, iov_iter_count(to),
                                     tcon->ses->server->vals->shared_lock_type,
                                     0, NULL, CIFS_READ_OP))
                rc = generic_file_read_iter(iocb, to);
        up_read(&cinode->lock_sem);
+       clear_bit(CIFS_LOCK_SEM_HELD, &cinode->flags);
        return rc;
 }


Note that the bit is associated with the cifsInodeInfo file, and we
only have one file but multiple pids so it's not an effective
solution.  To describe, the patch doesn't work because when the server
goes down, you have many processes all having passed down_read() #1,
and they are blocked waiting for a response.  When the server comes
back at least one will see the bit is set and will skip down_read()
#2, but then it will proceed to finish the cifs_strict_readv(), and so
clear the bit, and other pids may not see the bit set anymore, and
will call down_read() #2, leading to the same deadlock.
