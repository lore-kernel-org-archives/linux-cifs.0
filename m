Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBEB306746
	for <linux-cifs@vger.kernel.org>; Tue, 12 May 2026 12:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778589340; cv=none; b=fCWl72xdD1aEoJ0l8kByHHYt+V8ktAkO866H4nI/ovn0RqBQcmLdynNF1drHaQGJaRfSghGgiAn8tZjxqGQ3dQtB3/JiGnRyhMMA4tLJQ6WW0hGg5ox8mJEBzVpdRibw15EI4mxHWppEvjyYibLU2/5ug2/LPeoiocbdBytYZVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778589340; c=relaxed/simple;
	bh=Jp3QDQo/A0dPoJRZkDfmNDwfgZeVfsEuuiJwVac4Il8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHVJ3iicDPLBOMKRTES3gM4e0CYHVoVrwMHPx0f7NvzmCA7saoLEz1ygA6vnd7/gdJA2nIp8gS2+gwwyLw6jBwi3N+LUFT2Z2UVw7rX4PrbyjHpaxi8z5v/uwdM45VoXErV6pnCJpo8eY/CnTOzw7KsuafjzNOV5T+gIw2c+bjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E8Wfk140; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E8Wfk140"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778589329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2L5STRbVcsUYFv2ZB+WgCbwYuC/Gpxza2z9Fbl/lWXE=;
	b=E8Wfk140QSq2x3BUdzOV8PQOGuYslGH7Buqrpq0TB1Ybu/6KeEndbMZc3u0QpIqLWzZimh
	mTeyCHUYZ0gFKkxelNdiMnsY3EvOv5iDSzbm0mc0fBdeRjK7yUycL5EO3P94Mze8/jNzPV
	vwB43+BinwFQ1GvWOl3uo/5H7TXW1AM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-668-_yT0-Y8WPEeMFlJIxkOalA-1; Tue,
 12 May 2026 08:35:25 -0400
X-MC-Unique: _yT0-Y8WPEeMFlJIxkOalA-1
X-Mimecast-MFC-AGG-ID: _yT0-Y8WPEeMFlJIxkOalA_1778589323
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 357D61956055;
	Tue, 12 May 2026 12:35:23 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.83])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 437F3180034E;
	Tue, 12 May 2026 12:35:20 +0000 (UTC)
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
Subject: [PATCH v6 15/24] netfs: Fix read-gaps to remove netfs_folio from filled folio
Date: Tue, 12 May 2026 13:33:52 +0100
Message-ID: <20260512123404.719402-16-dhowells@redhat.com>
In-Reply-To: <20260512123404.719402-1-dhowells@redhat.com>
References: <20260512123404.719402-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Fix netfs_read_gaps() to remove the netfs_folio record from the folio
record before marking the folio uptodate if it successfully fills the gaps
around the dirty data in a streaming write folio (dirty, but not uptodate).

Found with:

    fsx -q -N 1000000 -p 10000 -o 128000 -l 600000 \
        /xfstest.test/junk --replay-ops=junk.fsxops

using the following as junk.fsxops:

    truncate 0x0 0x138b1 0x8b15d *
    write 0x507ee 0x10df7 0x927c0
    write 0x19993 0x10e04 0x927c0 *
    mapwrite 0x66214 0x1a253 0x927c0
    copy_range 0xb704 0x89b9 0x24429 0x79380
    write 0x2402b 0x144a2 0x90660 *
    mapwrite 0x204d5 0x140a0 0x927c0 *
    copy_range 0x1f72c 0x137d0 0x7a906 0x927c0 *
    read 0 0x9157c 0x9157c

on cifs with the default cache option.

It shows folio 0x24 misbehaving if the FMODE_READ check is commented out in
netfs_perform_write():

                if (//(file->f_mode & FMODE_READ) ||
                    netfs_is_cache_enabled(ctx)) {

and no fscache.  This was initially found with the generic/522 xfstest.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
---
 fs/netfs/buffered_read.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index ebd84a6cc3f0..51f844bfbdff 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -395,6 +395,7 @@ static int netfs_read_gaps(struct file *file, struct folio *folio)
 {
 	struct netfs_io_request *rreq;
 	struct address_space *mapping = folio->mapping;
+	struct netfs_group *group = netfs_folio_group(folio);
 	struct netfs_folio *finfo = netfs_folio_info(folio);
 	struct netfs_inode *ctx = netfs_inode(mapping->host);
 	struct folio *sink = NULL;
@@ -461,6 +462,12 @@ static int netfs_read_gaps(struct file *file, struct folio *folio)
 
 	ret = netfs_wait_for_read(rreq);
 	if (ret >= 0) {
+		if (group)
+			folio_change_private(folio, group);
+		else
+			folio_detach_private(folio);
+		kfree(finfo);
+		trace_netfs_folio(folio, netfs_folio_trace_filled_gaps);
 		flush_dcache_folio(folio);
 		folio_mark_uptodate(folio);
 	}
@@ -496,10 +503,8 @@ int netfs_read_folio(struct file *file, struct folio *folio)
 	struct netfs_inode *ctx = netfs_inode(mapping->host);
 	int ret;
 
-	if (folio_test_dirty(folio)) {
-		trace_netfs_folio(folio, netfs_folio_trace_read_gaps);
+	if (folio_test_dirty(folio))
 		return netfs_read_gaps(file, folio);
-	}
 
 	_enter("%lx", folio->index);
 

