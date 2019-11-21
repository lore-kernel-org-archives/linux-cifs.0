Return-Path: <SRS0=LLm2=ZN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BFEDC432C3
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Nov 2019 19:35:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EEA32068F
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Nov 2019 19:35:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J2DV5nPO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfKUTfV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Nov 2019 14:35:21 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44987 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfKUTfV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Nov 2019 14:35:21 -0500
Received: by mail-pg1-f196.google.com with SMTP id e6so2105787pgi.11
        for <linux-cifs@vger.kernel.org>; Thu, 21 Nov 2019 11:35:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=h9W6RxF7x1shdmxCUUG6hVBc35iudolC+xIcbEzFS1Q=;
        b=J2DV5nPO3g8m2NO0UiF54VtILEqGu+0hsJ9SHoE7cRt+e77jSbVmOSn05tLBszPUQH
         g0b1iS5V3EM3rYanOQd5kEy130ggKZiRygMHA3+WwX7i8KKMTd0Znw5qOJILpgs9VbJz
         f+f8kHShNgJe0vCfavQYM2pcY6YuuBOi5ZgnFxTzzxFUUVzbTPNCitydeoHoA79Z4RMb
         UYvXFF3GlA98adwtjt2aFiRELN7v5GEag1dYyOvGtIQ7mb0JhWjuK37kV839/Pii+f3l
         /mfnDeWOYrbjWW79gXd0dicLAnaTXEm/gRMgEssL1DV1Ighvc5SzbUjtg1rA5Ddn2YHG
         xcgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=h9W6RxF7x1shdmxCUUG6hVBc35iudolC+xIcbEzFS1Q=;
        b=rn8PgqxoBLsyrFO4RWlddN/gpNF+Cq/30uy8yWL31TKKDqlq7gepny1ra1DhY6ALS3
         ajy6XDyuxptwUwBhzh1brZ5KS1rtvreaqkvJqzu56jhakrRdHWrZUJgQKwXgarT5aeFC
         yzhBRLGC8bU0Td4RRZZd9WrdjHYamQRUCpF/OxTzQNR3xmP7nAgduhpqVaYQWnX/BUEE
         D/B7gCNpVJPFVjNwNlZCzbl3wS1XyWrFwFS7eAbXxxDXyRA3eZVG1qD5HfxhwBWhh5/j
         EGL0Ifkz5ERWTL4eJoyd9S8PgRkpZYx1ha/aFsCZQT4y5Rnwp3N4CRT7kxL86cMZ0U/1
         beyw==
X-Gm-Message-State: APjAAAWweeKTC0BXIbHXCnp4hHbCeLQEZJQwpyT0TT/WbrwpiGyc0F0V
        5wgFsQUZDsWiM20lmgJHQw==
X-Google-Smtp-Source: APXvYqxPxecy82FWJbcGAKM3RjqgTpW+W7Hl3M3xtySr3arVF4Q91gF66ZL5QS94PJJvZnUdZIowxw==
X-Received: by 2002:a65:60c7:: with SMTP id r7mr11364486pgv.420.1574364920606;
        Thu, 21 Nov 2019 11:35:20 -0800 (PST)
Received: from ubuntu-vm.mshome.net ([167.220.2.106])
        by smtp.gmail.com with ESMTPSA id h185sm3972216pgc.87.2019.11.21.11.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 11:35:19 -0800 (PST)
From:   Pavel Shilovsky <piastryyy@gmail.com>
X-Google-Original-From: Pavel Shilovsky <pshilov@microsoft.com>
To:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Frank Sorenson <sorenson@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: [PATCH 1/3] CIFS: Close open handle after interrupted close
Date:   Thu, 21 Nov 2019 11:35:12 -0800
Message-Id: <20191121193514.3086-1-pshilov@microsoft.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If Close command is interrupted before sending a request
to the server the client ends up leaking an open file
handle. This wastes server resources and can potentially
block applications that try to remove the file or any
directory containing this file.

Fix this by putting the close command into a worker queue,
so another thread retries it later.

Cc: Stable <stable@vger.kernel.org>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
---
 fs/cifs/smb2misc.c  | 59 ++++++++++++++++++++++++++++++++++-----------
 fs/cifs/smb2pdu.c   | 16 +++++++++++-
 fs/cifs/smb2proto.h |  3 +++
 3 files changed, 63 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 527c9efd3de0..80a8f4b2daab 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -725,36 +725,67 @@ smb2_cancelled_close_fid(struct work_struct *work)
 	kfree(cancelled);
 }
 
