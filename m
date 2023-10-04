Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F87EE936E1
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Oct 2023 20:28:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbjJDU2x (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233332AbjJDU2x (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 Oct 2023 16:28:53 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE08AD
        for <linux-cifs@vger.kernel.org>; Wed,  4 Oct 2023 13:28:49 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1696451327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/UaWqEfzxhl1jXhFCGXq6JpTDmUFK6Ykq/+fJkcj5+8=;
        b=o/dAQKBK9uxpcVItY8rsl9enIUz3Sq2ZOPly+lgJJBSPXdZ5q4QJs41B6a3tCu/IG4hl0K
        3Eena3h1le7NZxigIdBVqDZzIIMuMQ7uroz94/VBpIyRueIBZA7hv4xfIHMT4hqbR7cFLi
        p12XnZ0A89rXj1DXoheyoMICCYwTHhDO52am4Jf/OkIN7ArBe9E1d2zUyAtEBusiVJ5PIT
        mTPcxvbYAMSQfskw+2+YJN3KALwmDAj+7hpV6g4XFIXj63T/uh0JO+N6dvv4rNuM9FNlnB
        V7kPN6RGp1U47rYmF9XIHvkFYgKKiOJdF624z5EtsVjOuuFLymZT2aKEMP1DPQ==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1696451327; a=rsa-sha256;
        cv=none;
        b=pfL0lTihEBlYa1usRBhqLZK+SaWwOwLgCBuP0/VcHB02vpL2g9Lg+sqnsK4+EVxM6zdXfU
        zzsyE/YSihtuLAnQU2McdjX7DoejhdrqjgYuA2EuIM8APEhnRwAmlardb4xzulDa7XbbWo
        pgcYtmr9MtsVsaSikR/yYc6Sxd2plw/9TjrhFhQAlwT9KMIY4iblDQjBE/VUyHPvQruBaU
        2bFp/CSGkbSFUzKHox7TaooYHlYOi5+xyKLW8hyN7SCBEe6ebv3yscM8ybOlq+Ec6STzMm
        6c82buhvxbetiSQ0ecYTxByex32BOYVYZbFAU3XmDJ9BxTszgcTv+6xefx6btg==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1696451327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/UaWqEfzxhl1jXhFCGXq6JpTDmUFK6Ykq/+fJkcj5+8=;
        b=CRUrRyP+dR57rq7M2H4tGeoB6yYtYixR2ii7ilnRsyEgnsUZMhNqnKIKb6wxLsM2NZ5pVh
        1hxH6Itr7erVf6v+P5vuY0XymQ3EXfxfGfR018fANaCFVbnY26R/BLQDZs/s5m07lgpnJe
        ECqGcwTe5DdCmCmHdFXYoiiy7RM8bN2IoARTYawyiOUJMglGBhj+wFLBwAFf7ffQnQmvo5
        JTpFeizSm1SA9LE5d7qIIAUpvOr1f6I9530N2Y1NsfGT+baMfHLjv2W4gCMyK3Y8mde1GV
        d8zTrlhsbI0pAj6y7Olqo4NItVe+SjIJU8/JLxFsYHEQIzIUcszNzfbCKyVjPg==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH] smb: client: do not start laundromat thread on nohandlecache
Date:   Wed,  4 Oct 2023 17:28:38 -0300
Message-ID: <20231004202838.10757-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Honor 'nohandlecache' mount option by not starting laundromat thread
even when SMB server supports directory leases.

Fixes: 2da338ff752a ("smb3: do not start laundromat thread when dir leases  disabled")
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/connect.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index ce11165446cf..7b923e36501b 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2474,8 +2474,9 @@ cifs_put_tcon(struct cifs_tcon *tcon)
 static struct cifs_tcon *
 cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 {
+	struct cifs_tcon *tcon;
+	bool nohandlecache;
 	int rc, xid;
-	struct cifs_tcon *tcon;
 
 	tcon = cifs_find_tcon(ses, ctx);
 	if (tcon) {
@@ -2493,14 +2494,17 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 		goto out_fail;
 	}
 
-	if (ses->server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEASING)
-		tcon = tcon_info_alloc(true);
+	if (ses->server->dialect >= SMB20_PROT_ID &&
+	    (ses->server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEASING))
+		nohandlecache = ctx->nohandlecache;
 	else
-		tcon = tcon_info_alloc(false);
+		nohandlecache = true;
+	tcon = tcon_info_alloc(!nohandlecache);
 	if (tcon == NULL) {
 		rc = -ENOMEM;
 		goto out_fail;
 	}
+	tcon->nohandlecache = nohandlecache;
 
 	if (ctx->snapshot_time) {
 		if (ses->server->vals->protocol_id == 0) {
@@ -2662,10 +2666,6 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 	tcon->nocase = ctx->nocase;
 	tcon->broken_sparse_sup = ctx->no_sparse;
 	tcon->max_cached_dirs = ctx->max_cached_dirs;
-	if (ses->server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEASING)
-		tcon->nohandlecache = ctx->nohandlecache;
-	else
-		tcon->nohandlecache = true;
 	tcon->nodelete = ctx->nodelete;
 	tcon->local_lease = ctx->local_lease;
 	INIT_LIST_HEAD(&tcon->pending_opens);
-- 
2.42.0

