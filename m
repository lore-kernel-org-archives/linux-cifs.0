Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_TONAME_EQ_TOLOCAL_SHORT,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A8FEC1B0D8
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 06:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3669B22583
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 06:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438794AbgLNGm0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Dec 2020 01:42:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35655 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2438787AbgLNGm0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 14 Dec 2020 01:42:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607928060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=XhcC3OU08WU4RxtHzw8d6PE90hPmKBy4P2ISa+oxGzA=;
        b=b6HazmGN+OooSYWph2mO9F2nk+bzQ3NMttjTjiQ1p7TDZae0EZNEFXAyfQRa/mdnY3KhuJ
        1Tjl8gsk8cTKuC+/8cdCW6f7TA2rafrwiXv+UPVN3Aew4wQuMbQhde+GXtT21eeLmBzogB
        vie29NutQ84nWo9e7GxErFvb6wAnpyI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-qzmA1lp9NuOObadELIpUnA-1; Mon, 14 Dec 2020 01:40:58 -0500
X-MC-Unique: qzmA1lp9NuOObadELIpUnA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E2A9EA0CA1;
        Mon, 14 Dec 2020 06:40:57 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-107.bne.redhat.com [10.64.54.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 470C628557;
        Mon, 14 Dec 2020 06:40:56 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 11/12] cifs: update mnt_cifs_flags during reconfigure
Date:   Mon, 14 Dec 2020 16:40:26 +1000
Message-Id: <20201214064027.2885-11-lsahlber@redhat.com>
In-Reply-To: <20201214064027.2885-1-lsahlber@redhat.com>
References: <20201214064027.2885-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/fs_context.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index c1e53121526d..84a86e91127b 100644
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

