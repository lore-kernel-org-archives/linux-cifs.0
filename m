Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4223E1CED;
	Tue, 18 Aug 2026 10:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787049000; cv=none; b=W7mDE01+2Hh3ylrWABHXHFPg1QifCBJB2SKWVp9ZOXU+kyjvMxOOV/xrzZWV+xxwugjqnOHyOnnpgS5M1/0bRHqnXiA5Bv9TlvyqXJuxNNF/gogS/bvUWa2EH9SEQMiPFB7rdNIQIlb23Rv7xWAXRQdF+LK4p/W4bhPiuteyXWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787049000; c=relaxed/simple;
	bh=PHoG4Al+J6bmlX5hfjF9xp+ZYim9zrGXQmfo1DpuFPY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=clZWctyJfCSRplysFrM+EfTAhjo32nFtaOSccFlnLSEi1GRMw/Vvl+JcdhB1ecQTfnCbqGsJ4lC0HxQ+aP5+Ywo0Ee3XV6K2V5N1inIDgW/FIOD6BMZ9U4+axUl6kzLRKDjcNj3kc7KZ06F6IqYzCDUM6DuW7DW4PbVyE4WVN9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HOFcuzXp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HOFcuzXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E941F00A3A;
	Tue, 18 Aug 2026 10:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787048998;
	bh=oA5YhOItUInh8TEcUIpTf7oUnEBcO06MQC7rRQBXdXo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HOFcuzXpnKI05Fmts6b8sTaR8G+Nie1XPP0qhdWGno/awjz/3qX2CxKOnnKijS7v4
	 BUU30bv01pzSO3PifvCMDfFsmaZpIsGxvWO3CVRkukQlnR1wUCZTnV9HO8s7uo5jrl
	 7aV5vXAViE0JxPFJ691ULt3CDQV3zcrcoY0aIUK+LPaXNh5l7God+ejWTBy+ghkgj2
	 db9PVSLhO8qVjsVpXIsmZQYyDqQWJ5OGIcN7lBHtRQoB2Ez0cF5ozxqOE0UTuSwUAO
	 BdLlSFzn6i0vhUzxnnrmYm2GDEooILujNH/XyIWKnkbazCXB/vKazBiSihh3TbGtx0
	 5yWaQ3KIJkxRw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 18 Aug 2026 12:29:39 +0200
Subject: [PATCH 4/4] smb: prevent TIF_NOTIFY_SIGNAL from interrupting
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-work-tif_notify_signal-v1-4-1ee1fcc5b3ff@kernel.org>
References: <20260818-work-tif_notify_signal-v1-0-1ee1fcc5b3ff@kernel.org>
In-Reply-To: <20260818-work-tif_notify_signal-v1-0-1ee1fcc5b3ff@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: Peter Zijlstra <peterz@infradead.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Steve French <sfrench@samba.org>, linux-fsdevel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2385; i=brauner@kernel.org;
 h=from:subject:message-id; bh=PHoG4Al+J6bmlX5hfjF9xp+ZYim9zrGXQmfo1DpuFPY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1mEhwbL+3bJXZT9MfWj4VASUfWCuyT1m+K1j/au6Gq
 TNa+D4ZdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzE6wzD/8A5vto3tRx2b9/U
 tee1i+2r2eIrD35on9fYvdakOPB0xQeGf4qToh5Pz8gqCj50ceK5H7GiSxuC+8wemO9VM2U91bz
 anwUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

smb_send_kvec() blocks every signal during a send:

	sigfillset(&mask);
	sigprocmask(SIG_BLOCK, &mask, &oldmask);

An incomplete or partial sent would cause the connection to become out
of sync. That in turn would cause the session to be torn down and
reconnected.

In 00be6f26a2a7 ("smb: client: transport: avoid reconnects triggered
by pending task work") smb hand-rolled its own solution. Have it use the
new no_notify_signal_save() critical section instead.

This stops io_uring from cancelling a send in flight but that's just
like it is today and it is bounded by sk_sndtimeo at around 15s.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/smb/client/transport.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index fdf4e50c27ce..05dc20916c27 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -22,7 +22,6 @@
 #include <linux/mempool.h>
 #include <linux/sched/signal.h>
 #include <linux/task_io_accounting_ops.h>
-#include <linux/task_work.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifs_debug.h"
@@ -142,6 +141,7 @@ int
 smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
 	      size_t *sent)
 {
+	unsigned int notify_flags;
 	int rc = 0;
 	int retries = 0;
 	struct socket *ssocket = server->ssocket;
@@ -172,15 +172,12 @@ smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
 		 * after the retries we will kill the socket and
 		 * reconnect which may clear the network problem.
 		 *
-		 * Even if regular signals are masked, EINTR might be
-		 * propagated from sk_stream_wait_memory() to here when
-		 * TIF_NOTIFY_SIGNAL is used for task work. For example,
-		 * certain io_uring completions will use that. Treat
-		 * having EINTR with pending task work the same as EAGAIN
-		 * to avoid unnecessary reconnects.
+		 * Task work must not abort the send, see signal_pending().
 		 */
+		notify_flags = no_notify_signal_save();
 		rc = sock_sendmsg(ssocket, smb_msg);
-		if (rc == -EAGAIN || unlikely(rc == -EINTR && task_work_pending(current))) {
+		no_notify_signal_restore(notify_flags);
+		if (rc == -EAGAIN) {
 			retries++;
 			if (retries >= 14 ||
 			    (!server->noblocksnd && (retries > 2))) {

-- 
2.53.0

