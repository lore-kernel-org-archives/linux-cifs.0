Return-Path: <SRS0=z3C/=C6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 236D2C43463
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Sep 2020 04:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDB7220866
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Sep 2020 04:24:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vWqTVS5g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgIUEYA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Sep 2020 00:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbgIUEYA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Sep 2020 00:24:00 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1CCC061755
        for <linux-cifs@vger.kernel.org>; Sun, 20 Sep 2020 21:24:00 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id h9so1812893ybm.4
        for <linux-cifs@vger.kernel.org>; Sun, 20 Sep 2020 21:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NVzlegoq4hmNbGG6IV4Qk6S6qbnaIUr705f53A/65gA=;
        b=vWqTVS5gr9jZ5/b6IiDbzs7Xz8p/4yW9/fsKjUpOwfLCogKdylJqLkIbnAzM4u9Fi+
         BLemVbMyGe6nQGoTqCPcr4ZDgh2aFFS2yhryLGQEjoieJoF/BGWtjP/IJHjGQYcoCMXO
         be2NrBnua/kLZCrT7q6xZI86THhvgTW+p1vvpBp7NUgBBvmLFaweThKMlPN40f9tYiPB
         zKEJUlEqYOPb3ACV+f1yHfPzX4TsWp9eQdvT3oEO9LzIuXitczz1ArLm7LGjNBc/jDWb
         X8QSNGCMp0hNm1amof8wOz1gevaNIsiVMsNujLAyDdwPwAj+cZC5fodAAt2UE5xFtgpk
         U/fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NVzlegoq4hmNbGG6IV4Qk6S6qbnaIUr705f53A/65gA=;
        b=TzwwXweWgk+wl/l2t/qtBR5uoJ05tOmtegcYms5jgjNLzwa/wj+hsW5i55yhbDoNlR
         RDWKHSAcSfkNv2zpp0QEKyG/jyEuWC0+myJboC8uO7Bcml9zA/3Ahvox9F6LgSXpaiMt
         uLvsAP/r5fu4ZIpBt6VPiwutSGOifxDTAT+0yUPplMld2QmRoEQTugV9Z8cpa92sNzxD
         lmytHzI/uAWDnYfw5yQeJQeWYKv7QSvZ/MgBLw2t2BPIHfN6Z/qf/pO3/8TnKVsiy1Jw
         zK/Z+V1xEg7mDJX7RluO0jG/tz1jhNXOadSuiGEeq3H92IAtc67Aj46iXb2P5u+7kWH3
         wBfg==
X-Gm-Message-State: AOAM5316xaNMEqHq/+kYlkcw/k/sEARt5/e64bm2pEOpuYZSRrGTQSnG
        uqkuC82RPK6yXxDV8UipWMXf+adWbovSqZlC8uPid42nluuWMw==
X-Google-Smtp-Source: ABdhPJwqA4xWriCPzJJmn9fC0OlDa1LMMwhst7DDQnwFhAciDO0D2iUZ8AqC1wI0Z8W+IX73gucX2h0LWwrg13Qln0I=
X-Received: by 2002:a25:1405:: with SMTP id 5mr14050755ybu.97.1600662239400;
 Sun, 20 Sep 2020 21:23:59 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=qTXPkjqBuR9cvwQoRZFb72gY4M22tMG5Q_1XC9vvKZcg@mail.gmail.com>
 <87tuvwlpto.fsf@suse.com> <87r1r0lp9s.fsf@suse.com> <CAH2r5muiYZGr=1rZHobpKXAtG+OCDORZok_acOkL6TQssVrm3Q@mail.gmail.com>
In-Reply-To: <CAH2r5muiYZGr=1rZHobpKXAtG+OCDORZok_acOkL6TQssVrm3Q@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 21 Sep 2020 09:53:48 +0530
Message-ID: <CANT5p=ob6gSFkdy+k0Hera9mLQVhZ743RUiGk7gHbTGwuu7KEw@mail.gmail.com>
Subject: Re: mutiuser request_key in both ntlmssp and krb5
To:     Steve French <smfrench@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Sorry for the late reply on this. Was out for a few days.

> IIRC the keyring used is the session one, so each user gets a different k=
eyring.

Ah, I see. So I'm wondering how the multiuser mounts for ntlmssp work?
On each login, does the user have to populate the keyring with his/her
credentials?

> Remember that all code running in cifs.ko is always in the context of a
> process (or a kthread which is also using struct task). It's the process
> who does some syscall that calls cifs.ko. So within the kernel code you
> can always access the calling process task via the 'current' pointer.
>
> We use current_fsuid() to get the current uid.

Agreed for majority cases. But Steve makes a good point that this only
gets us the local uid/username.
However, the actual domain user name could be very different. For
example, local user user1 could be logged in as domain1\user1 or
domain2\user1. How do we handle this scenario?

I'm guessing (please correct me if I'm wrong here) that an user
session corresponds to only one of those two remote users
(domain1\user1 or domain2\user1). In that case, how do we get the
fully qualified name in the context of this session?

Regards,
Shyam

On Fri, Sep 18, 2020 at 1:12 AM Steve French <smfrench@gmail.com> wrote:
>
> In cases where we know the host name it makes sense to use that. But if t=
hey specify up address in unc name we will have to use that
>
> On Thu, Sep 17, 2020, 02:35 Aur=C3=A9lien Aptel <aaptel@suse.com> wrote:
>>
>> Aur=C3=A9lien Aptel <aaptel@suse.com> writes:
>> > Shyam Prasad N <nspmangalore@gmail.com> writes:
>> >> 1. For ntlmssp, I see that the credentials are stored in the keyring
>> >> with IPv4 or IPv6 address as the key. Suppose the mount was initially
>> >> done using hostname, and IP address changes (more likely in Azure
>> >> scenario), we may end up looking for credentials with the wrong key.
>> >
>> > Yes I thought the same thing.. I'm not sure why the decision to use IP
>> > was made.
>>
>> I suspect this code predates the existence of the in-kernel DNS
>> resolver. Just a guess.
>>
>> Cheers,
>> --
>> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
>> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
>> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg=
, DE
>> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)



--=20
-Shyam
