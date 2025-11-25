Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C2A20C48A
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093981; cv=none; b=SMGmrubWLL3wfokEUBwJzfFT8vl9wouOZFYvUmvp218gffEaxJM2vp/iFMqvjuCvBpL0sqQO0tlQI1UGcZd5Bfhd/OXa8waipqja3jtxdRCmCfaXB8m0GcjrZlt1qGR++f8+eAJgpH6BNBHPjjIoxfAwFZoma0d17FaCIIQHDog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093981; c=relaxed/simple;
	bh=VGok4gvIZCM+WHw12mFyh8RVZXEme1TZCdS17jliTKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3vZIARxegfqICzztJiUE3w1Pm1mxll4cFdIPIK7nbFv/gmW3Yg3turXssWAiMk3GzgPS35LPvGkn+vfpucdQ2wqDXCn+Q6xXfArA0raZwos/NtK6OBKuGT4n5fa1vQE+S83Zbkr8e4ZaTggqxOBP4VpLVMUJbiH7+71AGP+STg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=tkFXeLHn; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="tkFXeLHn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=octnfcbzKHl9HbGtvbHo3ac/1He9gMP6otpI2tm785w=; b=tkFXeLHnBgjpGY4RWtzGW3IHfn
	B+UvOlk/48zcYd10rCVqjtPT9jPBGnXnRP82VTNeWanM4Q2vEP65giSEM5VEOOoYn2VochghNBM8i
	nQeNX3q3QOxRLRaN7xu+ba1qVkigOnspBh5uLtpBflGzrMQtNqpCY58RzzPsgPtiUNQQH1wQxP6+L
	4Gg5aH/69LeOwwgwWw40iLLpvj/NrOMkOt3hE2RosJBPyzWZzUJ4CbBaI59vBSTI8zZGfxi5EDpFO
	DL8TfV2gEnEUG1vuSmQq7viP6ODpc15XlIXzR/YUAuzRmd5vyrtX/Q6e+uJdxUCWAytvK/zJqjqbY
	ojf2pDC6nobbNfbMh5+O6UL3gsuyTseuPw8j1QnteEPF8aB9GC0V+7o+IFuOTVr2VuoA1n38HvPdk
	KouxRtCOWG9JrMZ7FsAQMtlVvVFatIIQBEDJHl33exYlRf8+lnoVeK3Natkluk3/AM3LZARC4Q1UJ
	tsjphUNegMZEPhnHk3LHLX49;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxNh-00Fday-2Z;
	Tue, 25 Nov 2025 18:03:14 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 062/145] smb: client: make use of smbdirect_socket_set_logging()
Date: Tue, 25 Nov 2025 18:55:08 +0100
Message-ID: <d27914583422a94ad9ab48d698a7cdc0c167c0f2.1764091285.git.metze@samba.org>
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

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 05ac030ab653..3d3b6fa65781 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -156,6 +156,43 @@ static void smbd_disconnect_rdma_connection(struct smbdirect_socket *sc);
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
@@ -1839,6 +1876,7 @@ static struct smbd_connection *_smbd_get_connection(
 	if (!workqueue)
 		goto create_wq_failed;
 	smbdirect_socket_prepare_create(sc, sp, workqueue);
+	smbdirect_socket_set_logging(sc, NULL, smbd_logging_needed, smbd_logging_vaprintf);
 	/*
 	 * from here we operate on the copy.
 	 */
-- 
2.43.0

