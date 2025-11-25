Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D18F15ECD7
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093435; cv=none; b=ni468ADjQK8dIuOe3+PRman+KZFf4A0x85JNLXGgchaZQOnLs6gh16dKrKqLy0HhhNjFQCp71CeFpyY5DZCKRfrMbIxS3c7vyZKqlCw8nW83U4QBLrqro/rKv4TRRIpWmN8uLodhssVFt8WUPMSd8SUfHWPNvdlMp7wmIyQB3FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093435; c=relaxed/simple;
	bh=R8bHmBkEbtdMWpqxRCeNkAzO6f6bSOH2KpTrN6NXMpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MkwYUG0mhuI3eFUreDDUF1FoCRPi4U6nVlB896SAmBjjOI8yT1b/vx1bGjD/h2HMnSczVr4n4rJxlV355VmgvEcnBbBkIvRfKzSlSnW/nhuorNdjLFC6vip21Mv5+z8+0xNhOt7E/pep3lFY/ztvX6lVwte50Um7c/6k3vRnCx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=uY5Bgx4I; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="uY5Bgx4I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=g4+55J/IvWXCTgAVKmMhQ8CnIEtqfx1K9xCIW4DKDzE=; b=uY5Bgx4I9RQSWUlK8w3OS9MT+q
	pgzr91xIrdbcSYBJEehAsnYXeUQJad8nGrCvVr+A8EcmXvuqfHWI0wiL3MgnwxMe2vBtvSmNZDYM7
	L8c3Y983xL7oZEGJqJPC1hMuTNRtjCiVyR9Btx+zRcj89BOqHf6T+u5COpNYyWLSigNOhU1V2HdYl
	ZNDwqkIt0alEfAmKKlZrsaoMkg3A4AOOZ09Q+6HMkcipVIMUmM85dd3UtNvrYU49fCNCO3L6NzV9U
	+fNMPGj/RTJ03xKaFL/a99vqeqJ/oon2SRoqKVFPMll8p+RKii09wMw50x71QjSfZ9Og5IQjxzFb3
	6Rql4D1DK7LREm2ZyE77cEt7Ga+pA9zYVVTO25E3egiRPs444qlt/gL289lW0WlWVVXCpsRQN4PfT
	WtOFs5K6hlBroVvMFgthZZMdcRjM50y2m8VPsSlypdeVbZgzlyf0f9Erpml54w37X3D6MjRbyN0Fq
	EdIM5dVPW251GlJR65ZoIyPC;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxHp-00FcUX-0D;
	Tue, 25 Nov 2025 17:57:09 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 005/145] smb: smbdirect: introduce smbdirect_all_c_files.c
Date: Tue, 25 Nov 2025 18:54:11 +0100
Message-ID: <80afe8b6fdd1f324728fdee4daef48b496a30b10.1764091285.git.metze@samba.org>
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

This is a very basic start in order to introduce
common functions, which will be shared by client and server.

As a start smbdirect_all_c_files.c will be included in
fs/smb/client/smbdirect.c and fs/smb/server/transport_rdma.c
in order to allow tiny steps in the direction of moving to
a few exported functions from an smbdirect.ko.

Step by step this will include individual c files
with the real functions.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smbdirect/smbdirect_all_c_files.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 fs/smb/common/smbdirect/smbdirect_all_c_files.c

diff --git a/fs/smb/common/smbdirect/smbdirect_all_c_files.c b/fs/smb/common/smbdirect/smbdirect_all_c_files.c
new file mode 100644
index 000000000000..610556fb7931
--- /dev/null
+++ b/fs/smb/common/smbdirect/smbdirect_all_c_files.c
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *   Copyright (c) 2025, Stefan Metzmacher
+ */
+
+/*
+ * This is a temporary solution in order
+ * to include the common smbdirect functions
+ * into .c files in order to make a transformation
+ * in tiny bisectable steps possible.
+ *
+ * It will be replaced by a smbdirect.ko with
+ * exported public functions at the end.
+ */
+#ifndef SMBDIRECT_USE_INLINE_C_FILES
+#error SMBDIRECT_USE_INLINE_C_FILES define needed
+#endif
-- 
2.43.0

