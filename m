Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761392D0602
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744405; cv=none; b=BzBkrzW9IElRnaD/KxeAe4aCL10Nf36A+bUjUq6oUbQZfiSK9V7oktm7lbfG6MauiVonZ8w2/eOxZx23BAu2hRAEj5K037b/5CH0PssQMo1wRoDebfFO7yGV7n5OcYdV2ZACZJzuO4JaE/CwpPE6hmKixvEpQg0TtKnUAsQSIdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744405; c=relaxed/simple;
	bh=3GUt6I8Bkza49mhI9fywtdH3073Nfrh0bl/NHu2nI4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxfbhQLw2xVdgEn+uqJ30Rcl9/wwxa4j+Us3v0bvCibCNoMU6RF97ppwk2pEphYwHWhLxpDHoII97PXqto4VfBHbKmkoMzPxnYeTyx/E+UE+y9nkWUqcRm4vPXJXLS6kHM/TVEfELAlPjTv3mIrZm+cM2X7INzarNfk7xCCLHEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=k7b1ePSb; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="k7b1ePSb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=JcojBEtkna30Hqo+F1gitVUuCLmWnxhc+qxt03rQrNs=; b=k7b1ePSbM4O1MpNQqhUdfCKwos
	pY1VvdHuEg+COoRdW8C3gwcvk1pCuRl3XuZg149L7T6G1V6xkklafzxdgPnB9dsSqYgx3r7DDL+hv
	a6hnJupbaU+2HxV+AnYflVMl3P4AzGdxm2zJo2341G09pnaikA1tQU78Vqw8hWqYwKIX/SnLv1UGM
	p4EX1JG0+5HQEZvcc+ACUvqZMnPS3nW7rSp31QLyqws+EOdz2j7smx09rtxi2BYKRxrZ3mwBxOtId
	dIL2lYmNES7ew0zydNvyBMhP9DjzXCJHN1cnOCxwY14hMPVP769MatxKbwW9VeN7/JK33xjYgJV2T
	OPp1WewIGcqsKRhabRRlk50fqbgQzrPdFUG+qIeY3oywGIO3/52++espeeeByPsHSIXYX+GDDt36Z
	27gmIPhA2RutRXatcSqs2UEznN6lB2CsmN5VCY8nai4Dtpj1ysmZp9Lv+lRGfjy8ePyZRSfJDhbtS
	T/1bswN/XSvels7wEXAh4ivX;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6CG-00Bbol-1X;
	Wed, 29 Oct 2025 13:26:40 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 042/127] smb: smbdirect: introduce smbdirect_connection_send_immediate_work()
Date: Wed, 29 Oct 2025 14:20:20 +0100
Message-ID: <cf7a66b45bf07e660e93c6c8857e278e94074156.1761742839.git.metze@samba.org>
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

This is a combination of smb_direct_send_immediate_work() in the server
as well as send_immediate_empty_message() and smbd_post_send_empty() in
the client.

smbdirect_connection_send_immediate_work() replace all of them in
client and server.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 .../common/smbdirect/smbdirect_connection.c   | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index e834fcfe05af..cb977f014c3a 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -1522,6 +1522,28 @@ static void smbdirect_connection_send_io_done(struct ib_cq *cq, struct ib_wc *wc
 	wake_up(&sc->send_io.pending.dec_wait_queue);
 }
 
+__maybe_unused /* this is temporary while this file is included in orders */
+static void smbdirect_connection_send_immediate_work(struct work_struct *work)
+{
+	struct smbdirect_socket *sc =
+		container_of(work, struct smbdirect_socket, idle.immediate_work);
+	int ret;
+
+	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
+		return;
+
+	smbdirect_log_keep_alive(sc, SMBDIRECT_LOG_INFO,
+		"send an empty message\n");
+	sc->statistics.send_empty++;
+	ret = smbdirect_connection_send_single_iter(sc, NULL, NULL, 0, 0);
+	if (ret < 0) {
+		smbdirect_log_write(sc, SMBDIRECT_LOG_ERR,
+			"smbdirect_connection_send_single_iter ret=%1pe\n",
+			SMBDIRECT_DEBUG_ERR_PTR(ret));
+		smbdirect_connection_schedule_disconnect(sc, ret);
+	}
+}
+
 __maybe_unused /* this is temporary while this file is included in orders */
 static int smbdirect_connection_post_recv_io(struct smbdirect_recv_io *msg)
 {
-- 
2.43.0

