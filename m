Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60BE35C1BD
	for <linux-cifs@vger.kernel.org>; Thu, 25 Jun 2026 14:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782396490; cv=none; b=ihrMUUuUyIT343PoJNimxTTxQfTReRQzva21+03ln1J/tiQkGT44CLFNfsXBVCrh7WXHRmmQ7iPU1C0v4MZkr4hvwEcjC7C4mNoov/phUE/g95YzmhVzf/JhGL4il3HQDw3F8PgrTDqSWiFoeaFcPFuS+SrCnPx3UQxUpGJTHaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782396490; c=relaxed/simple;
	bh=MGB3c3wFt17lI147Ed0CbMmjVft1iM6JKRUb9DkY6ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5tVhq0p4PDHAK7TA48XuZvbX6ls5VA5cUTdxeIhJn+aKaOEVG2N5Q5S7ENI5c0fFNa/iPbFGCZhfyojp4ZEz3Z3IF+baAPFyy0g4KkPHzITN1F5uOmYw7q47fCzutIVJCE3EDfxCnrBH9pUCZk9+xc+yLUkEPLk2N8zrxetlpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b9si/kEJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b9si/kEJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782396488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JBq1SQEXIMOdD32CxvjwyU4ltaEPnjtuHVwIhEDJfg=;
	b=b9si/kEJHU7YrCo+/wYQeNzNNQuVHkeMT8/AyJ42pPz49t7pMvIWrxrqGkuF4XinKtKOA6
	UnYgetWL/jxWowXzVOceUXibcky4ri5vNHyn30Euv2zvjCVELyLTS23yEEsWC0FL8Ke3VT
	kwA9W6GoGogCo4xnu0IUR0bcJILvOD8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-54-szyagK6PME2b0o9rNcXqbA-1; Thu,
 25 Jun 2026 10:08:04 -0400
X-MC-Unique: szyagK6PME2b0o9rNcXqbA-1
X-Mimecast-MFC-AGG-ID: szyagK6PME2b0o9rNcXqbA_1782396482
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB2C0195411C;
	Thu, 25 Jun 2026 14:08:02 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.49.152])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9E1131800370;
	Thu, 25 Jun 2026 14:07:59 +0000 (UTC)
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
	linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v3 13/15] netfs: Fix writeback error handling
Date: Thu, 25 Jun 2026 15:06:31 +0100
Message-ID: <20260625140640.3116900-14-dhowells@redhat.com>
In-Reply-To: <20260625140640.3116900-1-dhowells@redhat.com>
References: <20260625140640.3116900-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Fix the error handling in writeback_iter() loop.  If an error occurs,
writeback_iter() needs to be called again with *error set to the error so
that it can clean up iteration state.  Further, the current folio needs
unlocking and redirtying.

Fixes: 288ace2f57c9 ("netfs: New writeback implementation")
Link: https://sashiko.dev/#/patchset/20260619140646.2633762-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/write_issue.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index 3b363ce12f3f..3682896c3fdf 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -582,8 +582,6 @@ int netfs_writepages(struct address_space *mapping,
 		}
 
 		error = netfs_write_folio(wreq, wbc, folio);
-		if (error < 0)
-			break;
 	} while ((folio = writeback_iter(mapping, wbc, folio, &error)));
 
 	netfs_end_issue_write(wreq);
@@ -594,7 +592,14 @@ int netfs_writepages(struct address_space *mapping,
 	return error;
 
 couldnt_start:
-	netfs_kill_dirty_pages(mapping, wbc, folio);
+	if (error == -ENOMEM) {
+		folio_redirty_for_writepage(wbc, folio);
+		folio_unlock(folio);
+		folio = writeback_iter(mapping, wbc, folio, &error);
+		WARN_ON_ONCE(folio != NULL);
+	} else {
+		netfs_kill_dirty_pages(mapping, wbc, folio);
+	}
 out:
 	netfs_wb_end(ictx);
 	_leave(" = %d", error);

