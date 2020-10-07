Return-Path: <SRS0=bDWC=DO=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B0C3C4363C
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Oct 2020 10:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E7622080A
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Oct 2020 10:45:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kurzvFDO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgJGKpm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Oct 2020 06:45:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:35316 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbgJGKpm (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 7 Oct 2020 06:45:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1602067541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rytuVFf34C/HUOxZNFl7qzkRLkeD/jgOPdwjZkmOHMk=;
        b=kurzvFDOrHI4b65nYMMfyJ0lkHavO2dArTHG7nw56QrqDm/SmbznA5bMP3ae+qWXeUEkod
        A3IuXNl4HRx7H9iicr58AijiCF+CQ9xpTnJHIyk4b9JmeDRfivDXboBCa/L4Mz/3xZ86ag
        RTjRvu1pPQBKf2OzzW+kzqHDdWVZffg=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 81A2BAD5F;
        Wed,  7 Oct 2020 10:45:41 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: handle -EINTR in cifs_setattr
In-Reply-To: <CAN05THRzdzc7Xy0fi2pF4jEs=QfsS-GSG_LEz_YwbexesRHvhw@mail.gmail.com>
References: <20201006052643.6298-1-lsahlber@redhat.com>
 <87ft6ripw9.fsf@suse.com>
 <CAN05THRzdzc7Xy0fi2pF4jEs=QfsS-GSG_LEz_YwbexesRHvhw@mail.gmail.com>
Date:   Wed, 07 Oct 2020 12:45:40 +0200
Message-ID: <87d01uiaaz.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ronnie sahlberg <ronniesahlberg@gmail.com> writes:
> glibc have handling for EINTR in most places, but not in for example utim=
ensat()
> because this function is not supposed to be able to return this error.
> Similarly we have functions like chmod and chown that also come into cifs=
.ko
> via the same entrypoint: cifs_setattr()
> I think all of these "update inode data" are never supposed to be
> interruptible since
> they were classically just updating the in-memory inode and the thread
> would never hit d-state.

I see, thanks for the explanation.

> Anyway, for these functions EINTR is not a valid return code so I
> think we should take care to not
> return it. Even if we change glibc adn the very very thin wrapper for
> this functions there are applications
> that might call the systemcall directly or via a different c-library.

Should we use is_retryable_error() to check for the errcode?

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, DE
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)
