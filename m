Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36FB3C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 31 Mar 2022 18:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbiCaSDx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 31 Mar 2022 14:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbiCaSDw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 31 Mar 2022 14:03:52 -0400
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99EA231ACC
        for <linux-cifs@vger.kernel.org>; Thu, 31 Mar 2022 11:02:04 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id E46E07FC23;
        Thu, 31 Mar 2022 18:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1648749722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6ZRNqUNZ5+aAR4/Vo+9KeTJ7WySX9CmsFcJzGKnO9H0=;
        b=c/YHwfEnRFNjF/7MkhNjHPIemi+mgIphe4mbAKQFZz4tsvfISlf3nvKcqqzEAmg/fuxUY2
        Erw2qbRaoGDfANTad6c87c4Rda6FnqlHrleFC2bWXcL185cbMkWWVzENrZeJW3tnhuXBFl
        nEpXf7oi22u1M4mdxX7z3duXbZw1iI+aSG0lc70CbtXDcjqBA8y219tNoYu5de/3ngLnd4
        o75xbTSlhKl83O6cnPu7VdimCgoXNwaZcIRjKO40VsJy62qPI/2wtDT2blY3DBAwQtluP7
        ecrVN/0JWJf8Qo/OoxhYEKsJvSoNBT7mcQ4wzukqbOczdd+5x2Yq1v1mb2mHMA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 1/2] cifs: fix potential race with cifsd thread
Date:   Thu, 31 Mar 2022 15:01:50 -0300
Message-Id: <20220331180151.5301-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

To avoid racing with demultiplex thread while it is handling data on
socket, use cifs_signal_cifsd_for_reconnect() helper for marking
current server to reconnect and let the demultiplex thread handle the
rest.

Fixes: dca65818c80c ("cifs: use a different reconnect helper for non-cifsd threads")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/connect.c | 2 +-
 fs/cifs/netmisc.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ee3b7c15e884..3ca06bd88b6e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4465,7 +4465,7 @@ static int tree_connect_dfs_target(const unsigned int xid, struct cifs_tcon *tco
 	 */
 	if (rc && server->current_fullpath != server->origin_fullpath) {
 		server->current_fullpath = server->origin_fullpath;
-		cifs_reconnect(tcon->ses->server, true);
+		cifs_signal_cifsd_for_reconnect(server, true);
 	}
 
 	dfs_cache_free_tgts(tl);
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index ebe236b9d9f5..235aa1b395eb 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -896,7 +896,7 @@ map_and_check_smb_error(struct mid_q_entry *mid, bool logErr)
 		if (class == ERRSRV && code == ERRbaduid) {
 			cifs_dbg(FYI, "Server returned 0x%x, reconnecting session...\n",
 				code);
-			cifs_reconnect(mid->server, false);
+			cifs_signal_cifsd_for_reconnect(mid->server, false);
 		}
 	}
 
-- 
2.35.1

