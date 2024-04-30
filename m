Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA63143729
	for <linux-cifs@vger.kernel.org>; Tue, 30 Apr 2024 14:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714486226; cv=none; b=lVEhnm0OBgEtIszXW7abPxP7yrtFD7xD6fytyLXshpLO67MAqktN1QpWZJEuysOw1nCwHKzRRvWdF7mFxCaXu5ETQGmx7XcyPTIj/UvYL1oF5Z/PjmSlQCSqN0OXq1eKgWG+Sd9the5Ce5zK3Gb/t1H4SDbN19NoWjukQ8uf7V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714486226; c=relaxed/simple;
	bh=vz+YfblBo3QfOpwB1FPiUkicsoKm3SMVqbFyMUKkCFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3WcX+3TtKy6y9sulF5rPO6o1StN0Ei5z7OgvSzcJU1HEMJGPZOPqq/Dex8jD9ppP3abdPt53G9hnlApuljljqPDaN784hYdsE4PfcEUy1WdMMLIDkG2F7k3N4bdaLYrax9CvXFi98XvQXIR375LFYswWjIFBmkSAr0W7xzc+8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S5UmSO2X; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S5UmSO2X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714486224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LecQUVGvecJLTuG1l1rChvgN6KTtzp5XXcuKsom4sxQ=;
	b=S5UmSO2XhbCdoCft/kDxjd/oks0eVEmJ5q3GZuVlBG5zEDgfuyQxaYWpNB/TA5CA/bH+ms
	wvI+s4KA5JHa9UjW97K17R0GM5SbWnQaS4rNu5AV5NIuPXxrh+UBJYZMzHd9+0xZ4NVJr8
	mHHmdto7t19ajiAsOobZujdRc9wLMlw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-530-nTjp26d8MHqPkKdHzOK-3w-1; Tue,
 30 Apr 2024 10:10:18 -0400
X-MC-Unique: nTjp26d8MHqPkKdHzOK-3w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE7CE38000A9;
	Tue, 30 Apr 2024 14:10:16 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.42.28.22])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0DF4F1C06700;
	Tue, 30 Apr 2024 14:10:14 +0000 (UTC)
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
	linux-kernel@vger.kernel.org,
	Steve French <sfrench@samba.org>,
	Shyam Prasad N <nspmangalore@gmail.com>,
	Rohith Surabattula <rohiths.msft@gmail.com>
Subject: [PATCH v7 16/16] cifs: Enable large folio support
Date: Tue, 30 Apr 2024 15:09:28 +0100
Message-ID: <20240430140930.262762-17-dhowells@redhat.com>
In-Reply-To: <20240430140930.262762-1-dhowells@redhat.com>
References: <20240430140930.262762-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

Now that cifs is using netfslib for its VM interaction, it only sees I/O in
terms of iov_iter iterators and does not see pages or folios.  This makes
large multipage folios transparent to cifs and so we can turn on multipage
folios on regular files.

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
 fs/smb/client/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 5239c823de86..e8bfeea23660 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -72,6 +72,7 @@ static void cifs_set_ops(struct inode *inode)
 			inode->i_data.a_ops = &cifs_addr_ops_smallbuf;
 		else
 			inode->i_data.a_ops = &cifs_addr_ops;
+		mapping_set_large_folios(inode->i_mapping);
 		break;
 	case S_IFDIR:
 		if (IS_AUTOMOUNT(inode)) {

