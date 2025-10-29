Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A342BEFF6
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744703; cv=none; b=tRzw9BQk+IT0E1Xzpvs7S9RvuNKa6MiYvng/IzByr9e269aD2OMnCHainY/mILBgi7d7CqCvfSdks96Eo85BUKbCNQiFsh6OT91ZKVPLOGw4PqvuANNpECpPQyUx+P6LKVqVarPHZwSTn1cxsxxzQpFLgkg7BRzd6gLvERUPdBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744703; c=relaxed/simple;
	bh=WbFN9LYJ1zDHk0pAzk97G8z4AwBITj2yp04jZN/sN0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/H5iMxVhbXCy5j12VtrWj9ifrN7OtmtvT9MUeKNNpIEEzeBd3PvhVGbNrNKW2W7SlbAy+0u6c2P3KnH8W7a2uBJ9dVvC5fqonc5N1zK/ORhmA7TN+cZix3UptXpOCFlT03Xzn/wPg6Ni3+1EUvCteRZFcT4vW5009p7lY5eNn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=DhDXI96R; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="DhDXI96R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=DEbGESjpA1z5Ya4Y/8qCyqVGQIZoCeEOfi+Sciqa0rA=; b=DhDXI96RiJasI6yOQkOJ1X2k+P
	nFuDJO/eAU4cFuS2K0FXwgzW8toeaMwY875wHF85SoLfo3GwLlpFrxpPgCxWd/x6rLMjl92FomrWw
	Kq317cqW8WdLYWjcmV4WngeIevbtU/JnII1ht0NBqexRYdiETaUGZWlcTLD1vGoWWJZ96OgIXPBKx
	ALNpT+QJVZW/3PvlTrVy9y2l0TiyIfRcb+gDssoEk9ADRk6s1q9hdk+aXB+/mag8hGeUAf28LI/T3
	78Rh9rz9YMXKDBINePDDaT5dG0qWwvicXVdCOmHtkAIXAI8MlKv260hgE3xJhj6Saoc8IMkb/iB+a
	3mk0ewkC6mUNy1fNLPzswCFBcEofADIslQw8LsVTEERJSCzKQJkRDb6F/S2G4qJEchTh7gHDDZN+u
	n7jquT/HxmnkNA6n0/YxZWapev0UBbMsxjaqSDveD8hNyJ8wEL3jk4LgRbme+eLw8TLMX8FinPehD
	W0sUJezfafFctg6SYoWrwd4a;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6H4-00Bcbz-1m;
	Wed, 29 Oct 2025 13:31:38 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	David Howells <dhowells@redhat.com>
Subject: [PATCH v2 091/127] smb: client: make use of smbdirect.ko
Date: Wed, 29 Oct 2025 14:21:09 +0100
Message-ID: <8ae722e2bc80de69e330baa49102011572eb100b.1761742839.git.metze@samba.org>
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

