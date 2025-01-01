Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1AD6EB4C;
	Wed,  1 Jan 2025 13:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735737703; cv=none; b=Y4UqmRoZsmJb5UCkFhi5gJh15YEK9QV2ze7jMcmpydkqu2qKwTHkdzjR8JjOieI2/9wrdlfZKH4iyXVJqhN4AgJwTOWd9y5PUzEuX6zdKPn7Pgd9o0XpC68mFlkOA5WpwXtW9W+y65vDzYwP4dO9tJHecfEsmpSZvWAco2UL8lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735737703; c=relaxed/simple;
	bh=tjB7vHIeGCjLJhl7fk10/7Rfk2/vB4huTfoGoJTMaV0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=BexrzYZ2fL6HtittGNjrFePP5QRXRXLLdpYU0R+LilUSGPOJICL1bhUJ0Yim+gZ/3D4BrDtU301PW2YKgsgotKTA0ncpOb2LL09LbB704t5+2q2+M/NltR+8W4VFmf6rMKo9qXkUo5+665vpnmVspfKc5Mzs4He/TzTDAuQng84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q+5Pfyik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q+5Pfyik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA57C4CED1;
	Wed,  1 Jan 2025 13:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735737702;
	bh=tjB7vHIeGCjLJhl7fk10/7Rfk2/vB4huTfoGoJTMaV0=;
	h=From:To:Cc:Subject:Date:From;
	b=q+5PfyikijYAroFfeXcULvd28A4NMMs1ukDCHd+5Fcj4H6CYLDNOgzsj5Xk+IjY+A
	 dHzNX4r99BXTxVI/89oHzl1VjCoOxqnLnGpXh21YGWuXzBRllq2RCOQ/5VOZSwyWhD
	 cnr61J6gocA0n+s5H43+xDdJpuLWjplyzuf62o0x/Fv/jZGN8P4SE+cvMdxJaAsgWa
	 SBF/v7uwfSRewhGwHP9a1S457ngrJj2kGOx3vdNdFU+OGmQux9g/WeIgbGX7Iwr+Yt
	 Wv3T6RoRWvh8el4Qz5jsv7ZEk7bzXByV0L02abDDwVB+S3DSEBa0XM0WHkzo1/QJ02
	 OCHQNHSaZ4qbw==
Received: by pali.im (Postfix)
	id D12E0768; Wed,  1 Jan 2025 14:21:32 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Fix endian types in struct rfc1002_session_packet
Date: Wed,  1 Jan 2025 14:21:24 +0100
Message-Id: <20250101132124.20041-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

All fields in struct rfc1002_session_packet are in big endian. This is
because all NetBIOS packet headers are in big endian as opposite of SMB
structures which are in little endian.

Therefore use __be16 and __be32 types instead of __u16 and __u32 in
struct rfc1002_session_packet.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/rfc1002pdu.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/rfc1002pdu.h b/fs/smb/client/rfc1002pdu.h
index ae1d025da294..ac82c2f3a4a2 100644
--- a/fs/smb/client/rfc1002pdu.h
+++ b/fs/smb/client/rfc1002pdu.h
@@ -24,7 +24,7 @@
 struct rfc1002_session_packet {
 	__u8	type;
 	__u8	flags;
-	__u16	length;
+	__be16	length;
 	union {
 		struct {
 			__u8 called_len;
@@ -35,8 +35,8 @@ struct rfc1002_session_packet {
 			__u8 scope2; /* null */
 		} __attribute__((packed)) session_req;
 		struct {
-			__u32 retarget_ip_addr;
-			__u16 port;
+			__be32 retarget_ip_addr;
+			__be16 port;
 		} __attribute__((packed)) retarget_resp;
 		__u8 neg_ses_resp_error_code;
 		/* POSITIVE_SESSION_RESPONSE packet does not include trailer.
-- 
2.20.1

