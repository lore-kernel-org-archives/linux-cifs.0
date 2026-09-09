Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB9335CB61
	for <linux-cifs@vger.kernel.org>; Wed,  9 Sep 2026 17:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788974001; cv=none; b=hmh+GCGMoNlO9ugrRfkhS1TRX9lRm+qEEVvGYi/JlB1zgdldFoNkjrnInPogR9ozi5o87UpmBEXB5dgDbxlVejLffR1YGiAI0XD716kOVkSc/vHQFro2lPFFnfbRdRejXvzwOq4yFlEr37Nal5JxOsLAaAj3R2+joxmb2JHXhUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788974001; c=relaxed/simple;
	bh=Dvelg2xfRPt+GEBXYOdSLVS/wF4eTLVcXc9LhLKkpgo=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=PAA7LVrfKsLPRjQKi6SBjFLmJzJhJmuGUj/0KP3dvBG9ENAwC3y7PdXdorPYPP+Lm2CIADowQ59cgDzOyXTKKvtURrM0bYei8H85FWLSwn5F1NHsGfAJPCnwlPJlD9ErBgyVD+I9POAAOo1JIvJ4OccQVhdf2zRrIlUX7fBfyvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YcQzkByQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YcQzkByQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788973998;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZRfKNGkawxZEEz9tQqGkbnM4yy5E2ATyItYlCc0VsaI=;
	b=YcQzkByQftwcmRmJy78qQd++OYuToQ1TVukzJF4c6v4k1yS4wicCXUb16iJ5wWF49zXrfz
	tI6NtmrLlQkcFAOEvuF0gZRSxWEe+vwoHeoPRbV6vQsj9SiD0VvSNCy2nU8CeqY9hclFRm
	oGrkp+lVVPrSs5tnNjCVZXfiABxblTo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-690-tCCd9euFNRK1NjEfRlWKug-1; Wed,
 09 Sep 2026 13:13:12 -0400
X-MC-Unique: tCCd9euFNRK1NjEfRlWKug-1
X-Mimecast-MFC-AGG-ID: tCCd9euFNRK1NjEfRlWKug_1788973990
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 64D6D19540C3;
	Wed,  9 Sep 2026 17:13:10 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.158])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 258EE767;
	Wed,  9 Sep 2026 17:13:07 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <afd68097-b2b2-47e5-889b-fb077e7a9247@redhat.com>
References: <afd68097-b2b2-47e5-889b-fb077e7a9247@redhat.com> <a385053c-1c4a-4060-a3bb-befa007ddb33@redhat.com> <1714046.1788952509@warthog.procyon.org.uk>
To: sorenson@redhat.com
Cc: dhowells@redhat.com, Paulo Alcantara <pc@manguebit.org>,
    Jeff Layton <jlayton@kernel.org>, linux-fsdevel@vger.kernel.org,
    netfs@lists.linux.dev, CIFS <linux-cifs@vger.kernel.org>,
    linux-kernel@vger.kernel.org
Subject: Re: netfs_read_gaps(): aliased sink folio makes the read destination unreadable, SIGBUS on cifs with signing
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1729857.1788973986.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 18:13:06 +0100
Message-ID: <1729858.1788973986@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

How's the attached look?

David
---
commit bc3adc29e9ed4bd564527690bb553d17ee9a24be
Author: David Howells <dhowells@redhat.com>
Date:   Wed Sep 9 11:36:30 2026 +0100

    netfs: Fix netfs_read_gaps() to use separate sink folios
    =

    Fix netfs_read_gaps() to use separate folios rather than re-using a si=
ngle
    sink folio to discard the unwanted data so that cifs checksum checking=
 sees
    all the data that was fetched.
    =

    Fixes: 7f84a7b9892d ("netfs: Make netfs_read_folio() handle streaming-=
write pages")
    Reported-by: Frank Sorenson <sorenson@redhat.com>
    Closes: https://lore.kernel.org/r/a385053c-1c4a-4060-a3bb-befa007ddb33=
@redhat.com/
    Signed-off-by: David Howells <dhowells@redhat.com>
    Tested-by: Frank Sorenson <sorenson@redhat.com>
    cc: Paulo Alcantara <pc@manguebit.org>
    cc: Namjae Jeon <linkinjeon@kernel.org>
    cc: netfs@lists.linux.dev
    cc: linux-cifs@vger.kernel.org
    cc: linux-fsdevel@vger.kernel.org

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 424df70a5c30..0f5220461f8e 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -482,15 +482,14 @@ static int netfs_read_gaps(struct file *file, struct=
 folio *folio)
 	struct netfs_group *group =3D netfs_folio_group(folio);
 	struct netfs_folio *finfo =3D netfs_folio_info(folio);
 	struct netfs_inode *ctx =3D netfs_inode(mapping->host);
-	struct folio *sink =3D NULL;
-	struct bio_vec *bvec;
+	struct bio_vec *bvec =3D NULL;
 	unsigned int from =3D finfo->dirty_offset;
 	unsigned int to =3D from + finfo->dirty_len;
-	unsigned int off =3D 0, i =3D 0;
+	unsigned int off =3D 0;
 	size_t flen =3D folio_size(folio);
 	size_t nr_bvec =3D flen / PAGE_SIZE + 2;
 	size_t part;
-	int ret;
+	int ret, i =3D 0, sink_from =3D -1, sink_to =3D -1;
 =

 	_enter("%lx", folio->index);
 =

@@ -515,24 +514,23 @@ static int netfs_read_gaps(struct file *file, struct=
 folio *folio)
 	if (!bvec)
 		goto discard;
 =

-	sink =3D folio_alloc(GFP_KERNEL, 0);
-	if (!sink) {
-		kfree(bvec);
-		goto discard;
-	}
-
 	trace_netfs_folio(folio, netfs_folio_trace_read_gaps);
 =

-	rreq->direct_bv =3D bvec;
-	rreq->direct_bv_count =3D nr_bvec;
 	if (from > 0) {
 		bvec_set_folio(&bvec[i++], folio, from, 0);
 		off =3D from;
 	}
+	sink_from =3D i;
 	while (off < to) {
+		struct folio *sink =3D folio_alloc(GFP_KERNEL, 0);
+
+		if (!sink)
+			goto discard;
 		part =3D min_t(size_t, to - off, PAGE_SIZE);
-		bvec_set_folio(&bvec[i++], sink, part, 0);
+		bvec_set_folio(&bvec[i], sink, part, 0);
 		off +=3D part;
+		sink_to =3D i;
+		i++;
 	}
 	if (to < flen)
 		bvec_set_folio(&bvec[i++], folio, flen - to, to);
@@ -553,8 +551,10 @@ static int netfs_read_gaps(struct file *file, struct =
folio *folio)
 		folio_mark_uptodate(folio);
 	}
 =

-	if (sink)
-		folio_put(sink);
+	if (sink_to >=3D 0)
+		for (; sink_from <=3D sink_to; sink_from++)
+			folio_unlock(bvec_folio(&bvec[sink_from]));
+	kfree(bvec);
 	folio_unlock(folio);
 	netfs_put_request(rreq, netfs_rreq_trace_put_return);
 	return ret < 0 ? ret : 0;
@@ -563,6 +563,10 @@ static int netfs_read_gaps(struct file *file, struct =
folio *folio)
 	netfs_put_failed_request(rreq);
 alloc_error:
 	folio_unlock(folio);
+	if (sink_to >=3D 0)
+		for (; sink_from <=3D sink_to; sink_from++)
+			folio_put(bvec_folio(&bvec[sink_from]));
+	kfree(bvec);
 	return ret;
 }
 =

