Return-Path: <SRS0=c2dJ=YS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D105DCA9EAF
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Oct 2019 01:23:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A617621D7B
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Oct 2019 01:23:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388830AbfJYBXr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 24 Oct 2019 21:23:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48212 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388701AbfJYBXr (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 24 Oct 2019 21:23:47 -0400
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 606DAC049E10
        for <linux-cifs@vger.kernel.org>; Fri, 25 Oct 2019 01:23:46 +0000 (UTC)
Received: by mail-qk1-f200.google.com with SMTP id s14so673949qkg.12
        for <linux-cifs@vger.kernel.org>; Thu, 24 Oct 2019 18:23:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NwbQTkijrN6NABRO3e2oglmsIqJHoiL95bPmzxB+rNU=;
        b=VIohoB852zkOjRx1ch5vXZBDM9qRHygjn4jmkOjPIRZeDSqN4zgFUDKBMNYYETGQf7
         jBO6fGCbMBRWO/Fp5L1MFUICC2o7OcMeWbYci4js58Wxmc2TjbQtClCTHvSU4E5yAs2u
         ucUI1hennor5TnPO3k2VfeWcITLARrAoj2cqwjfHaaJ51epFazaq0IjJX106h+co451a
         TbyTrHg2ScFF0tPBnAh5aAhjkE5MXA6B5anQtGj7CWf7hNPGSBp20Dm+vrcvcSYwnPHn
         vDUZLbSvlubZXPzmg5XK5e+UoWgdlb1XHKRpDEeaY3Hr+NGgT7VAYU2ztO2NU+8CFnZQ
         mPeA==
X-Gm-Message-State: APjAAAXk/JVYk75Gl86UmfuhJ4sXrRBgDWe44/D9mZZXur6S62R1h699
        WFUcn+a9VvKMadwbGv6VqBoVzTw5JBob3qAGUWxFYjg0BWyR6vo2XshO2DDC4Ib3HlERn8/nF7f
        E/2Bm/rf4zXHU+8PR9A4Sd7eroIIRIKVwF7b4bw==
X-Received: by 2002:ac8:3209:: with SMTP id x9mr109230qta.293.1571966625635;
        Thu, 24 Oct 2019 18:23:45 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyO6v94I7IikPLSrwDMuhHTpbv4NEcBLDXf5rTMYpQEhtP/Xwd19GgeQoLukJU7OiOS+Ej0c9RMCi+QLzfgiQM=
X-Received: by 2002:ac8:3209:: with SMTP id x9mr109211qta.293.1571966625295;
 Thu, 24 Oct 2019 18:23:45 -0700 (PDT)
MIME-Version: 1.0
References: <20191024235120.8059-1-lsahlber@redhat.com> <20191024235120.8059-2-lsahlber@redhat.com>
In-Reply-To: <20191024235120.8059-2-lsahlber@redhat.com>
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Thu, 24 Oct 2019 21:23:09 -0400
Message-ID: <CALF+zO=bGY2KMUbjakjTcEx2CoxcQxk_bAiPEhhrtzkef4XcQQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix cifsInodeInfo lock_sem deadlock when reconnect occurs
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Oct 24, 2019 at 7:51 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> From: Dave Wysochanski <dwysocha@redhat.com>
>
> There's a deadlock that is possible and can easily be seen with
> a test where multiple readers open/read/close of the same file
> and a disruption occurs causing reconnect.  The deadlock is due
> a reader thread inside cifs_strict_readv calling down_read and
> obtaining lock_sem, and then after reconnect inside
> cifs_reopen_file calling down_read a second time.  If in
> between the two down_read calls, a down_write comes from
> another process, deadlock occurs.
>
>         CPU0                    CPU1
>         ----                    ----
> cifs_strict_readv()
>  down_read(&cifsi->lock_sem);
>                                _cifsFileInfo_put
>                                   OR
>                                cifs_new_fileinfo
>                                 down_write(&cifsi->lock_sem);
> cifs_reopen_file()
>  down_read(&cifsi->lock_sem);
>
> Fix the above by changing all down_write(lock_sem) calls to
> down_write_trylock(lock_sem)/msleep() loop, which in turn
> makes the second down_read call benign since it will never
> block behind the writer while holding lock_sem.
>
> Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
> Suggested-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifsglob.h  |  5 +++++
>  fs/cifs/cifsproto.h |  1 +
>  fs/cifs/file.c      | 23 +++++++++++++++--------
>  fs/cifs/smb2file.c  |  2 +-
>  4 files changed, 22 insertions(+), 9 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 50dfd9049370..d78bfcc19156 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1391,6 +1391,11 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file);
>  struct cifsInodeInfo {
>         bool can_cache_brlcks;
>         struct list_head llist; /* locks helb by this inode */
> +       /*
> +        * NOTE: Some code paths call down_read(lock_sem) twice, so
> +        * we must always use use cifs_down_write() instead of down_write()
> +        * for this semaphore to avoid deadlocks.
> +        */
>         struct rw_semaphore lock_sem;   /* protect the fields above */
>         /* BB add in lists for dirty pages i.e. write caching info for oplock */
>         struct list_head openFileList;
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index e53e9f62b87b..fe597d3d5208 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -170,6 +170,7 @@ extern int cifs_unlock_range(struct cifsFileInfo *cfile,
>                              struct file_lock *flock, const unsigned int xid);
>  extern int cifs_push_mandatory_locks(struct cifsFileInfo *cfile);
>
> +extern void cifs_down_write(struct rw_semaphore *sem);
>  extern struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fid *fid,
>                                               struct file *file,
>                                               struct tcon_link *tlink,
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 0e0217641de1..a80ec683ea32 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -281,6 +281,13 @@ cifs_has_mand_locks(struct cifsInodeInfo *cinode)
>         return has_locks;
>  }
>
> +void
> +cifs_down_write(struct rw_semaphore *sem)
> +{
> +       while (!down_write_trylock(sem))
> +               msleep(10);
> +}
> +
>  struct cifsFileInfo *
>  cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
>                   struct tcon_link *tlink, __u32 oplock)
> @@ -306,7 +313,7 @@ cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
>         INIT_LIST_HEAD(&fdlocks->locks);
>         fdlocks->cfile = cfile;
>         cfile->llist = fdlocks;
> -       down_write(&cinode->lock_sem);
> +       cifs_down_write(&cinode->lock_sem);
>         list_add(&fdlocks->llist, &cinode->llist);
>         up_write(&cinode->lock_sem);
>
> @@ -464,7 +471,7 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file, bool wait_oplock_handler)
>          * Delete any outstanding lock records. We'll lose them when the file
>          * is closed anyway.
>          */
> -       down_write(&cifsi->lock_sem);
> +       cifs_down_write(&cifsi->lock_sem);
>         list_for_each_entry_safe(li, tmp, &cifs_file->llist->locks, llist) {
>                 list_del(&li->llist);
>                 cifs_del_lock_waiters(li);
> @@ -1027,7 +1034,7 @@ static void
>  cifs_lock_add(struct cifsFileInfo *cfile, struct cifsLockInfo *lock)
>  {
>         struct cifsInodeInfo *cinode = CIFS_I(d_inode(cfile->dentry));
> -       down_write(&cinode->lock_sem);
> +       cifs_down_write(&cinode->lock_sem);
>         list_add_tail(&lock->llist, &cfile->llist->locks);
>         up_write(&cinode->lock_sem);
>  }
> @@ -1049,7 +1056,7 @@ cifs_lock_add_if(struct cifsFileInfo *cfile, struct cifsLockInfo *lock,
>
>  try_again:
>         exist = false;
> -       down_write(&cinode->lock_sem);
> +       cifs_down_write(&cinode->lock_sem);
>
>         exist = cifs_find_lock_conflict(cfile, lock->offset, lock->length,
>                                         lock->type, lock->flags, &conf_lock,
> @@ -1072,7 +1079,7 @@ cifs_lock_add_if(struct cifsFileInfo *cfile, struct cifsLockInfo *lock,
>                                         (lock->blist.next == &lock->blist));
>                 if (!rc)
>                         goto try_again;
> -               down_write(&cinode->lock_sem);
> +               cifs_down_write(&cinode->lock_sem);
>                 list_del_init(&lock->blist);
>         }
>
> @@ -1125,7 +1132,7 @@ cifs_posix_lock_set(struct file *file, struct file_lock *flock)
>                 return rc;
>
>  try_again:
> -       down_write(&cinode->lock_sem);
> +       cifs_down_write(&cinode->lock_sem);
>         if (!cinode->can_cache_brlcks) {
>                 up_write(&cinode->lock_sem);
>                 return rc;
> @@ -1331,7 +1338,7 @@ cifs_push_locks(struct cifsFileInfo *cfile)
>         int rc = 0;
>
>         /* we are going to update can_cache_brlcks here - need a write access */
> -       down_write(&cinode->lock_sem);
> +       cifs_down_write(&cinode->lock_sem);
>         if (!cinode->can_cache_brlcks) {
>                 up_write(&cinode->lock_sem);
>                 return rc;
> @@ -1522,7 +1529,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
>         if (!buf)
>                 return -ENOMEM;
>
> -       down_write(&cinode->lock_sem);
> +       cifs_down_write(&cinode->lock_sem);
>         for (i = 0; i < 2; i++) {
>                 cur = buf;
>                 num = 0;
> diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
> index e6a1fc72018f..8b0b512c5792 100644
> --- a/fs/cifs/smb2file.c
> +++ b/fs/cifs/smb2file.c
> @@ -145,7 +145,7 @@ smb2_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
>
>         cur = buf;
>
> -       down_write(&cinode->lock_sem);
> +       cifs_down_write(&cinode->lock_sem);
>         list_for_each_entry_safe(li, tmp, &cfile->llist->locks, llist) {
>                 if (flock->fl_start > li->offset ||
>                     (flock->fl_start + length) <
> --
> 2.13.6
>

Thanks for doing this!  Looks fine to me.

I'm not loving this approach to solve this problem but I understand
why it may be preferred right now.
I note that trylock with a sleep / retry loop is not often used in
filesystems that I could tell (though it is used in drivers), so maybe
this can be improved another day.
