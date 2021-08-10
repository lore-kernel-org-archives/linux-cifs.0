Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 520CDC4338F
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 06:34:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22C2260E9B
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 06:34:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhHJGej (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Aug 2021 02:34:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30819 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229459AbhHJGej (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 10 Aug 2021 02:34:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628577256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hojzk0zeEhbULOpCcg+qe2MBidy33TFFW9PMc15rFLc=;
        b=bUho/PbM+hgzQjrSkx/HOXbAOcUp0qu5BWY5YlKnledDmC/NU8FyaEKefvNL2o1Ic4NMnj
        eI19y7G2qyzY94ueLfVNW1IuElPdYSUrg6IjrUFMvwU0eFYRjVfbiXmpE0a0E7VhJ/ujUz
        nWGgl8bcxAF5hxjnwM1GmBPaIhpfPGI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-l8_RJ5RmPTqNtrfP09__Sg-1; Tue, 10 Aug 2021 02:34:03 -0400
X-MC-Unique: l8_RJ5RmPTqNtrfP09__Sg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2A95100F764;
        Tue, 10 Aug 2021 06:34:02 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-105.bne.redhat.com [10.64.54.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A7541B4B8;
        Tue, 10 Aug 2021 06:34:01 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: use the correct max-length for dentry_path_raw()
Date:   Tue, 10 Aug 2021 16:33:55 +1000
Message-Id: <20210810063355.721945-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

RHBZ: 1972502

PATH_MAX is 4096 but PAGE_SIZE can be >4096 on some architectures
such as ppc and would thus write beyond the end of the actual object.

CC: Stable <stable@vger.kernel.org>
Reported-by: Xiaoli Feng <xifeng@redhat.com>
Suggested-by: Brian foster <bfoster@redhat.com>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 79402ca0ddfa..5f8a302ffcb2 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -100,7 +100,7 @@ build_path_from_dentry_optional_prefix(struct dentry *direntry, void *page,
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_USE_PREFIX_PATH)
 		pplen = cifs_sb->prepath ? strlen(cifs_sb->prepath) + 1 : 0;
 
-	s = dentry_path_raw(direntry, page, PAGE_SIZE);
+	s = dentry_path_raw(direntry, page, PATH_MAX);
 	if (IS_ERR(s))
 		return s;
 	if (!s[1])	// for root we want "", not "/"
-- 
2.30.2

