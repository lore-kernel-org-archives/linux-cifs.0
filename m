Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF44323182D
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744761; cv=none; b=f/gZ4wNXHuFeAo6oGmlcHmr+CcvmkQ/P4b9KivkGZyMrekxmTYmcEtlQ5C5phchCuizM0UqL8hmHBpHoSMzHMjzOo/+eK0GB7hZS1Ys604TPRZWDgiEwF9J5SQdjRK6tDR9Mf4yY49YGzLkU6zCUxOBFrH644R9zN6khDQkRr5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744761; c=relaxed/simple;
	bh=8B87I+1vQYarHP43kVij5G6sltExeuIcBkXRtaY4nDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5ElP/blv3e7wux6hues+d5GfJGb29S+4Llwq3w0f2sQj8PVzs//i+6Q9XHDmPRnarMlXZOyEEaZOKnWJKey7n1UdQhD5N4DRtLjiwYlGRRCuGop2w47aK1RZg6ejDY7ccg16XgsqGmbEnVmLmRq+eI5kb4bRf3OJKdrkk2k7+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=fVzxHvEI; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="fVzxHvEI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=E7ggdYeEdFHJlGINPQsrPGnqd/pfHpF/99bFkD2GYUo=; b=fVzxHvEI579+fe0yCzO0FCSnrW
	LPw8Ut0zAI7thzPZ+EQYDsA0xzCbSj/ZBjtTN+p6jwpqhJKAoGosRq1ow+CNAv46bOPT5arRLlmdD
	36Rnrrp6wtPEcnN3LpRjuEFz7KBy+Mp0UyZqsOuNZL/91bQl4cVHl1RPU1zh6f0W+hOOTV3YZbTBb
	yk4U6OgMr1eu4NHymNoPGNgISPzoHPfwplOoCyWkSXgQle9l1lHFLZrj3zcDpdVXzvPSDcGQB8xk6
	FVfsGnuaylgpnkZQTANQB9p0TXC++Y797KgoWU++dBYmElayyTKjrmnMqNOVWJHi0N/1nzGlXCqFv
	7c3MkfLd6HfEGVR7OKSlJqbiePsUsGrR4MQIpwKQWRWXxyRjBoGcohebNJyCt+7ik3OeLmYueGv5u
	DSfVuR42xck6kDjiDeAdze+zGP4f/sGGTFIBVnizEb0963ARkZt/cqt3BBniIGOW0ucxLv16gEw+o
	reXcZuKtIinaw6B73w1LkWgI;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Hz-00BclQ-1a;
	Wed, 29 Oct 2025 13:32:36 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 100/127] smb: server: make use of smbdirect_frwr_is_supported()
Date: Wed, 29 Oct 2025 14:21:18 +0100
Message-ID: <d191362c9e5b2002cf665c3d2eab88d057c2cb3f.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an exact copy of rdma_frwr_is_supported().

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 886a350819bf..7181d9f62b09 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -2179,15 +2179,6 @@ static int smb_direct_connect(struct smbdirect_socket *sc)
 	return 0;
 }
 
-static bool rdma_frwr_is_supported(struct ib_device_attr *attrs)
-{
-	if (!(attrs->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS))
-		return false;
-	if (attrs->max_fast_reg_page_list_len == 0)
-		return false;
-	return true;
-}
-
 static int smb_direct_handle_connect_request(struct rdma_cm_id *new_cm_id,
 					     struct rdma_cm_event *event)
 {
@@ -2199,7 +2190,7 @@ static int smb_direct_handle_connect_request(struct rdma_cm_id *new_cm_id,
 	u8 peer_responder_resources;
 	int ret;
 
-	if (!rdma_frwr_is_supported(&new_cm_id->device->attrs)) {
+	if (!smbdirect_frwr_is_supported(&new_cm_id->device->attrs)) {
 		ksmbd_debug(RDMA,
 			    "Fast Registration Work Requests is not supported. device capabilities=%llx\n",
 			    new_cm_id->device->attrs.device_cap_flags);
@@ -2361,7 +2352,7 @@ static int smb_direct_ib_client_add(struct ib_device *ib_dev)
 	if (ib_dev->node_type != RDMA_NODE_IB_CA)
 		smb_direct_port = SMB_DIRECT_PORT_IWARP;
 
-	if (!rdma_frwr_is_supported(&ib_dev->attrs))
+	if (!smbdirect_frwr_is_supported(&ib_dev->attrs))
 		return 0;
 
 	smb_dev = kzalloc(sizeof(*smb_dev), KSMBD_DEFAULT_GFP);
@@ -2485,7 +2476,7 @@ static bool ksmbd_find_rdma_capable_netdev(struct net_device *netdev)
 
 		ibdev = ib_device_get_by_netdev(netdev, RDMA_DRIVER_UNKNOWN);
 		if (ibdev) {
-			rdma_capable = rdma_frwr_is_supported(&ibdev->attrs);
+			rdma_capable = smbdirect_frwr_is_supported(&ibdev->attrs);
 			ib_device_put(ibdev);
 		}
 	}
-- 
2.43.0

