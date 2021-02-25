Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D17AC433DB
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 07:38:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD53364ECE
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 07:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbhBYHiU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Feb 2021 02:38:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39087 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234545AbhBYHiR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 25 Feb 2021 02:38:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614238597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=dSjFoylzCYKDhMZqdeFdao+Js7/2DD3LCCybC/Bb6ww=;
        b=fCPtS7Iima/WRK4nntYnf1fJyGendQXvYeJX2Pmzp0HCAy9pNyEPSeyfLVOjhUu9J44xNp
        NSLkp3MpK79EakCVo7pDZlZYYe+RucajbWnpHT2gnJ9c5ubsQoRn1Jo7GwgfxizVCtL0Ts
        Z18HW3U2eG3m6I3PWID+jyOLOb2F8YE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-FVKhR4GFOOGonMHVQyT7ig-1; Thu, 25 Feb 2021 02:36:36 -0500
X-MC-Unique: FVKhR4GFOOGonMHVQyT7ig-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2453D10CE79F;
        Thu, 25 Feb 2021 07:36:35 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-42.bne.redhat.com [10.64.54.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82641679F9;
        Thu, 25 Feb 2021 07:36:34 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH] cifs: fix handling of escaped ',' in the password mount argument
Date:   Thu, 25 Feb 2021 17:36:27 +1000
Message-Id: <20210225073627.32234-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Passwords can contain ',' which are also used as the separator between
mount options. Mount.cifs will escape all ',' characters as the string ",,".
Update parsing of the mount options to detect ",," and treat it as a single
'c' character.

Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/fs_context.c | 43 ++++++++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 14c955a30006..892f51a21278 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -544,20 +544,37 @@ static int smb3_fs_context_parse_monolithic(struct fs_context *fc,
 
 	/* BB Need to add support for sep= here TBD */
 	while ((key = strsep(&options, ",")) != NULL) {
-		if (*key) {
-			size_t v_len = 0;
-			char *value = strchr(key, '=');
-
-			if (value) {
-				if (value == key)
-					continue;
-				*value++ = 0;
-				v_len = strlen(value);
-			}
-			ret = vfs_parse_fs_string(fc, key, value, v_len);
-			if (ret < 0)
-				break;
+		size_t len;
+		char *value;
+
+		if (*key == 0)
+			break;
+
+		/* Check if following character is the deliminator If yes,
+		 * we have encountered a double deliminator reset the NULL
+		 * character to the deliminator
+		 */
+		while (options && options[0] == ',') {
+			len = strlen(key);
+			strcpy(key + len, options);
+			options = strchr(options, ',');
+			if (options)
+				*options++ = 0;
 		}
+
+
+		len = 0;
+		value = strchr(key, '=');
+		if (value) {
+			if (value == key)
+				continue;
+			*value++ = 0;
+			len = strlen(value);
+		}
+
+		ret = vfs_parse_fs_string(fc, key, value, len);
+		if (ret < 0)
+			break;
 	}
 
 	return ret;
-- 
2.13.6

