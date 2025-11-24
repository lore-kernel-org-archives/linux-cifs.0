Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FEB303A07
	for <linux-cifs@vger.kernel.org>; Mon, 24 Nov 2025 12:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763988230; cv=none; b=dGZ7iDOFrXHIWdyNx2cbCTNB3G+FMI7Ve4xGxq75ZouYeaS96S+cR5fPfO4O7tpQGMBpomJVJroltBmaBm1DSz2jlg3MiRH5VzPSaJBjPFef0fo4HtxNf6jlJw1DJwQVRgCG5Q7ndai6LWOQkA/8ia+wSWQDSYeBoz9/+rlnocg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763988230; c=relaxed/simple;
	bh=9azUYLxcrprXapB2AW29/5U1XZ7wheGbaYw8wddL248=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nN+GgVSNE6NIPxr2EFszNw4mzf7CZkTStpng5lTw377hgDki4Fjrdn1J2k4FIihV98jzo0SDkA8H1QpRd72xzMrdXMyg+mhGxxXt17KKl/i/s6Esc+fvHPTM+2lI/iADyz9+AeT82SOBN3NXlU3UxaMqiqFqlRCxSOOZe6PT/1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bJuzlBKy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bJuzlBKy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763988226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7FUmnWmOFPZ/yS6/aSdvHVfj2x2LVbiiAoaubXk9WOA=;
	b=bJuzlBKyKQkLcJLlkHa0g/HymU1gbLubZBOJUCJYqBHXHsx5oyDpEHwfwdoP1WaFWMuhR2
	xi6mo7RIqJkhXpTLS6hk+SOodZVlGiJGANtIF98RothOJr83mEgM6xHKnjBbcU9m3mb1mX
	L6m9emKGsb6cdR9nJVHATXMFnN2K5cw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-204-hn7XBzfvPq67pNfCEiOL2g-1; Mon,
 24 Nov 2025 07:43:42 -0500
X-MC-Unique: hn7XBzfvPq67pNfCEiOL2g-1
X-Mimecast-MFC-AGG-ID: hn7XBzfvPq67pNfCEiOL2g_1763988220
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D448180057A;
	Mon, 24 Nov 2025 12:43:40 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.14])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3D1CE3003761;
	Mon, 24 Nov 2025 12:43:38 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Stefan Metzmacher <metze@samba.org>,
	linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 10/11] cifs: Don't need state locking in smb2_get_mid_entry()
Date: Mon, 24 Nov 2025 12:42:49 +0000
Message-ID: <20251124124251.3565566-11-dhowells@redhat.com>
In-Reply-To: <20251124124251.3565566-1-dhowells@redhat.com>
References: <20251124124251.3565566-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

There's no need to get ->srv_lock or ->ses_lock in smb2_get_mid_entry() as
all that happens of relevance (to the lock) inside the locked sections is
the reading of one status value in each.

Replace the locking with READ_ONCE() and use a switch instead of a chain of
if-statements.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/smb2transport.c | 48 +++++++++++++++--------------------
 1 file changed, 20 insertions(+), 28 deletions(-)

diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 6d76b0c6d73d..47eab3753c9e 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -684,43 +684,35 @@ static int
 smb2_get_mid_entry(struct cifs_ses *ses, struct TCP_Server_Info *server,
 		   struct smb2_hdr *shdr, struct smb_message **smb)
 {
-	spin_lock(&server->srv_lock);
-	if (server->tcpStatus == CifsExiting) {
-		spin_unlock(&server->srv_lock);
+	switch (READ_ONCE(server->tcpStatus)) {
+	case CifsExiting:
 		return -ENOENT;
-	}
-
-	if (server->tcpStatus == CifsNeedReconnect) {
-		spin_unlock(&server->srv_lock);
+	case CifsNeedReconnect:
 		cifs_dbg(FYI, "tcp session dead - return to caller to retry\n");
 		return -EAGAIN;
-	}
-
-	if (server->tcpStatus == CifsNeedNegotiate &&
-	   shdr->Command != SMB2_NEGOTIATE) {
-		spin_unlock(&server->srv_lock);
-		return -EAGAIN;
-	}
-	spin_unlock(&server->srv_lock);
-
-	spin_lock(&ses->ses_lock);
-	if (ses->ses_status == SES_NEW) {
-		if ((shdr->Command != SMB2_SESSION_SETUP) &&
-		    (shdr->Command != SMB2_NEGOTIATE)) {
-			spin_unlock(&ses->ses_lock);
+	case CifsNeedNegotiate:
+		if (shdr->Command != SMB2_NEGOTIATE)
 			return -EAGAIN;
-		}
-		/* else ok - we are setting up session */
+		break;
+	default:
+		break;
 	}
 
-	if (ses->ses_status == SES_EXITING) {
-		if (shdr->Command != SMB2_LOGOFF) {
-			spin_unlock(&ses->ses_lock);
+	switch (READ_ONCE(ses->ses_status)) {
+	case SES_NEW:
+		if (shdr->Command != SMB2_SESSION_SETUP &&
+		    shdr->Command != SMB2_NEGOTIATE)
+			return -EAGAIN;
+			/* else ok - we are setting up session */
+		break;
+	case SES_EXITING:
+		if (shdr->Command != SMB2_LOGOFF)
 			return -EAGAIN;
-		}
 		/* else ok - we are shutting down the session */
+		break;
+	default:
+		break;
 	}
-	spin_unlock(&ses->ses_lock);
 
 	*smb = smb2_mid_entry_alloc(shdr, server);
 	if (*smb == NULL)

