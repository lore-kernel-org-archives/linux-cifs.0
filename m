Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE08371053;
	Thu, 22 Jan 2026 17:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769102308; cv=none; b=lUXY7qbrpHBd4uNjvQQdiYG3ROndaPuOJmuGsyXmt9sK64qmaMDCt0eL111l1sljybEIQbSwOUUaqGq1JyOqROrmWmgn7jCAn0d0mUUs4SwdZ6wcJGnLzP5BVgvcAFxqeE4bF01TWHn104Kto2cDdrrIVfwAXHd9RKYju9CzoGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769102308; c=relaxed/simple;
	bh=XvwSPZcivfzNuq/9FiO7xqrChG/9+HdG2D927WMqhJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqLcGR04NCuJl4r9D2R2i99ULAIlJsiabfl6eIZ89fYEuoDO9xZOq2XFcXRMEpuSJCy2/pNrpIeXoaYDMuq2Hcfs07QLspmFTp1tV2sYDErnHDg9iZHVMn5e0rIZzfkazOh6pkTXnlo1FhqOatYGusEgqJEy5VOn/lYj4Q6LeEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ZUomD/gu; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ZUomD/gu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=xEc89crKM/l86w0No2H1ucD7L5nbNmANhmh4sQkynl8=; b=ZUomD/guJhrwhh4X5YjkCRh2gh
	sFyxFDSWr8cZrwOizjvxmMQcBkND+ZuDuxYJC6ZkhYDiL6y0yK2XcMP/lH89l9TTUrkPd35S0Ja1I
	eEOJ92ULKzqZQ5Lvo4NXLzHfSoSpoG78LzDNz2n0NRLzrV97MuQKqK4wFGW/t2xGDCJZbVJSp7gsm
	FvNPEL8FZKJekx3EyAn46m8EKJVjBjCf1SgtGjPicqsi/aDi2kDAA8A1MF6HdC1ZZ/nRHWwTu9QFJ
	BxBurn7ZkccTXDdBcmrYpcFvGhzfw4RzIWvgV762FuPdNC6jp1Q/x5GrVjSRkC2Ew3dPSnFJRXY6t
	3e0BpmYiTvH+GIyDPL9+OfvJ4ExJsLfndmi2Wso1WIdUbPHpwSsB+r84Hhr9KSFrlZFCPTI5ArRQW
	QMRqqSinF4ZTBNb6lBnOJTO0GJ+LHHQNHcQP3990hXq5pcdAIHGhx/6JA+PerTjHkf5ejrUf2S3DA
	EJvnsVGmjKxT3bVzvyAZdxfG;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1viyK3-00000001ptK-2mqu;
	Thu, 22 Jan 2026 17:18:19 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 12/20] smb: client: remove pointless sc->send_io.pending handling in smbd_post_send_iter()
Date: Thu, 22 Jan 2026 18:16:52 +0100
Message-ID: <41b38ffd722b542f017bb455dadb73232d8a1720.1769101771.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1769101771.git.metze@samba.org>
References: <cover.1769101771.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If we reach this the connection is already broken as
smbd_post_send() already called
smbd_disconnect_rdma_connection().

This will also simplify further changes.

Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index c9fcd35e0c77..cfbe8ce0db42 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1274,11 +1274,6 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 	if (!rc)
 		return 0;
 
-	if (atomic_dec_and_test(&sc->send_io.pending.count))
-		wake_up(&sc->send_io.pending.zero_wait_queue);
-
-	wake_up(&sc->send_io.pending.dec_wait_queue);
-
 err_dma:
 	for (i = 0; i < request->num_sge; i++)
 		if (request->sge[i].addr)
-- 
2.43.0

