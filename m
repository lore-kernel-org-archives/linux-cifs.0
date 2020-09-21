Return-Path: <SRS0=z3C/=C6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FAEFC43463
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Sep 2020 09:49:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1D6921789
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Sep 2020 09:49:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ft5Vancq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgIUJty (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Sep 2020 05:49:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:57108 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbgIUJty (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 21 Sep 2020 05:49:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1600681793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FBm2H2GCFlplthkyhYpDb0vxg81ycvjt+IhwCnQrRj4=;
        b=ft5VancqcLvlhKwzI69fK+pStMD68sYlon4wQGRFmRVuEIGowzbZk9wZtbe2D5Yz4NSkfX
        gVRHYrqJy0s7HmY8lnSUlC68ybPpXavJNcP0YtYrfdfiSVzzYAdSZkuTjb2OdAUmueDZNW
        +LjfObroabWel3eSN6UxjX6tFwQ3WSg=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8920FAD83;
        Mon, 21 Sep 2020 09:50:29 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: mutiuser request_key in both ntlmssp and krb5
In-Reply-To: <87imc7lblm.fsf@suse.com>
References: <CANT5p=qTXPkjqBuR9cvwQoRZFb72gY4M22tMG5Q_1XC9vvKZcg@mail.gmail.com>
 <87tuvwlpto.fsf@suse.com> <87r1r0lp9s.fsf@suse.com>
 <CAH2r5muiYZGr=1rZHobpKXAtG+OCDORZok_acOkL6TQssVrm3Q@mail.gmail.com>
 <CANT5p=ob6gSFkdy+k0Hera9mLQVhZ743RUiGk7gHbTGwuu7KEw@mail.gmail.com>
 <87imc7lblm.fsf@suse.com>
Date:   Mon, 21 Sep 2020 11:49:52 +0200
Message-ID: <87ft7blarj.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Aur=C3=A9lien Aptel <aaptel@suse.com> writes:
>> Ah, I see. So I'm wondering how the multiuser mounts for ntlmssp work?
>> On each login, does the user have to populate the keyring with his/her
>> credentials?
>
> I think that was the idea yes, or maybe integrate with PAM somehow? But
> you'll have to do some archeological work with Jeff Layton to get to the
> bottom of this :)

If you were asking *how* can the user populate it at this moment, then
the answer is with the cifscreds program. But I don't know what was the
planned scenario for users (login once, then manually call cifscreds a
to login a 2nd time?)

https://github.com/piastry/cifs-utils/blob/master/cifscreds.c

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, DE
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)
