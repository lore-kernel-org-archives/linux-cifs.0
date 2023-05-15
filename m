Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05462C77B7D
	for <linux-cifs@archiver.kernel.org>; Mon, 15 May 2023 21:27:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245561AbjEOV1G (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 15 May 2023 17:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245501AbjEOV1A (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 15 May 2023 17:27:00 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B0E13C18
        for <linux-cifs@vger.kernel.org>; Mon, 15 May 2023 14:26:34 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id af79cd13be357-75773a7bd66so1021800385a.1
        for <linux-cifs@vger.kernel.org>; Mon, 15 May 2023 14:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684185993; x=1686777993;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XJIy+gKpleVhui/GdnvuJ4ylTzic+zNhaKi23bM/TGg=;
        b=prFTaDHxSFzH0Sup2CAgTsdfFteNwFxCLVY2SYoDGWYDYdUg4m2Wv7uanG4OBpqmet
         /x9GH4ZGxMyUUPo2EAnTJm8yH+A9/k5byxjruyDd9yBL2OxHo/4YyxkpRffV1QYyb8fo
         rqvPkOj1NRT/IOADzl8NVgAiZCxKID7yKM4ZaVDPFTQyDXHzisPPZ9IP/PdLZzxCxKcN
         6Eu4HIAR+CeRcmvnatsL5wfvI+2kjWg2ZcwRHUblF2aK32GdO4T3Mu9Cu2QYW7wM7bzU
         xrIP+FfHxSbwrvPQRMV4iIre9zeSqONf0w9tY6rorEVavJFrFheLi3Dml+ix5Gid+iNy
         pI+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684185993; x=1686777993;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XJIy+gKpleVhui/GdnvuJ4ylTzic+zNhaKi23bM/TGg=;
        b=Leh7Nd2u4evdr4BYEILBHL94kTo9hQSwXaPMQ5xyO802jC6naORt4lsqKzw7MNBzZG
         cKo9n5PdK6rYVrqgq05yn8xh9RBDdWyMvVzUZw9dATQLjbLppRYYMSv/WjJov7N8JkJO
         mgvOEdR0+ru7AmPCawkvEr81yPQCGhHhiwheBCt02QQMxNug/JNG4dEhBrxgitaMfpz/
         Ho61vJ3/WI3hn17VC1k++XWsqlQnz1BFIuKxulf+42nYqdaXwvRbmGIWSiCWU25I6Xyw
         QPr2JygstDsansfMit2G8c+l9R3sOc+Py/YZH04+qNp+MTHHU98POBbdsz7BoAK3EETC
         0Qrg==
X-Gm-Message-State: AC+VfDzEcLPqMFZ1BdPUpFTVPLlz1M9W7Ky47wSMh0yE79tS/ig581Xx
        XeJn/zuXr5pzw+MYBpY0hPt0aTuZi4Ai6g==
X-Google-Smtp-Source: ACHHUZ4Fm4V/hv2XzSZR9oCU/gGKZB7n61WUSO5RTAbVVRm4MUETTmO96PNPTPVdRS0zY+ta84umCw==
X-Received: by 2002:a05:622a:24b:b0:3f4:f210:959b with SMTP id c11-20020a05622a024b00b003f4f210959bmr24115928qtx.12.1684185992972;
        Mon, 15 May 2023 14:26:32 -0700 (PDT)
Received: from ubuntu2004.1qqixozwsnuevircicbvxjrsib.bx.internal.cloudapp.net ([20.84.44.103])
        by smtp.googlemail.com with ESMTPSA id ff14-20020a05622a4d8e00b003ef3e8f8823sm5378599qtb.89.2023.05.15.14.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 14:26:32 -0700 (PDT)
From:   Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To:     pc@cjr.nz, sfrench@samba.org, lsahlber@redhat.com,
        nspmangalore@gmail.com, tom@talpey.com, linux-cifs@vger.kernel.org,
        smfrench@gmail.com
Cc:     Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH] SMB3: drop reference to cfile before sending oplock break
Date:   Mon, 15 May 2023 21:25:12 +0000
Message-Id: <20230515212512.1402756-1-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In cifs_oplock_break function we drop reference to a cfile at
the end of function, due to which close command goes on wire
after lease break acknowledgment even if file is already closed
by application but we had deferred the handle close.
If other client with limited file shareaccess waiting on lease
break ack proceeds operation on that file as soon as first client
sends ack, then we may encounter status sharing violation error
because of open handle.
Solution is to put reference to cfile(send close on wire if last ref)
and then send oplock acknowledgment to server.

Fixes: 9e31678fb403 ("SMB3: fix lease break timeout when multiple deferred close handles for the same file.")
Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/cifs/cifsglob.h |  4 ++--
 fs/cifs/file.c     | 17 ++++++++++++-----
 fs/cifs/smb1ops.c  |  9 ++++-----
 fs/cifs/smb2ops.c  |  7 +++----
 4 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a99883f16d94..2b8f9d335ad7 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -424,8 +424,8 @@ struct smb_version_operations {
 	/* check for STATUS_NETWORK_SESSION_EXPIRED */
 	bool (*is_session_expired)(char *);
 	/* send oplock break response */
-	int (*oplock_response)(struct cifs_tcon *, struct cifs_fid *,
-			       struct cifsInodeInfo *);
+	int (*oplock_response)(struct cifs_tcon *, __u64, __u64, __u16,
+			struct cifsInodeInfo *);
 	/* query remote filesystem */
 	int (*queryfs)(const unsigned int, struct cifs_tcon *,
 		       struct cifs_sb_info *, struct kstatfs *);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 260d5ec878e8..8b6414824e8e 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4885,7 +4885,9 @@ void cifs_oplock_break(struct work_struct *work)
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	struct TCP_Server_Info *server = tcon->ses->server;
 	int rc = 0;
-	bool purge_cache = false;
+	bool purge_cache = false, oplock_break_cancelled;
+	__u64 persistent_fid, volatile_fid;
+	__u16 net_fid;
 
 	wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
 			TASK_UNINTERRUPTIBLE);
@@ -4930,19 +4932,24 @@ void cifs_oplock_break(struct work_struct *work)
 	if (!CIFS_CACHE_HANDLE(cinode) && !list_empty(&cinode->deferred_closes))
 		cifs_close_deferred_file(cinode);
 
+	persistent_fid = cfile->fid.persistent_fid;
+	volatile_fid = cfile->fid.volatile_fid;
+	net_fid = cfile->fid.netfid;
+	oplock_break_cancelled = cfile->oplock_break_cancelled;
+
+	_cifsFileInfo_put(cfile, false /* do not wait for ourself */, false);
 	/*
 	 * releasing stale oplock after recent reconnect of smb session using
 	 * a now incorrect file handle is not a data integrity issue but do
 	 * not bother sending an oplock release if session to server still is
 	 * disconnected since oplock already released by the server
 	 */
-	if (!cfile->oplock_break_cancelled) {
-		rc = tcon->ses->server->ops->oplock_response(tcon, &cfile->fid,
-							     cinode);
+	if (!oplock_break_cancelled) {
+		rc = tcon->ses->server->ops->oplock_response(tcon, persistent_fid,
+				volatile_fid, net_fid, cinode);
 		cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
 	}
 
-	_cifsFileInfo_put(cfile, false /* do not wait for ourself */, false);
 	cifs_done_oplock_break(cinode);
 }
 
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index abda6148be10..7d1b3fc014d9 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -897,12 +897,11 @@ cifs_close_dir(const unsigned int xid, struct cifs_tcon *tcon,
 }
 
 static int
-cifs_oplock_response(struct cifs_tcon *tcon, struct cifs_fid *fid,
-		     struct cifsInodeInfo *cinode)
+cifs_oplock_response(struct cifs_tcon *tcon, __u64 persistent_fid,
+		__u64 volatile_fid, __u16 net_fid, struct cifsInodeInfo *cinode)
 {
-	return CIFSSMBLock(0, tcon, fid->netfid, current->tgid, 0, 0, 0, 0,
-			   LOCKING_ANDX_OPLOCK_RELEASE, false,
-			   CIFS_CACHE_READ(cinode) ? 1 : 0);
+	return CIFSSMBLock(0, tcon, net_fid, current->tgid, 0, 0, 0, 0,
+			   LOCKING_ANDX_OPLOCK_RELEASE, false, CIFS_CACHE_READ(cinode) ? 1 : 0);
 }
 
 static int
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 6dfb865ee9d7..bbae7a77fbec 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2363,15 +2363,14 @@ smb2_is_network_name_deleted(char *buf, struct TCP_Server_Info *server)
 }
 
 static int
-smb2_oplock_response(struct cifs_tcon *tcon, struct cifs_fid *fid,
-		     struct cifsInodeInfo *cinode)
+smb2_oplock_response(struct cifs_tcon *tcon, __u64 persistent_fid,
+		__u64 volatile_fid, __u16 net_fid, struct cifsInodeInfo *cinode)
 {
 	if (tcon->ses->server->capabilities & SMB2_GLOBAL_CAP_LEASING)
 		return SMB2_lease_break(0, tcon, cinode->lease_key,
 					smb2_get_lease_state(cinode));
 
-	return SMB2_oplock_break(0, tcon, fid->persistent_fid,
-				 fid->volatile_fid,
+	return SMB2_oplock_break(0, tcon, persistent_fid, volatile_fid,
 				 CIFS_CACHE_READ(cinode) ? 1 : 0);
 }
 
-- 
2.34.1

