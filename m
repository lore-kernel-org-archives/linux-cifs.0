Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFCE1E89C
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155454; cv=none; b=dYXptO6xWH0que9rfVxskcGfFNnNhmWJXxKERal+90I/2kQ3/ciiwo1x62+XX5Xw5y7dS+l3Rr4q76l5PQpzKnTwsVtz35st01px+0hvJIM/fYCQLhZaZ6as+yfvpl7Y8xsg5W/QzV8xFAE7sMcud1i+7+4xT/wYf5Ez3FSPw3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155454; c=relaxed/simple;
	bh=4JMA5IBnvSHXWFKFTLhV908+7oUixG9pEJM93QOUq44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JwiuJFYMPJypxi3m65CPVL9roEihIG/MrWDmEWiOCBOsKULxeRlQr3IEkgXATJOru8iTXPwQVJjrdwEXJD5cXK6V3q0U7mRzfwPPD1HsP1Sh5/6H98XF23FKoFTibJfogtBYc5pprjDF7xsUKfp+DPMpis9nTJsY2/WsvOZfEOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Y0FAp3FN; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Y0FAp3FN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=QpsyYYVWqluMLty6/9UAIxU+hwXsAEXMA9savJJBiJg=; b=Y0FAp3FN2uQ8goK7lrROtUVWWz
	78tTVQQm9X4o0//OKsyJKY9i/Tm7AEFwanMqLJ/2vyjpPP/TbGxAZmYw6Y0EIrVwZ5p/ME83fy6ZD
	OnwWLTC9CNk//Y2YBWy6Z7PnW6XPrGTrTznWnF+CmrgcfM4gYhkcA68ufSvXSd9lySyYWrzgAmXgO
	6wkpDCuTxOtNRn/2gd5ezytIUcAQTmXr6srJnhyQnDIsn5AdPqRH9S/am9CWi6NGijcBQkPvJUsIy
	thdIhh/KPf2n2pyhhZ9x4YsY+7z4vCTDm7Goks6uLvkSG0ttdHRyW7eCyr0PfFnsBdQTtkuxhjGFQ
	s6UAlDfc02WXAORL3+bTUbEJt18AX1vBQ402PPgTUa2l2KCm9lG6oLLccbp4jmYsCKPC2zeqLb2cg
	mVR0kpzNeBtH50+GyFQuAYV0M9tRiFr1fYZNzFl1mV2mHfDPJzOWOBFYTu6vOiaj24PCpuiJFpNrs
	UaArpnB7c+K3cShPtR1vMKDY;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeFs-000mLx-06;
	Mon, 25 Aug 2025 20:57:28 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 094/142] smb: server: move smb_direct_disconnect_rdma_work() into free_transport()
Date: Mon, 25 Aug 2025 22:40:55 +0200
Message-ID: <149659aad412ffd0b1ea0a61349c01044b9066a2.1756139607.git.metze@samba.org>
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

The logic is also needed when smb_direct_handle_connect_request()
calls free_transport(), because rdma_accept() and RDMA_CM_EVENT_ESTABLISHED
could already be reached.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index fdcf53856665..741b5b62b7d6 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -380,13 +380,19 @@ static void free_transport(struct smb_direct_transport *t)
 	struct smbdirect_socket *sc = &t->socket;
 	struct smbdirect_recv_io *recvmsg;
 
+	disable_work_sync(&t->disconnect_work);
+	if (sc->status < SMBDIRECT_SOCKET_DISCONNECTING) {
+		smb_direct_disconnect_rdma_work(&t->disconnect_work);
+		wait_event_interruptible(sc->status_wait,
+					 sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
+	}
+
 	wake_up_all(&t->wait_send_credits);
 
 	ksmbd_debug(RDMA, "wait for all send posted to IB to finish\n");
 	wait_event(t->wait_send_pending,
 		   atomic_read(&t->send_pending) == 0);
 
-	disable_work_sync(&t->disconnect_work);
 	disable_work_sync(&t->post_recv_credits_work);
 	disable_work_sync(&t->send_immediate_work);
 
@@ -1486,9 +1492,6 @@ static void smb_direct_disconnect(struct ksmbd_transport *t)
 
 	ksmbd_debug(RDMA, "Disconnecting cm_id=%p\n", sc->rdma.cm_id);
 
-	smb_direct_disconnect_rdma_work(&st->disconnect_work);
-	wait_event_interruptible(sc->status_wait,
-				 sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
 	free_transport(st);
 }
 
-- 
2.43.0

