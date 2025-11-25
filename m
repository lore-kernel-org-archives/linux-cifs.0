Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D7A32A3CC
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093452; cv=none; b=mVeJ74YfpNBAEuza4qZxBBDzjaPa1KMAkIpCPNTqt5Vjp5SKMlL7NyDVNzF2n3LBeuOwiEIJGRAhv3nUybdMq85IyPbcOQnX9/aazAu9PLXp5ufsKjhcabLMIYR6DMI/Vs6N9PUqarU9YKfPriX+0XjjenIOckiJDhUqLxuBoBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093452; c=relaxed/simple;
	bh=w7LBUu+Sko7qnnE5fpSrQIjlqHdVynPfhqrsdM6fCFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kW6+9VK0PdtuAfW9hkWhRNQFmNFKSLoQqoISEBjrZlOFvzZ1Rjan3mWKXrMyKGeRatCvkues0VqoD7poVJyiXVcG8r4+uYwFe1nrLJaSBoI10miBoGdnmNCiGUaEgQAWtlykbbXwveu2aKYvddGaEdpZofKOodZGWb/rGfht27o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=JIdfuU9t; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="JIdfuU9t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=ILasSayKTvR0cSE5NAS5Zr8W921YJMVtSvZbeFPPOwM=; b=JIdfuU9tip9fafgsp1+yaeJpUs
	cpbSY4mO3fNhI4PbwbA4+kDO58hb31znuKJ0M0B2zKXL4Vj6kr69WXSSoOharokessZ/EfRYgl/VV
	ZcWGSxVGEo+jXvtmVRWk542g1GeWlhL3/0XXa/PjptU734yz1ogkcMCoPmn3PVzdJKyRcPLlZVx9t
	bTPMp09wyUcqMZ+ahI5nvTvbrzCTjFqZBIDhPHynkhcExueFfyFO519RkUHs7IL7sZ6ad0pCrqjG7
	/UQDvDI3pjkMfFtYob2WmoXCTNo8wiWHbTphh7+/sA+G6pB2reFRdn0u3vW63X7BK7TvMi3y/gA0t
	3jI00I7DXJzqDFQd/wUvuMgToZJRS3RNPIgHBVHYVQlHUXDRzCPWLqJWiSWJ+hFwXoQ1JfPRWbWfO
	uomtjnoe2tsErn3na8AS6+z3uL884NmX9W3b1jjwkgKuuK58FjNDMRGwmVPdPb65ojWHXWtlPul6V
	MH0UGtEkGANGu9UY0tMtO8+X;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxI7-00FcZ7-0O;
	Tue, 25 Nov 2025 17:57:27 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 008/145] smb: server: include smbdirect_all_c_files.c
Date: Tue, 25 Nov 2025 18:54:14 +0100
Message-ID: <d38593de25f7ac822e0e444cdfa1a103461cd7f6.1764091285.git.metze@samba.org>
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

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 4e7ab8d9314f..d656dbf9f7ae 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -9,6 +9,8 @@
 
 #define SUBMOD_NAME	"smb_direct"
 
+#define SMBDIRECT_USE_INLINE_C_FILES 1
+
 #include <linux/kthread.h>
 #include <linux/list.h>
 #include <linux/mempool.h>
@@ -30,6 +32,16 @@
 #include "../common/smbdirect/smbdirect_socket.h"
 #include "transport_rdma.h"
 
+static void smb_direct_disconnect_rdma_connection(struct smbdirect_socket *sc);
+
+/*
+ * This is a temporary solution until all code
+ * is moved to smbdirect_all_c_files.c and we
+ * have an smbdirect.ko that exports the required
+ * functions.
+ */
+#include "../common/smbdirect/smbdirect_all_c_files.c"
+
 #define SMB_DIRECT_PORT_IWARP		5445
 #define SMB_DIRECT_PORT_INFINIBAND	445
 
-- 
2.43.0

