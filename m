Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647F7291C1F
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154555; cv=none; b=pIeKZVqiFjKSg2OUDNg/s5SB42KNgpsbgjI+QLSf4LWCGd/ipSGsaHdwS8SF5VO6x3mha7c6mDh3YIKOQJ7hGDMsA6ZjuVZZB73ad5Z0b8/HdoYdBXAUD2K9gk6+3/qVVVod+Jk20Eoi+Pooz1b5I2r5CKO9ndQmZaJg7xhI/6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154555; c=relaxed/simple;
	bh=tPtRwB2nmvoujkm1V3cHNEKhQ1d9S3zRRZX5ma7VPYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+Y/Cx2/ocNoTZZaQ8HlyVrb0nrraC1MLYs57PM+abF4OCpi/V6ND+0xUGIBZFQa1dPUJRoUKi0ytpFRqBqpzFayjqaXCHvIe9WNmDbSUtkcpmVOirec6jM+V78u+KDT+85PVeh2hq6st2QQX0SsiUJugj1i2MQalVXgUs0bYQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=bsLKnds9; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="bsLKnds9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=rbD3qqKFpVGj4OvRRovKjGAmNbVTuNF62y5SdbCMCV0=; b=bsLKnds9MOaNrG8OpO32GK/8eR
	fybQuOfrix6mK87D6o0DJqDCox7i+GHaAVooRrrubiqZXdUz7sxSSsulgbE8L7mr0+z2cwEDokdjD
	y3PQKiCtAHE/9VKz28G0suV2odfNH2H0SUlfyG79cIa0k+imzReKhI4feEM9UDnaaTGKHrH9weRe4
	SdjFZJLgLD/Ao9oVWVOJkD+9F9Nv28WcFJHBLThw3zWrfd7M6RG/lY+NKlZOueewQ48r9/O/7yaEN
	JqIifuG0mr3MhWPOXyDMLjNGiGffqKj5CLEJPeypeKNBdS2lx1orhmZXK/vszo/Bn/d6+VbEVWQTI
	Lz8/PIiN0msgDw2jrwDKkzi04gBXTYa3sC/OvGzsWM1N3oWapDwX8OI5tCuzbdEBzZH1ZMhnlNp18
	ac8WWjc2eGuvEbvEe1HSNpOs35NkziB3XUlDKg2dR8TA72Sl5gPJIgUJgTXhOAtFDLIa+cXWrNgM/
	AyJT2uMdyxADBaWbpXVJtZo3;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe1O-000jJY-36;
	Mon, 25 Aug 2025 20:42:31 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 003/142] smb: smbdirect: introduce smbdirect_socket.disconnect_work
Date: Mon, 25 Aug 2025 22:39:24 +0200
Message-ID: <12d40c225a8fa43705ebca7786faa25d341c5fbd.1756139607.git.metze@samba.org>
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

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 5c94e668b8ae..79eb99ba984e 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -20,6 +20,8 @@ struct smbdirect_socket {
 	enum smbdirect_socket_status status;
 	wait_queue_head_t status_wait;
 
+	struct work_struct disconnect_work;
+
 	/* RDMA related */
 	struct {
 		struct rdma_cm_id *cm_id;
-- 
2.43.0

