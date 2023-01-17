Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B339C00A5A
	for <linux-cifs@archiver.kernel.org>; Tue, 17 Jan 2023 22:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjAQWWm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 Jan 2023 17:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbjAQWVL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 Jan 2023 17:21:11 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99AA95B5B9
        for <linux-cifs@vger.kernel.org>; Tue, 17 Jan 2023 14:00:54 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id D1DA880268;
        Tue, 17 Jan 2023 22:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1673992853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NUi4SYM8lfBX5Z1sKmXuOJbDfolhTaxdrUws4C3czWA=;
        b=fT0xKTD0702OVVl3y9l37COk755BjDohhDGzaIWqshnWr9eNDeqBrpfaSFTqcRUqtG6hbD
        vcsgsnhd88vpMQL9Exrg2AcvV6IIchNYCOyYr/OyfpOaa0WVrXSpnH2wUtpx5DfSn01VoP
        kKROe780ekz+vVG/QssIVlF8wNZRuLNnu2SI2OYL26lLqNoMn5kfCuc5k4M2v+dHk2bPCI
        FFU6VfuHD7meLt6RQh9Gx+jhwxQ2oDSZnpJIkk6H9jO4nsZSFv1kk28n1u7eS2fa17bXrQ
        4lZv9/3pobaijm9vthmrwMVeA4gtqtxv9p5jGX2dVBjbNtaWB5FH4FoHbP9TuQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, aurelien.aptel@gmail.com,
        Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH v2 1/5] cifs: fix potential deadlock in cache_refresh_path()
Date:   Tue, 17 Jan 2023 19:00:37 -0300
Message-Id: <20230117220041.15905-2-pc@cjr.nz>
In-Reply-To: <20230117220041.15905-1-pc@cjr.nz>
References: <20230117000952.9965-1-pc@cjr.nz>
 <20230117220041.15905-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Avoid getting DFS referral from an exclusive lock in
cache_refresh_path() because the tcon IPC used for getting the
referral could be disconnected and thus causing a deadlock as shown
below:

task A                       task B
======                       ======
cifs_demultiplex_thread()    dfs_cache_find()
 cifs_handle_standard()       cache_refresh_path()
  reconnect_dfs_server()       down_write()
   dfs_cache_noreq_find()       get_dfs_referral()
    down_read() <- deadlock      smb2_get_dfs_refer()
                                  SMB2_ioctl()
				   cifs_send_recv()
				    compound_send_recv()
				     wait_for_response()

where task A cannot wake up task B because it is blocked on
down_read() due to the exclusive lock held in cache_refresh_path() and
therefore not being able to make progress.

Fixes: c9f711039905 ("cifs: keep referral server sessions alive")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/dfs_cache.c | 42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index e20f8880363f..a6d7ae5f49a4 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -770,26 +770,27 @@ static int get_dfs_referral(const unsigned int xid, struct cifs_ses *ses, const
  */
 static int cache_refresh_path(const unsigned int xid, struct cifs_ses *ses, const char *path)
 {
-	int rc;
-	struct cache_entry *ce;
 	struct dfs_info3_param *refs = NULL;
+	struct cache_entry *ce;
 	int numrefs = 0;
-	bool newent = false;
+	int rc;
 
 	cifs_dbg(FYI, "%s: search path: %s\n", __func__, path);
 
-	down_write(&htable_rw_lock);
+	down_read(&htable_rw_lock);
 
 	ce = lookup_cache_entry(path);
-	if (!IS_ERR(ce)) {
-		if (!cache_entry_expired(ce)) {
-			dump_ce(ce);
-			up_write(&htable_rw_lock);
-			return 0;
-		}
-	} else {
-		newent = true;
+	if (!IS_ERR(ce) && !cache_entry_expired(ce)) {
+		up_read(&htable_rw_lock);
+		return 0;
 	}
+	/*
+	 * Unlock shared access as we don't want to hold any locks while getting
+	 * a new referral.  The @ses used for performing the I/O could be
+	 * reconnecting and it acquires @htable_rw_lock to look up the dfs cache
+	 * in order to failover -- if necessary.
+	 */
+	up_read(&htable_rw_lock);
 
 	/*
 	 * Either the entry was not found, or it is expired.
@@ -797,19 +798,22 @@ static int cache_refresh_path(const unsigned int xid, struct cifs_ses *ses, cons
 	 */
 	rc = get_dfs_referral(xid, ses, path, &refs, &numrefs);
 	if (rc)
-		goto out_unlock;
+		goto out;
 
 	dump_refs(refs, numrefs);
 
-	if (!newent) {
-		rc = update_cache_entry_locked(ce, refs, numrefs);
-		goto out_unlock;
+	down_write(&htable_rw_lock);
+	/* Re-check as another task might have it added or refreshed already */
+	ce = lookup_cache_entry(path);
+	if (!IS_ERR(ce)) {
+		if (cache_entry_expired(ce))
+			rc = update_cache_entry_locked(ce, refs, numrefs);
+	} else {
+		rc = add_cache_entry_locked(refs, numrefs);
 	}
 
-	rc = add_cache_entry_locked(refs, numrefs);
-
-out_unlock:
 	up_write(&htable_rw_lock);
+out:
 	free_dfs_info_array(refs, numrefs);
 	return rc;
 }
-- 
2.39.0

