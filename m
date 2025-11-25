Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF1A15ECD7
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093445; cv=none; b=Kn8JiOHbRoLHhRocvfOtJKTtDH57En/cY/aS76wHrsPgWFbYhxGKGM9yt8JsuIPj42mW3zot3otgR34WVRIXI8i/iloOCGPo0V86VymrrseByL9tHqPQRc1pgQkzryFyWsjlUtT7M7kB6AdhxZFmgO5kD3JDO9STjHHXW0ML4OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093445; c=relaxed/simple;
	bh=vJtvFpyEubb0e00/QRbWNGybFKXg6S30D125DW0h8dM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rytsTGN0q18QApP7IDUhvSTxE3WlMzugXRjDKSnJLmjMfUAZHt3KSVD3j+AEoY03CnRlRqcz0VZOvUkP+aNwOWcFz78ijMbR/vk1ldvC0y0RJPrylxdfc4qBgzGB5op7CQrMtb2YDb8NtDQ76GNP6wTTJuEMOfJaIJJi5MQY9Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Iu2vHYx0; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Iu2vHYx0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=P7kzmXaq12CXSjZa+JFSudhNmy60aVOYfnD9qzkh1tU=; b=Iu2vHYx0W2sxtAY9JD3KGqNNiN
	v9h9MwtkaF+2Rs6NZ7t+48M3aZ610NAyVYWOxBbsveEvHkntT0tbP5IJ2Z7CgFnRBgfEPsgd7710j
	S50U2Oy+LoylrzJ35gpIYJvOswgr86fXyuveAIhaJausJvMnV4D6x0xntM2zVzpTwBz1JNCIrGh2B
	Wt1vyzhyV+8bqcnKxAQEidfxn6dG71ypcGyX4jcwanFXgvg1vykXugz0A1OSTigYV4m97jAAV/LNx
	n2ua+Jp21axPCGzAT7hwdDsUuZ6WHjTtXWVgxuPD6pE47DUMestfatednTt/2F01rZe/ZPTSjKXxJ
	Nu2mwt/PUhGZOf4DTRcwS/XzV3rHEKAjnKClh72QQZzsMW+7uy0AWeM6QwFjXKrl5+P5PD2KH/1Fb
	O10HonMre/KCcPiag6WrR9oclc0g+iznoQDc4JVNlUwEdHhDphgBVxvx+47jkX8TwEnjq0hH4Etff
	OikUUq7aqfRqhghsfwdSK5b4;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxI1-00FcXN-0F;
	Tue, 25 Nov 2025 17:57:21 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 007/145] smb: client: include smbdirect_all_c_files.c
Date: Tue, 25 Nov 2025 18:54:13 +0100
Message-ID: <5b396cbc0f0cc1f0c01a7ae56009f974899f016c.1764091285.git.metze@samba.org>
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

This is the first tiny step in order to use common functions in future.
Once we have all functions in common we'll move to an smbdirect.ko
that exports public functions instead of including the .c file.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 788a0670c4a8..320166f5d267 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -4,6 +4,9 @@
  *
  *   Author(s): Long Li <longli@microsoft.com>
  */
+
+#define SMBDIRECT_USE_INLINE_C_FILES 1
+
 #include <linux/module.h>
 #include <linux/highmem.h>
 #include <linux/folio_queue.h>
@@ -143,6 +146,16 @@ module_param(smbd_logging_level, uint, 0644);
 MODULE_PARM_DESC(smbd_logging_level,
 	"Logging level for SMBD transport, 0 (default): error, 1: info");
 
+static void smbd_disconnect_rdma_connection(struct smbdirect_socket *sc);
+
+/*
+ * This is a temporary solution until all code
+ * is moved to smbdirect_all_c_files.c and we
+ * have an smbdirect.ko that exports the required
+ * functions.
+ */
+#include "../common/smbdirect/smbdirect_all_c_files.c"
+
 #define log_rdma(level, class, fmt, args...)				\
 do {									\
 	if (level <= smbd_logging_level || class & smbd_logging_class)	\
-- 
2.43.0

