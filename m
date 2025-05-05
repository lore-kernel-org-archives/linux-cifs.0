Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196D3397A60;
	Mon,  5 May 2025 23:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746486420; cv=none; b=Btuv2+CWEcoN9VHRh7GRBgZTL5Cdl+7+nB2VFV3bEzF6xI7Nko2n14pR5O87aa+MyAuKwlDTx8cHwKeQMR5kXI4TYO72NsuizlkKZSD8jcV44xuCykWYNXUo0GHLXTDy6KVBAh9bZt0a5mnx461ctGPScYALd1SW5kyPQ+hrCa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746486420; c=relaxed/simple;
	bh=NohlARD/kzQF1sDE8ID+pBhuAQcs2l1B8N7z5Av5Ug0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ewD2HFoWh85kRSbPHQiK/fo4P59i57PcsqIw7yarDInd2L689dZqnN5qqrb4/lOnKP2ue/lXefBvwdLfvIuIceC/EpKBH6fFsTEBkpbLZlcXTk25zu712YOT6BMiyZuoXknk71gP+yWiboUhDeF4a+45ojxiYlh4eaz5BwQJji8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lS8Dz/CM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lS8Dz/CM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093EBC4CEE4;
	Mon,  5 May 2025 23:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746486418;
	bh=NohlARD/kzQF1sDE8ID+pBhuAQcs2l1B8N7z5Av5Ug0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lS8Dz/CMg8RmE7CoHka5mJ0XOCz6h+fpcmxxKOKoDaaJ+Hu7I0F/FNIMxJa/kYjt+
	 Ye/EQRHHHtMSvFcEB8pqYk9LPMtrq6D9/DAMEgHt5WQzu1iU9iC2MVCvgIlpWDPJHY
	 D8bk4rBXHiV2y3MSEypskimkk4cFRm1npXwiWpPjqbta5TE47sl92JvdVQdledaKJH
	 LuipHNnaG2I1B/tujpRBlNGC9c9kfUbWe1lkPmzkz3+xY/RtM4RL18H4tS9zVGDoyk
	 AsSkUQnmbT7MgKJ19aqU0yFlxLxgUcm+IKIow4eynnpsQ9JRCrQhzkNfIn556ohmDJ
	 WST3lwxII1JaQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.1 016/212] cifs: Fix establishing NetBIOS session for SMB2+ connection
Date: Mon,  5 May 2025 19:03:08 -0400
Message-Id: <20250505230624.2692522-16-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505230624.2692522-1-sashal@kernel.org>
References: <20250505230624.2692522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.136
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 781802aa5a5950f99899f13ff9d760f5db81d36d ]

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
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsproto.h |  3 +++
 fs/smb/client/connect.c   | 20 +++++++++++++++-----
 fs/smb/client/transport.c |  2 +-
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index d1fd54fb3cc14..9a30425b75a96 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -30,6 +30,9 @@ extern void cifs_small_buf_release(void *);
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
index 0baa64c48c3d1..76c04c4ed45fc 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2966,8 +2966,10 @@ ip_rfc1001_connect(struct TCP_Server_Info *server)
 	 * sessinit is sent but no second negprot
 	 */
 	struct rfc1002_session_packet req = {};
-	struct smb_hdr *smb_buf = (struct smb_hdr *)&req;
+	struct msghdr msg = {};
+	struct kvec iov = {};
 	unsigned int len;
+	size_t sent;
 
 	req.trailer.session_req.called_len = sizeof(req.trailer.session_req.called_name);
 
@@ -2996,10 +2998,18 @@ ip_rfc1001_connect(struct TCP_Server_Info *server)
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
@@ -3008,7 +3018,7 @@ ip_rfc1001_connect(struct TCP_Server_Info *server)
 	 */
 	usleep_range(1000, 2000);
 
-	return rc;
+	return 0;
 }
 
 static int
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 3fdafb9297f13..d2867bd263c55 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -178,7 +178,7 @@ delete_mid(struct mid_q_entry *mid)
  * Our basic "send data to server" function. Should be called with srv_mutex
  * held. The caller is responsible for handling the results.
  */
-static int
+int
 smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
 	      size_t *sent)
 {
-- 
2.39.5

