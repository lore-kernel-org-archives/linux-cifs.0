Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D02DDAB
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154969; cv=none; b=YOl4L/YvyN8evXnSNBwBnJj/xUphDSG/6NcUrCjMc1HhboYSxt4Vgz7h8Y+HZDhi0uloyY01NdXZ+eQup8uKrzUIX+WxXivuczCtLwdpPyBhots07R9TUK2BPpJ5f/KHSF0IeB43k08mmJHAB/otob1dfX0h4T2ErwOKbdEonB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154969; c=relaxed/simple;
	bh=FEw+t/QapUfahW9aUPm6HcLYYjKzUS3XpBLGHpOoCJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EtEZoTMHR1ehF3y/dtfAkhqreTCOrOAvPt+RpTFh2lqDxRJ2LKikkCTnGhfs4lRtkke+XupFwnR1TxKnfax3vlrur56hpKSRo+ngJUf/504CDFqF+VXrls9OUqxoEbKfOCrYhajY2K1lx55lv4OVuYwdKjctNGTdRFd0IxuUVRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=usQNeFhF; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="usQNeFhF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=D8nc4lXuqpXC3lzs1+L2B89YRfeb/dLlP0fwmi/G7Wg=; b=usQNeFhFK/IZgFqW+Dzt2HgwVR
	6ZCkYm0ZI6Ufb1PlPTirtnV/KvnyH1FCHNPxZarVwi3Ttm9v/09IpgARfGRNRDMB/pKED1JE7qIoH
	BqgB4/0vQgrmzOHpRtCmmW5TR97udVlBqDOR8Xd9TKNMqBWlymK1lSzFw2sfhRAXjjAPzHmVfvaEE
	LUgtqwPnVVDVLOn8LXBDUshIBl9M9Ju/j+vzsW20uw7zFphZXlIh7EHB35B3i0bPPZ4jdSHHnjAX3
	BDimYS0ZtgbD2AEKkEgFbq/wbkBV5/RetfE80pCUkxHHIgkIt4E0eXZYPZAr7J8jzUWmAfVwYboAa
	0H3tSi6osqnuWArk7p7l6IHlVNkfN393yrz1pWzUCj6WUvZ3hKkLKYJc2M3VPKolPBWjVf/8iCWxq
	HcqPlLnq/oWmkCNVndKUyqEOV9Y3KIk+cgW1+RIqotWLCvzoehEo/9GSghYcBxYpHbj0gzqODKYDJ
	jRS1dFiGjmslq7CmUfWt+CCG;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe85-000kk7-02;
	Mon, 25 Aug 2025 20:49:25 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 046/142] smb: client: remove unused smbd_connection.count_reassembly_queue
Date: Mon, 25 Aug 2025 22:40:07 +0200
Message-ID: <92709bbdcf5c1a105812b60ebd7aefe4d6720759.1756139607.git.metze@samba.org>
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

This basically represents the same information as
sc->recv_io.reassembly.queue_length.

The only thing that's different is that
smbd_connection.count_reassembly_queue was updated in each
loop step, while sc->recv_io.reassembly.queue_length is only
updated once after the loop in smbd_recv.
Also sc->recv_io.reassembly.queue_length is updated under
a spinlock.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/cifs_debug.c | 3 +--
 fs/smb/client/smbdirect.c  | 2 --
 fs/smb/client/smbdirect.h  | 1 -
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 8f1ad9cb6208..35c90d494cd9 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -465,12 +465,11 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 			server->smbd_conn->count_get_receive_buffer,
 			server->smbd_conn->count_put_receive_buffer,
 			server->smbd_conn->count_send_empty);
-		seq_printf(m, "\nRead Queue count_reassembly_queue: %x "
+		seq_printf(m, "\nRead Queue "
 			"count_enqueue_reassembly_queue: %x "
 			"count_dequeue_reassembly_queue: %x "
 			"reassembly_data_length: %x "
 			"reassembly_queue_length: %x",
-			server->smbd_conn->count_reassembly_queue,
 			server->smbd_conn->count_enqueue_reassembly_queue,
 			server->smbd_conn->count_dequeue_reassembly_queue,
 			sc->recv_io.reassembly.data_length,
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 68450489c5d1..a597b0bbd521 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1307,7 +1307,6 @@ static void enqueue_reassembly(
 	virt_wmb();
 	sc->recv_io.reassembly.data_length += data_length;
 	spin_unlock(&sc->recv_io.reassembly.lock);
-	info->count_reassembly_queue++;
 	info->count_enqueue_reassembly_queue++;
 }
 
@@ -2035,7 +2034,6 @@ int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
 						&sc->recv_io.reassembly.lock);
 				}
 				queue_removed++;
-				info->count_reassembly_queue--;
 				info->count_dequeue_reassembly_queue++;
 				put_receive_buffer(info, response);
 				offset = 0;
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 3963fd27d8b6..bc72634f5433 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -69,7 +69,6 @@ struct smbd_connection {
 	/* for debug purposes */
 	unsigned int count_get_receive_buffer;
 	unsigned int count_put_receive_buffer;
-	unsigned int count_reassembly_queue;
 	unsigned int count_enqueue_reassembly_queue;
 	unsigned int count_dequeue_reassembly_queue;
 	unsigned int count_send_empty;
-- 
2.43.0

