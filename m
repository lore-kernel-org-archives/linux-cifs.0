Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301402882C9
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744915; cv=none; b=BUmSMBecWIBs1FpnBELPruyc8ijfgtubOHqcHC8uSSAxyQZdYNHofeAuk5Ld/iRiDHVVUOB8XVDy/YBKDLZQZTM0Du0zdRv5YiwWYByjGcjsgClWHcrWEmpiIu+6Qswpyugilq+JjivD8mpk3srd0ctj2bLkRsQi90QvJAwbnj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744915; c=relaxed/simple;
	bh=Jjk5Kju32pctZC+NWn9fPo80L0dmCpXJgaZWkFa9ECY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rp0UXKaPUPjqZyA6s7AbhzhGm2vo9j92yXjR0S4nOzcBDPm3WsvK4GwE0JPiJBXOzjM8MD+Dc7LR8b71XgWHRfu5ObwJpCmLJDwbHY2buzKiYeoGosOr6K5nDHuWpRhsPiLnbfr1QBCubfrMJtupH7yKhQA/KLHKubdUjnXPX6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Aldxi+2q; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Aldxi+2q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=EmsEjX8nlpjgRFwyfWoxd86W/jVwuYDI840kd6MqCMg=; b=Aldxi+2qr/vLdL7Q+oyvO1duIo
	6YYdjGq/zrCkQbmhypjjXhG2vqUPZzwPMkrxy2XmC+jHcVCFBVdnmVvziJxnKaCcLOp6V96Jnokyy
	oeFkY+jAkPguj9v3Tnw4e2XgbbB/nkha11V+E4f5eE9MOWXdUGOW/LVCdsl4KILgSSYgzFyBljzrG
	qHoRIZSiEhWnm8cgGMsApDFwneydK/NQn1rPpLLum4UefmI8v3QqL64e3X8AhQ7Jiqaft7QzE+iuF
	xA8oFiUmpZ7dcWHAermtU/MZwr3Ty6NSUR4zCjy/7p+jmSa9yQSa2c8BtroMiwdP44VnhTnhvOPAW
	x2NtM3VrSrLAUTdiMIco88kj/aGq0dNfD4v3qGc70C1eUGy9AdOE0dE1AW4cuvRiBaLLlEC6in0bW
	qnUmNkxxUFKrwWk74VB82+hw1C0uvtqqQ9BAe0duBXieRRVnUH6UQbdmyn5YjEO0/f3dmTxuzI512
	HlkDxSCi3AFWYcIoxhctfJkW;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6KU-00BdBE-2w;
	Wed, 29 Oct 2025 13:35:11 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 127/127] smb: server: make use of smbdirect.ko
Date: Wed, 29 Oct 2025 14:21:45 +0100
Message-ID: <ca69115a279fbe0455c1b48d283072520e257d45.1761742839.git.metze@samba.org>
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
redirect to ksmbd.ko functions via
smbdirect_socket_set_logging().

We still don't use real socket layer,
but we're very close...

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/Kconfig          |  4 ++--
 fs/smb/server/transport_rdma.c | 10 ----------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
index 098cac98d31e..59a059ecabec 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -49,8 +49,8 @@ if SMB_SERVER
 
 config SMB_SERVER_SMBDIRECT
 	bool "Support for SMB Direct protocol"
-	depends on SMB_SERVER=m && INFINIBAND && INFINIBAND_ADDR_TRANS || SMB_SERVER=y && INFINIBAND=y && INFINIBAND_ADDR_TRANS=y
-	select SG_POOL
+	depends on SMB_SERVER && INFINIBAND && INFINIBAND_ADDR_TRANS
+	select SMB_COMMON_SMBDIRECT
 	default n
 
 	help
diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index e7d54283ae47..c261082ff9c7 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -9,8 +9,6 @@
 
 #define SUBMOD_NAME	"smb_direct"
 
-#define SMBDIRECT_USE_INLINE_C_FILES 1
-
 #include <linux/kthread.h>
 #include <linux/list.h>
 #include <linux/string_choices.h>
@@ -627,11 +625,3 @@ static const struct ksmbd_transport_ops ksmbd_smb_direct_transport_ops = {
 	.rdma_write	= smb_direct_rdma_write,
 	.free_transport = smb_direct_free_transport,
 };
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

