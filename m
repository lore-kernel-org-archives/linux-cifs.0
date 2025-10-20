Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF182DF3D1
	for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 08:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760950025; cv=none; b=ADKFj0kAq94hC1Ndogfs/9KEmmGKf8vZ6rIAS1fZhM5EZ64Afm3pdF6mN2rb5inb8fX8AqEG0p3rb9Q9mbgzBX34TXSyr52ZPcSNf0EWkOAoo1F8xHVrnFpPtg/x8Gh7n4dpOy6dmNo6lkc/5l/qDoJipb5G76F69ZdFCoQOU/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760950025; c=relaxed/simple;
	bh=0p7pi7Yld99hBF6iVmp4sXJMuXA0SFTO3Ev1u98H2Y8=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=iBwbOb7Wo/0Wi1L92PwgQhBGJ7R4Sue5BEQ3FMSv+4J+fUQqYIEEhFKTrCIHDZ9wG56VGyhEDwdKaLM/9gc6WN7LoMvvSilLhPFjCcIaRuqNnG85O6uQKFbTckJsltTfmIGRSVvjrzORzYOt/YGSY+MqUP+kTbLOGFEA4Su3tYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K+gsLQB/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K+gsLQB/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760950022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=XjEQjZwf4EmHPbS5RjxLJjALrd9Cs6yyFcKWJJYHCAk=;
	b=K+gsLQB/jMurcvCnEsWqZX3RzRgcIopeCenp5bXYB8Yrj87NryKGj08SwJceh6f3p14tA2
	mDkLSj0X38FURmPH1ReXoYg3K29ZsgWrH+RBgoHMR94FsnFRTTPFYH7OaV8RlHXISla9SC
	vKrsQOy0a4gO/ZQiW4sJwLhgwvrUUlc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-688-LwPprkAhN6ODlYg8QAswsA-1; Mon,
 20 Oct 2025 04:47:00 -0400
X-MC-Unique: LwPprkAhN6ODlYg8QAswsA-1
X-Mimecast-MFC-AGG-ID: LwPprkAhN6ODlYg8QAswsA_1760950019
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0D91118002C1;
	Mon, 20 Oct 2025 08:46:59 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.57])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9129430001A2;
	Mon, 20 Oct 2025 08:46:57 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
cc: dhowells@redhat.com, Paulo Alcantara <pc@manguebit.org>,
    linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Fix TCP_Server_Info::credits to be signed
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1006941.1760950016.1@warthog.procyon.org.uk>
Date: Mon, 20 Oct 2025 09:46:56 +0100
Message-ID: <1006942.1760950016@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Fix TCP_Server_Info::credits to be signed, just as echo_credits and
oplock_credits are.  This also fixes what ought to get at least a
compilation warning if not an outright error in *get_credits_field() as a
pointer to the unsigned server->credits field is passed back as a pointer
to a signed int.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: linux-cifs@vger.kernel.org
---
 fs/smb/client/cifsglob.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 8f6f567d7474..b91397dbb6aa 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -740,7 +740,7 @@ struct TCP_Server_Info {
 	bool nosharesock;
 	bool tcp_nodelay;
 	bool terminate;
-	unsigned int credits;  /* send no more requests at once */
+	int credits;  /* send no more requests at once */
 	unsigned int max_credits; /* can override large 32000 default at mnt */
 	unsigned int in_flight;  /* number of requests on the wire to server */
 	unsigned int max_in_flight; /* max number of requests that were on wire */

