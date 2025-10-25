Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC22306490;
	Sat, 25 Oct 2025 16:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409641; cv=none; b=JgKl9VLnwdAF5xgslHjVAydw+BTknua7r13UvuLA7wXSirBVDXf0gyuPZMNL+XNKmG3XccxUvXaTuInmozjW+Rlu15MqIgqN4xjMy/Xih2jC8qoqvwcapxobmeswSG305bgKF6AmbPO+knnse0DmUhVV9GedSeKehZGRJWV0AMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409641; c=relaxed/simple;
	bh=qIMw9ZuxqOW9de6zo3ajgmujFKYvixLItCVGd2KiffY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4POXgYgDtcKAqjx6Ier+wI+jZpbArdKMt57hghSH0oVqZg1iXjvfA0nFESew/bF2bX0nzRGTlVSQ6Zn/EApBQtA5usdZc/zc2EKI6wMfU5TF43Tgx9ZXetgRywBpZNlI0wns7/H08cKiwtsaSNxx697nHcHfXvi5itooSzLahA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jTLpcCTS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jTLpcCTS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0DFC4CEF5;
	Sat, 25 Oct 2025 16:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409641;
	bh=qIMw9ZuxqOW9de6zo3ajgmujFKYvixLItCVGd2KiffY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jTLpcCTSsUHVgOkkrbYONgGAfWlb2zcUYhqgLVb6n1Ve55w3VjpF0P9NFt8unVnCz
	 DxqVCDExM8SOv/wRQQfeqDW7fW7dRvk8fF4au8hD93aCTPtLtVhLJrvOxH63R0t4yN
	 5/Gbyw5aG3mUiNq/ffyJAQRKk775rtBxOHLg0IE2uiPs32/ir3KMIdaOLKIhcLP3ET
	 RYoaO3SC3eTN8zCNMsl+NybY79sAVbTPDsbuZ0ZZB4x0s4hnsSxtTQDRPKtpoG1UYT
	 vX30RVjFkPqK8Z9QKR6QhtYPiNAzUnPdq/uGl8aGUBQ0UM4lfUTpUeGo/0t3uj/imc
	 F2GC0UPoSmBlg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fiona Ebner <f.ebner@proxmox.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.17-6.1] smb: client: transport: avoid reconnects triggered by pending task work
Date: Sat, 25 Oct 2025 12:00:33 -0400
Message-ID: <20251025160905.3857885-402-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Fiona Ebner <f.ebner@proxmox.com>

[ Upstream commit 00be6f26a2a7c671f1402d74c4d3c30a5844660a ]

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
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- **Bug addressed:** When `sk_stream_wait_memory()` sees
  `signal_pending(current)` it returns `-EINTR`
  (net/core/stream.c:141-185). In CIFS, `__smb_send_rqst()` masks
  regular signals but not `TIF_NOTIFY_SIGNAL`, so that `-EINTR` flows
  back, hits the reconnect path (`rc = -ERESTARTSYS` plus
  `cifs_signal_cifsd_for_reconnect()`) and forces unnecessary
  disconnects with errors like `-512`
  (fs/smb/client/transport.c:350-379).
- **Why it happens in practice:** io_uring queues task_work with
  `notify_method = TWA_SIGNAL` (io_uring/io_uring.c:3844-3847), which
  sets `TIF_NOTIFY_SIGNAL` and trips `signal_pending()` even though the
  task only has task_work pending. CIFS previously treated this
  indistinguishably from a real signal, so combining io_uring with SMB
  writes caused spurious reconnects observed by users (commit message
  symptom).
- **Fix mechanics:** The patch adds `<linux/task_work.h>`
  (fs/smb/client/transport.c:25) and treats `-EINTR` as a transient
  condition only when `task_work_pending(current)` reports queued task
  work (fs/smb/client/transport.c:186-195). This keeps the existing
  retry/backoff logic but prevents the reconnect machinery from running
  on synthetic task-work signals. The comment at
  fs/smb/client/transport.c:178-183 documents the scenario.
- **Safety:** Fatal or user-requested interrupts still break out because
  `fatal_signal_pending(current)` is checked up front
  (fs/smb/client/transport.c:268-272) and the new clause only fires when
  both `rc == -EINTR` and task work is pending. If the condition
  persists, the existing retry limit still returns `-EAGAIN`, so there
  is no risk of livelock. `task_work_pending()` has been part of the API
  since v5.18 (include/linux/task_work.h:24-27), so the helper is
  available on active stable lines, and no other subsystems are touched.
- **Backport outlook:** The change is tiny, self-contained, and directly
  fixes a user-visible regression without altering protocol semantics.
  It should be safe to backport as-is; running the usual CIFS
  regression/balance-of-tree network write tests would be the natural
  follow-up.

 fs/smb/client/transport.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index a61ba7f3fb86b..940e901071343 100644
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
2.51.0

