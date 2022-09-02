Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D102C001B5
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Sep 2022 16:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbiIBQWO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 2 Sep 2022 12:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234554AbiIBQWM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 2 Sep 2022 12:22:12 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D9FBFEA1
        for <linux-cifs@vger.kernel.org>; Fri,  2 Sep 2022 09:22:11 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C46F434928;
        Fri,  2 Sep 2022 16:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1662135729; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=XU1Jiv9EGrUx+9JG+mV2gvFKKJX5F7BNZUsA1nYY0bw=;
        b=cinlv+0dIJOc+HPCSyAieJnX4XmBL2uWAavRJdXT1bxYEEcptyu7Ub7V5Jpj09r5p2R2EE
        crlE3ID4Ekb9apv6113zAIl0ywW7VM6XAHuLcodwpEu6U0BQdRI+Bz8bm5M2F6+YiI7rDB
        KKsA+m6fZThEO4uxO6xBAXGab9wlDz8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1662135729;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=XU1Jiv9EGrUx+9JG+mV2gvFKKJX5F7BNZUsA1nYY0bw=;
        b=ZngOLMBCAe6fABH9iHiFrZwSmZb3DUeAE8G732WXzsu+GwbDwtyUh+PveOSXGcEus/lsad
        yjIpoIgjGwUupPCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4860913328;
        Fri,  2 Sep 2022 16:22:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6ipeA7EtEmNtSQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Fri, 02 Sep 2022 16:22:09 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [PATCH] cifs: fix some build warnings in file.c and smbencrypt.c
Date:   Fri,  2 Sep 2022 13:21:55 -0300
Message-Id: <20220902162155.8310-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Variable server is already declared in the beginning of
_cifsFileInfo_put() and then again in the close case:

> fs/cifs/file.c: In function ‘_cifsFileInfo_put’:
> fs/cifs/file.c:537:41: error: declaration of ‘server’ shadows a previous local [-Werror=shadow]
>   537 |                 struct TCP_Server_Info *server = tcon->ses->server;
>       |                                         ^~~~~~
> fs/cifs/file.c:487:33: note: shadowed declaration is here
>   487 |         struct TCP_Server_Info *server = tcon->ses->server;

Remove that second declaration since it has the same value.

Also in cifs_setlk(), a struct cifsLockInfo is declared as "lock", same
name as the function parameter:

> fs/cifs/file.c:1815:38: error: declaration of ‘lock’ shadows a parameter [-Werror=shadow]
> 1815 |                 struct cifsLockInfo *lock;
>
> fs/cifs/file.c:1781:48: note: shadowed declaration is here
>  1781 |            bool wait_flag, bool posix_lck, int lock, int unlock,
>       |                                            ~~~~^~~~

Rename the struct to "lock_info", move its declaration to top of
function, and reverse the order of the lock/unlock checks, since in the
unlock case, it's a single line call, and we can goto out earlier. No
functional modifications though.

