Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACBE8C433C1
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Mar 2021 06:27:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6377861A2C
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Mar 2021 06:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbhCYG06 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Mar 2021 02:26:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25496 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229533AbhCYG0t (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 25 Mar 2021 02:26:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616653608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zHyhmR/icVoFmSIPNM2iGf7TW5GUYPdgj9RfZ2NLn7o=;
        b=Vo4x6MK6jbVA1UFwoVmFZ0/h9BvxwEQibqTZfPW7vqGSOnrvGAMriFFXojue27FnSr+eHq
        GUhJviTIBUwZaPllLAo/cVMft8tTIZQKU5caTjPMdov3f60qa5vGbmkwlsZCdI/oKFp7xo
        gheKXtoA04zu5KxqU3+bH9yHxUa+L74=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-fdTiUxaVNXyndDphsronBA-1; Thu, 25 Mar 2021 02:26:43 -0400
X-MC-Unique: fdTiUxaVNXyndDphsronBA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3464612A1;
        Thu, 25 Mar 2021 06:26:42 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-17.bne.redhat.com [10.64.54.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3FC1763BA7;
        Thu, 25 Mar 2021 06:26:42 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: revalidate mapping when we open files for SMB1 POSIX
Date:   Thu, 25 Mar 2021 16:26:35 +1000
Message-Id: <20210325062635.43370-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

RHBZ: 1933527

Under SMB1 + POSIX, if an inode is reused on a server after we have read and
cached a part of a file, when we then open the new file with the
re-cycled inode there is a chance that we may serve the old data out of cache
to the application.
This only happens for SMB1 (deprecated) and when posix are used.
The simplest solution to avoid this race is to force a revalidate
on smb1-posix open.

 Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 26de4329d161..042e24aad410 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -165,6 +165,7 @@ int cifs_posix_open(char *full_path, struct inode **pinode,
 			goto posix_open_ret;
 		}
 	} else {
+		cifs_revalidate_mapping(*pinode);
 		cifs_fattr_to_inode(*pinode, &fattr);
 	}
 
-- 
2.29.2

