Return-Path: <SRS0=VVBU=AR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4896EC433E0
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jul 2020 15:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EA5320708
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jul 2020 15:32:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="D/B8WsXu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729358AbgGFPcD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Jul 2020 11:32:03 -0400
Received: from mx.cjr.nz ([51.158.111.142]:53948 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729321AbgGFPcD (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 6 Jul 2020 11:32:03 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 5E70D804BE;
        Mon,  6 Jul 2020 15:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1594049123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=waqq5/ckPrWXM1SXWctkzMZsUpMVCr9UI4qSGCUm0F8=;
        b=D/B8WsXu6vyv8E10EeNT1nu8Udc2R8YJcjzl3jfAuq0AqzPfLgxqb1XK7RG567/Fl3E/Zo
        2u7/jmBs+fDquI5JEUqiNj+V0Z/eNBwWB6Yk38dOa91gCNvIyhIFGmPIZx+jPVLHfF2CPB
        X6yjjyG02Rl6FZ8Xh4QQDtnVyOatl26edNXmpcUO1fFrw2eMK8xpZ87iooLOCua/jMJQmH
        /6qJ6m+lUAQj1wPD9POJlUuol08N8k1+j+KuPh/rr5EeUdKQbTVsVQz+8LpGCdGFivx60q
        UOKL7bAWjyJckQw262VoY4HBsJ3TQ9Viactoozg15di9BGHVa3RZrY7yCaW6Pg==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 3/7] cifs: rename reconn_inval_dfs_target()
Date:   Mon,  6 Jul 2020 12:23:58 -0300
Message-Id: <20200706152402.5721-4-pc@cjr.nz>
In-Reply-To: <20200706152402.5721-1-pc@cjr.nz>
References: <20200706152402.5721-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This function has nothing to do with *invalidation* but setting up the
next target server from a cached referral.

Rename it to reconn_set_next_dfs_target().  While at it, get rid of
some meaningless checks.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/connect.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5c3c65265478..b90ee86c0523 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -393,15 +393,14 @@ static inline int reconn_set_ipaddr(struct TCP_Server_Info *server)
 
 #ifdef CONFIG_CIFS_DFS_UPCALL
 /* These functions must be called with server->srv_mutex held */
-static void reconn_inval_dfs_target(struct TCP_Server_Info *server,
-				    struct cifs_sb_info *cifs_sb,
-				    struct dfs_cache_tgt_list *tgt_list,
-				    struct dfs_cache_tgt_iterator **tgt_it)
+static void reconn_set_next_dfs_target(struct TCP_Server_Info *server,
+				       struct cifs_sb_info *cifs_sb,
+				       struct dfs_cache_tgt_list *tgt_list,
+				       struct dfs_cache_tgt_iterator **tgt_it)
 {
 	const char *name;
 
-	if (!cifs_sb || !cifs_sb->origin_fullpath || !tgt_list ||
-	    !server->nr_targets)
+	if (!cifs_sb || !cifs_sb->origin_fullpath)
 		return;
 
 	if (!*tgt_it) {
@@ -578,7 +577,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 		 * feature is disabled, then we will retry last server we
 		 * connected to before.
 		 */
-		reconn_inval_dfs_target(server, cifs_sb, &tgt_list, &tgt_it);
+		reconn_set_next_dfs_target(server, cifs_sb, &tgt_list, &tgt_it);
 #endif
 		rc = reconn_set_ipaddr(server);
 		if (rc) {
-- 
2.27.0

