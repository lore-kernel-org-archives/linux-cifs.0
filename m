Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0D5DC433FE
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Oct 2022 06:46:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiJKGq3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 Oct 2022 02:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiJKGq0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 Oct 2022 02:46:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7FDA8993A
        for <linux-cifs@vger.kernel.org>; Mon, 10 Oct 2022 23:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665470784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tcpDoYjkxMpw3zSqw1xUo5hBl7+y2lJmV5AmHSqPdwI=;
        b=YHRhV47n4HA3wRcwjfWa1L5m2t5VW9Z6jgWL68T2r35ozSqmEDVmdWxL2cC+H3XRAh8Ejz
        miQWWEhPl/EIAr/xl2Yo37ezJcFcHBYUCeiGCo6cxS6z3AnkBJq+SSkvk3y/UhVMaH5WQl
        fhgVRjmzoBVsfWU9SlnGyN26B4cU5LQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-LDMf55Z7PnayFq7AKBBbrQ-1; Tue, 11 Oct 2022 02:46:22 -0400
X-MC-Unique: LDMf55Z7PnayFq7AKBBbrQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82206185A79C;
        Tue, 11 Oct 2022 06:46:22 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-22.bne.redhat.com [10.64.52.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 94A64200D8C2;
        Tue, 11 Oct 2022 06:46:21 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: fix skipping to incorrect offset in emit_cached_dirents
Date:   Tue, 11 Oct 2022 16:46:11 +1000
Message-Id: <20221011064611.1428646-2-lsahlber@redhat.com>
In-Reply-To: <20221011064611.1428646-1-lsahlber@redhat.com>
References: <20221011064611.1428646-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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
 fs/cifs/readdir.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 8e060c00c969..7170614434a1 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -847,14 +847,19 @@ static bool emit_cached_dirents(struct cached_dirents *cde,
 	int rc;
 
 	list_for_each_entry(dirent, &cde->entries, entry) {
-		if (ctx->pos >= dirent->pos)
+		if (ctx->pos > dirent->pos)
 			continue;
+		/*
+		 * There may be holes in the ->pos sequence
+		 * so always force ctx->pos to the current position.
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
@@ -1202,10 +1207,10 @@ int cifs_readdir(struct file *file, struct dir_context *ctx)
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

