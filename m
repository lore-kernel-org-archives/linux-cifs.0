Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D9D29993E
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094733; cv=none; b=ADiTrIv1Xd1smxIryci0jiSAJO8TStRMCdXWycmEsyAf+ehzfCbWvshTKePuUA0m/cD9zt2145zedD2Lp1/VFfGKg0ziw4xdpFyFsGLrTM9OdCOIEqKK/326c23sLI2XVHdVG0RTN7cU7m4EH03mjN3WoXAoTfwiNln/WQI0AsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094733; c=relaxed/simple;
	bh=upzCofrfzWpFalw+oq7muas2DAE+BYM7HnHl1uzmSF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESi2QuDQQ5APQjDhS5JsdoPJrqaySkThEAp/tieOjrWPEe+ggt9YQsxtnXziv0/jk5oLWCTqxYcNPuhInxqPZo7YVV058kdk9NxO2LJ/vzrJKAmo3ia75Yuu2iV1ixNugYKmxQ165YjzDY514UY2EA+JS86QXANWlCzUJ0ZO3xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=jepNXiQa; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="jepNXiQa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=JmXw+JB7gvzJpMqxvsB+lEIlefy96D+PL/h/vMq/gRg=; b=jepNXiQafE48EcqcRrBB8bUDCX
	x/3cnpznEdR8QT9nTcTQD3Rc0rT6XYrtGz4WNj+/6hied6AmgTSj/Z1Ta1OymoasX32o9Ou6z5arT
	/f4kNQyM7edemIQNFprMNd14+43zFdxUXkMPHPkNWx2I9iMeQ0YKJwLhVf+1YtoqxkOR2oa428l+U
	raI9pwTCjj07qWsfgDx8vky5Hnp1odCo7tNlPt3qbscXqQRnjnSXXRLqaXyyPm4NsqcNm/0MAOSJu
	9wRZFPV2Jhom4J6LHY9Vnoi4Epmy9B2bcQZASe0BRuhg+BH7KKYL+fY/j4DLd65Lwt5X/AluuTla+
	C8OvKbnHnS2es3n2jyB2qIrU79DRMleXM9b0MxF1anjzdz6EJ/hstx/hCdvUr8JA7POCNew1AnTPm
	simBclPAXAOTYW8zV8ANxT8vWYsbmAcnUGuF0lBtDrIgHt1g+V59pyUx4eTDspoRdtvKYFY8k+Qyq
	5yMDMaH1xWhWPo1mUrENnLW1;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxUk-00FeFL-0h;
	Tue, 25 Nov 2025 18:10:30 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 098/145] smb: server: make use of smbdirect_socket_set_logging()
Date: Tue, 25 Nov 2025 18:55:44 +0100
Message-ID: <b5c66902cfdd52c166d97b78b9fce4a6be82843a.1764091285.git.metze@samba.org>
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

This will allow the logging to keep working as before,
when we move to common functions in the next commits.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 62 ++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 343e2bd7ee2a..52cc756aa088 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -113,6 +113,65 @@ struct smb_direct_transport {
 	struct smbdirect_socket socket;
 };
 
+static bool smb_direct_logging_needed(struct smbdirect_socket *sc,
+				      void *private_ptr,
+				      unsigned int lvl,
+				      unsigned int cls)
+{
+	if (lvl <= SMBDIRECT_LOG_ERR)
+		return true;
+
+	if (lvl > SMBDIRECT_LOG_INFO)
+		return false;
+
+	switch (cls) {
+	/*
+	 * These were more or less also logged before
+	 * the move to common code.
+	 *
+	 * SMBDIRECT_LOG_RDMA_MR was not used, but
+	 * that's client only code and we should
+	 * notice if it's used on the server...
+	 */
+	case SMBDIRECT_LOG_RDMA_EVENT:
+	case SMBDIRECT_LOG_RDMA_SEND:
+	case SMBDIRECT_LOG_RDMA_RECV:
+	case SMBDIRECT_LOG_WRITE:
+	case SMBDIRECT_LOG_READ:
+	case SMBDIRECT_LOG_NEGOTIATE:
+	case SMBDIRECT_LOG_OUTGOING:
+	case SMBDIRECT_LOG_RDMA_RW:
+	case SMBDIRECT_LOG_RDMA_MR:
+		return true;
+	/*
+	 * These were not logged before the move
+	 * to common code.
+	 */
+	case SMBDIRECT_LOG_KEEP_ALIVE:
+	case SMBDIRECT_LOG_INCOMING:
+		return false;
+	}
+
+	/*
+	 * Log all unknown messages
+	 */
+	return true;
+}
+
+static void smb_direct_logging_vaprintf(struct smbdirect_socket *sc,
+					const char *func,
+					unsigned int line,
+					void *private_ptr,
+					unsigned int lvl,
+					unsigned int cls,
+					struct va_format *vaf)
+{
+	if (lvl <= SMBDIRECT_LOG_ERR)
+		pr_err("%pV", vaf);
+	else
+		ksmbd_debug(RDMA, "%pV", vaf);
+}
+
 #define KSMBD_TRANS(t) (&(t)->transport)
 #define SMBD_TRANS(t)	(container_of(t, \
 				struct smb_direct_transport, transport))
@@ -429,6 +488,9 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 		return NULL;
 	sc = &t->socket;
 	smbdirect_socket_prepare_create(sc, sp, smb_direct_wq);
+	smbdirect_socket_set_logging(sc, NULL,
+				     smb_direct_logging_needed,
+				     smb_direct_logging_vaprintf);
 	/*
 	 * from here we operate on the copy.
 	 */
-- 
2.43.0

