Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD113331A62
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764095577; cv=none; b=frbW+KgUIPOvHTCwjc7xP243xU5ZgXWcyn0zW9InrvBIuxJW9dAfZX5pv81rWBGTCY86pv2mqapdPXHPmWr5ywNOXy58q7GocyJypNqK7XQpadU6he/+Alj6A6mMQ1fZcG97Nw9dzFM5ZeDuaeuaVxbvkakwG+m2ESVRvsI49ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764095577; c=relaxed/simple;
	bh=DRpr+TOqrSZpsSfFePH1zw3SgCVZt/PPjETFZc1xuTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RhfluLgIt8xF1uZyb9jkERFsXF8TZPpWzKGyuQumdaZePxWWYFrm9KC3KjB8d8sTVByFpZ0hsI/PpTQfhtKdZ7BljRME0QLoTK8b9b8GBYF3k+XP1WP9qr3rCx3fFGlMo3pQRgG8bnI8efDwf4wGbdjQj5Cvknfz1NmNHou3OxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=mpTXQI3T; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="mpTXQI3T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=JtTUgN7Q/kmK9tFaXwPneT5S8M+2EvMdCdRr1+c7pAk=; b=mpTXQI3T87FYKoScUu13apAvm7
	9jla66rm5lJ/gbblie7nSEc5TnLZfJIdupZMKU7E7DLeUhDmnFe6G77SHKIkrFuJG0EWjLuYaHnKU
	2/16yD4IMByjC/QyZ/DGR59/6QqWh1CgL7pkIE+FrQTMgtswBPz8lVUIBUFLAAOHsqPPmvCQv4bXc
	h2smogeOvHMJUSFPsXlzo5pHhYrw72HrSwCzWr84g3qO6p7E3bbAHyxzHZl5jBog5cB+SqokN4W+X
	pp7f2DJkligYAePj0K7J0Mcdgh30KUOqdu5O4Vn3z2Kg4oBOjVEn3JHLTfjga+PUw65TtDuTlya3H
	woetlmXl6xL8g5+EpJUXRVHUdGDU7zh5SdnVFNrXDhPWE8AuBLQXhDsudrhFMoky3rBLrVQzBB1/4
	mfxt+J888xq/McbvgWUBOADk8BY3YFY79eI9mKbIIAZZCjSm7mC/gz0zqHW9s+x6stV+jj92BwXbn
	HVth06JgDBXwyoWG8uPRe+al;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxnE-00Fg3T-2T;
	Tue, 25 Nov 2025 18:29:37 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 141/145] smb: smbdirect: introduce smbdirect_socket_bind()
Date: Tue, 25 Nov 2025 18:56:27 +0100
Message-ID: <55778c70f01ba954ea8e61c166101bdc55ad57f8.1764091285.git.metze@samba.org>
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

This will be used by the server in the next steps.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_public.h |  3 +++
 fs/smb/common/smbdirect/smbdirect_socket.c | 16 ++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_public.h b/fs/smb/common/smbdirect/smbdirect_public.h
index a5b15fce840c..7404f7e5bf52 100644
--- a/fs/smb/common/smbdirect/smbdirect_public.h
+++ b/fs/smb/common/smbdirect/smbdirect_public.h
@@ -85,6 +85,9 @@ bool smbdirect_connection_is_connected(struct smbdirect_socket *sc);
 __SMBDIRECT_PUBLIC__
 int smbdirect_connection_wait_for_connected(struct smbdirect_socket *sc);
 
+__SMBDIRECT_PUBLIC__
+int smbdirect_socket_bind(struct smbdirect_socket *sc, struct sockaddr *addr);
+
 __SMBDIRECT_PUBLIC__
 void smbdirect_socket_shutdown(struct smbdirect_socket *sc);
 
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/common/smbdirect/smbdirect_socket.c
index cb57ed994c6c..b04ee8f2bd2a 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.c
+++ b/fs/smb/common/smbdirect/smbdirect_socket.c
@@ -663,6 +663,22 @@ void smbdirect_socket_destroy_sync(struct smbdirect_socket *sc)
 		SMBDIRECT_DEBUG_ERR_PTR(sc->first_error));
 }
 
+__SMBDIRECT_PUBLIC__
+int smbdirect_socket_bind(struct smbdirect_socket *sc, struct sockaddr *addr)
+{
+	int ret;
+
+	if (sc->status != SMBDIRECT_SOCKET_CREATED)
+		return -EINVAL;
+
+	ret = rdma_bind_addr(sc->rdma.cm_id, addr);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_socket_bind);
+
 __SMBDIRECT_PUBLIC__
 void smbdirect_socket_shutdown(struct smbdirect_socket *sc)
 {
-- 
2.43.0

