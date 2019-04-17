Return-Path: <SRS0=xEhF=ST=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78380C282DA
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Apr 2019 17:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 516912064A
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Apr 2019 17:19:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732321AbfDQRTQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Apr 2019 13:19:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37810 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729395AbfDQRTP (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 17 Apr 2019 13:19:15 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 78987F74D4;
        Wed, 17 Apr 2019 17:19:15 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-59.sin2.redhat.com [10.67.116.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E8B660C66;
        Wed, 17 Apr 2019 17:19:12 +0000 (UTC)
From:   Kenneth D'souza <kdsouza@redhat.com>
To:     linux-cifs@vger.kernel.org
Cc:     piastryyy@gmail.com
Subject: [PATCH] getcifsacl: Add support to accept more paths
Date:   Wed, 17 Apr 2019 22:49:09 +0530
Message-Id: <20190417171909.803-1-kdsouza@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Wed, 17 Apr 2019 17:19:15 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Accept more than one path on the getcifsacl command line.

Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
---
 getcifsacl.c | 82 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 46 insertions(+), 36 deletions(-)

diff --git a/getcifsacl.c b/getcifsacl.c
index fc78881..df3099d 100644
--- a/getcifsacl.c
+++ b/getcifsacl.c
@@ -340,14 +340,54 @@ getcifsacl_usage(const char *prog)
 	fprintf(stderr, "\nRefer to getcifsacl(1) manpage for details\n");
 }
 
+static void
+getcifsacl(const char *filename , bool raw)
+{
+	ssize_t attrlen;
+	size_t bufsize = BUFSIZE;
+        char *attrval;
+        int failed = 0;
+cifsacl:
+	if (bufsize >= XATTR_SIZE_MAX) {
+		printf("buffer to allocate exceeds max size of %d\n",
+				XATTR_SIZE_MAX);
+		exit(1);
+	}
+
+	attrval = malloc(bufsize * sizeof(char));
+	if (!attrval) {
+		printf("error allocating memory for attribute value buffer\n");
+		exit(1);
+	}
+
+	attrlen = getxattr(filename, ATTRNAME, attrval, bufsize);
+	if (attrlen == -1) {
+		if (errno == ERANGE) {
+			free(attrval);
+			bufsize += BUFSIZE;
+			goto cifsacl;
+                } else
+                {
+                  fprintf(stderr, "Failed to getxattr %s: %s\n", filename, strerror(errno) );
+                    failed = -1;
+                }
+        }
+
+        if (failed == 0)
+        {
+        printf("# filename: %s\n", filename);
+        parse_sec_desc((struct cifs_ntsd *)attrval, attrlen, raw);
+	printf("\n");
+        }
+        free(attrval);
+
+}
+
 int
 main(const int argc, char *const argv[])
 {
 	int c, ret = 0;
 	bool raw = false;
-	ssize_t attrlen;
-	size_t bufsize = BUFSIZE;
-	char *filename, *attrval;
 	execname = basename(argv[0]);
 
 	if (argc < 2) {
@@ -374,8 +414,7 @@ main(const int argc, char *const argv[])
 		printf("you must specify a filename after options.\n");
 		printf("Usage: getcifsacl [option] <file_name>\n");
 		goto out;
-	} else
-		filename = argv[optind];
+	}
 
 	if (!raw && !plugin_loaded) {
 		ret = init_plugin(&plugin_handle);
@@ -386,38 +425,9 @@ main(const int argc, char *const argv[])
 			plugin_loaded = true;
 	}
 
-cifsacl:
-	if (bufsize >= XATTR_SIZE_MAX) {
-		printf("buffer to allocate exceeds max size of %d\n",
-				XATTR_SIZE_MAX);
-		ret = -1;
-		goto out;
-	}
-
-	attrval = malloc(bufsize * sizeof(char));
-	if (!attrval) {
-		printf("error allocating memory for attribute value buffer\n");
-		ret = -1;
-		goto out;
-	}
-
-	attrlen = getxattr(filename, ATTRNAME, attrval, bufsize);
-	if (attrlen == -1) {
-		if (errno == ERANGE) {
-			free(attrval);
-			bufsize += BUFSIZE;
-			goto cifsacl;
-		} else {
-			fprintf(stderr, "getxattr failed on %s: %s\n", filename, strerror(errno) );
-			free(attrval);
-			ret = -1;
-			goto out;
-		}
-	}
-
-	parse_sec_desc((struct cifs_ntsd *)attrval, attrlen, raw);
+	for(; optind < argc; optind++)
+		getcifsacl(argv[optind], raw);
 
-	free(attrval);
 out:
 	if (plugin_loaded)
 		exit_plugin(plugin_handle);
-- 
2.20.1

