Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C3316EB42
	for <linux-cifs@vger.kernel.org>; Mon, 10 Nov 2025 15:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762788257; cv=none; b=cD94hnOgTimMNiFDuY96lY9qBRlOUwHrdbNcsm5+TKsfhPL1nyf7ACabv9oUKGBRy2oTzVvCoSkSL/SaI5pTbBQ/NgMIfXr0wtT+wJqLIQIqi8UNbhErJxvPM3NRrTrJd4E4gU9qzQ0Phe6scFtClFYuHH1Ruk13h21Xo/2kD90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762788257; c=relaxed/simple;
	bh=G/VRAG9g0Ztv3aafyWQWdMl197i8AoxSVhas5/vO+Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FWtld7iUYtW7v8fHDnaxs+jg5D9aH3pczMO2iolOZ0WVy/g3xczfad+fzyOSDpu99CqPUsu9lxyPVowzO3IZVh4+9qoAAreRO//SBt5u32bjm/q29/attG9/ThqxdPdJb/nxxPT8HY7rIEE9qN0JaQfRacClcItH+fUr4FA3AgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=bWoEr8S8; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="bWoEr8S8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=6Pa9Hl/4tOLCprUapP9WVXeDGypM1kLq6H31y5mWsHI=; b=bWoEr8S8bHOtkjRF3+AcelyRiL
	0EZLprT/nGbehmlgIL8F6hP25bHDcoW6RfRE84T1PrRgDHTZG+Rtgd0q3/NnYwJAahun5nYUXj4MV
	Y7HcaFiy1KZ+DOdt2z1UAAFt0fodCAp3fAqXMN5+Iavoh/OgDoU6Onls2h4cscygeTCZFYFpJgEWl
	RmH8zw8roY82aYBSpDpqWGf+zQHo/1hk5nog2cakMX5oijMchjPNIa/L4hfMy0SKHvgjLzYcWqc87
	3dtwXbpOUxsRjGJHN71rO2Ez8gkwFMu4UgC55lsU63su/gFbuSPRiWULH632mkbkkheMVkz1lsCHm
	MDczoddXjPNjuibMblGjakwgkrEhyYEe3tggQRbPJmFvkWG2LJiFDyNMi20G/L65zKL4nQJXh3WQm
	YP/9//9ZxXGdHTQOkWk6xR5sgoyZrPc5W8BZFCJ5MQXVwI7wBLrMAw4Wk3KYbeXoHACwv6ROQlsXk
	eJHMHFghfkbnih2/W+rqXBF0;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vITkS-00DTEX-1m;
	Mon, 10 Nov 2025 15:24:04 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] smb: client: let smbd_disconnect_rdma_connection() turn CREATED into DISCONNECTED
Date: Mon, 10 Nov 2025 16:23:52 +0100
Message-ID: <20251110152352.2889115-1-metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When smbd_disconnect_rdma_connection() turns SMBDIRECT_SOCKET_CREATED
into SMBDIRECT_SOCKET_ERROR, we'll have the situation that
smbd_disconnect_rdma_work() will set SMBDIRECT_SOCKET_DISCONNECTING
and call rdma_disconnect(), which likely fails as we never reached
the RDMA_CM_EVENT_ESTABLISHED. it means that
wait_event(sc->status_wait, sc->status == SMBDIRECT_SOCKET_DISCONNECTED)
in smbd_destroy() will hang forever in SMBDIRECT_SOCKET_DISCONNECTING
never reaching SMBDIRECT_SOCKET_DISCONNECTED.

So we directly go from SMBDIRECT_SOCKET_CREATED to
SMBDIRECT_SOCKET_DISCONNECTED.

Fixes: ffbfc73e84eb ("smb: client: let smbd_disconnect_rdma_connection() set SMBDIRECT_SOCKET_ERROR...")
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 85a4c55b61b8..c6c428c2e08d 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -290,6 +290,9 @@ static void smbd_disconnect_rdma_connection(struct smbdirect_socket *sc)
 		break;
 
 	case SMBDIRECT_SOCKET_CREATED:
+		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
+		break;
+
 	case SMBDIRECT_SOCKET_CONNECTED:
 		sc->status = SMBDIRECT_SOCKET_ERROR;
 		break;
-- 
2.43.0