Also remove the defines in top of smbencrypt.c
(CVAL/SSVALX/SSVAL/true/false) since they're unused.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/file.c       | 72 +++++++++++++++++++++-----------------------
 fs/cifs/smbencrypt.c | 12 --------
 2 files changed, 34 insertions(+), 50 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index fa738adc031f..1af16d112967 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -534,7 +534,6 @@ void _cifsFileInfo_put(struct cifsFileInfo *cifs_file,
 		cancel_work_sync(&cifs_file->oplock_break) : false;
 
 	if (!tcon->need_reconnect && !cifs_file->invalidHandle) {
-		struct TCP_Server_Info *server = tcon->ses->server;
 		unsigned int xid;
 
 		xid = get_xid();
@@ -1787,6 +1786,7 @@ cifs_setlk(struct file *file, struct file_lock *flock, __u32 type,
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct inode *inode = d_inode(cfile->dentry);
+	struct cifsLockInfo *lock_info;
 
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 	if (posix_lck) {
@@ -1811,48 +1811,44 @@ cifs_setlk(struct file *file, struct file_lock *flock, __u32 type,
 		goto out;
 	}
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
-	if (lock) {
-		struct cifsLockInfo *lock;
-
-		lock = cifs_lock_init(flock->fl_start, length, type,
-				      flock->fl_flags);
-		if (!lock)
-			return -ENOMEM;
+	if (unlock) {
+		rc = server->ops->mand_unlock_range(cfile, flock, xid);
+		goto out;
+	}
 
-		rc = cifs_lock_add_if(cfile, lock, wait_flag);
-		if (rc < 0) {
-			kfree(lock);
-			return rc;
-		}
-		if (!rc)
-			goto out;
+	/* lock == true */
+	lock_info = cifs_lock_init(flock->fl_start, length, type, flock->fl_flags);
+	if (!lock_info)
+		return -ENOMEM;
 
-		/*
-		 * Windows 7 server can delay breaking lease from read to None
-		 * if we set a byte-range lock on a file - break it explicitly
-		 * before sending the lock to the server to be sure the next
-		 * read won't conflict with non-overlapted locks due to
-		 * pagereading.
-		 */
-		if (!CIFS_CACHE_WRITE(CIFS_I(inode)) &&
-					CIFS_CACHE_READ(CIFS_I(inode))) {
-			cifs_zap_mapping(inode);
-			cifs_dbg(FYI, "Set no oplock for inode=%p due to mand locks\n",
-				 inode);
-			CIFS_I(inode)->oplock = 0;
-		}
+	rc = cifs_lock_add_if(cfile, lock_info, wait_flag);
+	if (rc < 0) {
+		kfree(lock_info);
+		return rc;
+	}
+	if (!rc)
+		goto out;
 
-		rc = server->ops->mand_lock(xid, cfile, flock->fl_start, length,
-					    type, 1, 0, wait_flag);
-		if (rc) {
-			kfree(lock);
-			return rc;
-		}
+	/*
+	 * Windows 7 server can delay breaking lease from read to None
+	 * if we set a byte-range lock on a file - break it explicitly
+	 * before sending the lock to the server to be sure the next
+	 * read won't conflict with non-overlapted locks due to
+	 * pagereading.
+	 */
+	if (!CIFS_CACHE_WRITE(CIFS_I(inode)) && CIFS_CACHE_READ(CIFS_I(inode))) {
+		cifs_zap_mapping(inode);
+		cifs_dbg(FYI, "Set no oplock for inode=%p due to mand locks\n", inode);
+		CIFS_I(inode)->oplock = 0;
+	}
 
-		cifs_lock_add(cfile, lock);
-	} else if (unlock)
-		rc = server->ops->mand_unlock_range(cfile, flock, xid);
+	rc = server->ops->mand_lock(xid, cfile, flock->fl_start, length, type, 1, 0, wait_flag);
+	if (rc) {
+		kfree(lock_info);
+		return rc;
+	}
 
+	cifs_lock_add(cfile, lock_info);
 out:
 	if ((flock->fl_flags & FL_POSIX) || (flock->fl_flags & FL_FLOCK)) {
 		/*
diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index 4a0487753869..0214092d2714 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -26,18 +26,6 @@
 #include "cifsproto.h"
 #include "../smbfs_common/md4.h"
 
-#ifndef false
-#define false 0
-#endif
-#ifndef true
-#define true 1
-#endif
-
-/* following came from the other byteorder.h to avoid include conflicts */
-#define CVAL(buf,pos) (((unsigned char *)(buf))[pos])
-#define SSVALX(buf,pos,val) (CVAL(buf,pos)=(val)&0xFF,CVAL(buf,pos+1)=(val)>>8)
-#define SSVAL(buf,pos,val) SSVALX((buf),(pos),((__u16)(val)))
-
 /* produce a md4 message digest from data of length n bytes */
 static int
 mdfour(unsigned char *md4_hash, unsigned char *link_str, int link_len)
-- 
2.35.3

