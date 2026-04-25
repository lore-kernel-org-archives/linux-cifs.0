Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71E3396B9D
	for <linux-cifs@vger.kernel.org>; Sat, 25 Apr 2026 12:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777121770; cv=none; b=fP4lu5aGJOSwxzgVHUHAy6SMbt3sh9UZTrAr0t7j+PPSbYwtcq84CBRzZSEukIk4ot8QQswipv/vKVjbRHsnWIRUpqaz7FJyeOFueOhR+M+hRhJHiPUL21RzEpusd7iEJOvHNl2MV/KZ+vOFu59ZiI5mTj2N4N9StrNqUWI9CCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777121770; c=relaxed/simple;
	bh=3aYouAujFzp76xqqlG9o4vknZZvSlVMk3kOrrxli+y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZ3pybJ7X/WVT2uHcRhJSvkFKpJsMiSLePsIyGkC4lOFhTfggSGlpHmLIJrXCixUnkCCRvzm+iZij7VMgSziJ9eM13mjQtczTf54lWhFhrluhcay+JgnUpJEYO/pbDf9sJNQbtM8+Cy0f1BcC0BwQKmbyI9kObbPrjpXBDVahKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HeTcD2Jy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HeTcD2Jy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777121768;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CEaZFT1kA2C9fmI8tLKUXOafS9Zq2QwNR5SdFuG0lEc=;
	b=HeTcD2JyjLlfIiryfvg7CzeYjoYx/zoDcypuvESaeiG0G+N4qvDZ+nZOj7X2vLy/PBG7cJ
	jpt+5a9oxNNP/S4+ZFLP6/UmKulHdMIUK5THmTAGWf7YujDI/y24a4ohMLwWOhcQfOWuvH
	480RJVnqgiKCuhEj+es0TLMZNYPFboE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-445-mOWP0i8_M_KNCYMj24Mf9A-1; Sat,
 25 Apr 2026 08:56:02 -0400
X-MC-Unique: mOWP0i8_M_KNCYMj24Mf9A-1
X-Mimecast-MFC-AGG-ID: mOWP0i8_M_KNCYMj24Mf9A_1777121761
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DC28B1956080;
	Sat, 25 Apr 2026 12:56:00 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.17])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D1F5630078C2;
	Sat, 25 Apr 2026 12:55:57 +0000 (UTC)
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
Subject: [PATCH v3 18/19] afs: Fix afs_get_link() to take validate_lock around afs_read_single()
Date: Sat, 25 Apr 2026 13:54:22 +0100
Message-ID: <20260425125426.3855807-19-dhowells@redhat.com>
In-Reply-To: <20260425125426.3855807-1-dhowells@redhat.com>
References: <20260425125426.3855807-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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

