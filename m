Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 582FDC433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Nov 2021 08:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32F1E61106
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Nov 2021 08:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhKDIhQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Nov 2021 04:37:16 -0400
Received: from alderaan.xwing.info ([79.137.33.81]:57592 "EHLO
        alderaan.xwing.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbhKDIhP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Nov 2021 04:37:15 -0400
Received: from bespin.vpn.xwing.info (143.90.7.93.rev.sfr.net [93.7.90.143])
        by alderaan.xwing.info (Postfix) with ESMTPSA id 18130101894;
        Thu,  4 Nov 2021 09:34:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=xwing.info; s=mail;
        t=1636014877; bh=23RUryggb1Sa1Dh9llTOr4L7jY0/dBdkqIe3k7d02To=;
        h=From:To:Cc:Subject:Date;
        b=kHH9wmnT3uJE+cB8svyTTo91RpN5X79347xp7PnFLoom6CElhxoEX5qePq4sIbkmU
         6IU3iSLKnYAwZEhmwtNyU45WNCRy7cInlSi5Zpu2nKFmGOMVuBOFpjvMRvn4QsMYxv
         MPJMbdGlBq1cI0/E+bR2A7X4Ig4V4CYiQtH8YxV0=
From:   Guillaume Castagnino <casta@xwing.info>
To:     linux-cifs@vger.kernel.org
Cc:     Guillaume Castagnino <casta@xwing.info>
Subject: [PATCH v2] ksmbd-tools: Standardize exit codes
Date:   Thu,  4 Nov 2021 09:34:32 +0100
Message-Id: <20211104083432.14666-1-casta@xwing.info>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In case of success, EXIT_SUCCESS must be returned by the control binary
This standard behaviour is expected for example for the unit file
Standardize failure codes instead of returning directly function error
code

Signed-off-by: Guillaume Castagnino <casta@xwing.info>
---
 control/control.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/control/control.c b/control/control.c
index 5b86355..780a48a 100644
--- a/control/control.c
+++ b/control/control.c
@@ -38,12 +38,12 @@ static int ksmbd_control_shutdown(void)
 	fd = open("/sys/class/ksmbd-control/kill_server", O_WRONLY);
 	if (fd < 0) {
 		pr_err("open failed: %d\n", errno);
-		return fd;
+		return EXIT_FAILURE;
 	}
 
 	ret = write(fd, "hard", 4);
 	close(fd);
-	return ret;
+	return ret != -1 ? EXIT_SUCCESS : EXIT_FAILURE;
 }
 
 static int ksmbd_control_show_version(void)
@@ -54,14 +54,14 @@ static int ksmbd_control_show_version(void)
 	fd = open("/sys/module/ksmbd/version", O_RDONLY);
 	if (fd < 0) {
 		pr_err("open failed: %d\n", errno);
-		return fd;
+		return EXIT_FAILURE;
 	}
 
 	ret = read(fd, ver, 255);
 	close(fd);
 	if (ret != -1)
 		pr_info("ksmbd version : %s\n", ver);
-	return ret;
+	return ret != -1 ? EXIT_SUCCESS : EXIT_FAILURE;
 }
 
 static int ksmbd_control_debug(char *comp)
@@ -72,7 +72,7 @@ static int ksmbd_control_debug(char *comp)
 	fd = open("/sys/class/ksmbd-control/debug", O_RDWR);
 	if (fd < 0) {
 		pr_err("open failed: %d\n", errno);
-		return fd;
+		return EXIT_FAILURE;
 	}
 
 	ret = write(fd, comp, strlen(comp));
@@ -85,7 +85,7 @@ static int ksmbd_control_debug(char *comp)
 	pr_info("%s\n", buf);
 out:
 	close(fd);
-	return ret;
+	return ret != -1 ? EXIT_SUCCESS : EXIT_FAILURE;
 }
 
 int main(int argc, char *argv[])
@@ -104,7 +104,7 @@ int main(int argc, char *argv[])
 	while ((c = getopt(argc, argv, "sd:cVh")) != EOF)
 		switch (c) {
 		case 's':
-			ksmbd_control_shutdown();
+			ret = ksmbd_control_shutdown();
 			break;
 		case 'd':
 			ret = ksmbd_control_debug(optarg);
-- 
2.33.1

