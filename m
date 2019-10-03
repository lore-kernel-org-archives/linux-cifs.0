Return-Path: <SRS0=2csP=X4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B706C10F14
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Oct 2019 23:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44D0C2133F
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Oct 2019 23:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729589AbfJCX3Y (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 3 Oct 2019 19:29:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59340 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727452AbfJCX3Y (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 3 Oct 2019 19:29:24 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 461DD308FE8F;
        Thu,  3 Oct 2019 23:29:24 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-57.bne.redhat.com [10.64.54.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C3FA600C4;
        Thu,  3 Oct 2019 23:29:23 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] smbinfo: Add SETCOMPRESSION support
Date:   Fri,  4 Oct 2019 09:29:02 +1000
Message-Id: <20191003232902.16332-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 03 Oct 2019 23:29:24 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 smbinfo.c   | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
 smbinfo.rst |  2 ++
 2 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/smbinfo.c b/smbinfo.c
index b4d497b..049a4f2 100644
--- a/smbinfo.c
+++ b/smbinfo.c
@@ -91,6 +91,8 @@ usage(char *name)
 		"      Prints the objectid of the file and GUID of the underlying volume.\n"
 		"  getcompression:\n"
 		"      Prints the compression setting for the file.\n"
+		"  setcompression <no|default|lznt1>:\n"
+		"      Sets the compression level for the file.\n"
 		"  list-snapshots:\n"
 		"      List the previous versions of the volume that backs this file.\n"
 		"  quota:\n"
@@ -299,6 +301,30 @@ getcompression(int f)
 }
 
 static void
+setcompression(int f, uint16_t level)
+{
+	struct smb_query_info *qi;
+
+	qi = malloc(sizeof(struct smb_query_info) + 2);
+	memset(qi, 0, sizeof(qi) + 2);
+	qi->info_type = 0x9c040;
+	qi->file_info_class = 0;
+	qi->additional_information = 0;
+	qi->output_buffer_length = 2;
+	qi->flags = PASSTHRU_FSCTL;
+
+	level = htole16(level);
+	memcpy(&qi[1], &level, 2);
+
+	if (ioctl(f, CIFS_QUERY_INFO, qi) < 0) {
+		fprintf(stderr, "ioctl failed with %s\n", strerror(errno));
+		exit(1);
+	}
+
+	free(qi);
+}
+
+static void
 print_fileaccessinfo(uint8_t *sd, int type)
 {
 	uint32_t access_flags;
@@ -1126,17 +1152,35 @@ list_snapshots(int f)
 	free(buf);
 }
 
+static int
+parse_compression(const char *arg)
+{
+	if (!strcmp(arg, "no"))
+		return 0;
+	else if (!strcmp(arg, "default"))
+		return 1;
+	else if (!strcmp(arg, "lznt1"))
+		return 2;
+
+	fprintf(stderr, "compression must be no|default|lznt1\n");
+	exit(10);
+}
+
 int main(int argc, char *argv[])
 {
 	int c;
 	int f;
+	int compression = 1;
 
 	if (argc < 2) {
 		short_usage(argv[0]);
 	}
 
-	while ((c = getopt_long(argc, argv, "vVh", NULL, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "c:vVh", NULL, NULL)) != -1) {
 		switch (c) {
+		case 'c':
+			compression = parse_compression(optarg);
+			break;
 		case 'v':
 			printf("smbinfo version %s\n", VERSION);
 			return 0;
@@ -1183,6 +1227,8 @@ int main(int argc, char *argv[])
 		fsctlgetobjid(f);
 	else if (!strcmp(argv[optind], "getcompression"))
 		getcompression(f);
+	else if (!strcmp(argv[optind], "setcompression"))
+		setcompression(f, compression);
 	else if (!strcmp(argv[optind], "list-snapshots"))
 		list_snapshots(f);
 	else if (!strcmp(argv[optind], "quota"))
diff --git a/smbinfo.rst b/smbinfo.rst
index 500ce0e..c8f76e6 100644
--- a/smbinfo.rst
+++ b/smbinfo.rst
@@ -69,6 +69,8 @@ COMMAND
 
 `getcompression`: Prints the compression setting for the file.
 
+`setcompression -c <no|default|lznt1>`: Sets the compression setting for the file.
+
 `list-snapshots`: Lists the previous versions of the volume that backs this file
 
 `quota`: Print the quota for the volume in the form
-- 
2.13.6

