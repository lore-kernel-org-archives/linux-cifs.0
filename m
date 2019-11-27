Return-Path: <SRS0=l6Wi=ZT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3B20C43215
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Nov 2019 00:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8692B2075C
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Nov 2019 00:37:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="fxxz0Maf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfK0AhY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Nov 2019 19:37:24 -0500
Received: from mx.cjr.nz ([51.158.111.142]:16158 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726947AbfK0AhY (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 26 Nov 2019 19:37:24 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 1D8A380A27;
        Wed, 27 Nov 2019 00:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1574815042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Qsu79zBM4TCr1/G3qqTg6Hu/99no/gFFjzerJfX8Nw=;
        b=fxxz0MafYOj0ahI+hmbRwASc+SrsnwRyNR59jhAgwmI40uIbzF8Ohc9ssnTm4FDUV3+ReX
        thb5aqadL6F3JQv6HahVVKS+FDgzFlK6jZebE6js55GOARF3xe9qm6nLWxJanCY2rKk2PZ
        IUbRYARU1Zel/PbGcBnoW1JCWbzVS9CYegoZHujnFNQVgywOjUSlTce9ayM39E5RhhanUc
        XEZa0CLRubaxb3atKBheCh+hGdWlH+3fzDtEjHLOcJcf57xRDCHOWjdEJVSejo+RrWkdHu
        OshPXwRi3SlxgnhZ64LWWSaVS2LKJLSep5BvQr7mr7jC/cH4ubj2THiBjjD7Dg==
From:   "Paulo Alcantara (SUSE)" <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Subject: [PATCH v3 07/11] cifs: Merge is_path_valid() into get_normalized_path()
Date:   Tue, 26 Nov 2019 21:36:30 -0300
Message-Id: <20191127003634.14072-8-pc@cjr.nz>
In-Reply-To: <20191127003634.14072-1-pc@cjr.nz>
References: <20191127003634.14072-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Just do the trivial path validation in get_normalized_path().

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/dfs_cache.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index e889608e5e13..1d1f7c03931b 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -75,13 +75,11 @@ static void refresh_cache_worker(struct work_struct *work);
 
 static DECLARE_DELAYED_WORK(refresh_task, refresh_cache_worker);
 
-static inline bool is_path_valid(const char *path)
+static int get_normalized_path(const char *path, char **npath)
 {
-	return path && (strchr(path + 1, '\\') || strchr(path + 1, '/'));
-}
+	if (!path || strlen(path) < 3 || (*path != '\\' && *path != '/'))
+		return -EINVAL;
 
-static inline int get_normalized_path(const char *path, char **npath)
-{
 	if (*path == '\\') {
 		*npath = (char *)path;
 	} else {
@@ -828,9 +826,6 @@ int dfs_cache_find(const unsigned int xid, struct cifs_ses *ses,
 	char *npath;
 	struct cache_entry *ce;
 
-	if (unlikely(!is_path_valid(path)))
-		return -EINVAL;
-
 	rc = get_normalized_path(path, &npath);
 	if (rc)
 		return rc;
@@ -875,9 +870,6 @@ int dfs_cache_noreq_find(const char *path, struct dfs_info3_param *ref,
 	char *npath;
 	struct cache_entry *ce;
 
-	if (unlikely(!is_path_valid(path)))
-		return -EINVAL;
-
 	rc = get_normalized_path(path, &npath);
 	if (rc)
 		return rc;
@@ -929,9 +921,6 @@ int dfs_cache_update_tgthint(const unsigned int xid, struct cifs_ses *ses,
 	struct cache_entry *ce;
 	struct cache_dfs_tgt *t;
 
-	if (unlikely(!is_path_valid(path)))
-		return -EINVAL;
-
 	rc = get_normalized_path(path, &npath);
 	if (rc)
 		return rc;
@@ -989,7 +978,7 @@ int dfs_cache_noreq_update_tgthint(const char *path,
 	struct cache_entry *ce;
 	struct cache_dfs_tgt *t;
 
-	if (unlikely(!is_path_valid(path)) || !it)
+	if (!it)
 		return -EINVAL;
 
 	rc = get_normalized_path(path, &npath);
@@ -1049,8 +1038,6 @@ int dfs_cache_get_tgt_referral(const char *path,
 
 	if (!it || !ref)
 		return -EINVAL;
-	if (unlikely(!is_path_valid(path)))
-		return -EINVAL;
 
 	rc = get_normalized_path(path, &npath);
 	if (rc)
-- 
2.24.0

