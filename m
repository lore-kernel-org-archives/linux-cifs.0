Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53DE5C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Dec 2021 06:02:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235749AbhLOGCe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Dec 2021 01:02:34 -0500
Received: from mail-pg1-f172.google.com ([209.85.215.172]:37452 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233735AbhLOGCe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Dec 2021 01:02:34 -0500
Received: by mail-pg1-f172.google.com with SMTP id a23so14677876pgm.4
        for <linux-cifs@vger.kernel.org>; Tue, 14 Dec 2021 22:02:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Cz1auCJRA0wMcBQ2LoTSJ+MmEKMFXXWFygD8tShQBl8=;
        b=Sc2CvQmzFx4PmVDYFETMdBPv5/GVl0DyhcU3TtTWnyghhQW5fhvB6kTUErEyuKJ+7b
         4GYmpqS3vpevG7//wli4GrQ9uygrIl1a5BPKUSh7ZeM2FRtwz8sb90xMzNztP7UFSj8H
         UGs4bC517ssUWe9pFJvtOPMvYZnNRmIb8GmUxSwTOX5gYmURQfk5v3bKRwLPTr4nU15n
         1oFGURYsopxxJg9cFyVe+Z/zOqwydmeZTEiQoXHgd3lmWIgHZh15nmmhyGQR8tnTXly7
         4ylHHgZCH2I7FQ8WmWZ+sIysgQcIyMizfWAuRJCbQwZQSs8UwT1QkuS4cMJS4jlNvLuq
         imYw==
X-Gm-Message-State: AOAM532O5JU2+MhViaAR6UwBdAQ9OLb9YuwRaUdhSAEihwAjuY1zNu/6
        9YLJuSeAqdfzAtF/F+GWXh0aV2c51/g=
X-Google-Smtp-Source: ABdhPJxzhvQS9HfRcPUxdFKdE9F/0hisTrJj8LBh05+Z3wQl6ifpN3tBwE+hvRwOtpY3RbqiI+WxWg==
X-Received: by 2002:a63:290:: with SMTP id 138mr6809944pgc.425.1639548153649;
        Tue, 14 Dec 2021 22:02:33 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id oc10sm4575249pjb.26.2021.12.14.22.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 22:02:33 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Ziwei Xie <zw.xie@high-flyer.cn>
Subject: [PATCH 1/3] ksmbd: set RSS capable in FSCTL_QUERY_NETWORK_INTERFACE_INFO
Date:   Wed, 15 Dec 2021 15:02:04 +0900
Message-Id: <20211215060206.8048-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Set RSS capable in FSCTL_QUERY_NETWORK_INTERFACE_INFO if netdev has
multi tx queues. And add ksmbd_compare_user() to avoid racy condition
issue in ksmbd_free_user(). because windows client is simultaneously used
to send session setup requests for multichannel connection.

Tested-by: Ziwei Xie <zw.xie@high-flyer.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/mgmt/user_config.c | 10 ++++++++++
 fs/ksmbd/mgmt/user_config.h |  1 +
 fs/ksmbd/smb2pdu.c          | 14 +++++++++-----
 3 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/fs/ksmbd/mgmt/user_config.c b/fs/ksmbd/mgmt/user_config.c
index 1019d3677d55..279d00feff21 100644
--- a/fs/ksmbd/mgmt/user_config.c
+++ b/fs/ksmbd/mgmt/user_config.c
@@ -67,3 +67,13 @@ int ksmbd_anonymous_user(struct ksmbd_user *user)
 		return 1;
 	return 0;
 }
+
+bool ksmbd_compare_user(struct ksmbd_user *u1, struct ksmbd_user *u2)
+{
+	if (strcmp(u1->name, u2->name))
+		return false;
+	if (memcmp(u1->passkey, u2->passkey, u1->passkey_sz))
+		return false;
+
+	return true;
+}
diff --git a/fs/ksmbd/mgmt/user_config.h b/fs/ksmbd/mgmt/user_config.h
index aff80b029579..6a44109617f1 100644
--- a/fs/ksmbd/mgmt/user_config.h
+++ b/fs/ksmbd/mgmt/user_config.h
@@ -64,4 +64,5 @@ struct ksmbd_user *ksmbd_login_user(const char *account);
 struct ksmbd_user *ksmbd_alloc_user(struct ksmbd_login_response *resp);
 void ksmbd_free_user(struct ksmbd_user *user);
 int ksmbd_anonymous_user(struct ksmbd_user *user);
+bool ksmbd_compare_user(struct ksmbd_user *u1, struct ksmbd_user *u2);
 #endif /* __USER_CONFIG_MANAGEMENT_H__ */
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index f7bea92d4c98..7aee3b58b16f 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1429,10 +1429,15 @@ static int ntlm_authenticate(struct ksmbd_work *work)
 			ksmbd_free_user(user);
 			return 0;
 		}
-		ksmbd_free_user(sess->user);
+
+		if (!ksmbd_compare_user(sess->user, user))
+			return -EPERM;
+
+		ksmbd_free_user(user);
+	} else {
+		sess->user = user;
 	}
 
-	sess->user = user;
 	if (user_guest(sess->user)) {
 		if (conn->sign) {
 			ksmbd_debug(SMB, "Guest login not allowed when signing enabled\n");
@@ -2036,9 +2041,6 @@ int smb2_session_logoff(struct ksmbd_work *work)
 
 	ksmbd_debug(SMB, "request\n");
 
-	/* Got a valid session, set connection state */
-	WARN_ON(sess->conn != conn);
-
 	/* setting CifsExiting here may race with start_tcp_sess */
 	ksmbd_conn_set_need_reconnect(work);
 	ksmbd_close_session_fds(work);
@@ -7243,6 +7245,8 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 		nii_rsp->IfIndex = cpu_to_le32(netdev->ifindex);
 
 		nii_rsp->Capability = 0;
+		if (netdev->real_num_tx_queues > 1)
+			nii_rsp->Capability |= cpu_to_le32(RSS_CAPABLE);
 		if (ksmbd_rdma_capable_netdev(netdev))
 			nii_rsp->Capability |= cpu_to_le32(RDMA_CAPABLE);
 
-- 
2.25.1

