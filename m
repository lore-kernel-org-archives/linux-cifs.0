Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EEECC433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Apr 2022 16:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349547AbiDAQzh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Apr 2022 12:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349698AbiDAQz2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Apr 2022 12:55:28 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9651AF2C
        for <linux-cifs@vger.kernel.org>; Fri,  1 Apr 2022 09:51:48 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 6AD797FC23;
        Fri,  1 Apr 2022 16:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1648831906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bIM8RhEWB60yYRj8uXGhOauFpbX6RHPFm2z9rnnY87s=;
        b=NPaQ9f11OUUKx4nquY8YvEWe8SlgYte8+cLpiSeqIkFVCtCyKwjP8cPB9Zto/rD+5bHZqt
        35AIephbPmBiVVB2i4EW49zWxiNc2ebjqtjAl9dMKkMi+1GVt7PS/tDTsuakPUwqaoYthB
        wdYbAEkLsalrDzfkYPsxwmadZ2QQLGQcEs7yNlNjZSSjBN1iV6u9E8eNfr/1WjMEE4uisz
        X0NMYTMBTLjaXd9yAVBDUq0zgFxvK2xSwXXZ/4HMaZtIN+0CmuvXWiaHBgJaBEWOjrUIbY
        zkC2gx77wiVbeQy1IHSDlkEBk8vwqMokRjITv0i0mbNZUnyWzJ+qZzO5d+LGaw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH v2] cifs: force new session setup and tcon for dfs
Date:   Fri,  1 Apr 2022 13:51:34 -0300
Message-Id: <20220401165134.25471-1-pc@cjr.nz>
In-Reply-To: <20220331180151.5301-2-pc@cjr.nz>
References: <20220331180151.5301-2-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Do not reuse existing sessions and tcons in DFS failover as it might
connect to different servers and shares.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/connect.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 3ca06bd88b6e..54155eb4faac 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -453,9 +453,7 @@ static int reconnect_target_unlocked(struct TCP_Server_Info *server, struct dfs_
 	return rc;
 }
 
-static int
-reconnect_dfs_server(struct TCP_Server_Info *server,
-		     bool mark_smb_session)
+static int reconnect_dfs_server(struct TCP_Server_Info *server)
 {
 	int rc = 0;
 	const char *refpath = server->current_fullpath + 1;
@@ -479,7 +477,12 @@ reconnect_dfs_server(struct TCP_Server_Info *server,
 	if (!cifs_tcp_ses_needs_reconnect(server, num_targets))
 		return 0;
 
-	cifs_mark_tcp_ses_conns_for_reconnect(server, mark_smb_session);
+	/*
+	 * Unconditionally mark all sessions & tcons for reconnect as we might be connecting to a
+	 * different server or share during failover.  It could be improved by adding some logic to
+	 * only do that in case it connects to a different server or share, though.
+	 */
+	cifs_mark_tcp_ses_conns_for_reconnect(server, true);
 
 	cifs_abort_connection(server);
 
@@ -537,7 +540,7 @@ int cifs_reconnect(struct TCP_Server_Info *server, bool mark_smb_session)
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
 
-	return reconnect_dfs_server(server, mark_smb_session);
+	return reconnect_dfs_server(server);
 }
 #else
 int cifs_reconnect(struct TCP_Server_Info *server, bool mark_smb_session)
-- 
2.35.1

