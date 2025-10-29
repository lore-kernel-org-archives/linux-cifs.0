Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0CA23C4E9
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744200; cv=none; b=ihZa9YS5XiSE3W5uRZeLIXMtFXzsILAAn1YFycJyg6GdixMlqSxZLM2xDFIRf1JXpoyHxEiezUTgwWVbZArF9K2TNLmEVIYI/jDuAjXA9qFK20DUQQDDAcdwJ6NvqcEvGVCNG65FsjB+8NCFMbVNY6kEbWpHLdYAHIvJtMNwrQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744200; c=relaxed/simple;
	bh=EixkC02s5Zd5k8bf0TVE6gBgRhiQ7o0xylmWLZs1N9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqnz05YZ8htYB0suoCTWurG2kH5ybiU6+vywTdTr7BukkM8fArKLAszkhQOACWZWaovA+KXoFxTix0KRonBNyQ40c9AV4SwcWe+q+3Ve+3JykCVaGjvOvuidoalt2kL2RWLsLxEKL8zLq3FNgybJy0+bUOWSEQwKjjrbi94vaJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=n0UZK/NS; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="n0UZK/NS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=KsTARGwLsAdlA1pYu9e58MzCnXSPrmngIasktyeDZ+s=; b=n0UZK/NSwW25ptTuOo5winbXjv
	GveR2HzEU3KA6A6XwP6IBZUVDUz/RMbvbI/jKtCp7hlj9Gc4mtMXubrDKc63MeLHw8d1JbcyYhMqY
	7m3QXpohjPAswssvq6CqBjWvXR/vzC6s4/xSsitDlufbqUca2fCKW/gMmGOzSlUt1UCCcbiN1w35j
	wWdVWFj9L0yA1RBivkfNqyRcBq9QHmvW1agFi/9l/O+HauKQk59dg3MLJqfj+4rwxSXXKB/CEx7vd
	Jt1FEo4aoQH18RJrWexGOWhjFxXWDcJqiGf9xl7qFb1wX6HSiIDr4ZFuw49ApHH39UT1rEQnqngx/
	NOOEIhSElOudCYA+5Y6qt/dj/KnXa7WqBUz2uKpy78SPET/oZThnPHSCgKwltKI6jX29bNsNQCJCl
	cGRftdiZ0yzt+FYvG0EFveytU1NI5zEmTLxBMoTLD5j6grXGi0fEoekI4km0NT9IQnKFiRHcgQ0/0
	5P8prsF1ZzqgHCJOGfDjEAn3;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE68x-00BbH6-11;
	Wed, 29 Oct 2025 13:23:15 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 007/127] smb: server: include smbdirect_all_c_files.c
Date: Wed, 29 Oct 2025 14:19:45 +0100
Message-ID: <58151622e48824d4efc56ca93292dd1962045a04.1761742839.git.metze@samba.org>
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
 fs/smb/server/transport_rdma.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 5d3b48e77012..9bf023b797ad 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -9,6 +9,8 @@
 
 #define SUBMOD_NAME	"smb_direct"
 
+#define SMBDIRECT_USE_INLINE_C_FILES 1
+
 #include <linux/kthread.h>
 #include <linux/list.h>
 #include <linux/mempool.h>
@@ -28,6 +30,14 @@
 #include "../common/smbdirect/smbdirect_socket.h"
 #include "transport_rdma.h"
 
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

