Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8332ED15D
	for <linux-cifs@vger.kernel.org>; Tue, 11 Nov 2025 09:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762852972; cv=none; b=pwGBP8xTAWs+6enNgsZugTNrozNYPTuVTZW+GpqpvKh3W9BHsx6sVC45p2gkJUIaxzla0RZa8hJwyBK7UNuT8+LaiBTEsEf3aB4yiJUC0Z5BMZPyQ0nzC1fR8hcI0s6p6uBZ3oAc3WaHq2hl6wAtWvtyqeoARuAjBasNosXiB5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762852972; c=relaxed/simple;
	bh=h26Eyqu+NSRgv1KG7Ls+93kR0m0AexzUFJF9O7t78nY=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=CHd692xGpV9v7mi5Z6Pux2bvvcuASZT1np+a98O4lZ5TQjVN+c8qeH1hDIq1jwIQviN4+mH/Rb2WD44S80DoRMIaSCHa3bXN9Y22rpGzvlc95oSkk/XahuTtFXytq9H72vXQk+PC1e0z9+OAYqBrIe0THBwR7CsykGnBxmxvov0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ek3rPYzh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ek3rPYzh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762852969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x53XiDjKeKuDcvknuszrxzrJsq7weROy/z8/H9pN0WM=;
	b=Ek3rPYzhGbj8pzUXwsMXDlQbK0dPHUzvScDYY3Tq+JyVeCe+80nTKe9FnHZXeKKeroDcwB
	yV6+i68NiC7JzuUOZqYsFN51FMn5tCeVKTNRUpmqi14Xrudt0x3uGVC4Je3VvB80NNW9Q/
	W+q/N0qS/qbsgANz9NZZp7EKFp1jJj8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-92-LPsq1SZwN2-OIX2v-pkPqA-1; Tue,
 11 Nov 2025 04:22:46 -0500
X-MC-Unique: LPsq1SZwN2-OIX2v-pkPqA-1
X-Mimecast-MFC-AGG-ID: LPsq1SZwN2-OIX2v-pkPqA_1762852964
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 717431954B0A;
	Tue, 11 Nov 2025 09:22:44 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.87])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C302B180035F;
	Tue, 11 Nov 2025 09:22:31 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAGypqWw0bnE7_=49HSxgExouk4s5PVFQ6gVH50wrE8_=4b5vAg@mail.gmail.com>
References: <CAGypqWw0bnE7_=49HSxgExouk4s5PVFQ6gVH50wrE8_=4b5vAg@mail.gmail.com> <YT1PR01MB9451424C6870795133FB7C96B3A72@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM> <36fb31bf2c854cdc930a3415f5551dcd@izw-berlin.de> <CAH2r5mtNtyqZBpT8hL2xvZ8QYWAymrPR-5LmpZbeTHr_1ATPWg@mail.gmail.com> <uildcjpqxzc5nckupgdeeifkrqwrau2qxuc2df2uxuyys3i2k2@iz2bmi6yojyu> <YT1PR01MB945191C652AEE173CEADBA3EB3A12@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM> <aaloi77h2f5xolhrnegxsxntqp2jopwisunmjfp45idsoockpy@cy5agf2oqjop> <YT1PR01MB9451A0F623371F50E77CC1C9B3AD2@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: dhowells@redhat.com, Mark A Whiting <whitingm@opentext.com>,
    henrique.carvalho@suse.com, Enzo Matsumiya <ematsumiya@suse.de>,
    Steve French <smfrench@gmail.com>,
    Shyam Prasad <nspmangalore@gmail.com>,
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
Content-ID: <958478.1762852948.1@warthog.procyon.org.uk>
Date: Tue, 11 Nov 2025 09:22:28 +0000
Message-ID: <958479.1762852948@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Okay, the patch isn't good from a quick scan of it.

> +			if (folio_test_writeback(folio)) {
> +				/*
> +				 * For data-integrity syscalls (fsync(), msync()) we must wait for
> +				 * the I/O to complete on the page.
> +				 * For other cases (!sync), we can just skip this page, even if
> +				 * it's dirty.
> +				 */
> +				if (!sync) {
> +					stop = false;
> +					goto unlock_next;
> +				} else {
> +					folio_wait_writeback(folio);

You can't sleep here.  The RCU read lock is held.  There's no actual need to
sleep here anyway - you can just stop and leave the function (well, set
stop=true and break so that the accumulated batch is processed).

The way the code is meant to work is that cifs_write_back_from_locked_folio()
locks and waits for the first folio, then calls cifs_extend_writeback() to add
more folios to the writeout - if it doesn't need to wait for them.  You cannot
skip any folios as the set has to be contiguous.  If you skip one, you'll
corrupt the file.

Once a set of folios has been dispatched, cifs_writepages_begin() *should*
begin with the next folio that hasn't been sent - quite possibly one just
rejected by cifs_extend_writeback().  But at this point
cifs_write_back_from_locked_folio() will wait for it.

This should[*] work correctly, even in sync mode, because it should eventually
wait for any folio that's already undergoing writeback - though it might be
less efficient because if there are competing writebacks, they may end up
forcing each other to produce very small writes (there's no
writeback-vs-writeback locking apart from the individual folio locks).

[*] At least as far as the design goes; that's not to say there isn't a bug in
    the implementation.

That said, in sync mode, you might actually want cifs_extend_writeback() to
wait - but in that case, you have to drop the RCU read lock before you do the
wait and then reset the iteration correctly... and beware that doing that
might advance[**] the iterator state.

[**] It's possible that this is the actual cause of the bug - and that we're
     skipping the rejected folio because the xa_state isn't been correctly
     rewound.

David

