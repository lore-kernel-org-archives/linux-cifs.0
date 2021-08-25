Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D01C4338F
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Aug 2021 11:17:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4CF861101
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Aug 2021 11:17:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239653AbhHYLSA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 Aug 2021 07:18:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37642 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236038AbhHYLSA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 25 Aug 2021 07:18:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629890234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7C5UPnjzd5QEjPD0ohZJ4AG/I3BjTd/5koe2L1q6/N8=;
        b=ML4eOiCRsKOjNxZ8rqBp9HZMf6+Mrs6KHcQqJhzyKvVdZ+o65LOczqtERhdJpSa01yXYaC
        37pLLWI9Il+D6jB+TgNcIFQ5Z2gHJpNl3U4fYXmkbjqsgIJDwxkC6GXffGPoUbbIFoZ0DZ
        TzuM0hMCh9mGJNZmQ2NariGiZpmpLA8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-9tY5QAusMcu3JKfPTQDBLw-1; Wed, 25 Aug 2021 07:17:11 -0400
X-MC-Unique: 9tY5QAusMcu3JKfPTQDBLw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E6A5801A92;
        Wed, 25 Aug 2021 11:17:10 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-114.bne.redhat.com [10.64.54.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CD075F724;
        Wed, 25 Aug 2021 11:17:08 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: Do not leak EDEADLK to dgetents64 for STATUS_USER_SESSION_DELETED
Date:   Wed, 25 Aug 2021 21:16:56 +1000
Message-Id: <20210825111656.1635954-2-lsahlber@redhat.com>
In-Reply-To: <20210825111656.1635954-1-lsahlber@redhat.com>
References: <20210825111656.1635954-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

RHBZ: 1994393

If we hit a STATUS_USER_SESSION_DELETED for the Create part in the
Create/QueryDirectory compound that starts a directory scan
we will leak EDEADLK back to userspace and surprise glibc and the application.

Pick this up initiate_cifs_search() and retry a small number of tries before we
return an error to userspace.

Cc: stable@vger.kernel.org
Reported-by: Xiaoli Feng <xifeng@redhat.com>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/readdir.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index bfee176b901d..4518e3ca64df 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -369,7 +369,7 @@ int get_symlink_reparse_path(char *full_path, struct cifs_sb_info *cifs_sb,
  */
 
 static int
-initiate_cifs_search(const unsigned int xid, struct file *file,
+_initiate_cifs_search(const unsigned int xid, struct file *file,
 		     const char *full_path)
 {
 	__u16 search_flags;
@@ -451,6 +451,23 @@ initiate_cifs_search(const unsigned int xid, struct file *file,
 	return rc;
 }
 
+static int
+initiate_cifs_search(const unsigned int xid, struct file *file,
+		     const char *full_path)
+{
+	int rc, retry_count = 0;
+
+	do {
+		rc = _initiate_cifs_search(xid, file, full_path);
+		/*
+		 * We don't have enough credits to start reading the
+		 * directory so just try again.
+		 */
+	} while (rc == -EDEADLK && retry_count++ < 5);
+
+	return rc;
+}
+
 /* return length of unicode string in bytes */
 static int cifs_unicode_bytelen(const char *str)
 {
-- 
2.30.2

