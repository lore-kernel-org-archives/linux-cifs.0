Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6456C37A3AA
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744433; cv=none; b=FLalkj2dtGW0BrbZR/9XuYxsIAljHX2E75/urjhIX+ffUdza5Z+ZUXRNaOgaa+efJfuVCixueSQf18ZR/OaTdfVb6b3x3AvcELMYLd0SzYcFSShnJ9DT1zr18Ui2f+6OlGHckmheQr2AvX4Ibk4S4XEqMpwBNf3ric3AOuy9nYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744433; c=relaxed/simple;
	bh=BTjGrykZs7IzT2RCTp6lwgIz6IH0ZFL+oc90IHgdJ7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYOpwiuL6krk1DbiB4b7QSoeozqtEPurJtlwKqdDj4x/ozImb75wSmcMKIlKR3IIroDLqQgV1xXi4DpRjocVF9ov6OUtzlWl1F+N/ZTYuDgpr4WDDJzJjHZ0snWCGV6f1kyOeRlJ26B34J4/1fmJrvKAUnZgCNuoT4IRa0h+bws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=uzLCT5KO; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="uzLCT5KO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=5SnSj2eQcuRm+P36UsJW55o8k1/pIVpEPVCSUniMkoE=; b=uzLCT5KOlSxl8xex2LIczxlqoh
	qSNTvQG39dPwguPVEyu+8IqnpIzCaFfTI3QKjbifvmUrrurItOcwzAv1OhEQiKIDvIwhVNlHq/PSS
	86z9ffC0MrjlsMlYu7mlU4OeVZuOiCsgpp5TZL1UiNdCEdatfNCIurFIYPiI9Rkv1Jbx6oKZBQh4z
	foFjCi9X8Q+d0hfO1oSqeJRlf9hul3YOggMGCtYN51oLBqSkNAie+fwCuqByxN574tgp1vrvAM+5q
	W1P9Sj1UixcyFbIuUWOh3MD5vOSIXtg6EgbQCGpyPYkVccUQDPKD/Wo59cGG7Npynws40cjbHnexS
	mX2J9+xRGmxNzSEscZ/fNkafbfKA/HxPTzERBvpf69hOG1akbRJoILJtTUpQ409Jzmzate3aaQhDN
	LqA8ugITrkBn2iyE4/8EaJzpBOhFFB+ZY9NRPP38AhrOb9n92hpdp6AxtrtIWbhjIShuRPs8hMOID
	miLlHg622Gr6H8inNFUJA2Fs;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Ci-00BbtV-1X;
	Wed, 29 Oct 2025 13:27:08 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 047/127] smb: smbdirect: introduce smbdirect_connection_is_connected()
Date: Wed, 29 Oct 2025 14:20:25 +0100
Message-ID: <28f7953cda95a9162ec7ae7ac146959f77e103d4.1761742839.git.metze@samba.org>
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

This is a simple way to check is the connection is still ok
without the need to know internals of struct smbdirect_socket.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect_connection.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 858b071ba1bb..1487efbe7620 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -900,6 +900,14 @@ static void smbdirect_connection_disconnect_work(struct work_struct *work)
 	smbdirect_connection_wake_up_all(sc);
 }
 
+__maybe_unused /* this is temporary while this file is included in orders */
+static bool smbdirect_connection_is_connected(struct smbdirect_socket *sc)
+{
+	if (unlikely(!sc || sc->first_error || sc->status != SMBDIRECT_SOCKET_CONNECTED))
+		return false;
+	return true;
+}
+
 __maybe_unused /* this is temporary while this file is included in orders */
 static int smbdirect_connection_wait_for_connected(struct smbdirect_socket *sc)
 {
-- 
2.43.0

