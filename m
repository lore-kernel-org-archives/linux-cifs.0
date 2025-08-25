Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49652AE90
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154814; cv=none; b=pXlw4e/hZIFPrwnZaSUGvhpCboJpgvx9Upgt1VjMy2guh0imbf7Xa47UkZd4rtnC1SGGMBmh8H3KsQSEn3gcSXbjOHyX6xheicWt4UiTWGhaklbRBZBfc4w0C3Od7/6X7KLWima0jbV5jsX3fm8Bhlgm8FDfYIJFjLtmn6wAlJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154814; c=relaxed/simple;
	bh=sLiTUENg33jkXDXxasM2HQWkHbN04WQtGlnfqXH7WMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRVoPlWKfUF7clVnqOtiHF4c8VMvKulggz6B1+Eful+KPpzQp1icQfLHNc1tuoNc3ISmmBZoarvcQT/hb/096qMC45SnwYylYKwOFYw0sM1RW31dEyzhkTEaxfvnndAYG98i1lMk2agmGYB1L6jn1KC8WP6uohGfPhmovL5Wnk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=JZTrjb6H; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="JZTrjb6H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=UW6eS9CxDHobELUIPmZRpu4OxqzdfIyO+N6wYgdZ6+A=; b=JZTrjb6HBGQtHY8/1QcK4BEwki
	ZT1yStJVYuT3OLk1zau5qIWTkOsq6IuE4q0S3fkLFqbNWfUQ1sr21+3rNlPKMFwOtSQt29d0tK4pp
	oSSQzFv6E15iyaVUGuK0s+3zWctSHd1iZk6kdtAI2jM+V2PBw3/PwMSaC7ubf03YUx9W9l3yiyQPd
	5Cw143orsyrc7P8an7FatpoW8c6x+mHxklVPBooBCDrzd+Ly9LjOvsCIrIPVWjzHqJGkfrNIHj2xJ
	NlSSeSVhlqduAmal8y72ELvmkC3ciW1Kwt/dxe4frfYBsfyAC3cYNMcAlbemEpa9Y5P67qbEug9Nf
	ZQAJfFA66rn6mDPcv2sNuQzTgGcmoux3682vygiYgGLy6gnbq2uMQECqwm1eVDb0YxwzCfZoaS7v9
	4+fzdVgofNQRTcauj422jnKUO+CPPNQBlbMPoe9L2CeWgH7O8cqjK1UnfGVruggmts0QfoE02c74a
	UVWpoi/IIi0TTvQJ3WUeAAQy;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe5Z-000kA7-2x;
	Mon, 25 Aug 2025 20:46:50 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 030/142] smb: client: let smbd_destroy() call disable_work_sync(&info->post_send_credits_work)
Date: Mon, 25 Aug 2025 22:39:51 +0200
Message-ID: <1aa2d877d2a9b6549fc1bd4aa78d980928788ef5.1756139607.git.metze@samba.org>
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

We already called disable_work(&info->post_send_credits_work) in
smbd_disconnect_rdma_work().

But in smbd_destroy() we may destroy the memory so we better
wait until post_send_credits_work is no longer pending.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index d36556fab357..a61c7d2afbdf 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1462,6 +1462,9 @@ void smbd_destroy(struct TCP_Server_Info *server)
 			sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
 	}
 
+	log_rdma_event(INFO, "cancelling post_send_credits_work\n");
+	disable_work_sync(&info->post_send_credits_work);
+
 	log_rdma_event(INFO, "destroying qp\n");
 	ib_drain_qp(sc->ib.qp);
 	rdma_destroy_qp(sc->rdma.cm_id);
-- 
2.43.0

