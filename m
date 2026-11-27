Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795797713;
	b=HOa5OVxajBa2u83aHvPpNrKL5inB0+txHoMtfYPHa+PBHWvt11t+h/sQ8iacAvRz/A9g
	 ctbZ1aEthdz5rfIjDL3fe+RqjCoc06FKggved0mB2/JzGCLlV98ai9CJEHM9c8iDPrwHC
	 /MnPQdhXYWsRyzgk5LyhmRMKGs+AkVeQT7BsW8h4vrpBaIOA7/7nFHi+EYuOylMql3WnM
	 /y+cUGaaOjcM+6OFoaOX7RqLFFQda/fZmusjOAa73is87XvTw3gX8gVmxFrO7veKkAfI5
	 mSGr0a3unVJYGRGKNnNGwU8k1+7GEkPFI2YL4hB6imWc5R4O5Gl6noaxl3ebMsodhag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795797713;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=5YgTulolvOxwdu/mLeuXKTSqxBI7iZQ1WSaSrr9wFwM=;
	b=l2UHhpkRivgpNy3RWOKz7fXBvhy2awXihu1ccHwx/zUZnbVNevQLncI+2SxZELjyLOnI
	 CE3yubXy6Ytw+04okprYBbMh6FpiSqqKZnCEKyN0Rf9c/98rK+Ob33ZHJvVSy/PDdJcLP
	 7RZgwkuIhV4aDxdV8H7JwXEX51eWs/5VjvHF3YnhzRmVb6NRq9BdlqiuxhxLRDEAZgD/t
	 M3w0LPQftPiEmQhGJANRRzTQnZGC4fOqBWoXYa4PVm7ImDrhmRRj0IJ7gWzi6FHy6KgoH
	 8/tKwGvSmHWxgYKSjA/+sq3KyoDH4KqGHoI2TfMHaw2NP85BaB6Fd1NgH0c6BzhF4gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=OujbDebL;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF95606A339;
	Fri, 27 Nov 2026 16:41:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ACF95606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=OujbDebL
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=5YgTulolvOxwdu/mLeuXKTSqxBI7iZQ1WSaSrr9wFwM=; b=OujbDebLyDVVzxuQS7WawKc6hO
	21qxh0dA+82jrF2BWndw+viXoz5cqirXsSqYxTXGmc8aKFfw0ZS2Tsv0lJN102ZfdXAeawJM6RzJ9
	VtR6K2AysLUUP+j2cniXW1D4+iry4Ww8rBzClCoNymFMOMMs3vQq0kb/V1MlDNM2oKu/aO02YD48u
	nt252GN1H0wwBpqzAcUoWhj7xgppQ7E3kXvDH2Q9DoFGBiRdnbMF9eNWkgaDuMvaH4e/Slmeuyk69
	w6pNpMr/eHzv2HFxpQCdIrFDSYp3I0Umihe7xxNX0rFlTA67ZfTi7/L98/4QWsRHKjR+rW4Ukb1/u
	Mhz9hTtCAHooGKr9n0d9T77jmpX6pEQ3kloBf4XWYwD7KsW4jtXo2yt4PZKsb+f0GX8IagqwjzB+8
	gZOq2QjxgASCRkAGxT0HdMF01YVbk4HpZCCelsZSqiYKcUckTNkbBRiJgTGG0qs3PU9M8s9MnynJi
	lICTXrGNuBB/ZPDWd5WkHKKC;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWz1B-00000001Q5P-1K8o;
	Fri, 27 Nov 2026 16:41:49 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v2 12/13] smb: smbdirect: wake up the credit waiters after a failed send
Date: Fri, 27 Nov 2026 17:40:31 +0100
Message-ID: <aa9b2a1849ac734ae9f9c9603f6dbaf981e96d48.1795794871.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1795794871.git.metze@samba.org>
References: <cover.1795794871.git.metze@samba.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The error paths of smbdirect_connection_send_single_iter() give back
the send, local and batch credits without waking up the waiters on
sc->send_io.{credits,lcredits,bcredits}.wait_queue, so other senders
and the immediate send work can sleep while credits are available,
until something else wakes them up.

It also gives back the batch credit of a batch of the caller and
clears batch->credit, so smbdirect_connection_send_batch_abort()
doesn't see it and doesn't wake up the waiters either, and the credit
can be used for another PDU while the aborted one is still in the
batch.

Wake up the waiters, like smbdirect_connection_send_batch_abort()
does, and leave the batch credit of a batch of the caller to
smbdirect_connection_send_batch_abort() or
smbdirect_connection_send_batch_flush().

Fixes: 54abc694ebb8 ("smb: smbdirect: introduce smbdirect_connection_send_iter() and related functions")
Cc: stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-a2180487-c0d3-4f9a-92d7-208e032dd966
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/smbdirect/connection.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/smb/smbdirect/connection.c b/fs/smb/smbdirect/connection.c
index e84f488b83a3..837de712db65 100644
--- a/fs/smb/smbdirect/connection.c
+++ b/fs/smb/smbdirect/connection.c
@@ -1353,11 +1353,21 @@ int smbdirect_connection_send_single_iter(struct smbdirect_socket *sc,
 flush_failed:
 alloc_failed:
 	atomic_inc(&sc->send_io.credits.count);
+	wake_up(&sc->send_io.credits.wait_queue);
 credit_failed:
 	atomic_inc(&sc->send_io.lcredits.count);
+	wake_up(&sc->send_io.lcredits.wait_queue);
 lcredit_failed:
-	atomic_add(batch->credit, &sc->send_io.bcredits.count);
-	batch->credit = 0;
+	/*
+	 * The batch credit of a batch of the caller is given back by
+	 * smbdirect_connection_send_batch_abort() or
+	 * smbdirect_connection_send_batch_flush().
+	 */
+	if (batch == &_batch && batch->credit) {
+		atomic_add(batch->credit, &sc->send_io.bcredits.count);
+		batch->credit = 0;
+		wake_up(&sc->send_io.bcredits.wait_queue);
+	}
 bcredit_failed:
 	return ret;
 }
-- 
2.43.0

