Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0242EC433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Oct 2022 20:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiJJUnF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 10 Oct 2022 16:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiJJUnD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 10 Oct 2022 16:43:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C056E5E54D
        for <linux-cifs@vger.kernel.org>; Mon, 10 Oct 2022 13:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665434581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JGgEE9wfSSN3pMlDxNe54N/KrtlC6CS22MuYNZgiwvs=;
        b=AlmAShwWm2uA6++UxbDmhGNIx0G+FiQ3VD1H5c+o0AC/stjTfu6hpQmUy3UzQDympybefq
        qiV6Z5xyUFbeVx1rAI5ikm0uXsRMXoRTZ3Z7q19bRhyKbaKDhOPEWSbLAX3vzP2j/GG2zG
        p2xJjVc2X5B+5w0Wc6Kjp/WxYGMnkiI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-12-HPXX0oYEO7C_KZN4p-YMFg-1; Mon, 10 Oct 2022 16:42:59 -0400
X-MC-Unique: HPXX0oYEO7C_KZN4p-YMFg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7F06D185A794;
        Mon, 10 Oct 2022 20:42:59 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-22.bne.redhat.com [10.64.52.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93CBB14682C0;
        Mon, 10 Oct 2022 20:42:58 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: fix skipping to incorrect offset in emit_cached_dirents
Date:   Tue, 11 Oct 2022 06:42:50 +1000
Message-Id: <20221010204250.1411858-2-lsahlber@redhat.com>
In-Reply-To: <20221010204250.1411858-1-lsahlber@redhat.com>
References: <20221010204250.1411858-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When application has done lseek() to a different offset on a directory fd
we skipped one entry too many before we start emitting directory entries
from the cache.

Also change cifs_filldir() to return -EEXIST when we encouter a dot-directory in the
reply from the server. Check for this in the caller and skip caching the entry and
skip incprementing ctx->pos or else we end up emitting a sequence of directory entries with
holes in the ctx->pos space.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/readdir.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 8e060c00c969..0c71a771b256 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -847,14 +847,14 @@ static bool emit_cached_dirents(struct cached_dirents *cde,
 	int rc;
 
 	list_for_each_entry(dirent, &cde->entries, entry) {
-		if (ctx->pos >= dirent->pos)
+		if (ctx->pos > dirent->pos)
 			continue;
-		ctx->pos = dirent->pos;
 		rc = dir_emit(ctx, dirent->name, dirent->namelen,
 			      dirent->fattr.cf_uniqueid,
 			      dirent->fattr.cf_dtype);
 		if (!rc)
 			return rc;
+		ctx->pos++;
 	}
 	return true;
 }
@@ -965,7 +965,7 @@ static int cifs_filldir(char *find_entry, struct file *file,
 
 	/* skip . and .. since we added them first */
 	if (cifs_entry_is_dot(&de, file_info->srch_inf.unicode))
-		return 0;
+		return -EEXIST;
 
 	if (file_info->srch_inf.unicode) {
 		struct nls_table *nlt = cifs_sb->local_nls;
@@ -1183,6 +1183,17 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
 		*tmp_buf = 0;
 		rc = cifs_filldir(current_entry, file, ctx,
 				  tmp_buf, max_len, cfid);
+		/*
+		 * If we got a dot directory, just skip to the next entry.
+		 * We have already emitted it.
+		 */
+		if (rc == -EEXIST) {
+			current_entry =
+				nxt_dir_entry(current_entry, end_of_smb,
+					      cifsFile->srch_inf.info_level);
+			rc = 0;
+			continue;
+		}
 		if (rc) {
 			if (rc > 0)
 				rc = 0;
@@ -1202,10 +1213,10 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
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

