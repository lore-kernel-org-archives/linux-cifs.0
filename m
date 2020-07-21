Return-Path: <SRS0=/QKu=BA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA1DC433E3
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Jul 2020 12:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C593120717
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Jul 2020 12:37:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="fgZygBl4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgGUMhl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Jul 2020 08:37:41 -0400
Received: from mx.cjr.nz ([51.158.111.142]:36926 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727106AbgGUMhl (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 21 Jul 2020 08:37:41 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 2AB097FEAD;
        Tue, 21 Jul 2020 12:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1595335059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dM8DqT4Js/tBZGNhl2Q4XbeCyGaAX+FLSoXL3OejGqM=;
        b=fgZygBl481hLqqiNoN0igO4NBQLy7oPXa/cqsKzbuKVfQ5SqmuLAYIvykxCfSpITOWVSAH
        p6p+rEi9EeI+2hQLQyRfhE88n+42L+ctPh9QpTe+BlgfiVNf1h0RM7XdfMw4ta+NN57Nzn
        MTgqWAin3NtEaAA8WztkwKaeFzmITztv9SOS8P48pPiaTKWpSq6Xn+S8mFTyEuqNllbj/i
        BgPl2iO6I1WgYLK76NK52XP7iMAdKClq5lf9mlotiJmsh88Mk7bBSoJsdWQsNjXog0b9BQ
        Zza68HhItEzp7x54lobzsTo81TnXyzSMN5NmnLG44RI+M9z7345KWuag0tdR5A==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>, Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH v3 3/7] cifs: rename reconn_inval_dfs_target()
Date:   Tue, 21 Jul 2020 09:36:40 -0300
Message-Id: <20200721123644.14728-4-pc@cjr.nz>
In-Reply-To: <20200721123644.14728-1-pc@cjr.nz>
References: <20200721123644.14728-1-pc@cjr.nz>
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
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/connect.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 632978db2dbd..9582f63b8ebc 100644
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

