Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A9C7C433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Mar 2022 15:21:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbiCBPWO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 2 Mar 2022 10:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbiCBPWN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 2 Mar 2022 10:22:13 -0500
X-Greylist: delayed 617 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 02 Mar 2022 07:21:29 PST
Received: from sym2.noone.org (sym.noone.org [IPv6:2a01:4f8:120:4161::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C690FC6263
        for <linux-cifs@vger.kernel.org>; Wed,  2 Mar 2022 07:21:29 -0800 (PST)
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 4K7yHd6hW7zvjhS; Wed,  2 Mar 2022 16:11:09 +0100 (CET)
From:   Tobias Klauser <tklauser@distanz.ch>
To:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
Cc:     linux-cifs@vger.kernel.org
Subject: [PATCH] ksmbd: use netif_is_bridge_port
Date:   Wed,  2 Mar 2022 16:11:09 +0100
Message-Id: <20220302151109.19892-1-tklauser@distanz.ch>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Use netif_is_bridge_port defined in <linux/netdevice.h> instead of
open-coding it.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 fs/ksmbd/transport_tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/transport_tcp.c b/fs/ksmbd/transport_tcp.c
index 82a1429bbe12..8fef9de787d3 100644
--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -476,7 +476,7 @@ static int ksmbd_netdev_event(struct notifier_block *nb, unsigned long event,
 
 	switch (event) {
 	case NETDEV_UP:
-		if (netdev->priv_flags & IFF_BRIDGE_PORT)
+		if (netif_is_bridge_port(netdev))
 			return NOTIFY_OK;
 
 		list_for_each_entry(iface, &iface_list, entry) {
@@ -585,7 +585,7 @@ int ksmbd_tcp_set_interfaces(char *ifc_list, int ifc_list_sz)
 
 		rtnl_lock();
 		for_each_netdev(&init_net, netdev) {
-			if (netdev->priv_flags & IFF_BRIDGE_PORT)
+			if (netif_is_bridge_port(netdev))
 				continue;
 			if (!alloc_iface(kstrdup(netdev->name, GFP_KERNEL)))
 				return -ENOMEM;
-- 
2.34.1

