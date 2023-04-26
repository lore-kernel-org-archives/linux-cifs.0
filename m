Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CDDEC7618E
	for <linux-cifs@archiver.kernel.org>; Wed, 26 Apr 2023 14:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240825AbjDZOGL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 26 Apr 2023 10:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240627AbjDZOGK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 26 Apr 2023 10:06:10 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94996659D
        for <linux-cifs@vger.kernel.org>; Wed, 26 Apr 2023 07:06:06 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id 3f1490d57ef6-b97ec4bbc5aso5516672276.3
        for <linux-cifs@vger.kernel.org>; Wed, 26 Apr 2023 07:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682517966; x=1685109966;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xPS5kexiaFbJshNQNUa0Oz7qqUt1ipO601YkKT9L3lA=;
        b=M8Q2OmfJURtrrD1snNZQEqf0MWs3I3NfLuY0A+Gu/cadJS9gduwjTbOR6TC4AnK8xF
         pkKlaObWxJQKhfonkKaCz/OdbKUu/YHlsV1nr4/4RdLHjNgiV0KJyBVUc09cB35lW9Rl
         i3xiQfbQqMzwS1aBfn4vmmOAp3ngFfXoKhNu70m4RSQpVqbhnv79IbirsqjXT8Hiq1pu
         YcqwOZWGC0r1PNE7zF6d5qUdnno2MONeBkC3eT1X9MGGqC+svIKkalq9b0BHv0oe9yLx
         f0/RYAVJu9/hY4bkwCKQLOgOPTiywLMd7HzSaofwkO8XCuVznU2p38qPTdvxXZWuX1Wl
         Vj3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682517966; x=1685109966;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xPS5kexiaFbJshNQNUa0Oz7qqUt1ipO601YkKT9L3lA=;
        b=Fn/QarTAwSn+yzhUqVz74ziWqeZjsO5+elmFVPQNTnVeBCPkev6wOE/4xdup32+Pps
         NKX/ApzcHO+RmVYnh1bK9X68m3Z/x4dXZVimDqbFpY03fhJQZkPSBpU1ywJHM9C+kjxS
         JQgZ4QEXfmwRP7O6DkLP6P3rpLdJLnfWLO65fNdshCmr52oCSmPl78QdpP/B/lGgjTWi
         j2lTJxRCew8+og35hWuyQb6/waQQcNcX5uU5iDNnjRT+qz/33gdurvWbZoGkhuUOgjjq
         gpuENIvS/XAWvLhsJB4EuPb+8ofXoT3vianOQ2RFErN92S6knXcu8YDZZbFcNQTIObel
         7z1g==
X-Gm-Message-State: AAQBX9cikReKDG/fuP4TqKzkOXmKElTbTFUfSprjg167m+wCyAW36SSR
        uaA2/nTp8n4iirv5/AxG6mk=
X-Google-Smtp-Source: AKy350bwxPwVLKyuWhlKFvkzO9GTsq+pxVIrXieT+7qwqZr6G48/ksF1k2SBsWAYbAYAibnLat1EDg==
X-Received: by 2002:a05:7500:1d89:b0:fc:e0fc:178c with SMTP id dv9-20020a0575001d8900b000fce0fc178cmr487659gab.46.1682517965218;
        Wed, 26 Apr 2023 07:06:05 -0700 (PDT)
Received: from ubuntu2004.1qqixozwsnuevircicbvxjrsib.bx.internal.cloudapp.net ([20.84.44.103])
        by smtp.googlemail.com with ESMTPSA id br40-20020a05620a462800b007435a646354sm5142963qkb.0.2023.04.26.07.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 07:06:04 -0700 (PDT)
From:   Bharath SM <bharathsm.hsk@gmail.com>
To:     pc@cjr.nz, sfrench@samba.org, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org
Cc:     Bharath SM <bharathsm.hsk@gmail.com>,
        Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH] SMB3: Close deferred file handles in case of handle lease break
Date:   Wed, 26 Apr 2023 14:05:16 +0000
Message-Id: <20230426140516.12532-1-bharathsm.hsk@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We should not cache deferred file handles if we dont have
handle lease on a file. And we should immediately close all
deferred handles in case of handle lease break.

Fixes: 9e31678fb403 ("SMB3: fix lease break timeout when multiple deferred close handles for the same file.")
Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/cifs/file.c | 16 ++++++++++++++++
 fs/cifs/misc.c |  2 +-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 4d4a2d82636d..791a12575109 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4886,6 +4886,8 @@ void cifs_oplock_break(struct work_struct *work)
 	struct TCP_Server_Info *server = tcon->ses->server;
 	int rc = 0;
 	bool purge_cache = false;
+	struct cifs_deferred_close *dclose;
+	bool is_deferred = false;
 
 	wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
 			TASK_UNINTERRUPTIBLE);
@@ -4921,6 +4923,20 @@ void cifs_oplock_break(struct work_struct *work)
 		cifs_dbg(VFS, "Push locks rc = %d\n", rc);
 
 oplock_break_ack:
+	/*
+	 * When oplock break is received and there are no active
+	 * file handles but cached, then schedule deferred close immediately.
+	 * So, new open will not use cached handle.
+	 */
+	spin_lock(&CIFS_I(inode)->deferred_lock);
+	is_deferred = cifs_is_deferred_close(cfile, &dclose);
+	spin_unlock(&CIFS_I(inode)->deferred_lock);
+
+	if (!CIFS_CACHE_HANDLE(cinode) && is_deferred &&
+			cfile->deferred_close_scheduled && delayed_work_pending(&cfile->deferred)) {
+		cifs_close_deferred_file(cinode);
+	}
+
 	/*
 	 * releasing stale oplock after recent reconnect of smb session using
 	 * a now incorrect file handle is not a data integrity issue but do
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 5f874e9c1554..0cfb46d7773c 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -757,7 +757,7 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 	spin_unlock(&cifs_inode->open_file_lock);
 
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
-		_cifsFileInfo_put(tmp_list->cfile, true, false);
+		_cifsFileInfo_put(tmp_list->cfile, false, false);
 		list_del(&tmp_list->list);
 		kfree(tmp_list);
 	}
-- 
2.34.1

