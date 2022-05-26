Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A36CC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 26 May 2022 23:51:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343847AbiEZXvL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 May 2022 19:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245709AbiEZXvL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 26 May 2022 19:51:11 -0400
Received: from lgeamrelo11.lge.com (lgeamrelo13.lge.com [156.147.23.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F239D76
        for <linux-cifs@vger.kernel.org>; Thu, 26 May 2022 16:51:10 -0700 (PDT)
Received: from unknown (HELO lgemrelse7q.lge.com) (156.147.1.151)
        by 156.147.23.53 with ESMTP; 27 May 2022 08:51:08 +0900
X-Original-SENDERIP: 156.147.1.151
X-Original-MAILFROM: hyc.lee@gmail.com
Received: from unknown (HELO localhost.localdomain) (10.177.245.62)
        by 156.147.1.151 with ESMTP; 27 May 2022 08:51:08 +0900
X-Original-SENDERIP: 10.177.245.62
X-Original-MAILFROM: hyc.lee@gmail.com
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <sfrench@samba.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH] ksmbd: smbd: relax the count of sges required
Date:   Fri, 27 May 2022 08:50:54 +0900
Message-Id: <20220526235054.29434-1-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Remove the condition that the count of sges
must be greater than or equal to
SMB_DIRECT_MAX_SEND_SGES(8).
Because ksmbd needs sges only for SMB direct
header, SMB2 transform header, SMB2 response,
and optional payload.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
---
 fs/ksmbd/transport_rdma.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 0281c185892d..ff82852aa0fd 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -1709,11 +1709,11 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 	int max_send_sges, max_rw_wrs, max_send_wrs;
 	unsigned int max_sge_per_wr, wrs_per_credit;
 
-	/* need 2 more sge. because a SMB_DIRECT header will be mapped,
-	 * and maybe a send buffer could be not page aligned.
+	/* need 3 more sge. because a SMB_DIRECT header, SMB2 header,
+	 * SMB2 response could be mapped.
 	 */
 	t->max_send_size = smb_direct_max_send_size;
-	max_send_sges = DIV_ROUND_UP(t->max_send_size, PAGE_SIZE) + 2;
+	max_send_sges = DIV_ROUND_UP(t->max_send_size, PAGE_SIZE) + 3;
 	if (max_send_sges > SMB_DIRECT_MAX_SEND_SGES) {
 		pr_err("max_send_size %d is too large\n", t->max_send_size);
 		return -EINVAL;
@@ -1734,6 +1734,8 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 
 	max_sge_per_wr = min_t(unsigned int, device->attrs.max_send_sge,
 			       device->attrs.max_sge_rd);
+	max_sge_per_wr = max_t(unsigned int, max_sge_per_wr,
+			       max_send_sges);
 	wrs_per_credit = max_t(unsigned int, 4,
 			       DIV_ROUND_UP(t->pages_per_rw_credit,
 					    max_sge_per_wr) + 1);
@@ -1758,11 +1760,6 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 		return -EINVAL;
 	}
 
-	if (device->attrs.max_send_sge < SMB_DIRECT_MAX_SEND_SGES) {
-		pr_err("warning: device max_send_sge = %d too small\n",
-		       device->attrs.max_send_sge);
-		return -EINVAL;
-	}
 	if (device->attrs.max_recv_sge < SMB_DIRECT_MAX_RECV_SGES) {
 		pr_err("warning: device max_recv_sge = %d too small\n",
 		       device->attrs.max_recv_sge);
-- 
2.17.1

