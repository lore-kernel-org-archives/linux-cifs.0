Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C40632AACE
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093501; cv=none; b=u9kTiDzIET1wFrb3wqny4UnfaUB0fiYMRn2LGkwrSEFHzP73yPauOZoAjGBJta0o258WXkrb6F4ddAbu7euvyeLusxGr+ptBICMNHnqL6MaPnOGjcpm9P0nF4h1/MftM/3q0t/gPTlu1Mh5yMG+UwQar2unI82YSX3KLdYdas6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093501; c=relaxed/simple;
	bh=RIghT5KH6viMZqVmAn+WF95Dn2amsjAtbaYFVN1r6Xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wxdr59USvJRlrax5OzcP7KI/LrUrm1QdgYYW0bxASoKuM6M6giems9EJQJB3nBG482f14WymEDx+f6/J6j0jjgx8Yy291V5E50TDkmcSkIZisDzOHQ13aJevD7Iyn2c6prQV8YxiIW48nOLI+U6FtpWuadnbtJ5zKsCcJgo6mKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=WwRmqayX; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="WwRmqayX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=td+mDRlO4KLBe1dwcu8mq2h7nCS32fUqanVAFUTC3y4=; b=WwRmqayXDY8JIV2mgbToKY5z5m
	OyOlZiJBzEUorkP356+JMdLa86dF2rybdqTpecx5vey5UvFWQHdLosIXUyu+zaVZHDxEX1ay+FKlI
	Uo89HXnFgIpGKk01+0Wgx+b8PWmuKXHOKompToupgf76yypEjQrEYSirkQFT2incfrD0VaN+xVz80
	/V1iQQXMaYxkC/Z8JHPRMiNGFBXw/YUCcGdus30n8aE2+mz2wbXiLWq4s6qbifpnnnHrZN7iy9ejg
	OLvUSN0gtegbD1PNqndQYFabRb10/o01BSNStaq6knI4EBwe/jEvP3BlMa6SMcvY+gdEI8xR3l7P7
	fZ+93oJNWGwd5gqoXjr8dzrRlnevu6HY9Sc/t3azLyHmGsBTBhbmpP3LcRcOg4v9t/ZZ9N3kazToY
	VYwGTsf1mybnegUQUHtX5JUbJF02CaqqProdnl4UK+DGCdk2LHjElwtXAgNBe1K92oL5TdFno+N7G
	/60nsLE5WUjzR2TPht6dQZqI;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxIu-00Fcjb-2i;
	Tue, 25 Nov 2025 17:58:16 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 016/145] smb: smbdirect: introduce smbdirect_connection_{get,put}_recv_io()
Date: Tue, 25 Nov 2025 18:54:22 +0100
Message-ID: <df9c3bbbd8e214eebe6ea5b0e6c883fe47a874f5.1764091285.git.metze@samba.org>
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

These are basically copies of {get,put}_receive_buffer() in the client
and they are very similar to {get_free,put}_recvmsg() in the server.

The only difference to {get_free,put}_recvmsg() are the
updating of the sc->statistics.*.

In addition smbdirect_connection_get_recv_io() uses
list_first_entry_or_null() in order to simplify the code.
We also only use it on a healthy connection.

smbdirect_connection_put_recv_io() uses msg->socket instead
of an explicit argument. And it disables any complex_work.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_connection.c   | 47 +++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 0a96f5db6ff3..db807fb9e3db 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -5,3 +5,50 @@
  */
 
 #include "smbdirect_internal.h"
+
+__maybe_unused /* this is temporary while this file is included in others */
+static struct smbdirect_recv_io *smbdirect_connection_get_recv_io(struct smbdirect_socket *sc)
+{
+	struct smbdirect_recv_io *msg = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sc->recv_io.free.lock, flags);
+	if (likely(!sc->first_error))
+		msg = list_first_entry_or_null(&sc->recv_io.free.list,
+					       struct smbdirect_recv_io,
+					       list);
+	if (likely(msg)) {
+		list_del(&msg->list);
+		sc->statistics.get_receive_buffer++;
+	}
+	spin_unlock_irqrestore(&sc->recv_io.free.lock, flags);
+
+	return msg;
+}
+
+__maybe_unused /* this is temporary while this file is included in others */
+static void smbdirect_connection_put_recv_io(struct smbdirect_recv_io *msg)
+{
+	struct smbdirect_socket *sc = msg->socket;
+	unsigned long flags;
+
+	/*
+	 * Should already be disabled anyway.
+	 */
+	disable_work(&msg->complex_work);
+
+	if (likely(msg->sge.length != 0)) {
+		ib_dma_unmap_single(sc->ib.dev,
+				    msg->sge.addr,
+				    msg->sge.length,
+				    DMA_FROM_DEVICE);
+		msg->sge.length = 0;
+	}
+
+	spin_lock_irqsave(&sc->recv_io.free.lock, flags);
+	list_add_tail(&msg->list, &sc->recv_io.free.list);
+	sc->statistics.put_receive_buffer++;
+	spin_unlock_irqrestore(&sc->recv_io.free.lock, flags);
+
+	queue_work(sc->workqueue, &sc->recv_io.posted.refill_work);
+}
-- 
2.43.0

