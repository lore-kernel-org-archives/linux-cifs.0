Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482992C08CF;
	Wed, 30 Sep 2026 00:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790728764; cv=none; b=DCIgxcmETcpD5KhZwUUcM7wxsmK1oyp26szFIRIi5U819IO3I36XlMcs0GQomqko55zGv/DZmVKG5ZqXm+igDv+A9sC/LW/74lQ9Dcd3x8Hhcp4anex6ckZOKTGp3D0uKn//ZQ0pqYdLXAcB6g0BC4Y6D0/yXZu2BDwnEHp9Hik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790728764; c=relaxed/simple;
	bh=KGfIvBlCbx/6hTHchRqWbEpxqs+q/TBXo5o9Dai4OFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtooyrldUegKjNfVDXVHcqSMifcJj/Ho5TwFigTH2Z1BZYWuBO7CBJ0pVTRWt8DqTzsogmh0JRWz1yPHrFF8UjLqA62WT5XBi0wgHdGp0JUa+F6pqJ3EPyy36HHHWZR6GIqi5l3V5ySn1kypQ0fxx/Bz2UeR1L6iehveGL6gRwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=3PGJFtwI; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="3PGJFtwI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=BJ17WV1GnN5OT1URP0DH96YYJBOm5GXPtRjLgtxPpZw=; b=3PGJFtwIRq70PqjY/3X/LlkEie
	1zVcbmt6o6WSgxOUAmFuVMSIAjnJZzeiLt65TNrhcqVyMczEBWg1eCLYMcw7ueOnPgWkslp+7M4KP
	xwKs+aQWHPVnfIqjHToJT6EcHjQiniaYuflnJbbj9ohXXSaxiQZIZgVq/42UkT4Hdf6PbjSjE52MP
	VtGiiIC/qi8ZYht0ob0ZpB9M3RGWg4xomLrE0nBKRXpqKkQO6iiMdnrHFI+X4q9EFDNgh45HCC1gI
	LThVkpU7EWBbjwe9LT3sfDflrGz7SZw0p2Tor97zmw/vJMloMwa2R09z3A8r8C8wCwGWU3OaYI+TK
	D7B5T2zQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xBiLp-00000002aEH-2dQq;
	Tue, 29 Sep 2026 21:39:13 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev
Cc: Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 13/15] netfs: zero the tail of a short DIO/unbuffered read
Date: Tue, 29 Sep 2026 21:39:06 -0300
Message-ID: <20260930003908.1703770-14-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930003908.1703770-1-pc@manguebit.org>
References: <20260930003908.1703770-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The buffered read collector zero-fills the tail of a short read that
stops below the inode's i_size (netfs_clear_unread()), so a read that
races an extending write still returns the expected number of bytes.
The non-buffered collector path does no such thing: it just records
how much was transferred.

Add the same zero-fill for the non-buffered case, gated on
NETFS_SREQ_CLEAR_TAIL: a subreq's source sets that flag when a short
result from it is known to be safe to treat as a hole, as opposed to
NETFS_SREQ_HIT_EOF, which means the read genuinely ran off the end of
the file and should be reported short as-is. Only CLEAR_TAIL should
zero-fill here; a real EOF must stay a real short read.

No source currently sets CLEAR_TAIL on an unbuffered/DIO subrequest,
so this is inert on its own -- a following change teaches cifs to set
it in the one case that needs it.

Fixes: e2d46f2ec332 ("netfs: Change the read result collector to only use one work item")
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/netfs/read_collect.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index a94197ef0181..c5bfaf2c6f25 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -33,6 +33,22 @@ static void netfs_clear_unread(struct netfs_io_subrequest *subreq)
 		__set_bit(NETFS_SREQ_HIT_EOF, &subreq->flags);
 }
 
+static void netfs_clear_unread_dio(struct netfs_io_subrequest *subreq)
+{
+	uoff_t pos = subreq->start + subreq->transferred;
+	struct netfs_io_request *rreq = subreq->rreq;
+	size_t fill;
+
+	if (pos >= rreq->i_size)
+		return;
+
+	fill = min_t(uoff_t, rreq->i_size - pos,
+		     subreq->len - subreq->transferred);
+
+	netfs_reset_iter(subreq);
+	subreq->transferred += iov_iter_zero(fill, &subreq->io_iter);
+}
+
 /*
  * Cancel the copy-to-cache mark on a folio.
  */
@@ -311,6 +327,14 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 			    test_bit(NETFS_SREQ_HIT_EOF, &front->flags))
 				netfs_read_unlock_folios(rreq, &notes);
 		} else {
+			if (!(notes & HIT_PENDING) &&
+			    front->error == 0 &&
+			    transferred < front->len &&
+			    test_bit(NETFS_SREQ_CLEAR_TAIL, &front->flags)) {
+				netfs_clear_unread_dio(front);
+				transferred = front->transferred;
+				trace_netfs_sreq(front, netfs_sreq_trace_clear);
+			}
 			stream->collected_to = front->start + transferred;
 			rreq->collected_to = stream->collected_to;
 		}
-- 
2.55.0

