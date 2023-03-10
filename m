Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A33BC6FD1F
	for <linux-cifs@archiver.kernel.org>; Fri, 10 Mar 2023 15:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbjCJPpB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 10 Mar 2023 10:45:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234457AbjCJPop (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 10 Mar 2023 10:44:45 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9115125DAD
        for <linux-cifs@vger.kernel.org>; Fri, 10 Mar 2023 07:32:50 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id qa18-20020a17090b4fd200b0023750b675f5so10211376pjb.3
        for <linux-cifs@vger.kernel.org>; Fri, 10 Mar 2023 07:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678462370;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gLhrp//XsD+C95FDg8T1gfm9S5ECm9FE3n839Gavxdk=;
        b=jpMzea76/WCNXSipgX5Z4PmSbmKuQg72V1pmeKM09ndEj0EmKnafyMdb2pXA1EbqYb
         DE+xzYnjcNl24krA7KlO7QDChObxbYIq8JPA0cxNmcM0cCFIKQD/gYegTrPoWzdZQiGx
         L0Dy6OtPNn66/Xz+mcAHsM/DZssbHVH/UhkRHLM6Jk/uxXNX9OFtsBdpVUwQGOR7vZkX
         RQfjL744Lw8gD8ny6BiFkP7xDPGRnQC3q0DV0qMu5FFTRNCrWdDz/qAIhJYZ8gqxOuZg
         g1j7xNPAY5sphRR4GzOOGnXak/ey0DeKxifTBvOpwvQFV2c+as0nyeG3IGBsKOSABEZq
         gEPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678462370;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gLhrp//XsD+C95FDg8T1gfm9S5ECm9FE3n839Gavxdk=;
        b=Pz7OANd55Y2a77+8zxCPz5kgA+A0yG7boDdmFTMXjduk48uu+uHnNCm3LHZEUfZsbp
         IGHGK4xbHAqMN4peuUeEWCvRZD7caJa+14ZemnEoy0tjcJiP5fBrWXCOpkJn0Uf2qhgZ
         dCBDgY4xJ8y/+RD1ZNJ3ln1pGc0eN3uekg4xqSiuQ+bN7AaDXaSGOXLF8ddkRgp/VW0r
         WroobjJWofzXpn4P9KSHrjgW8u8wQ9lcs2GxjMi47JM9sFAQvmn+/7wqAeloZGMqByE2
         Zk0sfMpBUXCxgFV8SNPunT3zWUBwN5TszJkaYbrO0QeBFQZCyJWsSehbX6laSh0FCB6I
         OsLg==
X-Gm-Message-State: AO0yUKXTcoVGNci+ZSQVxqKtqyeFu5QO+Uqucv8qR7FTJINDcqddO03e
        7hXpkTgHdF2dwFmuIUnKjXRSVF0apTQ7qvD5
X-Google-Smtp-Source: AK7set9H/eCEG0mvoUuQpcjgPJ7byVAtuQ5YkoWc5rILCMrXrjuHWghdpB4B0Oc9ZkIrmTATAPVPKA==
X-Received: by 2002:a17:90a:e7c7:b0:237:7891:1ea4 with SMTP id kb7-20020a17090ae7c700b0023778911ea4mr26730454pjb.18.1678462369831;
        Fri, 10 Mar 2023 07:32:49 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id h7-20020a17090a604700b00230b8402760sm71637pjm.38.2023.03.10.07.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 07:32:49 -0800 (PST)
From:   Shyam Prasad N <nspmangalore@gmail.com>
X-Google-Original-From: Shyam Prasad N <sprasad@microsoft.com>
To:     smfrench@gmail.com, bharathsm.hsk@gmail.com, pc@cjr.nz,
        tom@talpey.com, linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 01/11] cifs: fix tcon status change after tree connect
Date:   Fri, 10 Mar 2023 15:32:00 +0000
Message-Id: <20230310153211.10982-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

After cifs_tree_connect, tcon status should not be
set to TID_GOOD. There could still be files that need
reopen. The status should instead be changed to
TID_NEED_FILES_INVALIDATE. That way, after reopen of
files, the status can be changed to TID_GOOD.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/cifs/cifsglob.h |  2 +-
 fs/cifs/connect.c  | 14 ++++++++++----
 fs/cifs/dfs.c      | 16 +++++++++++-----
 fs/cifs/file.c     | 10 +++++-----
 4 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a99883f16d94..8a37b1553dc6 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -137,7 +137,7 @@ enum tid_status_enum {
 	TID_NEED_RECON,
 	TID_NEED_TCON,
 	TID_IN_TCON,
-	TID_NEED_FILES_INVALIDATE, /* currently unused */
+	TID_NEED_FILES_INVALIDATE,
 	TID_IN_FILES_INVALIDATE
 };
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5233f14f0636..3d07729c91a1 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4038,9 +4038,15 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 
 	/* only send once per connect */
 	spin_lock(&tcon->tc_lock);
