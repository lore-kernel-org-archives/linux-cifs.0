Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5942DB7BA
	for <linux-cifs@vger.kernel.org>; Sat, 11 Apr 2026 08:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775897819; cv=none; b=f4Ys9EDqjS9QcUe6cN2RxAbgs3IlN27XJiEWA7ZG4UXSUGlwXxgNhzTT5liTFONcfnyIwCDQQ3g+g+oUeSX2+7tw5vbBIkf5tEih50G50U9o/c8xSvDSVnmT8rT3qGsUPLUVtvvm9jib2RwKBah6V6O3aOzB9637wfMcXY558Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775897819; c=relaxed/simple;
	bh=6IyTjJ0FkMoSea9J+AGLQ3aUcY30PRNbR4NncpohA1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uP9ictIRDIkdNmGFGMKzxz/7XlbhC7P4HloROOgq0t7u5d5CJJJ/789zkx/XQaprY3x5Y3+MzTRApQgYUXXCpshVKEiTRNnPKdGINMtVFpdH3zrVyZT3hEVpMnGUdEiCv63UsjZaBiyZQ3WQsBSoeS58gZ0rZWYKo1MyBUuUCbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K94+BNzv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K94+BNzv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775897816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ki83Ytu611LIH2psopIG9xX0z9ofN4J/Dowiy8MC1r8=;
	b=K94+BNzvmivxa4GX3Accthd7ISKqlZeQ2YbvYV/VrBfH3zcCpgMGXQXu5BsnjFnfT8AvLX
	XIqw1t0nbloY4MIVeHyOBQu1VMcl+SeUDlc+/smiUX1vwl32bRZ++oaJB3UPrNeu0NwMd9
	wp1ubv1c8E6uG/6FS7NaOhCfzvdk7YU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-391-J6cteSNxMlWcHbnBDMk3Og-1; Sat,
 11 Apr 2026 04:56:52 -0400
X-MC-Unique: J6cteSNxMlWcHbnBDMk3Og-1
X-Mimecast-MFC-AGG-ID: J6cteSNxMlWcHbnBDMk3Og_1775897811
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B92B1956080;
	Sat, 11 Apr 2026 08:56:51 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.47])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 179D6195608E;
	Sat, 11 Apr 2026 08:56:46 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.com>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] netfs: Miscellaneous fixes
Date: Sat, 11 Apr 2026 09:56:38 +0100
Message-ID: <20260411085643.3221565-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Hi Christian,

Here are some miscellaneous fixes for netfslib:

 (1) Fix triggering of a VM_BUG_ON_FOLIO() in netfs_write_begin().

 (2) Fix error handling in netfs_extract_user_iter().

 (3) Fix the dentry refcounting in cachefiles_cull().

 (4) Fix netfs_invalidate_folio() to clear the page dirty bit if all dirty
     data removed.

The patches can also be found here:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=netfs-fixes

Thanks,
David

David Howells (1):
  netfs: Fix netfs_invalidate_folio() to clear dirty bit if all changes
    gone

NeilBrown (1):
  cachefiles: fix incorrect dentry refcount in cachefiles_cull()

Paulo Alcantara (1):
  netfs: fix error handling in netfs_extract_user_iter()

Viacheslav Dubeyko (1):
  netfs: fix VM_BUG_ON_FOLIO() issue in netfs_write_begin() call

 fs/cachefiles/namei.c        |  5 +++++
 fs/netfs/iterator.c          | 13 ++++++++++---
 fs/netfs/misc.c              |  6 +++++-
 fs/netfs/read_retry.c        | 11 +++++++++--
 include/trace/events/netfs.h |  4 ++++
 5 files changed, 33 insertions(+), 6 deletions(-)

