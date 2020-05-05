Return-Path: <SRS0=N30I=6T=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B60C47254
	for <linux-cifs@archiver.kernel.org>; Tue,  5 May 2020 13:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB43320735
	for <linux-cifs@archiver.kernel.org>; Tue,  5 May 2020 13:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbgEENsk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 May 2020 09:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728898AbgEENsk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 May 2020 09:48:40 -0400
X-Greylist: delayed 300 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 05 May 2020 06:48:39 PDT
Received: from baptiste.telenet-ops.be (baptiste.telenet-ops.be [IPv6:2a02:1800:120:4::f00:13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04B1C061A0F
        for <linux-cifs@vger.kernel.org>; Tue,  5 May 2020 06:48:39 -0700 (PDT)
Received: from ramsan ([IPv6:2a02:1810:ac12:ed60:bd97:8453:3b10:1832])
        by baptiste.telenet-ops.be with bizsmtp
        id b1jc2200m3VwRR3011jccL; Tue, 05 May 2020 15:43:37 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1jVxrF-0008LA-Dt; Tue, 05 May 2020 15:43:37 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1jVxrF-0006z1-Bm; Tue, 05 May 2020 15:43:37 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Steve French <sfrench@samba.org>, Jiri Kosina <trivial@kernel.org>,
        Aurelien Aptel <aaptel@suse.com>
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH trivial] CIFS: Spelling s/EACCESS/EACCES/
Date:   Tue,  5 May 2020 15:43:35 +0200
Message-Id: <20200505134335.26802-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

As per POSIX, the correct spelling is EACCES:

include/uapi/asm-generic/errno-base.h:#define EACCES 13 /* Permission denied */

Fixes: b8f7442bc46e48fb ("CIFS: refactor cifs_get_inode_info()")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 fs/cifs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 390d2b15ef6ef9d7..5d2965a2373054a4 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -730,7 +730,7 @@ static __u64 simple_hashstr(const char *str)
  * cifs_backup_query_path_info - SMB1 fallback code to get ino
  *
  * Fallback code to get file metadata when we don't have access to
- * @full_path (EACCESS) and have backup creds.
+ * @full_path (EACCES) and have backup creds.
  *
  * @data will be set to search info result buffer
  * @resp_buf will be set to cifs resp buf and needs to be freed with
-- 
2.17.1

