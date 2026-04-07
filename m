Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E787733D51D
	for <linux-cifs@vger.kernel.org>; Tue,  7 Apr 2026 14:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775573725; cv=none; b=iOxyYokzOp5F87DJJJpb270pGBWPKEzh4ww9JLaOJZPd2S3bqbiXrbIQhL/x8z05Yjp0YEMyyWFw58MhLhebXL9CrEdOpu7vgHfjM5ZuNJHPweWbDqNGqAhIqcLrF7ddAb3Jo/xZewMYYBmnmeusT4FXMeOKioRq+3Gok1XVpSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775573725; c=relaxed/simple;
	bh=qShIrCSLo9hc5XiLmctUzLf6l1j5HmqLLb9rQsB2mAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHjV2Mv+hHmw+fQyTYT6iFcCrmtneohR81yJN8oSPM72Egp4rPy/TDdkVJjNdnfCtmmHmNwTwyit+PayKKEM0LsjGL4mwhvq4CfffOtkAZAD3mCu6moJQQP8t6zf5p0XoVZBNnbRBumOmaRJtb1FSN4x4e8G3aESKIwKuY+VEro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=gj+xa9px; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="gj+xa9px"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=SqP2ejoZrmlZEjm9zwXZG0rMc9+LIgTmP7z3fQgvZDU=; b=gj+xa9pxtecX+b0ilO113+G/Aa
	1k2bF3h5Kfrsr+Cvye/ILEdH4dSOL0Vzt6nZNJaK8sVq4NFNXkCukR92rJpcI1vgkriqqWzGvpZlj
	XlcfmQQVN9ZAy6nsCDnPyzy5OkdYLx/kc9qAZFRez1WTxuRcT9Sp02/pWPMV0QW3idjhBcydX76Yg
	8U+euwPMZFBVRQ3bU6dNHwiFO9qzlFgz/21ZRJlJj5XD8LYadsy4elir1S+64hWweEGGa/jYCv24c
	1FgePp/x8Ed8Y2C/M5uUzmRAeHEhX8/0UxutMAnVnF49No3wt3UihDopqaopHpZvRl7jn6mjQChaN
	YwhkHZz8kwr4VN27m8FAsnZx/NX+vwZ2WIHA2zYGc14145agaz4gfBaQRWDUN6+O/jJPXz8EWAwqe
	vg5YIf+i6F7pRod6SDTolwGz5y8GoYHQGqn/vClWJlMh2WVtiEUFqUiTYH2DhUlJvVCxkJlB4LjlI
	/OtkOQHx/9Bg0sHXcMdiNimV;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wA7hv-00000007WOm-1Cjg;
	Tue, 07 Apr 2026 14:47:11 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH 1/8] smb: smbdirect: change smbdirect_socket_parameters.{initiator_depth,responder_resources} to __u16
Date: Tue,  7 Apr 2026 16:46:27 +0200
Message-ID: <a72f02560aadca368b8f136d635ff5144b690517.1775571957.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1775571957.git.metze@samba.org>
References: <cover.1775571957.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We still limit this to U8_MAX as the rdma api only uses __u8
and that's also the limit for Infiniband and RoCE*,
while iWarp would be able to support larger values at
the protocol level.

As struct smbdirect_socket_parameters will be part
of the uapi for IPPROTO_SMBDIRECT in future, change it
now even if userspace sockets won't be supported yet.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect.h        | 4 ++--
 fs/smb/common/smbdirect/smbdirect_socket.c | 5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/smb/common/smbdirect/smbdirect.h b/fs/smb/common/smbdirect/smbdirect.h
index e70a21eb57f0..8fbffe3eb845 100644
--- a/fs/smb/common/smbdirect/smbdirect.h
+++ b/fs/smb/common/smbdirect/smbdirect.h
@@ -32,8 +32,8 @@ struct smbdirect_socket_parameters {
 	__u32 resolve_route_timeout_msec;
 	__u32 rdma_connect_timeout_msec;
 	__u32 negotiate_timeout_msec;
-	__u8  initiator_depth;
-	__u8  responder_resources;
+	__u16 initiator_depth;     /* limited to U8_MAX */
+	__u16 responder_resources; /* limited to U8_MAX */
 	__u16 recv_credit_max;
 	__u16 send_credit_target;
 	__u32 max_send_size;
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/common/smbdirect/smbdirect_socket.c
index 1e3b361728cc..4003753bea26 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.c
+++ b/fs/smb/common/smbdirect/smbdirect_socket.c
@@ -166,6 +166,11 @@ int smbdirect_socket_set_initial_parameters(struct smbdirect_socket *sc,
 	if (sp->flags & ~SMBDIRECT_FLAG_PORT_RANGE_MASK)
 		return -EINVAL;
 
+	if (sp->initiator_depth > U8_MAX)
+		return -EINVAL;
+	if (sp->responder_resources > U8_MAX)
+		return -EINVAL;
+
 	if (sp->flags & SMBDIRECT_FLAG_PORT_RANGE_ONLY_IB &&
 	    sp->flags & SMBDIRECT_FLAG_PORT_RANGE_ONLY_IW)
 		return -EINVAL;
-- 
2.43.0

