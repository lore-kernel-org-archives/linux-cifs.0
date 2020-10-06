Return-Path: <SRS0=Y/WD=DN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D354FC41604
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Oct 2020 10:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71A9420757
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Oct 2020 10:56:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="HvU8Q+w1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbgJFK4Y (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Oct 2020 06:56:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:57134 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbgJFK4Y (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 6 Oct 2020 06:56:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1601981799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B2wHLsXM0PH2VIZy6Vg9De35TcZ1NeUcfN2v3FpCAto=;
        b=HvU8Q+w1qZCzW/SSjVqHjOQBaSvYmBZTduVOS8vMwOqicL5merPtUYN5qd+QQIEy94ybKF
        3LpPmeaKgiMWGrnDJvGV5SAsKFq605kHp7qYivMZOg+fV6m2pMnjXX9Evi6bHn8o2mubm0
        vNVSPSiZZTE/GtdWKJbfBDNr2AnTPK4=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 98B46B30C;
        Tue,  6 Oct 2020 10:56:39 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: handle -EINTR in cifs_setattr
In-Reply-To: <20201006052643.6298-1-lsahlber@redhat.com>
References: <20201006052643.6298-1-lsahlber@redhat.com>
Date:   Tue, 06 Oct 2020 12:56:38 +0200
Message-ID: <87ft6ripw9.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Ronnie,

Ronnie Sahlberg <lsahlber@redhat.com> writes:
> Some calls that set attributes, like utimensat(), are not supposed to ret=
urn
> -EINTR and thus do not have handlers for this in glibc which causes us
> to leak -EINTR to the applications which are also unprepared to handle it.

EINTR happens when the task receives a signal right?

https://www.gnu.org/software/libc/manual/html_node/Interrupted-Primitives.h=
tml

Given what you said and what the glibc doc reads it seems like the fix
should go in glibc. Otherwise we need to care about every single syscall.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, DE
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)
