Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04847329372
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744829; cv=none; b=BOLk1Cuilphj+SeEkdx2/ZWyG7tjvJ4SsPNnwxIdFPDTDfxr1lXyPQ8OGZ7P2S36QgyOQMZWE7lr664yz923MbsWZmq/At924Q639n2/x2yJuHUBX8Q9r6Q2byULSLfpwtu9SNeV7tY5qmjpV/Vrx8yWKr1l85yk6fUvCV6iO/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744829; c=relaxed/simple;
	bh=lfHzUBL9kDuSyEA5+tR7MuRr/EiVHlOuoqgZeP43jSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crBQaLojjHiobGsxpVwQW1OHzOizs7KaHOSuGtexCwyQ/9wWzo0LtOUB7Bebia5Rpdz+PzWcfM/EzvxaxZ8CFOKZkx0xp4/dLuLtqOdmj5scqZ/zZimXZo9Tcr0a6YBhIMvJzp8kxNG1MYWjE/LPv3uE9NBsfpcx7xwZwdnWniY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=eobsnSuf; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="eobsnSuf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=mJf35CW6IbEVf9r1criD2105WCtqm8Ul1qcNtDpHZY8=; b=eobsnSuf9Tv1b4gbfZ82IU/+Op
	weEwDTxtN9KaOsZo09bx1AYoyOrrif0aZcICr/DcXYDIFt3XLNPJtyTpbqBdtovJSJYtauekv9d1i
	ZEUQY94y6pyIehIjB4CKfF02YsyOGc5MflIIhDT5Ux+tZPDIRavQioBw6yKTVcmjSnQKhWYFAjznb
	o1KJaxCdCxgHucLAfCLtULKtsNbXYxIsnnfwm3ed3i8cQpxQ+dO2Odc0dOac3tODybziVFxPb/Jzo
	RhHkxWByGf3ENlbN//6sI/eoMJ9F5Jm0EQ2bw5G+4WE2kudUzSn9fJrj8IriyxgdpR8DwDV5kg40H
	W65nbtfBZhr/LUrMb7cmf2LawCUJ6U6eTCHl3GE5wotHwzFcpBmmAvd9ma6v8jTeaLiytdB14WqHX
	RpYR5GD79h3c7Hy9ZwL6uc8LHiGgdqQ5mYOX285+yasJ/Odi2HSFiJE1TJY0ca4qz2JE2/EJk8rnq
	evjLSSMJCftxZ1vt0I0eJgdT;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6J7-00BcxX-1U;
	Wed, 29 Oct 2025 13:33:45 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 112/127] smb: server: make use of smbdirect_connection_wait_for_credits()
Date: Wed, 29 Oct 2025 14:21:30 +0100
Message-ID: <ddd5c1df1286b03bff2c34f1dbd4535e78b03405.1761742839.git.metze@samba.org>
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

This will allow us to share more common code between client and
server soon.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 42 ++++++++++------------------------
 1 file changed, 12 insertions(+), 30 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index d8829cb57270..3902ba403c0f 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -757,27 +757,6 @@ static int smb_direct_flush_send_list(struct smbdirect_socket *sc,
 	return ret;
 }
 
-static int wait_for_credits(struct smbdirect_socket *sc,
-			    wait_queue_head_t *waitq, atomic_t *total_credits,
-			    int needed)
-{
-	int ret;
-
-	do {
-		if (atomic_sub_return(needed, total_credits) >= 0)
-			return 0;
-
-		atomic_add(needed, total_credits);
-		ret = wait_event_interruptible(*waitq,
-					       atomic_read(total_credits) >= needed ||
-					       sc->status != SMBDIRECT_SOCKET_CONNECTED);
-
-		if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
-			return -ENOTCONN;
-		else if (ret < 0)
-			return ret;
-	} while (true);
-}
 
 static int wait_for_send_lcredit(struct smbdirect_socket *sc,
 				 struct smbdirect_send_batch *send_ctx)
@@ -790,10 +769,10 @@ static int wait_for_send_lcredit(struct smbdirect_socket *sc,
 			return ret;
 	}
 
-	return wait_for_credits(sc,
-				&sc->send_io.lcredits.wait_queue,
-				&sc->send_io.lcredits.count,
-				1);
+	return smbdirect_connection_wait_for_credits(sc,
+						     &sc->send_io.lcredits.wait_queue,
+						     &sc->send_io.lcredits.count,
+						     1);
 }
 
 static int wait_for_send_credits(struct smbdirect_socket *sc,
@@ -808,15 +787,18 @@ static int wait_for_send_credits(struct smbdirect_socket *sc,
 			return ret;
 	}
 
-	return wait_for_credits(sc, &sc->send_io.credits.wait_queue, &sc->send_io.credits.count, 1);
+	return smbdirect_connection_wait_for_credits(sc,
+						     &sc->send_io.credits.wait_queue,
+						     &sc->send_io.credits.count,
+						     1);
 }
 
 static int wait_for_rw_credits(struct smbdirect_socket *sc, int credits)
 {
-	return wait_for_credits(sc,
-				&sc->rw_io.credits.wait_queue,
-				&sc->rw_io.credits.count,
-				credits);
+	return smbdirect_connection_wait_for_credits(sc,
+						     &sc->rw_io.credits.wait_queue,
+						     &sc->rw_io.credits.count,
+						     credits);
 }
 
 static int calc_rw_credits(struct smbdirect_socket *sc,
-- 
2.43.0

