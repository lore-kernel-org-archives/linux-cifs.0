Return-Path: <SRS0=pabO=SN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ED97C10F14
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Apr 2019 02:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1619B2075B
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Apr 2019 02:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfDKCXP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Apr 2019 22:23:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42724 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbfDKCXP (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 10 Apr 2019 22:23:15 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5C1773168914;
        Thu, 11 Apr 2019 02:23:15 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-110.bne.redhat.com [10.64.54.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B75FEBA4A;
        Thu, 11 Apr 2019 02:23:14 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 1/2] smbinfo: add GETCOMPRESSION support
Date:   Thu, 11 Apr 2019 12:23:06 +1000
Message-Id: <20190411022307.26463-2-lsahlber@redhat.com>
In-Reply-To: <20190411022307.26463-1-lsahlber@redhat.com>
References: <20190411022307.26463-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 11 Apr 2019 02:23:15 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 smbinfo.c   | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 smbinfo.rst |  2 ++
 2 files changed, 50 insertions(+)

diff --git a/smbinfo.c b/smbinfo.c
index 4bc503a..db569b2 100644
--- a/smbinfo.c
+++ b/smbinfo.c
@@ -87,6 +87,8 @@ usage(char *name)
 		"      Prints FileStandardInfo for a cifs file.\n"
 		"  fsctl-getobjid:\n"
 		"      Prints the objectid of the file and GUID of the underlying volume.\n"
+		"  getcompression:\n"
+		"      Prints the compression setting for the file.\n"
 		"  list-snapshots:\n"
 		"      List the previous versions of the volume that backs this file.\n"
 		"  quota:\n"
@@ -243,6 +245,50 @@ fsctlgetobjid(int f)
 }
 
 static void
+print_getcompression(uint8_t *sd)
+{
+	uint16_t u16;
+
+	memcpy(&u16, &sd[0], 2);
+	u16 = le16toh(u16);
+
+	printf("Compression: ");
+	switch (u16) {
+	case 0:
+		printf("(0) NONE\n");
+		break;
+	case 2:
+		printf("(2) LZNT1\n");
+		break;
+	default:
+		printf("(%d) UNKNOWN\n", u16);
+		break;
+	}
+}
+
+static void
+getcompression(int f)
+{
+	struct smb_query_info *qi;
+
+	qi = malloc(sizeof(struct smb_query_info) + 2);
+	memset(qi, 0, sizeof(qi) + 2);
+	qi->info_type = 0x9003c;
+	qi->file_info_class = 0;
+	qi->additional_information = 0;
+	qi->input_buffer_length = 2;
+	qi->flags = PASSTHRU_FSCTL;
+
+	if (ioctl(f, CIFS_QUERY_INFO, qi) < 0) {
+		fprintf(stderr, "ioctl failed with %s\n", strerror(errno));
+		exit(1);
+	}
+	print_getcompression((uint8_t *)(&qi[1]));
+
+	free(qi);
+}
+
+static void
 print_fileaccessinfo(uint8_t *sd, int type)
 {
 	uint32_t access_flags;
@@ -1118,6 +1164,8 @@ int main(int argc, char *argv[])
 		filestandardinfo(f);
 	else if (!strcmp(argv[optind], "fsctl-getobjid"))
 		fsctlgetobjid(f);
+	else if (!strcmp(argv[optind], "getcompression"))
+		getcompression(f);
 	else if (!strcmp(argv[optind], "list-snapshots"))
 		list_snapshots(f);
 	else if (!strcmp(argv[optind], "quota"))
diff --git a/smbinfo.rst b/smbinfo.rst
index 0c96050..ca99b07 100644
--- a/smbinfo.rst
+++ b/smbinfo.rst
@@ -64,6 +64,8 @@ COMMAND
 
 `fsctl-getobjid`: Prints the ObjectID
 
+`getcompression`: Prints the compression setting for the file.
+
 `list-snapshots`: Lists the previous versions of the volume that backs this file
 
 `quota`: Print the quota for the volume in the form
-- 
2.13.6

