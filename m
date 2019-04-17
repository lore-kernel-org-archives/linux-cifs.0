Return-Path: <SRS0=xEhF=ST=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C51DC10F12
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Apr 2019 10:06:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7533220835
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Apr 2019 10:06:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729563AbfDQKGt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Apr 2019 06:06:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36163 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727312AbfDQKGs (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 17 Apr 2019 06:06:48 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D8DEC3082263;
        Wed, 17 Apr 2019 10:06:48 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.76.1.1])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CBB8819C58;
        Wed, 17 Apr 2019 10:06:47 +0000 (UTC)
From:   Kenneth D'souza <kdsouza@redhat.com>
To:     linux-cifs@vger.kernel.org
Cc:     piastryyy@gmail.com
Subject: [PATCH] smbinfo: Improve help usage and add -h option.
Date:   Wed, 17 Apr 2019 15:36:46 +0530
Message-Id: <20190417100646.14547-1-kdsouza@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 17 Apr 2019 10:06:48 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Call usage only for -h case. This avoids cluttering the screen with long
help output.
As we are adding more options to the utility, the end error is just hidden.
Call short_usage wherever necessary.

Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
---
 smbinfo.c   | 27 ++++++++++++++++++++++-----
 smbinfo.rst |  5 ++++-
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/smbinfo.c b/smbinfo.c
index 4bc503a..8c8f43f 100644
--- a/smbinfo.c
+++ b/smbinfo.c
@@ -64,6 +64,8 @@ usage(char *name)
 {
 	fprintf(stderr, "Usage: %s [-V] <command> <file>\n"
 		"-V for verbose output\n"
+		"-h display this help text\n"
+		"-v print smbinfo version\n"
 		"Commands are\n"
 		"  fileaccessinfo:\n"
 		"      Prints FileAccessInfo for a cifs file.\n"
@@ -97,6 +99,14 @@ usage(char *name)
 	exit(1);
 }
 
+static void
+short_usage(char *name)
+{
+	fprintf(stderr, "Usage: %s [-v] [-V] <command> <file>\n"
+               "Try 'smbinfo -h' for more information.\n", name);
+                exit(1);
+}
+
 static void
 win_to_timeval(uint64_t smb2_time, struct timeval *tv)
 {
@@ -1075,7 +1085,11 @@ int main(int argc, char *argv[])
 	int c;
 	int f;
 
-	while ((c = getopt_long(argc, argv, "vV", NULL, NULL)) != -1) {
+	if (argc < 2) {
+		short_usage(argv[0]);
+	}
+
+	while ((c = getopt_long(argc, argv, "vVh", NULL, NULL)) != -1) {
 		switch (c) {
 		case 'v':
 			printf("smbinfo version %s\n", VERSION);
@@ -1083,15 +1097,18 @@ int main(int argc, char *argv[])
 		case 'V':
 			verbose = 1;
 			break;
-		default:
+		case 'h':
 			usage(argv[0]);
+			break;
+		default:
+			short_usage(argv[0]);
 		}
 	}
 
-	if (optind >= argc - 1)
-		usage(argv[0]);
+	if (optind >= argc -1)
+		short_usage(argv[0]);
 
-	if ((f = open(argv[optind + 1], O_RDONLY)) < 0) {
+	if ((f = open(argv[optind + 1 ], O_RDONLY)) < 0) {
 		fprintf(stderr, "Failed to open %s\n", argv[optind + 1]);
 		exit(1);
 	}
diff --git a/smbinfo.rst b/smbinfo.rst
index 0c96050..be4c829 100644
--- a/smbinfo.rst
+++ b/smbinfo.rst
@@ -11,7 +11,7 @@ Userspace helper to display SMB-specific file information for the Linux SMB clie
 SYNOPSIS
 ********
 
-  smbinfo [-v] [-V] {command} {file system object}
+  smbinfo [-v] [-h] [-V] {command} {file system object}
 
 ***********
 DESCRIPTION
@@ -38,6 +38,9 @@ OPTIONS
 -V
   Verbose output.
 
+-h
+  Print help explaining the command line options.
+
 *******
 COMMAND
 *******
-- 
2.20.1

