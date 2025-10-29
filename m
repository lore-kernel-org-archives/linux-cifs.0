Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6B633F37B
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744211; cv=none; b=N8etDasKLZyWHKrmbWZwlPvTXR/3EKVPCOH3sQO/SlvrIIDVK1vH+i4U8TE0Fk77pXMzSE0y2kMDkU7jZE4GEsZ4MSBWN1585TPR7uSgRJiSJQS6ImkTlf3wIMVmEoJ0VNkqTDYrypJeQIJHgC9si5W5rXLzj7g5eMQ9KgSocx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744211; c=relaxed/simple;
	bh=ujGuoJpudibEqLGUtPnmIMKJz7yzTuV+oeE4bLQQQnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kWtlFa3ZFJ0uVyy8noocEfs1IBQHAM91gu2kSUXY171taR2LsjE/N/9hXvSzKAlWNvaZG2j0DqBMsx7iHAAra1UXZMZlZfiPOBhxtYItgPz4C/YrfDiFFtWUaIM0+85FAG7Xy1zTYfarwPWsvNh4BMN9aHhiSnTpAaDKUDRWcm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=GxGsG+TM; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="GxGsG+TM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=fvAVhMdelIY9T7TRI4LhOyzPl3HJn4mqaGgqZPl2kus=; b=GxGsG+TMWr+vz0HwzumHJziE1Y
	jmIh88rt9+cZWvEFha6Z7RzJY+CqJJ2eXtDicy1zYZIz1FpgcFwXByMcnTZcXa7YyT1IIze4bn5tQ
	MK/sVVwfsESirJfJNhR/rlpAep6dpmag/sIl73rZlI2oo23ypLsfDAQz3wEzCqurYZXwfxRprUnAn
	2dZ7VfztCjYVWSETBpQppcdQ5s+JY/zBD9jWOCVe/7IsaLMrYuqXgcTcVPO3DtSVFUqB15O2tXj6v
	JRnFF/4cx5e/d0rRmMs5Bx2SVQOFrXcJkr9hy4/Wedy5RGLYpYXwa/EJKNtj8kCJ1KOJYvqRjcUHK
	fy21/gIPvACw/1LoKb5rUdO4aSFh0qne+id/WdYZf/XmyEBxFcOcVL4M/0xy6pb40pD5ouJMPmj+r
	pC1LtHazSrTLSuqFo3YD0g3l99sQ0e17eLBYB5bk39pWiO0XuteGh9wzquEVrfEd1AicqhlT5oZBZ
	N1ZG8dxppk9ZpAa9SpMhUNKY;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE698-00BbIE-0x;
	Wed, 29 Oct 2025 13:23:26 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 009/127] smb: smbdirect: introduce smbdirect_socket_set_logging()
Date: Wed, 29 Oct 2025 14:19:47 +0100
Message-ID: <8d0f8874c14d3775a407726e951f40ea4ebd7515.1761742839.git.metze@samba.org>
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

This will be used by client and server in order to setup
their own logging functions.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 .../common/smbdirect/smbdirect_connection.c   | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index ca6508705be8..f7fc4b1732c4 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -24,3 +24,23 @@ static void smbdirect_socket_prepare_create(struct smbdirect_socket *sc,
 	 */
 	sc->workqueue = workqueue;
 }
+
+__maybe_unused /* this is temporary while this file is included in orders */
+static void smbdirect_socket_set_logging(struct smbdirect_socket *sc,
+					 void *private_ptr,
+					 bool (*needed)(struct smbdirect_socket *sc,
+							void *private_ptr,
+							unsigned int lvl,
+							unsigned int cls),
+					 void (*vaprintf)(struct smbdirect_socket *sc,
+							  const char *func,
+							  unsigned int line,
+							  void *private_ptr,
+							  unsigned int lvl,
+							  unsigned int cls,
+							  struct va_format *vaf))
+{
+	sc->logging.private_ptr = private_ptr;
+	sc->logging.needed = needed;
+	sc->logging.vaprintf = vaprintf;
+}
-- 
2.43.0

