Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B321A6832
	for <linux-cifs@vger.kernel.org>; Mon, 27 Jul 2026 13:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785157678; cv=none; b=mwmyfAjjZt7uWSzckNH8eYOv57xVG9RRA3u9MbCJPNGp7Z3KFQ8Jhv/tB/po/lfeFgd32Zr2O+Q1n+D+Cwgt6Bm77oybzfwc6iIGNm/UxmkdvVGdnfh8EoWAWmy2TVnCg2uxriQoP4zBMb6ZAg4Yk+YZU9sONXOqkxgYoa3igZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785157678; c=relaxed/simple;
	bh=PixeBS1hh3BZX0SkZZcTCfrASeyD4fHEVusdBAlcel0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WVenlcTGd9SQ3VJHqhYEVpYdD2xqLU/BwDm+FfZEWtUfFcd0H9F7oXUUK9/FKukeom5yPwGK3vTGtIkb25GLCBvaIP4OBGFqfRUWiGryx9Ux6uw/GXgQ9ybEkqQlRbM/PsZAu+TZvPupx1WeQXHTzhV7Pg7yZ0RsI/nap2rTRCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QiOlrL5m; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QiOlrL5m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785157676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3EKPzNHczmFLavrL8Aq2DDXkrcGDtNuGqWVxKjxzUYU=;
	b=QiOlrL5mhyNbBobx0U6mYtK0qoLf8HR205NRt6xwMQHuOgB7G7iMzL+psl/a6zguDvARry
	/PqJoG2znCR3gyvbC1BlmCSGik41kFv1YfNUJMkZ3S1FbmsIwsbtX0ox1Hi75SLyLKSDPC
	/xT3Ts85QuN4R8LacyBd2u9bIqs2m3w=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-310-Ar4alRKcPJii6Czk98UdMQ-1; Mon,
 27 Jul 2026 09:07:52 -0400
X-MC-Unique: Ar4alRKcPJii6Czk98UdMQ-1
X-Mimecast-MFC-AGG-ID: Ar4alRKcPJii6Czk98UdMQ_1785157671
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CA786180136C;
	Mon, 27 Jul 2026 13:07:50 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.33.159])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CF63519560A3;
	Mon, 27 Jul 2026 13:07:46 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Christoph Hellwig <hch@infradead.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] netfs: Miscellaneous fixes
Date: Mon, 27 Jul 2026 14:07:11 +0100
Message-ID: <20260727130716.1099906-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi Christian,

Here are some miscellaneous fixes for netfslib.

 (1) Clear PG_private_2 on copy-to-cache append failure.

 (2) Fix handling of rolling buffer allocation failure in single-object
     writeback.  This is probably unnecessary with (4), but if we're only
     writing to the cache, we can skip the write.

 (3) Fix cleanup of readeahead folios if iterator preparation fails.

 (4) Fix folio_queue allocation failure in writeback by adding a mempool.
     This also improves request and subrequest allocation.

The patches can also be found here:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=netfs-fixes

Thanks,
David

David Howells (1):
  netfs: Fix folio_queue ENOMEM in writeback by adding a mempool

Yichong Chen (3):
  netfs: clear PG_private_2 on copy-to-cache append failure
  netfs: handle single writeback rolling buffer allocation failure
  netfs: release readahead folios on iterator preparation failure

 fs/netfs/buffered_read.c       | 10 ++++++----
 fs/netfs/internal.h            |  1 +
 fs/netfs/main.c                |  7 +++++++
 fs/netfs/objects.c             | 31 +++++++++++++++++++------------
 fs/netfs/read_pgpriv2.c        |  3 ++-
 fs/netfs/rolling_buffer.c      | 21 ++++++++++++---------
 fs/netfs/write_issue.c         | 15 ++++++++++-----
 include/linux/netfs.h          |  1 +
 include/linux/rolling_buffer.h |  6 +++---
 9 files changed, 61 insertions(+), 34 deletions(-)

