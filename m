Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8CF37A3CA
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744234; cv=none; b=f74dyaNnfieVyb+qG4+vm1uaSL3UUCIFLJsAhFzuaD8GFfN7xzWCiaQCnVgBq39KdkqgCGMF2GRIrNpPtlUNFW2wqF7DM6vBT1XetyIGygzTwec3crVNezjLHlEkQnZcZIffTabsa2WUtSqTZQkPkvaGhhR0L3nVbrCoHXe2HIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744234; c=relaxed/simple;
	bh=sFBYQaARUbCCkjZL1PfE/peFKx6UI87rQDJTfsUohIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wh3Kpz09SBLrEVFQ1wyNiBn7u3J3kIbAzzpQFMFI0qdVe6gKie06pmuy64Ugw0YSxmj7ztezTsHa2TNTe5L/YMZki7lqLgaXAb3ZyeSW2Xpa8T1RBmFZOYovE+LeESC+rGeaIYy7TcxslHC/BVA5Bs3Zdd7CK8x0UBnXLaSgewc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ZuT4/lQP; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ZuT4/lQP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=DhDeh0Mcfs4QsUZuxbYo1QyR9P0lhNwSXSH3p/9Ps+w=; b=ZuT4/lQPzAlpchoqeLnctrjnX6
	h/I9fWFCGsVQPl6rbRzrGQupCjT+cCT3zIFgS6l1R155OAwj8obm37LzwSHcA/0JHO6t6VrEY3HBF
	A269VGowXxMyxSL5/XgajRRE/iZRCw8QPbSZx8y5LKtuyA7vzRG2rG94sqPLyfrI3CKNfLVplZakW
	CR6W1j9reeVqJAPFJNKGihJGMbPsejr36D79345QIRh9pJjtZIEw4oeZLlveZ1+3x8egnIFz63JVH
	US7KhfcrR6+xUldirAQafXWWgNOSgdEoGq/kR592GmOt6Ngir2FCLUGvCjrm8VaWANV/wUFH9exp5
	1yLmZg71Vl6Ied9Z0i1EVoYYHnaTU+NwIK7WAo5mXooCc06TSz9mv6tvFaalC/KG77CIyOYC3f4zy
	QW8k2JrjNH1Yfv11ghM5TK+hl5EiF8xouhA1Ou/2kqTqTR+6xMYvfyJE5ZAAFiiJ2pSUCVMu8nEfl
	7vp91Td+0Q3SWFeQ1AwQ0U4c;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE69V-00BbP9-1T;
	Wed, 29 Oct 2025 13:23:49 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 013/127] smb: smbdirect: introduce smbdirect_connection_{get,put}_recv_io()
Date: Wed, 29 Oct 2025 14:19:51 +0100
Message-ID: <b4c6e7f95ff8a5c59ffc5876674372a7f2b89e7c.1761742839.git.metze@samba.org>
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

These are basically copies of {get,put}_receive_buffer() in the client
and they are very similar to {get_free,put}_recvmsg() in the server.

The only difference to {get_free,put}_recvmsg() is the
updating of the sc->statistics.*.

In addition smbdirect_connection_get_recv_io() uses
list_first_entry_or_null() in order to simplify the code.

And smbdirect_connection_put_recv_io() uses msg->socket instead
of an explicit argument.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_connection.c   | 41 +++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index f96355043e16..dc0a5cea67bf 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -69,6 +69,47 @@ static void smbdirect_connection_wake_up_all(struct smbdirect_socket *sc)
 	wake_up_all(&sc->mr_io.cleanup.wait_queue);
 }
 
+__maybe_unused /* this is temporary while this file is included in orders */
+static struct smbdirect_recv_io *smbdirect_connection_get_recv_io(struct smbdirect_socket *sc)
+{
+	struct smbdirect_recv_io *msg = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sc->recv_io.free.lock, flags);
+	msg = list_first_entry_or_null(&sc->recv_io.free.list,
+				       struct smbdirect_recv_io,
+				       list);
+	if (likely(msg)) {
+		list_del(&msg->list);
+		sc->statistics.get_receive_buffer++;
+	}
+	spin_unlock_irqrestore(&sc->recv_io.free.lock, flags);
+
+	return msg;
+}
+
+__maybe_unused /* this is temporary while this file is included in orders */
+static void smbdirect_connection_put_recv_io(struct smbdirect_recv_io *msg)
+{
+	struct smbdirect_socket *sc = msg->socket;
+	unsigned long flags;
+
+	if (likely(msg->sge.length != 0)) {
+		ib_dma_unmap_single(sc->ib.dev,
+				    msg->sge.addr,
+				    msg->sge.length,
+				    DMA_FROM_DEVICE);
+		msg->sge.length = 0;
+	}
+
+	spin_lock_irqsave(&sc->recv_io.free.lock, flags);
+	list_add_tail(&msg->list, &sc->recv_io.free.list);
+	sc->statistics.put_receive_buffer++;
+	spin_unlock_irqrestore(&sc->recv_io.free.lock, flags);
+
+	queue_work(sc->workqueue, &sc->recv_io.posted.refill_work);
+}
+
 __maybe_unused /* this is temporary while this file is included in orders */
 static void smbdirect_connection_schedule_disconnect(struct smbdirect_socket *sc,
 						     int error)
-- 
2.43.0

