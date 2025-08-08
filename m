Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDA1283FE4
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 15:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754666954; cv=none; b=CcVOMV9VWnkgGlv6i+HDACDUGqJcbY0GwTvKHnegy1CegAVDr/JIHXvTP6UgvpQJU9YKPh9gEYQuVe3kYPo92fD62R2SRotGP7UmrZTX4IJcgXTrfDFwSCzABhazdr7/CFBMoHVH4gA6mjR3VTZUh6Yxr1IT5Ez57Chw/E7NCAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754666954; c=relaxed/simple;
	bh=ql0nxxrWjlb/xU6qbkV32Zob4vxeeHokdzVDYAioBnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKA2Nv+1MbRLMM3ea89inySgCv1VOelOB8SQBwbpclK61Gxfc+tG+fQ83U6w/rc+mXdqRjvEDdp0/vjVdeRxPqEzfD/KAu3ABA9k93MMwYXevy3sPAFAwtxD4+8LGdDX+/HebSfpRP+4tlNne0kCM1+ZyG0eqdzlD9AlvqcQMMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=JGK8aRfc; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="JGK8aRfc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=F3hwMFbPa1YtwtrilJjOweE62A0mW4eEN+pLyw+biTU=; b=JGK8aRfc/0mntGUDXeTJwd3cV9
	jExWDM++Wq03qeoHScG8Wi1EjBh+UnHMQAGhSwQ32Jd+X24Px9XFcGN73zquZML5nGLmJdJkcoXIl
	4BGJaRpwtQdlarHOmN49VNTvza9QOwqVaLbNe6cm1sYteAmruWcwr427gKVVX+SxUGTTLRzpYnymf
	IAb4Bv6E/+lErSCSAp3lmEeJkpbxHbE016Xsxrsg8o3iq8Fn9IBMosM7VPnI2H3Xt7A7yqBeLqnhK
	FaSAT03bAlH8Wc4i7N5W7Ak3cB2p+nbBsevMMLwq1ne8s2CzqdZLdokDZrqplgADPrYgQZRKCezbG
	Y7xRyYP/qVr2zvls+LTBjiWnnavGogBFatYgA1i198AttghmJBrRzhaq3apy9sn0Mrh1qowN9GvdS
	XxTzYo10vJkPzfGjCHGsQjtGqKtCtkYz06DL8ki/ZMySQBLW1eXaTgeMeDETCPQLjnfRZhBcQfWB0
	IzXooALLsmyr+NvXh2kRuXBz;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ukP1p-001pVS-19;
	Fri, 08 Aug 2025 15:29:09 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 8/9] smb: smbdirect: introduce smbdirect_socket.status_wait
Date: Fri,  8 Aug 2025 17:28:06 +0200
Message-ID: <5eeb36d56d96b9cadc746ff858c3303138e5f7a3.1754666549.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754666549.git.metze@samba.org>
References: <cover.1754666549.git.metze@samba.org>
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
Signed-off-by: Steve French <stfrench@microsoft.com>
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

