Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A824A33B6F8
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744183; cv=none; b=CqLX0qrYa1Uyt9s0wz7eqlkr0n4tQGwML9HcfPj+gZPMGImlZVaTBAlon+X4jnJ3lb93YixoeFMK2xjUzHO5cRxAOsXdr2K8m6LD2Y06bJGyKJn1pgTE+03atGETqFY+fXrr7zhPCH6PosyxhPwQ1RSTE3NU1X6oYDvR7IWhkRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744183; c=relaxed/simple;
	bh=z/Xl68ZDAZGRjfPXFoPfmQ+mmakF+Wxzp+PubjmG32c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zs/f2LSKXR6X8eCagSNXtwYOiuruLGFFQpIygsZLhvljAoSzj3lH22IjktOCRV6HfUwWuuNPAhiHaPDVnu+PodZLbf2X3DGIcxXgycpUTEkIMQs51c0sb/m0sOtfu7pVkTCMOWZM7x8yIjFDjEbYgFRKKqrOKKk3KwvLcgmK97M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=EqU00/4g; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="EqU00/4g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=0EgTWRMvRBH08xV90+7doxf8PSfYEWvDqLinvlYkZgk=; b=EqU00/4g4Zjh3Wv9UaitotMQuZ
	3rfiwnT4FHnUsgFmbiCGoQLHb2uDNwdlkawSTqHWWn3ryo4vlLJ9YycMk95xwTs1Qd8a1G1oewyaW
	A49cwnT9ge329QFMKjLfmMuSqvgoe5K9QqQqTSnDLCgAy6kdzHyDW9LEJLo3TIBKlgKr/3zq9RiX1
	vUgVnLLp1RwgQeBAsm84O9BB3a+sJtTyGCScBLJogIUw9pXvWNHdFYoAt7CI2qiMNWT2qaEDxuKOQ
	8bAn0xZOpzUz6YVifxXxXI+1AqxSxtbQKugB1IMsDyRU5AIlo7mkkb0VX8/nZIgyLu1K+DY4DS2Af
	nKQbJFPT6rUDQUbI96yrFd3LftZ77EeXaUjUKkGrpDoeR4M4+ykxSB0v1uE6mT1GymTi02xZjNJJJ
	PHP9ihgRRE2IbYTxOx7PXHBE5hUpabaozEwQW1DCXj27OdjBCNK0N2JdPGzbiyQSxVrqZKYPhIRom
	1KR/urkSwLDigBYcODvgHyxN;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE68g-00BbF9-2F;
	Wed, 29 Oct 2025 13:22:58 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 004/127] smb: smbdirect: introduce smbdirect_all_c_files.c
Date: Wed, 29 Oct 2025 14:19:42 +0100
Message-ID: <a4b06a87a19e511ac63be351633b900a4941d1f6.1761742839.git.metze@samba.org>
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

This is a very basic start in order to introduce
common functions, which will be shared by client and server.

As a start smbdirect_all_c_files.c will be included in
fs/smb/client/smbdirect.c and fs/smb/server/transport_rdma.c
in order to allow tiny steps in the direction of moving to
a few exported functions from an smbdirect.ko.

Step by step this will include individual c files
with the real functions.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_all_c_files.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 fs/smb/common/smbdirect/smbdirect_all_c_files.c

diff --git a/fs/smb/common/smbdirect/smbdirect_all_c_files.c b/fs/smb/common/smbdirect/smbdirect_all_c_files.c
new file mode 100644
index 000000000000..610556fb7931
--- /dev/null
+++ b/fs/smb/common/smbdirect/smbdirect_all_c_files.c
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *   Copyright (c) 2025, Stefan Metzmacher
+ */
+
+/*
+ * This is a temporary solution in order
+ * to include the common smbdirect functions
+ * into .c files in order to make a transformation
+ * in tiny bisectable steps possible.
+ *
+ * It will be replaced by a smbdirect.ko with
+ * exported public functions at the end.
+ */
+#ifndef SMBDIRECT_USE_INLINE_C_FILES
+#error SMBDIRECT_USE_INLINE_C_FILES define needed
+#endif
-- 
2.43.0

