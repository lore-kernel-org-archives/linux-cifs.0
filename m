Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB87360ECE
	for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2026 14:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789481378; cv=none; b=ju0ZrgkY2mTiHlV2OTHdQjz+wiskiq01S6mDN1kOfwoXQqMA7Qd1DDpkllflnR+b100pE+bZT+r/rcpQfR/4OM6LHvNiAhCxmbBik/R6wTylAuxg1TrPOw+WTLXi4AXYH2oJafYyN3tN7BYJGD0k6x95qkXoaC/LzkRxm1brm88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789481378; c=relaxed/simple;
	bh=yREmkMnVFGc2Wc0eQ78jm0lknObDoFuEPh83zenjuV8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rPXOQARdT599/GWDJ4A+21iPMJVYU785K3+lFVVeZOIZT1/rbultyAlGju8sOzqVxixMnZhh+HsmK3Y+SKHYsgc5NmNq+onv/VwSLyQdJcfSeUEKJDXx3K08bfdZr/z3XctCbIQ5HfDhe9zzLNnrakWpvfE/9xy5QYDC39XhB6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=E7V4sgPD; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="E7V4sgPD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=cL
	PDLM8JxOmXSK6wk59sp6hMYxg/dzPIWecGH4Q9iZc=; b=E7V4sgPD323N9DPOsK
	pHJoG8sQ+5QsZF1VDZkb0Cg7Q+DYQsbwYr0qOokYDemTJFv8/TOMzwpRkPvO/m0r
	tolRQAzZoaqmfF1ZWSJreTing4gYNl+9vzkHQvx4JosPZNQ4f03bpQsk+fvCenGA
	EK+xtqJSIcMXSGFEryC4MU8HQ=
Received: from hh.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wDnj1N1UalqZ_l6Aw--.52667S2;
	Tue, 15 Sep 2026 22:08:54 +0800 (CST)
From: huhai <15815827059@163.com>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	Henry Hu <huhai@kylinos.cn>,
	Sashiko <sashiko-bot+sashiko@kernel.org>
Subject: [PATCH] ksmbd: fix iface_list use-after-free during server reset
Date: Tue, 15 Sep 2026 22:08:34 +0800
Message-Id: <20260915140834.5616-1-15815827059@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnj1N1UalqZ_l6Aw--.52667S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KF47Cw1UKryDuw4DGF4kWFg_yoW8tr4rpF
	W5WrWqkr4UXwnYgr4kXayUC34Fgan7W347CFyxuwn3XrnayrZrtrWkt3sI9r95A3y8WryF
	qF4qv3s8uw4UA3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j46wAUUUUU=
X-CM-SenderInfo: rprvmiivyslimvzbiqqrwthudrp/xtbCzRZ2+2qpUXbnIwAA32

From: Henry Hu <huhai@kylinos.cn>

ksmbd_find_netdev_name_iface_list() walks iface_list for
fsctl_query_iface_info_ioctl(), which holds RTNL. But during server
reset, ksmbd_tcp_destroy() unlinks and frees the entries without RTNL,
and queued SMB requests can still be running at that point. So an
FSCTL_QUERY_NETWORK_INTERFACE_INFO request can therefore race with
interface destruction and dereference a freed entry. With debug-only
instrumentation to make the race deterministic, KASAN reports:

   BUG: KASAN: slab-use-after-free in
   ksmbd_find_netdev_name_iface_list

   ksmbd_find_netdev_name_iface_list
   fsctl_query_iface_info_ioctl
   smb2_ioctl
   handle_ksmbd_work

   Freed by:
   kfree
   ksmbd_tcp_destroy
   ksmbd_conn_transport_destroy
   kill_server_store

The fix is to detach iface_list to a temporary list under RTNL, then drop
RTNL before cleanup because the following cleanup may block and hold RTNL
for a long time.

Fixes: b2d99376c5d6 ("ksmbd: browse interfaces list on FSCTL_QUERY_INTERFACE_INFO IOCTL")
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Link: https://sashiko.dev/#/patchset/20260911163516.6403-1-15815827059%40163.com
Assisted-by: LLM
Signed-off-by: Henry Hu <huhai@kylinos.cn>
---
 fs/smb/server/transport_tcp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 4968cfc1a572..e6f663acf5f8 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -656,10 +656,15 @@ static void ksmbd_tcp_stop_listener(struct interface *iface)
 void ksmbd_tcp_destroy(void)
 {
 	struct interface *iface, *tmp;
+	LIST_HEAD(iface_list_to_free);
 
 	unregister_netdevice_notifier(&ksmbd_netdev_notifier);
 
-	list_for_each_entry_safe(iface, tmp, &iface_list, entry) {
+	rtnl_lock();
+	list_splice_init(&iface_list, &iface_list_to_free);
+	rtnl_unlock();
+
+	list_for_each_entry_safe(iface, tmp, &iface_list_to_free, entry) {
 		ksmbd_tcp_stop_listener(iface);
 		list_del(&iface->entry);
 		kfree(iface->name);
-- 
2.25.1

