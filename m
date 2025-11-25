Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D11E1C5D72
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093725; cv=none; b=fSeeUx0CGk/jiKAvgUlRceEhiSnZROs1hXIIrd4hd8HF2Npl3m+rFcZDAHGGPVg0Opeh4RefHBXaywQblxfoRsKnqoqZgcvNSDL7VSs5gk/otvnxCV2xv/e9Iv1HwEAKpq3R1VKJhvfeLfM+bw8xIl5Dl4ns1KIA0w/s7UdvgRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093725; c=relaxed/simple;
	bh=mNnhPJAapyyr4RDT0jtbXGZxCm63/T95UL3FXMrdnpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0yybp2iKdVJuJER0WoCD+9Mt8QIUIx4ZwZGCEVbA8GRcbQTPeT3NyF4lyYda/xOkiFoXFm84sKeiVzenveCoAqDuVhIK4YnyZ/SPi04ttpCnrVpikSNHNiO1NkSp5qiB9jEQQQ0hrNiXv2nuwnL2760HcYo3wDRCpcg+XNBhIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=2sBnq6cG; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="2sBnq6cG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=iH2ZEHsUjamBdwExE5GRMOAk+r2J6DDZ1dpmVjazrAo=; b=2sBnq6cGYchruqXVlFbFbwclna
	1VyhE7hB1uhT6MeJX/7hkHxuXGchzwgfsTxiBdnNTUaQOgJx18QRoO+9t90nk+ezyLvBGIBm5AYem
	L8UUPSZ7vfnLiLlSKlu+cQt24nSddqEokgOl9Fj/vcVbjJ8HA0cokh2h6mX9RKcNn4av8plhaBdIA
	Sdr4gRcAshmwNlVuAuSRbXb+G8ue56yeurRsQ/k427egOFeGQZ2KlnS9S079swpVEMk01JorhX6WP
	FgCHudhU4eqrgQ+z75k61X2bcLTWc5VRnEf0d/QLSa49MY8P/ShNZ7NrVUsQSpaWM1sTp6mOipxSl
	gIoaf73mqlR+3PMkTjt960n3dps2iHFF4qTR4Z//TlstOsQpkCAKbib8oJ7r6W5rdklCvO3ZAXS9m
	3j/Kar4aL/vLYKICPUzljy3JP7vH5kJsp8S1xRuYmFtH2gk02UnVLUIgJ/APEyO8fw8rqBq2aOYFm
	C2AJzYzBMknY6UbYT6lwnBYy;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxMW-00FdKc-2M;
	Tue, 25 Nov 2025 18:02:01 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 051/145] smb: smbdirect: introduce smbdirect_socket_shutdown()
Date: Tue, 25 Nov 2025 18:54:57 +0100
Message-ID: <25196e76808d60743066111698e7499075139dbd.1764091285.git.metze@samba.org>
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

This can be used by client and server to trigger a
disconnect of the connection, the idea of to be
similar to kernel_sock_shutdown(), but for smbdirect
there's no point in shutting down only one direct
so there's no 'how' argument.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smbdirect/smbdirect_socket.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/common/smbdirect/smbdirect_socket.c
index b0079c1f59aa..ed82238c76c0 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.c
+++ b/fs/smb/common/smbdirect/smbdirect_socket.c
@@ -431,6 +431,12 @@ static void smbdirect_socket_destroy_sync(struct smbdirect_socket *sc)
 		SMBDIRECT_DEBUG_ERR_PTR(sc->first_error));
 }
 
+__maybe_unused /* this is temporary while this file is included in others */
+static void smbdirect_socket_shutdown(struct smbdirect_socket *sc)
+{
+	smbdirect_socket_schedule_cleanup(sc, -ESHUTDOWN);
+}
+
 __maybe_unused /* this is temporary while this file is included in others */
 static int smbdirect_socket_wait_for_credits(struct smbdirect_socket *sc,
 					     enum smbdirect_socket_status expected_status,
-- 
2.43.0

