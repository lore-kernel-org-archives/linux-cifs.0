Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8DD7C4338F
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Aug 2021 19:57:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8871160F57
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Aug 2021 19:57:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbhHMT5a (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 13 Aug 2021 15:57:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57318 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230440AbhHMT53 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 13 Aug 2021 15:57:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628884622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AZO4nTptl+VPjFOwlGk9SKl7xgeGnnWcS0pDF8pDuZE=;
        b=ZOi2lXth7Vv9lHbBHLFznY1sV/k2b3gdvCudiJObUhHjseLOSVyyZyKZZse+jqr+ii/zlV
        zhxqGzvC0JbLx8xwAj5QdCGEO4jtpR6/nGx1Zia7aQuBG8aP866z+g9sH7hfSCvPbxphP9
        8u1ISlvLBbPaXQVyy1DXz+R+JKTA/us=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-jBf88iseMa-JBpMdwclqRw-1; Fri, 13 Aug 2021 15:57:00 -0400
X-MC-Unique: jBf88iseMa-JBpMdwclqRw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A65101082921;
        Fri, 13 Aug 2021 19:56:59 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-114.bne.redhat.com [10.64.54.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9AF885DA61;
        Fri, 13 Aug 2021 19:56:58 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 2/3] cifs: move calc_lanman_hash to smb1ops.c
Date:   Sat, 14 Aug 2021 05:56:43 +1000
Message-Id: <20210813195644.937810-3-lsahlber@redhat.com>
In-Reply-To: <20210813195644.937810-1-lsahlber@redhat.com>
References: <20210813195644.937810-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is only used by SMB1 so lets move it to smb1ops which is conditionally
compiled in depending on CIFS_ALLOW_INSECURE_LEGACY

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsencrypt.c | 42 ------------------------------------------
 fs/cifs/smb1ops.c     | 42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index ecf15d845dbd..79572d18ad7a 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -289,48 +289,6 @@ int setup_ntlm_response(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	return rc;
 }
 
-#ifdef CONFIG_CIFS_WEAK_PW_HASH
-int calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
-			char *lnm_session_key)
-{
-	int i, len;
-	int rc;
-	char password_with_pad[CIFS_ENCPWD_SIZE] = {0};
-
-	if (password) {
-		for (len = 0; len < CIFS_ENCPWD_SIZE; len++)
-			if (!password[len])
-				break;
-
-		memcpy(password_with_pad, password, len);
-	}
-
-	if (!encrypt && global_secflags & CIFSSEC_MAY_PLNTXT) {
-		memcpy(lnm_session_key, password_with_pad,
-			CIFS_ENCPWD_SIZE);
-		return 0;
-	}
-
-	/* calculate old style session key */
-	/* calling toupper is less broken than repeatedly
-	calling nls_toupper would be since that will never
-	work for UTF8, but neither handles multibyte code pages
-	but the only alternative would be converting to UCS-16 (Unicode)
-	(using a routine something like UniStrupr) then
-	uppercasing and then converting back from Unicode - which
-	would only worth doing it if we knew it were utf8. Basically
-	utf8 and other multibyte codepages each need their own strupper
-	function since a byte at a time will ont work. */
-
-	for (i = 0; i < CIFS_ENCPWD_SIZE; i++)
-		password_with_pad[i] = toupper(password_with_pad[i]);
-
-	rc = SMBencrypt(password_with_pad, cryptkey, lnm_session_key);
-
-	return rc;
-}
-#endif /* CIFS_WEAK_PW_HASH */
-
 /* Build a proper attribute value/target info pairs blob.
  * Fill in netbios and dns domain name and workstation name
  * and client time (total five av pairs and + one end of fields indicator.
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 3b83839fc2c2..eef378055a24 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -14,6 +14,48 @@
 #include "cifs_unicode.h"
 #include "fs_context.h"
 
+#ifdef CONFIG_CIFS_WEAK_PW_HASH
+int calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
+			char *lnm_session_key)
+{
+	int i, len;
+	int rc;
+	char password_with_pad[CIFS_ENCPWD_SIZE] = {0};
+
+	if (password) {
+		for (len = 0; len < CIFS_ENCPWD_SIZE; len++)
+			if (!password[len])
+				break;
+
+		memcpy(password_with_pad, password, len);
+	}
+
+	if (!encrypt && global_secflags & CIFSSEC_MAY_PLNTXT) {
+		memcpy(lnm_session_key, password_with_pad,
+			CIFS_ENCPWD_SIZE);
+		return 0;
+	}
+
+	/* calculate old style session key */
+	/* calling toupper is less broken than repeatedly
+	calling nls_toupper would be since that will never
+	work for UTF8, but neither handles multibyte code pages
+	but the only alternative would be converting to UCS-16 (Unicode)
+	(using a routine something like UniStrupr) then
+	uppercasing and then converting back from Unicode - which
+	would only worth doing it if we knew it were utf8. Basically
+	utf8 and other multibyte codepages each need their own strupper
+	function since a byte at a time will ont work. */
+
+	for (i = 0; i < CIFS_ENCPWD_SIZE; i++)
+		password_with_pad[i] = toupper(password_with_pad[i]);
+
+	rc = SMBencrypt(password_with_pad, cryptkey, lnm_session_key);
+
+	return rc;
+}
+#endif /* CIFS_WEAK_PW_HASH */
+
 /*
  * An NT cancel request header looks just like the original request except:
  *
-- 
2.30.2

