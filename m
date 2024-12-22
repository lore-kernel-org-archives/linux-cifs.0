Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0774116BE3A;
	Sun, 22 Dec 2024 16:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734885098; cv=none; b=N6W8k9w2+v6wlO5tXjjhbF7GtJrhFWAG7QsHSJqWKOEE4CULf0uSbMKGZnD6w2WLYNsj9CMVqZmEz9CTazppL7R6K24PlVdmpZgZ4n9e9haV1lm67HmWTN3IMF3RSFlzK6zDdaVFm0WNBQ8c8tA0pzgYEWbB3G/Egf+RyDnYHDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734885098; c=relaxed/simple;
	bh=niPFbWXtqM9OfYghrmofmbZBuIsFf29aqObb4aYx3F4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RsTwxSkyOZuMmAnmE1doCgbb/twXD3a6G6+XJf80vxhRrAySR86/x6OPf6z164cGvIf1t+WElXnKtd6VBm+CAkUXGrZIAxsdbl4mt7S1sY44OhZa8YUbNq8emJ83hOVEUNUZ4FRaXAZxM3h143V+stMlrYU36QlJWXaoKgQW3Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VFj9GRmN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VFj9GRmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C230C4CECD;
	Sun, 22 Dec 2024 16:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734885097;
	bh=niPFbWXtqM9OfYghrmofmbZBuIsFf29aqObb4aYx3F4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VFj9GRmNFktnbNlbX3qvhKpY0/PQXSf7vVHIgo+dbyzXNrFRoyfaET5IvRb0zzbqX
	 fyMqET6VDizVT2ud0wyTQfU0Dv2076AYjqqx8LuNtxEGrxp3RtqSYX5b/2OIJnQIge
	 IeVI0CeaZgpdA9WOwaAteeqdnOiYzzvUP50lmSCwXcQcR1eX5C6x5r+GMgRKBS9+Sn
	 knB6/kcDRtimL3eUgbLv6gkzedhHY/y4Efcs090jLexf6MfZmh4t7QJVMJshTwUpA3
	 aPZ0E9RdMoEv3SEpLxtrU/tG8QcQFd00M3Q0pOpg02zX+UPT4Qx3SUOgSrFrEUK/zI
	 LIo+y0dbV0YHA==
Received: by pali.im (Postfix)
	id 2FEF1B9A; Sun, 22 Dec 2024 17:31:27 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] cifs: Fix establishing NetBIOS session for SMB2+ connection
Date: Sun, 22 Dec 2024 17:30:46 +0100
Message-Id: <20241222163050.24359-3-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241222163050.24359-1-pali@kernel.org>
References: <20241222163050.24359-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Function ip_rfc1001_connect() which establish NetBIOS session for SMB
connections, currently uses smb_send() function for sending NetBIOS Session
Request packet. This function expects that the passed buffer is SMB packet
and for SMB2+ connections it mangles packet header, which breaks prepared
NetBIOS Session Request packet. Result is that this function send garbage
packet for SMB2+ connection, which SMB2+ server cannot parse. That function
is not mangling packets for SMB1 connections, so it somehow works for SMB1.

Fix this problem and instead of smb_send(), use smb_send_kvec() function
which does not mangle prepared packet, this function send them as is. Just
API of this function takes struct msghdr (kvec) instead of packet buffer.

[MS-SMB2] specification allows SMB2 protocol to use NetBIOS as a transport
protocol. NetBIOS can be used over TCP via port 139. So this is a valid
configuration, just not so common. And even recent Windows versions (e.g.
Windows Server 2022) still supports this configuration: SMB over TCP port
139, including for modern SMB2 and SMB3 dialects.

This change fixes SMB2 and SMB3 connections over TCP port 139 which
requires establishing of NetBIOS session. Tested that this change fixes
establishing of SMB2 and SMB3 connections with Windows Server 2022.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsproto.h |  3 +++
 fs/smb/client/connect.c   | 20 +++++++++++++++-----
 fs/smb/client/transport.c |  2 +-
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 5aa2769a42f3..f0ca99e6090c 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -31,6 +31,9 @@ extern void cifs_small_buf_release(void *);
 extern void free_rsp_buf(int, void *);
 extern int smb_send(struct TCP_Server_Info *, struct smb_hdr *,
 			unsigned int /* length */);
+extern int smb_send_kvec(struct TCP_Server_Info *server,
+			 struct msghdr *msg,
+			 size_t *sent);
 extern unsigned int _get_xid(void);
 extern void _free_xid(unsigned int);
 #define get_xid()							\
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 9cbfdc31cdda..812487325bc7 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3059,8 +3059,10 @@ ip_rfc1001_connect(struct TCP_Server_Info *server)
 	 * sessinit is sent but no second negprot
 	 */
 	struct rfc1002_session_packet req = {};
-	struct smb_hdr *smb_buf = (struct smb_hdr *)&req;
+	struct msghdr msg = {};
+	struct kvec iov = {};
 	unsigned int len;
+	size_t sent;
 
 	req.trailer.session_req.called_len = sizeof(req.trailer.session_req.called_name);
 
@@ -3089,10 +3091,18 @@ ip_rfc1001_connect(struct TCP_Server_Info *server)
 	 * As per rfc1002, @len must be the number of bytes that follows the
 	 * length field of a rfc1002 session request payload.
 	 */
-	len = sizeof(req) - offsetof(struct rfc1002_session_packet, trailer.session_req);
+	len = sizeof(req.trailer.session_req);
+	req.type = RFC1002_SESSION_REQUEST;
+	req.flags = 0;
+	req.length = cpu_to_be16(len);
+	len += offsetof(typeof(req), trailer.session_req);
+	iov.iov_base = &req;
+	iov.iov_len = len;
+	iov_iter_kvec(&msg.msg_iter, ITER_SOURCE, &iov, 1, len);
+	rc = smb_send_kvec(server, &msg, &sent);
+	if (rc < 0 || len != sent)
+		return (rc == -EINTR || rc == -EAGAIN) ? rc : -ECONNABORTED;
 
-	smb_buf->smb_buf_length = cpu_to_be32((RFC1002_SESSION_REQUEST << 24) | len);
-	rc = smb_send(server, smb_buf, len);
 	/*
 	 * RFC1001 layer in at least one server requires very short break before
 	 * negprot presumably because not expecting negprot to follow so fast.
@@ -3101,7 +3111,7 @@ ip_rfc1001_connect(struct TCP_Server_Info *server)
 	 */
 	usleep_range(1000, 2000);
 
-	return rc;
+	return 0;
 }
 
 static int
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 0dc80959ce48..03434dbe9374 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -179,7 +179,7 @@ delete_mid(struct mid_q_entry *mid)
  * Our basic "send data to server" function. Should be called with srv_mutex
  * held. The caller is responsible for handling the results.
  */
-static int
+int
 smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
 	      size_t *sent)
 {
-- 
2.20.1

