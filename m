Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1597C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Dec 2021 01:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhLPBiG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Dec 2021 20:38:06 -0500
Received: from mail-pj1-f51.google.com ([209.85.216.51]:43768 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhLPBiG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Dec 2021 20:38:06 -0500
Received: by mail-pj1-f51.google.com with SMTP id a11-20020a17090a854b00b001b11aae38d6so1616375pjw.2
        for <linux-cifs@vger.kernel.org>; Wed, 15 Dec 2021 17:38:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mR/pNZK3poKwo86OIX2osbO0iAKqYX0UcsElvn8l3WU=;
        b=RUUdEB8Zob2mur4VDz5wXcALsmTOCHavzf4bhrd1v2hVwPEzmLdi+5XOlzRFCha1ua
         FV5hfKMhXe0kGPS5lRpd6OiYefcqMqrIfRj2G7677Hpo+7Pq0Z+S3N5JLm1IC3+eZMOg
         3DsDb8bYW9XrLdx5NcaotjIxFQdJ+GkryPwlao+TP+GLqX17eOhkGe7Pk/p2XlI+Vgi3
         8gqFycWyHsPQ925xIVJNoBtjl6C4cUvchtRYEE8ZCyk6c02viHgbecbWEKEFCoQ2MnS4
         AbRmk/k1Cf1b6FshHx9sftkMdhqsMeVKylszuPY7FgIiDHVpVH1lbAyttU9k6GnzaJoB
         qiXA==
X-Gm-Message-State: AOAM530RYHbfjiJ2CTIEZLBGkbPemDZ52BHYXPygde11b8S/Kf5iWQSV
        m5U4d2Czy2ARBS03rAcXh19fULOLXB0=
X-Google-Smtp-Source: ABdhPJxa3QN7rpcyQCiGGmMz0MKVW3joZwxAlWKCRimOQXt11ySSq6+pDEfBceAE8d8MMqWogua0tQ==
X-Received: by 2002:a17:902:b712:b0:148:a2e7:fb4f with SMTP id d18-20020a170902b71200b00148a2e7fb4fmr7397780pls.144.1639618685329;
        Wed, 15 Dec 2021 17:38:05 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id m15sm3483643pgd.44.2021.12.15.17.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 17:38:04 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 1/2] ksmbd: set RSS capable in FSCTL_QUERY_NETWORK_INTERFACE_INFO
Date:   Thu, 16 Dec 2021 10:37:24 +0900
Message-Id: <20211216013725.8065-1-linkinjeon@kernel.org>
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

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 v2:
   - Add missing free ksmbd_user before returning.

 fs/ksmbd/mgmt/user_config.c | 10 ++++++++++
 fs/ksmbd/mgmt/user_config.h |  1 +
 fs/ksmbd/smb2pdu.c          | 15 ++++++++++-----
 3 files changed, 21 insertions(+), 5 deletions(-)

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
index f7bea92d4c98..2ff4f813026e 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1429,10 +1429,16 @@ static int ntlm_authenticate(struct ksmbd_work *work)
 			ksmbd_free_user(user);
 			return 0;
 		}
-		ksmbd_free_user(sess->user);
+
+		if (!ksmbd_compare_user(sess->user, user)) {
+			ksmbd_free_user(user);
+			return -EPERM;
+		}
+		ksmbd_free_user(user);
+	} else {
+		sess->user = user;
 	}
 
-	sess->user = user;
 	if (user_guest(sess->user)) {
 		if (conn->sign) {
 			ksmbd_debug(SMB, "Guest login not allowed when signing enabled\n");
@@ -2036,9 +2042,6 @@ int smb2_session_logoff(struct ksmbd_work *work)
 
 	ksmbd_debug(SMB, "request\n");
 
-	/* Got a valid session, set connection state */
-	WARN_ON(sess->conn != conn);
-
 	/* setting CifsExiting here may race with start_tcp_sess */
 	ksmbd_conn_set_need_reconnect(work);
 	ksmbd_close_session_fds(work);
@@ -7243,6 +7246,8 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 		nii_rsp->IfIndex = cpu_to_le32(netdev->ifindex);
 
 		nii_rsp->Capability = 0;
+		if (netdev->real_num_tx_queues > 1)
+			nii_rsp->Capability |= cpu_to_le32(RSS_CAPABLE);
 		if (ksmbd_rdma_capable_netdev(netdev))
 			nii_rsp->Capability |= cpu_to_le32(RDMA_CAPABLE);
 
-- 
2.25.1

