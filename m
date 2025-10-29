Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E9D224B15
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744438; cv=none; b=a5u7i6HdW+sGHMAHRvc1gawKxKwwl82uK6ip2mWabhOWtNmIxyGVEZPAFWHtP47iUSWjyJLlW6AiJafFJEXn8Wglgf/tlD3/i0rYMlV9EabNtk2zxF1EpO3H3z/E4Sr6SFC9n5HzIFW0alk3h7zzztsz9L3FGnxBfc5X7KbnTtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744438; c=relaxed/simple;
	bh=HPOONTvFsqKBpVUXna/EUOQo821DpK+M1b1f8a/ewe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NekkPvQ2gLBTd0WT8V0UVf+bli2w8bcdHmMyeQ/yTG3nib53eOeQZhFiX0ANGj37Z/PeF8iHrU301c/jwLU6V3jT2yVDD1ADS72q+GnZZt9F/pPsEu2qejwbHKBs6SB7UUsqKekfmN2WtOmIeJN60UTUMnVxuNelDmtzZv1tVxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=zQt6vIUT; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="zQt6vIUT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=es2jaFA4hWzXp2s1/zltWKFmmsKGJNoXYMYWFZDIWds=; b=zQt6vIUT04zFuqAkTbCGqCFXi+
	LHZCkIqCdHvSAg47FGonUwkOa/npBj6//MEQhtHPlbXdaXCQJIOt8nQUeyJDLKKSsnYgkDW/2J7I9
	TKeGPmpJjslAaG4L1lM8w76Eljn64YYAVe3oWzjLXXSW05esstP5vU8SVZEJH9LouZ99WPoEYSAt/
	Q5ay6ELCoEtIClrEuIqASt8sb+UdxQfnINzQFits2q5H9c5gKmJNDIy76/IAsuauUup2ZGm8FwkUX
	D8mZWdTgLOAfhICHU4AfsTqv67Esj7ppRDI+om9kC9ynB/UBi6zKe2w7SQrZdIkmpvru4TvOZi7IP
	S6rF17Nta1f/JSWvjqJkQDNMCLkhbdakksjfsAftq2PVU898CLAcmHyZQRkwGVTteViyl/r5Dd+8w
	Rijc9RE45bERtihpY4rKQlYFbMnrew+orT/KGLWJNkwS8A6CO4/l8Nk7ILPwe06W/bgXqrRQgAqyU
	XntFoJWbmQjPJleza417T13G;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Co-00BbuZ-0P;
	Wed, 29 Oct 2025 13:27:14 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 048/127] smb: smbdirect: introduce smbdirect_socket_shutdown()
Date: Wed, 29 Oct 2025 14:20:26 +0100
Message-ID: <84a38bb78cf7f7ca48d54242b1d06f5f181010cb.1761742839.git.metze@samba.org>
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
---
 fs/smb/common/smbdirect/smbdirect_connection.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 1487efbe7620..5670e442e129 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -1100,6 +1100,12 @@ static void smbdirect_connection_destroy_sync(struct smbdirect_socket *sc)
 		SMBDIRECT_DEBUG_ERR_PTR(sc->first_error));
 }
 
+__maybe_unused /* this is temporary while this file is included in orders */
+static void smbdirect_socket_shutdown(struct smbdirect_socket *sc)
+{
+	smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
+}
+
 static void smbdirect_connection_idle_timer_work(struct work_struct *work)
 {
 	struct smbdirect_socket *sc =
-- 
2.43.0

