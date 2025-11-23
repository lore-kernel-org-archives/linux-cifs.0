Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E60B27E04C
	for <linux-cifs@vger.kernel.org>; Sun, 23 Nov 2025 23:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763942005; cv=none; b=MbowrZOAG/IW1Lfk4yLW0XQKI4uCrVxzrx1lwSAd1mbwNje5Ha+I6lPVUdiKlCs7ttyiKbX32ZWkqOc3H8X5Efs2hh/X2dMSjvCsGPTuFx2hMstMr1CEpkAUOrObBTKj7+46J7UWmZsgyo7aFkq0Qc0Id2XyAoitVdEbwejXy5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763942005; c=relaxed/simple;
	bh=dfj697H1h67D7hHtq07SOsJ7IR78dPGt8xJLON5lKNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lH++fxVJ0Fvaaym1X72X134hh7rSrJ2bs7G2ZsOfsP4tWW1lDWNW2jdBZu3sG51hw8HlUuafp722Rz6YTcwOfkABbNDhJTSuJfeUbCRTJFx8iPGcXKuxVFhRLmpt7x9KAcXJlgBBlFzYrbkaN+4DzM9nanqu1qfmp0L88mqOSHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=St1O2sQS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="St1O2sQS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763942001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VZTfKIqZMw/8ui18rUPwNiaq7K+/Orm6QqFRuL2B6Mw=;
	b=St1O2sQScYNHcrhU6WbhZAoIhzg+nBP+U0tldHjiCFthCIUb8f+IcUG0SCOtZdBxpPESUM
	SEmfRa5JiNnuignwpBeVl6o7imK2Ierm1NDlL8cieI8gVxo9XDDSeS/RtWdKM3NyJ92+ag
	3pN9UfX8wGT240p67+ZBzJTSAyAduME=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-139-OMoaXr22PGKYbIriUvLiXA-1; Sun,
 23 Nov 2025 18:53:17 -0500
X-MC-Unique: OMoaXr22PGKYbIriUvLiXA-1
X-Mimecast-MFC-AGG-ID: OMoaXr22PGKYbIriUvLiXA_1763941996
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D7AC318001D1;
	Sun, 23 Nov 2025 23:53:15 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.14])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 702B11800451;
	Sun, 23 Nov 2025 23:53:13 +0000 (UTC)
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
Subject: [PATCH v3 07/12] cifs: Make smb1's SendReceive() wrap cifs_send_recv()
Date: Sun, 23 Nov 2025 23:52:34 +0000
Message-ID: <20251123235242.3361706-8-dhowells@redhat.com>
In-Reply-To: <20251123235242.3361706-1-dhowells@redhat.com>
References: <20251123235242.3361706-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Make the smb1 transport's SendReceive() simply wrap cifs_send_recv() as
does SendReceive2().  This will then allow that to pick up the transport
changes there.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/cifstransport.c | 83 +++++------------------------------
 1 file changed, 10 insertions(+), 73 deletions(-)

diff --git a/fs/smb/client/cifstransport.c b/fs/smb/client/cifstransport.c
index d67b256a2ee7..1a0b80fc97d4 100644
--- a/fs/smb/client/cifstransport.c
+++ b/fs/smb/client/cifstransport.c
@@ -237,12 +237,12 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	    struct smb_hdr *in_buf, unsigned int in_len,
 	    struct smb_hdr *out_buf, int *pbytes_returned, const int flags)
 {
-	int rc = 0;
-	struct smb_message *smb;
+	struct TCP_Server_Info *server;
+	struct kvec resp_iov = {};
 	struct kvec iov = { .iov_base = in_buf, .iov_len = in_len };
 	struct smb_rqst rqst = { .rq_iov = &iov, .rq_nvec = 1 };
-	struct cifs_credits credits = { .value = 1, .instance = 0 };
-	struct TCP_Server_Info *server;
+	int resp_buf_type;
+	int rc = 0;
 
 	if (WARN_ON_ONCE(in_len > 0xffffff))
 		return -EIO;
@@ -273,78 +273,15 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 		return -EIO;
 	}
 
-	rc = wait_for_free_request(server, flags, &credits.instance);
-	if (rc)
-		return rc;
-
-	/* make sure that we sign in the same order that we send on this socket
-	   and avoid races inside tcp sendmsg code that could cause corruption
-	   of smb data */
-
-	cifs_server_lock(server);
-
-	rc = allocate_mid(ses, in_buf, &smb);
-	if (rc) {
-		cifs_server_unlock(server);
-		/* Update # of requests on wire to server */
-		add_credits(server, &credits, 0);
-		return rc;
-	}
-
-	rc = cifs_sign_smb(in_buf, in_len, server, &smb->sequence_number);
-	if (rc) {
-		cifs_server_unlock(server);
-		goto out;
-	}
-
-	smb->mid_state = MID_REQUEST_SUBMITTED;
-
-	rc = smb_send(server, in_buf, in_len);
-	cifs_save_when_sent(smb);
-
-	if (rc < 0)
-		server->sequence_number -= 2;
-
-	cifs_server_unlock(server);
-
+	rc = cifs_send_recv(xid, ses, ses->server,
+			    &rqst, &resp_buf_type, flags, &resp_iov);
 	if (rc < 0)
-		goto out;
-
-	rc = wait_for_response(server, smb);
-	if (rc != 0) {
-		send_cancel(server, &rqst, smb);
-		spin_lock(&smb->mid_lock);
-		if (smb->mid_state == MID_REQUEST_SUBMITTED ||
-		    smb->mid_state == MID_RESPONSE_RECEIVED) {
-			/* no longer considered to be "in-flight" */
-			smb->callback = release_mid;
-			spin_unlock(&smb->mid_lock);
-			add_credits(server, &credits, 0);
-			return rc;
-		}
-		spin_unlock(&smb->mid_lock);
-	}
-
-	rc = cifs_sync_mid_result(smb, server);
-	if (rc != 0) {
-		add_credits(server, &credits, 0);
 		return rc;
-	}
-
-	if (!smb->resp_buf || !out_buf ||
-	    smb->mid_state != MID_RESPONSE_READY) {
-		rc = -EIO;
-		cifs_server_dbg(VFS, "Bad MID state?\n");
-		goto out;
-	}
-
-	*pbytes_returned = smb->response_pdu_len;
-	memcpy(out_buf, smb->resp_buf, *pbytes_returned);
-	rc = cifs_check_receive(smb, server, 0);
-out:
-	delete_mid(smb);
-	add_credits(server, &credits, 0);
 
+	*pbytes_returned = resp_iov.iov_len;
+	if (resp_iov.iov_len)
+		memcpy(out_buf, resp_iov.iov_base, resp_iov.iov_len);
+	free_rsp_buf(resp_buf_type, resp_iov.iov_base);
 	return rc;
 }
 

