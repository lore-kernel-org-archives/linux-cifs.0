Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181762C15A5
	for <linux-cifs@vger.kernel.org>; Sat, 11 Apr 2026 08:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775897837; cv=none; b=rbjP90rX4KpDjrKWSEp1O0M3VwsRI9i2/WX7WLaFVEE0JMMIfsUQGXhj97KhpxhRe1KdpSNkLNgE8S5JzChLYe2Vdr7yPo8DJeorDUOaqo1wOWKLw7LMs0IcN7ySY8+xZTGxyVxHJbxZXVYDh0n0OFYaGYFl8WkXmUAcSEB3rz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775897837; c=relaxed/simple;
	bh=Va5ic3j+XPVGHImNKjNKAB4SnRGmH/mONtJLhCgEHPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nN7XfnJagYWDdbfFINWknK2z/vUuJ5h9yGL8GO843zh2Q9Wb7TYla6MZA0BP0SUNgcCcfAooC3+abmkr5UKOJ1bCBKWYCNwR2bnBd873khkIj93Yt3ErBh1hNkjP79yPrUx/u+zU9RlSixbHRVoODWrypxS7GisrwqskQIuJvBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZsfbugLy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZsfbugLy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775897835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wyv45w2ugH74c2VSCb7J4MMwtcNcSvmG464mF8qh4Dc=;
	b=ZsfbugLy1cSn10dwtp48S1Z9ZoLLJcfY9gEQSWqEql+fPURf6cwU8B+mQMi2blt1lmLVXW
	YoH/a/p0b4PP0J9Ko5UdIFCyNZFRN7TZRrlsBB0eDTV1pBMaXJum/G680OtBO5fiSfDqe6
	2lbhMzWdIDIU6gkO618nTAE2yaHkc5A=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-465-lpn6ZtJpNsCHJ9bBcnhvXg-1; Sat,
 11 Apr 2026 04:57:10 -0400
X-MC-Unique: lpn6ZtJpNsCHJ9bBcnhvXg-1
X-Mimecast-MFC-AGG-ID: lpn6ZtJpNsCHJ9bBcnhvXg_1775897829
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B0C901956061;
	Sat, 11 Apr 2026 08:57:08 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.47])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8B19219560AB;
	Sat, 11 Apr 2026 08:57:04 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.com>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	NeilBrown <neilb@ownmail.net>,
	Marc Dionne <marc.dionne@auristor.com>,
	NeilBrown <neil@brown.name>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>
Subject: [PATCH 3/4] cachefiles: fix incorrect dentry refcount in cachefiles_cull()
Date: Sat, 11 Apr 2026 09:56:41 +0100
Message-ID: <20260411085643.3221565-4-dhowells@redhat.com>
In-Reply-To: <20260411085643.3221565-1-dhowells@redhat.com>
References: <20260411085643.3221565-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

From: NeilBrown <neilb@ownmail.net>

The patch mentioned below changed cachefiles_bury_object() to expect 2
references to the 'rep' dentry.  Three of the callers were changed to
use start_removing_dentry() which takes an extra reference so in those
cases the call gets the expected references.

However there is another call to cachefiles_bury_object() in
cachefiles_cull() which did not need to be changed to use
start_removing_dentry() and so was not properly considered.
It still passed the dentry with just one reference so the net result is
that a reference is lost.

To meet the expectations of cachefiles_bury_object(), cachefiles_cull()
must take an extra reference before the call.  It will be dropped by
cachefiles_bury_object().

Reported-by: Marc Dionne <marc.dionne@auristor.com>
Fixes: 7bb1eb45e43c ("VFS: introduce start_removing_dentry()")
Signed-off-by: NeilBrown <neil@brown.name>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/cachefiles/namei.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index e5ec90dccc27..eb9eb7683e3c 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -810,6 +810,11 @@ int cachefiles_cull(struct cachefiles_cache *cache, struct dentry *dir,
 	if (ret < 0)
 		goto error_unlock;
 
+	/*
+	 * cachefiles_bury_object() expects 2 references to 'victim',
+	 * and drops one.
+	 */
+	dget(victim);
 	ret = cachefiles_bury_object(cache, NULL, dir, victim,
 				     FSCACHE_OBJECT_WAS_CULLED);
 	dput(victim);

