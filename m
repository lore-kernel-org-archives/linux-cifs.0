Return-Path: <SRS0=Y/WD=DN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF99AC41604
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Oct 2020 05:26:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E47520870
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Oct 2020 05:26:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iv1TlRZH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgJFF0y (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Oct 2020 01:26:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55187 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725912AbgJFF0y (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Oct 2020 01:26:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601962013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=zvlwfGXcBK422+Q8iINBtZMI3UsLReypmtHnvwXCzJI=;
        b=iv1TlRZHP8jmrF9FRwwA2TEXuyEGQ4q3QuRytF1TER1XiTEuGELbm3PJVKdTbMtkrKfHVa
        o9qoCfC6ODazqp2x96myw6OknUZgjEL+HOVzQKk7zmZCtiqI8LMQygP7k8XHJY9I/KFn03
        2d7OAEbLYqe0zdE23tBTrX5jVUX7pr0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-aIYAOfjjPHy9gO0CgwoxVg-1; Tue, 06 Oct 2020 01:26:51 -0400
X-MC-Unique: aIYAOfjjPHy9gO0CgwoxVg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B77A10060C0;
        Tue,  6 Oct 2020 05:26:50 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-124.bne.redhat.com [10.64.54.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0854755789;
        Tue,  6 Oct 2020 05:26:49 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: handle -EINTR in cifs_setattr
Date:   Tue,  6 Oct 2020 15:26:43 +1000
Message-Id: <20201006052643.6298-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

RHBZ: 1848178

Some calls that set attributes, like utimensat(), are not supposed to return
-EINTR and thus do not have handlers for this in glibc which causes us
to leak -EINTR to the applications which are also unprepared to handle it.

For example tar will break if utimensat() return -EINTR and abort unpacking
the archive. Other applications may break too.

To handle this we add checks, and retry, for -EINTR in cifs_setattr()

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/inode.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 3989d08396ac..2dd6e7902ff4 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2879,13 +2879,18 @@ cifs_setattr(struct dentry *direntry, struct iattr *attrs)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
 	struct cifs_tcon *pTcon = cifs_sb_master_tcon(cifs_sb);
+	int rc, retries = 0;
 
-	if (pTcon->unix_ext)
-		return cifs_setattr_unix(direntry, attrs);
-
-	return cifs_setattr_nounix(direntry, attrs);
+	do {
+		if (pTcon->unix_ext)
+			rc = cifs_setattr_unix(direntry, attrs);
+		else
+			rc = cifs_setattr_nounix(direntry, attrs);
+		retries++;
+	} while (rc == -EINTR && retries < 4);
 
 	/* BB: add cifs_setattr_legacy for really old servers */
+	return rc;
 }
 
 #if 0
-- 
2.13.6

