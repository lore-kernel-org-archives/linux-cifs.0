Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0302FC433FE
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Dec 2021 01:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbhLPBiI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Dec 2021 20:38:08 -0500
Received: from mail-pf1-f175.google.com ([209.85.210.175]:44935 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhLPBiI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Dec 2021 20:38:08 -0500
Received: by mail-pf1-f175.google.com with SMTP id k64so22221929pfd.11
        for <linux-cifs@vger.kernel.org>; Wed, 15 Dec 2021 17:38:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zPpPuOpkw2hR3lP1AVsGBjGDVXt2KOxCg3WSpt4vsLc=;
        b=QvGZr3GuCmzBrAgQGUhN1xMKAmmbb6iHLEIGGyqg9GubmQiVlCdQRYBnjee6nDq5Wv
         RVa+p1Fvs/pzSXGXDVSeajS5Iwey/PYIpU+DNAaBk3MTJqSX4GjFj7/S39g58CFkrDWu
         XlLWXeUnQNNluX1YuXlJttWFf+VJtZQ99QzR+21emZE28O2CUpVbD2DQcQNB2clezzEf
         9BAUyq0JvyRUeblajSMAG9CQnC1f22YwFfHfmcYncDocwaMf+s1A+VtbQWcWIUHa4WkR
         jQeol8RxIBne1Dys2RIxlRdOXn1oif/0u0a5vLFRs92kb9yd9jeGHjzuK69fUTw9YIVS
         wnQQ==
X-Gm-Message-State: AOAM531K4gG6AI1p4OHMS+6T9QMIO/1Q+WwtWD2JndeyD6Rn3Te4mKXd
        jZ/P7nOoEm8f6jLRyZ19yE2teczffHY=
X-Google-Smtp-Source: ABdhPJygTIPih6byA97PhMrL37IOwvIpg0XG21+oeZWvjqhb+0eOo7HCJnihdbSygudCF2CTpzYYcw==
X-Received: by 2002:a63:2cd1:: with SMTP id s200mr10063582pgs.251.1639618687710;
        Wed, 15 Dec 2021 17:38:07 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id m15sm3483643pgd.44.2021.12.15.17.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 17:38:07 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 2/2] ksmbd: set both ipv4 and ipv6 in FSCTL_QUERY_NETWORK_INTERFACE_INFO
Date:   Thu, 16 Dec 2021 10:37:25 +0900
Message-Id: <20211216013725.8065-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211216013725.8065-1-linkinjeon@kernel.org>
References: <20211216013725.8065-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Set ipv4 and ipv6 address in FSCTL_QUERY_NETWORK_INTERFACE_INFO.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 v2:
   - move buffer check to under ipv6_retry to validate overflow.

 fs/ksmbd/smb2pdu.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 2ff4f813026e..0fbb62f9d509 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7224,15 +7224,10 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 	struct sockaddr_storage_rsp *sockaddr_storage;
 	unsigned int flags;
 	unsigned long long speed;
-	struct sockaddr_in6 *csin6 = (struct sockaddr_in6 *)&conn->peer_addr;
 
 	rtnl_lock();
 	for_each_netdev(&init_net, netdev) {
-		if (out_buf_len <
-		    nbytes + sizeof(struct network_interface_info_ioctl_rsp)) {
-			rtnl_unlock();
-			return -ENOSPC;
-		}
+		bool ipv4_set = false;
 
 		if (netdev->type == ARPHRD_LOOPBACK)
 			continue;
@@ -7240,6 +7235,12 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 		flags = dev_get_flags(netdev);
 		if (!(flags & IFF_RUNNING))
 			continue;
+ipv6_retry:
+		if (out_buf_len <
+		    nbytes + sizeof(struct network_interface_info_ioctl_rsp)) {
+			rtnl_unlock();
+			return -ENOSPC;
+		}
 
 		nii_rsp = (struct network_interface_info_ioctl_rsp *)
 				&rsp->Buffer[nbytes];
@@ -7272,8 +7273,7 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 					nii_rsp->SockAddr_Storage;
 		memset(sockaddr_storage, 0, 128);
 
-		if (conn->peer_addr.ss_family == PF_INET ||
-		    ipv6_addr_v4mapped(&csin6->sin6_addr)) {
+		if (!ipv4_set) {
 			struct in_device *idev;
 
 			sockaddr_storage->Family = cpu_to_le16(INTERNETWORK);
@@ -7284,6 +7284,9 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 				continue;
 			sockaddr_storage->addr4.IPv4address =
 						idev_ipv4_address(idev);
+			nbytes += sizeof(struct network_interface_info_ioctl_rsp);
+			ipv4_set = true;
+			goto ipv6_retry;
 		} else {
 			struct inet6_dev *idev6;
 			struct inet6_ifaddr *ifa;
@@ -7305,9 +7308,8 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 				break;
 			}
 			sockaddr_storage->addr6.ScopeId = 0;
+			nbytes += sizeof(struct network_interface_info_ioctl_rsp);
 		}
-
-		nbytes += sizeof(struct network_interface_info_ioctl_rsp);
 	}
 	rtnl_unlock();
 
-- 
2.25.1

