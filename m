Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFFB29ACE5
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 17:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754501808; cv=none; b=B+6bPfQwWZSOjguKBPVG6c1Ryc6X7vkiuYRNIcm50+Uh3+Dk/Qkn0otH15JfFbkfAl63vFgHqtSNvho2EyleZcDiutsO6kOZLuiUn0FGWAzhGnQFbclmdLwuBZZKfGhFNAduN7Au/YN/iRyMPdg4GbjYs2fN0A0ObUsqjLY5jRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754501808; c=relaxed/simple;
	bh=iiB0mFYukbJTIrb+PujDUH4JPDW5M4Xf057e2ryjjG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WtE3RPwnGEgZu0iUMs6b6YPRauhDg2md9Mu28os8hceHK84XWjl40TTkEUl2Teeip52jWlNm8CiDBg6qhRU+nEMUIe0ty/ml/7lNA0BlFs0wQT1M7b9rSWG9s+U81QhyaHFOi6AJfLXwiyOdTJPiNN/M8p3XkwTJeHt79a87+mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=tbSLI9ws; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="tbSLI9ws"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=cHs80A+tD1eg48eVJnbXyaLlyjH7aumFBVukj9mBQo4=; b=tbSLI9wsngPBDWvi3rF723iltS
	K6XNhN3CYgNelS2yLnZ5oh1sSBOflsynOF6wjgov8JiWtwYGE/Ezs9ZQKDy24Wzd6LY63Smg3CntJ
	c+5TOgOpCv7Oz9EVM69b9nuwxf4mYWdXdXbGrXvGzATcXraw714lw5H7NOqfbtL4hK3krqJJXQ4sC
	Luo1sXvi660tGFXP8tP6HDfL6DUx49raS0oimYok2A5071YkZk3umzZfUzmDL2GRF6meKHS5zKLCb
	5tPE10x/uiWJEydjgldys1UpdYMqkxilN/AMUg6l/E6LqbPZ5qqolmJXEiIp4aKE4gtJgNepQ7Pwv
	VMvBqoG3CffaFTmYefEuxYXEUa0Tk/j6lqVS4iRngAFHYIm7VwT3G/L9Wrjd0RZhjq8k9aQPimHLj
	7W0WNeE8wVv0qvI6F0/f8+rWDvRb5Jjko5fQaUH6O3UE9N31nF5hBtQ+dTE1CEJGgo/mmsiWGwZk2
	fgz1vgT9Et1DxtvVa5zOF5Mv;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uji4B-001OXg-1R;
	Wed, 06 Aug 2025 17:36:43 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 04/18] smb: smbdirect: introduce struct smbdirect_send_io
Date: Wed,  6 Aug 2025 19:35:50 +0200
Message-ID: <935fd25b08f70fb63026fff444e14a5a415053d1.1754501401.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754501401.git.metze@samba.org>
References: <cover.1754501401.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will be used in client and server soon
in order to replace smbd_request/smb_direct_sendmsg.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 24 ++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 7270fcee1048..4660c05c358f 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -89,6 +89,30 @@ struct smbdirect_socket {
 	} recv_io;
 };
 
+struct smbdirect_send_io {
+	struct smbdirect_socket *socket;
+	struct ib_cqe cqe;
+
+	/*
+	 * The SGE entries for this work request
+	 *
+	 * The first points to the packet header
+	 */
+#define SMBDIRECT_SEND_IO_MAX_SGE 6
+	size_t num_sge;
+	struct ib_sge sge[SMBDIRECT_SEND_IO_MAX_SGE];
+
+	/*
+	 * Link to the list of sibling smbdirect_send_io
+	 * messages.
+	 */
+	struct list_head sibling_list;
+	struct ib_send_wr wr;
+
+	/* SMBD packet header follows this structure */
+	u8 packet[];
+};
+
 struct smbdirect_recv_io {
 	struct smbdirect_socket *socket;
 	struct ib_cqe cqe;
-- 
2.43.0

