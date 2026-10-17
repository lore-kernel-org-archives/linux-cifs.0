Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261C62D7DE9;
	Sat, 17 Oct 2026 16:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253237; cv=none; b=qgcZXdNRBM+ZHMr2cLf6bIFfc/iR6BESq+HLSBfMhHbTUmHfcDpW2hb/Tfb5yN3MUCc+FTSWKU7DySyMam0iOLEZGuPNeSpYfNCatHq9QNpaQAIpS8wN+bku/2MWp90Zc7lyFiOzZWjDzbwDaT2QD1VDV5A5UkRtqpRfjncoov4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253237; c=relaxed/simple;
	bh=fotNhI0M73xT3jr5mmOkMQnMKaQU5V4v+9/Qh4co7t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSBz/FJ9jKhckPj1lUWO2vH2O7lhakz4EX7P88DUS8lC+OJeZaCh9O+C3d2A2/IKvCgYS4nn81IWlSLpi3dN/vBW2lmuf7nz0UqcxqnOHAGUBfxqndncZx8lWe+h2YMedDAAxdyoBbA/S67ZnVqgCZ2tNzW7BNL2MBa87uMlA6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHEGODGN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHEGODGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0031F000C4;
	Sat, 17 Oct 2026 16:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253232;
	bh=SsL+wMSE34IdXruUYsqx//lWUePL408zTagiaLHVD4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EHEGODGNnNA2MdonrKRjpP6+aQxyJqX7h/A4dSEfyCEM3fUY5mmhQGrj8WhCDY56Z
	 +2mzISywte2orJRyS3w8pnaLKKoPGHwGeqI29nA6Z2CIZPipbQAIk9Z6Kr64lfg4zG
	 2D/yGk8bPPDrxDgvm2chYdaxUuIj3hb79OmHI5GA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 051/869] smb: client: fix compound alignment with encryption
Date: Sat, 17 Oct 2026 17:48:12 +0200
Message-ID: <20261017160038.329069932@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit 90f7c100d2dd99d5cd5be950d553edd2647e6cc8 upstream.

The encryption layer can't handle the padding iovs, so flatten the
compound request into a single buffer with required padding to prevent
the server from dropping the connection when finding unaligned
compound requests.

Fixes: bc925c1216f0 ("smb: client: improve compound padding in encryption")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2851,13 +2851,35 @@ smb2_set_next_command(struct cifs_tcon *
 	}
 
 	/* SMB headers in a compound are 8 byte aligned. */
-	if (!IS_ALIGNED(len, 8)) {
-		num_padding = 8 - (len & 7);
+	if (IS_ALIGNED(len, 8))
+		goto out;
+
+	num_padding = 8 - (len & 7);
+	if (smb3_encryption_required(tcon)) {
+		int i;
+
+		/*
+		 * Flatten request into a single buffer with required padding as
+		 * the encryption layer can't handle the padding iovs.
+		 */
+		for (i = 1; i < rqst->rq_nvec; i++) {
+			memcpy(rqst->rq_iov[0].iov_base +
+			       rqst->rq_iov[0].iov_len,
+			       rqst->rq_iov[i].iov_base,
+			       rqst->rq_iov[i].iov_len);
+			rqst->rq_iov[0].iov_len += rqst->rq_iov[i].iov_len;
+		}
+		memset(rqst->rq_iov[0].iov_base + rqst->rq_iov[0].iov_len,
+		       0, num_padding);
+		rqst->rq_iov[0].iov_len += num_padding;
+		rqst->rq_nvec = 1;
+	} else {
 		rqst->rq_iov[rqst->rq_nvec].iov_base = smb2_padding;
 		rqst->rq_iov[rqst->rq_nvec].iov_len = num_padding;
 		rqst->rq_nvec++;
-		len += num_padding;
 	}
+	len += num_padding;
+out:
 	shdr->NextCommand = cpu_to_le32(len);
 }
 


