Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BA127F4F5
	for <linux-cifs@vger.kernel.org>; Mon, 24 Nov 2025 14:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763995033; cv=none; b=nQuyBK6BsVqoAVMNObKlqgEbpbGOCdH83/JUM71hemmzKVRGm07H1wfEmJARzGkk/9o5HFpglYxeGicYiHTe0RW1K4XkQh/TebHefcE07thU8Lofionx0dymcmRBPqz44uZiJXZuB66B60iOIyWd5MTsPbBM2v+lLTmoOUcP2BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763995033; c=relaxed/simple;
	bh=iVf1LZSiP/x1+YSHnYtRxBSi0Ghmz2g7mkpEjBD1v9w=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=TYFUs4EPy7Obzd6NDB6ppSH7zFpdwepACRkWTbT4lRZLtW+aIPqj5QWaadZP45WyEMLW1ypdaddvUQGNYNN7yt0s7kQkaItL6Gq37RSJH3NUMaNtHzVo7ROOMEgaOEzCpvkek5HMYMwDvVfpVVf2MzbOdQSGD0nRs3SSdmq7ukE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c2wMEp9T; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c2wMEp9T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763995030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EVNuTfX77TlGRdgoPmRedepMffr5gTRtJAUf4NLa7B8=;
	b=c2wMEp9TLsFfwleOscEVIuzoKTHZ5A1Fcl9W6uY5D6mD5KCY6WkzYgjrThXfGD8jcjNuqC
	ryyDN0xJXuS6hfguVw6fgtplMEorD/k84rl+fmu2WdZj9X30iL0Tx9ui3b3tpQ4T3/kSBg
	eSOFxQHy9s5dle/WImgKJVZCh9/t4eg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-227-BjkUBms9NXOyqDNHpJ2Pew-1; Mon,
 24 Nov 2025 09:37:03 -0500
X-MC-Unique: BjkUBms9NXOyqDNHpJ2Pew-1
X-Mimecast-MFC-AGG-ID: BjkUBms9NXOyqDNHpJ2Pew_1763995022
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 24D101800561;
	Mon, 24 Nov 2025 14:37:02 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.14])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E980A18004A3;
	Mon, 24 Nov 2025 14:36:59 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <7b897d50-f637-4f96-ba64-26920e314739@samba.org>
References: <7b897d50-f637-4f96-ba64-26920e314739@samba.org> <20251124124251.3565566-1-dhowells@redhat.com> <20251124124251.3565566-8-dhowells@redhat.com>
To: Stefan Metzmacher <metze@samba.org>
Cc: dhowells@redhat.com, Steve French <sfrench@samba.org>,
    Paulo Alcantara <pc@manguebit.org>,
    Shyam Prasad N <sprasad@microsoft.com>, linux-cifs@vger.kernel.org,
    netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
    linux-kernel@vger.kernel.org, Tom Talpey <tom@talpey.com>
Subject: Re: [PATCH v4 07/11] cifs: Clean up some places where an extra kvec[] was required for rfc1002
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3635950.1763995018.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 24 Nov 2025 14:36:58 +0000
Message-ID: <3635951.1763995018@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Hi Stefan,

Stefan Metzmacher <metze@samba.org> wrote:

> I had to squash this into the patch
> =

> I'm using smatch when building and got the following error
> with this change:
> =

>     client/transport.c:1073 compound_send_recv() error: we previously as=
sumed 'resp_iov' could be null (see line 1051)
> ...
>  	if ((ses->ses_status =3D=3D SES_NEW) || (optype & CIFS_NEG_OP) || (opt=
ype & CIFS_SESS_OP)) {

In this case smatch is wrong, though it can't work this out as the context
spans more than one file.  This clause applies only to certain operations
(such as session setup and negotiate) that will always have a response buf=
fer.
But I've no objection to adding this warning to splat the warning.

> > +		if (resp_iov) {
> =

> Is it really possible that resp_iov is NULL here?
> =

> I guess it is for things with CIFS_NO_RSP_BUF, correct?

It probably can't be NULL; even those things that provide CIFS_NO_RSP_BUF =
seem
to pass a resp_iov, though they tend not to actually initialise it.
Hopefully, this will go away in future and stuff will be attached to the
smb_message struct which will be allocated and passed down from the likes =
of
smb2pdu.c or cifssmb.c to transport.c.

David

