Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F03CDC4338F
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 02:36:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA0FC60FC4
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 02:36:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbhHJCgm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Aug 2021 22:36:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22705 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230048AbhHJCgm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 Aug 2021 22:36:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628562980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0nWhh5SSpoqlqMD+xY2IVz2KjKvPehpZDlTpX+Nh9m0=;
        b=AQLs60A5g/npQmrRlC5xyrbGBqjBLxgvSRE+c3swnozzXBN0nscgX/M9/AhrWHb+tAf5pd
        rqo0v/XFdDCtx79Y1xaTCD6GIwu+BFFiUQWEAA2NderDt0cUcjtjQpB869Nsgx1bD+HHw7
        e+BfF/NNA23tBONYKp+YkS/rHafClhg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-KWq51lILP-uV70f28GnJfA-1; Mon, 09 Aug 2021 22:36:18 -0400
X-MC-Unique: KWq51lILP-uV70f28GnJfA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 123EF1084F40;
        Tue, 10 Aug 2021 02:36:18 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-105.bne.redhat.com [10.64.54.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 395965B4BC;
        Tue, 10 Aug 2021 02:36:16 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: use the correct max-length for dentry_path_raw()
Date:   Tue, 10 Aug 2021 12:36:09 +1000
Message-Id: <20210810023609.710993-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

RHBZ: 1972502

PATH_MAX is 4096 but PAGE_SIZE can be >4096 on some architectures
such as ppc and would thus write beyond the end of the actual object.

CC: Stable <stable@vger.kernel.org>
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

