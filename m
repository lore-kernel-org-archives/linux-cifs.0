Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7F43CDBAA
	for <linux-cifs@vger.kernel.org>; Mon,  8 Jun 2026 14:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780928969; cv=none; b=s2xPXoRFmTvunMhSHdSfhMk8nbvtFNZqiB42JMHUajzl0oQe///BuAr9Jbd7CpXw1kNeWdbevVYzFLaZUmH9tr8FQCJhwIa+gn264h1A7uJM0PjuUQ1uVWkhquFLZCIJvfxLl5WCSZv3tN1fgFLU4b/Ena+klATFmCBIgqPhpRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780928969; c=relaxed/simple;
	bh=DkpihhTjpHPF+mbzuLJC/YfDpZqH4FAA8FOVnKZ+qr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TSVoJVkhQd+vZUqxMRZ4mW59qrY9mz+uLIXV1M0n2HYbJxbt1dyzBOD5NiShsug3HwA0oyhFpHlPnWWg03vvgJGcmbyI9EDlbh30myzQpsVLw701u9pR+XbXXCzPnoOJNpIv7SmDTk2YYs9irpxld2YH+kjJ/1FrmL/USHuUM1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=lzbCN4EC; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="lzbCN4EC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780928964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GQhJa6KB1UQaNvFLkmXIaU+jLvpVv1iVJ1szDNPtAV0=;
	b=lzbCN4ECVC0UciVdH7iaKTtgyQ3/U6v8+OwzZcz/3I1gjxFiIiU5Egf8/x24W4bnwUV9ht
	0dZeFAWSGOkp1pj61tRug9MbeKwtP2lTbeeMg/YDDGp5GDtsWfnvndABo87x8aZqOsDd4k
	bQ5ejSVB9lCv7s6V1o8zoSUjSd4nA9ZKrN2UXz03UlyMjQl/OjqfaZvoJj6qI2tdrYIz7D
	gTFxvhACa3CC5EXPcDSfCICLsI6TAEW5wBq99vM3Sce6thFumZLz78tKmdCujmKANy6GVr
	r3cGtisthIvp4AOXhEPePE/aibvxiljKf6ZaPWYKuJeajLnVy+fsaly1rv4qpA==
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
Subject: [PATCH samba v3 1/1] smbclient: cancel pending notify on SIGINT
Date: Mon,  8 Jun 2026 14:28:15 +0000
Message-ID: <20260608142815.388768-2-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260608142815.388768-1-chenxiaosong@chenxiaosong.com>
References: <20260608142815.388768-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

When client stops querying a directory for change notifications,
it should send a cancel request to the server.

After cancel notify succeeds, `status` returned by both
`tevent_req_poll_ntstatus()` and `cli_notify_recv()` is
`NT_STATUS_OK` rather than `NT_STATUS_CANCELLED`, so we
can only check `sig_state.cancelled`.

Suggested-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 source3/client/client.c | 64 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 57 insertions(+), 7 deletions(-)

diff --git a/source3/client/client.c b/source3/client/client.c
index 1d3656aab34..37693b8f401 100644
--- a/source3/client/client.c
+++ b/source3/client/client.c
@@ -45,6 +45,7 @@
 #include "lib/cmdline/cmdline.h"
 #include "libcli/smb/reparse.h"
 #include "lib/param/param.h"
+#include "lib/util/tevent_ntstatus.h"
 
 #ifndef REGISTER
 #define REGISTER 0
@@ -4653,19 +4654,46 @@ static int cmd_newer(TALLOC_CTX *mem_ctx)
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
+	if (state->notify_req)
+		state->cancelled = tevent_req_cancel(state->notify_req);
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
 		goto fail;
 	}
 	if (!next_token_talloc(talloc_tos(), &cmd_ptr, &buf, NULL)) {
-		goto usage;
+		goto fail;
 	}
 	name = talloc_asprintf_append(name, "%s", buf);
 	if (name == NULL) {
@@ -4684,14 +4712,33 @@ static int cmd_notify(TALLOC_CTX *mem_ctx)
 		goto fail;
 	}
 
+	ev = samba_tevent_context_init(frame);
+	if (!ev)
+		goto close;
+
+	se = tevent_add_signal(ev, frame, SIGINT, 0, notify_sig_int_handler, &sig_state);
+	if (!se)
+		goto close;
+
 	while (1) {
 		uint32_t i;
 		uint32_t num_changes = 0;
 		struct notify_change *changes = NULL;
 
-		status = cli_notify(cli, fnum, 1000, FILE_NOTIFY_CHANGE_ALL,
-				    true,
-				    talloc_tos(), &num_changes, &changes);
+		if (sig_state.cancelled) {
+			printf("notify cancelled\n");
+			goto close;
+		}
+
+		req = cli_notify_send(frame, ev, cli, fnum, 1000, FILE_NOTIFY_CHANGE_ALL, true);
+		if (!req)
+			goto close;
+		sig_state.notify_req = req;
+
+		if (!tevent_req_poll_ntstatus(req, ev, &status))
+			goto close;
+
+		status = cli_notify_recv(req, talloc_tos(), &num_changes, &changes);
 		if (NT_STATUS_EQUAL(status, NT_STATUS_NOTIFY_ENUM_DIR)) {
 			printf("NOTIFY_ENUM_DIR\n");
 			status = NT_STATUS_OK;
@@ -4699,7 +4746,7 @@ static int cmd_notify(TALLOC_CTX *mem_ctx)
 		if (!NT_STATUS_IS_OK(status)) {
 			d_printf("notify returned %s\n",
 				 nt_errstr(status));
-			goto fail;
+			goto close;
 		}
 		for (i=0; i<num_changes; i++) {
 			printf("%4.4x %s\n", changes[i].action,
@@ -4707,8 +4754,11 @@ static int cmd_notify(TALLOC_CTX *mem_ctx)
 		}
 		TALLOC_FREE(changes);
 	}
-usage:
-	d_printf("notify <dir name>\n");
+close:
+	status = cli_close(cli, fnum);
+	if (!NT_STATUS_IS_OK(status)) {
+		d_printf("close returned %s\n", nt_errstr(status));
+	}
 fail:
 	TALLOC_FREE(frame);
 	return 1;
-- 
2.54.0

