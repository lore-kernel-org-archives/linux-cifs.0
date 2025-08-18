Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B9F20126A;
	Mon, 18 Aug 2025 12:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521605; cv=none; b=P38ul2kl4X0PObU9d9Lrz6d0/igGJB8qc3hfFmYpMFQzECNm0eQhXG3FvyPE3xWiN9jj4pu4NoZmFjD1ge6gbETKVveW9RUbKhO/LkQaVU7G+oSfoZ0ZfjUxSGj8F0Iy2O0GCBpgqH6ADxqGoY4iSxAqpw5vr5OOi0KqVK36RYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521605; c=relaxed/simple;
	bh=4ag9/39dFWU8GkiOlWASTAeMNygUPvBXL7NuEXQxR7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hdbyusw3nTxuqMdWBEGdnw9ahi9LJz6v74zsD0NUNlzxrgDjmxXzzNgKENFKW3cmustxW9rqKZbp6S2an+s2HPheNxbISu8hkTfkuCxXkjNyjYlLLfuATRkKzppCSMLC9/9cH9OA2G9NG7tUAjdJDG6nwaYZ0F1KBOn90wn3ue8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qQsitWqI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qQsitWqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD79AC4CEEB;
	Mon, 18 Aug 2025 12:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521605;
	bh=4ag9/39dFWU8GkiOlWASTAeMNygUPvBXL7NuEXQxR7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qQsitWqIzzmSUDsr0D8usEOQWi4JmCBqlGyU7y3KpF5gzPX0VLVT5wUACsZKP1T9e
	 LodCbUNOoMKz4i/3gVrIQ1ouvq4bUWG4A6dlTc+nNuw+P3DYTWugLd0V5pBVr+d5w8
	 GhbpcQAcBTk+U3unEM6dISCISyQ0K4iAs4res3kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 043/444] smb: client: let send_done() cleanup before calling smbd_disconnect_rdma_connection()
Date: Mon, 18 Aug 2025 14:41:09 +0200
Message-ID: <20250818124450.554409951@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

commit 5349ae5e05fa37409fd48a1eb483b199c32c889b upstream.

We should call ib_dma_unmap_single() and mempool_free() before calling
smbd_disconnect_rdma_connection().

And smbd_disconnect_rdma_connection() needs to be the last function to
call as all other state might already be gone after it returns.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Fixes: f198186aa9bb ("CIFS: SMBD: Establish SMB Direct connection")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smbdirect.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -277,18 +277,20 @@ static void send_done(struct ib_cq *cq,
 	log_rdma_send(INFO, "smbd_request 0x%p completed wc->status=%d\n",
 		request, wc->status);
 
-	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
-		log_rdma_send(ERR, "wc->status=%d wc->opcode=%d\n",
-			wc->status, wc->opcode);
-		smbd_disconnect_rdma_connection(request->info);
-	}
-
 	for (i = 0; i < request->num_sge; i++)
 		ib_dma_unmap_single(sc->ib.dev,
 			request->sge[i].addr,
 			request->sge[i].length,
 			DMA_TO_DEVICE);
 
+	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
+		log_rdma_send(ERR, "wc->status=%d wc->opcode=%d\n",
+			wc->status, wc->opcode);
+		mempool_free(request, info->request_mempool);
+		smbd_disconnect_rdma_connection(info);
+		return;
+	}
+
 	if (atomic_dec_and_test(&request->info->send_pending))
 		wake_up(&request->info->wait_send_pending);
 


