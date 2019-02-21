Return-Path: <SRS0=RVJ6=Q4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D98C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 05:09:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A0C22086C
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 05:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbfBUFJ3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Feb 2019 00:09:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35942 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725648AbfBUFJ3 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 21 Feb 2019 00:09:29 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4D33481F25;
        Thu, 21 Feb 2019 05:09:29 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.76.1.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC82A1001DC5;
        Thu, 21 Feb 2019 05:09:27 +0000 (UTC)
From:   Kenneth D'souza <kdsouza@redhat.com>
To:     linux-cifs@vger.kernel.org
Cc:     piastryyy@gmail.com, smfrench@gmail.com
Subject: [PATCH] getcifsacl: Improve help usage and add -h option.
Date:   Thu, 21 Feb 2019 10:39:25 +0530
Message-Id: <20190221050925.17643-1-kdsouza@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 21 Feb 2019 05:09:29 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Call getcifsacl_usage only for -h and default case.
For others error out with appropriate message.

Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
---
 getcifsacl.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/getcifsacl.c b/getcifsacl.c
index 7f6e673..850a252 100644
--- a/getcifsacl.c
+++ b/getcifsacl.c
@@ -40,6 +40,7 @@
 
 static void *plugin_handle;
 static bool plugin_loaded;
+static char *execname;
 
 static void
 print_each_ace_mask(uint32_t mask)
@@ -331,6 +332,8 @@ getcifsacl_usage(const char *prog)
 		prog);
 	fprintf(stderr, "Usage: %s [option] <file_name>\n", prog);
 	fprintf(stderr, "Valid options:\n");
+	fprintf(stderr, "\t-h	Display this help text\n");
+	fprintf(stderr, "\n");
 	fprintf(stderr, "\t-v	Version of the program\n");
 	fprintf(stderr, "\n");
 	fprintf(stderr, "\t-r	Display raw values of the ACE fields\n");
@@ -345,8 +348,15 @@ main(const int argc, char *const argv[])
 	ssize_t attrlen;
 	size_t bufsize = BUFSIZE;
 	char *filename, *attrval;
+	execname = basename(argv[0]);
+
+        if (argc < 2) {
+                fprintf(stderr, "%s: you must specify a filename.\n", execname);
+                printf("Try `getcifsacl -h' for more information.\n");
+                goto out;
+        }
 
-	while ((c = getopt_long(argc, argv, "r:v", NULL, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "rhv", NULL, NULL)) != -1) {
 		switch (c) {
 		case 'v':
 			printf("Version: %s\n", VERSION);
@@ -355,18 +365,18 @@ main(const int argc, char *const argv[])
 			raw = true;
 			break;
 		default:
-			break;
+			getcifsacl_usage(execname);
+                        goto out;
+
 		}
 	}
 
-	if (raw && argc == 3)
-		filename = argv[2];
-	else if (argc == 2)
-		filename = argv[1];
-	else {
-		getcifsacl_usage(basename(argv[0]));
-		goto out;
-	}
+        if (optind >= argc) {
+               printf("you must specify a filename after options.\n");
+               printf("Usage: getcifsacl [option] <file_name>\n");
+                goto out;
+        } else
+              filename= argv[optind];
 
 	if (!raw && !plugin_loaded) {
 		ret = init_plugin(&plugin_handle);
-- 
2.20.1

