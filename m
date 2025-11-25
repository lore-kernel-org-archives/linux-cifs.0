Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC81279918
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093967; cv=none; b=mauaIyPnrm4zZFcBYExl+5AeAYbyDLMOoX6bHAjQBh2myRZloq5fZ5G3aylC9eOvqwBU22uAKjk2hhh+Fvb5bGkcTBbw6Fk7KKdwU12Kijb84TSorg/DIRC5Z5XgyQA4v0Dn1Dg+9IQFlARHHqOHV9Br3Vk4bUJsKH3vNIQd1mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093967; c=relaxed/simple;
	bh=pKIxhWZazmzobuRqRir3oz5NhMLXtY/Tkxx5VltkrLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Py1GougQssl3vwB3IW5F3aaRR8wLHhH/Kzblm9jhjGCZYtp4Gmqdo9fSSsiSHV8EexZ5f0kepXoJ+qxQ0cEwdIYI7Oo2QZP+xwC9k8xPHN3bZ3Txso+1NY63TEanHfedkR8M76pdBCi343G4NkQDnSSFivFp5RS+yd19gPPzmn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=M4P+Z6kq; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="M4P+Z6kq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=4qJv5OdAyX15EHqcuUE4I1SY1VsBTmSSmMErw4RxFwE=; b=M4P+Z6kqqWHkVMCGfUOq6V8h1P
	MKLFQlJOBwjt0Pa4+ns+m97NqeWKoZp/2uNWpeDhcBKyLidXiQeWx/Rw6QTvTPhf88ltUR5pzyQP2
	VgPWkHK/OWrzekseXz0AV3Q5sr6yH6XyoS5X6j1adXvs7IISybkZ7IjQIWRQhmJ8KRShPrtnj4Geg
	ikpZgt/rcBrol6DV/gJXauXRD//rB1Vx0wmZjOY+thbr34FC84x7EALkyWpp9MxxceBirS4AsPzGF
	UpjrzdJCQ8f79uqD3GcR9mg5HDJ7xu0Lsx42VL1cW3ztdTqdYpGYVgsLiZD7HEQbeXx2yTeqyEglJ
	T3/MuCKPpZsSNH7/oL9nEfqRnQaYDJcsckyjkOzOTdp91LUmJOky+jEVt84mgdh/xtvjmg6Z/Xqkg
	ldrEyu0bxvOf2gq/S3kHA+pIUm7KhCnIRdadsl5ImVAVwxUsfhaUP/am83reymgSJLc9HiZU0DvUr
	mPOStqJWzztRWT5M35NB2+VW;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxNU-00FdZt-1M;
	Tue, 25 Nov 2025 18:03:00 +0000
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
Subject: [PATCH v4 060/145] smb: smbdirect: introduce the basic smbdirect.ko
Date: Tue, 25 Nov 2025 18:55:06 +0100
Message-ID: <b4bca8a5c664e030d1d6680bf369a2df140f1a63.1764091285.git.metze@samba.org>
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
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/Kconfig                               |  2 +
 fs/smb/common/Makefile                       |  1 +
 fs/smb/common/smbdirect/Kconfig              |  9 +++++
 fs/smb/common/smbdirect/Makefile             | 16 ++++++++
 fs/smb/common/smbdirect/smbdirect_internal.h |  9 +++++
 fs/smb/common/smbdirect/smbdirect_main.c     | 40 ++++++++++++++++++++
 6 files changed, 77 insertions(+)
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
index 000000000000..bae6281fdd39
--- /dev/null
+++ b/fs/smb/common/smbdirect/Makefile
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Makefile for smbdirect support
+#
+
+obj-$(CONFIG_SMB_COMMON_SMBDIRECT) += smbdirect.o
+
+smbdirect-y := \
+	smbdirect_socket.o	\
+	smbdirect_connection.o	\
+	smbdirect_mr.o		\
+	smbdirect_rw.o		\
+	smbdirect_debug.o	\
+	smbdirect_connect.o	\
+	smbdirect_accept.o	\
+	smbdirect_main.o
diff --git a/fs/smb/common/smbdirect/smbdirect_internal.h b/fs/smb/common/smbdirect/smbdirect_internal.h
index a2018670749f..eecc8f6b197b 100644
--- a/fs/smb/common/smbdirect/smbdirect_internal.h
+++ b/fs/smb/common/smbdirect/smbdirect_internal.h
@@ -14,6 +14,15 @@
 #include "smbdirect.h"
 #include "smbdirect_pdu.h"
 #include "smbdirect_public.h"
+
+#include <linux/mutex.h>
+
+struct smbdirect_module_state {
+	struct mutex mutex;
+};
+
+extern struct smbdirect_module_state smbdirect_globals;
+
 #include "smbdirect_socket.h"
 
 #ifdef SMBDIRECT_USE_INLINE_C_FILES
diff --git a/fs/smb/common/smbdirect/smbdirect_main.c b/fs/smb/common/smbdirect/smbdirect_main.c
new file mode 100644
index 000000000000..c61ae8d7f4f0
--- /dev/null
+++ b/fs/smb/common/smbdirect/smbdirect_main.c
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *   Copyright (c) 2025, Stefan Metzmacher
+ */
+
+#include "smbdirect_internal.h"
+#include <linux/module.h>
+
+struct smbdirect_module_state smbdirect_globals = {
+	.mutex = __MUTEX_INITIALIZER(smbdirect_globals.mutex),
+};
+
+static __init int smbdirect_module_init(void)
+{
+	pr_notice("subsystem loading...\n");
+	mutex_lock(&smbdirect_globals.mutex);
+
+	/* TODO... */
+
+	mutex_unlock(&smbdirect_globals.mutex);
+	pr_notice("subsystem loaded\n");
+	return 0;
+}
+
+static __exit void smbdirect_module_exit(void)
+{
+	pr_notice("subsystem unloading...\n");
+	mutex_lock(&smbdirect_globals.mutex);
+
+	/* TODO... */
+
+	mutex_unlock(&smbdirect_globals.mutex);
+	pr_notice("subsystem unloaded\n");
+}
+
+module_init(smbdirect_module_init);
+module_exit(smbdirect_module_exit);
+
+MODULE_DESCRIPTION("smbdirect subsystem");
+MODULE_LICENSE("GPL");
-- 
2.43.0

