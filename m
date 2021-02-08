Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85926C433E0
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Feb 2021 06:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47E6E64E6F
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Feb 2021 06:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbhBHGuJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Feb 2021 01:50:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51074 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229745AbhBHGuJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Feb 2021 01:50:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612766923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=9Xew9XMFBorl+Ptih2sNqYULFMjTYm/HhGgtKxz2wUs=;
        b=I9T0xUssHRMQw4twLe8i+t2HPNUNbkcNNyIQpWgBAnhgK1YjgVEE/f4kJCqc9lRTolymJX
        teob/mUDdxfddNWxzsMORch1DLVHEfGaCMH3qp7ffGg9YLO05jgqWaToY2Cn2HM3jtr3Hw
        fk45A5WE7cjjib9XVwM9F3MM/w9prkQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-sadvkQIGP4ODpssffWuBjA-1; Mon, 08 Feb 2021 01:48:39 -0500
X-MC-Unique: sadvkQIGP4ODpssffWuBjA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4374F100A671;
        Mon,  8 Feb 2021 06:48:38 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-42.bne.redhat.com [10.64.54.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE45861D31;
        Mon,  8 Feb 2021 06:48:37 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: fix dfs-links
Date:   Mon,  8 Feb 2021 16:48:31 +1000
Message-Id: <20210208064831.19126-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This fixes a regression following dfs links that was introduced in the
patch series for the new mount api.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/connect.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 10fe6d6d2dee..76e4d8d8b3a6 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2983,6 +2983,14 @@ expand_dfs_referral(const unsigned int xid, struct cifs_ses *ses,
 			rc = PTR_ERR(mdata);
 			mdata = NULL;
 		} else {
+			/*
+			 * We can not clear out the whole structure since we
+			 * no longer have an explicit function to parse
+			 * a mount-string. Instead we need to clear out the
+			 * individual fields that are no longer valid.
+			 */
+			kfree(ctx->prepath);
+			ctx->prepath = NULL;
 			rc = cifs_setup_volume_info(ctx, mdata, fake_devname);
 		}
 		kfree(fake_devname);
-- 
2.13.6

