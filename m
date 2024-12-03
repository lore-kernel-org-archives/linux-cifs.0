Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFC01E32BE
	for <linux-cifs@vger.kernel.org>; Tue,  3 Dec 2024 11:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733224497; cv=none; b=GfCWOUefUE/C/HxdyyXzJoo+yNg5R1ht2Yp6GkE/wCmmk57cldLTDAw9sBRgWQFMNok6TJP6HdhL3PfY8AtSOvsuGgLaJz4Hn9PJbkazEaM2Dv6U3NNh7n0UvR3bR4C8ob4L6MWSxG5wupA5s5aFiYs7rNz9qi1iCsH1x01zACg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733224497; c=relaxed/simple;
	bh=2w8+rBgGUNncY1H9Q7rxGlY54qixjM2NjCAGYsglTxc=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=mmRbt00EryI513iniTN8bOQ661nYVdKPJ12GE2lhi++AfiEGG7qPIysY2+ezHh+a9crMIba5izaKzPbFNg7b3VKLFJCA20G208srcsKZ3AyHiN0r/D/86e22LJwynKayieFzJSzmiLjr3aJggXUswnT0k/Fii0lJXJs5NcqigjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sq66SitK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sq66SitK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733224494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RPIot6O9qk+YnC9bxPg9BIGVu8Y8b1+py2TT1hzR8XA=;
	b=Sq66SitKhRnIUAZ+fUfulVPjQPWor5lcRsUNe3lQz/vIa5Sm57scrEIYXRXECWIKCWFpYH
	g/J9lU/Kp9fYcdKaauB8Y/2HFRxg3QDVMTUOnbU8DCuFSRHPwtaW4FxUiriwymGzN747LI
	dN/n4P6poNAN7zUzBhwwUCUWQuAAGK0=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-624-WyGB666rNnyiAPq1PLXDJA-1; Tue,
 03 Dec 2024 06:14:51 -0500
X-MC-Unique: WyGB666rNnyiAPq1PLXDJA-1
X-Mimecast-MFC-AGG-ID: WyGB666rNnyiAPq1PLXDJA
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0E4671955EA7;
	Tue,  3 Dec 2024 11:14:50 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.48])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 44E751956054;
	Tue,  3 Dec 2024 11:14:48 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <505338.1733181074@warthog.procyon.org.uk>
References: <505338.1733181074@warthog.procyon.org.uk> <CANT5p=pUGYwswgXM-pniMjEWwbLK0cKXPBOJB9cG_cOrkBwQhg@mail.gmail.com> <CANT5p=qBwjBm-D8soFVVtswGEfmMtQXVW83=TNfUtvyHeFQZBA@mail.gmail.com>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
    CIFS <linux-cifs@vger.kernel.org>
Subject: Re: null-ptr deref found in netfs code
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <526705.1733224486.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Dec 2024 11:14:46 +0000
Message-ID: <526707.1733224486@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Okay, I think I see the problem.

Looking at the following extraction from the trace:

> netfs_rreq_ref: R=3D0000290e NEW         r=3D1
> netfs_read: R=3D0000290e READAHEAD c=3D00000000 ni=3D0 s=3D85e00000 l=3D=
800000 sz=3D280000000
> netfs_folio: i=3Df1c2900000000000 ix=3D85e00-85fff read
> netfs_folio: i=3Df1c2900000000000 ix=3D86000-861ff read
> netfs_folio: i=3Df1c2900000000000 ix=3D86200-863ff read
> netfs_folio: i=3Df1c2900000000000 ix=3D86400-865ff read

We're requesting reads of four folios, each consisting of 512 pages for a
total of 8MiB.

> netfs_sreq: R=3D0000290e[1] DOWN SUBMT f=3D02 s=3D85e00000 0/100000 e=3D=
0
> netfs_sreq: R=3D0000290e[2] DOWN SUBMT f=3D02 s=3D85f00000 0/100000 e=3D=
0
> netfs_sreq: R=3D0000290e[3] DOWN SUBMT f=3D02 s=3D86000000 0/100000 e=3D=
0
> netfs_sreq: R=3D0000290e[4] DOWN SUBMT f=3D02 s=3D86100000 0/100000 e=3D=
0
> netfs_sreq: R=3D0000290e[5] DOWN SUBMT f=3D02 s=3D86200000 0/100000 e=3D=
0
> netfs_sreq: R=3D0000290e[6] DOWN SUBMT f=3D02 s=3D86300000 0/100000 e=3D=
0
> netfs_sreq: R=3D0000290e[7] DOWN SUBMT f=3D02 s=3D86400000 0/100000 e=3D=
0
> netfs_sreq: R=3D0000290e[8] DOWN SUBMT f=3D02 s=3D86500000 0/100000 e=3D=
0

That got broken down into 8 submissions, each for a 1MiB slice.

> netfs_sreq: R=3D0000290e[1] DOWN IO    f=3D02 s=3D85e00000 100000/100000=
 e=3D0
