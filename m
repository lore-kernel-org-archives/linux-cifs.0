Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725B132C93E
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093956; cv=none; b=czChEw3Fc0hxYjyFQJzEa1QM2Ov/OhmlD4+S2FPQ5EzKy9TbGqbRIYteOKUEfe+jGXI1ZHRMGv7+LiAIv6Ek71rWA6HDv6I2EqsC0UbglzymrQxW6IVtYCAsU6mMTxq/MCKEu/XqTNi3Y2MWLnwfei9Uw2a8IOB0JoTUOkOkgU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093956; c=relaxed/simple;
	bh=W5OcAEjeh/15ujGBuUmxIoYtaLes0KsGJoRStmwKjFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lwo+aCyl4F+hrGLJoDG7vJfNVhZ4ig+v5Co5A3FAPLTxxoJ9QkSiss7atYlMlvlQEKdzd0ravb0V+XrqcDhduAoAz6ic8N3LacVsfyB0CsTTJ9QDnFXnble4KmHeXW/219Cp/gXxpqmVU2/1T4dzIhsgyWvavlfWQTTevL+XPgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ZJXAWawN; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ZJXAWawN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=3rjPAjStoO1UpAydj9sXqgkjPdRrA1M364NWhOlYKRw=; b=ZJXAWawNaIwH7ErTkwc3mEO3Jq
	919wsgIGHn/VwTKGIQi8gu4+ZaQFpLywSm/Rl/X1PbxAbd8G8B7OZ/mw4G1LlAWeElibJekVFciTh
	VD4KuGnwLxjc1Qct/nEXd5dEot3hxUgTeGkDIZ9gKSB7XshO/EihRjY1npm5Ff9f7uNxNx6AOgyFh
	hJfhNuTHpcbfu+jCsN5Yb4c77qElg57F2AklTeOBsdTrA7+ii33nzPUk5HDzDtexjoElKy+bZD4vC
	GovNWskiimAkbt0Str1CikPippd/2XUS4XxC+yTTTmfRQo91SbtAksoEsNWJri+HGqTjR9/9Q60DT
	wXdF7jZMym73FVmdl1bQ55Ch/EQkbDkO4vH7qaP96TDTPT+xNxd/M02v12sMHNDUjmTtbzd5uO+9k
	qfvpgjYNR5Zw3TqtTQK1AsC88lJcukQbVTQJ6N9qKSlQ+0wvF3Rx25iBzbk98x3LqitHwPgZ9edpM
	6oTH6HyW5MjtJLGJ2+D0iD4I;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxN9-00FdX4-09;
	Tue, 25 Nov 2025 18:02:39 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 057/145] smb: smbdirect: let smbdirect_internal.h define pr_fmt without SMBDIRECT_USE_INLINE_C_FILES
Date: Tue, 25 Nov 2025 18:55:03 +0100
Message-ID: <4cbebdbf147d38e1d6ada64aef2eea716abd03a0.1764091285.git.metze@samba.org>
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

When we move to smbdirect.ko we want log message prefixed with the
module name.

Note callers are still using smbdirect_socket_set_logging() in order
to redirect the per connection logging to their own log functions.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smbdirect/smbdirect_internal.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_internal.h b/fs/smb/common/smbdirect/smbdirect_internal.h
index ead845948089..8ea10f8f8501 100644
--- a/fs/smb/common/smbdirect/smbdirect_internal.h
+++ b/fs/smb/common/smbdirect/smbdirect_internal.h
@@ -6,6 +6,10 @@
 #ifndef __FS_SMB_COMMON_SMBDIRECT_INTERNAL_H__
 #define __FS_SMB_COMMON_SMBDIRECT_INTERNAL_H__
 
+#ifndef SMBDIRECT_USE_INLINE_C_FILES
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#endif /* ! SMBDIRECT_USE_INLINE_C_FILES */
+
 #include <linux/errname.h>
 #include "smbdirect.h"
 #include "smbdirect_pdu.h"
-- 
2.43.0

