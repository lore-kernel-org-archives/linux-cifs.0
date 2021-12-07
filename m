Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F70C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Dec 2021 11:54:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235644AbhLGL6K (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Dec 2021 06:58:10 -0500
Received: from smtp1.axis.com ([195.60.68.17]:53438 "EHLO smtp1.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230001AbhLGL6K (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 7 Dec 2021 06:58:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1638878080;
  x=1670414080;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=t92Mo+JxZG/jlt/VfGUzsrJ7nO3Csh7wPw0sfmctulE=;
  b=e+UfbUaP2byf4NcltFbLNUSaXFWNukmJKw7vxc2opbzn48o+/hG+jVzj
   GfjdPbuewewi0rUPEharaHhmNsGa4kd3R5N4nesdTnik1cUPo/svInbom
   tDLNBycljncpDOJSkTWLkMlULDtTd3wp7s24OxetND03f8qDiJwv5nElZ
   /Hu1Mq/QLJJB89yx5haj8FoLQh2IfqSAdJUERU13EiZ6TOZ1bH5FuRYo+
   2ySqcZ31SoCr9r/OHJxr7ZO8laF4eCfG17U+7asHSIS1mWj1N0cTUvAEP
   +Xy3GYUz6mRa7OTB2E0u3nW7mrq/kVLeRPHeePDhUmXAJPL8rVZsc9nyX
   A==;
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     Steve French <sfrench@samba.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
CC:     <kernel@axis.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] cifs: Fix crash on unload of cifs_arc4.ko
Date:   Tue, 7 Dec 2021 12:54:19 +0100
Message-ID: <20211207115420.18713-1-vincent.whitchurch@axis.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The exit function is wrongly placed in the __init section and this leads
to a crash when the module is unloaded.  Just remove both the init and
exit functions since this module does not need them.

Fixes: 71c02863246167b3d ("cifs: fork arc4 and create a separate module...")
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
---
 fs/smbfs_common/cifs_arc4.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/fs/smbfs_common/cifs_arc4.c b/fs/smbfs_common/cifs_arc4.c
index 85ba15a60b13..043e4cb839fa 100644
--- a/fs/smbfs_common/cifs_arc4.c
+++ b/fs/smbfs_common/cifs_arc4.c
@@ -72,16 +72,3 @@ void cifs_arc4_crypt(struct arc4_ctx *ctx, u8 *out, const u8 *in, unsigned int l
 	ctx->y = y;
 }
 EXPORT_SYMBOL_GPL(cifs_arc4_crypt);
-
-static int __init
-init_smbfs_common(void)
-{
-	return 0;
-}
-static void __init
-exit_smbfs_common(void)
-{
-}
-
-module_init(init_smbfs_common)
-module_exit(exit_smbfs_common)
-- 
2.33.1

