Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E393C19F2A
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Aug 2022 02:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244123AbiHHCrI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 7 Aug 2022 22:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244138AbiHHCqt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 7 Aug 2022 22:46:49 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2526813D57
        for <linux-cifs@vger.kernel.org>; Sun,  7 Aug 2022 19:44:04 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id e15so10854000lfs.0
        for <linux-cifs@vger.kernel.org>; Sun, 07 Aug 2022 19:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=0G2g4+ARrzM2zKTNBhdzSazHv/st7jrSWN5Aluts6so=;
        b=qZfOsTc7OlvOjdFIprscH/vifayfC5uENL/kkgIXrt1J2fePRlSwpzdQVtzOnUFQFy
         6hvExJVDMXxEP2m0RQIKn7OfmE+jrvF6WRyd/6n+kRKV2gWMeukV9IWlG7Yq0VjEcpMI
         POsoT09+ThuNOUdt+3XDBtXMBoMQgDsSRMLaNCtwMC5QtAKOGLFyMczqQZg4ehpaBqbv
         0mo2HPd2itt4o/rW2K5isFHZC4RDBBljXr6//JH2R5XHcDC9o/zU8ls2Wdec4j9BdYzb
         /mnlTPGdHYZbg3gjaemeH4DFhEQ53d7KmimUpPAFvopAy2RDhLP4Uuq8nW5zHvqBVvTN
         DsYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=0G2g4+ARrzM2zKTNBhdzSazHv/st7jrSWN5Aluts6so=;
        b=QjTSzuE1yF5LvsNzyjpzfNuOG4r+1D7BYktXLgsXq0XSjCt6WQyBy+X7fgDfD5AAJi
         4QQUhIosn+DCKKO9yzSHC/rbE+HOQ0KgxbzaTTmzrpf+uo+QAg48lvel/zUf8aT8nK4z
         HHa8VSYWOyygfDCu6it653718180axnfJJ2FH9ohjyCAycj1tP0HQivKYJaDeAFEPwUG
         DUQjI+Jxf3AgfoPRT4teNdwb41PhbcN4k/yA1/WzeH+uRQ8CiVvJ0a6ucVwEUY8akQMS
         cu4sGXxr8IfucRQNixviqyrG9hEUbuSkL0Ra1p6PtTqht6tB+FmrbhBo8zjlJTMQ42Bw
         Sgtg==
X-Gm-Message-State: ACgBeo1EQ5lXw/UpAaAdPvPS5tKdTl1ZDxxVYdQYvosTHpAh+P6iXnfK
        i2kX8yN/U46V60Jye34s/vN0HFGaspw=
X-Google-Smtp-Source: AA6agR4z0ZR3Xpk7bcO1NJPcSyuO+idiJ1a2A090OEkCI1ZvMfhV0DFaOKAgG7e4sNrJNsQic9laEw==
X-Received: by 2002:a05:6512:3085:b0:48c:fcf8:18ab with SMTP id z5-20020a056512308500b0048cfcf818abmr42152lfd.113.1659926640360;
        Sun, 07 Aug 2022 19:44:00 -0700 (PDT)
Received: from pohjola.lan (mobile-user-c1d2e4-79.dhcp.inet.fi. [193.210.228.79])
        by smtp.gmail.com with ESMTPSA id v22-20020ac25596000000b0048a77a2c4b2sm1255125lfg.158.2022.08.07.19.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Aug 2022 19:44:00 -0700 (PDT)
From:   atheik <atteh.mailbox@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     atheik <atteh.mailbox@gmail.com>
Subject: [PATCH 1/3] ksmbd: request update to stale share config
Date:   Mon,  8 Aug 2022 05:43:39 +0300
Message-Id: <20220808024341.63913-1-atteh.mailbox@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ksmbd_share_config_get() retrieves the cached share config as long
as there is at least one connection to the share. This is an issue when
the user space utilities are used to update share configs. In that case
there is a need to inform ksmbd that it should not use the cached share
config for a new connection to the share. With these changes the tree
connection flag KSMBD_TREE_CONN_FLAG_UPDATE indicates this. When this
flag is set, ksmbd removes the share config from the shares hash table
meaning that ksmbd_share_config_get() ends up requesting a share config
from user space.

