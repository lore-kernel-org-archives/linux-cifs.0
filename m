Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5956FC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Dec 2021 06:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235826AbhLOGCg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Dec 2021 01:02:36 -0500
Received: from mail-pg1-f172.google.com ([209.85.215.172]:41729 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233735AbhLOGCg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Dec 2021 01:02:36 -0500
Received: by mail-pg1-f172.google.com with SMTP id k4so19283570pgb.8
        for <linux-cifs@vger.kernel.org>; Tue, 14 Dec 2021 22:02:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PfLZFetk+wCOI+mqmiygJ8P310n9OqOXgEwuhEFcEKQ=;
        b=0opuiGqGjo8Jixs75wytmJ43ogyv9QHcGaiRW/E9LbkVo8dQNHX8SMxKGuXtOH7Zwd
         NEkbYqoAIBaTGLyw4usm/Z7Nhhneg6qpD32WqSvRlfGEm5SSawycQz8s/BiGjJouxzh4
         5dFpDcnl2oNdc0iQ5n0+glyVnYgUcsyN2EdSsKkfsf4f8o0FQTTKdHYzwhm1taoYBUj8
         ufklNI2xEqsJNiTfSO7xayvvwHtFR9URzEEsZ63hDHDzAMWQShx802uh0kBQvIGLyi/k
         pWwjs2jMSL6uHY4MrFO17qOL4D3RSjaM4NldFVs33e2i5fh/IHprwKFrt8VSEryj59rK
         9VVg==
X-Gm-Message-State: AOAM532vJNYaU1wjm4g78gZPJRGH6AKoSeRA4hbGtn9FDmXmnOLzQDon
        w9+mU32IUZzQioFZYMVLLdxSTj0ErGc=
X-Google-Smtp-Source: ABdhPJwCXrVoqv5DyI+XUer+zGke+teR1T1oz0M7a67iOvuQUAO063VwLbVOrekEENPrWY4sLwG5NA==
X-Received: by 2002:a63:fa17:: with SMTP id y23mr6920068pgh.400.1639548155996;
        Tue, 14 Dec 2021 22:02:35 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id oc10sm4575249pjb.26.2021.12.14.22.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 22:02:35 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/3] ksmbd: set both ipv4 and ipv6 in FSCTL_QUERY_NETWORK_INTERFACE_INFO
Date:   Wed, 15 Dec 2021 15:02:05 +0900
Message-Id: <20211215060206.8048-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211215060206.8048-1-linkinjeon@kernel.org>
References: <20211215060206.8048-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Set ipv4 and ipv6 address in FSCTL_QUERY_NETWORK_INTERFACE_INFO.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 7aee3b58b16f..4f938f038a65 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7223,10 +7223,11 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 	struct sockaddr_storage_rsp *sockaddr_storage;
 	unsigned int flags;
 	unsigned long long speed;
-	struct sockaddr_in6 *csin6 = (struct sockaddr_in6 *)&conn->peer_addr;
 
 	rtnl_lock();
 	for_each_netdev(&init_net, netdev) {
+		bool ipv4_set = false;
+
 		if (out_buf_len <
 		    nbytes + sizeof(struct network_interface_info_ioctl_rsp)) {
 			rtnl_unlock();
@@ -7239,7 +7240,7 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 		flags = dev_get_flags(netdev);
 		if (!(flags & IFF_RUNNING))
 			continue;
-
+ipv6_retry:
 		nii_rsp = (struct network_interface_info_ioctl_rsp *)
 				&rsp->Buffer[nbytes];
 		nii_rsp->IfIndex = cpu_to_le32(netdev->ifindex);
@@ -7271,8 +7272,7 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 					nii_rsp->SockAddr_Storage;
 		memset(sockaddr_storage, 0, 128);
 
-		if (conn->peer_addr.ss_family == PF_INET ||
-		    ipv6_addr_v4mapped(&csin6->sin6_addr)) {
+		if (!ipv4_set) {
 			struct in_device *idev;
 
 			sockaddr_storage->Family = cpu_to_le16(INTERNETWORK);
@@ -7283,6 +7283,9 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 				continue;
 			sockaddr_storage->addr4.IPv4address =
 						idev_ipv4_address(idev);
+			nbytes += sizeof(struct network_interface_info_ioctl_rsp);
+			ipv4_set = true;
+			goto ipv6_retry;
 		} else {
 			struct inet6_dev *idev6;
 			struct inet6_ifaddr *ifa;
@@ -7304,9 +7307,8 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
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

