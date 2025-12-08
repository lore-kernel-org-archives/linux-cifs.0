Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A2522D785
	for <linux-cifs@vger.kernel.org>; Mon,  8 Dec 2025 16:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765211124; cv=none; b=Ol/XpeTTt6MvC3iCRRy/VNRIXbOmv3XBXGehOpy7UwoGNn0bGD0qQjhhstJm3q/df9CVa2a5G+5wVC654sPOWHkOxygwqRQic2h8UXUrNXfsfJTKbG3nxevGCOg3x2jCX7CBJ3qIiHekj1U8ZDeIh+y5HG3N78WZTmvKH0MYkQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765211124; c=relaxed/simple;
	bh=xlTEHXzooNNDeBGXIesmCNyNHRun9mTjr4WRgeJFFxo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jmdrELrIYCSMz9CYmrDIShhEj6FL0tKiKbM/8CU7Zfs8oZ8d2c9fkBAv/wViNCGvJZIMnEd1o0byEDXP0riH63FhH4ZyzQzeZyP09XobuagwK7IcdBPbGocqO+0C8uaxBzaSHZtn6IWxvdzWiLqaUCTg1GyBP5KUcg1ecD+AQLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=IMQgl7hK; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="IMQgl7hK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=CiKrVI85vD3bbzXcBhDbKFazTe0ABFjTGTTal9tlVOY=; b=IMQgl7hKwD6HCTpMYBDwu+KKlQ
	jchSddw9z5IgIpRHGKOHcRkqD3NymoZfuZs3u+CAzVCKDiZLUxlk+6RECScEhK+7D55qp8opVGoIp
	MlvlZq2khacm4An+PjHWgW/DScwTmi7KfFiUuLUlURjcRfNDqoaEJ2IyPhU+JwPIEWtyw5nfSsh7a
	68frh69d7NkPvzY0MYGmnvDmT7U2ntwF6JNgut7ey5ogF4MrEnyc5JyWkjSPY2Mt/yKxLb+mKvGwf
	4b9CgF9qcYzPx7+xXmzSDibOy0YgnMuvhmWGBp1P8KbzQ28Dzs5gGwtZt1QEl8B4lD3cm0sUWjRYq
	rPty2b970THA2alk3ej3HE6W5xSxdk9U1HY0ZHws5x/y191kJi+vz6e4myCOe9cnQ7qKy14EP5YFU
	OZsxdM5UUMWLECvZ8WDyIm07bwXe55JvYa396R36NHPcAigqnm1FCHJzub+B7oy5zr3p+N+xoEccX
	6m14GW2zRMSWHnJPy5+Bi/6b;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vSdUL-00HPnf-26;
	Mon, 08 Dec 2025 15:49:25 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH] smb: server: reset smb_direct_port = SMB_DIRECT_PORT_INFINIBAND on init
Date: Mon,  8 Dec 2025 16:49:19 +0100
Message-ID: <20251208154919.934760-1-metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This allows testing with different devices (iwrap vs. non-iwarp) without
'rmmod ksmbd && modprobe ksmbd', but instead
'ksmbd.control -s && ksmbd.mountd' is enough.

In the long run we want to listen on iwarp and non-iwarp at the same time,
but requires more changes, most likely also in the rdma layer.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index f585359684d4..05f008ea51cd 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -2708,6 +2708,7 @@ int ksmbd_rdma_init(void)
 {
 	int ret;
 
+	smb_direct_port = SMB_DIRECT_PORT_INFINIBAND;
 	smb_direct_listener.cm_id = NULL;
 
 	ret = ib_register_client(&smb_direct_ib_client);
-- 
2.43.0

