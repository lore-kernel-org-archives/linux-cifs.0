Return-Path: <SRS0=VVBU=AR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67F62C433E1
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jul 2020 15:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 459F320720
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jul 2020 15:32:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="LlwGfPRb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729321AbgGFPcE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Jul 2020 11:32:04 -0400
Received: from mx.cjr.nz ([51.158.111.142]:53946 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729197AbgGFPcD (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 6 Jul 2020 11:32:03 -0400
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jul 2020 11:32:02 EDT
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 4040580342;
        Mon,  6 Jul 2020 15:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1594049121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yz/53z/+wul25KresV3NZp78cS9lzVU3qqiU0WglNyU=;
        b=LlwGfPRbu6qM83BTtARmhNRfrwN+mMsnB4FtqcqeSTHXSjMgiIHBbKAsC87Spmwhe/2zT8
        zMMx6uDb3cfBwr7Xek7yLnSO5j0mJTFk5FGr1Lo31CiiIGSkA/0qjbhd0suSdA32f8yREQ
        f76PKqxcevCJ/d3ZHaI1nHDDBS2s0NkGdUgNKiSKlZr9BMghOaZn76Rf3zbzLnrmcWFXYf
        xwmFDCUH/cYZlCyZAchar9I23w5282m3APnPRaXlMV4A3LaRV7+Sn9Qe3ZEZtm6KA/Yej8
        kAS+Eip9+LsLR6CKCt1ppI11RbaT3OWgiMj3PdMctsIo9vaHYtRwuFjzOtz60Q==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 2/7] cifs: reduce number of referral requests in DFS link lookups
Date:   Mon,  6 Jul 2020 12:23:57 -0300
Message-Id: <20200706152402.5721-3-pc@cjr.nz>
In-Reply-To: <20200706152402.5721-1-pc@cjr.nz>
References: <20200706152402.5721-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When looking up the DFS cache with a referral path that has more than
two path components, and is a complete prefix of an existing cache
entry, do not request another referral and just return the matched
entry as specified in MS-DFSC 3.2.5.5 Receiving a Root Referral
Request or Link Referral Request.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/dfs_cache.c | 79 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 68 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index df81c718d2fa..dae2f41e4f21 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -490,16 +490,7 @@ static int add_cache_entry(const char *path, unsigned int hash,
 	return 0;
 }
 
-/*
- * Find a DFS cache entry in hash table and optionally check prefix path against
- * @path.
- * Use whole path components in the match.
- * Must be called with htable_rw_lock held.
- *
- * Return ERR_PTR(-ENOENT) if the entry is not found.
- */
-static struct cache_entry *lookup_cache_entry(const char *path,
-					      unsigned int *hash)
+static struct cache_entry *__lookup_cache_entry(const char *path)
 {
 	struct cache_entry *ce;
 	unsigned int h;
@@ -517,9 +508,75 @@ static struct cache_entry *lookup_cache_entry(const char *path,
 
 	if (!found)
 		ce = ERR_PTR(-ENOENT);
+	return ce;
+}
+
+/*
+ * Find a DFS cache entry in hash table and optionally check prefix path against
+ * @path.
+ * Use whole path components in the match.
+ * Must be called with htable_rw_lock held.
+ *
+ * Return ERR_PTR(-ENOENT) if the entry is not found.
+ */
+static struct cache_entry *lookup_cache_entry(const char *path, unsigned int *hash)
+{
+	struct cache_entry *ce = ERR_PTR(-ENOENT);
+	unsigned int h;
+	int cnt = 0;
+	char *npath;
+	char *s, *e;
+	char sep;
+
+	npath = kstrndup(path, strlen(path), GFP_KERNEL);
+	if (!npath)
+		return ERR_PTR(-ENOMEM);
+
+	s = npath;
+	sep = *npath;
+	while ((s = strchr(s, sep)) && ++cnt < 3)
+		s++;
+
+	if (cnt < 3) {
+		h = cache_entry_hash(path, strlen(path));
+		ce = __lookup_cache_entry(path);
+		goto out;
+	}
+	/*
+	 * Handle paths that have more than two path components and are a complete prefix of the DFS
+	 * referral request path (@path).
+	 *
+	 * See MS-DFSC 3.2.5.5 "Receiving a Root Referral Request or Link Referral Request".
+	 */
+	h = cache_entry_hash(npath, strlen(npath));
+	e = npath + strlen(npath) - 1;
+	while (e > s) {
+		char tmp;
+
+		/* skip separators */
+		while (e > s && *e == sep)
+			e--;
+		if (e == s)
+			goto out;
+
+		tmp = *(e+1);
+		*(e+1) = 0;
+
+		ce = __lookup_cache_entry(npath);
+		if (!IS_ERR(ce)) {
+			h = cache_entry_hash(npath, strlen(npath));
+			break;
+		}
+
+		*(e+1) = tmp;
+		/* backward until separator */
+		while (e > s && *e != sep)
+			e--;
+	}
+out:
 	if (hash)
 		*hash = h;
-
+	kfree(npath);
 	return ce;
 }
 
-- 
2.27.0

