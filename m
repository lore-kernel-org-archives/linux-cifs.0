Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B20A4A5C22
	for <linux-cifs@vger.kernel.org>; Fri, 11 Sep 2026 16:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789144612; cv=none; b=XvPixK3oi8JwkHYwcNLnfq+fC+z+1f8FuDqVBtCps+0ekarsMG5HGB1GPSr7boqs5fk5LQiT7Sa25EdKERY7+N6O4CNJwx4lOJcNeDd7AOwtRSzXT2vKas1McOlnyMrq6B9mbXXW3Ww99kxa2HY5oRS5fcYDTpFhbYCXLZHClP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789144612; c=relaxed/simple;
	bh=3bevo8HnW8zcldnmzNq+/gJiIh8zBL4XAgVUE5IYW2s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p6nq5Wd7j9RYWklbKKOH7+8dBZ78PdhfPoQFiEsZKVrc+mCtJrAhAuE1eYlAjdCILcYweJ85/MDLMTqQtV1NjozDkUZFBM2ixUZOZ7aIq5JvU2Is8C1QuD+/kklTMP0Rj2DApex5yx4UHrUV0UjtY+Q9BEBvu14ZIVklb7oRPiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=EOMskpWK; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="EOMskpWK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=4Q
	L4wlfvvNkk90u10iZMuCWk6rhZMlO8mo5BXZVwqto=; b=EOMskpWKyBNamAXunO
	pHsTaYo6Xu6P7klGFqw4fqZWAN/no6vXHK5e4VP5QnPRJbytURq+Eu1oxMra1Srw
	Yx01FIXZ01BYZpnv/z+kf7J07QtI8pj/5kjHqat15SN3y97T7ufwukqPimbLIsKT
	d76Nidt4AGgB5j7CHBS4Beazo=
Received: from hh.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgDnmY37LaRqM4PiOg--.53919S3;
	Sat, 12 Sep 2026 00:36:13 +0800 (CST)
From: huhai <15815827059@163.com>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	Henry Hu <huhai@kylinos.cn>
Subject: [PATCH v2 1/4] ksmbd: fix link speed query in fsctl_query_iface_info_ioctl()
Date: Sat, 12 Sep 2026 00:35:13 +0800
Message-Id: <20260911163516.6403-2-15815827059@163.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260911163516.6403-1-15815827059@163.com>
References: <20260911163516.6403-1-15815827059@163.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgDnmY37LaRqM4PiOg--.53919S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7WFWrurW3tw4UJr1DJr1UJrb_yoW8AF1rpw
	4fuFykKFyUW34fW34kJ3yru34av398WrsrKrWxGw42vF4rtrW3JFn7t34jkryfCFZYyFWF
	gF4j9anY93Z3WFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jzuWdUUUUU=
X-CM-SenderInfo: rprvmiivyslimvzbiqqrwthudrp/xtbC7x1O02qkLf3LZgAA3c

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
2.25.1

