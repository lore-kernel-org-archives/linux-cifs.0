Return-Path: <SRS0=S2FA=RS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74AAFC43381
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Mar 2019 06:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5198521872
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Mar 2019 06:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbfCOGW1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 15 Mar 2019 02:22:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36810 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727179AbfCOGW0 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 15 Mar 2019 02:22:26 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A5FE03082DDD;
        Fri, 15 Mar 2019 06:22:26 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-111.bne.redhat.com [10.64.54.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0900619C56;
        Fri, 15 Mar 2019 06:22:25 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] smbinfo: add fsctl-getobjid support
Date:   Fri, 15 Mar 2019 16:22:15 +1000
Message-Id: <20190315062215.29499-2-lsahlber@redhat.com>
In-Reply-To: <20190315062215.29499-1-lsahlber@redhat.com>
References: <20190315062215.29499-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 15 Mar 2019 06:22:26 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This will print the ObjectID buffer for the object.
This is an example on how to fetch FSCTL data for an object using
the passthrough API.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 smbinfo.c   | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 smbinfo.rst |  2 ++
 2 files changed, 75 insertions(+)

diff --git a/smbinfo.c b/smbinfo.c
index 6b63f9d..215842c 100644
--- a/smbinfo.c
+++ b/smbinfo.c
@@ -39,6 +39,11 @@
 #include <inttypes.h>
 
 #define CIFS_IOCTL_MAGIC 0xCF
+
+/* query_info flags */
+#define PASSTHRU_QUERY_INFO     0x00000000
+#define PASSTHRU_FSCTL          0x00000001
+
 struct smb_query_info {
         uint32_t   info_type;
         uint32_t   file_info_class;
@@ -170,6 +175,72 @@ print_bits(uint32_t mask, struct bit_string *bs)
 }
 
 static void
+print_guid(uint8_t *sd)
+{
+	uint32_t u32;
+	uint16_t u16;
+	int i;
+
+	memcpy(&u32, &sd[0], 4);
+	printf("%08x-", le32toh(u32));
+
+	memcpy(&u16, &sd[4], 2);
+	printf("%04x-", le16toh(u16));
+
+	memcpy(&u16, &sd[6], 2);
+	printf("%04x-", le16toh(u16));
+
+	printf("%02x%02x-", sd[8], sd[9]);
+	for (i = 0; i < 6; i++)
+		printf("%02x", sd[10 + i]);
+}
+
+static void
+print_objidbuf(uint8_t *sd)
+{
+	printf("Object-ID: ");
+	print_guid(&sd[0]);
+	printf("\n");
+
+	printf("Birth-Volume-ID: ");
+	print_guid(&sd[16]);
+	printf("\n");
+
+	printf("Birth-Object-ID: ");
+	print_guid(&sd[32]);
+	printf("\n");
+
+	printf("Domain-ID: ");
+	print_guid(&sd[48]);
+	printf("\n");
+}
+
+static void
+fsctlgetobjid(int f)
+{
+	struct smb_query_info *qi;
+	struct stat st;
+
+	fstat(f, &st);
+
+	qi = malloc(sizeof(struct smb_query_info) + 64);
+	memset(qi, 0, sizeof(qi) + 64);
+	qi->info_type = 0x9009c;
+	qi->file_info_class = 0;
+	qi->additional_information = 0;
+	qi->input_buffer_length = 64;
+	qi->flags = PASSTHRU_FSCTL;
+
+	if (ioctl(f, CIFS_QUERY_INFO, qi) < 0) {
+		fprintf(stderr, "ioctl failed with %s\n", strerror(errno));
+		exit(1);
+	}
+	print_objidbuf((uint8_t *)(&qi[1]));
+
+	free(qi);
+}
+
+static void
 print_fileaccessinfo(uint8_t *sd, int type)
 {
         uint32_t access_flags;
@@ -951,6 +1022,8 @@ int main(int argc, char *argv[])
                 secdesc(f);
         else if (!strcmp(argv[optind], "quota"))
                 quota(f);
+        else if (!strcmp(argv[1], "fsctl-getobjid"))
+                fsctlgetobjid(f);
         else {
                 fprintf(stderr, "Unknown command %s\n", argv[optind]);
                 exit(1);
diff --git a/smbinfo.rst b/smbinfo.rst
index 9bfd313..fd7f0ff 100644
--- a/smbinfo.rst
+++ b/smbinfo.rst
@@ -62,6 +62,8 @@ COMMAND
 
 `filestandardinfo`: Prints the FileStandardInformation class
 
+`fsctl-getobjid`: Prints the ObjectID
+
 `quota`: Print the quota for the volume in the form
 - SID Length
 - Change Time
-- 
2.13.6

