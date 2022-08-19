Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E479EC25B0E
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Aug 2022 04:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344650AbiHSEig (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Aug 2022 00:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243004AbiHSEig (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Aug 2022 00:38:36 -0400
Received: from lgeamrelo11.lge.com (lgeamrelo11.lge.com [156.147.23.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 282FA2D1EB
        for <linux-cifs@vger.kernel.org>; Thu, 18 Aug 2022 21:38:33 -0700 (PDT)
Received: from unknown (HELO lgeamrelo01.lge.com) (156.147.1.125)
        by 156.147.23.51 with ESMTP; 19 Aug 2022 13:38:31 +0900
X-Original-SENDERIP: 156.147.1.125
X-Original-MAILFROM: hyc.lee@gmail.com
Received: from unknown (HELO localhost.localdomain) (10.177.245.62)
        by 156.147.1.125 with ESMTP; 19 Aug 2022 13:38:31 +0900
X-Original-SENDERIP: 10.177.245.62
X-Original-MAILFROM: hyc.lee@gmail.com
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH] ksmbd: fix incorrect handling of iterate_dir
Date:   Fri, 19 Aug 2022 13:35:57 +0900
Message-Id: <20220819043557.26745-1-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

if iterate_dir() returns non-negative value,
caller has to treat it as normal and
check there is any error while populating
dentry information. ksmbd doesn't have to
do anything because ksmbd already
checks too small OutputBufferLength to
store one file information.

And because ctx->pos is set to file->f_pos
when iterative_dir is called, remove
restart_ctx().

This patch fixes some failure of
SMB2_QUERY_DIRECTORY, which happens when
ntfs3 is local filesystem.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
---
 fs/ksmbd/smb2pdu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 53c91ab02be2..6716c4e3c16d 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3970,11 +3970,9 @@ int smb2_query_dir(struct ksmbd_work *work)
 	 */
 	if (!d_info.out_buf_len && !d_info.num_entry)
 		goto no_buf_len;
-	if (rc == 0)
-		restart_ctx(&dir_fp->readdir_data.ctx);
-	if (rc == -ENOSPC)
+	if (rc > 0 || rc == -ENOSPC)
 		rc = 0;
-	if (rc)
+	else if (rc)
 		goto err_out;
 
 	d_info.wptr = d_info.rptr;
-- 
2.17.1

