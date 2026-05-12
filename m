Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB20337DAAF
	for <linux-cifs@vger.kernel.org>; Tue, 12 May 2026 12:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778589327; cv=none; b=Pe7TpRMDZK6OOFNGeRvdoC03S3wD0v0rudsmYCNX3y7Rhd2H1jmtt+Y3Mq5DuugYCX6Lu0sYq4iBUukrMj9l7kfoX5yjfeJTbgtVZ4vyjhP4wASNojuulorES5b437AwWWCpqWaD1/9LUkzRtmkOeYvn1XmfBfwxvu88QUBqyTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778589327; c=relaxed/simple;
	bh=KeUasABkgEn3NQcjVtDzHTfFRZyrIiFqog4yscjBZRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nUGdhYiquqBpzvb7ctzutfp8MmeThZ75WQC4LfbnG4FqB/SdKY7cXsxLTNHrBvpbEC4PHYAIVK+H13vpjHO3O5NSi2wesTjDiZOw9mU/keZljKH/5YXBPG3rZjlCOv/7Qu4x9A2mhppsQcGWR5FOX0kWm9onXCnHhc3D5leLSvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gBIbh7DH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gBIbh7DH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778589314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0gmHNNP6/GH74ADWZurqVXHN7qp3bddGwDZsoBT42iI=;
	b=gBIbh7DHDvyClJT9/H7rcrhuAux/9IeWO6YjdQVs5u8O1xTAFNcsCb6ukr8vEHgKs/DNIS
	R1nYXY0F7BeyNA9gnTqq3+j1NFu0hOvXsvJFEIfPkStSRtasy4Wm3qvm+r4hXTe1tzosam
	nJQbAxJmqy0zo9IyhHYveKOpuz5JstU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-478-q_3PvK5QP3u9LJ3SzEBl9g-1; Tue,
 12 May 2026 08:35:11 -0400
X-MC-Unique: q_3PvK5QP3u9LJ3SzEBl9g-1
X-Mimecast-MFC-AGG-ID: q_3PvK5QP3u9LJ3SzEBl9g_1778589309
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 47C2F1800610;
	Tue, 12 May 2026 12:35:09 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.83])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 35AE530001BB;
	Tue, 12 May 2026 12:35:05 +0000 (UTC)
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
Subject: [PATCH v6 12/24] netfs: Defer the emission of trace_netfs_folio()
Date: Tue, 12 May 2026 13:33:49 +0100
Message-ID: <20260512123404.719402-13-dhowells@redhat.com>
In-Reply-To: <20260512123404.719402-1-dhowells@redhat.com>
References: <20260512123404.719402-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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
index b6ecd059dc4f..278aeb074e75 100644
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

