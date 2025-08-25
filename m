Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D937E28F1
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155853; cv=none; b=jLomL0Os7kqyiKVxdQXEzsowmwZogwE0u16eEoWM0ubfie91Q9JjUBz4S7AbE7cntVxBYcU/fjZ6EgwtZdQ8nCNR+d9eXfJGJU0UgDikfRyOVOU15/Slg/QE/vcLheBQJ3RQoA1Xsp5s0+1p3YOQom8W54TIAeVP7i93ZpJuGlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155853; c=relaxed/simple;
	bh=4p2/bYwm+sxOTVYycIp36msCLYFmljYuxXrBwuJIHok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDBoGD1lC53RIt9CBME6Bfvg8SNaZZardPFonuMveovJFJV/4u5SvmRI7ZUB+Mo2yed4Fl5h6EJo+jb/WZYlnRsoYep5nkyeLWgoRatXb1kFspzn6GKX1FbQQA28T2CPbdX4wdk6/cNmTv6B953C+OiageGJMhUzmi9pgufzvJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=3cjsD/zz; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="3cjsD/zz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=JSK+riPPPf08vYfT1RBtQsvn92r3VHjyW5AHCdAF5AY=; b=3cjsD/zznwqKL+0TSSE6iU3mnM
	D2WGCuHCapm7JjHtTfCOdFa+b/znVTmUwmYAgi2wQYYRhqUfQ/Ckstcc/KYMzll1JCp1zp8JtRrLm
	iqkVVbQlxaZ8bdm/mgmQN7ky7FSkmgfn3ksEZeZbQtts6esBtYbgDcps91T/tGOJIPkM/IC7w+7yM
	eLQ2iGIeBeh8P9N2inTsb2H2WtREN2j5fIFogE7fqb2GCC6NWh4Kxw3JxrcBA2/k4DRPfBW0qgDzf
	DPzA4CJiNyjEAv/MzOoGswJFhHEcmNld0mYhHDbwNMZUV9b2dU2vtBlf61LFZEx0bt31SiaJZpjTk
	f9f/1u/+VMID6Lk50wpwk/PhEIHhNuDZdTBEXJ2hYRyWHWaseHLxqInpiib5EUy4g6P2kClItcxnP
	XcCd6j+TzmJnDcGfeMKtzAuBxWaQSR9Nz7w4Sxr6WIF4ywr6/tNvCaFuHrigBWOrmfZlhVhbABI81
	tIg98u7uLWsItVLqGwLn/0lc;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeMK-000ngc-2j;
	Mon, 25 Aug 2025 21:04:08 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 134/142] smb: server: pass struct smbdirect_socket to wait_for_rw_credits()
Date: Mon, 25 Aug 2025 22:41:35 +0200
Message-ID: <568abc598637207c7dae45cc46b2c5b927c90b32.1756139608.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will make it easier to move function to the common code
in future.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index defebe773b8a..e47ff55af2e0 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -982,10 +982,8 @@ static int wait_for_send_credits(struct smbdirect_socket *sc,
 	return wait_for_credits(sc, &sc->send_io.credits.wait_queue, &sc->send_io.credits.count, 1);
 }
 
-static int wait_for_rw_credits(struct smb_direct_transport *t, int credits)
+static int wait_for_rw_credits(struct smbdirect_socket *sc, int credits)
 {
-	struct smbdirect_socket *sc = &t->socket;
-
 	return wait_for_credits(sc,
 				&sc->rw_io.credits.wait_queue,
 				&sc->rw_io.credits.count,
@@ -1401,7 +1399,7 @@ static int smb_direct_rdma_xmit(struct smb_direct_transport *t,
 	ksmbd_debug(RDMA, "RDMA %s, len %#x, needed credits %#x\n",
 		    str_read_write(is_read), buf_len, credits_needed);
 
-	ret = wait_for_rw_credits(t, credits_needed);
+	ret = wait_for_rw_credits(sc, credits_needed);
 	if (ret < 0)
 		return ret;
 
-- 
2.43.0

