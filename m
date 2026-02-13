Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D2235F8B2;
	Fri, 13 Feb 2026 13:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990590; cv=none; b=VLp7qP4rch67toeWTe6hI2zxPmWdSSQRezUb6ULbJ7hlBf1a0t5oNHYiBLSnW6uUjVI5HzRMcg757kE9J2ZgQ2NjmjXYOL+XQAYH2EDFm9dz6K/ZdC7dOoU/IdE/aCbmJQSoiL64Dtz4kjJAQkuc2uBgWkl22lcyiwdqmHTMtY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990590; c=relaxed/simple;
	bh=yAtHvmUi83Sb5SL3jYpqdU2ncv5joiUCBdpz3b/8Knc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDiqNcyZiMrq+6pQTijJSywRFEDbPUANPbwyyNsyINlp4jugdO4oXhSKHlnVp2WSn9EIbelmNRWB+wSh4uhfXqm9jSOqW9WlCv2k8Ul6Hp8AvOWsz0732y96eU3Y3u+qtH8aqyXpXnZt2dwZf4g6GiXgs5ayuoN7soUUIVHztvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLHmPaI3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLHmPaI3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D216C116C6;
	Fri, 13 Feb 2026 13:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990590;
	bh=yAtHvmUi83Sb5SL3jYpqdU2ncv5joiUCBdpz3b/8Knc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLHmPaI3CgSAGNmgX6O/B0aEcbOIQCYU1WpTT6XvpH4lFXLccfktgngfeg0qKw7SV
	 cdP+9cc98KnAIlQ0IXyxhdjBKCbpFw0ri8yBjVprppPjquxXTKIznqi+OSvTRoO1Y7
	 05OTAXHlUmzliDdu5Opt+4kIthRS7ZxLRdCrTRIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.19 16/49] smb: client: let smbd_post_send() make use of request->wr
Date: Fri, 13 Feb 2026 14:47:35 +0100
Message-ID: <20260213134709.324836166@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
References: <20260213134708.713126210@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

commit bf1656e12a9db2add716c7fb57b56967f69599fa upstream.

We don't need a stack variable in addition.

Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smbdirect.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1105,7 +1105,6 @@ static int manage_keep_alive_before_send
 static int smbd_post_send(struct smbdirect_socket *sc,
 		struct smbdirect_send_io *request)
 {
-	struct ib_send_wr send_wr;
 	int rc, i;
 
 	for (i = 0; i < request->num_sge; i++) {
@@ -1121,14 +1120,14 @@ static int smbd_post_send(struct smbdire
 
 	request->cqe.done = send_done;
 
-	send_wr.next = NULL;
-	send_wr.wr_cqe = &request->cqe;
-	send_wr.sg_list = request->sge;
-	send_wr.num_sge = request->num_sge;
-	send_wr.opcode = IB_WR_SEND;
-	send_wr.send_flags = IB_SEND_SIGNALED;
+	request->wr.next = NULL;
+	request->wr.wr_cqe = &request->cqe;
+	request->wr.sg_list = request->sge;
+	request->wr.num_sge = request->num_sge;
+	request->wr.opcode = IB_WR_SEND;
+	request->wr.send_flags = IB_SEND_SIGNALED;
 
-	rc = ib_post_send(sc->ib.qp, &send_wr, NULL);
+	rc = ib_post_send(sc->ib.qp, &request->wr, NULL);
 	if (rc) {
 		log_rdma_send(ERR, "ib_post_send failed rc=%d\n", rc);
 		smbd_disconnect_rdma_connection(sc);


