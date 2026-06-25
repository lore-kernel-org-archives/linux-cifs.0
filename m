Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44BB360EFB
	for <linux-cifs@vger.kernel.org>; Thu, 25 Jun 2026 14:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782396497; cv=none; b=jNomiI4C55fwmrXSLCQMij1gymw858eayhUhDMtfp45UBIewVqb2M1SHvKrIr9UR8SS/pXzUCxfXq7DDsWJBvHQn6zmiHLkbW1HWisEgQ0d9fyZpLreA490e8S53h3/GMv9ux6MFIy4MJUd51Z6L14ox2KXk05FNcnYgEKn+cZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782396497; c=relaxed/simple;
	bh=elZ6s3PGePQtvKkuWc/132OUzgTYXmfpO45C022yIGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SkUmeLTvWwlEwo3/kPF8gAedPWLEcE/FOn5YMbYWGxNGMfL+n8penX3YJ26z3WGYN1mcoaiJiYa7mcLHYicYbxhAP+r9AP3WKwOFV998+MKhrgv+h5rPSGf7/Gqh8JDEje+BxcUsYbBMM4UzlpwAKFc2gJH0gepwXuFNmt8sgRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bpeoFgng; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bpeoFgng"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782396496;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VdumfDDf1PJp00pZdD4aygrxcSHtSzAPned20bGl9Fs=;
	b=bpeoFgngOBfsNLlCZaA2DXVpkq3z9DoMJS6XTdjy/Wr81LM5ko+T8BWGTfAXbhhHuSUYTW
	TtMzcscM/IdEnVQ6tmEGSDAf54ilZuFErXhE7XKcBaDtl04M+LlosOwPNhzzzixOqkZBW6
	TuZ8+UiNmH3rGkCowtt3ewzhby4I+Ww=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-424-oeLPkOq1M4etwJ0IzOsNtw-1; Thu,
 25 Jun 2026 10:08:10 -0400
X-MC-Unique: oeLPkOq1M4etwJ0IzOsNtw-1
X-Mimecast-MFC-AGG-ID: oeLPkOq1M4etwJ0IzOsNtw_1782396487
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 49DAB186BF1D;
	Thu, 25 Jun 2026 14:08:07 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.49.152])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3605A1800370;
	Thu, 25 Jun 2026 14:08:03 +0000 (UTC)
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
Subject: [PATCH v3 14/15] netfs: Fix folio state after ENOMEM whilst under writeback iteration
Date: Thu, 25 Jun 2026 15:06:32 +0100
Message-ID: <20260625140640.3116900-15-dhowells@redhat.com>
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

Fix the state of the current folio when ENOMEM occurs during writeback
iteration.  The folio needs to be redirtied and unlocked before the
terminal writeback_iter() is invoked.

Fixes: 06fa229ceb36 ("netfs: Abstract out a rolling folio buffer implementation")
Link: https://sashiko.dev/#/patchset/20260619140646.2633762-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/write_issue.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index 3682896c3fdf..f2761c99795a 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -582,6 +582,10 @@ int netfs_writepages(struct address_space *mapping,
 		}
 
 		error = netfs_write_folio(wreq, wbc, folio);
+		if (error == -ENOMEM) {
+			folio_redirty_for_writepage(wbc, folio);
+			folio_unlock(folio);
+		}
 	} while ((folio = writeback_iter(mapping, wbc, folio, &error)));
 
 	netfs_end_issue_write(wreq);

