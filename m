Return-Path: <SRS0=9w6c=D5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D485C388F7
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Oct 2020 18:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 485082225F
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Oct 2020 18:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898038AbgJVSNy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Oct 2020 14:13:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:58916 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901782AbgJVSNx (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 22 Oct 2020 14:13:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 97C58B305
        for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2020 18:13:51 +0000 (UTC)
From:   Samuel Cabrero <scabrero@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     Samuel Cabrero <scabrero@suse.de>
Subject: [PATCH 11/11] cifs: Handle witness share moved notification
Date:   Thu, 22 Oct 2020 20:13:39 +0200
Message-Id: <20201022181339.30771-12-scabrero@suse.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201022181339.30771-1-scabrero@suse.de>
References: <20201022181339.30771-1-scabrero@suse.de>
Reply-To: scabrero@suse.de
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Just log a message as it is not clear enough what this notification
means. It is received for example when a node belonging to a scale-out
file server dies, but it is also received as soon as a client registers
for notifications (w2k12r2) when the server is scale-out.

Signed-off-by: Samuel Cabrero <scabrero@suse.de>
---
 fs/cifs/cifs_swn.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/fs/cifs/cifs_swn.c b/fs/cifs/cifs_swn.c
index b71b05638b1c..ab079533dc24 100644
--- a/fs/cifs/cifs_swn.c
+++ b/fs/cifs/cifs_swn.c
@@ -534,6 +534,29 @@ static int cifs_swn_client_move(struct cifs_swn_reg *swnreg, struct sockaddr_sto
 	return cifs_swn_reconnect(swnreg->tcon, addr);
 }
 
+static int cifs_swn_share_moved(struct cifs_swn_reg *swnreg, struct sockaddr_storage *addr)
+{
+	struct sockaddr_in *ipv4 = (struct sockaddr_in *)addr;
+	struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)addr;
+
+	if (addr->ss_family == AF_INET)
+		cifs_dbg(FYI, "%s: share '%s' from '%s' moved to %pI4\n",
+				__func__, swnreg->share_name, swnreg->net_name,
+				&ipv4->sin_addr);
+	else if (addr->ss_family == AF_INET6)
+		cifs_dbg(FYI, "%s: share '%s' from '%s' moved to %pI6\n",
+				__func__, swnreg->share_name, swnreg->net_name,
+				&ipv6->sin6_addr);
+
+	/*
+	 * FIXME It is not clear enough how to handle this notification and what does it mean.
+	 * It is received for example when a node belonging to a scale-out file server dies, but
+	 * it is also received as soon as a client registers for notifications (w2k12r2) when the
+	 * share is scale-out and all nodes are working fine. Just log for now.
+	 */
+	return 0;
+}
+
 int cifs_swn_notify(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cifs_swn_reg *swnreg;
@@ -593,6 +616,17 @@ int cifs_swn_notify(struct sk_buff *skb, struct genl_info *info)
 		}
 		return cifs_swn_client_move(swnreg, &addr);
 	}
+	case CIFS_SWN_NOTIFICATION_SHARE_MOVE: {
+		struct sockaddr_storage addr;
+
+		if (info->attrs[CIFS_GENL_ATTR_SWN_IP]) {
+			nla_memcpy(&addr, info->attrs[CIFS_GENL_ATTR_SWN_IP], sizeof(addr));
+		} else {
+			cifs_dbg(FYI, "%s: missing IP address attribute\n", __func__);
+			return -EINVAL;
+		}
+		return cifs_swn_share_moved(swnreg, &addr);
+	}
 	default:
 		cifs_dbg(FYI, "%s: unknown notification type %d\n", __func__, type);
 		break;
-- 
2.28.0

