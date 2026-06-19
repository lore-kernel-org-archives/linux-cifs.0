Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083023932D1
	for <linux-cifs@vger.kernel.org>; Fri, 19 Jun 2026 14:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781878068; cv=none; b=JDhc6WME2XuSQ1sqA7CcUqsJ7o1r8E3XPpC2ZW/+vJdCfJ/qsZaUMNcdeIvI+zGXMeDdRFfx1oGlOQg39B/4BKKsMK/1ft7YhitDnyFh0PalCBpu4YXaUoYxHy5H4sWDbT7eYFGdGM0BbAt/Irb1MJK1GL8gj8H3v92B3QjKb88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781878068; c=relaxed/simple;
	bh=ZTP7q8W8ggimp4fkS8Bp4m2KMaDOWPpUQdn/EzPXwAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZyAOvnfE1EVzHiMAnN1UJDbsVrnx2lnxnb/taXGr7MlMDL3ipiVpbeynYvSYz/oHdbtrMB3Fb+rctkpoy5576f4AETXWUJMgOkmIumff5o9BNpsQSOAPt+E4d5P0hNya/ZG3cgRBNqSxgJsr5WsRpPoXFHngjQJX2aj47oBI8pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aZ1+neEq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aZ1+neEq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781878066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lg3QobSmdRBdCansQlMNMTSeQxNIKRIjET+hDWCLJE0=;
	b=aZ1+neEqtJP/00q2iP4+HjprjmxGW1muvEn7+vDWzCjXsrljLwvIQsHNdYFBTBMJgO06Yw
	gTLeyPezVNaZe5lMinPgEqSOjR04hsxm+I+cKIuHPzhnaJQrpK0Y67WkBIIgXtMWkFHqjN
	Pvnt2cI7H0kj3HBaVxrksyuYn0JiXZc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-441-PdfIEjenOMatLbU16py5iQ-1; Fri,
 19 Jun 2026 10:07:42 -0400
X-MC-Unique: PdfIEjenOMatLbU16py5iQ-1
X-Mimecast-MFC-AGG-ID: PdfIEjenOMatLbU16py5iQ_1781878061
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 040401956062;
	Fri, 19 Jun 2026 14:07:41 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.50.44])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 27DCD18005B7;
	Fri, 19 Jun 2026 14:07:37 +0000 (UTC)
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
Subject: [PATCH 09/11] netfs: Fix kdoc warning
Date: Fri, 19 Jun 2026 15:06:13 +0100
Message-ID: <20260619140646.2633762-10-dhowells@redhat.com>
In-Reply-To: <20260619140646.2633762-1-dhowells@redhat.com>
References: <20260619140646.2633762-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Fix a kdoc warning due to a misnamed parameter in the description.

Reported-by: Matthew Wilcox <willy@infradead.org>
cc: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 include/linux/netfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 243c0f737938..bdc270e84b30 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -753,7 +753,7 @@ static inline void netfs_inode_init(struct netfs_inode *ctx,
 
 /**
  * netfs_resize_file - Note that a file got resized
- * @ctx: The netfs inode being resized
+ * @ictx: The netfs inode being resized
  * @new_i_size: The new file size
  * @changed_on_server: The change was applied to the server
  *

