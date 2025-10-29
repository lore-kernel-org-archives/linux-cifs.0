Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9EE285C8D
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744328; cv=none; b=Ze9BNp4/NwG4N4+/UOYVITkmWewLv8EX4pXuHBA+AQNH2nCsmOzxbiTSLoQocEfOp2IhdQ/c6SE+UXNjf/uUN7/TQzG/ZMcTXvDY2KgVsRyXsYvHXNHLE3Pz49Ut0GIVFUTZsRLkUwMxxXaulJE5X/Nph4O2NuQkc7x5htYWqK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744328; c=relaxed/simple;
	bh=ENtoRXgRLog0F5PCMLoc7ReK67BP9vzvEAdQiSjQxpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmd/mn5mUvkkSxDeIdUa81Sk0jLWIKtLBVvXpYeIO7Lc2ET18us4AGiTSXZ9zAju26e36xLQuj7O0jKmDm2uzjbkV0PBJ75OhPulPJeMttripgQGZ6F4d/Fl17saOpBEE982P1ZxQ8OzEZPyrFuHgPuc7rtKoavVh1KIY7hucfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=vAkOY99o; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="vAkOY99o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=n7oSuR4/Qsa3P52qQ0Ryhuz6phjJhE/hO9NAAagfr4Q=; b=vAkOY99otPX09PVSggM++NZCl1
	HmcAhKmP0c2ktuHo02Dqc1kYdF1IKkDMkwK/16eFwHSOLef4Yfr+WbM8WhsDhXMr1ANfL3IAqV+Rt
	EfqF3IEc2gfLsfmM5sDHWcOXHrjja0CEZRMAdkDucEwDtWZE3T7Pul7AHjzweP/U2qMBYjN/71pUO
	FLnP2tqEYWfZcQZPN2RRaFzOPxQ/LTLv5135aajUQsKaw+/ETQ4nqXBhIchISWucmZNxINC6qFSca
	n8Vsx5TLgBB2uxPJeMch7d8yuZHQH/67j4Vorq5eiBXQkNcDhtHYBX0bfFv4lWi8CsxJgCCpbRF77
	WDMDjpurjXRGMlNEJTDpKJsai1P/jGI5Je4RmZ4szbz/r1WKcTHiBcjrNLT/ncACKgqZu2FH3iyJi
	WrcJanLhdYeUS0vqsgs9r6+v5TWlP7E/yoLMvMBQwwIlT53tb1ebeUZ7fRJXUrQIQHmQF8rmhWoJ/
	mwXprZ/zpnand7xBQyJ1zV2n;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Az-00BbdD-1B;
	Wed, 29 Oct 2025 13:25:21 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 029/127] smb: smbdirect: introduce smbdirect_get_buf_page_count()
Date: Wed, 29 Oct 2025 14:20:07 +0100
Message-ID: <4051ce8759eb0b014e0db5e3b409251bee87a895.1761742839.git.metze@samba.org>
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

This is a copy of get_buf_page_count() in the server
and will replace it soon.

The only difference is that we now use size_t instead
of int.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 5856ce287afa..983e08c8d2ee 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -640,4 +640,10 @@ struct smbdirect_rw_io {
 	struct scatterlist sg_list[];
 };
 
+static inline size_t smbdirect_get_buf_page_count(const void *buf, size_t size)
+{
+	return DIV_ROUND_UP((uintptr_t)buf + size, PAGE_SIZE) -
+		(uintptr_t)buf / PAGE_SIZE;
+}
+
 #endif /* __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_SOCKET_H__ */
-- 
2.43.0

