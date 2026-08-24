Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF1B36AB57
	for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 12:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787572959; cv=none; b=rBWuK7Pz0plq9MSZqpMBG6Xt52viw57Y5YjVJ9JXwD+MMsSs76veSBfGLr1KLsiK7NPAmuBs9DS9Y6op9YwVroneOKQyJhj45qTz3l3mDNyMavlL5UdBlzDXOB5Ca5DXsFCUproDSPGUGpkIbJ3BdUCKS6X9HFNfIq+SyDgWbh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787572959; c=relaxed/simple;
	bh=A4NhaUz0PFgkxGsOQggbmrHpH8MhWSAoy5EKuQCcgtU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=micae1nUpqjOJ11PeZsQcGzM0OT57GE4QQfCuw5sHeerYENxC7xUYn0MXOwF1ioLPndoi3ozD2VTGMb6uccRU9pq5KMN4JbevcrpJxGj9F5BVZ+t80FGO2INrt6Jxcg/Nct+QFjBMr2aZPPsQv9Sx2C+G+ELyW7NCc5W1KDmM/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OAOReVTH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OAOReVTH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787572956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dm6eVdzu1lSXF3tT287Ob1G0/L65ulpkOnLX+ANQp8A=;
	b=OAOReVTHRsdTm5svl5xz7RSYjgmrEddUUjaGnhIuTX3h8yrvqUxmgWYjWTe6seErtfg/gM
	Rm2OJGDoDuQznKkNE+YkiQvIIcFaTFs14vT1aKg4RkqIgwlSj0gJ1dXMh0qA2QVUJLt4Fx
	4KH1OIQy4559gta7tg0Kn4NN0hW3018=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-259-3u4ezehPMn2u7Sv8Dqarwg-1; Mon,
 24 Aug 2026 08:02:34 -0400
X-MC-Unique: 3u4ezehPMn2u7Sv8Dqarwg-1
X-Mimecast-MFC-AGG-ID: 3u4ezehPMn2u7Sv8Dqarwg_1787572951
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AA256197751A;
	Mon, 24 Aug 2026 12:02:30 +0000 (UTC)
Received: from warthog.com (unknown [10.44.32.15])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5254A434;
	Mon, 24 Aug 2026 12:02:26 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] netfs, cachefiles: Miscellaneous fixes
Date: Mon, 24 Aug 2026 13:02:19 +0100
Message-ID: <20260824120224.504575-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Hi Christian,

Here are a couple of miscellaneous fixes for netfslib and one for cachefiles,
if you could pick them up?

 (1) Fix an uninitialised return value from netfs_unbuffered_write().

 (2) Fix read progress reporting to avoid 64-bit tearing on a 32-bit
     machine.  This has been modified from the previous submission as part
     of a different series to take account of a sashiko reported issue[1].

 (3) Fix a potential UAF/KASAN warning reported by sashiko[1] in cachefiles in
     which the coherency data buffer is cast to a __be64* and dereferenced in
     a tracepoint - even though it might not be at least that large (or
     aligned).

The patches can also be found here:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=netfs-fixes

Thanks,
David

[1] https://sashiko.dev/#/patchset/20260810144746.574036-1-dhowells%40redhat.com

David Howells (2):
  netfs: Fix read progress reporting
  cachefiles: Fix potential UAF/KASAN warning

Karl Mehltretter (1):
  netfs: Fix uninitialized return value in netfs_unbuffered_write()

 fs/cachefiles/xattr.c             | 16 ++++-----
 fs/netfs/buffered_read.c          |  4 +++
 fs/netfs/direct_write.c           |  2 +-
 fs/netfs/internal.h               |  1 +
 fs/netfs/objects.c                | 32 ++++++++++-------
 fs/netfs/read_collect.c           | 58 +++++++++++++++++++++++--------
 fs/netfs/read_single.c            |  2 ++
 include/linux/netfs.h             |  2 +-
 include/trace/events/cachefiles.h | 19 ++++++++--
 include/trace/events/netfs.h      | 21 +++++++++++
 10 files changed, 119 insertions(+), 38 deletions(-)