-	if (tcon->ses->ses_status != SES_GOOD ||
-	    (tcon->status != TID_NEW &&
-	    tcon->status != TID_NEED_TCON)) {
+	if (tcon->status != TID_GOOD &&
+	    tcon->status != TID_NEW &&
+	    tcon->status != TID_NEED_RECON) {
+		spin_unlock(&tcon->tc_lock);
+		return -EHOSTDOWN;
+	}
+
+	if (tcon->status == TID_NEED_FILES_INVALIDATE ||
+	    tcon->status == TID_GOOD) {
 		spin_unlock(&tcon->tc_lock);
 		return 0;
 	}
@@ -4051,7 +4057,7 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 	if (rc) {
 		spin_lock(&tcon->tc_lock);
 		if (tcon->status == TID_IN_TCON)
-			tcon->status = TID_NEED_TCON;
+			tcon->status = TID_NEED_RECON;
 		spin_unlock(&tcon->tc_lock);
 	} else {
 		spin_lock(&tcon->tc_lock);
diff --git a/fs/cifs/dfs.c b/fs/cifs/dfs.c
index b64d20374b9c..d37af02902c5 100644
--- a/fs/cifs/dfs.c
+++ b/fs/cifs/dfs.c
@@ -479,9 +479,15 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 
 	/* only send once per connect */
 	spin_lock(&tcon->tc_lock);
-	if (tcon->ses->ses_status != SES_GOOD ||
-	    (tcon->status != TID_NEW &&
-	    tcon->status != TID_NEED_TCON)) {
+	if (tcon->status != TID_GOOD &&
+	    tcon->status != TID_NEW &&
+	    tcon->status != TID_NEED_RECON) {
+		spin_unlock(&tcon->tc_lock);
+		return -EHOSTDOWN;
+	}
+
+	if (tcon->status == TID_NEED_FILES_INVALIDATE ||
+	    tcon->status == TID_GOOD) {
 		spin_unlock(&tcon->tc_lock);
 		return 0;
 	}
@@ -529,12 +535,12 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 	if (rc) {
 		spin_lock(&tcon->tc_lock);
 		if (tcon->status == TID_IN_TCON)
-			tcon->status = TID_NEED_TCON;
+			tcon->status = TID_NEED_RECON;
 		spin_unlock(&tcon->tc_lock);
 	} else {
 		spin_lock(&tcon->tc_lock);
 		if (tcon->status == TID_IN_TCON)
-			tcon->status = TID_GOOD;
+			tcon->status = TID_NEED_FILES_INVALIDATE;
 		spin_unlock(&tcon->tc_lock);
 		tcon->need_reconnect = false;
 	}
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 4d4a2d82636d..96d865e108f4 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -174,13 +174,13 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
 	struct list_head *tmp1;
 
 	/* only send once per connect */
-	spin_lock(&tcon->ses->ses_lock);
-	if ((tcon->ses->ses_status != SES_GOOD) || (tcon->status != TID_NEED_RECON)) {
-		spin_unlock(&tcon->ses->ses_lock);
+	spin_lock(&tcon->tc_lock);
+	if (tcon->status != TID_NEED_FILES_INVALIDATE) {
+		spin_unlock(&tcon->tc_lock);
 		return;
 	}
 	tcon->status = TID_IN_FILES_INVALIDATE;
-	spin_unlock(&tcon->ses->ses_lock);
+	spin_unlock(&tcon->tc_lock);
 
 	/* list all files open on tree connection and mark them invalid */
 	spin_lock(&tcon->open_file_lock);
@@ -194,7 +194,7 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
 	invalidate_all_cached_dirs(tcon);
 	spin_lock(&tcon->tc_lock);
 	if (tcon->status == TID_IN_FILES_INVALIDATE)
-		tcon->status = TID_NEED_TCON;
+		tcon->status = TID_GOOD;
 	spin_unlock(&tcon->tc_lock);
 
 	/*
-- 
2.34.1

