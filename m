Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A2933CE81
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744205; cv=none; b=Hnmm5b8YgdKASFzORY5QGNHTD1i0zxtQpLrCpURrjDgY9TKMifi5CuKlhVENEImPOyfLqCcjSGXRHknHOveg5XirtDJ2r6HYO246WKwC1Hw2qTxvx3mxyYdjVsbU7xuplDMhcWtY0hVFi7ULVBtZdeE0KDjXZo/+1E3/aov4IHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744205; c=relaxed/simple;
	bh=U9LDKlHXsvpqtXkg3PsP0MR1qZAf1woHf1mxjmT7Nqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQi/fRhhZFqG8OZteKPaoQsgg/tX7jF+bYLcF83I6VrbZuuCaiKO81hJN7X26SdXTMyr9FlUIrjUTC5Srv8jKiMYJxPswlBp9WnAJzUiS4amWCaOcaI8DEKtPVtBrF1G0TDf27bGyzmSCo5yQzIg3vD8l1bYAfLV9Gvx8UQfkVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=vx4Zydpt; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="vx4Zydpt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=uGes8dHTXzJiQSLU0y/1FlzJBQ3ZsqRbyStwO7XsH2s=; b=vx4ZydptHdzExfSCxT24axXyjt
	nJN09PQVyr9Gw4Oz0dCmz2PAOqGUc06lX7n4UPxXAtcgh2/JRgficc9e2g8Dk/iJkVmSf3Dr5LIyx
	ro72AsWcYPdRPORouU5tn9UqIZ79wIKgjKkwjmHMssjqqAGwBpqSjGtxBVU094OtwqPKxQvfS2FwD
	3e/jlrE0Tz2zSnTmoI8W9nOJ7zUf1yMwr9Yh8wwGYhVmAA+mfBFAfB872D8zcZgHvGUUTQ1uyx2q/
	gkrT/0KnzJNxbL5IjnetND0WmnJVSECQl0zqg4fVfkk+fpjtWmgKh3E7thpo2yRmiSmp3B7qnBB5P
	z7rXvcOMT5JDYXcPJqfTaLsyYiUPnHxOVsoHyFCZot2b/3t/Nf0bQwfDl7v6Anw7ck0y4WGnEle57
	O6r1JVOsTbetE67o0SUJulMCt72zVEx9el3m5wRwm3Pgzc/4vIiEZ1rC7OF/zlGJAE/sXLE+3VvKv
	d2BEoJsx0stLSB4pmYB4rbL4;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE692-00BbHI-2e;
	Wed, 29 Oct 2025 13:23:20 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 008/127] smb: smbdirect: introduce smbdirect_connection.c with the first helper function
Date: Wed, 29 Oct 2025 14:19:46 +0100
Message-ID: <669569db93998de21b89bb6824518265d4967d06.1761742839.git.metze@samba.org>
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

This is a very basic start in order to introduce smbdirect_connection.c
with common functions, which will be shared by client and server.

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
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_all_c_files.c  |  1 +
 .../common/smbdirect/smbdirect_connection.c   | 26 +++++++++++++++++++
 2 files changed, 27 insertions(+)
 create mode 100644 fs/smb/common/smbdirect/smbdirect_connection.c

diff --git a/fs/smb/common/smbdirect/smbdirect_all_c_files.c b/fs/smb/common/smbdirect/smbdirect_all_c_files.c
index 610556fb7931..ba92f0813932 100644
--- a/fs/smb/common/smbdirect/smbdirect_all_c_files.c
+++ b/fs/smb/common/smbdirect/smbdirect_all_c_files.c
@@ -15,3 +15,4 @@
 #ifndef SMBDIRECT_USE_INLINE_C_FILES
 #error SMBDIRECT_USE_INLINE_C_FILES define needed
 #endif
+#include "smbdirect_connection.c"
diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
new file mode 100644
index 000000000000..ca6508705be8
--- /dev/null
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *   Copyright (C) 2017, Microsoft Corporation.
+ *   Copyright (c) 2025, Stefan Metzmacher
+ */
+
+#include "smbdirect_internal.h"
+
+__maybe_unused /* this is temporary while this file is included in orders */
+static void smbdirect_socket_prepare_create(struct smbdirect_socket *sc,
+					    const struct smbdirect_socket_parameters *sp,
+					    struct workqueue_struct *workqueue)
+{
+	smbdirect_socket_init(sc);
+
+	/*
+	 * Make a copy of the callers parameters
+	 * from here we only work on the copy
+	 */
+	sc->parameters = *sp;
+
+	/*
+	 * Remember the callers workqueue
+	 */
+	sc->workqueue = workqueue;
+}
-- 
2.43.0

