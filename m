Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD0132ABFB
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093507; cv=none; b=WqLOKdaHuzKXFWCPgKg7VVa4QM71j35YEXSPeYOXGmhq9sGUgGEjRsMite74rXBmJQU6TDIWDFTpSIwcqBFFEjPbYHFv88g4NZOjeLwm96A/Oa3cJPmlymd3qhWMAA79+SW/e8ERFDI7wdqbX4vosBWPlHuYcuynVEJcpYn1AT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093507; c=relaxed/simple;
	bh=eOypgZUMzzrk5LCrWcsV0GIy0O52mvCDFfUBBUPpoxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2qLQ/wy3PkAoBhHNOiQ6EtghtJxCBqtdfhAmvH6uQ4nzQVXAFSuaPR8y/TlsdtNMAwQDZDvGOImh6hlQrLOYWS5VRzWS5FiygSZvbvpmTddk8wIMN8uXJyGwPwUoBmiqPUXHgymgCZk9ejJkd+PKlO3nvfGWenqDJzVlWFrfeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=DDkhHIGx; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="DDkhHIGx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=q8WoHaLN4EH2gjfj87NxF4/nUgHoRACqI6jB3cgK+9Y=; b=DDkhHIGx2um3/n55o/AZ2e9xBy
	otALGoAhE050cb/rIVz1uiADfIWzyhzpVQh9kCYBIrYmLxM/X7UbT/0UgK20gcXGPaWr5UT8Nz8/7
	t7TpL0b5fpuJFT+nPdAW/lg4bi8BEZwRNMf148I1MRh1QsSascHqWFiHfAyajLcmULIt8CyhhPWa+
	TtHOcfJ35kYMnU0vXjNCCwAWlsGAJyX/CT2cxjbINToiTEw84dNJ5WqgnskmNV7/o8J6SyebPGVIJ
	ddtWRPPs/hmtIPuW1c7MmKUb9t7ysUBrMcY2lhoTuREBr3KMnFUcALLIxh+qCynkmzNlkgjSUvd6c
	Lm/mlQYJXxdMzbkz6OrgO0Xdaph10II1etENSKYM6xJc1XmHFGdDq9LNfhX+3STMArPKJSxuG2h59
	A0s1JuyVMaPiqprOywLGeaGqM0D2qXM+FgfmtFSaO/WwxTPaJOfmu9O5akYGwA4C7arEiRmq1MLr1
	OBIikNRiRdJsVyP4lRv2oeg3;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxJ0-00Fckb-17;
	Tue, 25 Nov 2025 17:58:22 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 017/145] smb: smbdirect: introduce smbdirect_connection_reassembly_{append,first}_recv_io()
Date: Tue, 25 Nov 2025 18:54:23 +0100
Message-ID: <4aaf7160bc5d97d6dce6e62b8a5a5e50a4bce65b.1764091285.git.metze@samba.org>
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

These are basically copies of enqueue_reassembly() and
[_]get_first_reassembly() of both client and server. The only difference
is that enqueue_reassembly() of the server does not have:
sc->statistics.enqueue_reassembly_queue++

Also smbdirect_connection_reassembly_first_recv_io() makes use of
list_first_entry_or_null() in order to simplify the code.

In the next commits they will replace the existing functions.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_connection.c   | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index db807fb9e3db..aa554527f993 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -52,3 +52,43 @@ static void smbdirect_connection_put_recv_io(struct smbdirect_recv_io *msg)
 
 	queue_work(sc->workqueue, &sc->recv_io.posted.refill_work);
 }
+
+__maybe_unused /* this is temporary while this file is included in others */
+static void smbdirect_connection_reassembly_append_recv_io(struct smbdirect_socket *sc,
+							   struct smbdirect_recv_io *msg,
+							   u32 data_length)
+{
+	unsigned long flags;
+
+	/*
+	 * The work should already/still be disabled
+	 */
+	disable_work(&msg->complex_work);
+
+	spin_lock_irqsave(&sc->recv_io.reassembly.lock, flags);
+	list_add_tail(&msg->list, &sc->recv_io.reassembly.list);
+	sc->recv_io.reassembly.queue_length++;
+	/*
+	 * Make sure reassembly_data_length is updated after list and
+	 * reassembly_queue_length are updated. On the dequeue side
+	 * reassembly_data_length is checked without a lock to determine
+	 * if reassembly_queue_length and list is up to date
+	 */
+	virt_wmb();
+	sc->recv_io.reassembly.data_length += data_length;
+	spin_unlock_irqrestore(&sc->recv_io.reassembly.lock, flags);
+	sc->statistics.enqueue_reassembly_queue++;
+}
+
+__maybe_unused /* this is temporary while this file is included in others */
+static struct smbdirect_recv_io *
+smbdirect_connection_reassembly_first_recv_io(struct smbdirect_socket *sc)
+{
+	struct smbdirect_recv_io *msg;
+
+	msg = list_first_entry_or_null(&sc->recv_io.reassembly.list,
+				       struct smbdirect_recv_io,
+				       list);
+
+	return msg;
+}
-- 
2.43.0

