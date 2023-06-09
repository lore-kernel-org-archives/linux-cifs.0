Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FEE6C7EE2E
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Jun 2023 17:47:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjFIRrj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Jun 2023 13:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjFIRrj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Jun 2023 13:47:39 -0400
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873B3DD
        for <linux-cifs@vger.kernel.org>; Fri,  9 Jun 2023 10:47:38 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id 006d021491bc7-55af55a0fdaso1363326eaf.2
        for <linux-cifs@vger.kernel.org>; Fri, 09 Jun 2023 10:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686332857; x=1688924857;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZFu/lUEM6FUe1loWdD2nYcG4AZ+lX44UcYWbi69QQe4=;
        b=TFsQAqU1UQUsTAQ0XF1gI8k9Sk5X4UVkwQUOAlJYaZ4pc5wLY/lx7xrFtPNRHnoEBj
         pKHFhgyyBHKQH+ifGh5Pb/UQ1lDLmNVrZZupGkskLpmSPZLGnGnZ5q1129OIUz/aysiZ
         Ye/6ToE8L8Gax9UA3A02kGz/U/ugeupmno9Jdxh7mGnBeVHYkwWPfiIqyRBwFTuPk+KO
         RQVF16NwGxR9ZB9hO+z+pEOUb1jh1QhHEPIXPYAnvNBtYFQ17RDIwFzgCpKgQVQFUG6Z
         STbv0t6e3DuxBRsQMw+8pEfEYSPZAlFLN6HY32xdQGFgpKcm08zDVj/OcGjF8cpYbzGt
         QxxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686332857; x=1688924857;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZFu/lUEM6FUe1loWdD2nYcG4AZ+lX44UcYWbi69QQe4=;
        b=Xb1brbx1O4SZaky1wrzt1J0sIqzLIn7aWLQf8Wjj8sw2kdbtkzvFGpw3slVZqIXRaj
         4gF3GVAz9crM+N+zM5p9ZmOg3ufozMRnaZKiruly3svfMaHICkrFsyrkMrARNv14S5b3
         mwveejlBPp1WnNPOd1/SSvX1xXlfolJrxIi3oitCE5MrR2kGenwPQBaoCST4cAgIxb+1
         7z9mZy7b9eqA46CdrOs0zeP30QmiTXNG97JnSjyxTGOTedhuF75EivDdg7+/ARHOU5NX
         5xNfr8OaEDEkQzWDtTRB17mGz7/TRlCGNq1fcP5cLfeh0yBkh3yKZ1xiqcd0jp3dzaut
         GSzA==
X-Gm-Message-State: AC+VfDw5qCly2KpdH/x+JNpeEEy/OAW4AdWLGATjc7D6xBw+Iiwe8hV+
        OWjlcjDVAj3/pCvO1rn6VGi9ZeG6/5soDExO
X-Google-Smtp-Source: ACHHUZ42nmjGi0RbSzeZ4xxwlpOMLQ4lkGNAFkqd5/P+IT3DC4NFoD2C4DUV0tYIbvpZiWUNBLbxlw==
X-Received: by 2002:a05:6808:2129:b0:398:5a28:d80f with SMTP id r41-20020a056808212900b003985a28d80fmr2570678oiw.4.1686332857156;
        Fri, 09 Jun 2023 10:47:37 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id m4-20020a17090a71c400b0025671de4606sm5003064pjs.4.2023.06.09.10.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 10:47:36 -0700 (PDT)
From:   Shyam Prasad N <nspmangalore@gmail.com>
X-Google-Original-From: Shyam Prasad N <sprasad@microsoft.com>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        bharathsm.hsk@gmail.com, tom@talpey.com
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 1/6] cifs: fix status checks in cifs_tree_connect
Date:   Fri,  9 Jun 2023 17:46:54 +0000
Message-Id: <20230609174659.60327-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The ordering of status checks at the beginning of
cifs_tree_connect is wrong. As a result, a tcon
which is good may stay marked as needing reconnect
infinitely.

Fixes: 2f0e4f034220 ("cifs: check only tcon status on tcon related functions")
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/connect.c | 9 +++++----
 fs/smb/client/dfs.c     | 9 +++++----
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 8e9a672320ab..1250d156619b 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4086,16 +4086,17 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 
 	/* only send once per connect */
 	spin_lock(&tcon->tc_lock);
+	if (tcon->status == TID_GOOD) {
+		spin_unlock(&tcon->tc_lock);
+		return 0;
+	}
+
 	if (tcon->status != TID_NEW &&
 	    tcon->status != TID_NEED_TCON) {
 		spin_unlock(&tcon->tc_lock);
 		return -EHOSTDOWN;
 	}
 
-	if (tcon->status == TID_GOOD) {
-		spin_unlock(&tcon->tc_lock);
-		return 0;
-	}
 	tcon->status = TID_IN_TCON;
 	spin_unlock(&tcon->tc_lock);
 
diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
index 2f93bf8c3325..2390b2fedd6a 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -575,16 +575,17 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 
 	/* only send once per connect */
 	spin_lock(&tcon->tc_lock);
+	if (tcon->status == TID_GOOD) {
+		spin_unlock(&tcon->tc_lock);
+		return 0;
+	}
+
 	if (tcon->status != TID_NEW &&
 	    tcon->status != TID_NEED_TCON) {
 		spin_unlock(&tcon->tc_lock);
 		return -EHOSTDOWN;
 	}
 
-	if (tcon->status == TID_GOOD) {
-		spin_unlock(&tcon->tc_lock);
-		return 0;
-	}
 	tcon->status = TID_IN_TCON;
 	spin_unlock(&tcon->tc_lock);
 
-- 
2.34.1

