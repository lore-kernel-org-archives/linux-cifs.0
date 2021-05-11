Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F09BAC43460
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 16:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4A736187E
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 16:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhEKQlQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 May 2021 12:41:16 -0400
Received: from mx.cjr.nz ([51.158.111.142]:35050 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231407AbhEKQlQ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 11 May 2021 12:41:16 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 2F43D7FEDB;
        Tue, 11 May 2021 16:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1620751208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=J6nyce18u+laffOjUs6pQ820VZpdsqTd68pK6l+t9Ds=;
        b=UKLxxynlfbX1aVbg4Gy+Vd9kO7HbQmHrSjQ3bsuSWeW9CCVu0fD0tt2BzVXKhumCxAccD/
        Xqypl2CbNM9IanumHoz40wc2Jz66ylSfMgUP9wA2idiQ3ahI6cvLfQg2w7PqRmFmvjfjdx
        yihrg1m7WDfLNM97ugjklLwKnNvg1PuKFbTtnSI6zanQjOqNrc8OQ/H2xYdWr7Df2ycXKK
        oGz6AIjcz18k9p9hkGm6APv0HkpFNt8FtCmRBBz5vjkL4EuhLhDsdqVwLTP8bJ6c8fngzG
        wF2SPn+h+PbfMzvzGZSHJCA58BUIXZ+P5FlC4zAH9OR5r18BjjhOosL4OpzzFQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, piastryyy@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH cifs-utils] mount.cifs: handle multiple ip addresses per hostname
Date:   Tue, 11 May 2021 13:39:52 -0300
Message-Id: <20210511163952.11670-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Support passing multiple 'ip=' options to specify all ip addresses a
server name was resolved to.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 mount.cifs.c   | 44 ++++++++++++++++++++------------------------
 mount.cifs.rst |  8 ++++----
 2 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index 7f898bbd215a..988e56b649a2 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -2036,6 +2036,21 @@ restore_privs:
 	return rc;
 }
 
+static void set_ip_params(char *options, size_t options_size, char *addrlist)
+{
+	char *s = addrlist + strlen(addrlist), *q = s;
+	char tmp;
+
+	do {
+		for (; s >= addrlist && *s != ','; s--);
+		tmp = *q;
+		*q = '\0';
+		strlcat(options, *options ? ",ip=" : "ip=", options_size);
+		strlcat(options, s + 1, options_size);
+		*q = tmp;
+	} while (q = s--, s >= addrlist);
+}
+
 int main(int argc, char **argv)
 {
 	int c;
@@ -2043,7 +2058,6 @@ int main(int argc, char **argv)
 	char *mountpoint = NULL;
 	char *options = NULL;
 	char *orig_dev = NULL;
-	char *currentaddress, *nextaddress;
 	char *value = NULL;
 	char *ep = NULL;
 	int rc = 0;
@@ -2201,20 +2215,10 @@ assemble_retry:
 			goto mount_exit;
 	}
 
-	currentaddress = parsed_info->addrlist;
-	nextaddress = strchr(currentaddress, ',');
-	if (nextaddress)
-		*nextaddress++ = '\0';
-
 mount_retry:
 	options[0] = '\0';
-	if (!currentaddress) {
-		fprintf(stderr, "Unable to find suitable address.\n");
-		rc = parsed_info->nofail ? 0 : EX_FAIL;
-		goto mount_exit;
-	}
-	strlcpy(options, "ip=", options_size);
-	strlcat(options, currentaddress, options_size);
+
+	set_ip_params(options, options_size, parsed_info->addrlist);
 
 	strlcat(options, ",unc=\\\\", options_size);
 	strlcat(options, parsed_info->host, options_size);
@@ -2266,17 +2270,9 @@ mount_retry:
 		switch (errno) {
 		case ECONNREFUSED:
 		case EHOSTUNREACH:
-			if (currentaddress) {
-				fprintf(stderr, "mount error(%d): could not connect to %s",
-					errno, currentaddress);
-			}
-			currentaddress = nextaddress;
-			if (currentaddress) {
-				nextaddress = strchr(currentaddress, ',');
-				if (nextaddress)
-					*nextaddress++ = '\0';
-			}
-			goto mount_retry;
+			fprintf(stderr, "mount error(%d): could not connect to: %s", errno, parsed_info->addrlist);
+			rc = parsed_info->nofail ? 0 : EX_FAIL;
+			break;
 		case ENODEV:
 			fprintf(stderr,
 				"mount error: %s filesystem not supported by the system\n", cifs_fstype);
diff --git a/mount.cifs.rst b/mount.cifs.rst
index 9d4446f035b6..89fb5c902f79 100644
--- a/mount.cifs.rst
+++ b/mount.cifs.rst
@@ -166,10 +166,10 @@ dir_mode=arg
   If the server does not support the CIFS Unix extensions this overrides
   the default mode for directories.
 
-ip=arg|addr=arg
-  sets the destination IP address. This option is set automatically if
-  the server name portion of the requested UNC name can be resolved so
-  rarely needs to be specified by the user.
+ip=arg|addr=arg[,ip=arg2|addr=arg2,...]
+  Sets a maximum number of 16 destination IP addresses. This option is
+  set automatically if the server name portion of the requested UNC
+  name can be resolved so rarely needs to be specified by the user.
 
 domain=arg|dom=arg|workgroup=arg
   Sets the domain (workgroup) of the user. If no domains are given,
-- 
2.31.1

