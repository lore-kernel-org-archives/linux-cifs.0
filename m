Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4B937A3A2
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744188; cv=none; b=fAXk5lKIDDofisVx6NAOnKa/bC67JBLb5O78+vezarb/Q1LcmxD0tLp4v0od92/gT5Jq0w8E+KbgagGZDzKj6dZ6fsaTbIUhouzK6GWwCy7rUkv7+ArLZriSYo8XZMqUCJKIgROIoWI/EsPzx8c1ojrQmaM/2AISfqOctRIngpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744188; c=relaxed/simple;
	bh=OalY4EUgF8n5CUT6hBDD387FDGweH4PtqtX6gbhebdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XX8qsp5quiI5Nb7tmocLyVZISX6+fFoii2ceSjWbma7+RPjMKHYZ1jolsNblb7bmhL3SWlQPtAG2fHtCtvjiaukCaxpYdV97MSOR69PUayz7MlQXfcJwK+/FCC4lAzhKTFGH88fdPBHB0N5JzsRY7ml0Zlf/pWVS/OF6aU5XKwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=sbOVsNFY; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="sbOVsNFY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=0+3y7RdTjGih8EkiQLzLp/DBbv+XviHIHTvFfoaUu3Q=; b=sbOVsNFYTXw6qudRAGZYHpJZFH
	74OUjXmbIhgTSa0mr7ENZkGFcAhLXZ/e0xqSvQF7Y8uOEqJMRKLqN9T8mgC6N3RPn9j2CGZriw99y
	cAUZtzOLYQ72MigSFSgxPqRZ81lIdo66lKkiwupxuBFe4YBq5rYXVXL2Iy5D8A94uuEsbvMlziK6A
	y30nCJb68Yl4WmO241UpQpMFtZRJO033FTyDZgVmd15vWqvfTSCZ4U1S/Z3f5OSthqviFqmy55i7v
	DuXHaaqgOozsOA/SPEOmvfwS0UWsZ9blOLYeGr4xk06r/jcFJuRWnE+Ig7kculEEMnU+DelSHbZOi
	W9/UWCG57ZPsqhMg8myyLy+uSTQCNslNhlsgLrpIfM4W2RfMrh8PG/AAuFnIpXEriHTVAP1PKj9PV
	JFOKqDqO0dZ5EUgX9qgVf7DpysGBQaXmVFtp5CyKYXrS7uRrE2P79p4w14P4aF/UXF+7S6VYY5ZlC
	D3Bymcro0AKrLpmCXikbf6qM;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE68m-00BbFL-0p;
	Wed, 29 Oct 2025 13:23:04 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 005/127] smb: smbdirect: introduce smbdirect_internal.h
Date: Wed, 29 Oct 2025 14:19:43 +0100
Message-ID: <d4dc3baa7bdde32e283883469be10cc2b1d6eb0f.1761742839.git.metze@samba.org>
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

This will be included by individual .c files as first
header.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_internal.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)
 create mode 100644 fs/smb/common/smbdirect/smbdirect_internal.h

diff --git a/fs/smb/common/smbdirect/smbdirect_internal.h b/fs/smb/common/smbdirect/smbdirect_internal.h
new file mode 100644
index 000000000000..0727b9fee879
--- /dev/null
+++ b/fs/smb/common/smbdirect/smbdirect_internal.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ *   Copyright (c) 2025, Stefan Metzmacher
+ */
+
+#ifndef __FS_SMB_COMMON_SMBDIRECT_INTERNAL_H__
+#define __FS_SMB_COMMON_SMBDIRECT_INTERNAL_H__
+
+#include <linux/errname.h>
+#include "smbdirect.h"
+#include "smbdirect_pdu.h"
+#include "smbdirect_socket.h"
+
+#endif /* __FS_SMB_COMMON_SMBDIRECT_INTERNAL_H__ */
-- 
2.43.0

