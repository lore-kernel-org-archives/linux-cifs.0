Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D7518A956
	for <linux-cifs@vger.kernel.org>; Mon, 10 Nov 2025 15:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762788270; cv=none; b=PwRSmM9tlikEz0uxSaEQ9OIA/BiA85aIXLpPmuY31lAbZ6XJgi1X+JeomQNcz7UM/9Y4A5Pkqd9/4sQIJlTpxWHqAoZKHq78FGklNE3uhIE7k0oWhgpYNJTeCshwQjxGMDIa8iGnn8pKp8c3QRDCas8BwvrwDSWmGQP+YlSgFlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762788270; c=relaxed/simple;
	bh=HZ0sa7FdNl+PBVFKQFgm4sF3r74chYcNC4CBMOqKdMU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NETv6Q0BF3WT2z6A3mHFbsiSQnZTEebIvOOZY+RQFZqSO/tfDEmP91zLN6paQQiT48W1YZUyzMxWKulRUyLA4dDy1YjqFiiRyOHArB+H3jnm32SDScEIUuhnfWKw/7pvZkGCnp2yO+GfftGfuYvqsCaDAotbAMzoReEOcaYkut8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=VbtYqc/l; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="VbtYqc/l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=psxo2bSvkQMI53M1PA4IMWPxzEC7ryfCrtvWP2F0IAE=; b=VbtYqc/lZrU2WwNC0DZqGLeuuz
	7Af60UN7bE1lnh+I1SrWA/r7ZM93AhWgQqlJmjTp5z8BnM98ktGkxkGWRK6MtmkJ9vCm1fxp1o3f7
	3SCybmWXiXSHC3p8ES6ztZgH+y8HL+19m3LEDqUIdcen1fUpDpAxtr3urNxvLVPXvCLbDl+0zh0EF
	EZndjC7G0vR4MWewtJIi0H+Gu4nytzvxf8F/+883A2fr1gAZ50kP8FiwTkr/o2k4itPEh+iXQ+Bu9
	4rWgkqNOlNVjShCASYfa0DM/Vwg/ioo+rWJEA/V8oQcDUL0XD12aK5nEbt+9VMAr2FhTzG1mMmwKp
	65N+exszgouoEiEpOEKdRvB9YYu/vgwF5uR5txH6RiaWoxEjzfpyPp+Mtd0fvKa+nalWNLTb26vPd
	flvuAiJPLl1p7AC383ItOvoMqyuS1Q5fSQqY1aFoiidnWpXpbECYzHsDRwg5lvimOth58czgqLqxm
	w7DGgghy3tI2OMW5grD84BRd;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vITko-00DTEk-04;
	Mon, 10 Nov 2025 15:24:26 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH] smb: server: let smb_direct_disconnect_rdma_connection() turn CREATED into DISCONNECTED
Date: Mon, 10 Nov 2025 16:24:20 +0100
Message-ID: <20251110152420.2889233-1-metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When smb_direct_disconnect_rdma_connection() turns SMBDIRECT_SOCKET_CREATED
into SMBDIRECT_SOCKET_ERROR, we'll have the situation that
smb_direct_disconnect_rdma_work() will set SMBDIRECT_SOCKET_DISCONNECTING
and call rdma_disconnect(), which likely fails as we never reached
the RDMA_CM_EVENT_ESTABLISHED. it means that
wait_event(sc->status_wait, sc->status == SMBDIRECT_SOCKET_DISCONNECTED)
in free_transport() will hang forever in SMBDIRECT_SOCKET_DISCONNECTING
never reaching SMBDIRECT_SOCKET_DISCONNECTED.

So we directly go from SMBDIRECT_SOCKET_CREATED to
SMBDIRECT_SOCKET_DISCONNECTED.

Fixes: b3fd52a0d85c ("smb: server: let smb_direct_disconnect_rdma_connection() set SMBDIRECT_SOCKET_ERROR...")
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 3d8d8cb456c1..e2be9a496154 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -334,6 +334,9 @@ smb_direct_disconnect_rdma_connection(struct smbdirect_socket *sc)
 		break;
 
 	case SMBDIRECT_SOCKET_CREATED:
+		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
+		break;
+
 	case SMBDIRECT_SOCKET_CONNECTED:
 		sc->status = SMBDIRECT_SOCKET_ERROR;
 		break;
-- 
2.43.0

