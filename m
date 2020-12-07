Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_TONAME_EQ_TOLOCAL_SHORT,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2173C4361B
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9418F23A21
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 23:41:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbgLGXlR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Dec 2020 18:41:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41034 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726708AbgLGXlR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Dec 2020 18:41:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607384391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=BAYJ0hGZ+4vF+u3dZ5kVuPr2jACFeTFGhqLynAHx6AE=;
        b=Xn/ieMABxV5DsJY6Pcnicj6UWyI4FchixvqeN0cUDYkqLJCcTDc94zq7PHVqpCkhcwI3XB
        tm526vUT3BXBk0vgR9xJhELWOtuAps1tqJ0Lu3DdCf3zYh/u2059JO2YstEUQ3FDwlq64Q
        32+Dl3JMhhhAdQ0zBH9yMG+JPlN3+IE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-lh_sp2GhO4OkYqyVCw7DcQ-1; Mon, 07 Dec 2020 18:39:47 -0500
X-MC-Unique: lh_sp2GhO4OkYqyVCw7DcQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77B6F193578E;
        Mon,  7 Dec 2020 23:39:46 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-107.bne.redhat.com [10.64.54.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0EEC60636;
        Mon,  7 Dec 2020 23:39:45 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 21/21] cifs: update mnt_cifs_flags during reconfigure
Date:   Tue,  8 Dec 2020 09:36:46 +1000
Message-Id: <20201207233646.29823-21-lsahlber@redhat.com>
In-Reply-To: <20201207233646.29823-1-lsahlber@redhat.com>
References: <20201207233646.29823-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/fs_context.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index bf5a25b930d5..cc750bb55223 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -704,6 +704,7 @@ static int smb3_reconfigure(struct fs_context *fc)
 
 	smb3_cleanup_fs_context_contents(cifs_sb->ctx);
 	rc = smb3_fs_context_dup(cifs_sb->ctx, ctx);
+	smb3_update_mnt_flags(cifs_sb);
 
 	return rc;
 }
-- 
2.13.6

