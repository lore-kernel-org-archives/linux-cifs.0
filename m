Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 874C1CDB46E
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Oct 2023 17:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344100AbjJLRok (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Oct 2023 13:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344050AbjJLRoj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Oct 2023 13:44:39 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C875B8
        for <linux-cifs@vger.kernel.org>; Thu, 12 Oct 2023 10:44:37 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-50307acd445so1611760e87.0
        for <linux-cifs@vger.kernel.org>; Thu, 12 Oct 2023 10:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20230601.gappssmtp.com; s=20230601; t=1697132675; x=1697737475; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m+V/wcbz3KSgQETycpVjvDmzvT4kZIgUF1ZWc3j2OGw=;
        b=C0Ij6DqOHaWO3vBH612FJNj25+ioFELdjTBjVXUCRpGBZzO1sx9FttcVU5JOQMPMPe
         QxlW53HwwqAzg5VYMpKvEmOd1An1hQA+7dHYHnkGhu2VdUJ0Fjj0hN4td1Jl3VfFneMA
         Za1TnVlsC8TgUQpGd8M9zEo1H9zF/C0pyFq/dLPdMaXoKH3RoXBRqYvuReorG0SbzbN5
         ldObotzZGseFdrwqYtLmLJNpF7URzxU9BdjrNvykZdfBhAY69vNDPqPyefCwbF/5Jkmo
         diowzsbqaG77M5JPIzyzo0EkDtLu4FV/Y2QTh44GFJ8MYLo998uS6EkGKzh8OP9zAhjK
         7HRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697132675; x=1697737475;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m+V/wcbz3KSgQETycpVjvDmzvT4kZIgUF1ZWc3j2OGw=;
        b=ImmptPFaeEXCyrpiGwO+NlW1/Ka/9nyTZjF5N3QZn1t7SCm+VP8raCTjnzwRdUgM3s
         01icRrO9K+SvY75VMcajF1tZazj+PeXbQ5o+Ck+oZDidnuE+HBjcPOK7565tVAc9Bn8R
         XpzCcY2Vg0tFCx4qwXROfrhGLpHt5qbhceR2cbHNbrdKShxQ44izbNnms4LmQrRriO4Z
         6638k5uFmKT4ax4GnPJ8H7y05qx5/VqnvCXiaYEPgTBlHmMCJZcMAklOMViRc0FbF45g
         qhNeYCFJL4dmL/tD9hJWUc2szyUuX1wferjiWMwVbkUZTC2C/Y3sXVreQ7sIhOH85qTH
         9uhw==
X-Gm-Message-State: AOJu0YwxF+d2J4J7fEK2SGKZlzLYvZobqcuLoEudDtOrikOCgcgf9JHO
        p5CSI/exGseOfUWANA+wqYxB6WrRTt+10zD2WGw=
X-Google-Smtp-Source: AGHT+IHRzWJ6yotoJWOBzsjfZWeHXhcVDJLuSZKGwRtQZK2b4fFOrHXgGZLTefJfVR3DIc2iv+vw3w==
X-Received: by 2002:a05:6512:5ca:b0:4fa:5e76:7ad4 with SMTP id o10-20020a05651205ca00b004fa5e767ad4mr17820311lfo.10.1697132675378;
        Thu, 12 Oct 2023 10:44:35 -0700 (PDT)
Received: from marios-t5500.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id z14-20020ac25dee000000b004f755ceafbcsm2891176lfq.217.2023.10.12.10.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Oct 2023 10:44:35 -0700 (PDT)
From:   Marios Makassikis <mmakassikis@freebox.fr>
To:     linux-cifs@vger.kernel.org
Cc:     Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH] fs/smb: server: fix recursive locking in vfs helpers
Date:   Thu, 12 Oct 2023 19:43:50 +0200
Message-Id: <20231012174349.462290-1-mmakassikis@freebox.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Running smb2.rename test from Samba smbtorture suite against a kernel built
with lockdep triggers a "possible recursive locking detected" warning.

This is because mnt_want_write() is called twice with no mnt_drop_write()
in between:
  -> ksmbd_vfs_mkdir()
    -> ksmbd_vfs_kern_path_create()
       -> kern_path_create()
          -> filename_create()
            -> mnt_want_write()
       -> mnt_want_write()

Fix this by removing the mnt_want_write/mnt_drop_write calls from vfs
helpers that call kern_path_create().

Full lockdep trace below:

