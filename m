Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C16513AA31
	for <linux-cifs@vger.kernel.org>; Fri, 19 Jul 2024 14:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721398163; cv=none; b=KLhEq/MRsLaQ4KSDpB2hSV0dLUZgN+998umybEHAdJ4trBW/WQjg0ltMRFYw7odI51tDMxg0V0lYKUz2MPm2AYL9vSfvPFLVh5004ng/V5xKtxV+IcYwQJUiGowNsFdTsxicwMj6SHn+N1ism4E5/xN5BDVrv8FCLbrHZ8hJ2cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721398163; c=relaxed/simple;
	bh=z9L2RRPN+yB281xxzltNv1j6Z1E9DHHvme/HdszIKGI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Oow6BO3LlJ+ji9SNTwRKFsTbVOk6qCtSjEdIZqQsUmrgvG7dgD1PVhVJUz4AMO31BFph3c7A260EEngDlvP3FeneDlv9bruss+EhkfGfm9Uu5rsmSYFdwAfm4O/55AFIIChI39Rk6HR/9bR9g1qKB+hNIiLz40oOUOOJuMTyTSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KKjfla7i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KKjfla7i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721398158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=X5yK/71Kg44cUzpHHgqsqEufCVRHK0VlMZT8SCa0wP0=;
	b=KKjfla7iq7gaa7UK5+Gcr1v5eOYmNSGsFPZ2Dqa+L1mQ0LdYLsSsz8luybQKfcWwaahAVU
	ScT6cWyQKhBnAuBebxBxly8faCE6QegV8/aUhEUwmCvFyG3Djf5LWrtF4Yy8bADlZMen2i
	8bKV4P3oFkydBvdyrZwfwWHBkeRqL4E=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-190-2jvLXaeHNIKDd_BWVd8HhQ-1; Fri,
 19 Jul 2024 10:09:15 -0400
X-MC-Unique: 2jvLXaeHNIKDd_BWVd8HhQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 84FB21944A92;
	Fri, 19 Jul 2024 14:09:13 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.216])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0027A3000188;
	Fri, 19 Jul 2024 14:09:10 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <nspmangalore@gmail.com>,
	Rohith Surabattula <rohiths.msft@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/4] cifs: Miscellaneous fixes and a trace point
Date: Fri, 19 Jul 2024 15:09:00 +0100
Message-ID: <20240719140907.1598372-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hi Steve,

Here are four patches for cifs:

 (1) Fix re-repick of a server upon subrequest retry.

 (2) Fix some error code setting that got accidentally removed.

 (3) Fix the handling of the zero_point after a DIO write.  It always needs
     to be bumped past the end of the DIO write.

 (4) Add a tracepoint and some debugging to keep track of when we've ended
     the ->in_flight contribution from an operation.

I've pushed the patches here also:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=cifs-fixes

David

David Howells (4):
  cifs: Fix server re-repick on subrequest retry
  cifs: Fix missing error code set
  cifs: Fix setting of zero_point after DIO write
  cifs: Add a tracepoint to track credits involved in R/W requests

 fs/smb/client/cifsglob.h  | 17 +++++++-----
 fs/smb/client/file.c      | 47 +++++++++++++++++++++++++++++----
 fs/smb/client/smb1ops.c   |  2 +-
 fs/smb/client/smb2ops.c   | 42 ++++++++++++++++++++++++++----
 fs/smb/client/smb2pdu.c   | 43 +++++++++++++++++++++++++-----
 fs/smb/client/trace.h     | 55 ++++++++++++++++++++++++++++++++++++++-
 fs/smb/client/transport.c |  8 +++---
 7 files changed, 184 insertions(+), 30 deletions(-)

