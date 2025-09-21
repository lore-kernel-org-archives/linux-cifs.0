Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D42B1514DC
	for <linux-cifs@vger.kernel.org>; Sun, 21 Sep 2025 21:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758491193; cv=none; b=QWZvw9d9991Sn8O8cAhuXtIvitV9MtsUNCIJliwQkclu2xI9z4H5yJHk5kSyFaRQlExBPDM5tSAuV3VqT432NJEcXRYksKoIdVmS6CL45D9sOGt1dbqFJ8vmHEkD45KL+3yzWvOqLKM+TmV0HFpAVSVIqZhl3jpZ5pjhMfxeZAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758491193; c=relaxed/simple;
	bh=x++QTLEHIk1yxsHTCf/BpRumcaM9bdq49SR/z914Dy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InC47zSKO4CjiTh8HOIUmWXR1Ccvg+CiL/VQVAkdnRwYIVejTHOqI6n/2Yf+a6V4qa5vdgt584IKQQ6G55riMzVT9h2VdRsdzu6baEgNr62BuVUSQeLU6MrBPz9fYZziZZgUqETHlpFgP9L3ZG+bpyq2kj+mfA7fZBKNIDLKRLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=NYYsIURO; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="NYYsIURO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=BZw0zlfZiC+R/2KXHccTA/BR5XGESSFqlGhN7zcFztM=; b=NYYsIUROwOURmV/H2PYBwz6V1i
	+FV2WcgDd49RFQyyGhnk0eQ14zwrHlzriyZVR0eycd5B6DwfGA0becF/1hRHseWgu1x0Zqc92yN4x
	V77FyXlHyyGaWvcXH+ZIMzL2YXxl99+oJ6gkbEuQFE2sfck6VMfFfRWSyggxCCNKtJn0Zkv+2/BDS
	sWMCoqmUn6sawLEEwuXifZqpUAXQ8pZHY2EtMSqkk4kzvPsnzJs+Csz5TDyi+lf5z0LMq1m7AH471
	yUvTZJG6C2furn3y66cvjykRG6M41A0GaWjk5VlzV+8DUjeZAI+1SbNSE8Zq/uDOCNCdz4kA3Aqmy
	+jNPy4BPPZ5VsD4ojOylPe56lnw0eCukwbkolAvrypKSkjDp/lz2WJiBKDIpQ/DsqoPKBUluLy4bg
	gvCvurZdL02DXvwAdVJqSJdG77rK3YhFARxtBrHCT9CMLYnjER06bQYzw/MlQf1IxvzOmbZWXm7cE
	Cspn5yOh1053TaRW1JymgckI;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v0Rt4-005GVh-2c;
	Sun, 21 Sep 2025 21:46:27 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 08/18] smb: client: make consitent use of spin_lock_irq{save,restore}() in smbdirect.c
Date: Sun, 21 Sep 2025 23:44:55 +0200
Message-ID: <d9a5ff5a66b4e27ed2ef903965bebe313c362fe9.1758489989.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1758489988.git.metze@samba.org>
References: <cover.1758489988.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a mix of using spin_lock(), spin_lock_irq() and
spin_lock_irqsave() and it seems at least enqueue_reassembly() was wrong
in using just spin_lock() as it's called via recv_done() from a SOFTIRQ
as we're using IB_POLL_SOFTIRQ.

And Documentation/kernel-hacking/locking.rst section
"Cheat Sheet For Locking" says:

-  Otherwise (== data can be touched in an interrupt), use
   spin_lock_irqsave() and
   spin_unlock_irqrestore().

So in order to keep it simple and safe we use that version
now. It will help merging functions into common code and
have consistent locking in all cases.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 00be4afaee52..5bc316248058 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1397,7 +1397,9 @@ static void enqueue_reassembly(
 	struct smbdirect_recv_io *response,
 	int data_length)
 {
-	spin_lock(&sc->recv_io.reassembly.lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&sc->recv_io.reassembly.lock, flags);
 	list_add_tail(&response->list, &sc->recv_io.reassembly.list);
 	sc->recv_io.reassembly.queue_length++;
 	/*
@@ -1408,7 +1410,7 @@ static void enqueue_reassembly(
 	 */
 	virt_wmb();
 	sc->recv_io.reassembly.data_length += data_length;
-	spin_unlock(&sc->recv_io.reassembly.lock);
+	spin_unlock_irqrestore(&sc->recv_io.reassembly.lock, flags);
 	sc->statistics.enqueue_reassembly_queue++;
 }
 
@@ -2076,6 +2078,7 @@ int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
 	if (sc->recv_io.reassembly.data_length >= size) {
 		int queue_length;
 		int queue_removed = 0;
+		unsigned long flags;
 
 		/*
 		 * Need to make sure reassembly_data_length is read before
@@ -2135,11 +2138,11 @@ int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
 				if (queue_length)
 					list_del(&response->list);
 				else {
-					spin_lock_irq(
-						&sc->recv_io.reassembly.lock);
+					spin_lock_irqsave(
+						&sc->recv_io.reassembly.lock, flags);
 					list_del(&response->list);
-					spin_unlock_irq(
-						&sc->recv_io.reassembly.lock);
+					spin_unlock_irqrestore(
+						&sc->recv_io.reassembly.lock, flags);
 				}
 				queue_removed++;
 				sc->statistics.dequeue_reassembly_queue++;
@@ -2157,10 +2160,10 @@ int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
 				 to_read, data_read, offset);
 		}
 
-		spin_lock_irq(&sc->recv_io.reassembly.lock);
+		spin_lock_irqsave(&sc->recv_io.reassembly.lock, flags);
 		sc->recv_io.reassembly.data_length -= data_read;
 		sc->recv_io.reassembly.queue_length -= queue_removed;
-		spin_unlock_irq(&sc->recv_io.reassembly.lock);
+		spin_unlock_irqrestore(&sc->recv_io.reassembly.lock, flags);
 
 		sc->recv_io.reassembly.first_entry_offset = offset;
 		log_read(INFO, "returning to thread data_read=%d reassembly_data_length=%d first_entry_offset=%d\n",
@@ -2432,6 +2435,7 @@ static int allocate_mr_list(struct smbdirect_socket *sc)
 static struct smbdirect_mr_io *get_mr(struct smbdirect_socket *sc)
 {
 	struct smbdirect_mr_io *ret;
+	unsigned long flags;
 	int rc;
 again:
 	rc = wait_event_interruptible(sc->mr_io.ready.wait_queue,
@@ -2447,18 +2451,18 @@ static struct smbdirect_mr_io *get_mr(struct smbdirect_socket *sc)
 		return NULL;
 	}
 
-	spin_lock(&sc->mr_io.all.lock);
+	spin_lock_irqsave(&sc->mr_io.all.lock, flags);
 	list_for_each_entry(ret, &sc->mr_io.all.list, list) {
 		if (ret->state == SMBDIRECT_MR_READY) {
 			ret->state = SMBDIRECT_MR_REGISTERED;
-			spin_unlock(&sc->mr_io.all.lock);
+			spin_unlock_irqrestore(&sc->mr_io.all.lock, flags);
 			atomic_dec(&sc->mr_io.ready.count);
 			atomic_inc(&sc->mr_io.used.count);
 			return ret;
 		}
 	}
 
-	spin_unlock(&sc->mr_io.all.lock);
+	spin_unlock_irqrestore(&sc->mr_io.all.lock, flags);
 	/*
 	 * It is possible that we could fail to get MR because other processes may
 	 * try to acquire a MR at the same time. If this is the case, retry it.
-- 
2.43.0

