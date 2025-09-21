Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172F31514DC
	for <linux-cifs@vger.kernel.org>; Sun, 21 Sep 2025 21:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758491248; cv=none; b=R7Sw4iVTohXqI1gsQ3iK8tlhDroS/EArOZDTsvS0C0Bu8uoiEPzSn7CYcBcvfxxHFqNFjSwrfdEfxe1RM8cPTWpP6xZet3W7baYLanBDvxIBQx9R4QQJGiIgAgNEQ8ayBetpIW0ZfmKThlqIc2oqq6Mro/ZAEcs2fVjXJmkn+y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758491248; c=relaxed/simple;
	bh=4bpAucRrIlKCW+ZkkmsgwPrDGyrStQn0tTWVV2gorCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SrL96wKwzxm143dCXxQDYfJVvKsvpliWi5ts6svheovZVw9lf030P27LmwLbaf1xIbuwnEHktePZqM47f6ApPW50dVuojx5uNtLZdUOYCMwA93OpsWiyRBYhbBgBJKLgV+mTZdD5+vA39TfGW/N3kfPSiY2n0QlyByiun0AJdRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=GkbUP0FV; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="GkbUP0FV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=/d7fagOsnCE0cqJu+bN2pL70FTdVCbTcJxByJAxgvd4=; b=GkbUP0FVLG14H5kkXoOVha/zQw
	SoZwoH92ZI0UkzyeL2lwOQOTDWIPXhfbOEjKMOoDwWNcsBKkPrQ6BGt79D+OTVr4tMuiJA1RjxfiS
	nPCf34qdOxsSyJjKPgwiw9ofYMcs5Jnz076MlpDctz3ncyOCAPZIsF51dRBZ+v7kt/7tZChJ9NkVn
	WqQiSFdxRSCMYn10t8QYDNUZkXxmOg0l9JO+4t6Su2HxPFlGttT4jH4Sy5DYNrk7zK+XT7e8nlxm9
	OdQf9xvu/xh/3EFJt5q1rlHhxaahUctgi900y5lPEY7I3QCQC4aVdrx8e8la8/NUJP0bQ12yHw/dT
	c+v+3jGcTkNP+hqjtmvyztHGSeKch9ATVSK27jX2xz8rKsllindopgjyxGAknUn8YDxEEpYi34aOW
	XP9RI0fmGLN0hw9FjcFbEBJe9aMOm7dZlpyYeT+Xrbvm/mid14tKcLhn45UKeYmI7Q0qTBLe6tv8p
	Ks3D2w0ohCP6iuROUidUGkGY;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v0Ru0-005Ggh-0G;
	Sun, 21 Sep 2025 21:47:24 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 15/18] smb: server: let {free_transport,smb_direct_disconnect_rdma_{work,connection}}() wake up all wait queues
Date: Sun, 21 Sep 2025 23:45:02 +0200
Message-ID: <e15437e4d5a71cb9adc08178d4b35054118e89b1.1758489989.git.metze@samba.org>
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

This is important in order to let all waiters notice a broken connection.

We also go via smb_direct_disconnect_rdma_{work,connection}() for broken
connections.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 40 +++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index cd4398ae8b98..ba4dfdcb321a 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -207,6 +207,19 @@ static struct smbdirect_recv_io *get_first_reassembly(struct smbdirect_socket *s
 		return NULL;
 }
 
+static void smb_direct_disconnect_wake_up_all(struct smbdirect_socket *sc)
+{
+	/*
+	 * Wake up all waiters in all wait queues
+	 * in order to notice the broken connection.
+	 */
+	wake_up_all(&sc->status_wait);
+	wake_up_all(&sc->send_io.credits.wait_queue);
+	wake_up_all(&sc->send_io.pending.zero_wait_queue);
+	wake_up_all(&sc->recv_io.reassembly.wait_queue);
+	wake_up_all(&sc->rw_io.credits.wait_queue);
+}
+
 static void smb_direct_disconnect_rdma_work(struct work_struct *work)
 {
 	struct smbdirect_socket *sc =
@@ -257,6 +270,12 @@ static void smb_direct_disconnect_rdma_work(struct work_struct *work)
 	case SMBDIRECT_SOCKET_DESTROYED:
 		break;
 	}
+
+	/*
+	 * Wake up all waiters in all wait queues
+	 * in order to notice the broken connection.
+	 */
+	smb_direct_disconnect_wake_up_all(sc);
 }
 
 static void
@@ -314,6 +333,12 @@ smb_direct_disconnect_rdma_connection(struct smbdirect_socket *sc)
 		break;
 	}
 
+	/*
+	 * Wake up all waiters in all wait queues
+	 * in order to notice the broken connection.
+	 */
+	smb_direct_disconnect_wake_up_all(sc);
+
 	queue_work(sc->workqueue, &sc->disconnect_work);
 }
 
@@ -421,8 +446,14 @@ static void free_transport(struct smb_direct_transport *t)
 					 sc->status == SMBDIRECT_SOCKET_DISCONNECTED);
 	}
 
-	wake_up_all(&sc->send_io.credits.wait_queue);
-	wake_up_all(&sc->send_io.pending.zero_wait_queue);
+	/*
+	 * Wake up all waiters in all wait queues
+	 * in order to notice the broken connection.
+	 *
+	 * Most likely this was already called via
+	 * smb_direct_disconnect_rdma_work(), but call it again...
+	 */
+	smb_direct_disconnect_wake_up_all(sc);
 
 	disable_work_sync(&sc->recv_io.posted.refill_work);
 	disable_delayed_work_sync(&sc->idle.timer_work);
@@ -1644,14 +1675,11 @@ static int smb_direct_cm_handler(struct rdma_cm_id *cm_id,
 
 		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
 		smb_direct_disconnect_rdma_work(&sc->disconnect_work);
-		wake_up_all(&sc->status_wait);
-		wake_up_all(&sc->recv_io.reassembly.wait_queue);
-		wake_up_all(&sc->send_io.credits.wait_queue);
 		break;
 	}
 	case RDMA_CM_EVENT_CONNECT_ERROR: {
 		sc->status = SMBDIRECT_SOCKET_DISCONNECTED;
-		wake_up_all(&sc->status_wait);
+		smb_direct_disconnect_rdma_work(&sc->disconnect_work);
 		break;
 	}
 	default:
-- 
2.43.0

