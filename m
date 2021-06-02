Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5E2EC4708F
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Jun 2021 18:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BB3A613AD
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Jun 2021 18:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbhFBS6R (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 2 Jun 2021 14:58:17 -0400
Received: from mail-lf1-f49.google.com ([209.85.167.49]:45620 "EHLO
        mail-lf1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229467AbhFBS6R (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 2 Jun 2021 14:58:17 -0400
Received: by mail-lf1-f49.google.com with SMTP id j10so4909728lfb.12
        for <linux-cifs@vger.kernel.org>; Wed, 02 Jun 2021 11:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0qmuboDmAxMcnj4Uo8kUasyStmmfA9XXGVw/XcdTeJA=;
        b=RiwAOq46u23hT87oIJ9HKBcpdPbjh52xo7niTODA2/ggZ5v48rZAfvN/1zvpJRsniZ
         J/4D4/H/kSR6iRts3t5LoozaU9fsoy7Sf4dkO7GxywKBj60s5+u9ZGSyvo8jIEIJH8DH
         X+S2pRD8QLK7aeePbsAO0S0i9oKAgJa2zbOOES7tsyUlfWsmS6Kr5H0yhmvUf2Zp/CUT
         TNh0u2+sDibD3hldA9Ff+quMZKPsXlrk8V2lWO3O3o5vk7lDLui9IFM8zlb07mxhf7wD
         D6Xle419krlLssBbyF/g3VL38u/v4N5Y4zdAGVnBNV4mL6g49F6Qg24ROorJ+6lMTXDR
         Cr8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0qmuboDmAxMcnj4Uo8kUasyStmmfA9XXGVw/XcdTeJA=;
        b=JWtFcFxgVO0gjLEvvPsyOJG26vSaC67jCVp8SgafYd3fdaPtSd7xz2zkly23oE3l2t
         +pUu1ZfzTtwoODBNfYPDLXh/uZvzGM3KdSixQOgxWLBap0OaJH0hPQkV4tuqHWgCj7PY
         p4QjeRTrjeUSiA6P1SZmkov7L9w9q8vbVmrq2RtLCRh56xPNjnITe6u9HT4PGlQ1bMuV
         axzXWX6hsEpYE2Zjmqq71erOMcsraHfLvsam8A6UTJ4diJXgrZZaL1Mg7rXbmLeqkdf+
         kXwDk/Tbu2oPaoBqkiDfUpnsLoPyrMTtTexzR+J8WjJOWTsplSa9/b6FOvcZ5yZkueRR
         cM9w==
X-Gm-Message-State: AOAM530tqi34YXcF8iVBO+ahQqhWZw37VCBi/EtY2YXG1yPCWG+0HR9E
        duHlx23mSUlsKYnmoqdKPWNt+aBk0aDAN0NOXRY=
X-Google-Smtp-Source: ABdhPJyElJ6IdzZGESAmhngX+PH2/TcftrI58LIX14MWG4yHENZ9LgGCvvLeqrasCKhR6w87mASotH8Jh21vL4s6evY=
X-Received: by 2002:a19:f611:: with SMTP id x17mr23811052lfe.313.1622660132800;
 Wed, 02 Jun 2021 11:55:32 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=oMLZei+OhXZ-8Hr2NCx=pRYWF1zQ0vRQ5D_NkvLGwJDg@mail.gmail.com>
 <874kegtg2o.fsf@suse.com>
In-Reply-To: <874kegtg2o.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 2 Jun 2021 13:55:21 -0500
Message-ID: <CAH2r5muWPj4rSFWTi4vuWQZWsJooyV-Yu3XZhEcXjY6sPH+Ltg@mail.gmail.com>
Subject: Re: Multichannel patches
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looking through the PR - agree with Aurelien's comments (mostly minor)

On Wed, Jun 2, 2021 at 10:57 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
> Hi Shyam,
>
> We've already discussed how to go about it so your changes LGTM.
> I've added some minor comments on your github pull request.
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
> > P.S. There is a logic in cifs_reconnect to switch between the targets
> > for the server. I don't think these changes will break the DFS
> > scenario. The code will likely take effect only for when the primary
> > channel reconnects (as DFS server entries are cached with super block
> > as the key). Perhaps more changes will be needed there to also switch
> > between the targets for individual channels (maybe use superblock +
> > channel num as the key for caching entries?). Folks with better
> > knowledge than me with this code may want to check on this?
>
> You need to talk with Paulo for this. He has just sent a rewrite of the
> cache yday.
>
> > @Steve French It'll be good to let a few cycles of buildbot to run
> > with this code, before submitting to upstream. I have run a bunch of
> > tests with this. However, more soak time will be safer.
>
> We need more tests on the buildbot so if you have things for mchan we
> can run on it please add it there.
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>


--=20
Thanks,

Steve
