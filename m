Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7502119;
	Wed,  1 Jan 2025 13:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735736962; cv=none; b=TWcvGiywIWuYlWplPhvPGgY1m4p+2zDwAy8iNbBXKn562D1Ya/fsZZt1amxa/B2aY6sXk12FkN+sWNFtHAjaf5rRJeaTGj8+T0cbQX4rRGaYKlVKhm4zzZeBq/zt0kvcRNHJKfF/lsrnxYef2qEl8OVsUHgaJ7jOl0oG+/9edHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735736962; c=relaxed/simple;
	bh=BNVwtbOyUhp7c6NZcCDqIDu9h8NZS8dM/pr8tkCpEtQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=rsF0E99CbvKMmZy/AXlw+cXnmVmulWdyymlQ+dhSnJY3nwTwWFvKZVO0BHQEXnC2bn0UNx8ZiYVtxslxdKuCB4hIMeb7gO0SJ6ioqyNezuTncM0cvZWFZODEg0rJxs2EzUs5Pnf0KGDpoKv12NNRl0pe6jRNDZ3O2IZdDs9upzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fCrhijPG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fCrhijPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D259EC4CED1;
	Wed,  1 Jan 2025 13:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735736962;
	bh=BNVwtbOyUhp7c6NZcCDqIDu9h8NZS8dM/pr8tkCpEtQ=;
	h=From:To:Cc:Subject:Date:From;
	b=fCrhijPGQuelKT5NjfRJUFzyvN7NBfNn/3NbI9OA2Ae0ZixWr3YgC5YkK0QcegAS/
	 tCsQM6ElnQEOhCf1J06kvW/Cw59nVqL7b6nB+EjOe5ishuK/rVBXoNEgfdcaQDYOP/
	 ScB2vxObe+p7NtCN8qwag5hXCJmwxhoS0i3FYIg928VJ482hHoq0wYsg9c7WxniqcN
	 0y3Z1G7AO3c+A/hslaYDDq8beBkAlN9lZevwCg8x0mn+2kscOCvkGl/+Cf6RQtkpMC
	 D1L6OkOwX73EvjZojMjdUt7fRxvPmpmPQsQyUKX7SkzrOMcNrJmUSisM8nTgHLTw0D
	 RL9tU41hWW5RQ==
Received: by pali.im (Postfix)
	id 4BEF2768; Wed,  1 Jan 2025 14:09:11 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Correctly set SMB1 SessionKey field in Session Setup Request
Date: Wed,  1 Jan 2025 14:07:34 +0100
Message-Id: <20250101130734.19846-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

[MS-CIFS] specification in section 2.2.4.53.1 where is described
SMB_COM_SESSION_SETUP_ANDX Request, for SessionKey field says:

    The client MUST set this field to be equal to the SessionKey field in
    the SMB_COM_NEGOTIATE Response for this SMB connection.

Linux SMB client currently set this field to zero. This is working fine
against Windows NT SMB servers thanks to [MS-CIFS] product behavior <94>:

    Windows NT Server ignores the client's SessionKey.

For compatibility with [MS-CIFS], set this SessionKey field in Session
Setup Request to value retrieved from Negotiate response.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsglob.h | 1 +
 fs/smb/client/cifspdu.h  | 6 +++---
 fs/smb/client/cifssmb.c  | 1 +
 fs/smb/client/sess.c     | 1 +
 4 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 82e819f9d24e..4cbf119af4e0 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -773,6 +773,7 @@ struct TCP_Server_Info {
 	char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
 	__u32 sequence_number; /* for signing, protected by srv_mutex */
 	__u32 reconnect_instance; /* incremented on each reconnect */
+	__le32 session_key_id; /* retrieved from negotiate response and send in session setup request */
 	struct session_key session_key;
 	unsigned long lstrp; /* when we got last response from this server */
 	struct cifs_secmech secmech; /* crypto sec mech functs, descriptors */
diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index fd114fcb1320..6ae9f045ad89 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -601,7 +601,7 @@ typedef union smb_com_session_setup_andx {
 		__le16 MaxBufferSize;
 		__le16 MaxMpxCount;
 		__le16 VcNumber;
-		__u32 SessionKey;
+		__le32 SessionKey;
 		__le16 SecurityBlobLength;
 		__u32 Reserved;
 		__le32 Capabilities;	/* see below */
@@ -620,7 +620,7 @@ typedef union smb_com_session_setup_andx {
 		__le16 MaxBufferSize;
 		__le16 MaxMpxCount;
 		__le16 VcNumber;
-		__u32 SessionKey;
+		__le32 SessionKey;
 		__le16 CaseInsensitivePasswordLength; /* ASCII password len */
 		__le16 CaseSensitivePasswordLength; /* Unicode password length*/
 		__u32 Reserved;	/* see below */
@@ -658,7 +658,7 @@ typedef union smb_com_session_setup_andx {
 		__le16 MaxBufferSize;
 		__le16 MaxMpxCount;
 		__le16 VcNumber;
-		__u32 SessionKey;
+		__le32 SessionKey;
 		__le16 PasswordLength;
 		__u32 Reserved; /* encrypt key len and offset */
 		__le16 ByteCount;
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 9dc946138f18..b76e3248a39d 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -481,6 +481,7 @@ CIFSSMBNegotiate(const unsigned int xid,
 	server->max_rw = le32_to_cpu(pSMBr->MaxRawSize);
 	cifs_dbg(NOISY, "Max buf = %d\n", ses->server->maxBuf);
 	server->capabilities = le32_to_cpu(pSMBr->Capabilities);
+	server->session_key_id = pSMBr->SessionKey;
 	server->timeAdj = (int)(__s16)le16_to_cpu(pSMBr->ServerTimeZone);
 	server->timeAdj *= 60;
 
diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index b0ee44e9a3d9..af4884952186 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -646,6 +646,7 @@ static __u32 cifs_ssetup_hdr(struct cifs_ses *ses,
 					USHRT_MAX));
 	pSMB->req.MaxMpxCount = cpu_to_le16(server->maxReq);
 	pSMB->req.VcNumber = cpu_to_le16(1);
+	pSMB->req.SessionKey = server->session_key_id;
 
 	/* Now no need to set SMBFLG_CASELESS or obsolete CANONICAL PATH */
 
-- 
2.20.1

