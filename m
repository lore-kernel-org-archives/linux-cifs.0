Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3614628689B
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154620; cv=none; b=g5FE+KqVb5YpA+0vD4IVOg25tycMYXTOrZcH0EU7dLSlVsm+jt4iqpyHMrX2PzaebHYRLX0jsZes9/uff2uQDQXl37HD2TH2yttjqNCauFmY5dg5k3bxIr5/AUnezWD5roIX1UjTLkt+6SFcK7O00Qe4iB1FW2Fp6YkN4YryMrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154620; c=relaxed/simple;
	bh=5Ll4OTGKk7O7ousH3Vsq9ZGNjQauqwaB87kLCoh14eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRqMHf59dMqfDrBdSc6JAbDEonUktOrabbMWBVMc4Hg9pgnP6bK6smiit2EsvR4wVGHPwvQnAz3rDDWnYTRSNP/oXgqn3w8/lBBUo0gGXqY/tYLWfE5GP7aggQN/BZXJgCM0w/ZTaRpYpF03uvYU75Pfyvf3uqwCnSXDYi9kwoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=CjHxvaIH; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="CjHxvaIH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=/GhBLN6rvUZjZvfHUt9t0jcr1gWU/Gqldr952pTS4Fo=; b=CjHxvaIHV4n7HrvTqGfZJCvNJB
	U/ZXF40ckDs/QbKshc6uURX5noi3A0Ld1KlHzHU2jZD/AphxLKZgWhY54S0NYonxD8uD8RGW0wqla
	kHLB5wzj0sB6RcMVZZSBhseLbWLom8XPZVdGO6EaQqMh0gZUI8483RlD06oJtAXBiSoDwPnlGFbf7
	WMMwXij5fr169/fSP3bDAO8uQ9xECZKr62e2ILBUbLZExA6ui4Ive0mKATTigQngcyZIwS1TyeAh8
	PNftZ3hZb5E0bMPhS79F5XKOuc+C5gMBpnLl+Ud2dbiJUd4+j8gRjaFDCantITZ+0UGfUmOV7xsmg
	l3xSfLeUlWgobLHpGEUAubDXm23S75Q2MSyaOnR8dTlMYjw3WZEPzKW4LdfLDR7vN+cVvtRF+aqay
	q/0aJWCCsVRj80HSgA7/1ZhFk7c0pYvHP7hR79AtalQ/tyeZ5NccYp18E1djSyua5ms9bIknIC1n5
	HKnsk/anlpE+cEu7jWKM8tUM;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe2S-000jVx-1b;
	Mon, 25 Aug 2025 20:43:36 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 010/142] smb: smbdirect: introduce smbdirect_socket_parameters.{resolve_{addr,route},rdma_connect,negotiate}_timeout_msec
Date: Mon, 25 Aug 2025 22:39:31 +0200
Message-ID: <ff34cb7c0f5c52fd13eed7d126e2292bcbc03c5c.1756139607.git.metze@samba.org>
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

These will be used instead of hardcoded values in client and server.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect.h b/fs/smb/common/smbdirect/smbdirect.h
index b9a385344ff3..17aa08dd6aba 100644
--- a/fs/smb/common/smbdirect/smbdirect.h
+++ b/fs/smb/common/smbdirect/smbdirect.h
@@ -23,6 +23,10 @@ struct smbdirect_buffer_descriptor_v1 {
  * Some values are important for the upper layer.
  */
 struct smbdirect_socket_parameters {
+	__u32 resolve_addr_timeout_msec;
+	__u32 resolve_route_timeout_msec;
+	__u32 rdma_connect_timeout_msec;
+	__u32 negotiate_timeout_msec;
 	__u16 recv_credit_max;
 	__u16 send_credit_target;
 	__u32 max_send_size;
-- 
2.43.0

