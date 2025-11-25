Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BCA527510E
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094727; cv=none; b=M9LrY5iO2yz6yw9QM1B52N0JWKHyxdKmF/bLQp/eZKgHVCxUXuHDXCpaKLJUsaxEQ9NP63APTfKxjckCiX8Evxi/ruuSJ/ggFJYaGFEpP/nnxTTDjH7FeC6czFsb/168EVc413MZP41zHGr2QsaLq2b0MAROdl6VIxSLHMgIivo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094727; c=relaxed/simple;
	bh=VhEwHlBvAclbGiemLILcpHWR9V6+dtJ98OxVniHOL7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTCtTeknq8afiZVhYzsp68QPy6d7TWFrMh4Z7xfH1uEYi4Io9/6hbOWh2lLoyZUSEu7zFrFA4lKryH6tVtSovWh+nf11/9kSGzBIz4uj+CqTmkFYPf/fHLZlZqbyxmg1CuPNtzDMVEzN2+Doe+0ttdJPepID0enaFOhBj59yhBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ibEVN0sz; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ibEVN0sz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=sT31C4tAeKhL06V6v2TfzRVrbNatNC0ToY8SoAngLck=; b=ibEVN0szryxig3nrrKmUHZyXwh
	ygIbaTjXcyfnkqdKIDDom1c9PKjT2E/F0u1eXOt36inYbEDbC/8Aj/Gyrb0uELC5KJP6mJ3QYbYVC
	NC7zsBW7UiwEV5nHBMRbIrXoTo4ERbKAGa2MEahsVs6NmBzPuPDyRwPnyhXjk9tnsEDQ9KauXY7vo
	bsJW7Li3Emybxy7E5FFiVP/1hxgi44uJ3iidV/d7J1aeklmsQWY8mXJy9gk7rAYxnPb5lED/QqjF0
	gvy/H44jps3QtUxWYvS1lXAMB9e/OOSmnnMLR7mSBo3lfSknIOxo1uxuJ0cW8mpTs4oUQWIJTD0Nc
	EzNXc6xt135y0PE8BeHw893e9ufhOVWWuiGFcH6tDI2Jw+hRdhWOGKwJbjU/XUGZgRLjb8/37eu6G
	4fEV9RKK9UjtO+Ou1wGqdp+aH/a3WYQgn7g3ImMg3FoWK9ifrDCaa7xTg4zp1fqdHNGyPOM8bTtvB
	upzd2KmcT/YkzM65rPo8GX6q;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxVg-00FeOE-0W;
	Tue, 25 Nov 2025 18:11:29 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 106/145] smb: server: make use of smbdirect_frwr_is_supported()
Date: Tue, 25 Nov 2025 18:55:52 +0100
Message-ID: <231e4c2aa79d4ccff6661c14ffe21c6ae768c347.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
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
index 9ebf19c5fa80..37c7f9524c6c 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -2212,15 +2212,6 @@ static int smb_direct_connect(struct smbdirect_socket *sc)
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
@@ -2232,7 +2223,7 @@ static int smb_direct_handle_connect_request(struct rdma_cm_id *new_cm_id,
 	u8 peer_responder_resources;
 	int ret;
 
-	if (!rdma_frwr_is_supported(&new_cm_id->device->attrs)) {
+	if (!smbdirect_frwr_is_supported(&new_cm_id->device->attrs)) {
 		ksmbd_debug(RDMA,
 			    "Fast Registration Work Requests is not supported. device capabilities=%llx\n",
 			    new_cm_id->device->attrs.device_cap_flags);
@@ -2394,7 +2385,7 @@ static int smb_direct_ib_client_add(struct ib_device *ib_dev)
 	if (ib_dev->node_type != RDMA_NODE_IB_CA)
 		smb_direct_port = SMB_DIRECT_PORT_IWARP;
 
-	if (!rdma_frwr_is_supported(&ib_dev->attrs))
+	if (!smbdirect_frwr_is_supported(&ib_dev->attrs))
 		return 0;
 
 	smb_dev = kzalloc(sizeof(*smb_dev), KSMBD_DEFAULT_GFP);
@@ -2518,7 +2509,7 @@ static bool ksmbd_find_rdma_capable_netdev(struct net_device *netdev)
 
 		ibdev = ib_device_get_by_netdev(netdev, RDMA_DRIVER_UNKNOWN);
 		if (ibdev) {
-			rdma_capable = rdma_frwr_is_supported(&ibdev->attrs);
+			rdma_capable = smbdirect_frwr_is_supported(&ibdev->attrs);
 			ib_device_put(ibdev);
 		}
 	}
-- 
2.43.0

