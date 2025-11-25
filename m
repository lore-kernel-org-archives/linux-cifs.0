Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC822DAFBA
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 08:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764060973; cv=none; b=MKFR2GU22d3CMy3qin7vZL0OKlqO5tlLYZ8n+758oXCSZHvU8QNKPF0Uo3xbtqxwL8arp68zCxilS+gaT5vPCtTQA0yxiTd+eRROFK5Ij/K2qhK/KmPny6zA/6H3rYOpfAWTZhzZA/aDpst8yvsOVhqu6HWkml7WLiphJL2CTCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764060973; c=relaxed/simple;
	bh=tcBcw23MLkZvyACyF285nlNGJ0yppijJkckhPBfDZ4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+hl77aNMZdAqYDLBoxoyASi9UsnqBs9LO5SNVf7jnZlzDZJsgHH0KTrFivOSH+0B6j5GLyHT189LkvmhJtOI8yxwDceNrpi900r/Q2vEchHHclm1OaDrqCjPtVKGh6/hRYOc/UHVfmc88MjkI/X0noaZSsZsOVHga9M4xLtVsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=iqHTczwp; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="iqHTczwp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=D/JkWB35XQsNbHhZFKGF3tXGeza4iw8+rQmW/843H1k=; b=iqHTczwpV+p18f7Z+S9HoxPG0V
	ma7WoJ54VwZX0Exbwy4bAt1SOJ31pFeCfEmrkcjhOUMeQ752+P8ozMyU0HAFrePr3UYBZ/anY7RbE
	ZnSYpOiePJUFsOebzqL08D7n18xobjs0J/0BLFdRrh6p3AfzyixrI90Q62y5uo5oWsMYJZVEKineX
	/jGARRcswhDAlSXSvzSAq/LOmoFKECQI3IfZ6LnJmq7lCXye4UVLEWA4d+yqWRqzbcBrVpSfvOZD3
	CPy0C5CvwAmmyH+GrTQOaVtXREgpddS7mDM+Ytmnw7mM7nHjltBfnNejbSisiOMLkLYCUwIEY4tIn
	R7tWZeInV/uvVXErxGRyq9VrLDiPB8/D5hijzFF/ymWFCV5/NLIppqkBJPZST5IPitVKYK2lyMWOX
	dXCKFJH1velj246t6Lmox6mnRMbcfcYWcgGRNUn0J7H9WVYlyl/W0fPbRyguxmjPOQqp2Rxkg8Thz
	xnpPKM9DpLwbHXrUeU0mvfoW;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNoqG-00FYJU-2Z;
	Tue, 25 Nov 2025 08:56:08 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 1/4] smb: smbdirect: introduce SMBDIRECT_DEBUG_ERR_PTR() helper
Date: Tue, 25 Nov 2025 09:55:54 +0100
Message-ID: <d62ca3c6b59271264264e93dd3001a7c3132dd84.1764060262.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764060262.git.metze@samba.org>
References: <cover.1764060262.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This can be used like this:

  int err = somefunc();
  pr_warn("err=%1pe\n", SMBDIRECT_DEBUG_ERR_PTR(err));

This will be used in the following fixes in order
to be prepared to identify real world problems
more easily.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index ee5a90d691c8..611986827a5e 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -74,6 +74,19 @@ const char *smbdirect_socket_status_string(enum smbdirect_socket_status status)
 	return "<unknown>";
 }
 
+/*
+ * This can be used with %1pe to print errors as strings or '0'
+ * And it avoids warnings like: warn: passing zero to 'ERR_PTR'
+ * from smatch -p=kernel --pedantic
+ */
+static __always_inline
+const void * __must_check SMBDIRECT_DEBUG_ERR_PTR(long error)
+{
+	if (error == 0)
+		return NULL;
+	return ERR_PTR(error);
+}
+
 enum smbdirect_keepalive_status {
 	SMBDIRECT_KEEPALIVE_NONE,
 	SMBDIRECT_KEEPALIVE_PENDING,
-- 
2.43.0

