Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88FB305688
	for <linux-cifs@vger.kernel.org>; Mon,  5 Oct 2026 18:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791226048; cv=none; b=RWpMYm0xN39n63o9awc7tsg8pL2BxDCiNEw/pm+4BNXio8zOTgj2twA7kAJRIWlweovmtnHWbYp4lX0FVoOsEqHY9ZYBBt0b2WDRW407LcPrVtVBsbIg66st/v9ScLle5/huo9oVI3EI2Q7u3g3kwRXTOBg1zxOzuxUzq7BJtQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791226048; c=relaxed/simple;
	bh=nCkegsTcKpfetXnABC9zWRz9L0hirRJfNeaH8RoYRds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6FeWU3797vnCRLPpP7ZgPNV5WKILLLvu8Ha3gmw7zAFa8i69aT2A0nHaxMX1oGWFixLGRyxytPZvwlp/gYxzipO/G7UOw+13k2+FZ2p2q85aPoDiQOblD2sjzBZq+3fn32KS97vdUe026N4z8upDIHxrD3sr6iIuagCLcPINNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=L7UjYYjJ; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="L7UjYYjJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=nlkrCNZv8V00z7j1duHzodY3Mp4x9Cqn7tis342wmko=; b=L7UjYYjJ6qbmnavKXx/fVFRXg8
	xdNAurUYlCYyMvPxDgcr2c8kwf9VyCB1BuuwJIKYfA7RiuTorhzwEiTwHcWDdejK4jntTgZAlpcZQ
	2LRZKCGcxwo4JHfJ2wDtIpRi7ScSJBL1gGjgf/SO3F1Sviyg4y+X0U7KFm6NNUClJuzGy4EL+Gy1R
	MaAmJEKkh9/AipkhmFL+iaU1sCv2eF4QhJiXrt5/bk3DJfosJ2GUVqxmHpc7lUmGj5qCp3RfP4pJ2
	ArnngUiz8Q3TZNij34GuESlmcZ2sLHSmiIU4Op6lMXZO5X9yVHaGWSjIn++y6YCXULnkXu0F05Kqy
	dSPS0HNVlwri82CjOnMrEJyPWvcd8mpFdiJvZz3GKuJRXRahYAzbbJDj0DBo91V+BI9geu1VdW8OI
	ZY8P63QZIF7FfhgTLTFBJaBafKDiPAFBIKHT5jH6hNPZQ78mdM06Kx9Yf4mbwizjHsY7DYFHiVpki
	lRyWctUQDbIlK1UT0wQ0XqZJ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xDnie-00000005f8d-0DO6;
	Mon, 05 Oct 2026 18:47:24 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 2/5] smb: smbdirect: add smbdirect_socket_get() and smbdirect_socket_put()
Date: Mon,  5 Oct 2026 20:46:57 +0200
Message-ID: <424edd9cd03a71efcc95cc2f8441145694f9f30f.1791225453.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791225453.git.metze@samba.org>
References: <cover.1791225453.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
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
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Assisted-by: Claude:claude-opus-5-5
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

