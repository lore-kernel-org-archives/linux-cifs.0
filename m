Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA271F8910
	for <linux-cifs@vger.kernel.org>; Tue,  3 Dec 2024 16:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242454; cv=none; b=L6tG8jKjiOGHF2uiOXRRA4dz2Ve8aN1Y18R64xHFfUouGXm+dhdY35LtfozwdGKqP6+OZa/TfJLifQeI1/qOSOxZWE2jd9GBJcSzIaxDt6O1erVOqy42laHykrBPu9fTl3aOQntlCjmhAuAymlKhrKnKHthkErr1CzZjKVURcb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242454; c=relaxed/simple;
	bh=CfqEX2Gcq4pCgqv8gmxNPTHxxZA3SNI4TTlDg02qkBk=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=bBEuv4fZ6+FiYy4kHI7XkIKUouNC1APBqDfKAwXEAK6gAiAdcmKypTbI0YrFYebnRz5vWE2KKaVE/sIkdizKWQvvpucrA2YRjZp/Dd+cnAz0cyj/d/jDczcCu2ndwJVcgz8SG+rziEWfMBtYCG55rJ4dg0at8D4u/Z13Q5Lxiwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TMh+URnz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TMh+URnz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733242451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=niThWHauEwBijDSd8TA0mZbk/Na0oUA3zDV+giCv4EE=;
	b=TMh+URnz9Oey+BaOjx6u0JTxahupzFp+urQRSKLHZSjW+Gh4yTjhg0+C8x7Wl4a2mFSOuJ
	XOjVr++VZQIsTVVspOupuP/o9ZKjrRHdYDvmDAq9ThMFC4b/G6z0ag74OvqYg/HpIUZ99a
	Q3YIx159P7SvZoPh+Qeo9d4dlC1Mpj0=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-252-kVCWUILSP5KVZk60hDTtew-1; Tue,
 03 Dec 2024 11:14:10 -0500
X-MC-Unique: kVCWUILSP5KVZk60hDTtew-1
X-Mimecast-MFC-AGG-ID: kVCWUILSP5KVZk60hDTtew
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 174F21955DD4;
	Tue,  3 Dec 2024 16:14:09 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.48])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F34181955F2D;
	Tue,  3 Dec 2024 16:14:07 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CANT5p=qBwjBm-D8soFVVtswGEfmMtQXVW83=TNfUtvyHeFQZBA@mail.gmail.com>
References: <CANT5p=qBwjBm-D8soFVVtswGEfmMtQXVW83=TNfUtvyHeFQZBA@mail.gmail.com>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
    CIFS <linux-cifs@vger.kernel.org>
Subject: [PATCH] netfs: Fix non-contiguous donation between completed reads
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <536504.1733242446.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Dec 2024 16:14:06 +0000
Message-ID: <536505.1733242446@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

When a read subrequest finishes, if it doesn't have sufficient coverage to
complete the folio(s) covering either side of it, it will donate the exces=
s
coverage to the adjacent subrequests on either side, offloading
responsibility for unlocking the folio(s) covered to them.

Now, preference is given to donating down to a lower file offset over
donating up because that check is done first - but there's no check that
the lower subreq is actually contiguous, and so we can end up donating
incorrectly.

The scenario seen[1] is that an 8MiB readahead request spanning four 2MiB
folios is split into eight 1MiB subreqs (numbered 1 through 8).  These
terminate in the order 1,6,2,5,3,7,4,8.  What happens is:

        - 1 donates to 2
        - 6 donates to 5
        - 2 completes, unlocking the first folio (with 1).
        - 5 completes, unlocking the third folio (with 6).
        - 3 donates to 4
        - 7 donates to 4 incorrectly
        - 4 completes, unlocking the second folio (with 3), but can't use
          the excess from 7.
        - 8 donates to 4, also incorrectly.

Fix this by preventing downward donation if the subreqs are not contiguous
(in the example above, 7 donates to 4 across the gap left by 5 and 6).

Reported-by: Shyam Prasad N <nspmangalore@gmail.com>
Closes: https://lore.kernel.org/r/CANT5p=3DqBwjBm-D8soFVVtswGEfmMtQXVW83=3D=
TNfUtvyHeFQZBA@mail.gmail.com/
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.com>
cc: Jeff Layton <jlayton@kernel.org>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Link: https://lore.kernel.org/r/526707.1733224486@warthog.procyon.org.uk/ =
[1]
---
 fs/netfs/read_collect.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index 3cbb289535a8..b415e3972336 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -247,16 +247,17 @@ static bool netfs_consume_read_data(struct netfs_io_=
subrequest *subreq, bool was
 =

 	/* Deal with the trickiest case: that this subreq is in the middle of a
 	 * folio, not touching either edge, but finishes first.  In such a
-	 * case, we donate to the previous subreq, if there is one, so that the
-	 * donation is only handled when that completes - and remove this
-	 * subreq from the list.
+	 * case, we donate to the previous subreq, if there is one and if it is
+	 * contiguous, so that the donation is only handled when that completes
+	 * - and remove this subreq from the list.
 	 *
 	 * If the previous subreq finished first, we will have acquired their
 	 * donation and should be able to unlock folios and/or donate nextwards.
 	 */
 	if (!subreq->consumed &&
 	    !prev_donated &&
-	    !list_is_first(&subreq->rreq_link, &rreq->subrequests)) {
+	    !list_is_first(&subreq->rreq_link, &rreq->subrequests) &&
+	    subreq->start =3D=3D prev->start + prev->len) {
 		prev =3D list_prev_entry(subreq, rreq_link);
 		WRITE_ONCE(prev->next_donated, prev->next_donated + subreq->len);
 		subreq->start +=3D subreq->len;

