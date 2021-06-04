Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A5BEC4743D
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 22:25:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5474D613AD
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 22:25:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbhFDW1p (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Jun 2021 18:27:45 -0400
Received: from mx.cjr.nz ([51.158.111.142]:9460 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231534AbhFDW1p (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 4 Jun 2021 18:27:45 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 1B6AB7FC02;
        Fri,  4 Jun 2021 22:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1622845557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KDikN8TnMuoynt95PbaKl+U292bGOru9bdL9S23mhQk=;
        b=SAti10PXfO5ZLp0cxuF7HffTbhdYt5FD+ZBb9qstmZ0ceFSjdIt1/rt8o0EgAIVIjunwHe
        pAKS7njp8PP0yOdfhtgXslWkx0BWxy/7Y+jv7eX9J9UATjcni3IblsUDlkKX/Q46HfeuQF
        DGycqy5j5D5bMbCfbuPtXm5ujx2msrxIODDL+Qfh/RUbhG55DBJ7ZPQFPv/a7/ofHiXBRG
        acDAgA8qxP1fjSiDci5AH1hb3DJXwJ/B2PsVdFAhSpM7Kz7hvZ8ROEhOwLas3mMOdKuzge
        UDHIayiIgbopm157/3mzAzWgGk3Yx5WhJhzG8OvXHe2ryVWADnOuO6V2BlSSXA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 2/7] cifs: get rid of @noreq param in __dfs_cache_find()
Date:   Fri,  4 Jun 2021 19:25:28 -0300
Message-Id: <20210604222533.4760-3-pc@cjr.nz>
In-Reply-To: <20210604222533.4760-1-pc@cjr.nz>
References: <20210604222533.4760-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

@noreq param isn't used anywhere, so just remove it.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/dfs_cache.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index b1fa30fefe1f..e5ea87869f36 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -701,8 +701,7 @@ static int update_cache_entry(const char *path,
  * handle them properly.
  */
 static int __dfs_cache_find(const unsigned int xid, struct cifs_ses *ses,
-			    const struct nls_table *nls_codepage, int remap,
-			    const char *path, bool noreq)
+			    const struct nls_table *nls_codepage, int remap, const char *path)
 {
 	int rc;
 	unsigned int hash;
@@ -716,16 +715,6 @@ static int __dfs_cache_find(const unsigned int xid, struct cifs_ses *ses,
 	down_read(&htable_rw_lock);
 
 	ce = lookup_cache_entry(path, &hash);
-
-	/*
-	 * If @noreq is set, no requests will be sent to the server. Just return
-	 * the cache entry.
-	 */
-	if (noreq) {
-		up_read(&htable_rw_lock);
-		return PTR_ERR_OR_ZERO(ce);
-	}
-
 	if (!IS_ERR(ce)) {
 		if (!cache_entry_expired(ce)) {
 			dump_ce(ce);
@@ -890,7 +879,7 @@ int dfs_cache_find(const unsigned int xid, struct cifs_ses *ses,
 	if (rc)
 		return rc;
 
-	rc = __dfs_cache_find(xid, ses, nls_codepage, remap, npath, false);
+	rc = __dfs_cache_find(xid, ses, nls_codepage, remap, npath);
 	if (rc)
 		goto out_free_path;
 
@@ -1002,7 +991,7 @@ int dfs_cache_update_tgthint(const unsigned int xid, struct cifs_ses *ses,
 
 	cifs_dbg(FYI, "%s: update target hint - path: %s\n", __func__, npath);
 
-	rc = __dfs_cache_find(xid, ses, nls_codepage, remap, npath, false);
+	rc = __dfs_cache_find(xid, ses, nls_codepage, remap, npath);
 	if (rc)
 		goto out_free_path;
 
-- 
2.31.1

