Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 555DBC4321E
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Nov 2022 21:22:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiKAVW5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 1 Nov 2022 17:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiKAVW5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 1 Nov 2022 17:22:57 -0400
X-Greylist: delayed 451 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 01 Nov 2022 14:22:55 PDT
Received: from smtp.smtpout.orange.fr (smtp-15.smtpout.orange.fr [80.12.242.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A549426C
        for <linux-cifs@vger.kernel.org>; Tue,  1 Nov 2022 14:22:55 -0700 (PDT)
Received: from pop-os.home ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id pyanoKD2rsfCIpybPoWfJx; Tue, 01 Nov 2022 22:15:20 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 01 Nov 2022 22:15:20 +0100
X-ME-IP: 86.243.100.34
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH 16/30] cifs: Use kstrtobool() instead of strtobool()
Date:   Tue,  1 Nov 2022 22:14:04 +0100
Message-Id: <a8ce10f9b8608ecff03954e5157c8c7d0bf0df05.1667336095.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1667336095.git.christophe.jaillet@wanadoo.fr>
References: <cover.1667336095.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

strtobool() is the same as kstrtobool().
However, the latter is more used within the kernel.

In order to remove strtobool() and slightly simplify kstrtox.h, switch to
the other function name.

While at it, include the corresponding header file (<linux/kstrtox.h>)

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This patch is part of a serie that axes all usages of strtobool().
Each patch can be applied independently from the other ones.

The last patch of the serie removes the definition of strtobool().

You may not be in copy of the cover letter. So, if needed, it is available
at [1].

[1]: https://lore.kernel.org/all/cover.1667336095.git.christophe.jaillet@wanadoo.fr/
---
 fs/cifs/cifs_debug.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 90850da390ae..4f1b3a65e74c 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -8,6 +8,7 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
+#include <linux/kstrtox.h>
 #include <linux/module.h>
 #include <linux/proc_fs.h>
 #include <linux/uaccess.h>
@@ -779,7 +780,7 @@ static ssize_t cifsFYI_proc_write(struct file *file, const char __user *buffer,
 	rc = get_user(c[0], buffer);
 	if (rc)
 		return rc;
-	if (strtobool(c, &bv) == 0)
+	if (kstrtobool(c, &bv) == 0)
 		cifsFYI = bv;
 	else if ((c[0] > '1') && (c[0] <= '9'))
 		cifsFYI = (int) (c[0] - '0'); /* see cifs_debug.h for meanings */
@@ -939,7 +940,7 @@ static ssize_t cifs_security_flags_proc_write(struct file *file,
 
 	if (count < 3) {
 		/* single char or single char followed by null */
-		if (strtobool(flags_string, &bv) == 0) {
+		if (kstrtobool(flags_string, &bv) == 0) {
 			global_secflags = bv ? CIFSSEC_MAX : CIFSSEC_DEF;
 			return count;
 		} else if (!isdigit(flags_string[0])) {
-- 
2.34.1

