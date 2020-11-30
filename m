Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A0A7C64E8A
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Nov 2020 18:04:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A0B8207F7
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Nov 2020 18:04:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729527AbgK3SEd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Nov 2020 13:04:33 -0500
Received: from mx2.suse.de ([195.135.220.15]:45748 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729436AbgK3SEd (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 30 Nov 2020 13:04:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C2CE9AF3E
        for <linux-cifs@vger.kernel.org>; Mon, 30 Nov 2020 18:03:11 +0000 (UTC)
From:   Samuel Cabrero <scabrero@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     Samuel Cabrero <scabrero@suse.de>
Subject: [PATCH v4 06/11] cifs: Set witness notification handler for messages from userspace daemon
Date:   Mon, 30 Nov 2020 19:02:52 +0100
Message-Id: <20201130180257.31787-7-scabrero@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130180257.31787-1-scabrero@suse.de>
References: <20201130180257.31787-1-scabrero@suse.de>
Reply-To: scabrero@suse.de
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

+ Set a handler for the witness notification messages received from the
  userspace daemon.

+ Handle the resource state change notification. When the resource
  becomes unavailable or available set the tcp status to
  CifsNeedReconnect for all channels.

Signed-off-by: Samuel Cabrero <scabrero@suse.de>
---
 fs/cifs/cifs_swn.c                     | 86 ++++++++++++++++++++++++++
 fs/cifs/cifs_swn.h                     |  4 ++
 fs/cifs/netlink.c                      |  9 +++
 include/uapi/linux/cifs/cifs_netlink.h | 17 +++++
 4 files changed, 116 insertions(+)

diff --git a/fs/cifs/cifs_swn.c b/fs/cifs/cifs_swn.c
index c0af03955d0c..63b0764af5d5 100644
--- a/fs/cifs/cifs_swn.c
+++ b/fs/cifs/cifs_swn.c
@@ -383,6 +383,92 @@ static void cifs_put_swn_reg(struct cifs_swn_reg *swnreg)
 	mutex_unlock(&cifs_swnreg_idr_mutex);
 }
 
+static int cifs_swn_resource_state_changed(struct cifs_swn_reg *swnreg, const char *name, int state)
+{
+	int i;
+
+	switch (state) {
+	case CIFS_SWN_RESOURCE_STATE_UNAVAILABLE:
+		cifs_dbg(FYI, "%s: resource name '%s' become unavailable\n", __func__, name);
+		for (i = 0; i < swnreg->tcon->ses->chan_count; i++) {
+			spin_lock(&GlobalMid_Lock);
+			if (swnreg->tcon->ses->chans[i].server->tcpStatus != CifsExiting)
+				swnreg->tcon->ses->chans[i].server->tcpStatus = CifsNeedReconnect;
+			spin_unlock(&GlobalMid_Lock);
+		}
+		break;
+	case CIFS_SWN_RESOURCE_STATE_AVAILABLE:
+		cifs_dbg(FYI, "%s: resource name '%s' become available\n", __func__, name);
+		for (i = 0; i < swnreg->tcon->ses->chan_count; i++) {
+			spin_lock(&GlobalMid_Lock);
+			if (swnreg->tcon->ses->chans[i].server->tcpStatus != CifsExiting)
+				swnreg->tcon->ses->chans[i].server->tcpStatus = CifsNeedReconnect;
+			spin_unlock(&GlobalMid_Lock);
+		}
+		break;
+	case CIFS_SWN_RESOURCE_STATE_UNKNOWN:
+		cifs_dbg(FYI, "%s: resource name '%s' changed to unknown state\n", __func__, name);
+		break;
+	}
+	return 0;
+}
+
+int cifs_swn_notify(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cifs_swn_reg *swnreg;
+	char name[256];
+	int type;
+
+	if (info->attrs[CIFS_GENL_ATTR_SWN_REGISTRATION_ID]) {
+		int swnreg_id;
+
+		swnreg_id = nla_get_u32(info->attrs[CIFS_GENL_ATTR_SWN_REGISTRATION_ID]);
+		mutex_lock(&cifs_swnreg_idr_mutex);
+		swnreg = idr_find(&cifs_swnreg_idr, swnreg_id);
+		mutex_unlock(&cifs_swnreg_idr_mutex);
+		if (swnreg == NULL) {
+			cifs_dbg(FYI, "%s: registration id %d not found\n", __func__, swnreg_id);
+			return -EINVAL;
+		}
+	} else {
+		cifs_dbg(FYI, "%s: missing registration id attribute\n", __func__);
+		return -EINVAL;
+	}
+
+	if (info->attrs[CIFS_GENL_ATTR_SWN_NOTIFICATION_TYPE]) {
+		type = nla_get_u32(info->attrs[CIFS_GENL_ATTR_SWN_NOTIFICATION_TYPE]);
+	} else {
+		cifs_dbg(FYI, "%s: missing notification type attribute\n", __func__);
+		return -EINVAL;
+	}
+
+	switch (type) {
+	case CIFS_SWN_NOTIFICATION_RESOURCE_CHANGE: {
+		int state;
+
+		if (info->attrs[CIFS_GENL_ATTR_SWN_RESOURCE_NAME]) {
+			nla_strlcpy(name, info->attrs[CIFS_GENL_ATTR_SWN_RESOURCE_NAME],
+					sizeof(name));
+		} else {
+			cifs_dbg(FYI, "%s: missing resource name attribute\n", __func__);
+			return -EINVAL;
+		}
+		if (info->attrs[CIFS_GENL_ATTR_SWN_RESOURCE_STATE]) {
+			state = nla_get_u32(info->attrs[CIFS_GENL_ATTR_SWN_RESOURCE_STATE]);
+		} else {
+			cifs_dbg(FYI, "%s: missing resource state attribute\n", __func__);
+			return -EINVAL;
+		}
+		return cifs_swn_resource_state_changed(swnreg, name, state);
+	}
+	default:
+		cifs_dbg(FYI, "%s: unknown notification type %d\n", __func__, type);
+		break;
+	}
+
+	return 0;
+}
+
 int cifs_swn_register(struct cifs_tcon *tcon)
 {
 	struct cifs_swn_reg *swnreg;
diff --git a/fs/cifs/cifs_swn.h b/fs/cifs/cifs_swn.h
index 69c7bd1035da..7ef9ecedbd05 100644
--- a/fs/cifs/cifs_swn.h
+++ b/fs/cifs/cifs_swn.h
@@ -9,9 +9,13 @@
 #define _CIFS_SWN_H
 
 struct cifs_tcon;
+struct sk_buff;
+struct genl_info;
 
 extern int cifs_swn_register(struct cifs_tcon *tcon);
 
 extern int cifs_swn_unregister(struct cifs_tcon *tcon);
 
+extern int cifs_swn_notify(struct sk_buff *skb, struct genl_info *info);
+
 #endif /* _CIFS_SWN_H */
diff --git a/fs/cifs/netlink.c b/fs/cifs/netlink.c
index 83008a56def5..5aaabe4cc0a7 100644
--- a/fs/cifs/netlink.c
+++ b/fs/cifs/netlink.c
@@ -11,6 +11,7 @@
 #include "netlink.h"
 #include "cifsglob.h"
 #include "cifs_debug.h"
+#include "cifs_swn.h"
 
 static const struct nla_policy cifs_genl_policy[CIFS_GENL_ATTR_MAX + 1] = {
 	[CIFS_GENL_ATTR_SWN_REGISTRATION_ID]	= { .type = NLA_U32 },
@@ -24,9 +25,17 @@ static const struct nla_policy cifs_genl_policy[CIFS_GENL_ATTR_MAX + 1] = {
 	[CIFS_GENL_ATTR_SWN_USER_NAME]		= { .type = NLA_STRING },
 	[CIFS_GENL_ATTR_SWN_PASSWORD]		= { .type = NLA_STRING },
 	[CIFS_GENL_ATTR_SWN_DOMAIN_NAME]	= { .type = NLA_STRING },
+	[CIFS_GENL_ATTR_SWN_NOTIFICATION_TYPE]	= { .type = NLA_U32 },
+	[CIFS_GENL_ATTR_SWN_RESOURCE_STATE]	= { .type = NLA_U32 },
+	[CIFS_GENL_ATTR_SWN_RESOURCE_NAME]	= { .type = NLA_STRING},
 };
 
 static struct genl_ops cifs_genl_ops[] = {
+	{
+		.cmd = CIFS_GENL_CMD_SWN_NOTIFY,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit = cifs_swn_notify,
+	},
 };
 
 static const struct genl_multicast_group cifs_genl_mcgrps[] = {
diff --git a/include/uapi/linux/cifs/cifs_netlink.h b/include/uapi/linux/cifs/cifs_netlink.h
index 5662e2774513..da3107582f49 100644
--- a/include/uapi/linux/cifs/cifs_netlink.h
+++ b/include/uapi/linux/cifs/cifs_netlink.h
@@ -31,6 +31,9 @@ enum cifs_genl_attributes {
 	CIFS_GENL_ATTR_SWN_USER_NAME,
 	CIFS_GENL_ATTR_SWN_PASSWORD,
 	CIFS_GENL_ATTR_SWN_DOMAIN_NAME,
+	CIFS_GENL_ATTR_SWN_NOTIFICATION_TYPE,
+	CIFS_GENL_ATTR_SWN_RESOURCE_STATE,
+	CIFS_GENL_ATTR_SWN_RESOURCE_NAME,
 	__CIFS_GENL_ATTR_MAX,
 };
 #define CIFS_GENL_ATTR_MAX (__CIFS_GENL_ATTR_MAX - 1)
@@ -39,8 +42,22 @@ enum cifs_genl_commands {
 	CIFS_GENL_CMD_UNSPEC,
 	CIFS_GENL_CMD_SWN_REGISTER,
 	CIFS_GENL_CMD_SWN_UNREGISTER,
+	CIFS_GENL_CMD_SWN_NOTIFY,
 	__CIFS_GENL_CMD_MAX
 };
 #define CIFS_GENL_CMD_MAX (__CIFS_GENL_CMD_MAX - 1)
 
+enum cifs_swn_notification_type {
+	CIFS_SWN_NOTIFICATION_RESOURCE_CHANGE = 0x01,
+	CIFS_SWN_NOTIFICATION_CLIENT_MOVE	 = 0x02,
+	CIFS_SWN_NOTIFICATION_SHARE_MOVE	 = 0x03,
+	CIFS_SWN_NOTIFICATION_IP_CHANGE	 = 0x04,
+};
+
+enum cifs_swn_resource_state {
+	CIFS_SWN_RESOURCE_STATE_UNKNOWN     = 0x00,
+	CIFS_SWN_RESOURCE_STATE_AVAILABLE   = 0x01,
+	CIFS_SWN_RESOURCE_STATE_UNAVAILABLE = 0xFF
+};
+
 #endif /* _UAPILINUX_CIFS_NETLINK_H */
-- 
2.29.2

