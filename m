Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFB632C85
	for <linux-cifs@vger.kernel.org>; Wed,  2 Jul 2025 07:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751440702; cv=none; b=SiRN6FcvlH8Yz9bLHVPUiv6qupl0uQcn3JLjM6pwY5Z64feC1LPXHYBAq5KLI/3GVKG6UE4XwrnJGnSpPFe7HGwhaVAAeUTyPQEt1WPs2elEd/bJK41wc03/Nag3LW6xu+8Qfe9tZ09yHIWcTYaaxwjDtSxjQvHzi+HsCIuKgpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751440702; c=relaxed/simple;
	bh=Bl1IGVPfjgc+Mn+yaC04zS2rbSCC95LKW9UjcNeHnpA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Kfola7/fi13CHmougHPowbTGLOoTfVJ/LXWfc1u9VsdA6YLWLOFauKkMt3H9Rq0Xmf6zYfI78B9LJVQExWuLcJZBg44uHRHTmoCg7d1Rav/LDCjJ3B4YYbMrI7GANO7V1H2NpQqW7ryZnjwraXipdZf1tmToWaBDa86eQaDitGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=AOMek+sn; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="AOMek+sn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-Id:Date:Cc:To:From;
	bh=VZLx/loH14Yx5Zd2sekAGIwetpGqLRxVgkW0h+1ZlMc=; b=AOMek+snl/IAIeY6roaucHfJHd
	936mDZpw7jjD0MtXM9+Bk98UcleNbuW+M4Kr3uhTcazbCYR73nQ/8lpiVimuSXjsvntE83AXWUqvJ
	3ZVL3dxRiPghqUbSTz16e3fqrTyPDUmHP+Di8IvRHuUhu8oVPGkRkwaEQ14/d8ZyhfcqlVwewePXq
	F6ii8oaL/yyuNzhSNUiGJrAICElF/2FVOjVCD/KKvyrtFR0N9NHpDG+txRmRzlVAPBkrqhAoWs0qB
	a3OY6lNS59FvBJ9QKjOlHBSM99OtvC9arznVBnigTSCbBj8Okm7FviY2Gkz5zHq/Tlzd2sojFD1DE
	oih0GZCn+BwRtnNHwIu3hPwRgKa9yKoeNt074q/2j5ikHBUq40XPIo98eZS197YXb6NBKr7URqRG9
	QudLDET20P2FuXn/kDU2+ud+9AlxPHyOhA/dwlZytAQVgApAOtN7n1rwzaRx5eMlzH12vJvlkpAcb
	yQTBLsH1M7hElelsL2KeqVx6;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uWrjN-00DTrq-2J;
	Wed, 02 Jul 2025 07:18:09 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH] smb: server: make use of rdma_destroy_qp()
Date: Wed,  2 Jul 2025 09:18:05 +0200
Message-Id: <20250702071805.2540741-1-metze@samba.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The qp is created by rdma_create_qp() as t->cm_id->qp
and t->qp is just a shortcut.

rdma_destroy_qp() also calls ib_destroy_qp(cm_id->qp) internally,
but it is protected by a mutex, clears the cm_id and also calls
trace_cm_qp_destroy().

This should make the tracing more useful as both
rdma_create_qp() and rdma_destroy_qp() are traces and it makes
the code look more sane as functions from the same layer are used
for the specific qp object.

trace-cmd stream -e rdma_cma:cm_qp_create -e rdma_cma:cm_qp_destroy
shows this now while doing a mount and unmount from a client:

  <...>-80   [002] 378.514182: cm_qp_create:  cm.id=1 src=172.31.9.167:5445 dst=172.31.9.166:37113 tos=0 pd.id=0 qp_type=RC send_wr=867 recv_wr=255 qp_num=1 rc=0
  <...>-6283 [001] 381.686172: cm_qp_destroy: cm.id=1 src=172.31.9.167:5445 dst=172.31.9.166:37113 tos=0 qp_num=1

Before we only saw the first line.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <stfrench@microsoft.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 64a428a06ace..c6cbe0d56e32 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -433,7 +433,8 @@ static void free_transport(struct smb_direct_transport *t)
 	if (t->qp) {
 		ib_drain_qp(t->qp);
 		ib_mr_pool_destroy(t->qp, &t->qp->rdma_mrs);
-		ib_destroy_qp(t->qp);
+		t->qp = NULL;
+		rdma_destroy_qp(t->cm_id);
 	}
 
 	ksmbd_debug(RDMA, "drain the reassembly queue\n");
@@ -1940,8 +1941,8 @@ static int smb_direct_create_qpair(struct smb_direct_transport *t,
 	return 0;
 err:
 	if (t->qp) {
-		ib_destroy_qp(t->qp);
 		t->qp = NULL;
+		rdma_destroy_qp(t->cm_id);
 	}
 	if (t->recv_cq) {
 		ib_destroy_cq(t->recv_cq);
-- 
2.34.1

