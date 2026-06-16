Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0864E427A0D
	for <linux-cifs@vger.kernel.org>; Tue, 16 Jun 2026 10:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781604590; cv=none; b=mM3Q4aitwKBix5xYKlu7k0rY9Mwmo7NaD2d7gVtytDVG8fWLq5CXmEp2xRXSs3efhXCURN4+CzezVjNlkoS3COKhzd2T2uCfHZErF5VoWLvEOyfnLhEvcZ66+MmF/00kGL8fvbXMsE3jC3Xg3OohLTrlbZ0M4ST+8lfojZwvgbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781604590; c=relaxed/simple;
	bh=+2yExf3nFRZfncR6dxtXjw3ITVBrwKiRqNCi5abTFMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8i1IsrLWg7DV8T9C+iB5M/nuipGwnUUipsui/IZ/Mjeifq70ZfuOO6MbaQAQ29XrOk482eghvsztdtL8iBbeXwKPekGzVMAC4FHrkhyNcNDhqGPGyEj3CwRkoEjBdusLNy3FlRafG6BX5c2J5J9mdSyrEKSbV45vkmDsrG3tqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M1yDHPN8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M1yDHPN8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781604588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p9DNEnvUuEWndqSbROk8DKtJ535ilbu1JwdDRpUce88=;
	b=M1yDHPN8OKeOBy8jXJp38TsXjfa6B9JdXh6hXdcdsnC3iHqL3MOdrG5OJhlzzzaZ3w7YsU
	j4jl8hVVsxL9tvC5Yn825B9D70HpzmqRfhoqQoZzcj/rAMyL0RBS0d0LuUur4FXPj93ZJ+
	R2diOKn8s50Mc0WDu4DfVvI7ot1bEWg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-691-tzbC4J7tO7aO9tOQbD3bZA-1; Tue,
 16 Jun 2026 06:09:44 -0400
X-MC-Unique: tzbC4J7tO7aO9tOQbD3bZA-1
X-Mimecast-MFC-AGG-ID: tzbC4J7tO7aO9tOQbD3bZA_1781604582
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 095661954B3A;
	Tue, 16 Jun 2026 10:09:42 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.50.44])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8622419560B2;
	Tue, 16 Jun 2026 10:09:35 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Jens Axboe <axboe@kernel.dk>,
	Leon Romanovsky <leon@kernel.org>,
	Steve French <sfrench@samba.org>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 08/30] netfs: Fix kdoc warning
Date: Tue, 16 Jun 2026 11:07:57 +0100
Message-ID: <20260616100821.2062304-9-dhowells@redhat.com>
In-Reply-To: <20260616100821.2062304-1-dhowells@redhat.com>
References: <20260616100821.2062304-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

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
index 06e6cceffaeb..1bc120d61c5b 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -760,7 +760,7 @@ static inline void netfs_inode_init(struct netfs_inode *ctx,
 
 /**
  * netfs_resize_file - Note that a file got resized
- * @ctx: The netfs inode being resized
+ * @ictx: The netfs inode being resized
  * @new_i_size: The new file size
  * @changed_on_server: The change was applied to the server
  *

