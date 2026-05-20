Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0443EF0DA
	for <linux-cifs@vger.kernel.org>; Wed, 20 May 2026 15:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779291456; cv=none; b=tCU9Ksm7ClnYMyIweyxB9AOn/BgQOLSM9iX6b0dZVmvy8ygKNHHeZpEVP7Xe0B0sN8S8lQuTtzrKeqqZ6SWUvTb9WxxMynMohSrCNWVM818B3YO8idJjGeJbwO5GMJQoEPdonrThc8CqGGEoBVI3Jbejl2eI6fT+S/il744txgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779291456; c=relaxed/simple;
	bh=GYCE9NPtSuZUtSm97fSDkHhTRvA6tafzCS1+0FwZfjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cW+NuV7dIdy/VaJlxihpL4fyjko1u9iiXzRpdFJmIfsLTV8FPOvv4X9JPNMFMimPGJnqXacw27K/ftuG2byrolwvUT9vIH3MEzATwQ+9C4Be7QQPWMRhGDuMgrVJNFpSNaDj0u8pJm1ZyIfWgugKmIXTw5YMcSlxVvIVZQ7RRZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=igNKDhkk; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="igNKDhkk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1779291451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cf239SaL59Uic5cw3AIL/fdVQj4V5v9G7P0FRuP8ksk=;
	b=igNKDhkkcrIqcN4vkPE4gi2Oot7SFM58X5IBjHpzAiQxZokjPthsp+Yf/gjj21TjCNjg5k
	3zOAfcKHX3q57VK+XFYZt2mlSkTMQRK/QLCBjI73oI0pN1uzcrH40F32Vnq37rPpc8j1DR
	+XU1aIJCTVmEVRe59rarU9bGC3ItNP6wQPQUpOKTAy+lM/YFiEhbKdLoOniVfj/5VGAPvD
	A6NT5uxyMhIXIA2EdwI/33JupKcY/HxGO56lsT1BZeBNU2fsfnrodNG17HBxoybbumUlg8
	kYPTP9fuQbbPpakaKcsUaKFZHwZ7CdHWP6frx2ON9AZW8jRiFb5Lp0WF4N0k8w==
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
Subject: [PATCH samba v2 1/1] smbclient: cancel pending notify on SIGINT
Date: Wed, 20 May 2026 15:36:07 +0000
Message-ID: <20260520153607.347960-2-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260520153607.347960-1-chenxiaosong@chenxiaosong.com>
References: <20260520153607.347960-1-chenxiaosong@chenxiaosong.com>
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
 source3/client/client.c | 53 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 50 insertions(+), 3 deletions(-)

diff --git a/source3/client/client.c b/source3/client/client.c
index 1d3656aab34..b474e0608cb 100644
--- a/source3/client/client.c
+++ b/source3/client/client.c
@@ -45,6 +45,7 @@
 #include "lib/cmdline/cmdline.h"
 #include "libcli/smb/reparse.h"
 #include "lib/param/param.h"
+#include "lib/util/tevent_ntstatus.h"
 
 #ifndef REGISTER
 #define REGISTER 0
@@ -4653,12 +4654,39 @@ static int cmd_newer(TALLOC_CTX *mem_ctx)
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
@@ -4684,14 +4712,33 @@ static int cmd_notify(TALLOC_CTX *mem_ctx)
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
+		if (sig_state.cancelled) {
+			printf("notify cancelled\n");
+			goto fail;
+		}
+
+		req = cli_notify_send(frame, ev, cli, fnum, 1000, FILE_NOTIFY_CHANGE_ALL, true);
+		if (!req)
+			goto fail;
+		sig_state.notify_req = req;
+
+		if (!tevent_req_poll_ntstatus(req, ev, &status))
+			goto fail;
+
+		status = cli_notify_recv(req, talloc_tos(), &num_changes, &changes);
 		if (NT_STATUS_EQUAL(status, NT_STATUS_NOTIFY_ENUM_DIR)) {
 			printf("NOTIFY_ENUM_DIR\n");
 			status = NT_STATUS_OK;
-- 
2.54.0

