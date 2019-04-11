Return-Path: <SRS0=pabO=SN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E41F5C10F14
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Apr 2019 02:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCB872075B
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Apr 2019 02:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfDKCXR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Apr 2019 22:23:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52717 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbfDKCXR (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 10 Apr 2019 22:23:17 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 213DEDA314;
        Thu, 11 Apr 2019 02:23:17 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-110.bne.redhat.com [10.64.54.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D45D19C6F;
        Thu, 11 Apr 2019 02:23:16 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 2/2] smbinfo: Add SETCOMPRESSION support
Date:   Thu, 11 Apr 2019 12:23:07 +1000
Message-Id: <20190411022307.26463-3-lsahlber@redhat.com>
In-Reply-To: <20190411022307.26463-1-lsahlber@redhat.com>
References: <20190411022307.26463-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 11 Apr 2019 02:23:17 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 smbinfo.c   | 28 ++++++++++++++++++++++++++++
 smbinfo.rst |  5 +++++
 2 files changed, 33 insertions(+)

diff --git a/smbinfo.c b/smbinfo.c
index db569b2..b87cca4 100644
--- a/smbinfo.c
+++ b/smbinfo.c
@@ -89,6 +89,8 @@ usage(char *name)
 		"      Prints the objectid of the file and GUID of the underlying volume.\n"
 		"  getcompression:\n"
 		"      Prints the compression setting for the file.\n"
+		"  setcompression <0|1|2>:\n"
+		"      Sets the compression level for the file.\n"
 		"  list-snapshots:\n"
 		"      List the previous versions of the volume that backs this file.\n"
 		"  quota:\n"
@@ -289,6 +291,30 @@ getcompression(int f)
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
@@ -1166,6 +1192,8 @@ int main(int argc, char *argv[])
 		fsctlgetobjid(f);
 	else if (!strcmp(argv[optind], "getcompression"))
 		getcompression(f);
+	else if (!strcmp(argv[optind], "setcompression"))
+		setcompression(f, strtol(argv[optind + 2], NULL, 10));
 	else if (!strcmp(argv[optind], "list-snapshots"))
 		list_snapshots(f);
 	else if (!strcmp(argv[optind], "quota"))
diff --git a/smbinfo.rst b/smbinfo.rst
index ca99b07..af97b7f 100644
--- a/smbinfo.rst
+++ b/smbinfo.rst
@@ -66,6 +66,11 @@ COMMAND
 
 `getcompression`: Prints the compression setting for the file.
 
+`setcompression <0|1|2>`: Sets the compression setting for the file.
+- 0 No compression
+- 1 Default compression
+- 2 LZNT1
+
 `list-snapshots`: Lists the previous versions of the volume that backs this file
 
 `quota`: Print the quota for the volume in the form
-- 
2.13.6

