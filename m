Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4874C38147
	for <linux-cifs@archiver.kernel.org>; Tue, 17 Jan 2023 22:22:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjAQWWl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 Jan 2023 17:22:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbjAQWVW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 Jan 2023 17:21:22 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26089618B6
        for <linux-cifs@vger.kernel.org>; Tue, 17 Jan 2023 14:01:05 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 0F265817D4;
        Tue, 17 Jan 2023 22:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1673992861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ic9e4+ceYYlZYr/hlG2Eu49hTci5KP8LXbEt0apG5ec=;
        b=lSj6ctOtE0C5DVNdZvPnqgNlZdQ+kQk/jihLkiFX9cc1JW5NVQgb9n0IrZcIP1TOmApud5
        39nwJqa5bmXeoZfC6wMi6JbJLuLXtozxmwrlPJqUh1LhzZpWUW4KPZFnIKqadaFELyjMPD
        QUXgw5k7mTPJtRkJsERdSz5rzlWHgbx/aVdURBP+oQL60aOIrIaWXNITDclpCloF72vHGY
        7FYPa+JCrKb5H+P9cj+yMom36S6V7k92dWHOvjSlANAXyI+4B4asmpyetsWM2i6JHw6Tnd
        ILIDpwdTRulEaZPTBC9OXvhKnQUCeoungd6hGiKe0a2z9KHIaH7K70G91gfN4g==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, aurelien.aptel@gmail.com,
        Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH v2 5/5] cifs: handle cache lookup errors different than -ENOENT
Date:   Tue, 17 Jan 2023 19:00:41 -0300
Message-Id: <20230117220041.15905-6-pc@cjr.nz>
In-Reply-To: <20230117220041.15905-1-pc@cjr.nz>
References: <20230117000952.9965-1-pc@cjr.nz>
 <20230117220041.15905-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

lookup_cache_entry() might return an error different than -ENOENT
(e.g. from ->char2uni), so handle those as well in
cache_refresh_path().

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/dfs_cache.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 58d11be9d020..308101d90006 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -644,7 +644,9 @@ static struct cache_entry *__lookup_cache_entry(const char *path, unsigned int h
  *
  * Use whole path components in the match.  Must be called with htable_rw_lock held.
  *
+ * Return cached entry if successful.
  * Return ERR_PTR(-ENOENT) if the entry is not found.
+ * Return error ptr otherwise.
  */
 static struct cache_entry *lookup_cache_entry(const char *path)
 {
@@ -789,8 +791,13 @@ static struct cache_entry *cache_refresh_path(const unsigned int xid,
 	down_read(&htable_rw_lock);
 
 	ce = lookup_cache_entry(path);
-	if (!IS_ERR(ce) && !force_refresh && !cache_entry_expired(ce))
+	if (!IS_ERR(ce)) {
+		if (!force_refresh && !cache_entry_expired(ce))
+			return ce;
+	} else if (PTR_ERR(ce) != -ENOENT) {
+		up_read(&htable_rw_lock);
 		return ce;
+	}
 
 	/*
 	 * Unlock shared access as we don't want to hold any locks while getting
@@ -822,7 +829,7 @@ static struct cache_entry *cache_refresh_path(const unsigned int xid,
 			if (rc)
 				ce = ERR_PTR(rc);
 		}
-	} else {
+	} else if (PTR_ERR(ce) == -ENOENT) {
 		ce = add_cache_entry_locked(refs, numrefs);
 	}
 
-- 
2.39.0

