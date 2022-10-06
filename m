Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 980C3C433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Oct 2022 04:36:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiJFEgj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 Oct 2022 00:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiJFEg0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 Oct 2022 00:36:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686F8606AD
        for <linux-cifs@vger.kernel.org>; Wed,  5 Oct 2022 21:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665030984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j48MCdQCLMMAWnoLvoqO0CE61Ao1b77BAcRJKtt9Pa0=;
        b=h58s0XzVKrxXS5G5ZTt3b/x9Za0e3BjNHdSo785H2wqR3EoiRm+bKr54Z2TgDSvvZXU+VC
        yzcWxFEorAdxfzgv3ibN3Ed/6Sn2loogDYah3LA0fJaPCt9XcF8VZ8lO4qeCRH9y8MGGwu
        SieADahSDaDKul/TiZmgfU7pTGA306Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-416-cm9mAIxNNQG2qDL48TgTAw-1; Thu, 06 Oct 2022 00:36:21 -0400
X-MC-Unique: cm9mAIxNNQG2qDL48TgTAw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F04DA85A583;
        Thu,  6 Oct 2022 04:36:20 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-22.bne.redhat.com [10.64.52.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4839549BB67;
        Thu,  6 Oct 2022 04:36:19 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: fix skipping to incorrect offset in emit_cached_dirents
Date:   Thu,  6 Oct 2022 14:36:09 +1000
Message-Id: <20221006043609.1193398-2-lsahlber@redhat.com>
In-Reply-To: <20221006043609.1193398-1-lsahlber@redhat.com>
References: <20221006043609.1193398-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When application has done lseek() to a different offset on a directory fd
we skipped one entry too many before we start emitting directory entries
from the cache.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/readdir.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 8e060c00c969..da0d1e188432 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -847,9 +847,13 @@ static bool emit_cached_dirents(struct cached_dirents *cde,
 	int rc;
 
 	list_for_each_entry(dirent, &cde->entries, entry) {
-		if (ctx->pos >= dirent->pos)
+		/*
+		 * Skip ahead until we get to the current position of the
+		 * directory.
+		 */
+		if (ctx->pos > dirent->pos)
 			continue;
-		ctx->pos = dirent->pos;
+
 		rc = dir_emit(ctx, dirent->name, dirent->namelen,
 			      dirent->fattr.cf_uniqueid,
 			      dirent->fattr.cf_dtype);
-- 
2.35.3

