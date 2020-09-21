Return-Path: <SRS0=z3C/=C6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAD62C43463
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Sep 2020 08:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E46F2076E
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Sep 2020 08:19:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="eI4m92SP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgIUITl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Sep 2020 04:19:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:49104 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726359AbgIUITl (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 21 Sep 2020 04:19:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1600676380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cBAdTySspyZxCnkIrFRLo4wHNAC9AkNCvlQVjmozWPg=;
        b=eI4m92SPj7kJlBT2dxODubtwsF0v20r6t9O6TP8OnThBLbvFGGYBdOv3Qetlwt1O0umcJS
        vJD7nDIAL0tFwyQrY8hXS9dpRAQbLP7wFLvnmg7ODDTjR8i7t5HxcQK0a7RWtnlF3pLlgr
        IZBh5Yb5Xhg/eF8rW5wiSHxAhF14KzM=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 072EDAF45;
        Mon, 21 Sep 2020 08:20:16 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com
Subject: Re: [PATCH][SMB3] mount.cifs: use SUDO_UID env variable for cruid
In-Reply-To: <CANT5p=rKKZeS+HqonXQF4eaKFTod0rhb56GM4dXkYKhCcDhftw@mail.gmail.com>
References: <CANT5p=oiTY63d5yVyywiTrCqpAmvaugMVVpQRV7RT7ZA9HU2+Q@mail.gmail.com>
 <87r1r2ugzw.fsf@suse.com>
 <CANT5p=qV6BWojwBET+kYUwJf7tQDFoRtUb8O+pWHrqWMw5e5LQ@mail.gmail.com>
 <87wo0slr0c.fsf@suse.com>
 <CANT5p=rarYr0bErP77GF5QOu8=xx7Ovfy2dWdUNxnOTGkLXMKQ@mail.gmail.com>
 <87o8m4lnig.fsf@suse.com>
 <CANT5p=rKKZeS+HqonXQF4eaKFTod0rhb56GM4dXkYKhCcDhftw@mail.gmail.com>
Date:   Mon, 21 Sep 2020 10:19:39 +0200
Message-ID: <87lfh3lexw.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Thanks Shyam, looks good to me :)

Shyam Prasad N <nspmangalore@gmail.com> writes:
> Here's the updated patch.

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, DE
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)
