Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9831C5D72
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093760; cv=none; b=gYZJJ9F8vZp2wOp39i/B6KBx0ghTBhtR6q2SyIBgPGVhBpbDQHFk2eJDhIddzsNQOdM9YrzRv9DuDad0v/tRMWl7khX9OKgiiCVecxUEOOTwckcstYuR8K0yvMJT4qukJKmGwNE3YXKTHCOtKotPV7fZLUX6Ghjj6j23lW6XeKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093760; c=relaxed/simple;
	bh=/K1z2oht3FXjB+ieaDOyED9NmGvjnRTGP9DAtbmU2u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RouWSNubfVnp1ah4IIDGNUdlemlf8lIgqVUX8U+MHfc+iZWKDC8kPJDFjUd/1nJeYmfoHGDWurRmASMY28ycQtTeec+PTeE7iwReUULOAzB6ZYOug4hl0uYwLJz8VSx58mChCvV2Zcx8ttgEK1lItqJHWIh/CVcH4JiftCkunFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=nenk8YBo; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="nenk8YBo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=cWjktuw45N3wnmtfOqZpNWGAi4s9n5JE9rpaf+rYeC4=; b=nenk8YBo8t2huQxp8e4uEb6iMC
	aiP2SxW2KqLqcy28MQV7kt8enj3ShhG79I9j+puwlP8VzIAwFDHjPmA1mcSxawIZi8dF5vmRHXEyN
	YHYp01+jHjCU+W2GhJQ3b21FgA3D563TSqwZrEFbPk6QxpH23DkbkbQ6nmqEkVxJGxESLX7yQEFfH
	0W8UovjxP+4APrrEXuva28JcTX5nOe8LKbuDUQImnwpFJhvSqUqz4PjRdmMM8eE3Exu9VVXeDGR3F
	GTA9T2DHsR7jB8I5Fceap5kQAYOb8Dy90WtCK2T2ATYBsa4m0QNbNbBuCWGd0+90iFFzHZawXzZd6
	FvpFNrZFwkW7JWh1GHx13PgznmEpBBzyHzkRgxyGAlNBv6UGyEugw4JTNY2rRpz9+VUw5iHwZkR2n
	OICKdmFpIO1yZgUICllmdMBr80iCrQ/fyKTzqwFHxxrOBupUHTE+9vtpMHDf+lyUNJYlVdYRzUUBW
	o4UkllvagiSMSFgRe8bQN5a6;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxN2-00FdS9-2K;
	Tue, 25 Nov 2025 18:02:33 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 056/145] smb: smbdirect: let smbdirect_socket.h include all headers for used structures
Date: Tue, 25 Nov 2025 18:55:02 +0100
Message-ID: <97aa13bfd745af9cbd7770bd9e7715f13a857549.1764091285.git.metze@samba.org>
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

Currently they are implicitly included via client and server code,
but this is needed when we move to an smbdirect.ko.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 957685ec5857..bfa6a8907de4 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -6,6 +6,13 @@
 #ifndef __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_SOCKET_H__
 #define __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_SOCKET_H__
 
+#include <linux/wait.h>
+#include <linux/workqueue.h>
+#include <linux/kref.h>
+#include <linux/mempool.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/completion.h>
 #include <rdma/rw.h>
 
 enum smbdirect_socket_status {
-- 
2.43.0

