Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E7D3321D4
	for <linux-cifs@vger.kernel.org>; Wed,  3 Dec 2025 21:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764798936; cv=none; b=J9PZmf6Xm0EuFKZ3X14Hyaon6otWxZnITfEviJGX6F/RermkAusvIyjVoUUoNj+2P6WV4EV4n61WsjXadJtTVPgQfPp32DG5IPHZWPqGaEyZ+FeQe9NsLNDnQvuDWpn826cVI6QA0oAb/EQ+Oe+bJNFWApEVc1z7ccOhfeYtAw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764798936; c=relaxed/simple;
	bh=6MT+BRoFcwpyxp1U6a1lZB7Kai83FgRSOE/acObNls0=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=U/dcLIZ9eXwfNpoeot5g2bz4myipvlFUNfTeuDb96oOdmXo4PaZlOqTUkvyAnzrCn5psGplNqW8R3fam5TLvvK3TuLSh6gAdOlgfmOdSfls6oMeZ/nxHzeQg/e4CrNmeGwVwcR3UOjMrw9oPsqgY1ImNXlCzIzDXhXpSq4qrIqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vxi1P7U6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vxi1P7U6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764798934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uA6IWYK7L5/jdEKTAJNw36cf0/7jd94rzFjAoJEThZI=;
	b=Vxi1P7U6YcDP4NwRBszUBJQFzYkDR6Jy1a/fF8Z+UdhQfTfOGvYD1E83IJ8XDwI+bbeNUy
	EL+wCxh7z2YuP0GffhpInYNwQp75g/C0yCOLttEv/i7puWHArl6SsdFxYY+TAtouTgLGI2
	7rc5ODG4M6J9/+tfx36MJEIfoiZYBAE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-664-bt9gstNrP0SRPuq2msu0VA-1; Wed,
 03 Dec 2025 16:55:33 -0500
X-MC-Unique: bt9gstNrP0SRPuq2msu0VA-1
X-Mimecast-MFC-AGG-ID: bt9gstNrP0SRPuq2msu0VA_1764798931
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 28FAD1956089;
	Wed,  3 Dec 2025 21:55:31 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.14])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F1079180045B;
	Wed,  3 Dec 2025 21:55:28 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1597479.1764697506@warthog.procyon.org.uk>
References: <1597479.1764697506@warthog.procyon.org.uk>
To: Steve French <sfrench@samba.org>
Cc: dhowells@redhat.com, Paulo Alcantara <pc@manguebit.org>,
    Shyam Prasad N <sprasad@microsoft.com>, linux-cifs@vger.kernel.org,
    netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
    stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Fix handling of a beyond-EOF DIO/unbuffered read over SMB2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1961802.1764798927.1@warthog.procyon.org.uk>
Date: Wed, 03 Dec 2025 21:55:27 +0000
Message-ID: <1961803.1764798927@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

If a DIO read or an unbuffered read request extends beyond the EOF, the
server will return a short read and a status code indicating that EOF was
hit, which gets translated to -ENODATA.  Note that the client does not cap
the request at i_size, but asks for the amount requested in case there's a
race on the server with a third party.

Now, on the client side, the request will get split into multiple
subrequests if rsize is smaller than the full request size.  A subrequest
that starts before or at the EOF and returns short data up to the EOF will
be correctly handled, with the NETFS_SREQ_HIT_EOF flag being set,
indicating to netfslib that we can't read more.

If a subrequest, however, starts after the EOF and not at it, HIT_EOF will
not be flagged, its error will be set to -ENODATA and it will be abandoned.
This will cause the request as a whole to fail with -ENODATA.

Fix this by setting NETFS_SREQ_HIT_EOF on any subrequest that lies beyond
the EOF marker.

Fixes: 1da29f2c39b6 ("netfs, cifs: Fix handling of short DIO read")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index d21606fa3f1f..f142f62c639d 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4656,7 +4656,7 @@ smb2_readv_callback(struct mid_q_entry *mid)
 	} else {
 		size_t trans = rdata->subreq.transferred + rdata->got_bytes;
 		if (trans < rdata->subreq.len &&
-		    rdata->subreq.start + trans == ictx->remote_i_size) {
+		    rdata->subreq.start + trans >= ictx->remote_i_size) {
 			__set_bit(NETFS_SREQ_HIT_EOF, &rdata->subreq.flags);
 			rdata->result = 0;
 		}