Signed-off-by: Atte Heikkilä <atteh.mailbox@gmail.com>
---
 ksmbd_netlink.h     |  2 ++
 mgmt/share_config.c |  6 +++++-
 mgmt/share_config.h |  1 +
 mgmt/tree_connect.c | 14 ++++++++++++++
 4 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/ksmbd_netlink.h b/ksmbd_netlink.h
index 192cb13..5d77b72 100644
--- a/ksmbd_netlink.h
+++ b/ksmbd_netlink.h
@@ -349,6 +349,7 @@ enum KSMBD_TREE_CONN_STATUS {
 #define KSMBD_SHARE_FLAG_STREAMS		BIT(11)
 #define KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS	BIT(12)
 #define KSMBD_SHARE_FLAG_ACL_XATTR		BIT(13)
+#define KSMBD_SHARE_FLAG_UPDATE 		BIT(14)
 
 /*
  * Tree connect request flags.
@@ -364,6 +365,7 @@ enum KSMBD_TREE_CONN_STATUS {
 #define KSMBD_TREE_CONN_FLAG_READ_ONLY		BIT(1)
 #define KSMBD_TREE_CONN_FLAG_WRITABLE		BIT(2)
 #define KSMBD_TREE_CONN_FLAG_ADMIN_ACCOUNT	BIT(3)
+#define KSMBD_TREE_CONN_FLAG_UPDATE		BIT(4)
 
 /*
  * RPC over IPC.
diff --git a/mgmt/share_config.c b/mgmt/share_config.c
index 70655af..c9bca1c 100644
--- a/mgmt/share_config.c
+++ b/mgmt/share_config.c
@@ -51,12 +51,16 @@ static void kill_share(struct ksmbd_share_config *share)
 	kfree(share);
 }
 
-void __ksmbd_share_config_put(struct ksmbd_share_config *share)
+void ksmbd_share_config_del(struct ksmbd_share_config *share)
 {
 	down_write(&shares_table_lock);
 	hash_del(&share->hlist);
 	up_write(&shares_table_lock);
+}
 
+void __ksmbd_share_config_put(struct ksmbd_share_config *share)
+{
+	ksmbd_share_config_del(share);
 	kill_share(share);
 }
 
diff --git a/mgmt/share_config.h b/mgmt/share_config.h
index 28bf351..902f2cb 100644
--- a/mgmt/share_config.h
+++ b/mgmt/share_config.h
@@ -64,6 +64,7 @@ static inline int test_share_config_flag(struct ksmbd_share_config *share,
 	return share->flags & flag;
 }
 
+void ksmbd_share_config_del(struct ksmbd_share_config *share);
 void __ksmbd_share_config_put(struct ksmbd_share_config *share);
 
 static inline void ksmbd_share_config_put(struct ksmbd_share_config *share)
diff --git a/mgmt/tree_connect.c b/mgmt/tree_connect.c
index 7d467e1..0cf6265 100644
--- a/mgmt/tree_connect.c
+++ b/mgmt/tree_connect.c
@@ -65,6 +65,20 @@ ksmbd_tree_conn_connect(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 	}
 
 	tree_conn->flags = resp->connection_flags;
+	if (test_tree_conn_flag(tree_conn, KSMBD_TREE_CONN_FLAG_UPDATE)) {
+		struct ksmbd_share_config *new_sc;
+
+		ksmbd_share_config_del(sc);
+		new_sc = ksmbd_share_config_get(share_name);
+		if (!new_sc) {
+			pr_err("Failed to update stale share config\n");
+			status.ret = -ESTALE;
+			goto out_error;
+		}
+		ksmbd_share_config_put(sc);
+		sc = new_sc;
+	}
+
 	tree_conn->user = sess->user;
 	tree_conn->share_conf = sc;
 	status.tree_conn = tree_conn;
-- 
2.37.1

