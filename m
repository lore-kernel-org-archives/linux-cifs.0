Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB22306B2E
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744490; cv=none; b=O7d1lKx9xxUSSfoVhYBPZboO0Q5r8uBLsUyW956zMWEkisP7IihXAxsqjtaxmADHn9sUh1Og+FXRg2mIpPpoTWgaLGsCd81OAvkHc4VAcpgt5GkgDTF83dsbgRAYeHZQouoqFt6gQYCz2PovkaE9DEYHW3RzuX0cZgG2sDxQ/ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744490; c=relaxed/simple;
	bh=iFgbnwHxWGKS0GhbM0q9WQvs7Jn2I9ng2YYSE8l6O6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+EYPtx/frKynkVOdqnItFPqZDfrbbWq90nwjENVWbLeIivObcB0qQgU2uuGidiehKVd/1+OUdN2Wz09pI9HegTEmR/SNKIcdW0qK3rliQ7V+1N4LjofnZCEpXQH2uZWbe/IHbFkUXg7Yq4MFTGbAdnL4cAW8qHRwVjFtVrJlIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=R6+eWqhs; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="R6+eWqhs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Edtvz7J13GK7PrKL+/9EWcNSb/xlAPA7kvQBkMU3lss=; b=R6+eWqhsFVbFrHASwpEN6MtNhE
	UJBugJewB2zdreM4hT4AwKVLQu2qoDnRA3RLgfc+4aE4Obw6jy+ZACAHlfo7xQdy/CDYFlmOwPy3t
	8caecqfohdyTEOWEQhOdHtXOKysgVlmtr7lTnJu0Ro/BRGMVXahJRKJp+MejgDBhEKiinMADE54D0
	I/oMTAGCspfPESUXGVDkZHOnvM/EtwOYbrEniPC9E3KbCkwYHbzItSxl+7hbtYHHEr1ueMv2SImLM
	22XhEogwhc66aVInihh8nWliPik0eFSl5v7wvL3S8ApBlEaQJ711yMUU+e0WqLxU6PrL+9bvHHKZM
	D2k110xUOfts4aU8+J0kyZz/ucIWXlgcgf9Txz/7JRDGKNX1BicflfZElXskchUXGveHA9boEwWTL
	Ilkp+7V2iTSjtx4wCPSV4KwR8gPLuGHEgRJdRHVCWgks47U/3S3vXRjJpXHaDMDHZWvlbSh5feFKs
	7nkokXfntPQxsJe/7H7JP2fR;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6DZ-00Bc2N-1j;
	Wed, 29 Oct 2025 13:28:01 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	David Howells <dhowells@redhat.com>
Subject: [PATCH v2 056/127] smb: smbdirect: introduce the basic smbdirect.ko
Date: Wed, 29 Oct 2025 14:20:34 +0100
Message-ID: <3f5df0582a3553d48932d982dee36230a0ade8f5.1761742839.git.metze@samba.org>
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

This exports the functions needed by cifs.ko and ksmbd.ko.

It doesn't yet provide a generic socket layer, but it
is a good start to introduce that on top.
It will be much easier after Davids refactoring
using MSG_SPLICE_PAGES, will make it easier to
use the socket layer without an additional copy.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/Kconfig                           |  2 ++
 fs/smb/common/Makefile                   |  1 +
 fs/smb/common/smbdirect/Kconfig          |  9 +++++++++
 fs/smb/common/smbdirect/Makefile         | 15 +++++++++++++++
 fs/smb/common/smbdirect/smbdirect_main.c | 24 ++++++++++++++++++++++++
 5 files changed, 51 insertions(+)
 create mode 100644 fs/smb/common/smbdirect/Kconfig
 create mode 100644 fs/smb/common/smbdirect/Makefile
 create mode 100644 fs/smb/common/smbdirect/smbdirect_main.c

diff --git a/fs/smb/Kconfig b/fs/smb/Kconfig
index ef425789fa6a..065c0aa130e7 100644
--- a/fs/smb/Kconfig
+++ b/fs/smb/Kconfig
@@ -9,3 +9,5 @@ config SMBFS
 	tristate
 	default y if CIFS=y || SMB_SERVER=y
 	default m if CIFS=m || SMB_SERVER=m
+
+source "fs/smb/common/smbdirect/Kconfig"
diff --git a/fs/smb/common/Makefile b/fs/smb/common/Makefile
index 9e0730a385fb..e6ee65c31b5d 100644
--- a/fs/smb/common/Makefile
+++ b/fs/smb/common/Makefile
@@ -4,3 +4,4 @@
 #
 
 obj-$(CONFIG_SMBFS) += cifs_md4.o
+obj-$(CONFIG_SMB_COMMON_SMBDIRECT) += smbdirect/
diff --git a/fs/smb/common/smbdirect/Kconfig b/fs/smb/common/smbdirect/Kconfig
new file mode 100644
index 000000000000..d8d8cde23860
--- /dev/null
+++ b/fs/smb/common/smbdirect/Kconfig
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# smbdirect configuration
+
+config SMB_COMMON_SMBDIRECT
+	def_tristate n
+	depends on INFINIBAND && INFINIBAND_ADDR_TRANS
+	depends on m || INFINIBAND != m
+	select SG_POOL
diff --git a/fs/smb/common/smbdirect/Makefile b/fs/smb/common/smbdirect/Makefile
new file mode 100644
index 000000000000..251766424b6b
--- /dev/null
+++ b/fs/smb/common/smbdirect/Makefile
@@ -0,0 +1,15 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Makefile for smbdirect support
+#
+
+obj-$(CONFIG_SMB_COMMON_SMBDIRECT) += smbdirect.o
+
+smbdirect-y := \
+	smbdirect_connection.o	\
+	smbdirect_mr.o		\
+	smbdirect_rw.o		\
+	smbdirect_debug.o	\
+	smbdirect_connect.o	\
+	smbdirect_accept.o	\
+	smbdirect_main.o
diff --git a/fs/smb/common/smbdirect/smbdirect_main.c b/fs/smb/common/smbdirect/smbdirect_main.c
new file mode 100644
index 000000000000..c9fc1e1de0ca
--- /dev/null
+++ b/fs/smb/common/smbdirect/smbdirect_main.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *   Copyright (c) 2025, Stefan Metzmacher
+ */
+
+#include "smbdirect_internal.h"
+#include <linux/module.h>
+
+static __init int smbdirect_init_module(void)
+{
+	pr_notice("subsystem loaded\n");
+	return 0;
+}
+
+static __exit void smbdirect_exit_module(void)
+{
+	pr_notice("subsystem unloaded\n");
+}
+
+module_init(smbdirect_init_module);
+module_exit(smbdirect_exit_module);
+
+MODULE_DESCRIPTION("smbdirect subsystem");
+MODULE_LICENSE("GPL");
-- 
2.43.0

