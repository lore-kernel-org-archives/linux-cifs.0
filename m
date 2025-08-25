Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D38288510
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155609; cv=none; b=H6SxM8o/RpbUO+o+ENlri1tJsrDhmO2H4nAEtlB/0+llwCH+CHyabYpADYcTsJXZqyg6oEhSEq8o6zCbYDCFkmZn5clTwVaB/AD8cRuMvGY/WV+BO9DWEEz5QnKeXxCjR7pusIKicrwu8jZTmsk0Bdujg/Qj/a8dFIkRGwgrBFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155609; c=relaxed/simple;
	bh=5J7I01j1td0HrzF+pgjkxsXXYeazYsH/eoko9aJRrIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hF9crGNI88N9SS8Lj0InvVJcIfzDGw3BJlc0VOzYWO6w7MTYMUbPE3l2kn62+iQUg1C4JInlNfvBsd1LggjXZ7O4zZuTSAiSbQBbmlsu/xQRfv4m/Bi88c0EWqDC2bQYijP0hlDXcALv/uRcVOpkzJPVarW7E6sZJVHFjGkGdKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=HJiSHGlq; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="HJiSHGlq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=CF7X9Xpms/Oi8CEudNpU5B3be0ADA/GuqLqE9myqClI=; b=HJiSHGlqMDKJTOqI5Sj/qxpTnD
	+dpd0ncNNxW6O2hwj9exl/RfzPnc+AclfvI4/doScOVVEGQt52WL9lN+T8cnVnjrO/NeSx56QrC8f
	nBnx9RZgTHMsZKycneQr/6u2jCeAWqU/b39Z3u2d9loaE5rM9S7QWoBelKfwomrQyick/4yTtXK7u
	G1F0mBbcJThukK2T3UxJatSP5xcVWo8hNUuNQWKvJ1QiJ71zB+Giwgz+T4hgw9NR+00K51tOA3MG1
	87AIPAogdgvLkxu0BGmQHclZcb3f5PVgR8r1NLNC0flzi9VUyjcB1cHQsc+mmOq4vhYjr1wpEwgRt
	4OOZwDAwl4F1k9wj22K3928jNwuLvd9de7aZm5nUiodNGWlxG5QYn2ywZ+2UASHDM8+oXBAheM0cA
	sOed8FWq7TTWONI8fZy63nRfwGtuYjsLq2oS1T2iaHrsnu3DRyPnIpay9jf4+mN+fnXFCrbbJLt7P
	8+DkXS6+M3fXc+LoAInypVc3;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeIO-000msH-2T;
	Mon, 25 Aug 2025 21:00:04 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 110/142] smb: server: make use of smbdirect_socket_parameters.negotiate_timeout_msec and change to 5s
Date: Mon, 25 Aug 2025 22:41:11 +0200
Message-ID: <67713bfe52a3240c771ccc8b4dc8075ba5b3dd3a.1756139607.git.metze@samba.org>
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

The server negotiations timer is just 5 seconds in Windows, so use the
same. See [MS-SMBD] 3.1.7.2 Connection Arrival.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index dfafb4f2218e..9bc8431821b6 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -33,8 +33,8 @@
 
 #define SMB_DIRECT_VERSION_LE		cpu_to_le16(SMBDIRECT_V1)
 
-/* SMB_DIRECT negotiation timeout in seconds */
-#define SMB_DIRECT_NEGOTIATE_TIMEOUT		120
+/* SMB_DIRECT negotiation timeout (for the server) in seconds */
+#define SMB_DIRECT_NEGOTIATE_TIMEOUT		5
 
 /*
  * Default maximum number of RDMA read/write outstanding on this connection
@@ -299,6 +299,7 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 
 	INIT_WORK(&sc->disconnect_work, smb_direct_disconnect_rdma_work);
 
+	sp->negotiate_timeout_msec = SMB_DIRECT_NEGOTIATE_TIMEOUT * 1000;
 	sp->recv_credit_max = smb_direct_receive_credit_max;
 	sp->send_credit_target = smb_direct_send_credit_target;
 	sp->max_send_size = smb_direct_max_send_size;
@@ -1954,7 +1955,7 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 					sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED &&
 					sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING &&
 					sc->status != SMBDIRECT_SOCKET_NEGOTIATE_NEEDED,
-					SMB_DIRECT_NEGOTIATE_TIMEOUT * HZ);
+					msecs_to_jiffies(sp->negotiate_timeout_msec));
 	if (ret <= 0 || sc->status != SMBDIRECT_SOCKET_NEGOTIATE_RUNNING)
 		return ret < 0 ? ret : -ETIMEDOUT;
 
-- 
2.43.0

