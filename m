Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A2B296BA2
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154586; cv=none; b=sMV0ZiF0AHJ1W+mFRuhAaw3VfVDa5os7knAzpf6NF+N0CNCQ8ZnwWb8IPqae8VCxLjk8BwxETfwioMo/D+PPPcONKos4E07UsYpcRB0WZApVW100qrlhNkcDtxiBsDfHwPwsK+tSmQNvhl3MD/WaSFq6qzfGvzcW/P+bAhX4mlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154586; c=relaxed/simple;
	bh=XKCWDxivOJSP5ZNtSZ810kfkVf17sVfpqdaitePVFUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mb7LIAtvkjX8ZmP3A07+BT2y8dOhQsFFmZNmCJMDfZKzvSc0o0lIFSV0gdFzO248ZUw3bnd+J0qpNlRyhVKSSTXdNmyaksReMSgwnwFSj9Z2RlRf1myvreVz+rpbJE/SBcBbpcmSdOIY+99joltL/sXgqbj4W3geS2Kat/m2164=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=PmYF6afE; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="PmYF6afE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=1nzp8IuvxdyWUD84dgWr7xE4PHMAucRQUfJUXn6B7ok=; b=PmYF6afEHAuDGpwctgmegrXNTo
	otH1WLv/DnGqG55wbX7GhdyoUQkkunvBifMktWIRR08m6/qIXnFjhy+Qdz3YAAI5KgK+2GX3yHfal
	lk7lO5Bil+1378obl6aKEw4LOn5b6Dl/tMa2ceCGAjzBIQbSgZogPF2y4tfqYWQcUCNdfVu+EyGO/
	zgB/PVcoM5yoabfp8XQ3DbOQNtXPsxyPdNwDZ4BMLSEhjyqeYkWWQiWycBwLLNI03gfaWHUGIWlfg
	egdXmv0cjOnaOqhJfo61/PBGyYHpghSFFqyM6/tfuf06o75lyK6cyZ/6QeDKsEmfHiWLdViIbwR+b
	ysjlkw9q5FfJ+GVDddRGloIheZ35N/T26BzvoLUvk8+oQSLW1Fj/HKGX4p10AuHoWS5Z9FX4NBYg2
	sU+aB8LDwHbJcelOHp9/C3KKnF9Wqb9dQzYjC0VKjKSkHytbTzGUhTgioPcR6Cfl94B/JTKpufEI4
	qVv1Zc0FNqm+J0xIj48aF5ya;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe1s-000jQ6-22;
	Mon, 25 Aug 2025 20:43:00 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 006/142] smb: smbdirect: introduce struct smbdirect_send_batch
Date: Mon, 25 Aug 2025 22:39:27 +0200
Message-ID: <9b68b1b21eef8831cac06eee3529b6ff862aecf4.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will replace struct smb_direct_send_ctx in the server
and allow us move code to the common smbdirect layer soon.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index fc52c85a32fe..ef6f330ba7d4 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -177,6 +177,23 @@ struct smbdirect_send_io {
 	u8 packet[];
 };
 
+struct smbdirect_send_batch {
+	/*
+	 * List of smbdirect_send_io messages
+	 */
+	struct list_head msg_list;
+	/*
+	 * Number of list entries
+	 */
+	size_t wr_cnt;
+
+	/*
+	 * Possible remote key invalidation state
+	 */
+	bool need_invalidate_rkey;
+	u32 remote_key;
+};
+
 struct smbdirect_recv_io {
 	struct smbdirect_socket *socket;
 	struct ib_cqe cqe;
-- 
2.43.0

