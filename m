Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795783325;
	b=wUbxESVe+1xht+J5E8ABeWrZJTGy4K1ICJNJ1NEGe1S0ezqFYi1dWayUGhWKf+CI5UCs
	 CUHaRQoTvoElb9BveZy6+ut1RaXZES7b5VoEvQ3Y+GRgJ7+jr1clDLzNVZQ3sTfPnMkiB
	 +AiyyqTiF4g2KZsAy2OGc8R4WNUfal63qPLVtN1zIU/aesc+TVIgO/RfmBq2I/lKgtKCp
	 qv9MELWluZKbM4ZILRMIHKBDr2v+Lpg1dK95LtZva8Sm2Be6xGEIBqjdcTfR4PzSvmcdU
	 UEHrk6bDk9FlHmpOiD4gAmkoJW2YJU+0Fa1pWM19CbJwUTfHYXUKqBRjlnMF5mlCBHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795783325;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hQKNLycQKppNpji2+bIfLgjRTyqMC6x0w6jmqSorL0Y=;
	b=BDp/I2cO2WsgZX3B3x67P2YSVP7dMWQfGFAQOULWS9UoVAk5Du52Q3jHdGRG3to2HE7k
	 AjP+c+VhzoOcGFIpAKTWVr13No4ZBbFTU1gpqzPf7jHlWXbOrMpFAp+NbQva+XoiqTCt2
	 +UuTvqJIv0nvvBF8MCsEKGh4+1fQOo1qCTM/xDlPAPdCFNbHgrQz/lfhbEXw16ShCI0Ne
	 r+KZHgJR3VDLgVRgl82Gk4YJvMMvCC62CmW84Zw6Jl0mh3PrZ1u0wPLmm9F2Z+qQJhHqe
	 NVfydgJokdcJ1kTV7dFZsyd2eWSPFul7rX3Oj5Q+PKs6qKwoIdsEFdK3GXSjuHNHedA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=2uyqXHMw;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28244606A31E;
	Fri, 27 Nov 2026 12:42:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28244606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=2uyqXHMw
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=hQKNLycQKppNpji2+bIfLgjRTyqMC6x0w6jmqSorL0Y=; b=2uyqXHMwGYar9B2UYt2s2d5UyY
	l7HGqkGsPTgm9sFjG6bsflETZZXeHS+6dtBD1yWbehZ+cp/C79L7MqzXln/rzzdk6tCoVr+t2geit
	lzWEvEqqV3QXbQAO2nhbjElbX6+tta7cDW+n9eL+ppgy4JEH1ezV2xp17ODIdRM+nAhq3g2xf8upR
	6HVKzWhaH2INlrCRKCDBPTclJo03JmuccoIqZ+ozZDYshtRClmD/vKEoyD24dQxuy4Ogjs/VFj9tS
	Uikmv9Rcnkj9On3nDkxWkwJ8k+xcwUIgs4fj12ttMmQ3U10FMWi84RvetKVTSOcM9/E0rjq8RUAoH
	G21nDg87RIH43hwx6cBOfhvdgG6Y+Y64CYkUj3p+3vbD7frr4hy11z/7xxBsA8OysGKaiGeZM82Ni
	2OrozhU1yVMRqxQirkPwxEPkDyH6/BO4LCHHKrkEPsIG+DjKqyZrZ1a9HHQIeU2XEPUYJ2vXNSoJ/
	MIVVq8pyM41vyndFb/hrfwev;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWvH8-00000001M7Q-2ZWd;
	Fri, 27 Nov 2026 12:42:02 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 1/8] smb: smbdirect: add smbdirect_socket_get() and smbdirect_socket_put()
Date: Fri, 27 Nov 2026 13:41:34 +0100
Message-ID: <46829d9e9c9d84090ae4ddc06990ab29b5f794d8.1795782695.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1795782695.git.metze@samba.org>
References: <cover.1795782695.git.metze@samba.org>
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

These take and drop a reference on sc->refs.destroy, which only keeps
the memory of the socket alive. smbdirect_socket_release() still
disconnects and destroys the socket, after that it is no longer
connected and all functions fail gracefully.

This will be used by the smb client in order to use the socket,
e.g. for smbdirect_connection_register_mr_io(), while
cifs_abort_connection() may release it at the same time.

Fixes: b8aef8c8808c ("smb: client: make use of smbdirect_socket_create_kern()/smbdirect_socket_release()")
Cc: stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/smbdirect/socket.c | 27 +++++++++++++++++++++++++++
 include/linux/smbdirect.h |  3 +++
 2 files changed, 30 insertions(+)

diff --git a/fs/smb/smbdirect/socket.c b/fs/smb/smbdirect/socket.c
index e270e36b3145..13cf50b96bc9 100644
--- a/fs/smb/smbdirect/socket.c
+++ b/fs/smb/smbdirect/socket.c
@@ -851,6 +851,33 @@ void smbdirect_socket_release(struct smbdirect_socket *sc)
 }
 EXPORT_SYMBOL_GPL(smbdirect_socket_release);
 
+/*
+ * smbdirect_socket_get() and smbdirect_socket_put() only keep
+ * the memory of the socket alive, they don't prevent
+ * smbdirect_socket_release() from disconnecting and destroying
+ * it, after that the socket is no longer connected and
+ * all functions fail gracefully.
+ *
+ * This allows a caller to use the socket, e.g. for
+ * smbdirect_connection_register_mr_io(), while another
+ * thread may call smbdirect_socket_release() at the same time.
+ *
+ * smbdirect_socket_put() may free the socket,
+ * so it must be called from process context.
+ */
+void smbdirect_socket_get(struct smbdirect_socket *sc)
+{
+	kref_get(&sc->refs.destroy);
+}
+EXPORT_SYMBOL_GPL(smbdirect_socket_get);
+
+void smbdirect_socket_put(struct smbdirect_socket *sc)
+{
+	might_sleep();
+	kref_put(&sc->refs.destroy, smbdirect_socket_release_destroy);
+}
+EXPORT_SYMBOL_GPL(smbdirect_socket_put);
+
 int smbdirect_socket_wait_for_credits(struct smbdirect_socket *sc,
 				      enum smbdirect_socket_status expected_status,
 				      int unexpected_errno,
diff --git a/include/linux/smbdirect.h b/include/linux/smbdirect.h
index 97f5ba730fa7..7f0b1ed6cf16 100644
--- a/include/linux/smbdirect.h
+++ b/include/linux/smbdirect.h
@@ -111,6 +111,9 @@ void smbdirect_socket_shutdown(struct smbdirect_socket *sc);
 
 void smbdirect_socket_release(struct smbdirect_socket *sc);
 
+void smbdirect_socket_get(struct smbdirect_socket *sc);
+void smbdirect_socket_put(struct smbdirect_socket *sc);
+
 int smbdirect_connection_send_batch_flush(struct smbdirect_socket *sc,
 					  struct smbdirect_send_batch *batch,
 					  bool is_last);
-- 
2.43.0

