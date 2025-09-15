Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97078301476;
	Mon, 15 Sep 2025 15:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=94.136.29.106
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757949608; cv=none; b=fmTIGA/mx+U+z5IkxwzkHbfFzQAVUppZJVcIdHif8K8ZrlodCF7fX1RDKcBdZFocLIPYkDHMPuJRX+oLsru+5kAQnHiMInbeL96nS+8/jf2NJhVCI+dN3wtDrtTgRpQZnMOd9PRT+W4Le1vEsStaP5FYuNv51z4709NzUPv9xDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757949608; c=relaxed/simple;
	bh=r0XPNJ2T0NahYpxtTRPPDjeCs7eUxcldKZ6+StMISqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eGJqIcDx+pw3BkGUcGg93qlmH/yaa2xiNSCyCRagDMKsvVw13EWTrpZjBQKaA1xRmiBe5t5XYHtU0dmsAUeW3cdstL/VimsyU4pGBO4nm+mlisRrSAdgmnDNZOCXTN9UlQCfBB12dbrDSgtv4N8fYOcBAyXHuJ/tLpk4FpR3Dt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com; spf=pass smtp.mailfrom=proxmox.com; arc=none smtp.client-ip=94.136.29.106
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 06B2E4BCA9;
	Mon, 15 Sep 2025 17:19:57 +0200 (CEST)
From: Fiona Ebner <f.ebner@proxmox.com>
To: linux-kernel@vger.kernel.org
Cc: samba-technical@lists.samba.org,
	linux-cifs@vger.kernel.org,
	bharathsm@microsoft.com,
	tom@talpey.com,
	sprasad@microsoft.com,
	ronniesahlberg@gmail.com,
	pc@manguebit.org,
	sfrench@samba.org
Subject: [PATCH 1/2] smb: client: transport: avoid reconnects triggered by pending task work
Date: Mon, 15 Sep 2025 17:19:39 +0200
Message-ID: <20250915151950.1017597-2-f.ebner@proxmox.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250915151950.1017597-1-f.ebner@proxmox.com>
References: <20250915151950.1017597-1-f.ebner@proxmox.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Bm-Milter-Handled: 55990f41-d878-4baa-be0a-ee34c49e34d2
X-Bm-Transport-Timestamp: 1757949589672

When io_uring is used in the same task as CIFS, there might be
unnecessary reconnects, causing issues in user-space applications
like QEMU with a log like:

> CIFS: VFS: \\10.10.100.81 Error -512 sending data on socket to server

Certain io_uring completions might be added to task_work with
notify_method being TWA_SIGNAL and thus TIF_NOTIFY_SIGNAL is set for
the task.

In __smb_send_rqst(), signals are masked before calling
smb_send_kvec(), but the masking does not apply to TIF_NOTIFY_SIGNAL.

If sk_stream_wait_memory() is reached via sock_sendmsg() while
TIF_NOTIFY_SIGNAL is set, signal_pending(current) will evaluate to
true there, and -EINTR will be propagated all the way from
sk_stream_wait_memory() to sock_sendmsg() in smb_send_kvec().
Afterwards, __smb_send_rqst() will see that not everything was written
and reconnect.

Signed-off-by: Fiona Ebner <f.ebner@proxmox.com>
---
 fs/smb/client/transport.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index a61ba7f3fb86..940e90107134 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -22,6 +22,7 @@
 #include <linux/mempool.h>
 #include <linux/sched/signal.h>
 #include <linux/task_io_accounting_ops.h>
+#include <linux/task_work.h>
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
@@ -173,9 +174,16 @@ smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
 		 * send a packet.  In most cases if we fail to send
 		 * after the retries we will kill the socket and
 		 * reconnect which may clear the network problem.
+		 *
+		 * Even if regular signals are masked, EINTR might be
+		 * propagated from sk_stream_wait_memory() to here when
+		 * TIF_NOTIFY_SIGNAL is used for task work. For example,
+		 * certain io_uring completions will use that. Treat
+		 * having EINTR with pending task work the same as EAGAIN
+		 * to avoid unnecessary reconnects.
 		 */
 		rc = sock_sendmsg(ssocket, smb_msg);
-		if (rc == -EAGAIN) {
+		if (rc == -EAGAIN || unlikely(rc == -EINTR && task_work_pending(current))) {
 			retries++;
 			if (retries >= 14 ||
 			    (!server->noblocksnd && (retries > 2))) {
-- 
2.47.2