============================================
WARNING: possible recursive locking detected
6.6.0-rc5 #775 Not tainted
--------------------------------------------
kworker/1:1/32 is trying to acquire lock:
ffff888005ac83f8 (sb_writers#5){.+.+}-{0:0}, at: ksmbd_vfs_mkdir+0xe1/0x410

but task is already holding lock:
ffff888005ac83f8 (sb_writers#5){.+.+}-{0:0}, at: filename_create+0xb6/0x260

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(sb_writers#5);
  lock(sb_writers#5);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

4 locks held by kworker/1:1/32:
 #0: ffff8880064e4138 ((wq_completion)ksmbd-io){+.+.}-{0:0}, at: process_one_work+0x40e/0x980
 #1: ffff888005b0fdd0 ((work_completion)(&work->work)){+.+.}-{0:0}, at: process_one_work+0x40e/0x980
 #2: ffff888005ac83f8 (sb_writers#5){.+.+}-{0:0}, at: filename_create+0xb6/0x260
 #3: ffff8880057ce760 (&type->i_mutex_dir_key#3/1){+.+.}-{3:3}, at: filename_create+0x123/0x260

stack backtrace:
CPU: 1 PID: 32 Comm: kworker/1:1 Not tainted 6.6.0-rc5 #775
Workqueue: ksmbd-io handle_ksmbd_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x4f/0x90
 dump_stack+0x14/0x20
 print_deadlock_bug+0x2f0/0x410
 check_deadlock+0x26b/0x3b0
 __lock_acquire+0xce2/0x1060
 ? mark_lock.part.0+0xff/0x720
 ? __pfx___lock_acquire+0x10/0x10
 ? mark_held_locks+0x6b/0x90
 lock_acquire.part.0+0x125/0x2d0
 ? ksmbd_vfs_mkdir+0xe1/0x410
 ? __pfx_lock_acquire.part.0+0x10/0x10
 ? __kmem_cache_free+0x179/0x280
 ? ____kasan_slab_free+0x15b/0x1d0
 ? __kasan_slab_free+0x16/0x20
 ? slab_free_freelist_hook+0xbc/0x180
 lock_acquire+0x93/0x160
 ? ksmbd_vfs_mkdir+0xe1/0x410
 mnt_want_write+0x49/0x220
 ? ksmbd_vfs_mkdir+0xe1/0x410
 ksmbd_vfs_mkdir+0xe1/0x410
 ? __pfx__printk+0x10/0x10
 ? __pfx_ksmbd_vfs_mkdir+0x10/0x10
 smb2_open+0x1064/0x38b0
 ? __pfx___lock_acquire+0x10/0x10
 ? __pfx_smb2_open+0x10/0x10
 ? __lock_release+0x13f/0x290
 ? smb2_validate_credit_charge+0x25d/0x360
 ? __pfx___lock_release+0x10/0x10
 ? do_raw_spin_lock+0x127/0x1c0
 ? __pfx_do_raw_spin_lock+0x10/0x10
 ? do_raw_spin_unlock+0xac/0x110
 ? _raw_spin_unlock+0x22/0x50
 ? smb2_validate_credit_charge+0x25d/0x360
 ? ksmbd_smb2_check_message+0x3be/0x400
 ? __pfx_ksmbd_smb2_check_message+0x10/0x10
 __process_request+0x151/0x310
 __handle_ksmbd_work+0x33c/0x520
 ? __pfx___handle_ksmbd_work+0x10/0x10
 handle_ksmbd_work+0x4a/0xd0
 process_one_work+0x4a7/0x980
 ? __pfx_process_one_work+0x10/0x10
 ? assign_work+0xe1/0x120
 worker_thread+0x365/0x570
 ? __pfx_worker_thread+0x10/0x10
 kthread+0x18d/0x1d0
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x38/0x70
 ? __pfx_kthread+0x10/0x10
 ret_from_fork_asm+0x1b/0x30
 </TASK>

Fixes: 40b268d384a2 ("ksmbd: add mnt_want_write to ksmbd vfs functions")
Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
---
 fs/smb/server/vfs.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index b5a5e50fc9ca..ac49e295d4c3 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -173,10 +173,6 @@ int ksmbd_vfs_create(struct ksmbd_work *work, const char *name, umode_t mode)
 		return err;
 	}
 
-	err = mnt_want_write(path.mnt);
-	if (err)
-		goto out_err;
-
 	mode |= S_IFREG;
 	err = vfs_create(mnt_idmap(path.mnt), d_inode(path.dentry),
 			 dentry, mode, true);
@@ -186,9 +182,7 @@ int ksmbd_vfs_create(struct ksmbd_work *work, const char *name, umode_t mode)
 	} else {
 		pr_err("File(%s): creation failed (err:%d)\n", name, err);
 	}
-	mnt_drop_write(path.mnt);
 
-out_err:
 	done_path_create(&path, dentry);
 	return err;
 }
@@ -219,10 +213,6 @@ int ksmbd_vfs_mkdir(struct ksmbd_work *work, const char *name, umode_t mode)
 		return err;
 	}
 
-	err = mnt_want_write(path.mnt);
-	if (err)
-		goto out_err2;
-
 	idmap = mnt_idmap(path.mnt);
 	mode |= S_IFDIR;
 	err = vfs_mkdir(idmap, d_inode(path.dentry), dentry, mode);
@@ -246,8 +236,6 @@ int ksmbd_vfs_mkdir(struct ksmbd_work *work, const char *name, umode_t mode)
 	}
 
 out_err1:
-	mnt_drop_write(path.mnt);
-out_err2:
 	done_path_create(&path, dentry);
 	if (err)
 		pr_err("mkdir(%s): creation failed (err:%d)\n", name, err);
@@ -665,16 +653,11 @@ int ksmbd_vfs_link(struct ksmbd_work *work, const char *oldname,
 		goto out3;
 	}
 
-	err = mnt_want_write(newpath.mnt);
-	if (err)
-		goto out3;
-
 	err = vfs_link(oldpath.dentry, mnt_idmap(newpath.mnt),
 		       d_inode(newpath.dentry),
 		       dentry, NULL);
 	if (err)
 		ksmbd_debug(VFS, "vfs_link failed err %d\n", err);
-	mnt_drop_write(newpath.mnt);
 
 out3:
 	done_path_create(&newpath, dentry);
-- 
2.34.1

