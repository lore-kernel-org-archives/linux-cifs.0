Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F7233B6FC
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744171; cv=none; b=ii2/7rBTXT+04w8/8eSKW72zZPkHtr8UHjetm/pJYi+OvCO/UUpgLOKqB6mMeWoX9CjVAPs/SHzi/2pnrQkWseU44rj0qt+IenbULpfE6V2U3m73bAC/YTYCzvSAbm5orWN3uMntTjTMj55Vwyli4muLpjcTS7J2wejxMj8rF8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744171; c=relaxed/simple;
	bh=xAhdv/SjG1HnfI73+bzNrhLXS/vp+L0LV1n0KhMBjoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noCuRr/Wka5j96SkhNRxOIiKO6OEQ8Rj1PeS4BvJAPW1Z6qhBsfAvGEm/PEtN7TU2UaJZDst4DASnZ7gM5LcJhEhFKc6yeWgHtdUbkTV4puum2FhMQcdtngAB2EEgU8kRl97WT1JXVkKfwquGndRzJmrV1LcYxUMrCsRyAuVrm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Ko41oHq8; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Ko41oHq8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=bHPRqpShbMsgYVZpmuIAVAaARgUCetwqD9ByYTtkEyo=; b=Ko41oHq8KxJHbmsHLcm3/sQRsR
	oXdiXUH5eoUwBrk2rmz35gKDO0MmNoJRjWGoau9TfpIzZk5VWiL4yWfWgvzNvQSajuC0Uae9Z1y6q
	mKOmrs9QrIucIBV3g4VSc5WsyurrFV2szWPQ1+SuJSAKxufBbmI9lCF5Yih3l9eIiHffPgQ4orDJi
	k6lui/QMcIIU2fyjA5EtYdLQWf3pgU9aoANYKcIwsge6gaflFWsQ5R3G/B6kxvhD1Hz5yzDxNuLub
	sQNSLHlKOkD6WUKZHELVWP/u5CV81ny8xmWBivUwk6on7+0QHv/fUZwlXYqMqDf2+gWMnT1OxQha8
	U0DY0aX7vGQnES9F8GkfqJEf7X/TLFxToj4SdX7mTS+qH7Hr4nQC8OStNWPCW+0O7eEyCWVBCcAWC
	zxMBc+Q+9PBdfa3NqZnuOv988qoBRSAngrQZQR8NCGV4HoXzEK1lGGNIKfprR4JDLxlU/217CZJsu
	vJtDDkGHNb2KnCQMMx94h8SV;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE68U-00BbEi-0V;
	Wed, 29 Oct 2025 13:22:46 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 002/127] smb: smbdirect: introduce SMBDIRECT_DEBUG_ERR_PTR() helper
Date: Wed, 29 Oct 2025 14:19:40 +0100
Message-ID: <e3a67cdeb67f13bb80d5b04d1809fd3fd68fd9bb.1761742839.git.metze@samba.org>
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

This can be used like this:

  int err = somefunc();
  pr_warn("err=%1pe\n", SMBDIRECT_DEBUG_ERR_PTR(err));

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_socket.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index ee5a90d691c8..611986827a5e 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -74,6 +74,19 @@ const char *smbdirect_socket_status_string(enum smbdirect_socket_status status)
 	return "<unknown>";
 }
 
+/*
+ * This can be used with %1pe to print errors as strings or '0'
+ * And it avoids warnings like: warn: passing zero to 'ERR_PTR'
+ * from smatch -p=kernel --pedantic
+ */
+static __always_inline
+const void * __must_check SMBDIRECT_DEBUG_ERR_PTR(long error)
+{
+	if (error == 0)
+		return NULL;
+	return ERR_PTR(error);
+}
+
 enum smbdirect_keepalive_status {
 	SMBDIRECT_KEEPALIVE_NONE,
 	SMBDIRECT_KEEPALIVE_PENDING,
-- 
2.43.0

