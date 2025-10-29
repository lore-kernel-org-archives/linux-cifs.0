Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB1F3271E4
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744496; cv=none; b=LidoHI0/ZfVQg3XUM21IUfNw6BpEGvsevpjTFiCgvzCw1nrzSP5xg8H2UIZAc7vjM+aSi+mnlQmQ4DgproNlag74ECpze3gcM2BG1Q5PK0eB4Qk54gB3dEaKBzR2IByw5aUBIlTMiJ1L9dKY13wSwa5PYOYIdBthUEiWkGIy+X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744496; c=relaxed/simple;
	bh=9UmOdH1iYsSlAKWrWuLtyvV3h17VwiTOXNzpnzJ4LlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IO6QidD0JQ8NAugCd5jL794kLLPW1/x37oDHSWXuCqCrlOE4dS+jQKeIyyL+36lHHmv1lZtQ81w+mZ0LrI0h/ohohc5O/zlv2+H3xUuOapQRl1HGZsHO1JQAPoHKYutNTdR4R2/TJSkshyFht9XCyNmCNWAIc67Dt4jsXqQONfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=TLP1VNeu; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="TLP1VNeu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=M+PlIuw3PvuefEMXzkG7J6ekwOeWRvQfpwjle8wrEWU=; b=TLP1VNeuRVujORsgOSly85le1l
	3zE8Qr3NzWSqu84SJhwYzvtMkrQHD0XgwGjYzW+iJ9yLT1RqXlat8FJn4ukGUyXdCPMgRKESdoNN0
	NhDNtqcGAm+ZLGUme+kx4RWS2WLb+ocOoabYUWtCaBQLOZZ81z975ZsftuRMZOvBOw0hKwsLFZinJ
	DMjyHvAUEH9WnmrWWmL9YE86umimK4mcjnuo4VFYLkkztwCMVMl1UanWlL7t3lMBGUVj64h8HqMdW
	zAlSJ6kE/I04gFMHlqdYeVkG0R61vJyrQVIpY03U4hOhxR//3WPqvvEp9waoLelS9G01LdHKzs1rD
	XORHbtoPNP9BsEn+J9zow5V63Mi1f0F2jSHwzaWG0VOl3hAkXxhTWYzcoW8fncybIseROdco65hp+
	I0fGo24A+KV/sjg/B4BsmTPegmvAD8DTOYFFX2xxWqKPPY2o7axDMwT7YBNnPCNDHqXdDVMzkyLfY
	rKcp2SXATnrEewvxBMCNxIh5;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Dk-00Bc3k-1V;
	Wed, 29 Oct 2025 13:28:12 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 058/127] smb: client: make use of smbdirect_socket_set_logging()
Date: Wed, 29 Oct 2025 14:20:36 +0100
Message-ID: <98a6fccfa4a5e0bf37870fc5a5a775094ae0fdb9.1761742839.git.metze@samba.org>
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

This will allow the logging to keep working as before,
when we move to common functions in the next commits.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 04a90fd0971c..08192d69617b 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -153,6 +153,43 @@ MODULE_PARM_DESC(smbd_logging_level,
  */
 #include "../common/smbdirect/smbdirect_all_c_files.c"
 
+static bool smbd_logging_needed(struct smbdirect_socket *sc,
+				void *private_ptr,
+				unsigned int lvl,
+				unsigned int cls)
+{
+#define BUILD_BUG_SAME(x) BUILD_BUG_ON(x != SMBDIRECT_LOG_ ##x)
+	BUILD_BUG_SAME(ERR);
+	BUILD_BUG_SAME(INFO);
+#undef BUILD_BUG_SAME
+#define BUILD_BUG_SAME(x) BUILD_BUG_ON(x != SMBDIRECT_ ##x)
+	BUILD_BUG_SAME(LOG_OUTGOING);
+	BUILD_BUG_SAME(LOG_INCOMING);
+	BUILD_BUG_SAME(LOG_READ);
+	BUILD_BUG_SAME(LOG_WRITE);
+	BUILD_BUG_SAME(LOG_RDMA_SEND);
+	BUILD_BUG_SAME(LOG_RDMA_RECV);
+	BUILD_BUG_SAME(LOG_KEEP_ALIVE);
+	BUILD_BUG_SAME(LOG_RDMA_EVENT);
+	BUILD_BUG_SAME(LOG_RDMA_MR);
+#undef BUILD_BUG_SAME
+
+	if (lvl <= smbd_logging_level || cls & smbd_logging_class)
+		return true;
+	return false;
+}
+
+static void smbd_logging_vaprintf(struct smbdirect_socket *sc,
+				  const char *func,
+				  unsigned int line,
+				  void *private_ptr,
+				  unsigned int lvl,
+				  unsigned int cls,
+				  struct va_format *vaf)
+{
+	cifs_dbg(VFS, "%s:%u %pV", func, line, vaf);
+}
+
 #define log_rdma(level, class, fmt, args...)				\
 do {									\
 	if (level <= smbd_logging_level || class & smbd_logging_class)	\
@@ -1832,6 +1869,7 @@ static struct smbd_connection *_smbd_get_connection(
 	if (!workqueue)
 		goto create_wq_failed;
 	smbdirect_socket_prepare_create(sc, sp, workqueue);
+	smbdirect_socket_set_logging(sc, NULL, smbd_logging_needed, smbd_logging_vaprintf);
 	/*
 	 * from here we operate on the copy.
 	 */
-- 
2.43.0

