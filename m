Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53EE9C2BBCA
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 21:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 297502396D
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 21:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbgLGV1F (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Dec 2020 16:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgLGV1E (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Dec 2020 16:27:04 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE725C0619D2;
        Mon,  7 Dec 2020 13:23:52 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id j17so6097348ybt.9;
        Mon, 07 Dec 2020 13:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EJOHc17zvEobDOFxwlnd1L4iMrQot9jcPwqhnGntr9I=;
        b=PR89FjhyROMYrzNdU/CC1sy61GlJsq1xPP9zXtszWtlNZ1p9hqWSvP2SAeHJOYSl+r
         nrK2vOZakMjvi20D89GE3y+afmrxePMvpvVuVzav3DjsiGaClZ6l3yvxfuXm7SO3vq7m
         9PYtA7ZXzMj4Kn2AyiQIdC/rHf3Fnot0r9Ao05CEhVJneTKf8OxQsc7AXdyXdlCEfgiJ
         utkc38Yit/vo2z7dOgwMtN8EuNG2hfZPE4G4i3EJXcicSD1P53NayKTisC8ahbsqrxzw
         DhZw5pZLZxEgcqC5CTvR38f/EGBvBTC28qk8a4ro4Ld+r4+WCFDFWQJberhAK2FTaabZ
         e+Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EJOHc17zvEobDOFxwlnd1L4iMrQot9jcPwqhnGntr9I=;
        b=El6XLlwdlX+G7iQU9o5gc9wD4w1Am8LuIf1klHXjxiKpYojIQIDMe+4RZDQ0SS/jbw
         tHFP+dDir8zB4Tu9unGUisV+YEoW79vBJH/CQ3YJwSRCT4DY6irP+xUElS+IyATSpioX
         UID19Ou6nXTKj7nrwMEkgOh4JMBHuNvJrqCUanSY2eCrrkWf9BMzHgdMUvLQ9xL2Fp+j
         uT2n778dgdHpTEc2lh+XRldPXWlcS009osfe7vovCMnRad+iXkSZRuRQVZcZ4rE6c+Pm
         D7iOyejl53TfO4vKB/kcRS5WaLNyF2D9e56VJsg8GFBJ9jEfFc0RXki6jlQssttRjW0h
         vRHA==
X-Gm-Message-State: AOAM533FbuVHS8F+2TbMozVKRRuTq9dIGzQlHT9rQrU/jHbKnLW7GILu
        wrdtgKR69WcHthNV8VQq1NNuW3EYbQiYqhAepTfw56Sj
X-Google-Smtp-Source: ABdhPJx5qZ+rLue5yDZ0J7fW53DlyRNWKSX802X7XAN4N0j77LPTesms57jetylejWawrq8UlQ0Y7Omr67EaQhDYMHk=
X-Received: by 2002:a25:cad2:: with SMTP id a201mr25315070ybg.327.1607376232060;
 Mon, 07 Dec 2020 13:23:52 -0800 (PST)
MIME-Version: 1.0
References: <20201027204226.26906-1-pboris@amazon.com> <CAHhKpQ7v_nPwBx2czk7rVXK3ZrmsZrAkcxDFOgq0ABTOVc7iSA@mail.gmail.com>
 <CANT5p=q2YvkEOEa4bS=-nbPOc9Xwa=4gnc09csCcszMmMjYSPg@mail.gmail.com>
 <CAHhKpQ7PwgDysS3nUAA0ALLdMZqnzG6q6wL1tmn3aqOPwZbyyg@mail.gmail.com> <CAKywueSZ5bfOxXVH6dkpjDjDawo-JdHjoSdQBYqrhrg7Zoi=Bw@mail.gmail.com>
In-Reply-To: <CAKywueSZ5bfOxXVH6dkpjDjDawo-JdHjoSdQBYqrhrg7Zoi=Bw@mail.gmail.com>
From:   Boris Protopopov <boris.v.protopopov@gmail.com>
Date:   Mon, 7 Dec 2020 16:23:41 -0500
Message-ID: <CAHhKpQ7GJK8HMf31Lri8z4khqJtu=nm79Q_A5yUS_5iDFmVj7w@mail.gmail.com>
Subject: Re: [PATCH] Add support for getting and setting SACLs
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        Boris Protopopov <pboris@amazon.com>,
        Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

HI, Pavel,

yes, thanks for the pointer, will include in the future.

Boris.

On Mon, Dec 7, 2020 at 2:05 PM Pavel Shilovsky <piastryyy@gmail.com> wrote:
>
> Hi Boris,
>
> Are you talking about this patch "[PATCH] Extend cifs acl utilities to
> handle SACLs"?
>
> Just for the future, I am trying to monitor the samba-dev mailing list
> but if you would like to get the fastest response to your patches then
> please include me directly or at least the linux-cifs mailing list.
>
> I stage pending patches in the "next" branch on my github tree, so,
> will include the one above.
>
> https://github.com/piastry/cifs-utils/commits/next
>
> --
> Best regards,
> Pavel Shilovsky
>
> =D0=BF=D0=BD, 7 =D0=B4=D0=B5=D0=BA. 2020 =D0=B3. =D0=B2 07:28, Boris Prot=
opopov <boris.v.protopopov@gmail.com>:
> >
> > Hello, Shyam,
> >
> > sorry for the delayed reply and thanks for looking at this patch. Yes,
> > the testing was done using the extended versions of
> > getcifsacl/setcifsacl (added setting owner and SACL support), the
> > patch for that posted recently via samba-technical (message ID
> > <20201120214918.12517-1-pboris@amazon.com>). I have tested
> > setting/getting the owner, DACL, and SACL, for all the DACL/SACL flags
> > (-a, -D, -M, -S), SACL type SYSTEM_AUDIT. This testing was done
> > against 5.10.0-rc1 and 4.14.203 (the latter required porting the
> > user-space patch). I believe this testing has fully exercised the code
> > changes in question.
> >
> > I will look at contributing to the fsxtesting-cifs code, but I think
> > the setcifsacl/getcifsact patch that enables easy access to the
> > descriptor components is a pre-requisite for such contributions.
> >
> > Thanks!
> >
> >
