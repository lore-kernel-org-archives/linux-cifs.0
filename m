Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B072533031A
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764095575; cv=none; b=Llkj5tbupjsisO7Jtg3uF0rg+NXgoSZ7GFviAvpzVamCBvL3HH608F5vyuj0QSM5qRqyPkbnjDyXR3TD0Mc9x9aEvljQEy74/FE6XIPMxatDXzEHPicX4DCTiTERhZTIni4Yqo1h9bjskV3xk8yR2v4PLc1v1sJ94M2cILjjHmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764095575; c=relaxed/simple;
	bh=qcyz1ThY74HSxtPnNPW57dyq3EWRJIp1bwF9FNIRhXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDPj9TsAuDmrZXYGwLnV2ORI+uCtn7D0yrSt1YyG04JSYBFvpSWiGrz82Rfx1wprAfcvOHxHAsu6MIg1l8mgQkWw8qy5GE4Rmc7qc2fVLqXJWRwHiU28+q3nxhm20JFEVil/aOD+DxoZ48l1dK5XYLsDi0QlKr6sc/TcXubP9gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=iZfyGD7S; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="iZfyGD7S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=dQJBEmgmuemS9LmpoA469mMdeNYWXFPBocfz2ukCDWM=; b=iZfyGD7S60wFZ0DYysnn/zVZ/y
	9UMq6gClOWlTcZRtO3KZQ1h8JLcck32IfNBWWKYFPKAYjjB/exz+dvBNgNTnpXKiwY77IovHbtlve
	5fwjk+lNf6nhKpkZntir39abjfd4lxFo/yP2KLkG4b1pT/20sNvny3pFATISau11I1ij5M8T+uQ1E
	JBaZynr7ilyHYuWxNrRo9F39l+lgIJ3T+xCOjLiGnLQ2kfeTgvLXJp7QOFaVkmSqAZLMbaTpbQ1oU
	OQl3/IMaCpY1+ka2QCZB6MV64akK+77mgWfamtInqkSOoQ1JbEHxBNDL0Qymz5afh7raFjP5tuy3c
	718MIf4OMfDDNZQuR5P490ZKhYWDrrC+5Ags9lJXAWFbwg4FUHuPszHsiCmPRq++1Et5fjrCKFslN
	cbXi/nMEDcHpF2fMATWH929Jq6Gmrwc1qMbJsmS1ZR83KWFHUzfNOe0uQS8PK8Ibj2+n2m/In/trQ
	MPnf6pNHKcPihJACP+5iITDr;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxiH-00Ffqu-0L;
	Tue, 25 Nov 2025 18:24:35 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 134/145] smb: smbdirect: wrap rdma_disconnect() in rdma_[un]lock_handler()
Date: Tue, 25 Nov 2025 18:56:20 +0100
Message-ID: <8f3c8ff31a4b4da800e1a35412ce4c14cdf17f4c.1764091285.git.metze@samba.org>
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

This might not be needed, but it controls the order
of ib_drain_qp() and rdma_disconnect().

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/common/smbdirect/smbdirect_socket.c
index 35252aa12fe4..41f69b6f8494 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.c
+++ b/fs/smb/common/smbdirect/smbdirect_socket.c
@@ -461,7 +461,20 @@ static void smbdirect_socket_cleanup_work(struct work_struct *work)
 	case SMBDIRECT_SOCKET_CONNECTED:
 	case SMBDIRECT_SOCKET_ERROR:
 		sc->status = SMBDIRECT_SOCKET_DISCONNECTING;
+		/*
+		 * Make sure we hold the callback lock
+		 * im order to coordinate with the
+		 * rdma_event handlers, typically
+		 * smbdirect_connection_rdma_event_handler(),
+		 * and smbdirect_socket_destroy().
+		 *
+		 * So that the order of ib_drain_qp()
+		 * and rdma_disconnect() is controlled
+		 * by the mutex.
+		 */
+		rdma_lock_handler(sc->rdma.cm_id);
 		rdma_disconnect(sc->rdma.cm_id);
+		rdma_unlock_handler(sc->rdma.cm_id);
 		break;
 
 	case SMBDIRECT_SOCKET_CREATED:
-- 
2.43.0

