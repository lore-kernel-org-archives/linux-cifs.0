Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E4149620
	for <linux-cifs@vger.kernel.org>; Sun, 21 Sep 2025 21:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758491136; cv=none; b=jBax3EcpYTYjSOWIH4VQQkSg0Gn0v/xbT5FEyDQi2OMzPEL2pG1UgmetBqvDEs/sQ7Mz6od3Z3MATR/npqHEwOBBM08JPoXp8YNrBRSgQUm+J9GgVFxWtvGQmgXj4mSJEW2fRcSTtrOxF6A3zaDInSfSqbVTcv+L1rZEl+0C0Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758491136; c=relaxed/simple;
	bh=MG4W0srwqPj5RZ4vhDeXXHwZtC+zvXh0ZQ1pjZqXv+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kl8xGQQiNKQpEsGzNzSM+Yy1OGLQc6o+XAQKO4gF/ukHjITpmCJT9zVWOTzanTdwhLCtfw2pmavOQWZ0I6QK2zstaPCvt/4ehv4UWKLNOCU+e2Qdla+eTUS7VieJlwi62FHohASS6fb9EYn0m0cU4zQbylKgGdk6Qy+wyDlBtzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=jqPIxR8C; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="jqPIxR8C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=8s1yRJzHYcj0JSI7+0RPoZkcz2/6cNfm7A6Be5Nm0Q8=; b=jqPIxR8Cx1FIITApZGHVqHQjCU
	yaPP7zJPYGxBCWrjLl/fdckj3guzf4W6u7WO7spwyGxPsVLmjkEsJeSS0Eat4PsVef4sMxkUlnKGl
	6D49z6+RbLNUOZgBA0EsIXL9w46HpCQmYTXk+jW+0bYR2hUE5wDWbG2RNJp3ASQKa803w01Lc4Uol
	B9BTwXeRN58HijMN9h1xYV68qsV+g/jD4FRsnLsrl6bMNRQMpV3hnpwsshlOcyzXNGuDYOcDKySdV
	6XxNu6JRwoDiqxB//YFraF9NsDDcZPOleTJCQxAyzHwX1XpL/hYPQDPmnJHkW5s5OGvdKUPoI7qhZ
	5lfEFfUyPaPhRcxFeXvjD+gpF6k8t/+sgaQPNncUT6yax6fuPp4PKcm8mNRG0WE+3GfH+HuTLT5aM
	brbRG/S3RJZdYNWg5sOa67Hml376RRjoyhtgjo1brlk60Epn3vsPLWtPpOfqY0PDfys4P47cZsA8q
	uu4ymq/WxTAAxNQK+IrTI9+O;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v0RsB-005GMF-1m;
	Sun, 21 Sep 2025 21:45:31 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 01/18] smb: smbdirect/client: introduce SMBDIRECT_SOCKET_ERROR
Date: Sun, 21 Sep 2025 23:44:48 +0200
Message-ID: <09b17a8a4e32d4360b4e554b032179aa96cf70f4.1758489988.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1758489988.git.metze@samba.org>
References: <cover.1758489988.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will be used to turn SMBDIRECT_SOCKET_CONNECTED into an
error within smbd_disconnect_rdma_connection() on the client
and smb_direct_disconnect_rdma_connection() on the server.

We do this in a single commit with the client as otherwise it
won't build because the enum value is not handled in the
switch statement.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c                  | 1 +
 fs/smb/common/smbdirect/smbdirect_socket.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index e0a01b3b396a..7e0d2ecaa37e 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -186,6 +186,7 @@ static void smbd_disconnect_rdma_work(struct work_struct *work)
 	case SMBDIRECT_SOCKET_NEGOTIATE_RUNNING:
 	case SMBDIRECT_SOCKET_NEGOTIATE_FAILED:
 	case SMBDIRECT_SOCKET_CONNECTED:
+	case SMBDIRECT_SOCKET_ERROR:
 		sc->status = SMBDIRECT_SOCKET_DISCONNECTING;
 		rdma_disconnect(sc->rdma.cm_id);
 		break;
diff --git a/fs/smb/common/smbdirect/smbdirect_socket.h b/fs/smb/common/smbdirect/smbdirect_socket.h
index 91eb02fb1600..b4970d7e42ad 100644
--- a/fs/smb/common/smbdirect/smbdirect_socket.h
+++ b/fs/smb/common/smbdirect/smbdirect_socket.h
@@ -23,6 +23,7 @@ enum smbdirect_socket_status {
 	SMBDIRECT_SOCKET_NEGOTIATE_RUNNING,
 	SMBDIRECT_SOCKET_NEGOTIATE_FAILED,
 	SMBDIRECT_SOCKET_CONNECTED,
+	SMBDIRECT_SOCKET_ERROR,
 	SMBDIRECT_SOCKET_DISCONNECTING,
 	SMBDIRECT_SOCKET_DISCONNECTED,
 	SMBDIRECT_SOCKET_DESTROYED
@@ -60,6 +61,8 @@ const char *smbdirect_socket_status_string(enum smbdirect_socket_status status)
 		return "NEGOTIATE_FAILED";
 	case SMBDIRECT_SOCKET_CONNECTED:
 		return "CONNECTED";
+	case SMBDIRECT_SOCKET_ERROR:
+		return "ERROR";
 	case SMBDIRECT_SOCKET_DISCONNECTING:
 		return "DISCONNECTING";
 	case SMBDIRECT_SOCKET_DISCONNECTED:
-- 
2.43.0

