Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 603D6C67871
	for <linux-cifs@archiver.kernel.org>; Tue, 17 Jan 2023 00:11:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbjAQALB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 16 Jan 2023 19:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233461AbjAQALA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 16 Jan 2023 19:11:00 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02D54EF7
        for <linux-cifs@vger.kernel.org>; Mon, 16 Jan 2023 16:10:58 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id D6FC980268;
        Tue, 17 Jan 2023 00:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1673914257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5+axe9MxvuWApoHIx+qWh9J5EHP57rnmfzB+bezSWo4=;
        b=NyF4jOUvcSjABHzmNN1RKbj2zboRZvHogfjCELxoqIGOQY7aBul4vU4pG+78WHQIDS6azq
        /MHTyNIMm69SCJlfVqbe5AFiXRuevCF7ovv8Nio9IfDodof9HAf/AsEXGxE/avUOycFcT+
        q1fTrD2lYYIk1VUkuXKs0bWTgpGIoUqE6o4hZafTHqPd4jjRjjlz2HAurYM0CQA+Bc82L1
        7A0bqhBcTf2Z0t/W13wDsW6hRqVEjaNrYdn1vkWqmwqVv3n76j23t426rkBTJVB0WbCOW2
        8PJOE7M6RaYr4DJPNcMkp4sfBofJoBi33gqhLgRwPRMwAWI/czh9x6TGzx1Vew==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 1/5] cifs: fix potential deadlock in cache_refresh_path()
Date:   Mon, 16 Jan 2023 21:09:48 -0300
Message-Id: <20230117000952.9965-2-pc@cjr.nz>
In-Reply-To: <20230117000952.9965-1-pc@cjr.nz>
References: <20230117000952.9965-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Avoid getting DFS referral from an exclusive lock in
cache_refresh_path() because the tcon IPC used for getting the
referral could be disconnected and thus causing a deadlock as shown
below:

task A
------
cifs_demultiplex_thread()
 cifs_handle_standard()
  reconnect_dfs_server()
   dfs_cache_noreq_find()
    down_read()

task B
------
dfs_cache_find()
 cache_refresh_path()
  down_write()
   get_dfs_referral()
    smb2_get_dfs_refer()
     SMB2_ioctl()
      cifs_send_recv()
       compound_send_recv()
        wait_for_response()

where task A cannot wake up task B because it is blocked due to the
exclusive lock held in cache_refresh_path().

Fixes: c9f711039905 ("cifs: keep referral server sessions alive")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/dfs_cache.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index e20f8880363f..a8ddac1c054c 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -770,46 +770,45 @@ static int get_dfs_referral(const unsigned int xid, struct cifs_ses *ses, const
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
 
+	up_read(&htable_rw_lock);
+
 	/*
 	 * Either the entry was not found, or it is expired.
 	 * Request a new DFS referral in order to create or update a cache entry.
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

