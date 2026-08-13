Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A873923909F
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 13:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786628748; cv=none; b=XA3PmAOLNHFhoPG8JKmnqKFS9fQD+gisXEgD4x10N7fog116blZ3RhSFUzic4a5N0cDtbIyfiE5flMv0MAi9+bnZyBCQC52AuON2F4UPUoJPbaKOUqQMElacld3/piYO9t9vMErD8fkPX9VV5QpOTqDD4yFa4LdazeCqHDVWCBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786628748; c=relaxed/simple;
	bh=0wHkEqHRypv5tkP9LlfNdRWNsV3WKRx0iw3qb2GlJpw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tnpHRS3/qnGVP5cZ3pjz8K75vTCAkUo9ZSP0452B+k1l7vlGyQn8mt1IPPvuSxRM59+PtuvF7ZdzUqDoeLzZfjY1/HgSDAAn0wxXh+xGuVIJClv18TfnVxLkq5KtxQhLG5m3wHygxleao36Ly0Y5Uutp9ORk5+BlS+E8+EAbOCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HYJiD1sL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HYJiD1sL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786628745;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qxcNqxDJHo6P7G7Xe79Ps0EZY26r/2eNZf8D3pRE4FQ=;
	b=HYJiD1sL7QoGEQPxwJavgkPf8mkqOaicUWx9xIz392nR1xSDb4FV0fRIGiYShYFLLmnHce
	Bi9tSkLp//cu9Pcfmq6lLDkPgWAjB2OQGvZ82/QkjlFIrbymRaNB+zMVtiYYwXekToNMuc
	k0QW3VL0bUJtOtRtEuoQBBp1ANS0zKU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-610-mswweZnAMKSRFLaag0XENw-1; Thu,
 13 Aug 2026 09:45:41 -0400
X-MC-Unique: mswweZnAMKSRFLaag0XENw-1
X-Mimecast-MFC-AGG-ID: mswweZnAMKSRFLaag0XENw_1786628740
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8B76818002C8;
	Thu, 13 Aug 2026 13:45:39 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.32.44])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 90DB31977033;
	Thu, 13 Aug 2026 13:45:36 +0000 (UTC)
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
Subject: [PATCH 0/2] netfs: Miscellaneous fixes
Date: Thu, 13 Aug 2026 14:45:30 +0100
Message-ID: <20260813134533.1174132-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Hi Christian,

Here are a couple of miscellaneous fixes for netfslib.

 (1) Fix an uninitialised return value from netfs_unbuffered_write().

 (2) Fix read progress reporting to avoid 64-bit tearing on a 32-bit
     machine.  This has been modified from the previous submission as part
     of a different series to take account of a sashiko reported issue[1].

The patches can also be found here:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=netfs-fixes

Thanks,
David

[1] https://sashiko.dev/#/patchset/20260810144746.574036-1-dhowells%40redhat.com

David Howells (1):
  netfs: Fix read progress reporting

Karl Mehltretter (1):
  netfs: Fix uninitialized return value in netfs_unbuffered_write()

 fs/netfs/buffered_read.c     |  4 +++
 fs/netfs/direct_write.c      |  2 +-
 fs/netfs/internal.h          |  1 +
 fs/netfs/objects.c           | 32 ++++++++++++--------
 fs/netfs/read_collect.c      | 58 +++++++++++++++++++++++++++---------
 fs/netfs/read_single.c       |  2 ++
 include/linux/netfs.h        |  2 +-
 include/trace/events/netfs.h | 21 +++++++++++++
 8 files changed, 94 insertions(+), 28 deletions(-)

