Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587F332B9B9
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093496; cv=none; b=Ei0/UHlXkfXjKFLn62NvqSn3WNI89moFJTES6JoEMb+Ia7lpVQ4EiRULgdD+ZDCoHsWPIvcPUX1AW3Ynl6UytAaxDn5CZOlk9AxmmbmG/yiraS308Qfj9L+F6K1zDdp4KxxGRRkNHKJYjSIGLdBXaRH08Go3q6CGw6M6MAWXYwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093496; c=relaxed/simple;
	bh=DVzZfNSM5MaRg8P/AmAa2967YinSjX+unuZuNofMFuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KsQvLXNzDYikUGV039DeupSLysX/vEb3TBLGGZ+wxVGIt1Qu7+SUb+8xMCJj0wIeOB4kuobM7QftYlyHnjLau/SxwiWvksYZjbngm9y2kO8exeTrqf6fS8hrZsBStrFUsJndkJ2TW20LxcKox9p3saKUlle1wRjjT2j2h9YhbPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=gLlvvbKe; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="gLlvvbKe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=rMVnQEG7bfqjHcaKD1bp+/4f5YYbvpzN230SAxGyDxs=; b=gLlvvbKeMUYZ8mcgGSQtG5BmdD
	20OWWbp6vsmw9yBEYvSqX7OaG4g3oA4Svz3XNpigTXSgd1Cixq6Iw9dJ8Cjw3tc9KMud4E0Iq9Wrq
	inUstQDA4ywkmphn7PEu37XnylEH0SwQYHPh54pvQXhDUKjiAGIIrYHmekMp1PWAScPxJbSJ3mlbM
	Ys3XEVvQWiD/vULwhVoal9Dtw4oXGIg97RhSsO0CVY6h1hBdhvNaPGu/DndMzRvi4lagYcB/jISXK
	XYNm1AjTBCTJfUY/FSw183qCQ+UTZHWAzQuOm/Mo5Ft3GjnpboBGF/gj8gvkVWHnmrJrlzgHrWpL5
	AO7zlw27WoVtT0cJTehlgBv/R/wL3/eppWNZgUiL2nyy4FkJtH/cRD2PyBMKvRZugC+OYxyjQYnuP
	v47f/To5iRxedksr3Rh+b+sUJnsWC+a6jdWGY0q2bexDsf8+y+kC8gXxChjCKkk8K7bxRMYp+Gpq+
	9nmh7uFlGw82cVYntMinLdcT;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxIp-00Fcib-0Z;
	Tue, 25 Nov 2025 17:58:11 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 015/145] smb: smbdirect: introduce smbdirect_connection.c to be filled
Date: Tue, 25 Nov 2025 18:54:21 +0100
Message-ID: <6e3aa1c7813c9797a1fa5c7dd35ecd7acb406f0f.1764091285.git.metze@samba.org>
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

Over time smbdirect_connection.c will get more and more functions
which will be included in fs/smb/client/smbdirect.c and
fs/smb/server/transport_rdma.c via
fs/smb/common/smbdirect/smbdirect_all_c_files.c
in order to allow tiny steps in the direction of moving to
a few exported functions from an smbdirect.ko.
That's why __maybe_unused is added for now it will
be removed at the end of the road to common code.

Note the Copyright (C) 2017, Microsoft Corporation is added
as a lot of functions from fs/smb/client/smbdirect.c will
be moved into this file soon and I don't want to forget
about adding it.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_all_c_files.c | 1 +
 fs/smb/common/smbdirect/smbdirect_connection.c  | 7 +++++++
 2 files changed, 8 insertions(+)
 create mode 100644 fs/smb/common/smbdirect/smbdirect_connection.c

diff --git a/fs/smb/common/smbdirect/smbdirect_all_c_files.c b/fs/smb/common/smbdirect/smbdirect_all_c_files.c
index 269d8c28c92e..93098598fbdc 100644
--- a/fs/smb/common/smbdirect/smbdirect_all_c_files.c
+++ b/fs/smb/common/smbdirect/smbdirect_all_c_files.c
@@ -16,3 +16,4 @@
 #error SMBDIRECT_USE_INLINE_C_FILES define needed
 #endif
 #include "smbdirect_socket.c"
+#include "smbdirect_connection.c"
diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
new file mode 100644
index 000000000000..0a96f5db6ff3
--- /dev/null
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -0,0 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *   Copyright (C) 2017, Microsoft Corporation.
+ *   Copyright (c) 2025, Stefan Metzmacher
+ */
+
+#include "smbdirect_internal.h"
-- 
2.43.0

