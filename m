Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CEA2E06EA
	for <linux-cifs@vger.kernel.org>; Thu, 23 Apr 2026 22:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776982962; cv=none; b=pWJTrzRZQi+lOyabw6x4+4EX2HOyUpO6zqPTQErJGj+AmP/tWTiIa1WjsMDlBy6MQTQktuXhhXqigRxofw5MNGn8zasaYLN6A5aCg6+iiygQbrXZ4KKkLbD8O1lCS1cPp8qmopNjJnsL62wmlrjX9OgnNjxmxQxNbxeYT7VON9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776982962; c=relaxed/simple;
	bh=3aYouAujFzp76xqqlG9o4vknZZvSlVMk3kOrrxli+y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=meTJRJwC5NW4GN2koPMbSX3GtoAG1COCz+tJbSUb4k5WdWqSthHl9XeofIMJru2JNbdTUwT2SpjjIgmXlDYelVfo5a32W+NP+mzIIfTpx3R4Hx1yEyToF2AiDTHDuLfMZjGbzPUqI+5Q0C+NVU2y7Iuscb2x5Rms9m4HsJmG8eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G5uc/idx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G5uc/idx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776982959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CEaZFT1kA2C9fmI8tLKUXOafS9Zq2QwNR5SdFuG0lEc=;
	b=G5uc/idxSx/apvBFFLOh1X2M/IEPV55jvoMl8SLbcMuZ0L1pNww627qP0gY+64wxbYzghw
	XUMo1uqdW4S2RwlGqQyWXR1KpWBMNwqg02v35+p3jXm1YtE/NUkFu0FEPH/Q6QciUc9tjQ
	vG6pAyRlAjSXoPsknZ4FBlYM7UEJWW4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-20-6mRXVomyPvGKAhZHmx0xIA-1; Thu,
 23 Apr 2026 18:22:37 -0400
X-MC-Unique: 6mRXVomyPvGKAhZHmx0xIA-1
X-Mimecast-MFC-AGG-ID: 6mRXVomyPvGKAhZHmx0xIA_1776982956
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BC47C1956095;
	Thu, 23 Apr 2026 22:22:35 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.17])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2CCFF19560AB;
	Thu, 23 Apr 2026 22:22:31 +0000 (UTC)
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
	Marc Dionne <marc.dionne@auristor.com>
Subject: [PATCH 3/4] afs: Fix afs_get_link() to take validate_lock around afs_read_single()
Date: Thu, 23 Apr 2026 23:22:06 +0100
Message-ID: <20260423222209.3054909-4-dhowells@redhat.com>
In-Reply-To: <20260423222209.3054909-1-dhowells@redhat.com>
References: <20260423222209.3054909-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Fix afs_get_link() to take the validate_lock around afs_read_single() to
prevent races between multiple ->get_link() calls.

Fixes: eae9e78951bb ("afs: Use netfslib for symlinks, allowing them to be cached")
Closes: https://sashiko.dev/#/patchset/20260326104544.509518-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/afs/inode.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 06e25e1b12df..5207c4a003f6 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -78,10 +78,19 @@ const char *afs_get_link(struct dentry *dentry, struct inode *inode,
 		goto good;
 
 fetch:
-	ret = afs_read_single(vnode, NULL);
-	if (ret < 0)
-		return ERR_PTR(ret);
-	set_bit(AFS_VNODE_DIR_READ, &vnode->flags);
+	if (down_write_killable(&vnode->validate_lock) < 0)
+		return ERR_PTR(-ERESTARTSYS);
+	if (test_and_clear_bit(AFS_VNODE_ZAP_DATA, &vnode->flags) ||
+	    !test_bit(AFS_VNODE_DIR_READ, &vnode->flags)) {
+		ret = afs_read_single(vnode, NULL);
+		if (ret < 0) {
+			up_write(&vnode->validate_lock);
+			return ERR_PTR(ret);
+		}
+		set_bit(AFS_VNODE_DIR_READ, &vnode->flags);
+	}
+
+	up_write(&vnode->validate_lock);
 
 good:
 	folio = folioq_folio(vnode->directory, 0);

