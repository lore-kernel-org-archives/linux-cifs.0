Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD0632AACE
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093459; cv=none; b=iQjs08meABXrKaPKdmBGtnFGG9KcQLMM24adgVXEG9pKBrqIpCkaS+xMx35/EYYYf0srp5O9vr6RekXvR0UmPx84AGHVlEtJTwZVbkJetqZ2Vjqj49Gimx6tYtri8JTRPamAnoJYfE5Qq/MCV3QcTODZIy99uvvJHF7/k3cZp9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093459; c=relaxed/simple;
	bh=c3jVMia4jxYpvJZDhGlTwiMOCM+DQubZvwJHBsljplk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HC4V541lp7G+LAbsRE+xc4zaDYCeUGNtTeCyZaRojrcZWoHk/9gktyWgTOEQyjsAc5q+F2vVN2UrisJ7NzkCkTxNXzoEiRzm7EwgA9mQXcM07F6nYPp3QfHYSNQJMmHASl1fH0iSnVvgkSFdj7hOKc7FvhINWYiPenuWj5J8VYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=N19BBa8K; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="N19BBa8K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=+iJTV0wB0cpRbHenev0TKJ/bIph3WMc1RrBAoT/CYqo=; b=N19BBa8Kowuc4cgeDt1IpybrFE
	f3eIL40Bgb8G9gZN/bMK/fOIS6coaBN2z3wqzi549kGHIFj5VPjAxYkXY9WcWHEmZ6GM6HQgHRxn7
	vkefV/+Nnt7HDmrcBbOGej9fQjzJvK3rCTjwBN7zwdewRAG0CRX+eReZ2UIuNN8zyeVbpvgrp/L+J
	9Gd202TWBZe4BuNr3oS04uUsjpb/H1gT5mNZHFsiakwkPTljJj75f2RrOhUWP8rQLjSfG+tPsOH6c
	uOAhpzfclQA8WMtLzYn4clCPJ8fSb2RFQ/tDxW1FTMaUlCUYrO7fgbpwQUTNdqUBJgpzKI7afe0hB
	oMsBAwu7CszbsOlEaHHguIWMQun4GF3kf5qBFk5vUmLxoC+4LzTHRyRakAU5uUovoXEZJln+wr93+
	0Y8L2DmMKtPmaMZrkzHe+Tf5X+EBBBXJXqjIWcGLZJvskTLsvcAPnuKPkBZPC6/ASD6/2Gql7D3sY
	1S3yWsKiG1tHjfbwlHkozzSM;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxID-00FcbA-01;
	Tue, 25 Nov 2025 17:57:33 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 009/145] smb: smbdirect: introduce smbdirect_socket.c to be filled
Date: Tue, 25 Nov 2025 18:54:15 +0100
Message-ID: <290632858a823c0c257bb7f92ff694162d1c835b.1764091285.git.metze@samba.org>
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

Over time smbdirect_socket.c will get more and more functions
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
 fs/smb/common/smbdirect/smbdirect_socket.c      | 7 +++++++
 2 files changed, 8 insertions(+)
 create mode 100644 fs/smb/common/smbdirect/smbdirect_socket.c

diff --git a/fs/smb/common/smbdirect/smbdirect_all_c_files.c b/fs/smb/common/smbdirect/smbdirect_all_c_files.c
index 610556fb7931..269d8c28c92e 100644
--- a/fs/smb/common/smbdirect/smbdirect_all_c_files.c
+++ b/fs/smb/common/smbdirect/smbdirect_all_c_files.c
@@ -15,3 +15,4 @@
 #ifndef SMBDIRECT_USE_INLINE_C_FILES
 #error SMBDIRECT_USE_INLINE_C_FILES define needed
 #endif
+#include "smbdirect_socket.c"
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/common/smbdirect/smbdirect_socket.c
new file mode 100644
index 000000000000..0a96f5db6ff3
--- /dev/null
+++ b/fs/smb/common/smbdirect/smbdirect_socket.c
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

