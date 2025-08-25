Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5754428F1
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 21:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155805; cv=none; b=dXyIP3IJkEokuul/EJcHO2feUzld9RdqLuzeHUzvAB7d2zfzT6ktVv9DNZ3xVwOeIWvx0j8BKujUNbd54x1xuoz2KA7YOJnAPJO1VtPhkbZcdlXdsFZutVw2EgPffESpctxmS+WrIQAJpjLLMyKpNPbqb6kPc/Tk5weU4aXcuBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155805; c=relaxed/simple;
	bh=vadTFeOE4I98kjM6LQ1e7A/bYgvjwXqvB6AujbMqdQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYVJSJ0wxeWpT4/BQ2dxor9MHaM1H/UEPzq1aFeg3Xs8EL0+i9IRu2KdeZZNnnWE8Ki1wf4tqsSYm1ADN4hsLQMwqRQGArmy5A1dCRvDDFrkaYjRDqT6AEAzlVJqVCA/g5PltWsLWtheoiZ0Lf9CGXetlbprI8/D+f0xYNYxS1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=17nAGOVx; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="17nAGOVx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=lts/FKhso1txEJ7cisPtnLdMQEn3Vhg6twxLZ5IsVi8=; b=17nAGOVx2vHVEeExFOsDtwgFrJ
	o8ZjvvkGaQp9YysPyjJEUvcWUK/lhF5IfHnU2zyJQpQlxsyqBnOG7dE4jiQStef4c2CVPDdSOQk27
	yHk/0sduXwx4Zpdi7OpMgF0ajabuZi9MiVGYEGdOEBEnmIAkH/4hcI9HOub2uHtVVa6E2vdmBX2Ra
	mk3L4n3hoA8qwOM2JNaW+xqN7vw3gjjK6gMbFQ3/VsC0KMtvygYmvBsVsQfsOF0ze9x/dAMSwPUel
	sBUA3DoqvUqrhY29yu7ZbyUI0HxVthEnsNUztUw+OkdUdBkrvwpWtqJPEHWfBzs69XGuC2yhAWzi3
	yAbyz+y8D+EU4yO9DZQdKQ4e7rTrE4xI/nkSs0mJHjTv/lpoWrLDRkIXDUtq3imUK5W1+E4wXfB9+
	gsdLJyx/Xmf94OMrxGi0ru7xAKnYoLir2QvSuMLvoYkklhBj08LFOjqylYrj5UUQ8Adr7fvDFI6RK
	+mKJsRbwjHZ5XVbAmLNYzRmN;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeLU-000nWD-1T;
	Mon, 25 Aug 2025 21:03:16 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 129/142] smb: server: remove unused struct struct smb_direct_transport argument from smb_direct_send_ctx_init()
Date: Mon, 25 Aug 2025 22:41:30 +0200
Message-ID: <ccf672589adf8f6805efd8d2b87a31e85b5126f7.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will make it easier to move function to the common code
in future.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 95f9552ef843..d2e587ae3931 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -896,8 +896,7 @@ static int smb_direct_post_send(struct smb_direct_transport *t,
 	return ret;
 }
 
-static void smb_direct_send_ctx_init(struct smb_direct_transport *t,
-				     struct smbdirect_send_batch *send_ctx,
+static void smb_direct_send_ctx_init(struct smbdirect_send_batch *send_ctx,
 				     bool need_invalidate_rkey,
 				     unsigned int remote_key)
 {
@@ -934,7 +933,7 @@ static int smb_direct_flush_send_list(struct smb_direct_transport *t,
 
 	ret = smb_direct_post_send(t, &first->wr);
 	if (!ret) {
-		smb_direct_send_ctx_init(t, send_ctx,
+		smb_direct_send_ctx_init(send_ctx,
 					 send_ctx->need_invalidate_rkey,
 					 send_ctx->remote_key);
 	} else {
@@ -1245,7 +1244,7 @@ static int smb_direct_writev(struct ksmbd_transport *t,
 	remaining_data_length = buflen;
 	ksmbd_debug(RDMA, "Sending smb (RDMA): smb_len=%u\n", buflen);
 
-	smb_direct_send_ctx_init(st, &send_ctx, need_invalidate, remote_key);
+	smb_direct_send_ctx_init(&send_ctx, need_invalidate, remote_key);
 	start = i = 1;
 	buflen = 0;
 	while (true) {
-- 
2.43.0

