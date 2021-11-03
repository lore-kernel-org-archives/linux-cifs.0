Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D718C433F5
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Nov 2021 15:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04A0A6109F
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Nov 2021 15:17:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhKCPTg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Nov 2021 11:19:36 -0400
Received: from alderaan.xwing.info ([79.137.33.81]:57584 "EHLO
        alderaan.xwing.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbhKCPTf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 Nov 2021 11:19:35 -0400
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Nov 2021 11:19:35 EDT
Received: from bespin.vpn.xwing.info (143.90.7.93.rev.sfr.net [93.7.90.143])
        by alderaan.xwing.info (Postfix) with ESMTPSA id 9F4FA100049;
        Wed,  3 Nov 2021 16:10:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=xwing.info; s=mail;
        t=1635952231; bh=5CM+tNlkzEY+MeZpOT7YxUJ1LtY9wpShiIiQmROSEMw=;
        h=From:To:Cc:Subject:Date;
        b=bugCZdubkJjwv09omvQQrs/0/6mXtjMnV9wLc9Wdo2c7CKtSR2EIwtt1nTazJb2HZ
         ps0xEa43ZKe6bitynDvJerOFx0bxpaMvMO7e3TJBLhkTXDHE3ASSC+Y4aXZ15mv1vp
         uVSFRwLfbBJF2D4pDtCHJQw/QYtArnWoWcxT1ioc=
From:   Guillaume Castagnino <casta@xwing.info>
To:     linux-cifs@vger.kernel.org
Cc:     Guillaume Castagnino <casta@xwing.info>
Subject: [PATCH] ksmbd-tools: Standardize exit codes
Date:   Wed,  3 Nov 2021 16:10:18 +0100
Message-Id: <20211103151018.172802-1-casta@xwing.info>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In case of success, EXIT_SUCCESS must be returned by the control binary
This standard behaviour is expected for example for the unit file

Signed-off-by: Guillaume Castagnino <casta@xwing.info>
---
 control/control.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/control/control.c b/control/control.c
index 5b86355..5ff2780 100644
--- a/control/control.c
+++ b/control/control.c
@@ -43,7 +43,7 @@ static int ksmbd_control_shutdown(void)
 
 	ret = write(fd, "hard", 4);
 	close(fd);
-	return ret;
+	return ret != -1 ? EXIT_SUCCESS : EXIT_FAILURE;
 }
 
 static int ksmbd_control_show_version(void)
@@ -61,7 +61,7 @@ static int ksmbd_control_show_version(void)
 	close(fd);
 	if (ret != -1)
 		pr_info("ksmbd version : %s\n", ver);
-	return ret;
+	return ret != -1 ? EXIT_SUCCESS : EXIT_FAILURE;
 }
 
 static int ksmbd_control_debug(char *comp)
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

