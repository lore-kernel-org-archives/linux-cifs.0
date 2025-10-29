Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CE92E1EE7
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744468; cv=none; b=fngTe0FtMjzdhLcVTzVhss0FEEC7RgmaWw0NUYGifAP5WjBA1ypjqzwvmO5v6xfC2qxp4gJ6Nm8WnFxjaJ+5d+IgtJtYAUtEG41oJvJxDAP+15ZyQKmhdyBbe1baVEK1zNb/551o6dOGQfvqMYWj/+nHtOROfhmHf254J+1I3vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744468; c=relaxed/simple;
	bh=vett1pg+Jw0WgrVssA6y6RgW/rrugYdT8pFcDZahhz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUytjX66ofqcNikhCmptPFuzHIaM+pMqHHsI/TQAmSaptE+fA0lq6UjcpsVHiD5KA/JRCXD4JfqbwacGOy+J9AoRrd0yBGQP0JBPrw9libkKHzm66xZSbwxJEnSrEXirFHiGcWinGQ8J6wb5M7bFAb3jt5O5Hx42VMehUCQpcUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=jtr2A0MZ; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="jtr2A0MZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=bcjMY6JVxw9y7Peakh/tVneXy9Z+k1t808ke8YxKUoA=; b=jtr2A0MZieKmzfUgNzaYw58COi
	e7tl1eXkbhaomF2F/xDCbldZNS7t+9oBjkkfyDD8hnshxdRRIf8k6dbKaxP60Ay4hXGTjhfiZ1irV
	CuyKZLsAL3GCAswDxcJjYXr98ljNsg55TRx9E7wAfcTTtwMhulRmKqwVPhrdmW3zYpsxhr2aZbqxk
	fNTfWSjja5pHbWaDc9kcGES7w0DOV9JF57EHNdXQou8YnkZC5gQMjV4TBN0sWPiSkpGRIPLd9npvG
	wvmRFuXktEWBS+j/2xbU6mhsDapgAnqFsRXFGkdGax8gG9uSiHABQ/E9wPbEzsFtCHY0FywXp1g4t
	hsN5K6eo4SMiMVWdPinLoBmfiEwkQ6UoykH/rttnkMP8UJULfvbDNhXCH1TeOYqSr8pQCxCWubaUn
	UJ2Yb3l2rhC2HwVkCO7B6E2nIkLaQUjEuN5ZnUjEsL0WNr2F4OldHVqrDD8qzrH8/uL8b39c4kh31
	PWTr3Zi3rBoVCXkZSMFSEnFS;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6DH-00Bbzd-2d;
	Wed, 29 Oct 2025 13:27:43 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 053/127] smb: smbdirect: let smbdirect_internal.h define pr_fmt without SMBDIRECT_USE_INLINE_C_FILES
Date: Wed, 29 Oct 2025 14:20:31 +0100
Message-ID: <f33c899c974ea11d0e8c82d2059dc81284d9d937.1761742839.git.metze@samba.org>
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
---
 fs/smb/common/smbdirect/smbdirect_internal.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_internal.h b/fs/smb/common/smbdirect/smbdirect_internal.h
index 0727b9fee879..f8fabddc3808 100644
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

