Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785513DDB18;
	Tue, 18 Aug 2026 10:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787048991; cv=none; b=IeZ0usUiAYmVpGM/uwPWAlxWNqYLO7HbePfH0q8PFhNrUZgDk0HmatNbDHV0Dp78eqBsZ9+pdf8Os3/x0Ejbg3z83taZHzqQ7mgYd9fTFqUO3DV3Eztce3lgK67p1AQe0TxDwKGK45qCcJFAxO9WK3j5TJqcq0GaVM1HzgfhYac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787048991; c=relaxed/simple;
	bh=GPNbpnB0jcJa4smLJiVmwCjZkDxhRfuvI09qEeH/sQI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Nz0FOrZewpvfzOReQ1rj8tnNGgyxN4sYtNmt4+bSw3QWxmOeqkgcXu1AQlabvXCBRqvfQabnf+94deCwwM3UBmyOk42F+hCpYTzSJ2vybEuNlyklXnhh+P4DwNeuAJPDXnIodweFE1mYUqkckLN8F2RZcgpFjGgTvZaQf7U8RLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QqauSKQ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QqauSKQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADEC1F00A3A;
	Tue, 18 Aug 2026 10:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787048990;
	bh=A5uPn/aNxaggwKLcm1ypjdrg/Nu/GJZLii6douxX+c8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QqauSKQ0GXzyMDD4lZDP5b0eCGig9L7ovZxo46V8STWM6/YqHy6Qz/ZTG5zKq+KfQ
	 Q1ouXdfFEc1DmV/KL52o8mCCUmHrXB4Dfl5q4tcg+ATdCw3IHhglGMlMryYdkygWPS
	 K7bYmdIW0t+nHL1Us7BXnFCUSrCDYjjrGXcQN6q/Gb8VkEOh5XnFvO1sUdg+yyirBL
	 83EBw1oUCUctGTz3+1GcRv91jo1XZcd7A32I/vLn63EmkNfDAo6xULPd6ttQJelanY
	 vLTHIjMAgaZFGEKLB3NRYPLIMRybByrBlzHzCIYdtm94Z2Ygg3UBQtCjinTnEz3r5R
	 47I9voNDEgtJQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 18 Aug 2026 12:29:36 +0200
Subject: [PATCH 1/4] signal: allow taks to temporarily block
 TIF_NOTIFY_SIGNAL
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-work-tif_notify_signal-v1-1-1ee1fcc5b3ff@kernel.org>
References: <20260818-work-tif_notify_signal-v1-0-1ee1fcc5b3ff@kernel.org>
In-Reply-To: <20260818-work-tif_notify_signal-v1-0-1ee1fcc5b3ff@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: Peter Zijlstra <peterz@infradead.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Steve French <sfrench@samba.org>, linux-fsdevel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2967; i=brauner@kernel.org;
 h=from:subject:message-id; bh=GPNbpnB0jcJa4smLJiVmwCjZkDxhRfuvI09qEeH/sQI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1mEhMmtW6JHi34afW+Y4Xd9+seZh6RISx1cdEKOGKY
 EnJUbmJHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABN5EMnwPy8y6+uZ9jMZM9t4
 fWwsyg5ctN34SCH2zaaLSSdffNLt9GT4w7NLPbl5YWnU+X6JffsmPo2ZJ53ntdfNeqN4qcCiGVK
 TGQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

TIF_NOTIFY_SIGNAL is used to kick a task in uninterruptible sleep to
return to userspace and run task work and then go back to sleep. This
mechanism works well but breaks e.g., coredumps. dump_interrupted() only
allows fatal signals to interrupt a coredump and the whole regular write
path going to actual filesystems is impervious to TIF_NOTIFY_SIGNAL as
well.

Add PF_NO_NOTIFY_SIGNAL and helpers to raise and restore it. This is the
same approach as memalloc_nofs_save(). signal_pending() will not report
a fake pending signal via TIF_NOTIFY_SIGNAL if inside a
PF_NO_NOTIFY_SIGNAL section.

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/sched.h        |  2 +-
 include/linux/sched/signal.h | 21 +++++++++++++++++++--
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 373bcc0598d1..fd72ca4ee92f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1796,7 +1796,7 @@ extern struct pid *cad_pid;
 						 * I am cleaning dirty pages from some other bdi. */
 #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
 #define PF_RANDOMIZE		0x00400000	/* Randomize virtual address space */
-#define PF__HOLE__00800000	0x00800000
+#define PF_NO_NOTIFY_SIGNAL	0x00800000	/* see no_notify_signal_save() */
 #define PF__HOLE__01000000	0x01000000
 #define PF__HOLE__02000000	0x02000000
 #define PF_NO_SETAFFINITY	0x04000000	/* Userland is not allowed to meddle with cpus_mask */
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 584ae88b435e..3182de4ff948 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -384,14 +384,31 @@ static inline int task_sigpending(struct task_struct *p)
 	return unlikely(test_tsk_thread_flag(p,TIF_SIGPENDING));
 }
 
+/* Prevent TIF_NOTIFY_SIGNAL from interrupting this task. */
+static inline unsigned int no_notify_signal_save(void)
+{
+	unsigned int flags = current->flags & PF_NO_NOTIFY_SIGNAL;
+
+	current->flags |= PF_NO_NOTIFY_SIGNAL;
+	return flags;
+}
+
+/* Restore TIF_NOTIFY_SIGNAL. */
+static inline void no_notify_signal_restore(unsigned int flags)
+{
+	current_restore_flags(flags, PF_NO_NOTIFY_SIGNAL);
+}
+
 static inline int signal_pending(struct task_struct *p)
 {
 	/*
 	 * TIF_NOTIFY_SIGNAL isn't really a signal, but it requires the same
 	 * behavior in terms of ensuring that we break out of wait loops
-	 * so that notify signal callbacks can be processed.
+	 * so that notify signal callbacks can be processed. Not for a task
+	 * that asked not to be interrupted by it, see no_notify_signal_save().
 	 */
-	if (unlikely(test_tsk_thread_flag(p, TIF_NOTIFY_SIGNAL)))
+	if (unlikely(test_tsk_thread_flag(p, TIF_NOTIFY_SIGNAL)) &&
+	    likely(!(READ_ONCE(p->flags) & PF_NO_NOTIFY_SIGNAL)))
 		return 1;
 	return task_sigpending(p);
 }

-- 
2.53.0

