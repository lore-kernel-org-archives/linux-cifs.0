Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794429093;
	b=HyyBzDz8v4GREAQQxWkLiZNeY8FxsUQwtqM1RTevEeXqKIOJQvQQtJ6XHUPTd6QPjhxV
	 NeGN4rICX9s7bybbjQJrVrwFkdlxl32F+eyYX8let+hylDye5/IoRo4+n075QSA+DL60x
	 fNGqLybm4sACAnRbuBSzcx7EJ2UYdJJ8GI413mmCANgI2FWAKNFPufOMfJ2kABGWajh8m
	 UVldFgSfsBFTQ1H1bWt8yivwJHXDoGVFO1LKx8Sj6P+GV+W+dAUXOHmw40J2RBPkNVMOd
	 Qjx7+t+mEDOiZOHjeRW19UZJr7gfDyNKD02g3pCs0FjBwcRepZkQvkGtueTdOCS2+dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794429093;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=CZaqB8zLqbirkp9myGrNJcVtQI5qFYQmk8ue8ilaeuU=;
	b=RgEyYOzf3RkG1Nrkkl78M20NHFQDQlcqXYWlsbYlwb89eniIfA4DrOjzf5WNfGJtGCRB
	 /8ZtbH0E1KahATfKFaH1nZaUOgeTThtUysptB3u7NeKu9dLMjapk/yko8Dhq/qRF1gGtV
	 PltPMU4CR26krIaAiXm6SiWPgLLETHZyb9rc1nrta6ENdUXf8B/etSx/PXA1vAi1Q2T83
	 K2EVwhd9YjNr1CnH/v4zJAx0qZp0Xz8zEwArKI6MV30qWXOmIeQ/9+ct1y2fhkr1Zt5VQ
	 SgcKj+wgQVY5oZiN4kRpZ6YedeAV6b5g8b3ph9Z+TKIn16VuytnwgO+eX0QJqg6v5bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=GB8jXMD0;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F76606A884
	for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 20:31:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32F76606A884
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=GB8jXMD0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794429092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CZaqB8zLqbirkp9myGrNJcVtQI5qFYQmk8ue8ilaeuU=;
	b=GB8jXMD0UDZAnJgrB98339EYKro4nqInUOSXLYQeNAslOg5M9slkyy5kMwB01uS+Pwm0TD
	SpX8NxrAJHnje8V//oUdO4b6x5+6Fk0TXMjpywu4ea1YENh4yeq0YHAx6qixA5Nt5HT59H
	lDLiRXW07vBTQugetakrS41z/LREd28=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-439-33PCyQqaMDaG7U0gjV2qMg-1; Wed,
 11 Nov 2026 15:31:27 -0500
X-MC-Unique: 33PCyQqaMDaG7U0gjV2qMg-1
X-Mimecast-MFC-AGG-ID: 33PCyQqaMDaG7U0gjV2qMg_1794429085
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2886D1800615;
	Wed, 11 Nov 2026 20:31:25 +0000 (UTC)
Received: from dhowells-thinkpadp1gen8.rmtgb.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CD2C11966650;
	Wed, 11 Nov 2026 20:31:20 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Matthew Wilcox <willy@infradead.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Marc Dionne <marc.dionne@auristor.com>,
	Stefan Metzmacher <metze@samba.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	v9fs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v17 07/17] afs: Fix an inconsistency in the symlink code
Date: Wed, 11 Nov 2026 20:30:20 +0000
Message-ID: <20261111203034.2126314-8-dhowells@redhat.com>
In-Reply-To: <20261111203034.2126314-1-dhowells@redhat.com>
References: <20261111203034.2126314-1-dhowells@redhat.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Fix the afs symlink code to set ->directory_size to the size of the buffer,
not PAGE_SIZE-1 or i_size.  This doesn't actually change the operation
since the value is ignored by the symlink writeback path (which writes to
the cache).

This was spotted by Claude.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Christoph Hellwig <hch@infradead.org>
cc: linux-afs@lists.infradead.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/afs/symlink.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/afs/symlink.c b/fs/afs/symlink.c
index 6b8c122877ca..a1dbd552ddff 100644
--- a/fs/afs/symlink.c
+++ b/fs/afs/symlink.c
@@ -99,7 +99,7 @@ static ssize_t afs_do_read_symlink(struct afs_vnode *vnode)
 		ret = netfs_alloc_folioq_buffer(NULL,
 						&vnode->directory, &cur_size, PAGE_SIZE,
 						mapping_gfp_mask(vnode->netfs.inode.i_mapping));
-		vnode->directory_size = PAGE_SIZE - 1;
+		vnode->directory_size = PAGE_SIZE;
 		if (ret < 0)
 			return ret;
 	}
@@ -116,7 +116,6 @@ static ssize_t afs_do_read_symlink(struct afs_vnode *vnode)
 			trace_afs_file_error(vnode, -EFBIG, afs_file_error_dir_big);
 			return -EFBIG;
 		}
-		vnode->directory_size = i_size;
 
 		/* Copy the symlink. */
 		symlink = kmalloc_flex(struct afs_symlink, content, i_size + 1);

