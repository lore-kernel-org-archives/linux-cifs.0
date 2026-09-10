Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5BB1A3A80
	for <linux-cifs@vger.kernel.org>; Thu, 10 Sep 2026 09:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789031370; cv=none; b=NlH0XYV0SUid6X5CRWtRfTeXzVlUNg2Ku2ixczdWAAbjLfNGr920/PKMy1x+uXKJ3fHrIt25vCYINTrB7hL0ubTCjhzwdhBNiIjtNiR4NjqUn5A3q9fxPLrFNBUdTsYBktgWW9YknXL7bygD6gtncEZ7gdOKX7kNEbr/wup06ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789031370; c=relaxed/simple;
	bh=hVR/FYMuNu9uBqwvkMeHWPMtgGRlkP2e2g/lwD9f2NY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LW8GZYIKWE7OXmJ387d1Oeel0WddtAVTEN1mX6umUulOm7xCSW4LR//vdLueD2aLBHJFlMHa/IKL4swYo7xpPOpb9fIbuxd4NSFHHBpb4wb05cJiOGsI8VTfOI4Puek+II7Qe2TBGg8uuLlOvFvEpn5u2/qtHU8xxOSs8dwzbkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=j7GULNlU; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="j7GULNlU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=o8
	THzR+NFFB8ic+4r/g+NFFVO2+2eyuLbb4BBykymEI=; b=j7GULNlUIKZsyeUqRT
	O1f8w7XP5ZqOSHwyWbiGBoQ8NXzRgw68bTdU1QY9+jbk7WziBeN6MWv7/gYkvLOE
	HJmLXdLG1dw1et5BDi2iuI8wM+rZDxPlXKnQ75qrmX1Rz+tyYtQ/FQxDLWyN55tq
	UAQURAdGnJoJtHDJ6kNxvh4/4=
Received: from ubuntu.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wD3P5uXc6Jq4+lDBw--.14608S2;
	Thu, 10 Sep 2026 17:08:40 +0800 (CST)
From: huhai <15815827059@163.com>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	Henry Hu <huhai@kylinos.cn>
Subject: [PATCH] ksmbd: fix link speed query in fsctl_query_iface_info_ioctl()
Date: Thu, 10 Sep 2026 17:08:18 +0800
Message-Id: <20260910090818.24479-1-15815827059@163.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3P5uXc6Jq4+lDBw--.14608S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WFWrurW3tw4UJr1DJr1UJrb_yoW8AF1rpw
	4fuFykKryUW34fW34kJ3yruryav398WrsrKrWxGw42vF4rKrW3JFn7t34jkryfCFZYyFWF
	gF4j9anY93Z3WFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jeT5dUUUUU=
X-CM-SenderInfo: rprvmiivyslimvzbiqqrwthudrp/xtbCzRhGy2qic5hv8AAA3k

From: Henry Hu <huhai@kylinos.cn>

fsctl_query_iface_info_ioctl() used to call
netdev->ethtool_ops->get_link_ksettings() directly and never checked the
return value. If the callback fails, cmd.base.speed may be left
uninitialized. Also, SPEED_UNKNOWN (-1) is treated as a numeric link speed
and would be converted into a bogus link speed.

Use __ethtool_get_link_ksettings() to acquire the per-netdev ops lock when
needed. Fall back to 1Gbps when the query fails, or when the reported speed
is 0 or SPEED_UNKNOWN.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Henry Hu <huhai@kylinos.cn>
---
 fs/smb/server/smb2pdu.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b7ce67094626..b01d9cf07f65 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -10467,6 +10467,7 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 	struct sockaddr_storage_rsp *sockaddr_storage;
 	unsigned int flags;
 	unsigned long long speed;
+	struct ethtool_link_ksettings cmd;
 
 	rtnl_lock();
 	for_each_netdev(&init_net, netdev) {
@@ -10501,10 +10502,8 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 		nii_rsp->Next = cpu_to_le32(152);
 		nii_rsp->Reserved = 0;
 
-		if (netdev->ethtool_ops->get_link_ksettings) {
-			struct ethtool_link_ksettings cmd;
-
-			netdev->ethtool_ops->get_link_ksettings(netdev, &cmd);
+		if (!__ethtool_get_link_ksettings(netdev, &cmd) &&
+		    cmd.base.speed && cmd.base.speed != SPEED_UNKNOWN) {
 			speed = cmd.base.speed;
 		} else {
 			ksmbd_debug(SMB, "%s %s\n", netdev->name,
-- 
2.40.1

