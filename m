Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0109F2459DC
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744537; cv=none; b=izHXiSLzE9gCRx32kOBJkmTaSz9fd59RobCKeK4Wdx1akWIGHEsqXLsRgUHjvs6IjNPQnfcGPuk70c/jpYoSGmnUSp5w8DBdqURfsl9+AsAxwzNo21AytQST77W6yLCM/XYTRG/1b93hOFyDgt/mCw4n52mAEgkmuCCWa3IpUU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744537; c=relaxed/simple;
	bh=MjaMGd2RtUF/uoc4DSKDaGEzuvXU1SPBkf8V5dJbx0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uz+BvUNkyRCqfAkkCGzIPZbuVcH1p2Qp2F+L4g/+7frZl6rrwdepG2sqm1mj3jD2JMQYUWSPLHv/nNN3IxwF7wGZM1oR6qM9u2cUFgNIsewvjibYNzb3C/l3K5SQlJMedOjfFjuLbAqCrt5GMLHGg1C5l3eei509GnVeCZ9wp3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=C3OBaRGb; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="C3OBaRGb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=n/KAblsQXDaf4rGjCuOL+re5yQhMQXgXAj4jCSyK7Dw=; b=C3OBaRGbKEZ38hsaVieALNuZc4
	J5c+21q5RmgA2GjQ9woK2RoYPdCJKKSbbVoR2T1N8Im0WVMyR7ThOcwDLuOf+sflbU/o2F0DZXJRK
	HZ787GEhcwPvHPwzNOI8TpXFZzmrV+XB7AFjJDwR9AtwV85NLJThIMNKpsykfXBJoInjCj0ITHut6
	qt7nfdpPqOy/A0+9DnsUlfYdclR6FSyy0uKAilRzyC+HTp/o5q1KMeqdMcD1GbTSFAYCwg5Vqe9LC
	f1VLF13JYmK/GmJRFfG/RY643UwBtLSw/+lxDkXPQ4jqgEN1XEvZXHjiPuhezxi/5hpXQzv2QxYpO
	Micye5+ooP+xs9ljkSiNYxaTPuq6Ui+t/NOSWwEY0eaLPfNAIgPVvxhWGdGnAmmjGvumQVd/9mznU
	1q5Y5hrPcjMyXtMZ/CVzBGKJN1bLsqSorPvQcK/fpsPau51Tq8Sw5Bnx4yqXkljlK7PvupK7C2TDZ
	JcTr5dRzmHrvfNqh/Ar0Dx+v;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6EO-00BcAS-1G;
	Wed, 29 Oct 2025 13:28:52 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 065/127] smb: client: make use of smbdirect_frwr_is_supported()
Date: Wed, 29 Oct 2025 14:20:43 +0100
Message-ID: <74930afdb9ca1f722e7c92273af8aaabb2bcdf53.1761742839.git.metze@samba.org>
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

This an exact copy of frwr_is_supported().

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index e61f41fd020b..ab8ce4c46bd6 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -783,20 +783,6 @@ static struct rdma_cm_id *smbd_create_id(
 	return ERR_PTR(rc);
 }
 
-/*
- * Test if FRWR (Fast Registration Work Requests) is supported on the device
- * This implementation requires FRWR on RDMA read/write
- * return value: true if it is supported
- */
-static bool frwr_is_supported(struct ib_device_attr *attrs)
-{
-	if (!(attrs->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS))
-		return false;
-	if (attrs->max_fast_reg_page_list_len == 0)
-		return false;
-	return true;
-}
-
 static int smbd_ia_open(
 		struct smbdirect_socket *sc,
 		struct sockaddr *dstaddr, int port)
@@ -814,7 +800,7 @@ static int smbd_ia_open(
 	}
 	sc->ib.dev = sc->rdma.cm_id->device;
 
-	if (!frwr_is_supported(&sc->ib.dev->attrs)) {
+	if (!smbdirect_frwr_is_supported(&sc->ib.dev->attrs)) {
 		log_rdma_event(ERR, "Fast Registration Work Requests (FRWR) is not supported\n");
 		log_rdma_event(ERR, "Device capability flags = %llx max_fast_reg_page_list_len = %u\n",
 			       sc->ib.dev->attrs.device_cap_flags,
-- 
2.43.0

