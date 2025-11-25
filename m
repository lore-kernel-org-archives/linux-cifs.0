Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F73318152
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093719; cv=none; b=FSlScv+RMjUi+Xm50amBDDnDqgBytNAD+B+NYB3x657edI5mnIQoAZT3n6c/o1L7E5mxfxRtfIFYWX2kaazh/TP0QL4M8fdEJo2hhvmJGJSrMucyGqV3vBfoDyFUWcBdQI4rc6JRSz9VvugwXyQt1o4zpclTEVSW8Lu5rAUbIng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093719; c=relaxed/simple;
	bh=pQQ6PsX5PaacmYRI3wkbzJ94ZnD4BCIV+d4XXsunYRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nft4dA1T94GNbEKRWuOZrt5apydmzNxw/vhE23jcAfpWayxs+h1WLLgxfG+8lO+rYfx0TQjiHoNTHXKSjHX60BNaEkEytxynkDj+jdhkthBlGl3bvD4IHpjI5iL8NFOw9mGKZZYeR1Nyc7wId8NZOR+h/xdy7Vt2O59t06Of5aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=i/TCM9lE; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="i/TCM9lE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=QsSwNc5zY0Vp+9eFsY9ZKfKzRllIiePk7r/9jSI+tj8=; b=i/TCM9lEwiEq6Xx6WkbL7uZxcy
	EXoV6YvXm4NBHpx25jK8Sn07K5vQg2LbFwYzGcy3zdcALOQXhlBwoLz3kJXXcr11l7kYcnoU5rPVj
	g3nqM/M+gA4hR5wRXmkZa7XYDHcwRhPOh1ardftCg8xXjgSpBhaLVkbfHHAFqEUI6HhPrqsPit/i8
	RPIFId+x6cE0SQ0MkYj6PwRl4zO5955V67ywb1teiy16icys91n4IhHFWSPFFBcp3+TvUIaNRh0qB
	DFo7+MtQ8ZkRYYB6mH2k1BKHcOgnaphd4JIsba+4s9xk5etnmYU1dzVsICMaau5JTMIP2jBGuigHS
	k6v9KxGSq2NyvzQtHsi6wVopSeR7wWO4tLJgjTpy5BZ2Zc3GtOmBdbCEw/221EIlVzYR8DvWTkGD6
	GqxSq3fDOwrizhud8K+OFQthIg8F3tZtADmEGptk8ucFdF3Fcvmpi0ctqxmEmwzOzl9PjmEcFvXAy
	Y8f/XibnRN/XabUxHPT9id8a;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxMQ-00FdJB-1a;
	Tue, 25 Nov 2025 18:01:54 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 050/145] smb: smbdirect: introduce smbdirect_connection_is_connected()
Date: Tue, 25 Nov 2025 18:54:56 +0100
Message-ID: <adc0e3fa052ff3a7e866c0f588ead2305876b44f.1764091285.git.metze@samba.org>
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

This is a simple way to check is the connection is still ok
without the need to know internals of struct smbdirect_socket.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smbdirect/smbdirect_connection.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 22d6273649a7..c270c9ac1c81 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -719,6 +719,14 @@ static void smbdirect_connection_negotiate_rdma_resources(struct smbdirect_socke
 						peer_responder_resources);
 }
 
+__maybe_unused /* this is temporary while this file is included in others */
+static bool smbdirect_connection_is_connected(struct smbdirect_socket *sc)
+{
+	if (unlikely(!sc || sc->first_error || sc->status != SMBDIRECT_SOCKET_CONNECTED))
+		return false;
+	return true;
+}
+
 __maybe_unused /* this is temporary while this file is included in others */
 static int smbdirect_connection_wait_for_connected(struct smbdirect_socket *sc)
 {
-- 
2.43.0

