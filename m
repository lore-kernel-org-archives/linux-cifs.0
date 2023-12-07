Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iB7iTkNj"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E5E121
	for <linux-cifs@vger.kernel.org>; Thu,  7 Dec 2023 07:58:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701964734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=Rf4tLfo9pF6yxazJHapLb8GMJYYM77NLkk22oYwFpQA=;
	b=iB7iTkNj6xiCqtB49jINHPOI1Vp5gPPLq4ctdzK3lTS/v6w5nL3TvBPywshCR2U45AFNu2
	e0pSIq8LWYP5rSMg25EUC4Rl2QmdYC36Gr06A9HRroLVA3L510ZzDKSj9406jw6IZoMPDa
	QxGLfIBTL3tnxt3YE29IYa33KjxPkZE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-139-b5LHgerXOWuiXKtScoUuSw-1; Thu, 07 Dec 2023 10:58:49 -0500
X-MC-Unique: b5LHgerXOWuiXKtScoUuSw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83A8C85A58B;
	Thu,  7 Dec 2023 15:58:48 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.161])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 26F022166AE2;
	Thu,  7 Dec 2023 15:58:47 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Steve French <smfrench@gmail.com>,
    Namjae Jeon <linkinjeon@kernel.org>, jra@samba.org
cc: dhowells@redhat.com, ronniesahlberg@gmail.com,
    Tom Talpey <tom@talpey.com>, Stefan Metzmacher <metze@samba.org>,
    jlayton@kernel.org, linux-cifs@vger.kernel.org,
    samba-technical@lists.samba.org
Subject: Can fallocate() ops be emulated better using SMB request compounding?
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <700922.1701964726.1@warthog.procyon.org.uk>
Date: Thu, 07 Dec 2023 15:58:46 +0000
Message-ID: <700923.1701964726@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Hi Steve, Namjae, Jeremy,

At the moment certain fallocate() operations aren't very well implemented in
the cifs filesystem on Linux, either because the protocol doesn't fully
support them or because the ops being used don't also set the EOF marker at
the same time and a separate RPC must be made to do that.

For instance:

 - FALLOC_FL_ZERO_RANGE does some zeroing and then sets the EOF as two
   distinctly separate operations.  The code prevents you from doing this op
   under some circumstances as it doesn't have an oplock and doesn't want to
   race with a third party (note that smb3_punch_hole() doesn't have this
   check).

 - FALLOC_FL_COLLAPSE_RANGE uses COPYCHUNK to move the file down and then sets
   the EOF as two separate operations as there is no protocol op for this.
   However, the copy will likely fail if the ranges overlap and it's
   non-atomic with respect to a third party.

 - FALLOC_FL_INSERT_RANGE has the same issues as FALLOC_FL_COLLAPSE_RANGE.

Question: Would it be possible to do all of these better by using compounding
with SMB2_FLAGS_RELATED_OPERATIONS?  In particular, if two components of a
compound are marked related, does the second get skipped if the first fails?
Further, are the two ops then essentially done atomically?

If this is the case, then for FALLOC_FL_ZERO_RANGE, just compounding the
SET_ZERO_DATA with the SET-EOF will reduce or eliminate the race window.

For FALLOC_FL_COLLAPSE/INSERT_RANGE, we could compound the COPYCHUNK and
SET-EOF.  As long as the SET-EOF won't happen if the COPYCHUNK fails, this
will reduce the race.

However, for COLLAPSE/INSERT, we can go further: recognise the { COPYCHUNK,
SET-EOF } compound on the server and see if the file positions, chunk length
EOF and future EOF are consistent with a collapse/insert request and, if so,
convert the pair of them to a single fallocate() call and try that; if that
fails, fall back to copy_file_range() and ftruncate().


As an alternative, at least for removing the 3rd-party races, is it possible
to make sure we have an appropriate oplock around the two components in each
case?  It would mean potentially more trips to the server, but would remove
the window, I think.

David

