Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A266D266EFC
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744240; cv=none; b=E0UjcIQ/DemM84i9dGqjTPsCh/hG3FIsoCnmg6nzCczPCG2XyNLwv7UEUiEu50NpdAa0c73n+XNhFS6jtVvJ5RZpHosdJGcLshPO6QOCmDpoM5gVnbmVcRX8CoNt+fVxz2JgGUctm+0ZhCOkx//d8M+HOGyGXkZtHdSYA5u/1f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744240; c=relaxed/simple;
	bh=sUHj+XUaqFrmOyqbEiOgIMmnwBvNafWrspyLUQtNOYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDYlXAF9Km6IY1nvhYri2s/SQOUGwmzEhySfOVh2KChYBd8jTnPb+OoUoadDOmBGgKa/yVGBR9eu/5jjghKuyvoRRgGYXHZVCLHRaHj8bU5uq++0UJZY4FuSHa9DlgUWk5kEune9++FCgOIz0xah4xR9YytVm5WBsgT2fPir6Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=xNEe14Xq; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="xNEe14Xq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=xO+zQdTr4nLoA6zxZmNOT1NDY6BXo5SP8zluU2kTL5s=; b=xNEe14XqYTAJogSypLQtS+UE5q
	P6UiLm3hwSHJG2n1xVp91UvndAPCLcicfxtmPc3723a/rD08mnT/fYRaHPncA35o7hFemdFvmyCfi
	JMFsipD0jQpCjxCeRgMmLMpkQDIByUuCUn8xxMkkffMtw5ynfQAwCi9BGgihU4Jq3vG+Vyc/0yb7l
	sGl7SxMyWmX0a67Rt6hMGgLwjOv8sTGqzJIjavMwToNUaeGfXmHH2s+5Ae9ovSLaL0CaFJLCGtMGg
	lDWt8pxi0qcJ4c5LROCInlyX/aERkslqlfz5rLbs9SVQSpdKraXrpg378QIY0HclZUK0V53Npw0bG
	5vb2r/7D5/nBV7hHb3gXxRkftkMzbvxJwxHpAgaGEQ5nP42eM76OF/C+P2Ay3rXDtlWQ1ZbDqONvI
	iNu2EZNOMS1a2xEanunwkRJtKgKXSIYd7wQauoX8/gvb6dNfGo4uDcqJtlE0yAH2vDYlUL9oTdXkr
	TdvAWAZmhzDoOf5BUekO1oPs;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE69b-00BbQ7-0M;
	Wed, 29 Oct 2025 13:23:55 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 014/127] smb: smbdirect: introduce smbdirect_connection_reassembly_{append,first}_recv_io()
Date: Wed, 29 Oct 2025 14:19:52 +0100
Message-ID: <0c4c928d9616ffb4bbb81ff5e03ae4dd7e99cf79.1761742839.git.metze@samba.org>
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
 .../common/smbdirect/smbdirect_connection.c   | 35 +++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index dc0a5cea67bf..27f8545ee30d 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -110,6 +110,41 @@ static void smbdirect_connection_put_recv_io(struct smbdirect_recv_io *msg)
 	queue_work(sc->workqueue, &sc->recv_io.posted.refill_work);
 }
 
+__maybe_unused /* this is temporary while this file is included in orders */
+static void smbdirect_connection_reassembly_append_recv_io(struct smbdirect_socket *sc,
+							   struct smbdirect_recv_io *msg,
+							   u32 data_length)
+{
+	unsigned long flags;
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
+__maybe_unused /* this is temporary while this file is included in orders */
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
+
 __maybe_unused /* this is temporary while this file is included in orders */
 static void smbdirect_connection_schedule_disconnect(struct smbdirect_socket *sc,
 						     int error)
-- 
2.43.0

