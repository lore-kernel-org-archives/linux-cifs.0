Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAB6396579;
	Tue, 16 Dec 2025 12:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888325; cv=none; b=CWRpf9r59C9XTUIB85xwy9M5V39sI0sTfwWusaRM24B6ugC9U1WA59tnvp3WC+39FU0cfl8ScCmTi8bdcFi9xzJOlPjuGETu0Ylqc6l6UM2DRO1Z0cBcE12UpAVAYxv77pWhwQXkUuLJVOHGI830AYuY0Vr6SPJpaxNUy3nCIe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888325; c=relaxed/simple;
	bh=F0E8z3YJS7za89WtMyi2ZHrRlSWo61zD/M21UzUw104=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HePL37YdaRRVRiCGaQ3cAwqG88/1p96YVYvYyMM03KeZqgBINmTtrHpDa8IxkyFvneeSWrFM4rIFyd9CxOrjruc+v37Jjqx2al2g8DWzmY5IjXomwDHUx9A4NtJgRnQ3AgCnJrdyFpOWt9AUn1x9dFBuDrugRN3G5ZECzkj2rCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BwjRHzBS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BwjRHzBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CDAC4CEF1;
	Tue, 16 Dec 2025 12:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888325;
	bh=F0E8z3YJS7za89WtMyi2ZHrRlSWo61zD/M21UzUw104=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BwjRHzBSrjwfPm7KOrzdRSxhBpsdJ7D2vgisduC/0lCwzA4XhCGhw1nl8seDQsrkY
	 BlhgLhr2DgeMV5W//f+pdIQKHF1qFnybPkec1uYcAxK7vEXxJ7eB5g3iHxy5kd3hNl
	 CE7ZJS3ubtkOOxjHhOYsY5ch1MOY+71sAOUHlXxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 501/614] smb: smbdirect: introduce SMBDIRECT_DEBUG_ERR_PTR() helper
Date: Tue, 16 Dec 2025 12:14:28 +0100
Message-ID: <20251216111419.521874013@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 1f3fd108c5c5a9885c6c276a2489c49b60a6b90d ]

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
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 425c32750b48 ("smb: server: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks in recv_done() and smb_direct_cm_handler()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index ee5a90d691c89..611986827a5e2 100644
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
2.51.0



