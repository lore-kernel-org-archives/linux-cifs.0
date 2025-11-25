Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1654927FD7C
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764095577; cv=none; b=k6diVNRjttWU9sZG0cIVxAc59CHt6/U5tQzyOnqLUcRhoMy5DGL7PR2s6dki/7EZwolBj5s38syVrkN7pCvqT/Trx2IaqPNBkMPsIKtCSoHt7xuSB9337Kn2lONFN4pvWpRDTcpRIbf2IYl8+oQ6PCG8GIYhQv754PGOdLfo5As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764095577; c=relaxed/simple;
	bh=FYid0kKQR+Z5YSmwsNScxkmcXmEYlXX6cDLVrvELTrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J5nLI3YRW4FL/AwR3277uB4JjAHdugmv8jVAf22NsZ4RmsauUI4mjatsYjkom5TxX8uSQqF9Qh7ILyn40FEsqPHy9qdAbVM03qHzq/fTTn5MM6DP/rC4dBeUUR24KGv4YfYEat19rXmezI+1uhIXemTKZSetzYdDhnEt6uww7lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=kDJZ/pEV; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="kDJZ/pEV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=DiLwwB7Moi+57tbTzIGDnugGWGAcOC+rjlIimTIPO60=; b=kDJZ/pEV6OWGu5+SHzaszipKx6
	AaeWOBxEzfjEfENAdr5Da2SYodG1xDXTOW/+HZvDet6tTw+l9c1AN5L46Ba3ZgicAY7Dqlcw8XBQc
	1UxRGBzGaXRLiTu+41gPgkmMvlCBcoyRpxLITQfRG4W2oAuSKgrZV9fRDHsK9BiafsHtwMxwSR6rB
	zcxU4OPOaqkf5y/Wx0fGdvgyJjEXxWTFQy2HG6/RcjM+pPSJLYM4ASPc9y30f4uc9xYfMeX1go21G
	fVoD1q9clYR+8aTPxm/yIMVqPJ+arpqlA+QGvSwcUxnNAbNchDb7hNEuDTx9Kb1e5t5M+0MizT2IA
	j8w5fsOtH50xaDoLpcCpZizJ4AhZV4OdEXCO7amjVB3B2VyYj14EWwGr01pBVaJGW52grfwoLPZv9
	XvOReqqpmlxm9xPFQrPFJH9IB6sa4yvR/HvX93R/tcl67lDXVZp8bkmg4KEOCXC5itTMoFujgBCx0
	Dca8A8wRKKMn/UMsVCvq/PQ/;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxi1-00Ffpy-1A;
	Tue, 25 Nov 2025 18:24:14 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 133/145] smb: server: make use of smbdirect.ko
Date: Tue, 25 Nov 2025 18:56:19 +0100
Message-ID: <9af09ceadcb7d6014d5fc63f5cf2d4984d481f9f.1764091285.git.metze@samba.org>
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
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/Kconfig          |  4 ++--
 fs/smb/server/transport_rdma.c | 10 ----------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
index 2775162c535c..2ab381554472 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -47,8 +47,8 @@ if SMB_SERVER
 
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

