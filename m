Return-Path: <SRS0=jtYN=BS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E16AAC433E3
	for <linux-cifs@archiver.kernel.org>; Sat,  8 Aug 2020 08:34:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB859206E9
	for <linux-cifs@archiver.kernel.org>; Sat,  8 Aug 2020 08:34:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgHHIe0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 8 Aug 2020 04:34:26 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:9356 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725880AbgHHIeZ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 8 Aug 2020 04:34:25 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B62D12A7F7EEF3E9890F;
        Sat,  8 Aug 2020 16:34:19 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Sat, 8 Aug 2020
 16:34:09 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <sfrench@samba.org>
CC:     <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
        <linux-kernel@vger.kernel.org>, <linmiaohe@huawei.com>
Subject: [PATCH] cifs: Convert to use the fallthrough macro
Date:   Sat, 8 Aug 2020 16:36:37 +0800
Message-ID: <1596875797-22710-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

Convert the uses of fallthrough comments to fallthrough macro.

Signed-off-by: Hongxiang Lou <louhongxiang@huawei.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 fs/cifs/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 24c2ac360591..667d70aa335f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3913,7 +3913,7 @@ smb2_readv_callback(struct mid_q_entry *mid)
 	case MID_RESPONSE_MALFORMED:
 		credits.value = le16_to_cpu(shdr->CreditRequest);
 		credits.instance = server->reconnect_instance;
-		/* fall through */
+		fallthrough;
 	default:
 		rdata->result = -EIO;
 	}
@@ -4146,7 +4146,7 @@ smb2_writev_callback(struct mid_q_entry *mid)
 	case MID_RESPONSE_MALFORMED:
 		credits.value = le16_to_cpu(rsp->sync_hdr.CreditRequest);
 		credits.instance = server->reconnect_instance;
-		/* fall through */
+		fallthrough;
 	default:
 		wdata->result = -EIO;
 		break;
-- 
2.19.1

