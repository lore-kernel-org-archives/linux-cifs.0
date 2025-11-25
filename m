Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A3E15ECD7
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093442; cv=none; b=OagVtcvDRfaeOLC4eduLkCuYC2S3w+6h8V7O8Sn7KgObwQKoo5VgG7NvdS/ta6T3pC69FKXHTZdgctsPd6AXnHAuG9N/XaWaRSHxzVQu+gr3dpGRddQ5YmqIeilDddO0Sqi/9iZCotg49BoGY6ytBaxRU/wkOFePDRe5KmYtlZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093442; c=relaxed/simple;
	bh=NHM3wGG3kXcXOog6ZeAnipRfD/csdkdapN4UWflP0so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEXXD6C8IUYAoZ1rJK2Wkkxm05dJ+zc6vtBbEx1Jahoog5W8SflBti1je9TRcQ1Ag+seJI0IfkBqNbJ/g7HrNQSBng96SqdkUn4RQMCaGRl+NCrf0Bbgeudl9B7omoUC6yrJzelyxD40m6cTJO9wUDiQUZqr8i4K/vkVhYQvowo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=AvQB1sV9; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="AvQB1sV9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=PUNrA2/WBdaoAW+QvA5c29shDZNDZY61L0vkRUkT/Zc=; b=AvQB1sV93ew2ocehWu1Dywo08I
	YJ4MJBMaSQyUVxALDK7ILubHdrYTrHGvyVkLgsg6Jv+5hEt2WO+rObkghmJDkpCfQ8rDS8cA44jfJ
	rbtHO98qlrtBWvbLU9UhBvbWDVuf9Zukf07q8dAXUC3NIwmhao3CNB7t9jfzSmMY98xJIJfYn4Eqa
	am2LMb9Z3EPsPDw0It7rZia0nfIAOtsOfAoaqhzslx4KT4ycyo3U91DoRj5uuSwo7F4pxEWuqiOax
	3ur3dwYmi7c+hXtclYjdHh1mK93Db75gtsCdG5gMP6bY7B6m01/sB8Xblacj3Mn+CAuDi/KSsh1L3
	R+M4J7qoeo9YGSEz5gp2AmFyz1M9AALNLSiakPGrXsuO+QFpMSqomClN8mUS9adYeNZzv2dQMY/xP
	t+IKZ6qjWlMc/1GTKkoy7VGnoFOahQFUvLpwghsaacIImLS6VhNlX7UjA1vWxk0oJbb4NVGj/8hOD
	i1QVejaAjaLMNaDmUu7DwRsQ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxHv-00FcVf-0h;
	Tue, 25 Nov 2025 17:57:15 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 006/145] smb: smbdirect: introduce smbdirect_internal.h
Date: Tue, 25 Nov 2025 18:54:12 +0100
Message-ID: <3bf83ddcecd56c6c25d42f67b2c3365287aa53ae.1764091285.git.metze@samba.org>
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

This will be included by individual .c files as first
header.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
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

