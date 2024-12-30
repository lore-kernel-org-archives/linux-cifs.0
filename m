Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859B21B0409
	for <linux-cifs@vger.kernel.org>; Mon, 30 Dec 2024 12:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735562715; cv=none; b=DPrjl9tnvTv0RD0Ctx2wMrh9QPcyJocYMwtdbFZTGasLt0deURs11VQcYgXH1jJ04G1/5mNVGjYL3ZGq8aC90IxCTj/S5aaZTyxT0IllAeTM7DThtBCuDP+G5cdSr/4svSas38+EQY7kU64neYE/92bdgzrrFsKjUQ4Hh2N6Njs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735562715; c=relaxed/simple;
	bh=SM5OEG2WOR3EkzZSOZKYvY3khvk3bWQtvnY2U8+T9j8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jWKsQy9XaBfRDwxoxNlIp1Nl78vXgdz39cXqu8XiaYqmP2L5yVlgcjShJG0ry3/xlsPpfuSFAHlGnw9WHYo2m5ImZUlYMEIzfnuvFpyFbfHNWPnI7KTCNiQKQZSOmPxJoOzDRQ7660n+P5d+7ovUDKsMgb6trOpRQgGbdq7XqWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=F2u2XBDm; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="F2u2XBDm"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1735562710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wf+Yduqw4GwSq6FzAP5ND/sUCG5O8H+zycnI3fj19L0=;
	b=F2u2XBDmiMNtPEf1reHz58eqIN6c3BPrQirr6f/KHG0tPuMgwnvYU7yCJrmFSaCtGaLhNB
	+UFHoNASm7JhrCvFjYfqf0XbD+qg98QzsqlLWNQbGQy9BB9wvSoiKKT5RBlPJQRmcTfwwK
	ecYtZfgYU9J32JsAH3hJHJNcYB9zDRA=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <sfrench@samba.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ksmbd: Remove unneeded if check in ksmbd_rdma_capable_netdev()
Date: Mon, 30 Dec 2024 13:44:56 +0100
Message-ID: <20241230124457.884986-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Remove the unnecessary if check and assign the result directly.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/smb/server/transport_rdma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 0ef3c9f0bfeb..c3785a5434f9 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -2283,8 +2283,7 @@ bool ksmbd_rdma_capable_netdev(struct net_device *netdev)
 
 		ibdev = ib_device_get_by_netdev(netdev, RDMA_DRIVER_UNKNOWN);
 		if (ibdev) {
-			if (rdma_frwr_is_supported(&ibdev->attrs))
-				rdma_capable = true;
+			rdma_capable = rdma_frwr_is_supported(&ibdev->attrs);
 			ib_device_put(ibdev);
 		}
 	}
-- 
2.47.1

