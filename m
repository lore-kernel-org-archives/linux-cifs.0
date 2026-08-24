Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF1F32ED34;
	Mon, 24 Aug 2026 12:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787573320; cv=none; b=ZKC6V52Q95+VtWj8AbJL35ZytcO4XTygkVYXJ3saGafJtuk4gOOxdJaNaYOi7mXvgt3lvYqSetF2qhmGxZPlO0pRxu6EeiebDIhewbvcYI8Foyq4aqeviy6tx06AJJxJhyxPrOnxSYVasEarcYSm+vtMuRw03M0W4NP4YfNwJSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787573320; c=relaxed/simple;
	bh=QGb3RG5lyIgUqH4kbCEpPCw/M0GKa5I2pj5SilAQlOU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ios/XSC2/oaFKBgeFM9l1JwkGjjVQ5aGN1gQi1mupFoebrCHsDVUCxvsLLogRJ/OXwH17NCGprCccyUVsUB9tyKRjkmI3XpRLVbpA2Efcxw56cuq0Vg/+NLZv50sOZOddX/kxkzCGqfQVKQVgDSFZ1+uWy6058hUVbUGhh17ixY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cMIThYTZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cMIThYTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC10E1F00A3A;
	Mon, 24 Aug 2026 12:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787573317;
	bh=DUEA/qneGQTRujvjwO1p968nTmU3uDlWe90U4CxGQqg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cMIThYTZhorK8YuFElNQkRult2MDkpYHJRD3Mm5MjlhTpQUBaw9OmhiykgZPD43I9
	 /SL801SXPz9bytThVnY+dupwFrqse3UpzS7o3kptkfVxvv5OEIfKtePHLWW8cKFRKB
	 wdbWZI64IsnCwWFeIby+UCs2PZrB8+Ay34DSfgmF1c8sQTMtNSAUxQi7ttsdjBymy6
	 2v5A5OIvjwPDYLE+kXBjF+gocNjNRVPG9VaAVoeRb4V9xLlbR6SpURZsSvgoMSGpzC
	 xBLijtyawdqNjlocaKGPiCo/a4EgDhuDu5CIwtnwFoBXAZ+LvPooVN/6/vBWBrm9db
	 TtbInG7RaZfXA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 24 Aug 2026 14:08:18 +0200
Subject: [PATCH v2 3/5] selftests/coredump: test that TIF_NOTIFY_SIGNAL
 doesn't truncate a coredump
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260824-work-tif_notify_signal-v2-3-6609e42b3157@kernel.org>
References: <20260824-work-tif_notify_signal-v2-0-6609e42b3157@kernel.org>
In-Reply-To: <20260824-work-tif_notify_signal-v2-0-6609e42b3157@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <peterz@infradead.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Steve French <sfrench@samba.org>, linux-fsdevel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=22336; i=brauner@kernel.org;
 h=from:subject:message-id; bh=QGb3RG5lyIgUqH4kbCEpPCw/M0GKa5I2pj5SilAQlOU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT1mFjWrXwl+odx6tfPAvwftiU81jr96MuvwjIrg1ieX
 y2/lr5k7ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIWg0jw5xbprO+vOqNdF42
 Ja2769T1+I1+SwVmfTza7ulVelNzlgjDf2+ZS316p3frvJmmt/yr1Ymrn06bV/z7tKOgYc1M116
 GVjYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Add a test that verifies that a coredump cannot be cut short by
TIF_NOTIFY_SIGNAL through io_uring running task work for uninterruptible
tasks.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/coredump/Makefile          |   7 +-
 .../selftests/coredump/coredump_notify_signal.h    |  29 ++
 .../coredump/coredump_notify_signal_helper.c       |  46 +++
 .../coredump/coredump_notify_signal_test.c         | 245 ++++++++++++++++
 tools/testing/selftests/coredump/coredump_test.h   |   1 +
 .../selftests/coredump/coredump_test_helpers.c     | 311 +++++++++++++++++++++
 6 files changed, 638 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/coredump/Makefile b/tools/testing/selftests/coredump/Makefile
