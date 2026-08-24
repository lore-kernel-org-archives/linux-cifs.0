Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4E0412BE7;
	Mon, 24 Aug 2026 12:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787573324; cv=none; b=LJrkBmemkqyqlxaJvon7bVM8AfSvDzDbH5tp5MY1LlpBQqQnbSKOyKfqohAZwVukebVn9x5qs4yAI6foZxAf7qO/Ag6B2awQPVdciIB4JoY2fN8mzLGvWf93Gegd9g+xYZvbXVXhwji3z9o6Zloof9zm1DvfuEms5sTkraCNUpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787573324; c=relaxed/simple;
	bh=DNuXd0pKQn7U4+pLkpu+uX5FDrR9RBOyfwfmgrAQmaM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eqG46AuLr2Us2AeQCL2+FFeH5negZ4WMprd0//qjWm2GLu28PaDUI0QrbYPjyGb1JGZdMoS8x3E2N27OLn/7kHAsum4lIdZwlTHi5a5G8sXZINfVxhNdf+LavSr8bwfeZBCCpoT6V92zgMPeyxfzZi7MPBPy1sQobXZqgtn3D+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=auaeZgQ+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="auaeZgQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64BA1F00A3A;
	Mon, 24 Aug 2026 12:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787573323;
	bh=uQui/Mo5x/mE+ZdE3He0UvEKRAK0DKtU9+wg6AGH260=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=auaeZgQ++dDT6ZiZ6j0vOGeWJbMYu77qkLcsAZ2LPTVROkev5iy5DviBSsIzb2Y6/
	 ZtcONh6wqJlHy5SxWbXTiC8pzO2Yi0YIaBNME3eOzW1iJtF1EBJez+ifmeeXFsLPWP
	 p03vPpvNElYn6yV9r0s7L/StVf289CXsvw40aWG2jiRORRnogxOjWe6qInEB+SPJeh
	 E3c+MsE1MOi87IWGqonmZ5BEFSESrz94UsQsQjqWEZ0pM4Ugy9YsvSyD0bZ02I0qtR
	 yHGM4KizZC0xb9QHNPxhlMSQtUh6aD5/izOnJy93eOjZCxzEHBByLIfEt4wVC7Zao2
	 1nrdZMFEI7O6A==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 24 Aug 2026 14:08:20 +0200
Subject: [PATCH v2 5/5] pid_namespace: prevent TIF_NOTIFY_SIGNAL from
 interrupting the reaper
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260824-work-tif_notify_signal-v2-5-6609e42b3157@kernel.org>
References: <20260824-work-tif_notify_signal-v2-0-6609e42b3157@kernel.org>
In-Reply-To: <20260824-work-tif_notify_signal-v2-0-6609e42b3157@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <peterz@infradead.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Steve French <sfrench@samba.org>, linux-fsdevel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1853; i=brauner@kernel.org;
 h=from:subject:message-id; bh=DNuXd0pKQn7U4+pLkpu+uX5FDrR9RBOyfwfmgrAQmaM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT1mFi+/SQbxvzpzDOeWTM1LbY8mlm86STj0xu7n77kv
 T3fTGcmW0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEql4y/OF/4DczK1bwzyTX
 ABtWL3eWI5Gab1ZtKU3/dIz9/iTjcGaGfybL9IRqYoU3fGcv36qcMOWBmmPQ8flmz/ft4/nMdol
 djh0A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Since commit 7fea700e04bd ("zap_pid_ns_processes: clear
TIF_NOTIFY_SIGNAL along with TIF_SIGPENDING") zap_pid_ns_processes()
clears TIF_NOTIFY_SIGNAL before every kernel_wait4() call. Otherwise
kernel_wait4() doesn't sleep and returns -ERESTARTSYS if
signal_pending() is true and the reaper busy-waits.

But clearing TIF_NOTIFY_SIGNAL doesn't fix it. It can get raised again.
For example, klp_send_signals() sets it raw against any task that hasn't
transitioned yet. And it keeps sending it until the livepatch finishes.

The sleep loop waiting for pid_allocated to drop has the same problem
and it doesn't even clear anything. So a schedule() in
TASK_INTERRUPTIBLE returns immediately.

Use a no_notify_signal guard. signal_pending() will ignore
TIF_NOTIFY_SIGNAL and the pid namespace reaper sleeps until a child
exits or free_pid() wakes it.

Fixes: 7fea700e04bd ("zap_pid_ns_processes: clear TIF_NOTIFY_SIGNAL along with TIF_SIGPENDING")
Cc: stable@vger.kernel.org
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/pid_namespace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index d36afc58ee1d..8bc9edb40b78 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -238,9 +238,10 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 	 * kernel_wait4() will also block until our children traced from the
 	 * parent namespace are detached and become EXIT_DEAD.
 	 */
+	/* Task work must not busy-loop the reaper, see signal_pending(). */
+	guard(no_notify_signal)();
 	do {
 		clear_thread_flag(TIF_SIGPENDING);
-		clear_thread_flag(TIF_NOTIFY_SIGNAL);
 		rc = kernel_wait4(-1, NULL, __WALL, NULL);
 	} while (rc != -ECHILD);
 

-- 
2.53.0

