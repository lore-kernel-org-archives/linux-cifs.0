Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E693B0ACD
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 11:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782302346; cv=none; b=W/m21jX/0ZlW1DAc37Ig/JGirTjWIxZQo453DCIExehxQ3rkJhqghcRX5xhMHuPvNZe+iYMOZwE0PXVwhivlbVpr+U0Qgvk3tj/CvMPin+cHwb52Qs/Um20QtI/N23UxV6uPLd/84fsqkhh/sUchOODstWiYk3mupsFoEe0Wf/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782302346; c=relaxed/simple;
	bh=xcJelI52wkI1Durndo4Ukxg2VCfFlIjSwM80/fncylE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2xV/FU8wco8FVC6DAoxCjAmAWceZ6Vo/pQWnISwDZOh1LdX4hTTGlv37oXvelNc26tXx1KpxsA0VNYY2eP96PsL6xUrZYoF12sGUDbeg0psuENUgCGshMu2A6hUu8Iky465GZUc/Vnm5+Hn0nlgqQ1RBdbDnQUS5JomIMzriX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b+I+rBWw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b+I+rBWw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782302343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i0AtkrTVa/lybpwiAxYjdBa6/G9hvdG3WAyln/4BxO4=;
	b=b+I+rBWwWJng7uu7pSvH8g/uPQ7gNiXZ4VZg4n+3x/QOyLmw+C1JYgoFXzLFC3OUPzZxjW
	VJhsxSw901jvNeTemxSXvR/GjombeizbRqPq5w8AbvJkMV8f1IMQ6XMR6TA2I8ZmELcwpk
	uZaaKKsj4RxqLdOjp3AO8TdDxbYQPYU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-620-f2V_fUnlOj-taMiMjyPlpQ-1; Wed,
 24 Jun 2026 07:58:58 -0400
X-MC-Unique: f2V_fUnlOj-taMiMjyPlpQ-1
X-Mimecast-MFC-AGG-ID: f2V_fUnlOj-taMiMjyPlpQ_1782302337
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 15F72180266F;
	Wed, 24 Jun 2026 11:58:57 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.49.152])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 58E123000B54;
	Wed, 24 Jun 2026 11:58:53 +0000 (UTC)
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
	syzbot+3c74b1f0c372e98efc32@syzkaller.appspotmail.com,
	hongao <hongao@uniontech.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Subject: [PATCH v2 14/14] netfs: Fix DIO write retry for filesystems without a ->prepare_write()
Date: Wed, 24 Jun 2026 12:57:35 +0100
Message-ID: <20260624115737.2964520-15-dhowells@redhat.com>
In-Reply-To: <20260624115737.2964520-1-dhowells@redhat.com>
References: <20260624115737.2964520-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Fix netfs_unbuffered_write() so that it doesn't re-issue a write twice when
the filesystem doesn't have a ->prepare_write().  The bit of code that does
the first issue should just be removed as everything it does is done again
when the loop it's in goes back to the top.

Reported-by: syzbot+3c74b1f0c372e98efc32@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3c74b1f0c372e98efc32
Tested-by: syzbot+3c74b1f0c372e98efc32@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: hongao <hongao@uniontech.com>
cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/direct_write.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/netfs/direct_write.c b/fs/netfs/direct_write.c
index 25f8ceb15fad..1ff1789016b8 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -190,12 +190,6 @@ static int netfs_unbuffered_write(struct netfs_io_request *wreq)
 			stream->prepare_write(subreq);
 			__set_bit(NETFS_SREQ_IN_PROGRESS, &subreq->flags);
 			netfs_stat(&netfs_n_wh_retry_write_subreq);
-		} else {
-			struct iov_iter source;
-
-			netfs_reset_iter(subreq);
-			source = subreq->io_iter;
-			netfs_reissue_write(stream, subreq, &source);
 		}
 	}
 

