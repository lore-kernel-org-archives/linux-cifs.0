Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9E31DAC79
	for <linux-cifs@vger.kernel.org>; Wed, 14 Aug 2024 20:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723668051; cv=none; b=uytkpDOZiyeyrZYkYmmITAmdMDNX8EDMCG1424Qvuruj1Bir8fuExoEHwtc/XALFWG2Xz2Q6FT1zKHdUGtVtJkOz1RKTiEvQZnlERjtLmvmicVizmuD4uhiOI7KzSh7hCA+IbmCyJXno8oZ56PeeXTRshIPqC/ViIPyYkSAmo2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723668051; c=relaxed/simple;
	bh=cHxke0ZCJxAJBo0yQTk/wSBW5w+L6DpeDHn+tU3fjpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oiwYbR8zp2jSw00crG5X3wwoTdNyuScNwX+kpsBMomQ7q5jW/DDYhnG8O7GBuSumAf7uEvJLvR5P+kxznyHu6q+/uc+aCkbHNAd365d9sMlo375/5J8sQzMO6HqCtSRHwEz1IXT3rkxEHKh0Mw2F8/Uud91M6DRszeYewQdIdkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ufd8ecz8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ufd8ecz8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723668047;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w97nPU0tAGeP5M9LqJOBxzdkU1NC+KgCeHw19Arp5sY=;
	b=Ufd8ecz8F2/Q2FNmTAOCyu7IiLGoGxMDELCsrS+uzGtnh9eVb22yJGO7TZTTj8eir31Hw/
	KTZNmSa44tdsAmqzchOiKP08v0zK5YWYFHE1clQp7frlhEmXsSJKrmnPyjKuB1Q83lKzgS
	dpOuGiS3Xit/Jsn2em2zIW+4K8zafpg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-41-BVHWuZvpPrWVhSRWafLQKA-1; Wed,
 14 Aug 2024 16:40:44 -0400
X-MC-Unique: BVHWuZvpPrWVhSRWafLQKA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EBA0F1954206;
	Wed, 14 Aug 2024 20:40:40 +0000 (UTC)
Received: from warthog.procyon.org.uk.com (unknown [10.42.28.30])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E563719560A3;
	Wed, 14 Aug 2024 20:40:34 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>,
	Steve French <smfrench@gmail.com>,
	Matthew Wilcox <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Marc Dionne <marc.dionne@auristor.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-erofs@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v2 13/25] iov_iter: Provide copy_folio_from_iter()
Date: Wed, 14 Aug 2024 21:38:33 +0100
Message-ID: <20240814203850.2240469-14-dhowells@redhat.com>
In-Reply-To: <20240814203850.2240469-1-dhowells@redhat.com>
References: <20240814203850.2240469-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Provide a copy_folio_from_iter() wrapper.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Alexander Viro <viro@zeniv.linux.org.uk>
cc: Christian Brauner <christian@brauner.io>
cc: Matthew Wilcox <willy@infradead.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
cc: linux-mm@kvack.org
---
 include/linux/uio.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 845d110acadc..853f9de5aa05 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -189,6 +189,12 @@ static inline size_t copy_folio_to_iter(struct folio *folio, size_t offset,
 	return copy_page_to_iter(&folio->page, offset, bytes, i);
 }
 
+static inline size_t copy_folio_from_iter(struct folio *folio, size_t offset,
+					  size_t bytes, struct iov_iter *i)
+{
+	return copy_page_from_iter(&folio->page, offset, bytes, i);
+}
+
 static inline size_t copy_folio_from_iter_atomic(struct folio *folio,
 		size_t offset, size_t bytes, struct iov_iter *i)
 {

