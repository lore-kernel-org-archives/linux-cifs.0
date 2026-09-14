Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E1849E5E9
	for <linux-cifs@vger.kernel.org>; Mon, 14 Sep 2026 15:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789399239; cv=none; b=K78LhiiRGmja/lyGIlq+vXKfgvp4ahdtfe/Xq0xEzVP3t1DhrMf6RizkEb+RdO/2GWwnabSIDjsA/NTWjPPRkiFCWjJiNc/yTuaBCa+R7bndQcAdRa6IrJ2wdRJ6/jLsZS/RE8PYA+nnY+JNc4ld8YXG/zPf64AbWBfTBT8Af+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789399239; c=relaxed/simple;
	bh=R86u+dZCTodjcBLgcHb8H8d3EJ/CATkpdjV43fjKhuE=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=o3EW15jWT2Lr1zeqY2lRQfkds8p+dkvlyvSoeCgZ0gRjvfzfiER+qX6/Rhjkngc+DoNLeNkHfsBxZMrdn9qjjGZ6Mye8N/Azw2epFGzOSq2Ii7R5iChdxSs3IWEeJz5zs4jDdcTnY6ajF0tua/eBzO11F2z5QfQ6yMwW9q4ysoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TkE+SCG8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TkE+SCG8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789399236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=buKLTSUlaD4MqKKVAvbS9GtGxrepxqulB+fMUyn6usY=;
	b=TkE+SCG8NEq753Mantbjg5Ig0ijLZdS316jhtbRiRYB3+8fghc1wOWf75vBJZ71vCqHkCp
	SMKU6cyF20dWF1wot7aJFmPxwFv+lJdXe+wdVflbvGNxxilZBSJKlrXwZbbx/y9/JZ/HzR
	CWmCb6mgyYVexIj1wEv8UiaKEnRN14c=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-128-2hvwp7MEMrK3cNaxMzw_7w-1; Mon,
 14 Sep 2026 11:20:33 -0400
X-MC-Unique: 2hvwp7MEMrK3cNaxMzw_7w-1
X-Mimecast-MFC-AGG-ID: 2hvwp7MEMrK3cNaxMzw_7w_1789399232
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 29E89189F3A3;
	Mon, 14 Sep 2026 15:20:32 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.54])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 33C97180056E;
	Mon, 14 Sep 2026 15:20:28 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <brauner@kernel.org>
cc: dhowells@redhat.com, Frank Sorenson <sorenson@redhat.com>,
    Paulo Alcantara <pc@manguebit.org>,
    Namjae Jeon <linkinjeon@kernel.org>, netfs@lists.linux.dev,
    linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: [PATCH] netfs: Fix netfs_read_gaps() to use separate sink folios
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3228133.1789399227.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 16:20:27 +0100
Message-ID: <3228134.1789399227@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

    =

Fix netfs_read_gaps() to use separate folios rather than re-using a single
sink folio to discard the unwanted data so that cifs checksum checking see=
s
all the data that was fetched.

Fixes: 7f84a7b9892d ("netfs: Make netfs_read_folio() handle streaming-writ=
e pages")
Reported-by: Frank Sorenson <sorenson@redhat.com>
Closes: https://lore.kernel.org/r/a385053c-1c4a-4060-a3bb-befa007ddb33@red=
hat.com/
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Frank Sorenson <sorenson@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Namjae Jeon <linkinjeon@kernel.org>
cc: netfs@lists.linux.dev
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/netfs/buffered_read.c |   34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 424df70a5c30..105194de6e13 100644
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
+			folio_put(bvec_folio(&bvec[sink_from]));
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