+/* Caller should already has an extra reference to @tcon */
+static int
+__smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
+			      __u64 volatile_fid)
+{
+	struct close_cancelled_open *cancelled;
+
+	cancelled = kzalloc(sizeof(*cancelled), GFP_KERNEL);
+	if (!cancelled)
+		return -ENOMEM;
+
+	cancelled->fid.persistent_fid = persistent_fid;
+	cancelled->fid.volatile_fid = volatile_fid;
+	cancelled->tcon = tcon;
+	INIT_WORK(&cancelled->work, smb2_cancelled_close_fid);
+	WARN_ON(queue_work(cifsiod_wq, &cancelled->work) == false);
+
+	return 0;
+}
+
+int
+smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
+			    __u64 volatile_fid)
+{
+	int rc;
+
+	cifs_dbg(FYI, "%s: tc_count=%d\n", __func__, tcon->tc_count);
+	spin_lock(&cifs_tcp_ses_lock);
+	tcon->tc_count++;
+	spin_unlock(&cifs_tcp_ses_lock);
+
+	rc = __smb2_handle_cancelled_close(tcon, persistent_fid, volatile_fid);
+	if (rc)
+		cifs_put_tcon(tcon);
+
+	return rc;
+}
+
 int
 smb2_handle_cancelled_mid(char *buffer, struct TCP_Server_Info *server)
 {
 	struct smb2_sync_hdr *sync_hdr = (struct smb2_sync_hdr *)buffer;
 	struct smb2_create_rsp *rsp = (struct smb2_create_rsp *)buffer;
 	struct cifs_tcon *tcon;
-	struct close_cancelled_open *cancelled;
+	int rc;
 
 	if (sync_hdr->Command != SMB2_CREATE ||
 	    sync_hdr->Status != STATUS_SUCCESS)
 		return 0;
 
-	cancelled = kzalloc(sizeof(*cancelled), GFP_KERNEL);
-	if (!cancelled)
-		return -ENOMEM;
-
 	tcon = smb2_find_smb_tcon(server, sync_hdr->SessionId,
 				  sync_hdr->TreeId);
-	if (!tcon) {
-		kfree(cancelled);
+	if (!tcon)
 		return -ENOENT;
-	}
 
-	cancelled->fid.persistent_fid = rsp->PersistentFileId;
-	cancelled->fid.volatile_fid = rsp->VolatileFileId;
-	cancelled->tcon = tcon;
-	INIT_WORK(&cancelled->work, smb2_cancelled_close_fid);
-	queue_work(cifsiod_wq, &cancelled->work);
+	rc = __smb2_handle_cancelled_close(tcon, rsp->PersistentFileId,
+					   rsp->VolatileFileId);
+	if (rc)
+		cifs_put_tcon(tcon);
 
-	return 0;
+	return rc;
 }
 
 /**
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 0aa40129dfb5..2f541e9efba1 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2942,7 +2942,21 @@ int
 SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 	   u64 persistent_fid, u64 volatile_fid)
 {
-	return SMB2_close_flags(xid, tcon, persistent_fid, volatile_fid, 0);
+	int rc;
+	int tmp_rc;
+
+	rc = SMB2_close_flags(xid, tcon, persistent_fid, volatile_fid, 0);
+
+	/* retry close in a worker thread if this one is interrupted */
+	if (rc == -EINTR) {
+		tmp_rc = smb2_handle_cancelled_close(tcon, persistent_fid,
+						     volatile_fid);
+		if (tmp_rc)
+			cifs_dbg(VFS, "handle cancelled close fid 0x%llx returned error %d\n",
+				 persistent_fid, tmp_rc);
+	}
+
+	return rc;
 }
 
 int
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 07ca72486cfa..e239f98093a9 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -203,6 +203,9 @@ extern int SMB2_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
 extern int SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 			     const u64 persistent_fid, const u64 volatile_fid,
 			     const __u8 oplock_level);
+extern int smb2_handle_cancelled_close(struct cifs_tcon *tcon,
+				       __u64 persistent_fid,
+				       __u64 volatile_fid);
 extern int smb2_handle_cancelled_mid(char *buffer,
 					struct TCP_Server_Info *server);
 void smb2_cancelled_close_fid(struct work_struct *work);
-- 
2.17.1

