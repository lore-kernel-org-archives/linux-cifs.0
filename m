Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80448C07E9A
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Jul 2021 02:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6020B611F1
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Jul 2021 02:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhGMCZ7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 12 Jul 2021 22:25:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35803 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229521AbhGMCZ6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 12 Jul 2021 22:25:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626142989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rREf1uQMGwD0I6konrXWhgHtOvwPNsWqq3guFpoW5h4=;
        b=H0AfDimT6LT7HTh/gUhoRwCptEmGb5rEQx4im4ezzSJoq/rBkqZvMwvi9amRj33S8XAr5r
        ouK0kPPC4wi49x9QvfFnwGYVwufs6ihgeS826eskUCebynwOFyYMLdWeb9c3KNFataiGkx
        1XcMy3LdryJxHmECdWfxNiOpD9fumko=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-xC1Z6i5lPn6fr7vX_j2zWQ-1; Mon, 12 Jul 2021 22:23:07 -0400
X-MC-Unique: xC1Z6i5lPn6fr7vX_j2zWQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47D1518D6A25;
        Tue, 13 Jul 2021 02:23:06 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-39.bne.redhat.com [10.64.54.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B56111893C;
        Tue, 13 Jul 2021 02:23:05 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: Do not use the original cruid when following DFS links for multiuser mounts
Date:   Tue, 13 Jul 2021 12:22:59 +1000
Message-Id: <20210713022259.2968733-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=213565

cruid should only be used for the initial mount and after this we should use the current
users credentials.
Ignore the original cruid mount argument when creating a new context for a multiuser mount
following a DFS link.

Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
Cc: stable@vger.kernel.org # 5.11
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifs_dfs_ref.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index ec57cdb1590f..5c9a8778c99d 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -208,6 +208,10 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
 		else
 			noff = tkn_e - (sb_mountdata + off) + 1;
 
+		if (strncasecmp(sb_mountdata + off, "cruid=", 6) == 0) {
+			off += noff;
+			continue;
+		}
 		if (strncasecmp(sb_mountdata + off, "unc=", 4) == 0) {
 			off += noff;
 			continue;
-- 
2.30.2

