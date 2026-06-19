Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695423655DB
	for <linux-cifs@vger.kernel.org>; Fri, 19 Jun 2026 14:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781878029; cv=none; b=LL6jdlN/+yp+/RtMVATlPwNDTQZwURX2CwfjSWUoLmpqvr6udYkgRSlEnc7jAWF5Rdxmoi6t31iDq9tqINwa9RVB4xyMfmqhdAnqEtU/pC4EQxYCbVSBGEaA/Hd4jgD10BXuBJHLQ1i01aV6KGf5PRW2/2VsQE+1k61v7Iz92Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781878029; c=relaxed/simple;
	bh=/VMGqRXj2H1ZoJ9Len4yDIgpZpvQtbhJDErO1fIajO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bv7nE9uhu6Mbgamz44FN8F2gJs31Bqc/gFpgYqriOuJbKqU7K2wcQ+dhz3QkdQlIYsKbx4okgBs6I7Da8jy3rXkxcKZ+8ppWulV31PyHCyBwh9CDV83BkBIFd1po2MOd5veEOXGy9/HVhrYxJmA9RbGAx4LQA//+n7Fr3aTcDoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TVwsnuPF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TVwsnuPF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781878027;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6xzr+Qi6ZDs+0Riq2AVSQ7VxUd6HCUSx75f0+qxBdXU=;
	b=TVwsnuPFPL4FXFc7LzFAdz03396z/N8QVBvUu6mRR7Uoc2uG2uVPRgByFG1ZsetIiM25w4
	Y2RuDvSX5AqV88eWsG9oQn/QCZBqmHv9XwrklSzUwfKeRPrf6aNHJ05I4lHfw9koon6rS7
	GYL/LwqBQuJR0phaOPeX3XxEe5dff60=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-361-2FCaygFbMVWNeJZhqa1f0w-1; Fri,
 19 Jun 2026 10:07:05 -0400
X-MC-Unique: 2FCaygFbMVWNeJZhqa1f0w-1
X-Mimecast-MFC-AGG-ID: 2FCaygFbMVWNeJZhqa1f0w_1781878023
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F25DD197731A;
	Fri, 19 Jun 2026 14:07:02 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.50.44])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DAB2E1688;
	Fri, 19 Jun 2026 14:06:59 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] cachefiles: Fix double fput
Date: Fri, 19 Jun 2026 15:06:06 +0100
Message-ID: <20260619140646.2633762-3-dhowells@redhat.com>
In-Reply-To: <20260619140646.2633762-1-dhowells@redhat.com>
References: <20260619140646.2633762-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Fix a double fput() in error handling in cachefiles_create_tmpfile().

Link: https://sashiko.dev/#/patchset/20260608145432.681865-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/cachefiles/namei.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index 2937db690b40..a464c4646c04 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -467,7 +467,6 @@ struct file *cachefiles_create_tmpfile(struct cachefiles_object *object)
 	ret = -EINVAL;
 	if (unlikely(!file->f_op->read_iter) ||
 	    unlikely(!file->f_op->write_iter)) {
-		fput(file);
 		pr_notice("Cache does not support read_iter and write_iter\n");
 		goto err_unuse;
 	}

