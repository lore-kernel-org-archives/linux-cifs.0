Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7B446AF2D
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 10:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779186217; cv=none; b=NY0tQ/ZtJSiyjVSPAUqLNH3JLpLe3wuH0yl9S+ha2mdH6PQO0PrS8eyt3w1jpyRvpsM7ibIpEjXag3ykwH/kY3Coy+yAVvjNg0UkgAlxtl3rYOgF06Bqth7GWJDJmJiWVpBhagMxvMreL1X5a0ANQdM5xo+HxYSMadxJelF9ogc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779186217; c=relaxed/simple;
	bh=0C0oxU5WSjFNdDxdnVtbUM7f6dBk/2BN9/tB3L8uuig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gCT6NEe7A43Cyf0g20u0naPhuITYf8ZKCLq2hkW8A+gisVIZ7YuFgLrJ+K5JhXnXaoMhq23LrslF5RwvNxH6USX2YZTau/cK+rpzL44QfVmL4dZPSDucdQOMoNVEk0DK5i6sSPlbZBvxE+BFy1rbSDHSw89G8olew77CVtXPdUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FNrL5TW0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FNrL5TW0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779186214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qznz4sKC7x1xRadlwZi8CnPQ8HiiD1rNpPtHaviUXUo=;
	b=FNrL5TW0ScReqU8ffaZZKIOJTjMNl4ZHQ8XRNhAN4DmXLKyRVeg3NhHgMshwcjz4lztAaW
	DjkEt4ICK9pkmvVtKqtx9nFTFKAYh8uRAxDP+5fdy4NZnHLMkLs4fL96q5ebi+7SfHCBnV
	g7mvDu+ccBsvUdWG0MRD7r9IMymhIxc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-32-NbkSoDhPMi-ejqUt3dBuKg-1; Tue,
 19 May 2026 06:23:31 -0400
X-MC-Unique: NbkSoDhPMi-ejqUt3dBuKg-1
X-Mimecast-MFC-AGG-ID: NbkSoDhPMi-ejqUt3dBuKg_1779186210
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2FE1218002E0;
	Tue, 19 May 2026 10:23:30 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.33])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0A08418004A3;
	Tue, 19 May 2026 10:23:26 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Stefan Metzmacher <metze@samba.org>,
	Mina Almasry <almasrymina@google.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 17/36] cifs: Don't use corking
Date: Tue, 19 May 2026 11:21:35 +0100
Message-ID: <20260519102158.592165-18-dhowells@redhat.com>
In-Reply-To: <20260519102158.592165-1-dhowells@redhat.com>
References: <20260519102158.592165-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

We don't need to cork the TCP socket if we send each message in a single
sendmsg() and set MSG_EOR to mark the last packet of the message with a
don't-append flag.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/transport.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 3ead26f76112..e43fce1099a9 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -271,9 +271,11 @@ static int smb_sendmsg(struct TCP_Server_Info *server, const struct iov_iter *it
 	struct msghdr msg = {
 		/*
 		 * MSG_SPLICE_PAGES causes tcp_sendmsg() to splice in the pages
-		 * in the iterator rather than copying from them.
+		 * in the iterator rather than copying from them; MSG_EOR
+		 * indicates that the last TCP packet we create should be
+		 * marked no-append with regards to the next sendmsg.
 		 */
-		.msg_flags	= MSG_NOSIGNAL | MSG_SPLICE_PAGES,
+		.msg_flags	= MSG_NOSIGNAL | MSG_SPLICE_PAGES | MSG_EOR,
 		.msg_iter	= *iter,
 	};
 	int retries = 0;
@@ -362,10 +364,6 @@ __smb_send_rqst(struct TCP_Server_Info *server, struct iov_iter *iter)
 		goto out;
 	}
 
-	rc = 0;
-	/* cork the socket */
-	tcp_sock_set_cork(ssocket->sk, true);
-
 	/*
 	 * We should not allow signals to interrupt the network send because
 	 * any partial send will cause session reconnects thus increasing
@@ -381,9 +379,6 @@ __smb_send_rqst(struct TCP_Server_Info *server, struct iov_iter *iter)
 
 	sigprocmask(SIG_SETMASK, &oldmask, NULL);
 
-	/* uncork it */
-	tcp_sock_set_cork(ssocket->sk, false);
-
 	if (sent > 0) {
 		/*
 		 * If signal is pending but we have already sent the whole

