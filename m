Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA8EEC43461
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 16:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 784856117A
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 16:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbhEKQho (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 May 2021 12:37:44 -0400
Received: from mx.cjr.nz ([51.158.111.142]:34592 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231230AbhEKQho (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 11 May 2021 12:37:44 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 41B597FEDB;
        Tue, 11 May 2021 16:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1620750995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Bac684D1TZwPny4epI0ci7Qpd8YH0kIM6iUGm/1STk=;
        b=KBBYfpRjpJJ0VY7JFOAIv2NZqCJIhj6fduCn83OFPA+4yg8RE8qjxtQfFRmmwW5Hitg4QN
        fYazIdcextrZBC2Uh0pmK4vi7Ib3dcacaf3yMFQJEnefcnuF1vi7oAQO2tJReF/eBuk7mi
        aKdry2+biH4AmW1lo0scNvCIU4necvE8Kpio/dwIkrwq0wJOT9eY5/i+FR6M2LczHoK4bh
        SCSnEGSn6yyPCQIQw6PuMlY8WK7y1P8dP7WvoAScZ6M4KfPYkY7yDj2psZzV+PXuKY0ZQ3
        hJWGdYL4DuFE3OKjzVg/E61luCRGcVLbcY1kaczRBKNBRDjv2z17U+UzjJ10RQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 3/3] cifs: fix find_root_ses() when refresing dfs cache
Date:   Tue, 11 May 2021 13:36:09 -0300
Message-Id: <20210511163609.11019-4-pc@cjr.nz>
In-Reply-To: <20210511163609.11019-1-pc@cjr.nz>
References: <20210511163609.11019-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

get_tcp_server() and cifs_get_smb_ses() require most of the fs context
info in order to find the respective tcp and ses pointers, so before
calling them, dup original fs context and set new unc path with
cifs_setup_volume_info().

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/dfs_cache.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
index 5c3129d4af1d..972aba397fdb 100644
--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -1430,6 +1430,12 @@ static struct cifs_ses *find_root_ses(struct vol_info *vi,
 	if (IS_ERR(rpath))
 		return ERR_CAST(rpath);
 
+	rc = smb3_fs_context_dup(&ctx, &vi->ctx);
+	if (rc) {
+		ses = ERR_PTR(rc);
+		goto out;
+	}
+
 	down_read(&htable_rw_lock);
 
 	ce = lookup_cache_entry(rpath, NULL);
-- 
2.31.1

