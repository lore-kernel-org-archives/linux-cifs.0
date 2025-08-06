Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3C629DB9B
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 17:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754501896; cv=none; b=fw4TCZfhy96XYjvPUm0MzqjkCuAo0iAiBqpJ6FtTck9cykCEa3levqzAJoWloQg/DELwrQOM7CDvfqTp+AnYBkesB21ghxZHChwPAozBjNtP5KA77pAXI/ZxJivV6k3T43RjRfPjSKRxmx+/Fm0il0ubuzzON0GQj2rBcvwkkY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754501896; c=relaxed/simple;
	bh=jFZLheeJJCVIDResvK8VHsY4bz+l/vAR9k+spONuuPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzpK4jblBBsVCIRCnqy9khv/tCtq1OzavWDPayatdg+XD6ZjJ0qsroAD2EUnzfODEFyYAam/ZzBD4ueMzYZeon5Ne/TOEGIsiKSCB9/+ATFuMeRs/YbvbHXOICy1imOz+tlgSPKcvqh0BugDBPqQapil65u8rfqGEMT9krZ7jyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=U9f9N0la; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="U9f9N0la"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=iXFRi7wVrvMW8VUnpsw5QdAheVGtnYQOLm8V16dTE2g=; b=U9f9N0lavj8CU4lfTJA4E9s8Nu
	Zl26oRoh9Jc7gulSxNbu/DiOBJ3pTYXM+QRTN5t1ZMp0pK/xxHRbq9lMmyZO9daFcRs/1Kmnc6Qtb
	Zb85Fb/Y9OjLJ4IuL6HRJwwdNMsYRXeYVXHaJ7KNK4lRrHroRoTTcv1rRE016vzt/HwNfGH3UcjU9
	+iDivshHEowxTPtYMO05imMHVAuRp6g3Y87BoqFBY0FoivtvrfMgrpNuAzrLahPcpg1zIbdMKsZuN
	GJKuUFMBz2iSEyPkmGv+DE4imqcVG6G2EuwPvSvblX4z2I9Q0/cLqFS3R0knFy8lLvRBmdc9FAZ/0
	KzzPEzyKcp1AOGTARxYo7y1aUDRsoQY40xTgkrjp/NFERgXxsebDEQ1o3x1sFL11NyrGisKsIfhfD
	oDAIIIAivj8QP8nG+T+npkSCz07tLG5VD/dwx7Jjq0YmK4AMSAZ8gShvnC3qHIR4CBQXTQoN2IMxP
	YQakRCFElHs6I4xDm3HZxWwz;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uji5a-001Oqr-2s;
	Wed, 06 Aug 2025 17:38:11 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 16/18] smb: server: make use of SMBDIRECT_RECV_IO_MAX_SGE
Date: Wed,  6 Aug 2025 19:36:02 +0200
Message-ID: <c647f5c932f46877eed52f023302486866dae6cf.1754501401.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754501401.git.metze@samba.org>
References: <cover.1754501401.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 7fcd80c329d7..8021225df200 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -37,7 +37,6 @@
 #define SMB_DIRECT_NEGOTIATE_TIMEOUT		120
 
 #define SMB_DIRECT_MAX_SEND_SGES		6
-#define SMB_DIRECT_MAX_RECV_SGES		1
 
 /*
  * Default maximum number of RDMA read/write outstanding on this connection
@@ -1760,7 +1759,7 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 		return -EINVAL;
 	}
 
-	if (device->attrs.max_recv_sge < SMB_DIRECT_MAX_RECV_SGES) {
+	if (device->attrs.max_recv_sge < SMBDIRECT_RECV_IO_MAX_SGE) {
 		pr_err("warning: device max_recv_sge = %d too small\n",
 		       device->attrs.max_recv_sge);
 		return -EINVAL;
@@ -1784,7 +1783,7 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 	cap->max_send_wr = max_send_wrs;
 	cap->max_recv_wr = sp->recv_credit_max;
 	cap->max_send_sge = max_sge_per_wr;
-	cap->max_recv_sge = SMB_DIRECT_MAX_RECV_SGES;
+	cap->max_recv_sge = SMBDIRECT_RECV_IO_MAX_SGE;
 	cap->max_inline_data = 0;
 	cap->max_rdma_ctxs = t->max_rw_credits;
 	return 0;
-- 
2.43.0

