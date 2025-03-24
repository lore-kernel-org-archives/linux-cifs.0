Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077B91DF975;
	Mon, 24 Mar 2025 06:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742799321; cv=none; b=HbQPBppFW5wDjj2/pNeQqTU9h+yK4Tua1mmR+K4uLXhbkej0w0AZ5KW+K5VRQP3FYkz0AjOg6FFFSyzrIe9x8/YV5guoFfBvW8ijuAVPfTbM2rL9wlB/BIF2lerT9kT5iykEqZsjf+M9h9teC7gAtnUpJmLsorQVNFZfhy2Oowo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742799321; c=relaxed/simple;
	bh=g9XGUuTEQFnJGpulXykQgmwGsLbFGLfWBifqYbVibuQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SfeLV2okrFuF7xl/E9jy1I8TLF5hDdSoEZod56UxBEf5FHC5wZaM7E02cMFfJ+QCZDU91h+50ndvBE7R88sv9uIDaO5YZKoW5gqITtvySTUynKZDa0gm5a4Ugx7dSYSxqfvCRptfu+zxGURhSca77V1msO6k9vUkvoPas7B1H+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
X-QQ-mid: bizesmtpsz1t1742799160t5xj3ii
X-QQ-Originating-IP: yHc2gHKafPJZLdKpG5LwwzyIMgkn1nGVmLlOMufgh1M=
Received: from localhost.localdomain ( [116.128.244.171])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 24 Mar 2025 14:52:38 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 2187205931425290801
From: chenxiaosong@chenxiaosong.com
To: linkinjeon@kernel.org,
	sfrench@samba.org,
	senozhatsky@chromium.org,
	tom@talpey.com
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH] smb/server: use sock_create_kern() in create_socket()
Date: Mon, 24 Mar 2025 06:51:55 +0000
Message-Id: <20250324065155.665290-1-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpsz:chenxiaosong.com:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: Mx19VWqBs5mwul16bCqV705JsmB8YINSbxTSRXfHTAvXuyrEAQUJeHNp
	N4z21FFbrAnJQYeJ9xQaJ6l6eGLKVqHs3P39uR3bP8eUpUxPebEQz6Hz+rC+kS/cNsw0POH
	uR7obC99nIwAr64YbvNEUP9Wf54GHNLKGpDYg0HrBwonZa3KVHw/z+09j6EMm2n4kSfSi1h
	k1ttfDAq7nDWG940afXY9OPFzidnc1123+QfuquHXdtA73jIt4nrlYgVGw6C8LpInv5Ele5
	NMTF08AqKzJDKlMQj7xgyVnarmbHpE3zqIcjpb5+ohc408Dwdc7PnqzZskzx7sjMas7TYzb
	P7x33cg6w+ujVDpIaaydbc4U0BVQt0K8d2AL55JWLLrTxdkavo5vjVtCGPRns2aUj7ykw5k
	fSo4UXOppwyKV3aVpdS/zZJnDD5dtLZf6Vzx5w+8+h32PpHkWTN2osPCz4Jw6sQSb+VRxeZ
	gFhrfDNi9i6b8RXoQzGyihQxJmgQgYB8vL81HaYPUhPxpTTNASsKE4SWOdmZd34kDOqFKE8
	LuV2IjNZp9RHoz2s/nHDZLXQOOV2BkGaQ1SLfYRvTiWYfYZcbG/u2utpr4htIvJlzdL15Tk
	IyLgopNF67OSgdLIMnJQ3JnYTD7PSML9xnXUOzVkehp/4ZXscgVjjlekbVOJ61o4gCpfxR/
	RQOqKuC+mTOlHYrYjmsgjl7//JKgdm3FvGJtFxBiYQNvXUaP1RbRzWirP9o5vYtdCXzdFoE
	o7RRJa75Eyn4rGKj430cdsuRtP9zL2hLa/ZlzAKsz3jj4dOzFrSsFan3pxSBYgdpt526u08
	KKlPa6Ptxo2WwNdVe/cMFPkSuShAgLXwhnfxK5lCyHhpQup/jGyN3tZJ5t5aDuXqOJ7tqt1
	ypLWbfv8JYfEVU6g+ZTvIYlWzZR4gvquuEtOZlg4OtATAMnIyzINTc/XCnlb7/YXr0TSKnb
	MFU10BKEqTB4e2UYjaKsX2+PgCchVgoStyqx7ImUFioB6ycPtMU4QovY2
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
X-QQ-RECHKSPAM: 0

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

The socket resides in kernel space, so use sock_create_kern()
instead of sock_create().

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/transport_tcp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 7f38a3c3f5bd..e5f46a91c3fc 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -429,12 +429,13 @@ static int create_socket(struct interface *iface)
 	struct socket *ksmbd_socket;
 	bool ipv4 = false;
 
-	ret = sock_create(PF_INET6, SOCK_STREAM, IPPROTO_TCP, &ksmbd_socket);
+	ret = sock_create_kern(current->nsproxy->net_ns, PF_INET6, SOCK_STREAM,
+			       IPPROTO_TCP, &ksmbd_socket);
 	if (ret) {
 		if (ret != -EAFNOSUPPORT)
 			pr_err("Can't create socket for ipv6, fallback to ipv4: %d\n", ret);
-		ret = sock_create(PF_INET, SOCK_STREAM, IPPROTO_TCP,
-				  &ksmbd_socket);
+		ret = sock_create_kern(current->nsproxy->net_ns, PF_INET,
+				       SOCK_STREAM, IPPROTO_TCP, &ksmbd_socket);
 		if (ret) {
 			pr_err("Can't create socket for ipv4: %d\n", ret);
 			goto out_clear;
-- 
2.34.1