> netfs_progress: R=3D0000290e[01] s=3D85e00000 ct=3D0/100000 pa=3D100000/=
100000 sl=3D0
> netfs_donate: R=3D0000290e[01] -> [02] to-next am=3D100000

Subrequest 1 completed, but wasn't large enough to cover a whole folio, so=
 it
donated its coverage forwards to subreq 2.

> netfs_sreq: R=3D0000290e[6] DOWN IO    f=3D02 s=3D86300000 100000/100000=
 e=3D0
> netfs_progress: R=3D0000290e[06] s=3D86300000 ct=3D0/100000 pa=3D100000/=
100000 sl=3D2
> netfs_donate: R=3D0000290e[06] -> [05] tail-to-prev am=3D100000

Subrequest 6 completed, but wasn't large enough to cover a whole folio, so=
 it
donated its coverage backwards to subreq 5.

> netfs_sreq: R=3D0000290e[2] DOWN IO    f=3D02 s=3D85f00000 100000/100000=
 e=3D0
> netfs_progress: R=3D0000290e[02] s=3D85e00000 ct=3D0/200000 pa=3D200000/=
200000 sl=3D0
> netfs_folio: i=3Df1c2900000000000 ix=3D85e00-85fff read-done
> netfs_folio: i=3Df1c2900000000000 ix=3D85e00-85fff read-unlock

Subreq 2 completed, and with the donation from subreq 1, had sufficient to
unlock the first folio.

> netfs_sreq: R=3D0000290e[5] DOWN IO    f=3D02 s=3D86200000 100000/100000=
 e=3D0
> netfs_progress: R=3D0000290e[05] s=3D86200000 ct=3D0/200000 pa=3D200000/=
200000 sl=3D2
> netfs_folio: i=3Df1c2900000000000 ix=3D86200-863ff read-done
> netfs_folio: i=3Df1c2900000000000 ix=3D86200-863ff read-unlock

Subreq 5 completed, and with the donation from subreq 6, had sufficient to
unlock the third folio.

> netfs_sreq: R=3D0000290e[3] DOWN IO    f=3D02 s=3D86000000 100000/100000=
 e=3D0
> netfs_progress: R=3D0000290e[03] s=3D86000000 ct=3D0/100000 pa=3D100000/=
100000 sl=3D1
> netfs_donate: R=3D0000290e[03] -> [04] to-next am=3D100000

Subrequest 3 completed, but wasn't large enough to cover a whole folio, so=
 it
donated its coverage forwards to subreq 4.  So far, so good.

> netfs_sreq: R=3D0000290e[7] DOWN IO    f=3D02 s=3D86400000 100000/100000=
 e=3D0
> netfs_progress: R=3D0000290e[07] s=3D86400000 ct=3D0/100000 pa=3D100000/=
100000 sl=3D3
> netfs_donate: R=3D0000290e[07] -> [04] to-prev am=3D0

Subreq 7 completed, but wasn't large enough to cover a whole folio, so it
donated its coverage backwards to subreq 4.  This is a bug as subreq 7 is =
not
contiguous with subreq 4.  It should instead have donated forwards to subr=
eq
8.

> netfs_sreq: R=3D0000290e[4] DOWN IO    f=3D02 s=3D86100000 100000/100000=
 e=3D0
> netfs_sreq: R=3D0000290e[4] DOWN +DON  f=3D02 s=3D86000000 300000/300000=
 e=3D0
> netfs_progress: R=3D0000290e[04] s=3D86000000 ct=3D0/300000 pa=3D200000/=
300000 sl=3D1
> netfs_folio: i=3Df1c2900000000000 ix=3D86000-861ff read-done
> netfs_folio: i=3Df1c2900000000000 ix=3D86000-861ff read-unlock

Subreq 4 completed, and with the donation from subreq 2, had sufficient to
unlock the second folio.  However, it also has some excess from subreq 7 t=
hat
it can't do anything with - and this gets lost.

> netfs_sreq: R=3D0000290e[8] DOWN IO    f=3D02 s=3D86500000 100000/100000=
 e=3D0
> netfs_progress: R=3D0000290e[08] s=3D86500000 ct=3D0/100000 pa=3D100000/=
100000 sl=3D3
> netfs_donate: R=3D0000290e[08] -> [04] tail-to-prev am=3D100000

Here's a repeat of the bug: subreq 8 donates to subreq 4, but, again, is n=
ot
contiguous.  As these are happening concurrently, the other thread hasn't
delisted subreq 4 yet.

> netfs_sreq: R=3D0000290e[4] DOWN +DON  f=3D02 s=3D86000000 400000/400000=
 e=3D0
> netfs_progress: R=3D0000290e[04] s=3D86200000 ct=3D200000/400000 pa=3D20=
0000/200000 sl=3D2

The request screwed at this point: subreq 4 shows the extra stuff it has b=
een
donated, but it is unable to do anything with it.  There is no folio to
wrangle as the third slot (sl=3D2) in the queue has already been cleared.

(Note that this bug shouldn't happen with the patches currently on my
netfs-writeback branch as I got rid of the donation mechanism in preferenc=
e
for something simpler with single-threaded collection.)

David

