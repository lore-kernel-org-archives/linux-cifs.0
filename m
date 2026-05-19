Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431B046AF3F
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 09:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779184368; cv=none; b=eC5f/dNdkxOpXUT3+hsP/tZBmBQo6PKuLEx3ilfC/9kQQfLTKrzRIzDxhANBDj5o6i3/rreMbt7tMuhiW/yyo2DjlcFv3YoMqzM+NGyUBdcMJzXFhInAN264swZVHqhp++PrLeta7iNhd1eSU96uK/xU8lVH3qdwMieDi3Tvo/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779184368; c=relaxed/simple;
	bh=7fywuZDVlrKGc4sNwnLRbmxTTcSYBixNNk6w+oyBrYE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BPixEXXMv5u4RZmIUKrmcqXQ5AsHoPYO7mNtOJJzGqyp0orhpLSlJxOMHahT40lBqg/UwyzuyfUhGjRluEuuKLtS/rjZs3hdBAUBTD6JTZpCUas2lPacNqEk2RCYzM+uaQn4gQ1ioMfs94mofIFT3DAqthoJAP4Nu+8ju9EvqCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=A66L2SYY; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="A66L2SYY"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1779184358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RZnAfTaRdKpYgWzZwegkttBv6QiAhqTCTRDs5T6MgUk=;
	b=A66L2SYY2PPOEPC879BYS+X9IuzBLIIcP+o3U2Dfjr6gnwuk8lMmwSV4xd5ZKz207exHTE
	zeXxXPAJXhQQyvxbFYk6l3+dJe+SoEUqkrY7g1UUWMxK/pJf5ev1nxEeIFNTOjapGWqAdY
	b1BWWie17uzV1kzUjN+dYC7BGz/leRO8qjN2nHk3oDFeRRQqPSqJ3e0/qWXS902mLy2kGS
	WVXX0naF6okx17/Zg7V1ar2reL3MrSBwTJ7/8skxAbIMMT2YI74/e0Vw8GiCa+s5WpEQLP
	y3IOd/kUlJv6dELXrJBy1zsWFg+HrsYpSqLbfW3sseXM5e2lAv3mrD+Lp6zEPw==
From: chenxiaosong@chenxiaosong.com
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH samba] smbclient: cancel pending notify on SIGINT
Date: Tue, 19 May 2026 09:51:13 +0000
Message-ID: <20260519095113.289692-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

When client stops querying a directory for change notifications, it should
send a cancel request to the server.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 source3/client/client.c | 57 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 54 insertions(+), 3 deletions(-)

diff --git a/source3/client/client.c b/source3/client/client.c
index 1d3656aab34..7fa850a6dd9 100644
--- a/source3/client/client.c
+++ b/source3/client/client.c
@@ -45,6 +45,7 @@
 #include "lib/cmdline/cmdline.h"
 #include "libcli/smb/reparse.h"
 #include "lib/param/param.h"
+#include "lib/util/tevent_ntstatus.h"
 
 #ifndef REGISTER
 #define REGISTER 0
@@ -4653,12 +4654,40 @@ static int cmd_newer(TALLOC_CTX *mem_ctx)
  Watch directory changes
 ****************************************************************************/
 
+struct notify_state {
+	struct tevent_req *notify_req;
+	bool cancelled;
+};
+
+static void
+notify_sig_int_handler(
+	struct tevent_context *ev,
+	struct tevent_signal *se,
+	int signum,
+	int count,
+	void *siginfo,
+	void *private_data)
+{
+	struct notify_state *state = (struct notify_state *)private_data;
+
+	if (state->notify_req) {
+		state->cancelled = tevent_req_cancel(state->notify_req);
+	}
+}
+
 static int cmd_notify(TALLOC_CTX *mem_ctx)
 {
 	TALLOC_CTX *frame = talloc_stackframe();
 	char *name, *buf;
 	NTSTATUS status;
 	uint16_t fnum;
+	struct tevent_req *req;
+	struct tevent_context *ev;
+	struct tevent_signal *se;
+	struct notify_state sig_state = {
+		.notify_req = NULL,
+		.cancelled = false,
+	};
 
 	name = talloc_strdup(talloc_tos(), client_get_cur_dir());
 	if (name == NULL) {
@@ -4684,14 +4713,36 @@ static int cmd_notify(TALLOC_CTX *mem_ctx)
 		goto fail;
 	}
 
+	ev = samba_tevent_context_init(frame);
+	if (!ev)
+		goto fail;
+
+	se = tevent_add_signal(ev, frame, SIGINT, 0, notify_sig_int_handler, &sig_state);
+	if (!se)
+		goto fail;
+
 	while (1) {
 		uint32_t i;
 		uint32_t num_changes = 0;
 		struct notify_change *changes = NULL;
 
-		status = cli_notify(cli, fnum, 1000, FILE_NOTIFY_CHANGE_ALL,
-				    true,
-				    talloc_tos(), &num_changes, &changes);
+		req = cli_notify_send(frame, ev, cli, fnum, 1000, FILE_NOTIFY_CHANGE_ALL, true);
+		if (!req) {
+			goto fail;
+		}
+		sig_state.notify_req = req;
+
+		if (!tevent_req_poll_ntstatus(req, ev, &status)) {
+			goto fail;
+		}
+
+		status = cli_notify_recv(req, talloc_tos(), &num_changes, &changes);
+
+		if (sig_state.cancelled) {
+			printf("notify cancelled\n");
+			goto fail;
+		}
+
 		if (NT_STATUS_EQUAL(status, NT_STATUS_NOTIFY_ENUM_DIR)) {
 			printf("NOTIFY_ENUM_DIR\n");
 			status = NT_STATUS_OK;
-- 
2.54.0

