Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01489C74A5B
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Mar 2023 19:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbjCWTFO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Mar 2023 15:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbjCWTFN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Mar 2023 15:05:13 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECDEE14216
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 12:05:12 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id bn14so5719162pgb.11
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 12:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679598312;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ACg+Z6I7+TvGUeT5hWZ3WZFwqVhJo9b/DSwM6tRWhmM=;
        b=pvHkuOE5tqR3RL8IiA4HtYNyD4XB4LgSI7yz62+vibbmBFX9m8tQSnw4UPQ0UsK89e
         yQknvimNimWFRrGN84dRQ6jL9CxkwhPGJOCS05+t+2fOjnVrl3y3t4Obiar0S7Pauhal
         W7ISx2PIXIp8NZLejb8zjqxYjhOPq2rxlAHFUNJvmX10B9VjXE+TtAfjA3Rle7TntPl9
         MIu5olEHQ5tPWXWG1tPRs9gNRIHiUrWv/PmFxyWERkLHeq0b5oA9pls2Uquadmr1EoWz
         t6YAt1S99r3w7qUzew3VgZFP8XooN2EI0dJKrELiIXIwB9KMtPwI+iwWDQ84Gx76SS6J
         059Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679598312;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ACg+Z6I7+TvGUeT5hWZ3WZFwqVhJo9b/DSwM6tRWhmM=;
        b=i3JnMFZsLxfpiswxqy5TliZUdIKkOXKvx+W8NTGXTBXp725EMOY6V4X9sUQGUhXLkl
         tY8E/+a3cZbNHt11RJ0DgXY+BBSmkswoBiFRtGpthO7qWmyNhXg2+tOA+L9C1QV+2lKT
         /w0PdmXPFIzy97yQnqcfzGPb3lif49AMzbGx2glloLYf+J70updnoUxHh3M6fRi66Cxx
         fc9X9FKbWG3SdxGi7aX0j6f4gSnUwSRfb+3mSokMShTldWM6FpbkAi304TxbmWMlLukW
         DofIkNJoMKxMhmrB8Cd1ZIRoRhqCJbkFxZgNENMOz6udg5gfpjbud3qYpyWbDAwlDuE7
         2+iw==
X-Gm-Message-State: AAQBX9fHb8ZgmGq9J9duEr8wpkvGfr597heH2ZbFCpwOZsljXfKBM1/e
        4cuAMddVwbdzQYzq6ghUCKjXAS3t6HWLVg==
X-Google-Smtp-Source: AKy350ZgxRqtbS/ek0jbfgGbFpbGtcPENrAgz6m9m6IvJG2zHkuXw+3nwfFNmQvUUJdqnmWKXV6opw==
X-Received: by 2002:a62:7905:0:b0:61d:f243:e817 with SMTP id u5-20020a627905000000b0061df243e817mr347935pfc.16.1679598312220;
        Thu, 23 Mar 2023 12:05:12 -0700 (PDT)
Received: from localhost.localdomain ([167.220.238.138])
        by smtp.googlemail.com with ESMTPSA id a14-20020a62e20e000000b00625d84a0194sm12377948pfi.107.2023.03.23.12.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 12:05:11 -0700 (PDT)
From:   bharathsm.hsk@gmail.com
To:     sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
        linux-cifs@vger.kernel.org
Subject: [PATCH] SMB3: Close deferred file handles if we get handle lease break
Date:   Thu, 23 Mar 2023 19:05:00 +0000
Message-Id: <20230323190500.1684832-1-bharathsm.hsk@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Bharath SM <bharathsm@microsoft.com>

We should not cache deferred file handles if we dont have
handle lease on a file. And we should immediately close all
deferred handles in case of handle lease break.

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
Fixes: 9e31678fb403 ("SMB3: fix lease break timeout when multiple deferred close handles for the same file.")
---
 fs/cifs/cifsproto.h |  3 ++-
 fs/cifs/file.c      | 21 +++++++++++++++++++++
 fs/cifs/misc.c      |  4 ++--
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index e2eff66eefab..d2819d449f05 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -278,7 +278,8 @@ extern void cifs_add_deferred_close(struct cifsFileInfo *cfile,
 
 extern void cifs_del_deferred_close(struct cifsFileInfo *cfile);
 
-extern void cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode);
+extern void cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode,
+				     bool wait_oplock_handler);
 
 extern void cifs_close_all_deferred_files(struct cifs_tcon *cifs_tcon);
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 4d4a2d82636d..ce75d8c1e3fe 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4884,6 +4884,9 @@ void cifs_oplock_break(struct work_struct *work)
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	struct TCP_Server_Info *server = tcon->ses->server;
+	bool is_deferred = false;
+	struct cifs_deferred_close *dclose;
+
 	int rc = 0;
 	bool purge_cache = false;
 
@@ -4921,6 +4924,23 @@ void cifs_oplock_break(struct work_struct *work)
 		cifs_dbg(VFS, "Push locks rc = %d\n", rc);
 
 oplock_break_ack:
+	/*
+	 * When oplock break is received and there are no active file handles
+	 * but cached file handles, then schedule deferred close immediately.
+	 * So, new open will not use cached handle.
+	 */
+	spin_lock(&CIFS_I(inode)->deferred_lock);
+	is_deferred = cifs_is_deferred_close(cfile, &dclose);
+	spin_unlock(&CIFS_I(inode)->deferred_lock);
+	if (!CIFS_CACHE_HANDLE(cinode) && is_deferred &&
+			cfile->deferred_close_scheduled && delayed_work_pending(&cfile->deferred)) {
+		if (cancel_delayed_work(&cfile->deferred)) {
+			_cifsFileInfo_put(cfile, false, false);
+			cifs_close_deferred_file(cinode, false);
+			goto oplock_break_done;
+		}
+	}
+
 	/*
 	 * releasing stale oplock after recent reconnect of smb session using
 	 * a now incorrect file handle is not a data integrity issue but do
@@ -4933,6 +4953,7 @@ void cifs_oplock_break(struct work_struct *work)
 		cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
 	}
 
+oplock_break_done:
 	_cifsFileInfo_put(cfile, false /* do not wait for ourself */, false);
 	cifs_done_oplock_break(cinode);
 }
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index a0d286ee723d..fd9d6b1ee1e2 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -728,7 +728,7 @@ cifs_del_deferred_close(struct cifsFileInfo *cfile)
 }
 
 void
-cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
+cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode, bool wait_oplock_handler)
 {
 	struct cifsFileInfo *cfile = NULL;
 	struct file_list *tmp_list, *tmp_next_list;
@@ -755,7 +755,7 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 	spin_unlock(&cifs_inode->open_file_lock);
 
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
-		_cifsFileInfo_put(tmp_list->cfile, true, false);
+		_cifsFileInfo_put(tmp_list->cfile, wait_oplock_handler, false);
 		list_del(&tmp_list->list);
 		kfree(tmp_list);
 	}
-- 
2.25.1

