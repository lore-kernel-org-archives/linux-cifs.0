Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4829939F188
	for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 08:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776154818; cv=none; b=Vdc0mWLih4xot27YM+2GNvKHKhII1v8TKy3Gz4lhvfTf+6MgrjoySqItSMY4OfFOv5CMurXiqzG/ANnWVYj9P16adM8suEPMuU5j/QMaPfJOAcLmejy3j5ngQyczAgZiNhAKWF2A2HsaZ4aqgXS89LYN+KKTFoGgcfdVCbTF7ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776154818; c=relaxed/simple;
	bh=RhC+R54qGCrLtOGs/kexq8BEeVwPnNprlCSo1U9Xboo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=phcMe1x28RUu1EEqPe22/+ZJeknvWR/iRZXLj9lzaPlwiW3o49pNe46yWFHksZ4ue1UXElmoETPtdPNngp8XdV9SFKNaslTeJxtprZBNmf2roXCtk6PYPahk+3tX+2NuvqlXRLdeqOpBwZ2IJ6ay1J0/wZb6dusMBleuKioG8M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FqzDTgEi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FqzDTgEi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776154816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Lkc8n/nLblH1jEvDoVkgjW0PN6Sjk/z6iJKsA99eTN8=;
	b=FqzDTgEiceblGZ5fHMX+kocp5rNBSUUhqpHdq/dqmINUWqwLQKzaXbsFVFbM6woxhyRPbN
	s/fQIL25rdYxHvwDUVHH1Hu651xawUUtS4S0nfB8CGranKPxbJ4YYcwFgmtUShHeEvttrB
	4XI2x3BH4WO5fLWJilWAkkYxhVzlS9o=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634-nhsVnpmANDakYrVdo-RK2Q-1; Tue,
 14 Apr 2026 04:20:13 -0400
X-MC-Unique: nhsVnpmANDakYrVdo-RK2Q-1
X-Mimecast-MFC-AGG-ID: nhsVnpmANDakYrVdo-RK2Q_1776154812
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6970A1800650;
	Tue, 14 Apr 2026 08:20:11 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.34.160])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2F2E1195608E;
	Tue, 14 Apr 2026 08:20:07 +0000 (UTC)
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
Subject: [PATCH v2 0/7] netfs: Miscellaneous fixes
Date: Tue, 14 Apr 2026 09:19:56 +0100
Message-ID: <20260414082004.3756080-1-dhowells@redhat.com>
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

 (3) Fix netfs_invalidate_folio() to clear the folio dirty bit if all dirty
     data removed.

 (4) Fix the handling of a partially failed copy (ie. EFAULT) into a
     streaming write folio.  Also remove the netfs_folio if a streaming
     write folio is entirely overwritten.

 (5) Fix netfs_read_gaps() to remove the netfs_folio from a filled folio.

 (6) Fix the calculation of zero_point in netfs_release_folio() to limit it
     to ->remote_i_size, not ->i_size.

 (7) Fix netfs_perform_read() to not disable streaming writes when writing
     to an fd that's open O_RDWR.

The patches can also be found here:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=netfs-fixes

Thanks,
David

Changes
=======
ver #2)
- Rebase on v7.0
- Drop the cachefiles dentry count fix as that's now upstream.
- Add four new patches from testing the generic/522 xfstest.

David Howells (5):
  netfs: Fix netfs_invalidate_folio() to clear dirty bit if all changes
    gone
  netfs: Fix streaming write being overwritten
  netfs: Fix read-gaps to remove netfs_folio from filled folio
  netfs: Fix zeropoint update where i_size > remote_i_size
  netfs: Fix write streaming disablement if fd open O_RDWR

Paulo Alcantara (1):
  netfs: fix error handling in netfs_extract_user_iter()

Viacheslav Dubeyko (1):
  netfs: fix VM_BUG_ON_FOLIO() issue in netfs_write_begin() call

 fs/netfs/buffered_read.c     |  9 ++++---
 fs/netfs/buffered_write.c    | 51 +++++++++++++++++++++++-------------
 fs/netfs/iterator.c          | 13 ++++++---
 fs/netfs/misc.c              |  8 ++++--
 fs/netfs/read_retry.c        | 11 ++++++--
 include/trace/events/netfs.h |  5 ++++
 6 files changed, 69 insertions(+), 28 deletions(-)

