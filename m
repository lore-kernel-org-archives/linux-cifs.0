Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0288EC433FE
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Oct 2022 22:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbiJKWHr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 Oct 2022 18:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJKWHq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 Oct 2022 18:07:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7DA4631C3
        for <linux-cifs@vger.kernel.org>; Tue, 11 Oct 2022 15:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665526063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XaGNY9O49GuSEJq54zhp/Z8SKLCfg08UbTR/W7valXg=;
        b=Xqwh63x52c78ThPuxsLZWWFAfMuj8rKNcYJg7hYwSfagb2zg69sdcd2NgZ0ixJFI4IuXAB
        aiOrpg1crVciNRcHwpLcerq7moVtBNFtSS95M+0Pxc3g/d3KZrg4LLMFmPbfO575peJjOY
        2/8uxCF8g8qAbAI99lg+03ObBFJ29Zg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-214-jYBHzlznNXWxdM-LXY_FbQ-1; Tue, 11 Oct 2022 18:07:40 -0400
X-MC-Unique: jYBHzlznNXWxdM-LXY_FbQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E73183C025CA;
        Tue, 11 Oct 2022 22:07:39 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-22.bne.redhat.com [10.64.52.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0578DC23F6F;
        Tue, 11 Oct 2022 22:07:38 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: fix skipping to incorrect offset in emit_cached_dirents
Date:   Wed, 12 Oct 2022 08:07:29 +1000
Message-Id: <20221011220729.1455757-2-lsahlber@redhat.com>
In-Reply-To: <20221011220729.1455757-1-lsahlber@redhat.com>
References: <20221011220729.1455757-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When application has done lseek() to a different offset on a directory fd
we skipped one entry too many before we start emitting directory entries
from the cache.

We need to also make sure that when we are starting to emit directory
entries from the cache, the ->pos sequence might have holes and skip
some indices.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/readdir.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 8e060c00c969..1bb4624e768b 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -844,17 +844,34 @@ static bool emit_cached_dirents(struct cached_dirents *cde,
 				struct dir_context *ctx)
 {
 	struct cached_dirent *dirent;
-	int rc;
+	bool rc;
 
 	list_for_each_entry(dirent, &cde->entries, entry) {
-		if (ctx->pos >= dirent->pos)
+		/*
+		 * Skip all early entries prior to the current lseek()
+		 * position.
+		 */
+		if (ctx->pos > dirent->pos)
 			continue;
+		/*
+		 * We recorded the current ->pos value for the dirent
+		 * when we stored it in the cache.
+		 * However, this sequence of ->pos values may have holes
+		 * in it, for example dot-dirs returned from the server
+		 * are suppressed.
+		 * Handle this bu forcing ctx->pos to be the same as the
+		 * ->pos of the current dirent we emit from the cache.
+		 * This means that when we emit these entries from the cache
+		 * we now emit them with the same ->pos value as in the
+		 * initial scan.
+		 */
 		ctx->pos = dirent->pos;
 		rc = dir_emit(ctx, dirent->name, dirent->namelen,
 			      dirent->fattr.cf_uniqueid,
 			      dirent->fattr.cf_dtype);
 		if (!rc)
 			return rc;
+		ctx->pos++;
 	}
 	return true;
 }
@@ -1202,10 +1219,10 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 				 ctx->pos, tmp_buf);
 			cifs_save_resume_key(current_entry, cifsFile);
 			break;
-		} else
-			current_entry =
-				nxt_dir_entry(current_entry, end_of_smb,
-					cifsFile->srch_inf.info_level);
+		}
+		current_entry =
+			nxt_dir_entry(current_entry, end_of_smb,
+				      cifsFile->srch_inf.info_level);
 	}
 	kfree(tmp_buf);
 
-- 
2.35.3

