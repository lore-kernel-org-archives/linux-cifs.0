Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21208277CAB
	for <linux-cifs@vger.kernel.org>; Tue,  5 Aug 2025 16:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754410348; cv=none; b=Qo3U4FVlJpKC/GBRPIYopVl/MNWSzIkb0EnANwT/0FODAL6wsw0tVvLYusv19dfqX9yaM68j0fUQO92VMDPZr4wpPPyZ6lo5fL0/T8d2x/CYApmbzZrdPMHKyq/YgAXhKZpA28Uwa+jroPIKAOPHJ1YFawyJT2hIUngrXjjrxDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754410348; c=relaxed/simple;
	bh=vOHGJiMNVWBz9w7VAUfrK7ojSIkG+DfWxvbUh11taN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQD0EMAZYGB8uRHcG8mvpCNyMwOxhAyLMO/TFkQFtTdW+QaBZZQMtpLGOJ2b8hEEwCStELSmLnUh/WlubtnuZ+a88xPAZ+bWmidcIzeRu5UgBrZCGb7TERnOmuxf6aEkNTtXlKl3Fm6XrMupedPvArmEJVkejlK+vCU/+C+t7uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=cJX+tsum; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="cJX+tsum"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=gyL4IDc7HU90u8aqDlrz0nY6lM5tSDmbEin3j52zRsw=; b=cJX+tsumD6gZpNo/GvL4/EfB9G
	zRnqnymJpfWDmot2lbItuMmmoHw+ji8RukFOIsAeZSoM9THP2M+rMSRnC+ZS6lKfRvDLpFRIaI2Cb
	APotuzOV0suuhFL+01WNvs8apRUYyE4L7slCPP3WhrDUZtRD7lS/bl58XR3NOhUOF/kagJznQKV0H
	q2WygfKeRi8LsNglAuv+nLUdYk4tcq1WjMkArBe8Y5c6DOucLaR/Q1USmDr8X0S+ivr+EXdHPd3NM
	tJba7cvyn5vmxrice6M2oRDAYksM2zCPBWku2gO9N4wNhhPDOrKtvB2cuc0MwPFk11GGE+DL7g3pq
	yE8VA80iuEQgMVqZpWymeK7H795BosuLKVHTjG3z40DYGs+yoBYiRXLjC1AU+z5Eb8gO0+OyBvw57
	pQ61Vimqas9waLWsiDMriaDJHyfsy4X06p8Ger+Xg/4zjeu//QkHQCisNV4NKKLJFTB8V9RFMFsgL
	z8bT6THMTDmDX9at5+rMZv+X;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ujKH1-0019bs-30;
	Tue, 05 Aug 2025 16:12:24 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 04/17] smb: smbdirect: introduce struct smbdirect_recv_io
Date: Tue,  5 Aug 2025 18:11:32 +0200
Message-ID: <58caaa8827675b0185da18556dfb6fa4f4756141.1754409478.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754409478.git.metze@samba.org>
References: <cover.1754409478.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will be used in client and server soon
in order to replace smbd_response/smb_direct_recvmsg.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 5db7815b614f..a7ad31c471a7 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -54,4 +54,19 @@ struct smbdirect_socket {
 	} recv_io;
 };
 
+struct smbdirect_recv_io {
+	struct smbdirect_socket *socket;
+	struct ib_cqe cqe;
+	struct ib_sge sge;
+
+	/* Link to free or reassembly list */
+	struct list_head list;
+
+	/* Indicate if this is the 1st packet of a payload */
+	bool first_segment;
+
+	/* SMBD packet header and payload follows this structure */
+	u8 packet[];
+};
+
 #endif /* __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_SOCKET_H__ */
-- 
2.43.0

