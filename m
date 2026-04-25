Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA80395240
	for <linux-cifs@vger.kernel.org>; Sat, 25 Apr 2026 12:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777121718; cv=none; b=BOfs12wWhjk0sdlP7MJnkH8QpeFKUQIeZs1oRUK6BlGm8ruP+MioNQYMSzZ1j7p06HmAeV2mz9wLP8aipjTUoFz5jG6f/s/UsX0ttBZq6RlvBf+fqE2Odh6kak1PqFtMzYiRuO1T7AX7LQEbzkBitW0cQSrkGlZ3g2o+TzF21zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777121718; c=relaxed/simple;
	bh=0RD9WK7Z8b1cfNWJfuywH/XVdQi+DID7QaHnobdiupA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXyrGQVNKkFrxOtSazNzVNbSRfhbZV2sKtwCID67nZlPyhYMGwAaoAqBPUFU0L2awAPmoBxexhYIvXvdZuTnJMaZLjcHXiT/mNMLW7q+D3J1iFAT3ZNVBYMohU1d+Ea0wtg4lrCS2/qfQ8B4Czx68zCgFqUf2gKdBwOW9C1P7sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jp0cLPhh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jp0cLPhh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777121716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hwkDzJJVkIB8QUWldBqXDsmI02iLpH9t4nRKDWmeUI0=;
	b=Jp0cLPhhTnp8jq379p6wV97IS2CXCs8CVtbJM5EDqu9w3i01nqhiasP7CjqNuu69dr8i5r
	FKhoLV+uJfplFR2bvCAWV4r/lFUTMx/7HnMgFu970hJK+Biqe4mNFL6o/T7cYaqFjCxtUs
	mLKDvpkMnZykmkQe7vb3RjSvaJIToq0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-632-5RXKACmKMJGgYMmdRiei9Q-1; Sat,
 25 Apr 2026 08:55:11 -0400
X-MC-Unique: 5RXKACmKMJGgYMmdRiei9Q-1
X-Mimecast-MFC-AGG-ID: 5RXKACmKMJGgYMmdRiei9Q_1777121710
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 17023195609F;
	Sat, 25 Apr 2026 12:55:09 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.17])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 23E7E19560AB;
	Sat, 25 Apr 2026 12:55:05 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v3 07/19] netfs: Fix zeropoint update where i_size > remote_i_size
Date: Sat, 25 Apr 2026 13:54:11 +0100
Message-ID: <20260425125426.3855807-8-dhowells@redhat.com>
In-Reply-To: <20260425125426.3855807-1-dhowells@redhat.com>
References: <20260425125426.3855807-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Fix the update of the zero point[*] by netfs_release_folio() when there is
uncommitted data in the pagecache beyond the folio being released but the
on-server EOF is in this folio (ie. i_size > remote_i_size).  The update
needs to limit zero_point to remote_i_size, not i_size as i_size is a local
phenomenon reflecting updates made locally to the pagecache, not stuff
written to the server.  remote_i_size tracks the server's i_size.

[*] The zero point is the file position from which we can assume that the
    server will just return zeros, so we can avoid generating reads.

Note that netfs_invalidate_folio() probably doesn't need fixing as
zero_point should be updated by setattr after truncation.

Found with:

    fsx -q -N 1000000 -p 10000 -o 128000 -l 600000 \
        /xfstest.test/junk --replay-ops=junk.fsxops

using the following as junk.fsxops:

    truncate 0x0 0x1bbae 0x82864
    write 0x3ef2e 0xf9c8 0x1bbae
    write 0x67e05 0xcb5a 0x4e8f6
    mapread 0x57781 0x85b6 0x7495f
    copy_range 0x5d3d 0x10329 0x54fac 0x7495f
    write 0x64710 0x1c2b 0x7495f
    mapread 0x64000 0x1000 0x7495f

on cifs with the default cache option.

It shows read-gaps on folio 0x64 failing with a short read (ie. it hits
EOF) if the FMODE_READ check is commented out in netfs_perform_write():

                if (//(file->f_mode & FMODE_READ) ||
                    netfs_is_cache_enabled(ctx)) {

and no fscache.  This was initially found with the generic/522 xfstest.

Fixes: cce6bfa6ca0e ("netfs: Fix trimming of streaming-write folios in netfs_inval_folio()")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/netfs/misc.c b/fs/netfs/misc.c
index d8e8a4b59768..e386cf31eb1e 100644
--- a/fs/netfs/misc.c
+++ b/fs/netfs/misc.c
@@ -302,7 +302,7 @@ bool netfs_release_folio(struct folio *folio, gfp_t gfp)
 	if (folio_test_dirty(folio))
 		return false;
 
-	end = umin(folio_next_pos(folio), i_size_read(&ctx->inode));
+	end = umin(folio_next_pos(folio), ctx->remote_i_size);
 	if (end > ctx->zero_point)
 		ctx->zero_point = end;
 

