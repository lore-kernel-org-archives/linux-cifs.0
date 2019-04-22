Return-Path: <SRS0=FjIb=SY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9B28C282E1
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Apr 2019 05:53:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA34720693
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Apr 2019 05:53:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfDVFxq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Apr 2019 01:53:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11925 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbfDVFxq (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 22 Apr 2019 01:53:46 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D7982C04F4AC;
        Mon, 22 Apr 2019 05:53:45 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.76.1.80])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC66B1001E69;
        Mon, 22 Apr 2019 05:53:44 +0000 (UTC)
From:   Kenneth D'souza <kdsouza@redhat.com>
To:     linux-cifs@vger.kernel.org
Cc:     piastryyy@gmail.com
Subject: [PATCH] getcifsacl: Add support for -R(recursive) option.
Date:   Mon, 22 Apr 2019 11:23:41 +0530
Message-Id: <20190422055341.27727-1-kdsouza@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Mon, 22 Apr 2019 05:53:45 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add support for -R option so we can list the ACLs of all files and
directories recursively.

Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
---
 getcifsacl.c      | 32 +++++++++++++++++++++++++++-----
 getcifsacl.rst.in |  3 +++
 2 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/getcifsacl.c b/getcifsacl.c
index bea81ee..74f38a3 100644
--- a/getcifsacl.c
+++ b/getcifsacl.c
@@ -37,10 +37,12 @@
 #include <sys/xattr.h>
 #include "cifsacl.h"
 #include "idmap_plugin.h"
+#include <ftw.h>
 
 static void *plugin_handle;
 static bool plugin_loaded;
 static char *execname;
+static bool raw = false;
 
 static void
 print_each_ace_mask(uint32_t mask)
@@ -336,12 +338,14 @@ getcifsacl_usage(const char *prog)
 	fprintf(stderr, "\n");
 	fprintf(stderr, "\t-v	Version of the program\n");
 	fprintf(stderr, "\n");
+	fprintf(stderr, "\t-R 	recurse into subdirectories\n");
+	fprintf(stderr, "\n");
 	fprintf(stderr, "\t-r	Display raw values of the ACE fields\n");
 	fprintf(stderr, "\nRefer to getcifsacl(1) manpage for details\n");
 }
 
 static void
-getcifsacl(const char *filename, bool raw)
+getcifsacl(const char *filename)
 {
 	ssize_t attrlen;
 	size_t bufsize = BUFSIZE;
@@ -381,12 +385,21 @@ cifsacl:
 	free(attrval);
 }
 
+static int recursive(const char *filename, const struct stat *sb, int tflag, struct FTW *ftwbuf)
+{
+	(void)sb;
+	(void)tflag;
+	(void)ftwbuf;
+        getcifsacl(filename);
+        return 0;
+}
+
 int
 main(const int argc, char *const argv[])
 {
 	int c, ret = 0;
-	bool raw = false;
 	execname = basename(argv[0]);
+	int do_recursive = 0;
 
 	if (argc < 2) {
 		fprintf(stderr, "%s: you must specify a filename.\n", execname);
@@ -394,7 +407,7 @@ main(const int argc, char *const argv[])
 		goto out;
 	}
 
-	while ((c = getopt_long(argc, argv, "rhv", NULL, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "Rrhv", NULL, NULL)) != -1) {
 		switch (c) {
 		case 'v':
 			printf("Version: %s\n", VERSION);
@@ -402,6 +415,9 @@ main(const int argc, char *const argv[])
 		case 'r':
 			raw = true;
 			break;
+		case 'R':
+			do_recursive = 1;
+                        break;
 		default:
 			getcifsacl_usage(execname);
 			goto out;
@@ -423,8 +439,14 @@ main(const int argc, char *const argv[])
 			plugin_loaded = true;
 	}
 
-	for(; optind < argc; optind++)
-		getcifsacl(argv[optind], raw);
+	for(; optind < argc; optind++) {
+		if(do_recursive) {
+			if (nftw(argv[optind], recursive, 20, 0) == -1)
+				fprintf(stderr, "Invalid filename %s: %s\n", argv[optind], strerror(errno));
+		}
+		else
+			getcifsacl(argv[optind]);
+	}
 
 out:
 	if (plugin_loaded)
diff --git a/getcifsacl.rst.in b/getcifsacl.rst.in
index 21a10cd..ffde968 100644
--- a/getcifsacl.rst.in
+++ b/getcifsacl.rst.in
@@ -43,6 +43,9 @@ OPTIONS
   flags are displayed in hexadecimal format, a SID is not mapped to a
   name.
 
+-R
+  List the ACLs of all files and directories recursively.
+
 *****
 NOTES
 *****
-- 
2.20.1

