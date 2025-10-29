Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E68284B25
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744337; cv=none; b=B7As2qFhf3FxogZ8/G1Paaq8WqvVDifk+NJRigmsfL3RTAVIicKvKtWgz96auXQV+hOlXeQZ1OoeEoMWsy5ytucj4u5j2n4EXGqkfiaggMNVhNHM/2g1IFPc+UgTef6JxdYE/SeH8burIgS5AVIaNts22xOEZHYpWKBknvjhfuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744337; c=relaxed/simple;
	bh=fREmyy9HzaP7l/oo/GCmRZFVyT3B8t+xLZEFMciX8Hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXUEho06pH2baFSxTqkSI7tbFl+NaIgOr07MMIIrsDUNa77NnKXVtptegouf0hGtZAj6cerGrwGhMAz/NpX2F4TcEh5g2x4evPs9YKtt3G6Z5ieuZsdWUTkpAADX9u5Uh3jRsN1POm0b6cTRqKPZ71l779XoYr1gRluRBlcZoBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=fYjjSlbg; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="fYjjSlbg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=GOi0ORirNZxGAhcvh5mMlbPeJ4YM4Ek0oe7GsgT7n68=; b=fYjjSlbghyTdIrIB4/frm2CuoH
	WvqTMPgvWPjR1mHj+SsWbRZtgw9X8U8dH/YPTZMV/owh0d5tD+OsNZq6a0rowI0Cnlus0BYUheai/
	DOydN6BkjwSXgvAtL0PfjnJ0M0quTIMH+zOuGP32e5V7A2iw9+VxjGXhi6BAnTj2FrFwGMV+fIwt9
	V9FqKEfD8/ljjQRS6bQkB/6FRzCoa99mhG0xVccv/ulVqpexVAa+7JblJDMeJOy/YATFer5Q8uPV7
	sirnXGk/hLgBMIjDwi3pzqT1bm/STDSOCFh7OIuSUZqFP84Brscnftns+pjVZTMGiIzmkha7WAq6w
	3J99eVLb1+cUcNDQSKkq/5FiK+DwyZUDhvRF+lrSnx9bIYDyTTIghCFSRVrKCeVVsuoXmDzIqvE6s
	iVjpq71fgcaoC3A6PYoNkQAVCd38kCFxJAJ4QSFSF5sR/0e0P+7AbPnNOzqAbrYLZWniH5h6K0Wx0
	FlRlFBSN3UJ1K5meeshm72Tu;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6B6-00Bbdj-26;
	Wed, 29 Oct 2025 13:25:28 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 030/127] smb: smbdirect: introduce smbdirect_connection_wait_for_credits()
Date: Wed, 29 Oct 2025 14:20:08 +0100
Message-ID: <b67ab02598dbea9f0b19227e4937631d4096d276.1761742839.git.metze@samba.org>
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

This is a copy of wait_for_credits() in the server, which
will be replaced by this soon.

This will allow us to share more common code between client
and server soon.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 .../common/smbdirect/smbdirect_connection.c   | 27 +++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index c1281807ff8c..1b84e0789d77 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -796,6 +796,33 @@ static void smbdirect_connection_idle_timer_work(struct work_struct *work)
 	queue_work(sc->workqueue, &sc->idle.immediate_work);
 }
 
+__maybe_unused /* this is temporary while this file is included in orders */
+static int smbdirect_connection_wait_for_credits(struct smbdirect_socket *sc,
+						 wait_queue_head_t *waitq,
+						 atomic_t *total_credits,
+						 int needed)
+{
+	int ret;
+
+	if (WARN_ON_ONCE(needed < 0))
+		return -EINVAL;
+
+	do {
+		if (atomic_sub_return(needed, total_credits) >= 0)
+			return 0;
+
+		atomic_add(needed, total_credits);
+		ret = wait_event_interruptible(*waitq,
+					       atomic_read(total_credits) >= needed ||
+					       sc->status != SMBDIRECT_SOCKET_CONNECTED);
+
+		if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
+			return -ENOTCONN;
+		else if (ret < 0)
+			return ret;
+	} while (true);
+}
+
 __maybe_unused /* this is temporary while this file is included in orders */
 static void smbdirect_connection_send_io_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-- 
2.43.0

