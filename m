Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9E5C433E0
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Feb 2021 09:59:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F07664E2B
	for <linux-cifs@archiver.kernel.org>; Sun,  7 Feb 2021 09:59:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhBGJ7Y (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 7 Feb 2021 04:59:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25876 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229445AbhBGJ7W (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 7 Feb 2021 04:59:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612691876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nb463ar027tgXHewGatt6ByNt8vkBXPEnIGuv2d2YiI=;
        b=b25GQXQyYoYqyZzqh9jaJlCinE76n6/GSOBTb2iGlgCdIU42L7MN8MKSAMMTEs5DVcvaSk
        xjDqG/PVdfpd09vaUatdTc42Kde0GmnpTWVPNG+gJipRepWtevgDRMcZSPgzKg4WaVg9ut
        y6E6q4hY73hTgvN0YMBO/b/9YYCfH1A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-qm2LGXD_N1izJYfSh6wp3w-1; Sun, 07 Feb 2021 04:57:54 -0500
X-MC-Unique: qm2LGXD_N1izJYfSh6wp3w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7EC01005501;
        Sun,  7 Feb 2021 09:57:52 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-115-23.rdu2.redhat.com [10.10.115.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB8EE1A873;
        Sun,  7 Feb 2021 09:57:51 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <87eehwnn2c.fsf@suse.com>
References: <87eehwnn2c.fsf@suse.com> <CAH2r5ms9dJ3RW=_+c0HApLyUC=LD5ACp_nhE2jJQuS-121kV=w@mail.gmail.com>
To:     =?us-ascii?Q?=3D=3Futf-8=3FQ=3FAur=3DC3=3DA9lien=3F=3D?= Aptel 
        <aaptel@suse.com>
Cc:     dhowells@redhat.com, Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] cifs: use discard iterator to discard unneeded network data more efficiently
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date:   Sun, 07 Feb 2021 09:57:51 +0000
Message-ID: <2689081.1612691871@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:

> > +{
> > +	struct msghdr smb_msg;
> > +
> > +	iov_iter_discard(&smb_msg.msg_iter, READ, to_read);
> > +
> > +	return cifs_readv_from_socket(server, &smb_msg);
> > +}
> > +
>=20
> Shouldn't smb_msg be initialized to zeroes? Looking around this needs to
> be done for cifs_read_from_socket() and cifs_read_page_from_socket() too.

Yeah - I think you're right.  I didn't manage to finish making the changes,
so what I gave to Steve wasn't tested.

David

