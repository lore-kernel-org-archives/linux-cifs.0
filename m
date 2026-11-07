Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794067756;
	b=ELt4RpNkdet1UZUZF5QWWYcsoLRf8of7F68DU/JwkETWGGuYbSx5k1fJa85gKkB0X3z3
	 yOMySGENl1Nsc1SR+JX2Gwy3Nh/6WzI4yvwvMTjs0ycd8tDSaBiXUrgjsIFjxhP5GpurD
	 iibuZPDa5AcKv74pwuvhM1kXDXRDYLe5hWq09T2hfNX/K9J1G/nGYGF/M0+6MHlxVTv7H
	 PUYOdkpVP3wG/2HNP0k2uMMf27GIsLSCdUFoju1pJEX2rrVLkXYNv7sJr3QRYqRa6u7QD
	 TEKF5OABAE4VhdVylOZYwm/LET+TPOTYNrl25w60A6YgAP77wm6B73VtpfpLoxRTQjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794067756;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=CZaqB8zLqbirkp9myGrNJcVtQI5qFYQmk8ue8ilaeuU=;
	b=TuaVMI15ic39uBw9NFKLkADFST9tK7a7uF9cNfs5uCdvJFeYfg1TcycxxJ5ZGn3KaZZZ
	 5S7ADxzerRsCvl5WiO9MxOsiimPdy7cTfxjrCMzTR9Fmm4YMJHTRDKbUP6tBsUUi4iYu/
	 gNI27uh/T/cKKtYTjcRWcpgaYpSd4Vjg4OaOFylbiUc6B68br2wwWdZnVGBnc7Afw9wOf
	 hpOCnSF/FPEgxFIyv01xWF1la+yaL3yxKejZeN0AAjS5KplD1JAbsiyLnfnrFam7UBR/2
	 Z5dtWQLSkJ3hqHkRjX3KXM9Ho8UqdV100yVJHsmIwhNVvgjEi0P8cEBSyJ8nYCYQ34A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=CsgMMA3f;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBBA60A380C
	for <linux-cifs@vger.kernel.org>; Sat,  7 Nov 2026 16:09:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0BBBA60A380C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=CsgMMA3f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794067755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CZaqB8zLqbirkp9myGrNJcVtQI5qFYQmk8ue8ilaeuU=;
	b=CsgMMA3f+RhSISATPn1uMwBLxeDmyM2s19nZLOaXbDpv6l2UHOHRaw/7Bq6gaJpqGGerM7
	D+14F+EHR3cbj01DIgpZ2Pu9uOQSoTW51UBVbE54Fvqbd4nhZ8mi/TJdmtE8Mzl3QFPQ5u
	Y20daCmnim7WS1FVhHlpQT+CHsE+AKw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-38-DYzUFMebMUqyiW7ZsANATg-1; Sat,
 07 Nov 2026 11:09:09 -0500
X-MC-Unique: DYzUFMebMUqyiW7ZsANATg-1
X-Mimecast-MFC-AGG-ID: DYzUFMebMUqyiW7ZsANATg_1794067747
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E6991195608E;
	Sat,  7 Nov 2026 16:09:06 +0000 (UTC)
Received: from dhowells-thinkpadp1gen8.rmtgb.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 200A7195608C;
	Sat,  7 Nov 2026 16:09:02 +0000 (UTC)
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
Subject: [PATCH v16 06/15] afs: Fix an inconsistency in the symlink code
Date: Sat,  7 Nov 2026 16:08:09 +0000
Message-ID: <20261107160823.1465553-7-dhowells@redhat.com>
In-Reply-To: <20261107160823.1465553-1-dhowells@redhat.com>
References: <20261107160823.1465553-1-dhowells@redhat.com>
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

