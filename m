Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DC913C9C4
	for <linux-cifs@vger.kernel.org>; Thu,  7 Aug 2025 16:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754583207; cv=none; b=rX/T+Uvq7MNLxF1XTwsdb6otZQ7ylFFwp1b1KQwathZcuyW1/XknFzeYyxuRnEsi80VFi2QgXlFbGPW7p1WErxHTjus9etlLnnQkhzReIUf+ee4q33/NgFZZ1+ofsd16P/V5j8qlrheTZNThPzC+OIj6BMLdhQ0WqIEQwKbWUWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754583207; c=relaxed/simple;
	bh=cjqzzMrIS081WSwcMHph/EpKlBwdFxe5KB4uJyWGx9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GiHBt+XVyLq8TU/DOo0Q3JMmLrbZgz01gJ6HdfZS1j5PoZsF0q/mBkpZiUXefOWFqNQLebbdPk1NGdO2xKVE7Nds6yAxZ+N5lRt56G6eSZfi0ZvE0u2PadsW7i0VsUAaO0nskzt0Y/4CUHRUq0kmA+U9nhYm0eDoW6gEWDbY+iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=QDRb+ohk; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="QDRb+ohk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=7F/232G2VDG9RxJgBb29CQuodJH39OPElS6DaH1eU98=; b=QDRb+ohkR6ID9oyalL2zXRFYlW
	NENkbcDtvriiELZ93LPE/gU+8N016oHU5JqWNi669mCajZd+O6o3x1c+JBSrrokq3i6VpTpgL9p1C
	WjH+p9JzcWjkJpue+4yGO+AeD2lZ1wIEqzP4KaBzvtEZALxG7QImMSJlP1kOhDE3IX3fakWTlpx1g
	olsIuEAB+pnSUwuLCFQOwKWj8JpNOy4UmFMWjX5JwMfugaCWe0pzeIG3TQ/HubwQaOJTWMM3S01qS
	+jKNbLdihq0+uNtSH9D0c1BUZGwYdOniHqBNxUOJufbQTR8Kfg4E1dCNPfjEjllqprSL6ZGItDewt
	1uj6QgWVGh56YPrANlQY9+xtfG2hwl7V8yOJaKSpUcwfLowxI5SHKWVTatBljVjkNezQiWtiRWs/b
	RWipVQ2hhW1p1FB1KM/LwIb2l5ff2Faf95pn3M7zFvFntd1ngWo9VgKl/G9yRC6noq+VMolupcQpI
	kbE34N2N++pjZmrX1iCAuTYx;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uk3F2-001ciC-38;
	Thu, 07 Aug 2025 16:13:21 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 8/9] smb: smbdirect: introduce smbdirect_socket.status_wait
Date: Thu,  7 Aug 2025 18:12:18 +0200
Message-ID: <9c447963b95f34eed0f752feb624264e40d8f2c6.1754582143.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754582143.git.metze@samba.org>
References: <cover.1754582143.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will be used by server and client soon.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index f43eabdd413d..aac4b040606b 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -28,6 +28,7 @@ enum smbdirect_socket_status {
 
 struct smbdirect_socket {
 	enum smbdirect_socket_status status;
+	wait_queue_head_t status_wait;
 
 	/* RDMA related */
 	struct {
-- 
2.43.0

