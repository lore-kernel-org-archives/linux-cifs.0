Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E12918BB9C;
	Sun, 22 Dec 2024 16:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734885098; cv=none; b=QrO28nTW6uTHkKGr7cVza5DfsOX/PjcliPytIXFT/yk1MxIVY1+VMICfkW+eurc/rneRtqmNrKbOMN6hqE8xajNuJhwEIwdbwuJORF+9aLyz4Hq7P+8bZEFnN9CeFOnK7BFHBcE9UWezwyjg7aKectFt7518cOUZLnIgxpEcJ9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734885098; c=relaxed/simple;
	bh=BKn6qJJyEh7iZf6t/GAlhryB7fb7xvjVO94LMY4hvcE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XxtaERHbAYUuzcDHt6f1rGmesEY3uwmLEbojt1owSE29lK9G1qmKuIS8ofdRmhXijznsCzrKR5pWt+N2LBJjAmbe0IA8vkPk97syAklJvY/cjVRaG1OoDbiKHTAZCgnY9NWscY+Lpxzhbqj2qt5AacRHn2gJSuZ+2O15LYVLhMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MKeSM2OZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MKeSM2OZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624C3C4CEDE;
	Sun, 22 Dec 2024 16:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734885097;
	bh=BKn6qJJyEh7iZf6t/GAlhryB7fb7xvjVO94LMY4hvcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MKeSM2OZNZE/NDBvCU4R++8n0qItHveSDZlcw5WTGHLUWOpgalkplU0N1zUAhjMU+
	 yhR70HkbmFbWkcx6O6QT2uvHOIDhRWXoo8X/nhUOygrrSlRPx67xVH4DlmBVa9tXWY
	 9ar3d7YWzdfB8S0HffLJbZr1WR9yVUPn/3J8vLRf7L2mXj8wnwQd3PrVvfEVp5GaZy
	 jrEGJQcYC/l3c7tiU2C2AAF2VdH7c5NQF+HcD9pT9GgVgiwGCfIf6NYsT1ReppihOH
	 rVzDoB27oApcnTt4heXAmj/yb23J5ilYdonIHWZPeJDwTrQmBujSvOQ/F4o8u5aJZu
	 TRaOWw2d/Pu0Q==
Received: by pali.im (Postfix)
	id 5A7E5D48; Sun, 22 Dec 2024 17:31:27 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] cifs: Improve establishing SMB connection with NetBIOS session
Date: Sun, 22 Dec 2024 17:30:47 +0100
Message-Id: <20241222163050.24359-4-pali@kernel.org>
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

Function ip_rfc1001_connect() send NetBIOS session request but currently
does not read response. It even does not wait for the response. Instead it
just calls usleep_range(1000, 2000) and explain in comment that some
servers require short break before sending SMB negotiate packet. Response
is later handled in generic is_smb_response() function called from
cifs_demultiplex_thread().

That comment probably refers to the old DOS SMB server which cannot process
incoming SMB negotiate packet if it has not sent NetBIOS session response
packet. Note that current sleep timeout is too small when trying to
establish connection to DOS SMB server running in qemu virtual machine
connected over qemu user networking with guestfwd netcat options. So that
usleep_range() call is not useful at all.

NetBIOS session response packet contains useful error information, like
the server name specified NetBIOS session request packet is incorrect.
Old Windows SMB servers and even the latest SMB server on the latest
Windows Server 2022 version requires that the name is the correct server
name, otherwise they return error RFC1002_NOT_PRESENT. This applies for all
SMB dialects (old SMB1, and also modern SMB2 and SMB3).

Therefore read the reply of NetBIOS session request and implement parsing
of the reply. Log received error to dmesg to help debugging reason why
connection was refused. Also convert NetBIOS error to useful errno.

Note that ip_rfc1001_connect() function is used only when doing connection
over port 139. So the common SMB scenario over port 445 is not affected by
this change at all.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/connect.c | 137 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 134 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 812487325bc7..ac2e5e1d23b1 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3049,6 +3049,44 @@ bind_socket(struct TCP_Server_Info *server)
 	return rc;
 }
 
