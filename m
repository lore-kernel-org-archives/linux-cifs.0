Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBC813A411
	for <linux-cifs@vger.kernel.org>; Mon, 24 Jun 2024 11:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719228253; cv=none; b=dlMUBgxPIGrXKvzBzCp6zPIhqS0hrY5kZKYtXIU0sOCNeL7Yvnis55JGrw9FGWogbazjZqhkGhiNyin2CflmAhiHQNEM9F1UiqWdQGkbBMOh3NdPOmWNk8qRsfwLb2QaQFXMP/AL4MVRumOatkyn6NRB7PtvDtM+FlLYQ/Z0asQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719228253; c=relaxed/simple;
	bh=bGbOgZ7/GsB8UBgf0LqnNlTJgNKN+fPQoD9ErB4i4UQ=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=VmEKUD0qOC6WitkP/+ZzJnZeoh1ULi77IW7kMjTTg0gvBYthtl3kZAl0+lF/bWiXlnjwGr7O+XgAoThxQQM4gzSo3hCYwy2EncNfVY6sir/jkMPrSiQNHjrcLAilPv690IM+560Vq9NVzFuwZEEli8iQF+sRsGFyuh4g1m1LkpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XlaVjrhb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XlaVjrhb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719228251;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1MZhBdhakyXXyis3UviwdkIkQ/9gObuVjuoXkcPA6zY=;
	b=XlaVjrhbnRrERP8Cv6TBivdk0PyYHYLpx21htyTxZP5Bs+C4satOTTaNyliwPbSzRObdwi
	CdfI+xE/Y9Kaq/hI4W7dQr+DQv9hUzmmOi4Y/r5YznqdG5NkJHfStKy9c21xxTYvJlnm5K
	yVVXH+eE3Xq365inZVz/+o41aqHy3bo=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-145-O_GMqFPHO-OqoLHMuqV_Ew-1; Mon,
 24 Jun 2024 07:24:10 -0400
X-MC-Unique: O_GMqFPHO-OqoLHMuqV_Ew-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 24006195608C;
	Mon, 24 Jun 2024 11:24:08 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.111])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9D0541956051;
	Mon, 24 Jun 2024 11:24:04 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
    Matthew Wilcox <willy@infradead.org>
cc: dhowells@redhat.com, Jeff Layton <jlayton@kernel.org>,
    netfs@lists.linux.dev, v9fs@lists.linux.dev,
    linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
    linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: [PATCH] netfs: Fix netfs_page_mkwrite() to flush conflicting data, not wait
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <614299.1719228243.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 24 Jun 2024 12:24:03 +0100
Message-ID: <614300.1719228243@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Fix netfs_page_mkwrite() to use filemap_fdatawrite_range(), not
filemap_fdatawait_range() to flush conflicting data.

Fixes: 102a7e2c598c ("netfs: Allow buffered shared-writeable mmap through =
netfs_page_mkwrite()")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Matthew Wilcox <willy@infradead.org>
cc: Jeff Layton <jlayton@kernel.org>
cc: netfs@lists.linux.dev
cc: v9fs@lists.linux.dev
cc: linux-afs@lists.infradead.org
cc: linux-cifs@vger.kernel.org
cc: linux-mm@kvack.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_write.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index 05745bcc54c6..9cbbeeee6170 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -554,9 +554,9 @@ vm_fault_t netfs_page_mkwrite(struct vm_fault *vmf, st=
ruct netfs_group *netfs_gr
 	group =3D netfs_folio_group(folio);
 	if (group !=3D netfs_group && group !=3D NETFS_FOLIO_COPY_TO_CACHE) {
 		folio_unlock(folio);
-		err =3D filemap_fdatawait_range(mapping,
-					      folio_pos(folio),
-					      folio_pos(folio) + folio_size(folio));
+		err =3D filemap_fdatawrite_range(mapping,
+					       folio_pos(folio),
+					       folio_pos(folio) + folio_size(folio));
 		switch (err) {
 		case 0:
 			ret =3D VM_FAULT_RETRY;

