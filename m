Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB019412BFB;
	Mon, 24 Aug 2026 12:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787573321; cv=none; b=BAH0qZ9YIuZh+xODTBh4gZ2kXQZDVoEhmm4YiUaVjh+uVw5EqqlQxRyFtrTXov2pIuMZajS7C40E2i4lgHXdIJM9sNojI0Fy8QcgM+R7Z6YCCS+3YRbYzwo+b7DHqYO7WBKpTjLhSjtTTEuKnQOgy6CxT08afpKjeeGI2lmv5VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787573321; c=relaxed/simple;
	bh=DegYEG6tpjLPd6zIyd0uvEZQ+CG03dLYC5VoDZmbB70=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BN39XJ0Ed+o/ryT16IMymIyGUBwOs4/ObgHS7hjwCRinjrPov2qssMA0rbioFwDDv7WYJTr3apwYtE+HxO8tEm2+90xk1MDn+d3E6pTFW2C2BXmRzdl+MNd2XFsPSnYDeVwEqzdb81cE4oppEdHpblJCWevN2E/0eGngG7utqgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lwYNaCQ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lwYNaCQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB23A1F000E9;
	Mon, 24 Aug 2026 12:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787573320;
	bh=X/BRx6M0sWOF5lRkxvQBnf742kB/koawcH9FfpZ801w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lwYNaCQ08Sh6l7XGgwRZlDDmSSKrXqYwm396gFjuimZaVsGZytvx+p7297a3dagpi
	 YpWIXwnkPt3mAI1yUptAYf7Qn2PyKlP3Db5dDCZ5mqpsKJxfLojXKz3UozogGoGPPn
	 1XBsfiTvtxe2Tz2Va/ntmvrjrrRR7rWhAm3rzGa3kn7wpEplgEr4GYCEg1f09PyrhY
	 zy2Zyq1wMjn7aXPCbxKkDWRCgd47EGvF//6Qe3llqXdUYmjPx03lToU8YftAJDgWtO
	 IxpuSfIY0hNZTiYFal2u9395hoIKrXyECPdNlGqfatI1yXaDjABt/lLnC34accHbIu
	 0pO6cqfWmQYgQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 24 Aug 2026 14:08:19 +0200
Subject: [PATCH v2 4/5] smb: prevent TIF_NOTIFY_SIGNAL from interrupting
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260824-work-tif_notify_signal-v2-4-6609e42b3157@kernel.org>
References: <20260824-work-tif_notify_signal-v2-0-6609e42b3157@kernel.org>
In-Reply-To: <20260824-work-tif_notify_signal-v2-0-6609e42b3157@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <peterz@infradead.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Steve French <sfrench@samba.org>, linux-fsdevel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Paulo Alcantara <pc@manguebit.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2185; i=brauner@kernel.org;
 h=from:subject:message-id; bh=DegYEG6tpjLPd6zIyd0uvEZQ+CG03dLYC5VoDZmbB70=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT1mFg6rpr9/KnJblcjBY2oGa/3Tnoe9H/NLofT+5YsD
 r662Hr/9I5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJLDvHyHDilY5tlM6jJRu1
 0k8xFa1M+GWvUb/SfuU36yfbfUpaT4YzMkyKr+KfFrleNnTzleSyhg+SVjHGzTmm0sr3e5vPMMT
 nMwEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

smb blocks every signal during some sends:

	sigfillset(&mask);
	sigprocmask(SIG_BLOCK, &mask, &oldmask);

An incomplete or partial send would cause the connection to become out
of sync. That in turn would cause the session to be torn down and
reconnected.

In commit 00be6f26a2a7 ("smb: client: transport: avoid reconnects
triggered by pending task work") smb hand-rolled its own solution. Have
it use the new no_notify_signal_save() critical section instead.

This stops io_uring from cancelling a send in flight but that's just
like it is today and it is bounded by sk_sndtimeo at around 15s.

Acked-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/smb/client/transport.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index fdf4e50c27ce..35fa699569e9 100644
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
@@ -172,15 +171,11 @@ smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
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
-		rc = sock_sendmsg(ssocket, smb_msg);
-		if (rc == -EAGAIN || unlikely(rc == -EINTR && task_work_pending(current))) {
+		scoped_guard(no_notify_signal)
+			rc = sock_sendmsg(ssocket, smb_msg);
+		if (rc == -EAGAIN) {
 			retries++;
 			if (retries >= 14 ||
 			    (!server->noblocksnd && (retries > 2))) {

-- 
2.53.0

