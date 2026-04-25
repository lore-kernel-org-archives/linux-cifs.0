Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AAB36D9EE
	for <linux-cifs@vger.kernel.org>; Sat, 25 Apr 2026 12:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777121705; cv=none; b=cwVo4PIPGyJ82LhICb7XxtRxRwFtQneBs4idomkOxYb1FITCvEvDJp+bpw8d5YGRR0d0gJ0HRrPtdt9EjDv7RbcW+PMoWzunOWw6M4l9qCqAobYbqCs1xO7JjIQRz4Lasod685voi4zaVuP2VG2sTwzGSzsLVUGeDWbVsIZBd/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777121705; c=relaxed/simple;
	bh=iJP+dqhWiqGi1MbPHkt833HZLa0pKEjFDuPHSK/G9uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gks/Qx3eccFPa29rk8KIz1/kZUre+OySOUsAGsfdHZGs8Ih+/e3RE5eV1+NoNi3LWUEwuAL6903kOPg+yS/fkNTiGsMhmO0GXpLvBhCynCOv56+tw3EDaRuuXsbuYf6eGRlZf98pvc4pBEULo/AXTyJ0FEkyC0UimU/CqI0Ubn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YYGaOR/7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YYGaOR/7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777121702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sFPwIBabIrcPkQ/URaUD6QY+l0UbTbUVhLLrjRDCqFg=;
	b=YYGaOR/75NYZajPWh+Oqt1Z4QyAdJP/votRpkd3P9kJB9Q6AhbyYn3dcF6O8a2tS/8xIK1
	MuVm1DHqNxIphdra87r/rCw22SwXzTzvm2NfMrY2Mf1hTWylhTe5EAaAoNDCpoOYNuWxQR
	VdkVtx/oYpSEupM4tl/I8vNtzIoIAE0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-683-5PRO9NDeOx2vHYS6roDNgg-1; Sat,
 25 Apr 2026 08:54:56 -0400
X-MC-Unique: 5PRO9NDeOx2vHYS6roDNgg-1
X-Mimecast-MFC-AGG-ID: 5PRO9NDeOx2vHYS6roDNgg_1777121695
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C9B2019560B5;
	Sat, 25 Apr 2026 12:54:54 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.17])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C86A919560AB;
	Sat, 25 Apr 2026 12:54:51 +0000 (UTC)
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
Subject: [PATCH v3 04/19] netfs: Defer the emission of trace_netfs_folio()
Date: Sat, 25 Apr 2026 13:54:08 +0100
Message-ID: <20260425125426.3855807-5-dhowells@redhat.com>
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

Change netfs_perform_write() to keep the netfs_folio trace value in a
variable and emit it later to make it easier to choose the value displayed.
This is a prerequisite for a subsequent patch.

Closes: https://sashiko.dev/#/patchset/20260414082004.3756080-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_write.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/netfs/buffered_write.c b/fs/netfs/buffered_write.c
index 05ea5b0cc0e8..fab172252759 100644
--- a/fs/netfs/buffered_write.c
+++ b/fs/netfs/buffered_write.c
@@ -149,6 +149,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 	}
 
 	do {
+		enum netfs_folio_trace trace;
 		struct netfs_folio *finfo;
 		struct netfs_group *group;
 		unsigned long long fpos;
@@ -222,7 +223,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			if (unlikely(copied == 0))
 				goto copy_failed;
 			netfs_set_group(folio, netfs_group);
-			trace_netfs_folio(folio, netfs_folio_is_uptodate);
+			trace = netfs_folio_is_uptodate;
 			goto copied;
 		}
 
@@ -238,7 +239,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			folio_zero_segment(folio, offset + copied, flen);
 			__netfs_set_group(folio, netfs_group);
 			folio_mark_uptodate(folio);
-			trace_netfs_folio(folio, netfs_modify_and_clear);
+			trace = netfs_modify_and_clear;
 			goto copied;
 		}
 
@@ -256,7 +257,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			}
 			__netfs_set_group(folio, netfs_group);
 			folio_mark_uptodate(folio);
-			trace_netfs_folio(folio, netfs_whole_folio_modify);
+			trace = netfs_whole_folio_modify;
 			goto copied;
 		}
 
@@ -283,7 +284,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			if (unlikely(copied == 0))
 				goto copy_failed;
 			netfs_set_group(folio, netfs_group);
-			trace_netfs_folio(folio, netfs_just_prefetch);
+			trace = netfs_just_prefetch;
 			goto copied;
 		}
 
@@ -297,7 +298,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			if (offset == 0 && copied == flen) {
 				__netfs_set_group(folio, netfs_group);
 				folio_mark_uptodate(folio);
-				trace_netfs_folio(folio, netfs_streaming_filled_page);
+				trace = netfs_streaming_filled_page;
 				goto copied;
 			}
 
@@ -312,7 +313,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 			finfo->dirty_len = copied;
 			folio_attach_private(folio, (void *)((unsigned long)finfo |
 							     NETFS_FOLIO_INFO));
-			trace_netfs_folio(folio, netfs_streaming_write);
+			trace = netfs_streaming_write;
 			goto copied;
 		}
 
@@ -332,9 +333,9 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 					folio_detach_private(folio);
 				folio_mark_uptodate(folio);
 				kfree(finfo);
-				trace_netfs_folio(folio, netfs_streaming_cont_filled_page);
+				trace = netfs_streaming_cont_filled_page;
 			} else {
-				trace_netfs_folio(folio, netfs_streaming_write_cont);
+				trace = netfs_streaming_write_cont;
 			}
 			goto copied;
 		}
@@ -350,6 +351,7 @@ ssize_t netfs_perform_write(struct kiocb *iocb, struct iov_iter *iter,
 		continue;
 
 	copied:
+		trace_netfs_folio(folio, trace);
 		flush_dcache_folio(folio);
 
 		/* Update the inode size if we moved the EOF marker */

