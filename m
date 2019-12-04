Return-Path: <SRS0=LMmx=Z2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 626D0C43603
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Dec 2019 20:38:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3488A21826
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Dec 2019 20:38:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="njSE619s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbfLDUiY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 Dec 2019 15:38:24 -0500
Received: from mx.cjr.nz ([51.158.111.142]:1738 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728238AbfLDUiX (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 4 Dec 2019 15:38:23 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 3FAE8809F8;
        Wed,  4 Dec 2019 20:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1575491902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OEqr8+yTGNA/u8ecjinMKBPiB0Yz6O79hcbAcMK42Jk=;
        b=njSE619sn8qlQutsAKwNeKdWcvPSz1tvJ7+1XHaTrzLpPvuJNAkbDiKF9SyIpSAdITqKb0
        r8jXo70zhij0IQwBS9ME0F9//+DMU5pSR6SIUrgwEmd8dniXNAaw69M67r9miCW5o3oCjF
        pXBpYi4VZgAIKls7lk1oy1WXWqRZBMVsmRtH6gISrblS/cU/VjLRhxCfzwYGM1rK884IdF
        UbiNUuz6eO0nv3kI7p3aaPgXrNtFcQpWvzF7pU5zFCI38ixLFyBW/F7gN5QSLnuviAwjYX
        MgNkIe624TuhyU76nVu8LBdqx9x68soyl4D8u+zqlJvN92KZXy2pnrKAlTsiFw==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH v4 2/6] cifs: Get rid of kstrdup_const()'d paths
Date:   Wed,  4 Dec 2019 17:37:59 -0300
Message-Id: <20191204203803.2316-3-pc@cjr.nz>
In-Reply-To: <20191204203803.2316-1-pc@cjr.nz>
References: <20191204203803.2316-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The DFS cache API is mostly used with heap allocated strings.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/dfs_cache.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index aed4183840c5..49c5f045270f 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -131,7 +131,7 @@ static inline void flush_cache_ent(struct cache_entry *ce)
 		return;
 
 	hlist_del_init_rcu(&ce->hlist);
-	kfree_const(ce->path);
+	kfree(ce->path);
 	free_tgts(ce);
 	cache_count--;
 	call_rcu(&ce->rcu, free_cache_entry);
@@ -420,7 +420,7 @@ static struct cache_entry *alloc_cache_entry(const char *path,
 	if (!ce)
 		return ERR_PTR(-ENOMEM);
 
-	ce->path = kstrdup_const(path, GFP_KERNEL);
+	ce->path = kstrndup(path, strlen(path), GFP_KERNEL);
 	if (!ce->path) {
 		kmem_cache_free(cache_slab, ce);
 		return ERR_PTR(-ENOMEM);
@@ -430,7 +430,7 @@ static struct cache_entry *alloc_cache_entry(const char *path,
 
 	rc = copy_ref_data(refs, numrefs, ce, NULL);
 	if (rc) {
-		kfree_const(ce->path);
+		kfree(ce->path);
 		kmem_cache_free(cache_slab, ce);
 		ce = ERR_PTR(rc);
 	}
-- 
2.24.0

