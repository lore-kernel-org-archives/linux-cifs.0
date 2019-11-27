Return-Path: <SRS0=l6Wi=ZT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69BF1C43215
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Nov 2019 00:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D1F12075C
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Nov 2019 00:37:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="a18jhQmb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfK0AhU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Nov 2019 19:37:20 -0500
Received: from mx.cjr.nz ([51.158.111.142]:16132 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbfK0AhT (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 26 Nov 2019 19:37:19 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id EB50280A27;
        Wed, 27 Nov 2019 00:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1574815038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8V5zt7MzulYrRwFSBPjsU7IixvtZhpZeey44jEmfZJg=;
        b=a18jhQmbcqH3f7jU9Cop+y577RZYBn7rCnwC1dErvZl+LqAQTXl+XQKDB5vROGP1Yu95x5
        mL7qiczb2B9/6M/XFQf9b24Y458HB0oKFd1LxF55D3upvpBmc00XVpERjGv3GCrdbdyWSx
        nbKUIVfk2cvnWQxIX0QT0kG4/4bVHXNFkUhuBfRG33QjndpqEoo64cyHfFLJxKTrYErqKc
        X+j931h2AlGiNwmMJloL5Bd8PE0TwDf+ONGYe82o+TMgtW1IGncRe5N0hvV1Ux9mUJZEUB
        JJ2ffaDsd2E8m4TPYBp320xPaohQurFnHZOlPyJqxBgkPhp/mI7qkVxtDsQ5UQ==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Subject: [PATCH v3 05/11] cifs: Get rid of kstrdup_const()'d paths
Date:   Tue, 26 Nov 2019 21:36:28 -0300
Message-Id: <20191127003634.14072-6-pc@cjr.nz>
In-Reply-To: <20191127003634.14072-1-pc@cjr.nz>
References: <20191127003634.14072-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The DFS cache API is mostly used with heap allocated strings.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
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

