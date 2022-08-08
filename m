Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2315BC00140
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Aug 2022 22:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236480AbiHHWC3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Aug 2022 18:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbiHHWC1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Aug 2022 18:02:27 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDCC1AF26
        for <linux-cifs@vger.kernel.org>; Mon,  8 Aug 2022 15:02:26 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id r14so11245948ljp.2
        for <linux-cifs@vger.kernel.org>; Mon, 08 Aug 2022 15:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=vEozrI9qeDZ0bs43tv0cC8zz34nNWEHvxQBc6wCU0X8=;
        b=AGLLsZ3AaOugkeJ0qiRnE8ETa1rzpdoNYmhV6q6X4m2ntHk4vVY+esnTXtg/vgPIki
         vksewMyDSUa2IFuk0aAYVc2skwTzJvFQi95Svmr4z7cAvIms8VHOr+Y8mrUcI4/pO/bE
         1GXYVzA3lcEYT/3UgZ6Zy2DFhkxi9aplOEkws/4cE5K+ak5TWJykPC37jFMmvCvbTvzD
         iW/WbMQSu6QuhLuEVQBfGeRg694LMwlP97P06EYXymda0R6WVi5Pxd1VpZZnnypc1wCw
         MWIm1KwPTaoiYPDN92wwN9/VDRbHEPSlK6rAqf3tFPd1UPbvdrlPAxCw4juxqNXiL/us
         7DvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=vEozrI9qeDZ0bs43tv0cC8zz34nNWEHvxQBc6wCU0X8=;
        b=EVC6E6ghpLCR6Oa2lxasseaKcupZrmUk7+DNlTfaItR7TZVilSEP0K3ozz6HOPEMQT
         Pmq/UEbu7TqRADsNtVVgQkTR2CyMKe4JP4/2UckO0VeXXdsrL0Oh3aqp4i95XMlM+WqS
         AbG2BLB1QNC20DhzKSLnzZBnMEr06CGgBQBW6XZXAwxRXAsnXwXtSLEDL9/CY07JTsB7
         2aD3nRIEDz/McfAKz5I0zjhbz6G5GFTYT4YHpU/xEJTuLsfpG2TPqdXHnMu6dfgOgKUo
         d7aA0hnQ0E4ajYizZilsneoMjCFjfP68rz7errdyv7FN9megna7KEJ8GFBHwGvPbFQlz
         QbDg==
X-Gm-Message-State: ACgBeo0tHO4vxChWAqTDVmkvErQYsRqIjSJCAXxWpywJPz1KA9k+oeuO
        mAVzLUNx9Ls17Mbc1ftur8MIIreMFak=
X-Google-Smtp-Source: AA6agR7w2VYmFVr8oQGNVKQ4UBGZ2bYwOS65l/S7fXznTbJ5LZ27rq2ykg0yJNW6J5d20FnqkoMc3Q==
X-Received: by 2002:a2e:b0c9:0:b0:25e:71e3:8441 with SMTP id g9-20020a2eb0c9000000b0025e71e38441mr6941702ljl.156.1659996144998;
        Mon, 08 Aug 2022 15:02:24 -0700 (PDT)
Received: from pohjola.lan (mobile-user-c1d2eb-134.dhcp.inet.fi. [193.210.235.134])
        by smtp.gmail.com with ESMTPSA id b15-20020a2eb90f000000b0025e72aae6bdsm1477817ljb.28.2022.08.08.15.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 15:02:24 -0700 (PDT)
From:   atheik <atteh.mailbox@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     atheik <atteh.mailbox@gmail.com>
Subject: [PATCH v2 1/3] ksmbd: request update to stale share config
Date:   Tue,  9 Aug 2022 01:02:14 +0300
Message-Id: <20220808220216.17235-1-atteh.mailbox@gmail.com>
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
 fs/ksmbd/ksmbd_netlink.h     |  2 ++
 fs/ksmbd/mgmt/share_config.c |  6 +++++-
 fs/ksmbd/mgmt/share_config.h |  1 +
 fs/ksmbd/mgmt/tree_connect.c | 14 ++++++++++++++
 fs/ksmbd/smb2pdu.c           |  1 +
 5 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/ksmbd_netlink.h b/fs/ksmbd/ksmbd_netlink.h
index 52aa0adeb951..a3211c55b01f 100644
--- a/fs/ksmbd/ksmbd_netlink.h
+++ b/fs/ksmbd/ksmbd_netlink.h
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
diff --git a/fs/ksmbd/mgmt/share_config.c b/fs/ksmbd/mgmt/share_config.c
index 70655af93b44..c9bca1c2c834 100644
--- a/fs/ksmbd/mgmt/share_config.c
+++ b/fs/ksmbd/mgmt/share_config.c
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
 
diff --git a/fs/ksmbd/mgmt/share_config.h b/fs/ksmbd/mgmt/share_config.h
index 28bf3511763f..902f2cb1963a 100644
--- a/fs/ksmbd/mgmt/share_config.h
+++ b/fs/ksmbd/mgmt/share_config.h
@@ -64,6 +64,7 @@ static inline int test_share_config_flag(struct ksmbd_share_config *share,
 	return share->flags & flag;
 }
 
+void ksmbd_share_config_del(struct ksmbd_share_config *share);
 void __ksmbd_share_config_put(struct ksmbd_share_config *share);
 
 static inline void ksmbd_share_config_put(struct ksmbd_share_config *share)
diff --git a/fs/ksmbd/mgmt/tree_connect.c b/fs/ksmbd/mgmt/tree_connect.c
index dd262daa2c4a..97ab7987df6e 100644
--- a/fs/ksmbd/mgmt/tree_connect.c
+++ b/fs/ksmbd/mgmt/tree_connect.c
@@ -57,6 +57,20 @@ ksmbd_tree_conn_connect(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 		goto out_error;
 
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
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 1f9a2cda0c58..b5c36657ecfd 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1944,6 +1944,7 @@ int smb2_tree_connect(struct ksmbd_work *work)
 		rsp->hdr.Status = STATUS_SUCCESS;
 		rc = 0;
 		break;
+	case -ESTALE:
 	case -ENOENT:
 	case KSMBD_TREE_CONN_STATUS_NO_SHARE:
 		rsp->hdr.Status = STATUS_BAD_NETWORK_NAME;
-- 
2.37.1

