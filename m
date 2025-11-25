Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E368ADF49
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094715; cv=none; b=Av6h6nDXaih0gdCqlgSoB1of7JZlVwoWeYx5qPn+RNEEvp6ECa4WNcoXDzonZ+URXlKQEdzhcN2dcHRhPFzAUngY+j4zk9nsnlGwrsNkdHTwItu5DextF+W0UznFA9OGx6qRqzAiitoRoQK0ZDwHUS/vnwTPVbqZOqiuXDaI8ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094715; c=relaxed/simple;
	bh=6flBTiJlZJah9fMTMs7Y3/eGVfqMQgFtw6iSJGXo3/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1bsS3PYLrHzb0zkLo80aTcx2olZYI0S+1FOIR/rz7cKlVCRuTHPJKxfXelndQv0z2/pJxASd3vUCRO70fkYiULGJwizJ9sRcZ6i/6MEWdOX1DaMzk76W5CHcpXeZhg40gsXHDxFvsDbN2w1HVuPJObma4DABXhuTjerTf8oBhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=qTdvazbd; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="qTdvazbd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=SozUG8RVCw91a4tDTcgWghO0msxJrN1STXZDFr8G8RM=; b=qTdvazbdqqOIvXnfVSbuf7QdI2
	TipWrlkeRZgXNDj9vRLGc2U8rcDxVLWJqODd9tybXbzWbgt3B0P5K3aR6nZ/SmByDkQ9hxreojssP
	Z8BoeDiAziXjE12P9PThi+PEU8uiJ38yi+TH+KDLoL/VGKyT+d2aRCSpIhoq2JnjbKnE4nzziniv+
	uH3T/jO6plj9WKs9Kz1YSeNnYomSVTM+3DtTU2vichhMtjV67VZsAGGy38D/LnvZngnlo8QB7FSkA
	g6S3CW+a3q5+1viiLEmgps+JbRk1+ZYFtl2UFlS/y/HfbAR4whW2ajcux6Kgm07a4v+26HDKSlf8B
	QyWAy8M4e59A8fOj19cKRlDzr8Iu3ke/LOpItKOSdbSGj/502D1qzHkdYPTpldsVL6Q4aCSgFseUE
	dYCv4Rpvr60Xp1GL/waRlrg06HKTIBBDXy0uYZlKKK3OWuiLUvVLTQHDbE86A3TxjIu7fiozrLAwm
	sKtDoNx3rjMcej/myOLEY6j/;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxUW-00FeCl-2R;
	Tue, 25 Nov 2025 18:10:17 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 096/145] smb: client: make use of smbdirect.ko
Date: Tue, 25 Nov 2025 18:55:42 +0100
Message-ID: <f6916a46690649d0d6e1f03762d6cba8ce13986d.1764091285.git.metze@samba.org>
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

This means we no longer inline the common smbdirect
.c files and use the exported functions from the
module instead.

Note the connection specific logging is still
redirect to cifs.ko functions via
smbdirect_socket_set_logging().

We still don't use real socket layer,
but we're very close...

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/Kconfig     |  3 ++-
 fs/smb/client/smbdirect.c | 10 ----------
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/Kconfig b/fs/smb/client/Kconfig
index 17bd368574e9..72f47669da0c 100644
--- a/fs/smb/client/Kconfig
+++ b/fs/smb/client/Kconfig
@@ -181,7 +181,8 @@ if CIFS
 
 config CIFS_SMB_DIRECT
 	bool "SMB Direct support"
-	depends on CIFS=m && INFINIBAND && INFINIBAND_ADDR_TRANS || CIFS=y && INFINIBAND=y && INFINIBAND_ADDR_TRANS=y
+	depends on CIFS && INFINIBAND && INFINIBAND_ADDR_TRANS
+	select SMB_COMMON_SMBDIRECT
 	help
 	  Enables SMB Direct support for SMB 3.0, 3.02 and 3.1.1.
 	  SMB Direct allows transferring SMB packets over RDMA. If unsure,
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 91ed47ff8f2b..0c3a4b6aa03f 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -5,8 +5,6 @@
  *   Author(s): Long Li <longli@microsoft.com>
  */
 
-#define SMBDIRECT_USE_INLINE_C_FILES 1
-
 #include <linux/errname.h>
 #include "smbdirect.h"
 #include "cifs_debug.h"
@@ -527,11 +525,3 @@ void smbd_debug_proc_show(struct TCP_Server_Info *server, struct seq_file *m)
 						    server->rdma_readwrite_threshold,
 						    m);
 }
-
-/*
- * This is a temporary solution until all code
- * is moved to smbdirect_all_c_files.c and we
- * have an smbdirect.ko that exports the required
- * functions.
- */
-#include "../common/smbdirect/smbdirect_all_c_files.c"
-- 
2.43.0

