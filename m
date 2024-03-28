Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B21132802
	for <linux-cifs@vger.kernel.org>; Thu, 28 Mar 2024 17:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711645202; cv=none; b=aixCPHK2C0/bwu4mlvOnMQWLTeAYieAaPT3M2sQU3fpiFbIoOqwAV8oAjx1CaPaGwlsyFIsoNcNbTP1XN5ZrAqXgj7plkJG914imwvWxiybNxrF+3HP3b707rnn4j017Lih+qqyq9zTgeGp6OqZbkbHO1R7qcsoA+PiGLByk/tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711645202; c=relaxed/simple;
	bh=lViBTFxW094B27mO0CNb4JcXxIC1M1VJ7XSGfavhzeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bnnNgDi90ekkJvBi2FzYr0c/lNdZQHs6as+hUwmU3mQ4fC+385BA9556gveeC5F8C8sDC3a172haPmIYzzKziI0dyaITOK5DCf7jQ2CJ9/ftR/Z7fR/LoHqVmzJ/HNeyPh9+heVVGRHXnh3WnN8RPsV2B2a6vmvQdQIyLMvhDRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BsjeLdQ/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BsjeLdQ/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711645199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=koZtPsH7hhKYp0dfXQczx6sKrVXjOZT1GIZj0qwvbyc=;
	b=BsjeLdQ/P3A0lBeDoU+x35AjMBHMQk/JcRaOSkjSQm1rOu1hlDdtscq1SrTCn5WXk53wuq
	48Q+V6BZhXBRQEUouTi11oTRqijH3hcbC2P4kSDSlfGDHgad55dKW+aHfpv1TSeSHlKcfT
	opIm6gyALbVOqfJKoP0v35UJArpD7ig=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-270-x0mgGlrpM3uifVCi1HPq0w-1; Thu,
 28 Mar 2024 12:59:55 -0400
X-MC-Unique: x0mgGlrpM3uifVCi1HPq0w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F0E5A28EC106;
	Thu, 28 Mar 2024 16:59:54 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.146])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F01722166B31;
	Thu, 28 Mar 2024 16:59:52 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <smfrench@gmail.com>
Cc: David Howells <dhowells@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Christian Brauner <christian@brauner.io>,
	netfs@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Steve French <sfrench@samba.org>,
	Shyam Prasad N <nspmangalore@gmail.com>,
	Rohith Surabattula <rohiths.msft@gmail.com>
Subject: [PATCH v6 07/15] cifs: Set zero_point in the copy_file_range() and remap_file_range()
Date: Thu, 28 Mar 2024 16:57:58 +0000
Message-ID: <20240328165845.2782259-8-dhowells@redhat.com>
In-Reply-To: <20240328165845.2782259-1-dhowells@redhat.com>
References: <20240328165845.2782259-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Set zero_point in the copy_file_range() and remap_file_range()
implementations so that we don't skip reading data modified on a
server-side copy.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Shyam Prasad N <nspmangalore@gmail.com>
cc: Rohith Surabattula <rohiths.msft@gmail.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
cc: linux-mm@kvack.org
---
 fs/smb/client/cifsfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index e01ba9f8706a..2dd29663dab1 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1283,6 +1283,8 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 	rc = cifs_flush_folio(target_inode, destend, &fstart, &fend, false);
 	if (rc)
 		goto unlock;
+	if (fend > target_cifsi->netfs.zero_point)
+		target_cifsi->netfs.zero_point = fend + 1;
 
 	/* Discard all the folios that overlap the destination region. */
 	cifs_dbg(FYI, "about to discard pages %llx-%llx\n", fstart, fend);
@@ -1301,6 +1303,8 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
 			fscache_resize_cookie(cifs_inode_cookie(target_inode),
 					      new_size);
 		}
+		if (rc == 0 && new_size > target_cifsi->netfs.zero_point)
+			target_cifsi->netfs.zero_point = new_size;
 	}
 
 	/* force revalidate of size and timestamps of target file now
@@ -1392,6 +1396,8 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
 	rc = cifs_flush_folio(target_inode, destend, &fstart, &fend, false);
 	if (rc)
 		goto unlock;
+	if (fend > target_cifsi->netfs.zero_point)
+		target_cifsi->netfs.zero_point = fend + 1;
 
 	/* Discard all the folios that overlap the destination region. */
 	truncate_inode_pages_range(&target_inode->i_data, fstart, fend);

