Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324D937F8BC
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 11:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782302295; cv=none; b=DrrDF4t1h99osD9iotI2P5CfZfTbQNm3hRAAj5fqYTIQRau3Vd8znm5fHOC/l+WEFprUYvqRNZXa0easOO6Ay0g9EN/lY8cHTgFKUS1X70hyEkfnxGwGDVQ6E38nNuJhM3Qrj5QXBDRbZoYAdZb7RPmB8LOR3Z+uHN7HTsA9Ais=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782302295; c=relaxed/simple;
	bh=RdvGg5oUDGJEEdfGJGQ/pnwBlwSc3oIQFuXQ0iNSvAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d87qmhXFMeZ4qA6s28YldC58dRT4y59h0HPEsYq1MvqiHPm04KekPjR9+nZ5i1JxpuLLFFNfSjzh59aG2k1Rv5X+2X/TFGmfna5OxJi6cUtNOjtus3g3KXWSnObNo557zaLqI+6OuRncKdrWBqN+RuHjGX+07s7yF4Jc+MxPZTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AxekMkBk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AxekMkBk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782302289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UCH9AytniZX5CSjSRd/+qJL1T4JneHVxw5zGHZC2I1o=;
	b=AxekMkBkO/b9ph4qKsWXiZrpSafrD8axVQ37KhUI5Tys0foMTU2g1X2PWbk2h0dU9wI8mW
	bfBl6L/iZ205v2dD0MGStcL/pwVQnQ/7LQcbToRIxIdHBP4TiFQpAL6ZbqEdvcTib3kqZa
	i0X5xincuhCMluziChiLVtvDNnUKYOU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-677-Kcz0Ba0yO42GHTSNRKa9aw-1; Wed,
 24 Jun 2026 07:58:03 -0400
X-MC-Unique: Kcz0Ba0yO42GHTSNRKa9aw-1
X-Mimecast-MFC-AGG-ID: Kcz0Ba0yO42GHTSNRKa9aw_1782302282
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 865421955E93;
	Wed, 24 Jun 2026 11:58:01 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.49.152])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BDDFD1956049;
	Wed, 24 Jun 2026 11:57:57 +0000 (UTC)
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
	NeilBrown <neil@brown.name>
Subject: [PATCH v2 03/14] cachefiles: Fix file burial to take lock when unsetting S_KERNEL_FILE
Date: Wed, 24 Jun 2026 12:57:24 +0100
Message-ID: <20260624115737.2964520-4-dhowells@redhat.com>
In-Reply-To: <20260624115737.2964520-1-dhowells@redhat.com>
References: <20260624115737.2964520-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Fix cachefiles_bury_object() to lock the inode of the file being buried
whilst it unsets the S_KERNEL_FILE flag.

Fixes: 07a90e97400c ("cachefiles: Implement culling daemon commands")
Closes: https://sashiko.dev/#/patchset/20260616100821.2062304-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: NeilBrown <neil@brown.name>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/cachefiles/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index a464c4646c04..d4309dfb55df 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -375,7 +375,7 @@ int cachefiles_bury_object(struct cachefiles_cache *cache,
 					    "Rename failed with error %d", ret);
 	}
 
-	__cachefiles_unmark_inode_in_use(object, d_inode(rep));
+	cachefiles_do_unmark_inode_in_use(object, d_inode(rep));
 	end_renaming(&rd);
 	_leave(" = 0");
 	return 0;

