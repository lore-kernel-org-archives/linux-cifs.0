Return-Path: <SRS0=e9ua=QV=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98158C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Feb 2019 11:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6277A222B6
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Feb 2019 11:15:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405053AbfBNLPs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Feb 2019 06:15:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:45880 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731242AbfBNLPs (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 14 Feb 2019 06:15:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E91EAAAA9;
        Thu, 14 Feb 2019 11:15:46 +0000 (UTC)
From:   Aurelien Aptel <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
Cc:     piastryyy@gmail.com, Aurelien Aptel <aaptel@suse.com>
Subject: [cifs-utils PATCH v1] mount.cifs: be more verbose and helpful regarding mount errors
Date:   Thu, 14 Feb 2019 12:15:44 +0100
Message-Id: <20190214111544.24253-1-aaptel@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 mount.cifs.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index ae7a899..9370f2e 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -2099,6 +2099,10 @@ mount_retry:
 		switch (errno) {
 		case ECONNREFUSED:
 		case EHOSTUNREACH:
+			if (currentaddress) {
+				fprintf(stderr, "mount error(%d): could not connect to %s",
+					errno, currentaddress);
+			}
 			currentaddress = nextaddress;
 			if (currentaddress) {
 				nextaddress = strchr(currentaddress, ',');
@@ -2110,6 +2114,12 @@ mount_retry:
 			fprintf(stderr,
 				"mount error: %s filesystem not supported by the system\n", cifs_fstype);
 			break;
+		case EHOSTDOWN:
+			fprintf(stderr,
+				"mount error: Server abruptly closed the connection.\n"
+				"This can happen if the server does not support the SMB version you are trying to use.\n"
+				"The default SMB version recently changed from SMB1 to SMB2.1 and above. Try mounting with vers=1.0.\n");
+			break;
 		case ENXIO:
 			if (!already_uppercased &&
 			    uppercase_string(parsed_info->host) &&
@@ -2126,7 +2136,7 @@ mount_retry:
 			strerror(errno));
 		fprintf(stderr,
 			"Refer to the %s(8) manual page (e.g. man "
-			"%s)\n", thisprogram, thisprogram);
+			"%s) and kernel log messages (dmesg)\n", thisprogram, thisprogram);
 		rc = EX_FAIL;
 		goto mount_exit;
 	}
-- 
2.16.4