index dece1a31d561..728f3c342eb9 100644
--- a/tools/testing/selftests/coredump/Makefile
+++ b/tools/testing/selftests/coredump/Makefile
@@ -3,7 +3,10 @@ CFLAGS += -Wall -O0 -g $(KHDR_INCLUDES) $(TOOLS_INCLUDES)
 
 TEST_GEN_PROGS := stackdump_test \
 		  coredump_socket_test \
-		  coredump_socket_protocol_test
+		  coredump_socket_protocol_test \
+		  coredump_notify_signal_test
+# Spawned by the kernel as the |helper, not a test of its own.
+TEST_GEN_FILES := coredump_notify_signal_helper
 TEST_FILES := stackdump
 
 include ../lib.mk
@@ -11,3 +14,5 @@ include ../lib.mk
 $(OUTPUT)/stackdump_test: coredump_test_helpers.c
 $(OUTPUT)/coredump_socket_test: coredump_test_helpers.c
 $(OUTPUT)/coredump_socket_protocol_test: coredump_test_helpers.c
+$(OUTPUT)/coredump_notify_signal_test: coredump_test_helpers.c
+$(OUTPUT)/coredump_notify_signal_helper: coredump_test_helpers.c
diff --git a/tools/testing/selftests/coredump/coredump_notify_signal.h b/tools/testing/selftests/coredump/coredump_notify_signal.h
new file mode 100644
index 000000000000..92868a43425c
--- /dev/null
+++ b/tools/testing/selftests/coredump/coredump_notify_signal.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __COREDUMP_NOTIFY_SIGNAL_H
+#define __COREDUMP_NOTIFY_SIGNAL_H
+
+#include <stdbool.h>
+#include <sys/types.h>
+
+/*
+ * Define a bunch of constants we need. We create a situation where the
+ * NT_FILE note blows past 200K. That's way beyond the default 64K
+ * pipe ring and past the ~36K an af_unix skb holds. So we force a write
+ * to come back short.
+ */
+#define NOTIFY_SIGNAL_MAP_COUNT		4000
+#define NOTIFY_SIGNAL_ANON_BYTES	(4UL << 20)
+#define NOTIFY_SIGNAL_STALL_US		200000
+#define NOTIFY_SIGNAL_MAPFILE		"/tmp/coredump.notify_signal.mapfile"
+#define NOTIFY_SIGNAL_TRIGGER		"/tmp/coredump.notify_signal.trigger"
+#define NOTIFY_SIGNAL_CORE_FILE		"/tmp/coredump.notify_signal.core"
+#define NOTIFY_SIGNAL_CORE_TMPFILE	"/tmp/coredump.notify_signal.core.tmp"
+#define NOTIFY_SIGNAL_SOCKET		"/tmp/coredump.notify_signal.socket"
+
+void crashing_child_notify_signal(void);
+bool coredump_io_uring_available(void);
+ssize_t recv_coredump_notify_signal(int fd, int fd_out, bool arm);
+long long coredump_expected_size(const char *path);
+
+#endif /* __COREDUMP_NOTIFY_SIGNAL_H */
diff --git a/tools/testing/selftests/coredump/coredump_notify_signal_helper.c b/tools/testing/selftests/coredump/coredump_notify_signal_helper.c
new file mode 100644
index 000000000000..849f5c1ea736
--- /dev/null
+++ b/tools/testing/selftests/coredump/coredump_notify_signal_helper.c
@@ -0,0 +1,46 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * The |helper half of coredump_notify_signal_test. The kernel spawns this
+ * with the coredump on stdin, so it cannot be part of the test binary.
+ * It saves the dump and, once the notes have started, trips the fifo the
+ * crashing task is polling so TIF_NOTIFY_SIGNAL is raised while the note
+ * write is in flight.
+ */
+
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+
+#include "coredump_notify_signal.h"
+
+int main(int argc, char *argv[])
+{
+	int fd_core_file;
+	ssize_t ret;
+
+	fd_core_file = open(NOTIFY_SIGNAL_CORE_TMPFILE,
+			    O_WRONLY | O_CREAT | O_TRUNC | O_CLOEXEC, 0600);
+	if (fd_core_file < 0) {
+		fprintf(stderr, "%s: open failed: %m\n", argv[0]);
+		return EXIT_FAILURE;
+	}
+
+	ret = recv_coredump_notify_signal(STDIN_FILENO, fd_core_file, true);
+	close(fd_core_file);
+	if (ret < 0)
+		goto err;
+
+	/* The test polls for this name, so only create it once it is whole. */
+	if (rename(NOTIFY_SIGNAL_CORE_TMPFILE, NOTIFY_SIGNAL_CORE_FILE)) {
+		fprintf(stderr, "%s: rename failed: %m\n", argv[0]);
+		goto err;
+	}
+
+	return EXIT_SUCCESS;
+
+err:
+	unlink(NOTIFY_SIGNAL_CORE_TMPFILE);
+	return EXIT_FAILURE;
+}
diff --git a/tools/testing/selftests/coredump/coredump_notify_signal_test.c b/tools/testing/selftests/coredump/coredump_notify_signal_test.c
new file mode 100644
index 000000000000..4a98ab141c41
--- /dev/null
+++ b/tools/testing/selftests/coredump/coredump_notify_signal_test.c
@@ -0,0 +1,245 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * A coredump is meant to be interrupted by SIGKILL and by the freezer and
+ * by nothing else. dump_interrupted() says so, but the blocking waits
+ * underneath it test signal_pending(), which is also true for
+ * TIF_NOTIFY_SIGNAL. A crashing task that has an io_uring completion land
+ * on it mid-dump therefore keeps dumping while every wait it enters bails
+ * out at once, and the dump is silently cut short. Nothing reports it:
+ * binfmt_elf sets has_dumped before it writes anything, so WCOREDUMP()
+ * says the dump worked.
+ *
+ * A coredump note is the only dump_emit() that exceeds what the transport
+ * takes in one go, so it is the one write that is certain to block. Both
+ * tests crash a child holding enough file backed mappings for its NT_FILE
+ * note to run past that, arm an io_uring poll on it, and trip the poll
+ * while the note is being written. What comes out has to be the whole
+ * dump.
+ */
+
+#include <fcntl.h>
+#include <limits.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+#include <sys/un.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "coredump_test.h"
+
+FIXTURE_SETUP(coredump)
+{
+	FILE *file;
+	int ret;
+
+	self->pid_coredump_server = -ESRCH;
+	self->fd_tmpfs_detached = -1;
+	file = fopen("/proc/sys/kernel/core_pattern", "r");
+	ASSERT_NE(NULL, file);
+
+	ret = fread(self->original_core_pattern, 1,
+		    sizeof(self->original_core_pattern), file);
+	ASSERT_TRUE(ret || feof(file));
+	ASSERT_LT(ret, sizeof(self->original_core_pattern));
+
+	self->original_core_pattern[ret] = '\0';
+	self->fd_tmpfs_detached = create_detached_tmpfs();
+	ASSERT_GE(self->fd_tmpfs_detached, 0);
+
+	ret = fclose(file);
+	ASSERT_EQ(0, ret);
+
+	/* A stale core file from a killed previous run would fake a pass. */
+	unlink(NOTIFY_SIGNAL_CORE_FILE);
+	/* And a stale socket would fail the server's bind. */
+	unlink(NOTIFY_SIGNAL_SOCKET);
+	unlink(NOTIFY_SIGNAL_TRIGGER);
+	ASSERT_EQ(mkfifo(NOTIFY_SIGNAL_TRIGGER, 0600), 0);
+}
+
+FIXTURE_TEARDOWN(coredump)
+{
+	const char *reason;
+	FILE *file;
+	int ret, status;
+
+	if (self->pid_coredump_server > 0) {
+		kill(self->pid_coredump_server, SIGTERM);
+		waitpid(self->pid_coredump_server, &status, 0);
+	}
+	unlink(NOTIFY_SIGNAL_CORE_FILE);
+	unlink(NOTIFY_SIGNAL_CORE_TMPFILE);
+	unlink(NOTIFY_SIGNAL_SOCKET);
+	unlink(NOTIFY_SIGNAL_TRIGGER);
+	unlink(NOTIFY_SIGNAL_MAPFILE);
+
+	file = fopen("/proc/sys/kernel/core_pattern", "w");
+	if (!file) {
+		reason = "Unable to open core_pattern";
+		goto fail;
+	}
+
+	ret = fprintf(file, "%s", self->original_core_pattern);
+	if (ret < 0) {
+		reason = "Unable to write to core_pattern";
+		goto fail;
+	}
+
+	ret = fclose(file);
+	if (ret) {
+		reason = "Unable to close core_pattern";
+		goto fail;
+	}
+
+	if (self->fd_tmpfs_detached >= 0) {
+		ret = close(self->fd_tmpfs_detached);
+		if (ret < 0) {
+			reason = "Unable to close detached tmpfs";
+			goto fail;
+		}
+		self->fd_tmpfs_detached = -1;
+	}
+
+	return;
+fail:
+	/* This should never happen */
+	fprintf(stderr, "Failed to cleanup coredump test: %s\n", reason);
+}
+
+/* Check that what the helper or the server saved is the whole dump. */
+static void check_whole_coredump(struct __test_metadata *const _metadata)
+{
+	long long expected;
+	struct stat st;
+
+	expected = coredump_expected_size(NOTIFY_SIGNAL_CORE_FILE);
+	ASSERT_GT(expected, 0);
+	ASSERT_EQ(stat(NOTIFY_SIGNAL_CORE_FILE, &st), 0);
+	ASSERT_EQ((long long)st.st_size, expected);
+}
+
+/*
+ * The dump goes to a |helper, so the reader is a separate program the
+ * kernel spawns. It saves what it received to NOTIFY_SIGNAL_CORE_FILE.
+ */
+TEST_F(coredump, notify_signal_pipe)
+{
+	char pattern[PATH_MAX], helper[PATH_MAX], *p;
+	struct stat st;
+	int status, i;
+	pid_t pid;
+	ssize_t n;
+
+	if (!coredump_io_uring_available())
+		SKIP(return, "io_uring not available");
+
+	n = readlink("/proc/self/exe", helper, sizeof(helper) - 1);
+	ASSERT_GT(n, 0);
+	helper[n] = '\0';
+	p = strstr(helper, "coredump_notify_signal_test");
+	ASSERT_NE(p, NULL);
+	ASSERT_LE((size_t)(p - helper) + sizeof("coredump_notify_signal_helper"),
+		  sizeof(helper));
+	strcpy(p, "coredump_notify_signal_helper");
+	if (access(helper, X_OK))
+		SKIP(return, "coredump_notify_signal_helper not built");
+
+	ASSERT_LT(snprintf(pattern, sizeof(pattern), "|%s", helper),
+		  (int)sizeof(pattern));
+	ASSERT_TRUE(set_core_pattern(pattern));
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+	if (pid == 0)
+		crashing_child_notify_signal();
+
+	ASSERT_EQ(waitpid(pid, &status, 0), pid);
+	ASSERT_TRUE(WIFSIGNALED(status));
+
+	/* The kernel does not wait for the helper, so poll for it. */
+	for (i = 0; i < 100; i++) {
+		if (!stat(NOTIFY_SIGNAL_CORE_FILE, &st) && st.st_size)
+			break;
+		usleep(100000);
+	}
+
+	check_whole_coredump(_metadata);
+}
+
+/* The same thing with the dump going to a coredump socket. */
+TEST_F(coredump, notify_signal_socket)
+{
+	pid_t pid, pid_coredump_server;
+	int ipc_sockets[2], status;
+	char pattern[PATH_MAX];
+	char c;
+
+	if (!coredump_io_uring_available())
+		SKIP(return, "io_uring not available");
+
+	ASSERT_EQ(socketpair(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0,
+			     ipc_sockets), 0);
+	ASSERT_LT(snprintf(pattern, sizeof(pattern), "@%s",
+			   NOTIFY_SIGNAL_SOCKET), (int)sizeof(pattern));
+	ASSERT_TRUE(set_core_pattern(pattern));
+
+	pid_coredump_server = fork();
+	ASSERT_GE(pid_coredump_server, 0);
+	if (pid_coredump_server == 0) {
+		int fd_server = -1, fd_coredump = -1, fd_core_file = -1;
+		int exit_code = EXIT_FAILURE;
+
+		close(ipc_sockets[0]);
+
+		fd_server = create_and_listen_unix_socket(NOTIFY_SIGNAL_SOCKET);
+		if (fd_server < 0)
+			goto out;
+		if (write_nointr(ipc_sockets[1], "1", 1) < 0)
+			goto out;
+		close(ipc_sockets[1]);
+
+		fd_coredump = accept4(fd_server, NULL, NULL, SOCK_CLOEXEC);
+		if (fd_coredump < 0)
+			goto out;
+
+		fd_core_file = open(NOTIFY_SIGNAL_CORE_FILE,
+				    O_WRONLY | O_CREAT | O_TRUNC | O_CLOEXEC,
+				    0600);
+		if (fd_core_file < 0)
+			goto out;
+
+		if (recv_coredump_notify_signal(fd_coredump, fd_core_file,
+						true) < 0)
+			goto out;
+
+		exit_code = EXIT_SUCCESS;
+out:
+		if (fd_core_file >= 0)
+			close(fd_core_file);
+		if (fd_coredump >= 0)
+			close(fd_coredump);
+		if (fd_server >= 0)
+			close(fd_server);
+		_exit(exit_code);
+	}
+	self->pid_coredump_server = pid_coredump_server;
+
+	EXPECT_EQ(close(ipc_sockets[1]), 0);
+	ASSERT_EQ(read_nointr(ipc_sockets[0], &c, 1), 1);
+	EXPECT_EQ(close(ipc_sockets[0]), 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+	if (pid == 0)
+		crashing_child_notify_signal();
+
+	ASSERT_EQ(waitpid(pid, &status, 0), pid);
+	ASSERT_TRUE(WIFSIGNALED(status));
+
+	wait_and_check_coredump_server(pid_coredump_server, _metadata, self);
+
+	check_whole_coredump(_metadata);
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/coredump/coredump_test.h b/tools/testing/selftests/coredump/coredump_test.h
index ed47f01fa53c..06f997ba47fd 100644
--- a/tools/testing/selftests/coredump/coredump_test.h
+++ b/tools/testing/selftests/coredump/coredump_test.h
@@ -9,6 +9,7 @@
 
 #include "../kselftest_harness.h"
 #include "../pidfd/pidfd.h"
+#include "coredump_notify_signal.h"
 
 #ifndef PAGE_SIZE
 #define PAGE_SIZE 4096
diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.c b/tools/testing/selftests/coredump/coredump_test_helpers.c
index 2a20faf9cb0a..f8d416180d5b 100644
--- a/tools/testing/selftests/coredump/coredump_test_helpers.c
+++ b/tools/testing/selftests/coredump/coredump_test_helpers.c
@@ -1,11 +1,18 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <assert.h>
+#include <elf.h>
+#include <endian.h>
 #include <errno.h>
 #include <fcntl.h>
 #include <limits.h>
+#include <link.h>
+#include <linux/stddef.h>
+#include <linux/io_uring.h>
+#include <linux/swab.h>
 #include <linux/coredump.h>
 #include <linux/fs.h>
+#include <poll.h>
 #include <pthread.h>
 #include <stdbool.h>
 #include <stdio.h>
@@ -13,7 +20,9 @@
 #include <string.h>
 #include <sys/epoll.h>
 #include <sys/ioctl.h>
+#include <sys/mman.h>
 #include <sys/socket.h>
+#include <sys/syscall.h>
 #include <sys/types.h>
 #include <sys/un.h>
 #include <sys/wait.h>
@@ -21,6 +30,7 @@
 
 #include "../filesystems/wrappers.h"
 #include "../pidfd/pidfd.h"
+#include "coredump_notify_signal.h"
 
 /* Forward declarations to avoid including harness header */
 struct __test_metadata;
@@ -381,3 +391,304 @@ void process_coredump_worker(int fd_coredump, int fd_peer_pidfd, int fd_core_fil
 		close(fd_coredump);
 	_exit(exit_code);
 }
+
+/*
+ * TIF_NOTIFY_SIGNAL coredump helpers.
+ *
+ * __dump_emit() takes anything short of a full write as the end of the
+ * dump, so every emit that blocks on a full transport can lose the rest
+ * of it. The NT_FILE note is the one emit that is certain to block,
+ * because it is the only one larger than the transport, so these helpers
+ * build a note large enough for that and then raise TIF_NOTIFY_SIGNAL on
+ * the dumping task while that write is in flight.
+ */
+
+static int io_uring_setup_raw(unsigned int entries, struct io_uring_params *p)
+{
+	return syscall(__NR_io_uring_setup, entries, p);
+}
+
+/* io_uring reads poll32_events back through swahw32() on big endian. */
+static __u32 notify_poll_mask(__u32 events)
+{
+#if defined(__BYTE_ORDER) && __BYTE_ORDER == __BIG_ENDIAN
+	return __swahw32(events);
+#else
+	return events;
+#endif
+}
+
+bool coredump_io_uring_available(void)
+{
+	struct io_uring_params p = {};
+	int fd;
+
+	fd = io_uring_setup_raw(1, &p);
+	if (fd < 0)
+		return false;
+	close(fd);
+	return true;
+}
+
+/*
+ * Arm a poll on @fd. io_uring leaves ctx->notify_method at TWA_SIGNAL
+ * unless the ring asks for SQPOLL or COOP_TASKRUN, so the completion runs
+ * set_notify_signal() against the task that submitted it. That is us, and
+ * we are about to become the coredumping task.
+ */
+static int arm_poll_notify(int trigger_fd)
+{
+	struct io_uring_params p = {};
+	unsigned int *sq_tail, *sq_array;
+	struct io_uring_sqe *sqes;
+	size_t sqring_sz;
+	void *sq;
+	int ring;
+
+	ring = io_uring_setup_raw(8, &p);
+	if (ring < 0)
+		return -1;
+
+	sqring_sz = p.sq_off.array + p.sq_entries * sizeof(unsigned int);
+	sq = mmap(NULL, sqring_sz, PROT_READ | PROT_WRITE,
+		  MAP_SHARED | MAP_POPULATE, ring, IORING_OFF_SQ_RING);
+	if (sq == MAP_FAILED)
+		return -1;
+
+	sqes = mmap(NULL, p.sq_entries * sizeof(*sqes), PROT_READ | PROT_WRITE,
+		    MAP_SHARED | MAP_POPULATE, ring, IORING_OFF_SQES);
+	if (sqes == MAP_FAILED)
+		return -1;
+
+	sq_tail = (unsigned int *)((char *)sq + p.sq_off.tail);
+	sq_array = (unsigned int *)((char *)sq + p.sq_off.array);
+
+	memset(&sqes[0], 0, sizeof(sqes[0]));
+	sqes[0].opcode = IORING_OP_POLL_ADD;
+	sqes[0].fd = trigger_fd;
+	sqes[0].poll32_events = notify_poll_mask(POLLIN);
+
+	sq_array[0] = 0;
+	__atomic_store_n(sq_tail, 1, __ATOMIC_RELEASE);
+
+	if (syscall(__NR_io_uring_enter, ring, 1, 0, 0, NULL, 0) < 0)
+		return -1;
+
+	/* Deliberately leaked, we are about to crash. */
+	return 0;
+}
+
+/*
+ * Adjacent mappings with identical flags and contiguous file offsets are
+ * merged into one VMA, which would collapse NT_FILE back to nothing, so
+ * alternate the protection to keep every mapping an entry of its own.
+ * Not PROT_EXEC, /tmp is often mounted noexec. Nothing is ever written
+ * through these so they get no anon_vma and stay out of the dump itself.
+ */
+static int make_file_mappings(void)
+{
+	long pgsz = sysconf(_SC_PAGESIZE);
+	int fd, i;
+
+	fd = open(NOTIFY_SIGNAL_MAPFILE,
+		  O_RDWR | O_CREAT | O_TRUNC | O_CLOEXEC, 0600);
+	if (fd < 0)
+		return 0;
+	if (ftruncate(fd, (off_t)NOTIFY_SIGNAL_MAP_COUNT * pgsz)) {
+		close(fd);
+		return 0;
+	}
+
+	for (i = 0; i < NOTIFY_SIGNAL_MAP_COUNT; i++) {
+		int prot = (i & 1) ? PROT_READ : (PROT_READ | PROT_WRITE);
+
+		if (mmap(NULL, pgsz, prot, MAP_PRIVATE, fd,
+			 (off_t)i * pgsz) == MAP_FAILED)
+			break;
+	}
+	close(fd);
+	return i;
+}
+
+void crashing_child_notify_signal(void)
+{
+	long pgsz = sysconf(_SC_PAGESIZE);
+	unsigned char *p;
+	int trigger_fd;
+	unsigned long off;
+
+	/* Open the read side first so the reader's open() cannot block. */
+	trigger_fd = open(NOTIFY_SIGNAL_TRIGGER, O_RDONLY | O_NONBLOCK | O_CLOEXEC);
+
+	/* Exit rather than crash: a dump without the poll armed proves nothing. */
+	if (trigger_fd < 0)
+		_exit(EXIT_FAILURE);
+
+	if (make_file_mappings() < NOTIFY_SIGNAL_MAP_COUNT)
+		_exit(EXIT_FAILURE);
+
+	p = mmap(NULL, NOTIFY_SIGNAL_ANON_BYTES, PROT_READ | PROT_WRITE,
+		 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (p == MAP_FAILED)
+		_exit(EXIT_FAILURE);
+	for (off = 0; off < NOTIFY_SIGNAL_ANON_BYTES; off += pgsz)
+		p[off] = 1;
+
+	if (arm_poll_notify(trigger_fd))
+		_exit(EXIT_FAILURE);
+
+	/* crash on purpose */
+	*(volatile int *)NULL = 0;
+	_exit(EXIT_FAILURE);
+}
+
+static int pull_trigger(void)
+{
+	int fd;
+
+	fd = open(NOTIFY_SIGNAL_TRIGGER, O_WRONLY | O_NONBLOCK | O_CLOEXEC);
+	if (fd < 0) {
+		fprintf(stderr, "%s: open failed: %m\n", __func__);
+		return -1;
+	}
+	if (write(fd, "x", 1) != 1) {
+		fprintf(stderr, "%s: write failed: %m\n", __func__);
+		close(fd);
+		return -1;
+	}
+	close(fd);
+	return 0;
+}
+
+/*
+ * phdr[0] is the PT_NOTE entry: elf_core_dump() emits it right after the
+ * ELF header. Its p_offset is where the notes begin.
+ */
+static long long note_offset(const unsigned char *hdr)
+{
+	ElfW(Phdr) ph;
+	ElfW(Ehdr) eh;
+
+	memcpy(&eh, hdr, sizeof(eh));
+	if (memcmp(eh.e_ident, ELFMAG, SELFMAG) || eh.e_type != ET_CORE)
+		return -1;
+	memcpy(&ph, hdr + sizeof(eh), sizeof(ph));
+	if (ph.p_type != PT_NOTE)
+		return -1;
+	return (long long)ph.p_offset;
+}
+
+/*
+ * Drain a coredump off @fd, counting what arrives. Once the notes have
+ * started the kernel is inside the one big note write, so poke the fifo
+ * the crashing task is polling and stop reading, which keeps the
+ * transport full and the write blocked with a partial count when the
+ * wakeup lands. Then carry on to end of file.
+ *
+ * What arrives is written to @fd_out when that is not negative.
+ * Returns the number of bytes received, or -1. Failing to trip the fifo
+ * is an error too: a dump that was never interrupted proves nothing.
+ */
+ssize_t recv_coredump_notify_signal(int fd, int fd_out, bool arm)
+{
+	unsigned char hdr[sizeof(ElfW(Ehdr)) + sizeof(ElfW(Phdr))];
+	static char buf[64 << 10];
+	long pgsz = sysconf(_SC_PAGESIZE);
+	long long note_off = 0;
+	size_t hdrlen = 0;
+	ssize_t total = 0;
+	bool armed = false;
+
+	for (;;) {
+		ssize_t n = read(fd, buf, sizeof(buf));
+
+		if (n < 0) {
+			if (errno == EINTR)
+				continue;
+			return -1;
+		}
+		if (n == 0)
+			break;
+		if (fd_out >= 0 && write(fd_out, buf, n) != n)
+			return -1;
+
+		if (hdrlen < sizeof(hdr)) {
+			size_t want = sizeof(hdr) - hdrlen;
+
+			if (want > (size_t)n)
+				want = (size_t)n;
+			memcpy(hdr + hdrlen, buf, want);
+			hdrlen += want;
+			if (hdrlen == sizeof(hdr))
+				note_off = note_offset(hdr);
+		}
+
+		total += n;
+
+		if (arm && !armed && note_off > 0 &&
+		    total > note_off + (long long)pgsz) {
+			if (pull_trigger())
+				return -1;
+			armed = true;
+			usleep(NOTIFY_SIGNAL_STALL_US);
+			continue;
+		}
+	}
+
+	if (arm && !armed)
+		return -1;
+
+	return total;
+}
+
+/*
+ * How large the dump was meant to be. The ELF header and the program
+ * headers are the first thing emitted, so even a truncated dump says how
+ * far it should have run: the end is max(p_offset + p_filesz).
+ *
+ * That end is exact even when the last segment ends in a hole:
+ * coredump_write() flushes the pending cprm->to_skip with a final one
+ * byte emit and __dump_skip() writes zeroes for transports that cannot
+ * seek, so a whole dump carries every byte the headers promise.
+ */
+long long coredump_expected_size(const char *path)
+{
+	ElfW(Phdr) *phdr = NULL;
+	long long expected = 0;
+	unsigned int nphdr, i;
+	ElfW(Ehdr) eh;
+	int fd;
+
+	fd = open(path, O_RDONLY | O_CLOEXEC);
+	if (fd < 0)
+		return -1;
+	if (read(fd, &eh, sizeof(eh)) != sizeof(eh))
+		goto err;
+	if (memcmp(eh.e_ident, ELFMAG, SELFMAG) || eh.e_type != ET_CORE)
+		goto err;
+	if (!eh.e_phnum || eh.e_phentsize != sizeof(*phdr))
+		goto err;
+
+	nphdr = eh.e_phnum;
+	phdr = calloc(nphdr, sizeof(*phdr));
+	if (!phdr)
+		goto err;
+	if (pread(fd, phdr, (size_t)nphdr * sizeof(*phdr), (off_t)eh.e_phoff) !=
+	    (ssize_t)((size_t)nphdr * sizeof(*phdr)))
+		goto err;
+
+	for (i = 0; i < nphdr; i++) {
+		long long end = (long long)phdr[i].p_offset +
+				(long long)phdr[i].p_filesz;
+		if (end > expected)
+			expected = end;
+	}
+
+	free(phdr);
+	close(fd);
+	return expected;
+err:
+	free(phdr);
+	close(fd);
+	return -1;
+}

-- 
2.53.0

