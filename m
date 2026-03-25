Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322513ACA4C
	for <linux-cifs@vger.kernel.org>; Wed, 25 Mar 2026 13:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774444832; cv=none; b=DoWj14SoXFOQHvMRA48korVk/A723klCexXMviFgXB9R7cW3rGj6ox3H6MV3nK72+y2Zfe5+oKSxdXRNvGDvoe1njW/Gk45D7uVwhqxfffKD+LQISCMD2CtZzFvK1kxmmD3pCiNOnS1d4a09Tvz8quRqoApJ1DViFpBS1jCE5fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774444832; c=relaxed/simple;
	bh=LIm0vx3ezpT40Nt6WIr3Wl5X6hPiUESn2FAwHMH30d4=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=CVSO8PeU/BNiqFUSd7vtwrsALMlq3aL4Lgcl1H9st0QZM+a+yscfKNnSkLjPMbt8LGfTH3rkzwx1hMY+OzuYbkAppYlul9wSCfBqCM6mEuxdZ62cgTTCIxCiKYpowIMpHe2bnDc0SiXgecMJKCYLXgnGLy8hI9MhKANWL2J5zN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BJfcGREo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BJfcGREo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774444830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FcixgmRff6ycuFp7NQcqQL9Fn67FcAa60NmIbJumNdA=;
	b=BJfcGREokRrega09OSz4Prm1qWiZ3my/4vtFxqHFLKKvqvr4JBiY/GLUVnVTKlcd1Bu1Eg
	giNn9JU/RFneQDgVyG0++EmvNVmXS6RN2i7spJzbAg8uLSiv6j4eqpooLfN0BdbMF3Hgr1
	lb17NW4xACEtalk8W3LPw0b9d0w/vno=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-60-Bmm2VqMrPdOG5cwt8fGRXA-1; Wed,
 25 Mar 2026 09:20:25 -0400
X-MC-Unique: Bmm2VqMrPdOG5cwt8fGRXA-1
X-Mimecast-MFC-AGG-ID: Bmm2VqMrPdOG5cwt8fGRXA_1774444824
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A164919146D6;
	Wed, 25 Mar 2026 13:20:17 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.33.121])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0CC8230002DA;
	Wed, 25 Mar 2026 13:20:15 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
cc: dhowells@redhat.com, Paulo Alcantara <pc@manguebit.org>,
    linux-cifs@vger.kernel.org
Subject: cifs_ses_add_channel() can race with itself
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <122436.1774444814.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Mar 2026 13:20:14 +0000
Message-ID: <122437.1774444814@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hi Steve,

Whilst running xfstests against cifs, I managed to encounter what I think =
must
be due to a race between cifs_ses_add_channel() and itself - presumably by
concurrent mount type things that share a session.

SO what I saw was this:

    BUG: kernel NULL pointer dereference, address: 0000000000000358
    ...
    RIP: 0010:cifs_alloc_hash+0x5/0xd0
    ...
    RSP: 0018:ffff88814eb4bdb0 EFLAGS: 00010246
    RAX: 0000000000000000 RBX: ffff888148804800 RCX: 0000000000000000
    RDX: 0000000000000000 RSI: 0000000000000358 RDI: ffffffff82c66915
    RBP: ffff88810ad52000 R08: 0000000000000000 R09: ffff88840fa1bea0
    R10: 0000000000000006 R11: 00000000000002eb R12: ffff8881488048a0
    R13: 000000000015681b R14: ffff888148786c00 R15: ffff888148804860
    FS:  0000000000000000(0000) GS:ffff88848be03000(0000) knlGS:0000000000=
000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 0000000000000358 CR3: 0000000002e3a002 CR4: 00000000001706f0
    Call Trace:
     <TASK>
     cifs_ses_add_channel+0x39b/0x530
     cifs_try_adding_channels+0x201/0x2e0
     mchan_mount_work_fn+0x1d/0x30
     process_one_work+0x189/0x2b0
     process_scheduled_works+0x3a/0x50
     worker_thread+0x13b/0x1d0

Now, the RIP location corresponds to the deref of *sdesc in cifs_alloc_has=
h(),
so sdesc (which is 0x358 in RSI) must be based on a NULL pointer.  Looking=
 at
cifs_ses_add_channel(), this corresponds to an inlined call to
smb3_crypto_shash_allocate().  0x358 matches server->secmech.aes_cmac if
server is NULL:

	(gdb) p &((struct TCP_Server_Info *)0)->secmech.aes_cmac
	$2 =3D (struct shash_desc **) 0x358

Looking further at cifs_ses_add_channel(), that means chan->server must be
NULL - but that would seem unlikely, given:

	chan_server =3D cifs_get_tcp_session(ctx, ses->server);

a few lines above:

	rc =3D smb3_crypto_shash_allocate(chan->server);

chan_server got checked for error, but not NULLness, though it doesn't loo=
k
like it could be NULL.

However, I note that there's no locking that spans the two lines.  The fir=
st
happens under ses->chan_lock and the second under ses->session_mutex, but
there's nothing to stop another cifs_ses_add_channel() jumping in in the
meantime and zapping chan->server as there's a gap, be it ever so small, w=
here
no lock is held.

Looking further up the stack, this is launched from mount into a workqueue=
, so
it's not necessarily inside of any of the mount locking either.  It would =
seem
that cifs_try_adding_channels() probably should use some locking, but does=
 not
seem to use anything authoritative.

Now this is a lot of surmisation.  It's the only time I've seen this in a =
lot
of running xfstests and things on cifs, so it's not especially reproducibl=
e,
unfortunately.

Let me know if you have a fix for this!

Thanks,
David

