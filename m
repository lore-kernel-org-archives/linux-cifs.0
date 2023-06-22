Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C373EB64DA
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Jun 2023 18:16:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjFVSQX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Jun 2023 14:16:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbjFVSQX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Jun 2023 14:16:23 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B21E1FE9
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jun 2023 11:16:22 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-666fb8b1bc8so5619799b3a.1
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jun 2023 11:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687457781; x=1690049781;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3PJzkvfJJ/w9PB8YUM8fK+3muONP6HcrChuABvZAryg=;
        b=A50JQOyowBkbW4faJ1cn115+eb9bmIKPqMYXNct2+sGAS5pteFfJldG2/TsW+3i7nK
         RospZLaSpOQjSlEOOvvUEQBvtDjVQtoXQ2mTDHiTDBk+xPTCbHszKdzQBegFYHCJJs2Q
         phkgLlrOeZJWVsMRDATssmjPRhNXRlnlH9cNnTuW98iXvfX76XqiwbIiff6E+2J3zNEb
         eo0BDD0hz5Y32yZWrFz3oAySryA489bou9jSVuvcQut07784SoCYByB9GeBTuIFA+OAk
         2c0+ExkJto5ZyoWlHvksgUnU2l/UBGF+Tkt6mx/85Mr9EcjFqupRmpapFlFsO3kkdL6+
         mvpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687457781; x=1690049781;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3PJzkvfJJ/w9PB8YUM8fK+3muONP6HcrChuABvZAryg=;
        b=iwu/I31EZgeTDt2wvG8JVojrVFeV8iMoeFG7QRMSY65OXlc3Oi2Jf4GpCbS5rmD3B5
         cgL5bzZwzhnqzszC6aajqS7hjSUrpxNDLf3rHUeWIsTfa5Z9pqhbiDaMIoe2pzMuy4Bv
         KF+2g7PQ+i7rNQpZqqX0ngHnUNFbMKOxscMMlRUAr4QoN1n/62ZrM6YEB0PtzSgHhbem
         ZZzxoXHA41nG3nPTXtKZ8Pcc26ZdEubmyHvWcbpbMMuIw1q83gTee//ppKybnC/HQ8Q1
         xIZfZeBVMg+yNPAUfkOq0JhY+9qChYE8YAmHuNXhRwExgVoZjTuPuGrXBGYYCHrTLFzt
         V+yw==
X-Gm-Message-State: AC+VfDxEEZUY+AeZNEP2UyAs6XwkZz+BpFz6HSXFrEp0y7jZkWoH6tna
        cMk3Q9RKPyfml6+kXzA+opleb6YMmeJRyvKk
X-Google-Smtp-Source: ACHHUZ7DUFv0Gd8EDawH/84ndz+EWH1LkKbS2MEC2a5MiRjiLz8Qo7Ketom/mIKRjAqkvQeIhviDdg==
X-Received: by 2002:a05:6a00:801:b0:668:6eed:7c1a with SMTP id m1-20020a056a00080100b006686eed7c1amr19129485pfk.7.1687457780867;
        Thu, 22 Jun 2023 11:16:20 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id h4-20020aa786c4000000b0064fdf576421sm4996536pfo.142.2023.06.22.11.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 11:16:20 -0700 (PDT)
From:   Shyam Prasad N <nspmangalore@gmail.com>
X-Google-Original-From: Shyam Prasad N <sprasad@microsoft.com>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ematsumiya@suse.de, bharathsm.hsk@gmail.com
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 3/3] cifs: do all necessary checks for credits within or before locking
Date:   Thu, 22 Jun 2023 18:16:04 +0000
Message-Id: <20230622181604.4788-3-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230622181604.4788-1-sprasad@microsoft.com>
References: <20230622181604.4788-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

All the server credits and in-flight info is protected by req_lock.
Once the req_lock is held, and we've determined that we have enough
credits to continue, this lock cannot be dropped till we've made the
changes to credits and in-flight count.

However, we used to drop the lock in order to avoid deadlock with
the recent srv_lock. This could cause the checks already made to be
invalidated.

Fixed it by moving the server status check to before locking req_lock.

Fixes: d7d7a66aacd6 ("cifs: avoid use of global locks for high contention data")
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/smb2ops.c   | 19 ++++++++++---------
 fs/smb/client/transport.c | 20 ++++++++++----------
 2 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 8e4900f6cd53..cb07ac32cf38 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -211,6 +211,16 @@ smb2_wait_mtu_credits(struct TCP_Server_Info *server, unsigned int size,
 
 	spin_lock(&server->req_lock);
 	while (1) {
+		spin_unlock(&server->req_lock);
+
+		spin_lock(&server->srv_lock);
+		if (server->tcpStatus == CifsExiting) {
+			spin_unlock(&server->srv_lock);
+			return -ENOENT;
+		}
+		spin_unlock(&server->srv_lock);
+
+		spin_lock(&server->req_lock);
 		if (server->credits <= 0) {
 			spin_unlock(&server->req_lock);
 			cifs_num_waiters_inc(server);
@@ -221,15 +231,6 @@ smb2_wait_mtu_credits(struct TCP_Server_Info *server, unsigned int size,
 				return rc;
 			spin_lock(&server->req_lock);
 		} else {
-			spin_unlock(&server->req_lock);
-			spin_lock(&server->srv_lock);
-			if (server->tcpStatus == CifsExiting) {
-				spin_unlock(&server->srv_lock);
-				return -ENOENT;
-			}
-			spin_unlock(&server->srv_lock);
-
-			spin_lock(&server->req_lock);
 			scredits = server->credits;
 			/* can deadlock with reopen */
 			if (scredits <= 8) {
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 0474d0bba0a2..f280502a2aee 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -522,6 +522,16 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int num_credits,
 	}
 
 	while (1) {
+		spin_unlock(&server->req_lock);
+
+		spin_lock(&server->srv_lock);
+		if (server->tcpStatus == CifsExiting) {
+			spin_unlock(&server->srv_lock);
+			return -ENOENT;
+		}
+		spin_unlock(&server->srv_lock);
+
+		spin_lock(&server->req_lock);
 		if (*credits < num_credits) {
 			scredits = *credits;
 			spin_unlock(&server->req_lock);
@@ -547,15 +557,6 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int num_credits,
 				return -ERESTARTSYS;
 			spin_lock(&server->req_lock);
 		} else {
-			spin_unlock(&server->req_lock);
-
-			spin_lock(&server->srv_lock);
-			if (server->tcpStatus == CifsExiting) {
-				spin_unlock(&server->srv_lock);
-				return -ENOENT;
-			}
-			spin_unlock(&server->srv_lock);
-
 			/*
 			 * For normal commands, reserve the last MAX_COMPOUND
 			 * credits to compound requests.
@@ -569,7 +570,6 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int num_credits,
 			 * for servers that are slow to hand out credits on
 			 * new sessions.
 			 */
-			spin_lock(&server->req_lock);
 			if (!optype && num_credits == 1 &&
 			    server->in_flight > 2 * MAX_COMPOUND &&
 			    *credits <= MAX_COMPOUND) {
-- 
2.34.1