+static int
+smb_recv_kvec(struct TCP_Server_Info *server, struct msghdr *msg, size_t *recv)
+{
+	int rc = 0;
+	int retries = 0;
+	int msg_flags = server->noblocksnd ? MSG_DONTWAIT : 0;
+
+	*recv = 0;
+
+	while (msg_data_left(msg)) {
+		rc = sock_recvmsg(server->ssocket, msg, msg_flags);
+		if (rc == -EAGAIN) {
+			retries++;
+			if (retries >= 14 ||
+			    (!server->noblocksnd && (retries > 2))) {
+				cifs_server_dbg(VFS, "sends on sock %p stuck for 15 seconds\n",
+						server->ssocket);
+				return -EAGAIN;
+			}
+			msleep(1 << retries);
+			continue;
+		}
+
+		if (rc < 0)
+			return rc;
+
+		if (rc == 0) {
+			cifs_dbg(FYI, "Received no data (TCP RST)\n");
+			return -ECONNABORTED;
+		}
+
+		/* recv was at least partially successful */
+		*recv += rc;
+		retries = 0; /* in case we get ENOSPC on the next send */
+	}
+	return 0;
+}
+
 static int
 ip_rfc1001_connect(struct TCP_Server_Info *server)
 {
@@ -3059,10 +3097,12 @@ ip_rfc1001_connect(struct TCP_Server_Info *server)
 	 * sessinit is sent but no second negprot
 	 */
 	struct rfc1002_session_packet req = {};
+	struct rfc1002_session_packet resp = {};
 	struct msghdr msg = {};
 	struct kvec iov = {};
 	unsigned int len;
 	size_t sent;
+	size_t recv;
 
 	req.trailer.session_req.called_len = sizeof(req.trailer.session_req.called_name);
 
@@ -3106,10 +3146,101 @@ ip_rfc1001_connect(struct TCP_Server_Info *server)
 	/*
 	 * RFC1001 layer in at least one server requires very short break before
 	 * negprot presumably because not expecting negprot to follow so fast.
-	 * This is a simple solution that works without complicating the code
-	 * and causes no significant slowing down on mount for everyone else
+	 * For example DOS SMB servers cannot process negprot if it was received
+	 * before the server sent response for SESSION_REQUEST packet. So, wait
+	 * for the response, read it and parse it as it can contain useful error
+	 * information (e.g. specified server name was incorrect). For example
+	 * even the latest Windows Server 2022 SMB1 server over port 139 send
+	 * error if its server name was in SESSION_REQUEST packet incorrect.
+	 * Nowadays usage of port 139 is not common, so waiting for reply here
+	 * does not slowing down mounting of common case (over port 445).
 	 */
-	usleep_range(1000, 2000);
+	len = offsetof(typeof(resp), trailer);
+	iov.iov_base = &resp;
+	iov.iov_len = len;
+	iov_iter_kvec(&msg.msg_iter, ITER_DEST, &iov, 1, len);
+	rc = smb_recv_kvec(server, &msg, &recv);
+	if (rc < 0 || recv != len)
+		return (rc == -EINTR || rc == -EAGAIN) ? rc : -ECONNABORTED;
+
+	switch (resp.type) {
+	case RFC1002_POSITIVE_SESSION_RESPONSE:
+		if (be16_to_cpu(resp.length) != 0) {
+			cifs_dbg(VFS, "RFC 1002 positive session response but with invalid non-zero length %u\n",
+				 be16_to_cpu(resp.length));
+			return -EIO;
+		}
+		cifs_dbg(FYI, "RFC 1002 positive session response");
+		break;
+	case RFC1002_NEGATIVE_SESSION_RESPONSE:
+		/* Read RFC1002 response error code and convert it to errno in rc */
+		len = sizeof(resp.trailer.neg_ses_resp_error_code);
+		iov.iov_base = &resp.trailer.neg_ses_resp_error_code;
+		iov.iov_len = len;
+		iov_iter_kvec(&msg.msg_iter, ITER_DEST, &iov, 1, len);
+		if (be16_to_cpu(resp.length) == len &&
+		    smb_recv_kvec(server, &msg, &recv) == 0 &&
+		    recv == len) {
+			cifs_dbg(VFS, "RFC 1002 negative session response with error 0x%x\n",
+				 resp.trailer.neg_ses_resp_error_code);
+			switch (resp.trailer.neg_ses_resp_error_code) {
+			case RFC1002_NOT_LISTENING_CALLED:
+				/* server does not listen for specified server name */
+				fallthrough;
+			case RFC1002_NOT_PRESENT:
+				/* server name is incorrect */
+				rc = -ENOENT;
+				cifs_dbg(VFS, "Server rejected NetBIOS servername %.15s\n",
+					 server->server_RFC1001_name[0] ?
+					 server->server_RFC1001_name :
+					 DEFAULT_CIFS_CALLED_NAME);
+				cifs_dbg(VFS, "Specify correct NetBIOS servername in source path or with -o servern= option\n");
+				break;
+			case RFC1002_NOT_LISTENING_CALLING:
+				/* client name was not accepted by server */
+				rc = -EACCES;
+				cifs_dbg(VFS, "Server rejected NetBIOS clientname %.15s\n",
+					 server->workstation_RFC1001_name[0] ?
+					 server->workstation_RFC1001_name :
+					 "LINUX_CIFS_CLNT");
+				cifs_dbg(VFS, "Specify correct NetBIOS clientname with -o netbiosname= option\n");
+				break;
+			case RFC1002_INSUFFICIENT_RESOURCE:
+				/* remote server resource error */
+				rc = -EREMOTEIO;
+				break;
+			case RFC1002_UNSPECIFIED_ERROR:
+			default:
+				/* other/unknown error */
+				rc = -EIO;
+				break;
+			}
+		} else {
+			cifs_dbg(VFS, "RFC 1002 negative session response\n");
+			rc = -EIO;
+		}
+		return rc;
+	case RFC1002_RETARGET_SESSION_RESPONSE:
+		cifs_dbg(VFS, "RFC 1002 retarget session response\n");
+		if (be16_to_cpu(resp.length) == sizeof(resp.trailer.retarget_resp)) {
+			len = sizeof(resp.trailer.retarget_resp);
+			iov.iov_base = &resp.trailer.retarget_resp;
+			iov.iov_len = len;
+			iov_iter_kvec(&msg.msg_iter, ITER_DEST, &iov, 1, len);
+			if (smb_recv_kvec(server, &msg, &recv) == 0 && recv == len) {
+				cifs_dbg(VFS, "Server wants to redirect connection\n");
+				cifs_dbg(VFS, "Remount with options -o ip=%pI4,port=%u\n",
+					 &resp.trailer.retarget_resp.retarget_ip_addr,
+					 be16_to_cpu(resp.trailer.retarget_resp.port));
+			}
+		}
+		cifs_dbg(VFS, "Closing connection\n");
+		/* FIXME: Should we automatically redirect to new retarget_resp server? */
+		return -EMULTIHOP;
+	default:
+		cifs_dbg(VFS, "RFC 1002 unknown response type 0x%x\n", resp.type);
+		return -EIO;
+	}
 
 	return 0;
 }
-- 
2.20.1

