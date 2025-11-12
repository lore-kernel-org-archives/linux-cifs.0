Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C20347FCA
	for <linux-cifs@vger.kernel.org>; Wed, 12 Nov 2025 18:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762971258; cv=none; b=jhjP+lolurCsCujG8KafmVM/PkPAs7ch+wi6kEwLc+aWkGl7r2WOYi5dyNPbgmN6PC3gyN0Gsk0NWFwQNRF6fQAJTnRiMPGgQ0koixqFGW4CB2KAjaCUZWJF/lR3PT9DUJfh/3Tfo6pID0oI1wS0x7JGRIEWd09C5ZZfN7EG3SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762971258; c=relaxed/simple;
	bh=YEFutSmuwDF90Rmg/rlHufn/Jawdw7U3vY1ZFFN1eEk=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=GNQWtmsA0RT5wj9+VDnEmd5O5RHOwCSLtqZxeuml70rCE+Jw95XhNE57ueQlanaDGfGl+FD8SJPYx3ksrDmTuCnqZePaG7lsv3VHXPi323Aac9DpoRLrs/sISzi1ptyf6CYnNG9f3fxRuUnbZI7He5U7tuN6x2YK6dy3bvZcFjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Prup5R2T; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Prup5R2T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762971255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+Evo58SPM/a7yDNs4/wF3AFs/xv6eTmjLTb1V54ancA=;
	b=Prup5R2TG5Tw9m8ybGZWXUETXWRyEf8qRbo8mIgdJ5DV1twLqsGV6TLaAVROGeKE6pANTY
	t/Y5MYQWcVO1JjQbwlvPzZC3WghDU2nx4uMbiYAfO/AjcfJuJvgBk0lVJe4+Q7euk+hvi9
	h8aChbkLjwInkrPTCIMyek8Vio6ms8E=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-677-D92ll-idOG6dK6aMpn0Fkg-1; Wed,
 12 Nov 2025 13:14:14 -0500
X-MC-Unique: D92ll-idOG6dK6aMpn0Fkg-1
X-Mimecast-MFC-AGG-ID: D92ll-idOG6dK6aMpn0Fkg_1762971253
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A336B1956095;
	Wed, 12 Nov 2025 18:14:12 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.87])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 18311196FC8B;
	Wed, 12 Nov 2025 18:14:08 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CANT5p=px8Lh1C2O0F8i1htoMACWZbLPfw0NEzUco5Njss2c7pQ@mail.gmail.com>
References: <CANT5p=px8Lh1C2O0F8i1htoMACWZbLPfw0NEzUco5Njss2c7pQ@mail.gmail.com> <YT1PR01MB9451424C6870795133FB7C96B3A72@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM> <36fb31bf2c854cdc930a3415f5551dcd@izw-berlin.de> <CAH2r5mtNtyqZBpT8hL2xvZ8QYWAymrPR-5LmpZbeTHr_1ATPWg@mail.gmail.com> <uildcjpqxzc5nckupgdeeifkrqwrau2qxuc2df2uxuyys3i2k2@iz2bmi6yojyu> <YT1PR01MB945191C652AEE173CEADBA3EB3A12@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM> <aaloi77h2f5xolhrnegxsxntqp2jopwisunmjfp45idsoockpy@cy5agf2oqjop> <YT1PR01MB9451A0F623371F50E77CC1C9B3AD2@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM> <CAGypqWw0bnE7_=49HSxgExouk4s5PVFQ6gVH50wrE8_=4b5vAg@mail.gmail.com> <958479.1762852948@warthog.procyon.org.uk> <CANT5p=rh7BQBnwNYLxHtFw=YUhAGVnskJ=33i6Eg4porU-X+5A@mail.gmail.com>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: dhowells@redhat.com, Bharath SM <bharathsm.hsk@gmail.com>,
    Mark A Whiting <whitingm@opentext.com>, henrique.carvalho@suse.com,
    Enzo Matsumiya <ematsumiya@suse.de>,
    Steve French <smfrench@gmail.com>,
    Paulo Alcantara <pc@manguebit.org>,
    "Heckmann,
                         Ilja" <heckmann@izw-berlin.de>,
    "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: [[ EXT ]] [BUG REPORT] cifs/smb data corruption when writing, x86_64, kernel 6.6.71
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1392199.1762971247.1@warthog.procyon.org.uk>
Date: Wed, 12 Nov 2025 18:14:07 +0000
Message-ID: <1392200.1762971247@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Shyam Prasad N <nspmangalore@gmail.com> wrote:

> 4. Page 2 is now written to by the next write, which extends the file
> by another 5k. Page 2 and 3 are now marked dirty.

It sounds like this is the crux of the problem.

The caller, cifs_write_back_from_locked_folio() has a stale copy of ->i_size.

I think we need to do one or more of:

 (1) our copy of i_size should be updated by cifs_extend_writeback() whilst we
     hold the lock on a folio

 (2) we should reject on what appears (given the stale i_size) to be a partial
     folio if inode->i_size changed

 (3) cifs_extend_writeback() should just stop - and maybe abandon the current
     batch - if it sees i_size has changed.

     Note that abandoning the contents of the batch rather than doing the
     flag-flipping loop is fine as they're merely locked to that point and we
     don't have to reverse the PG_dirty -> PG_write transition.

David

