Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5E6412279;
	Mon, 24 Aug 2026 12:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787573312; cv=none; b=epGyYH7YUK2h+HWgoTAskG9LrE+LIy2ng9qSgIiG/+27s5/yguOYl5+siV8RVop3a8GKlr2+7eXhHg2HY2XoehLmTJ6Q1Jfvs5gyMhjIsEKnRGr+cfjW6XzUAgVI6g8MiVg647hjhRcphCy5UlUQINdxkXp5qlgfivVnJkNqD6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787573312; c=relaxed/simple;
	bh=0rp4ZGU6IfSERPouoc34Y4ZlTojUvW1UTG3l6l2h0ow=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eVeNvMrQlUny+mCI6K7P/gFyzUZRoHR12ZKtPwb8/FVT39XwJ6YSGnayFSSlA9a/5BvSUapatatSKg5L4WdbnQ6kDKl/3iiA7Tt/GdOLVx0W+L+tVvXkbWuDxQ6y/n7aZghvuubNGbDYwqdTPfbgOFg9lMWobwo7S9Yw94M5ZCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LdPCSQI/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LdPCSQI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C831F00A3A;
	Mon, 24 Aug 2026 12:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787573311;
	bh=o8RHLBfpHqBP0lI5Ww81JVk0LKZH0X6CDHqTv7Kh0MQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LdPCSQI/6mZE7iWDb6UAjm7Yosxb6LA7ya8g31dEZL3BVHImOZ4ILDuq1/aKylY3H
	 ZiAwDiKAgwUYhp7cJhdmgK2hB+z9L9/wMg7plP8jtobvayup+tjLFBgs/zC8b9b9ye
	 R3I065igMKenf08Lqr0OfZBiFhJ99WR76Xf5w6vkpUq3G+8Xe2iRxQ0CMWjoYXEB8a
	 26e0VjIKQOPJshW/vwedjhFd+aLD5wKG2qxAoJvjzNbYxfZ2dfWjQ5kSQkN1Ax4xxa
	 bQ+1H0Qwl/0szb4R8Iojc78gF6n5o3bXSl6amf3HtRPZSrHtDJBDpP0JBoCIXoBJnS
	 CQWGx57yNDTVA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 24 Aug 2026 14:08:16 +0200
Subject: [PATCH v2 1/5] signal: allow taks to temporarily block
 TIF_NOTIFY_SIGNAL
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260824-work-tif_notify_signal-v2-1-6609e42b3157@kernel.org>
References: <20260824-work-tif_notify_signal-v2-0-6609e42b3157@kernel.org>
In-Reply-To: <20260824-work-tif_notify_signal-v2-0-6609e42b3157@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <peterz@infradead.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Steve French <sfrench@samba.org>, linux-fsdevel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3358; i=brauner@kernel.org;
 h=from:subject:message-id; bh=0rp4ZGU6IfSERPouoc34Y4ZlTojUvW1UTG3l6l2h0ow=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT1mFjmpxv94+it7Z085a5Hzt9jITOD/3vpa7EfYfcwS
 DnJoS7QUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMJFGTYb/OR+/tW746+N6uD20
 /2DczhK2pmNhWbXuWldiDPKmqKc+YGS4eXhyv+yJqFs7Tm19NNnz89P2lmAnYR6vTUZfE7fO5Tj
 KAgA=
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

Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/sched.h        |  2 +-
 include/linux/sched/signal.h | 27 +++++++++++++++++++++++++--
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3f100d69b053..82b43f20218a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1807,7 +1807,7 @@ extern struct pid *cad_pid;
 						 * I am cleaning dirty pages from some other bdi. */
 #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
 #define PF_RANDOMIZE		0x00400000	/* Randomize virtual address space */
-#define PF__HOLE__00800000	0x00800000
+#define PF_NO_NOTIFY_SIGNAL	0x00800000	/* see no_notify_signal_save() */
 #define PF__HOLE__01000000	0x01000000
 #define PF__HOLE__02000000	0x02000000
 #define PF_NO_SETAFFINITY	0x04000000	/* Userland is not allowed to meddle with cpus_mask */
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 584ae88b435e..6164995da980 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_SCHED_SIGNAL_H
 #define _LINUX_SCHED_SIGNAL_H
 
+#include <linux/cleanup.h>
 #include <linux/rculist.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
@@ -384,14 +385,36 @@ static inline int task_sigpending(struct task_struct *p)
 	return unlikely(test_tsk_thread_flag(p,TIF_SIGPENDING));
 }
 
+/* Prevent TIF_NOTIFY_SIGNAL from interrupting this task. */
+static inline unsigned int no_notify_signal_save(void)
+{
+	unsigned int flags = current->flags;
+
+	current->flags |= PF_NO_NOTIFY_SIGNAL;
+	return flags;
+}
+
+/* Restore the previous PF_NO_NOTIFY_SIGNAL state. */
+static inline void no_notify_signal_restore(unsigned int flags)
+{
+	current_restore_flags(flags, PF_NO_NOTIFY_SIGNAL);
+}
+
+DEFINE_LOCK_GUARD_0(no_notify_signal,
+		    _T->flags = no_notify_signal_save(),
+		    no_notify_signal_restore(_T->flags),
+		    unsigned int flags)
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

