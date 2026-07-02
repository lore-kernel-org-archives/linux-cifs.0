Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C90C40D572
	for <linux-cifs@vger.kernel.org>; Thu,  2 Jul 2026 08:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782980710; cv=none; b=hBNCmopBd57O0gtVPDZbEJelIA21rTpq0wnRFF6LqSURUOrAsWuStGSL3ukSI9SyQgXWm4N1N8z2wE08aSGA4slQGYxzpyUR3O3k87b4hB1NrpenclyQs0lOpTb9AG7H0gQvsDFSmsJRmIjaV7UXleHItJilzdydIu8+fs4ZFVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782980710; c=relaxed/simple;
	bh=HfgtOtkPnTZkqP0l+/lCuQCSuBXFO/omL6HTHwvhIWc=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=ThiUNARb2ir6XFwSywlVGS85Qh3AJJL6RUDFEli4tI+Bqlk3fQ4hnHPvGLVZcgt0k3v/2NjcGhBBnJ/GUHM0slfrNm+MLkkuvNGStJN7ZkNMNnYC+l5gRPAm6ZLsty9GfUy3eyTCHrMoexDo20w80L7o+KlmWH/wuhJd06NE4f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OJTgchan; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OJTgchan"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782980707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IEuW/QSzgrY+ZRrhZ3j8kkCyMYjASqMWanhrXEurUlM=;
	b=OJTgchan+a2XBO8M5vKKdCnHT4GyOSC02SeXFgwcQ7fv4R4D9sBJkXX2ZACWdVXRwI/fvf
	RJRH0cWDZaqNa4iTKSfMWNsO0Ogbp/e6qdHwCxeiRM5uu8wUZ13m7N10UDNm587cU+h423
	oN6JyYGcYIG8D7/bNy6wO79tXB6oOWY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-654-GvQoMCS9OW2t6w5xa65nAA-1; Thu,
 02 Jul 2026 04:25:06 -0400
X-MC-Unique: GvQoMCS9OW2t6w5xa65nAA-1
X-Mimecast-MFC-AGG-ID: GvQoMCS9OW2t6w5xa65nAA_1782980704
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 814A719541A5;
	Thu,  2 Jul 2026 08:25:04 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.33.159])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1BA2F3001D87;
	Thu,  2 Jul 2026 08:25:01 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
cc: dhowells@redhat.com, Paulo Alcantara <pc@manguebit.org>,
    Christian Brauner <brauner@kernel.org>, linux-cifs@vger.kernel.org,
    netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Fix missing credit release on failure in cifs_issue_read()
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <138901.1782980700.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 09:25:00 +0100
Message-ID: <138902.1782980700@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Fix missing release of credits in the failure path in cifs_issue_read()
lest retrying the subreq just overwrites the credits value.

Fixes: 69c3c023af25 ("cifs: Implement netfslib hooks")
Link: https://sashiko.dev/#/patchset/20260608145432.681865-1-dhowells%40re=
dhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/file.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 8b25d6c9ec5e..5a25635bc62a 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -241,6 +241,7 @@ static void cifs_issue_read(struct netfs_io_subrequest=
 *subreq)
 	return;
 =

 failed:
+	add_credits_and_wake_if(rdata->server, &rdata->credits, 0);
 	subreq->error =3D rc;
 	netfs_read_subreq_terminated(subreq);
 }

