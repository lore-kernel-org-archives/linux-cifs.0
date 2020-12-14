Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C34B7C1B0D8
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 06:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8977E225A9
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 06:42:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbgLNGmJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Dec 2020 01:42:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21338 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2438782AbgLNGmJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 14 Dec 2020 01:42:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607928043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=Q2EbUnmYufQyRNu8arCrSK+lGVrZXidyDAaFQFTdD3I=;
        b=RZzE7yHe+puW6Rr97t3nico2cIyOTFCksXmbcRmoZdLOV5YVPU/RSuPbD+ugUYiX1G8gR7
        x7g8z7DqKHBY3TVWCvTzKUbeKGOQSErpI7hCvpSX5Q2J+fJmsX7hkl3DLsLu4Nkm7qbTBD
        0g35kBEBxg8b26iMTQFTrsIp5E9VcQA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-JYAbWmw1Odyl7_rCDoNGHQ-1; Mon, 14 Dec 2020 01:40:41 -0500
X-MC-Unique: JYAbWmw1Odyl7_rCDoNGHQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4B25809DC3;
        Mon, 14 Dec 2020 06:40:40 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-107.bne.redhat.com [10.64.54.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2DFA660C05;
        Mon, 14 Dec 2020 06:40:39 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 08/12] cifs: do not allow changing posix_paths during remount
Date:   Mon, 14 Dec 2020 16:40:23 +1000
Message-Id: <20201214064027.2885-8-lsahlber@redhat.com>
In-Reply-To: <20201214064027.2885-1-lsahlber@redhat.com>
References: <20201214064027.2885-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/fs_context.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 40a5cfe0615b..4995082b7285 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -626,6 +626,10 @@ static void smb3_fs_context_free(struct fs_context *fc)
 static int smb3_verify_reconfigure_ctx(struct smb3_fs_context *new_ctx,
 				       struct smb3_fs_context *old_ctx)
 {
+	if (new_ctx->posix_paths != old_ctx->posix_paths) {
+		cifs_dbg(VFS, "can not change posixpaths during remount\n");
+		return -EINVAL;
+	}
 	if (new_ctx->sectype != old_ctx->sectype) {
 		cifs_dbg(VFS, "can not change sec during remount\n");
 		return -EINVAL;
-- 
2.13.6

