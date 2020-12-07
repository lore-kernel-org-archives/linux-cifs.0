Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE02BC4361B
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 19:06:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A765E238E3
	for <linux-cifs@archiver.kernel.org>; Mon,  7 Dec 2020 19:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgLGTFs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 7 Dec 2020 14:05:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgLGTFr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 7 Dec 2020 14:05:47 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6260CC061793;
        Mon,  7 Dec 2020 11:05:07 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id g20so21103825ejb.1;
        Mon, 07 Dec 2020 11:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CnTU61U0VfmH5d7Y0floY0nX86RrCNSa09zdCXYBzXk=;
        b=PFOwHotdXDiwAsjMXr+a10ZmP59ofuYod/RNnamWO8iVNjFwnVmSrBeG9mivlKWtXo
         MxA353m/lANrFXRl33HgKXA3om9hrLWdFJcMPBVMbJEFoKdxhmPDDFFcEjntDbmqswMy
         MDSx/3CvEjXGej5Zyyfe0wiLu2GIymcWv8D5LEzfYycNIAJO0UoY1tqaUyVsQaxFES3q
         C0c8tjA4yWs6XARBOTViv+EWIO/z5Usk2KE8/ETnT5IQzd7+w+Iov3AA07Lga40igwz8
         G7QHvJjL5DGyOnK2jPCIBcOdbFMNEbeT7/7iHyFdmK/UypiGDPxgW3N3AsKG9+8yB5R8
         dYuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CnTU61U0VfmH5d7Y0floY0nX86RrCNSa09zdCXYBzXk=;
        b=B5e/yH2q+xCFHXTw4WJRvSTv/MCIRIW8eU9zlYDeZ7iN29vnXYJrzyXnXlUX8eScPq
         SSmOR/9KrdNYr0QIsNV5Y7V7poqOHDl8Q/VjoHqL7l9GkjXkm3pmxJF09J83jWV4FYVi
         BnExvn0y7M+aUruBMdHb8ecpEuvch0mbtZRy7G5MJE6tEq4kwRtT+8bXZaEFDkejyQY7
         V7ntmbrfdXBMdvIHyFQuTJnXYuYYJmJhfOCaUjSesW3l4QzL385+mCi+o5+DoKDiYoPA
         wS8k8N/hbbm1CmzLRVI7ho5DMvILKEzoVydqsD7kpL7Xr5boQ0x4BhmqfVdDSr7NeH3Q
         C+Jg==
X-Gm-Message-State: AOAM530SXLMB8noTMnV5KD8sYrwmcxHVNfXV3moH2R8zXtreUZ0xcl06
        vSnW+BKxCk3gJB7wk5HtKYct5olo1NNxJ2St+g==
X-Google-Smtp-Source: ABdhPJyeboDPaJ6kDWKnmuQSQ9Jl9RbHTtINLsCaQptKdeEl1Jt00gyRZ1hcGoL18y9HiNQp4hDD7Twv7QOz1TxqwLw=
X-Received: by 2002:a17:906:604e:: with SMTP id p14mr20917499ejj.515.1607367905955;
 Mon, 07 Dec 2020 11:05:05 -0800 (PST)
MIME-Version: 1.0
References: <20201027204226.26906-1-pboris@amazon.com> <CAHhKpQ7v_nPwBx2czk7rVXK3ZrmsZrAkcxDFOgq0ABTOVc7iSA@mail.gmail.com>
 <CANT5p=q2YvkEOEa4bS=-nbPOc9Xwa=4gnc09csCcszMmMjYSPg@mail.gmail.com> <CAHhKpQ7PwgDysS3nUAA0ALLdMZqnzG6q6wL1tmn3aqOPwZbyyg@mail.gmail.com>
In-Reply-To: <CAHhKpQ7PwgDysS3nUAA0ALLdMZqnzG6q6wL1tmn3aqOPwZbyyg@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 7 Dec 2020 11:04:54 -0800
Message-ID: <CAKywueSZ5bfOxXVH6dkpjDjDawo-JdHjoSdQBYqrhrg7Zoi=Bw@mail.gmail.com>
Subject: Re: [PATCH] Add support for getting and setting SACLs
To:     Boris Protopopov <boris.v.protopopov@gmail.com>
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

Hi Boris,

Are you talking about this patch "[PATCH] Extend cifs acl utilities to
handle SACLs"?

Just for the future, I am trying to monitor the samba-dev mailing list
but if you would like to get the fastest response to your patches then
please include me directly or at least the linux-cifs mailing list.

I stage pending patches in the "next" branch on my github tree, so,
will include the one above.

https://github.com/piastry/cifs-utils/commits/next

--
Best regards,
Pavel Shilovsky

=D0=BF=D0=BD, 7 =D0=B4=D0=B5=D0=BA. 2020 =D0=B3. =D0=B2 07:28, Boris Protop=
opov <boris.v.protopopov@gmail.com>:
>
> Hello, Shyam,
>
> sorry for the delayed reply and thanks for looking at this patch. Yes,
> the testing was done using the extended versions of
> getcifsacl/setcifsacl (added setting owner and SACL support), the
> patch for that posted recently via samba-technical (message ID
> <20201120214918.12517-1-pboris@amazon.com>). I have tested
> setting/getting the owner, DACL, and SACL, for all the DACL/SACL flags
> (-a, -D, -M, -S), SACL type SYSTEM_AUDIT. This testing was done
> against 5.10.0-rc1 and 4.14.203 (the latter required porting the
> user-space patch). I believe this testing has fully exercised the code
> changes in question.
>
> I will look at contributing to the fsxtesting-cifs code, but I think
> the setcifsacl/getcifsact patch that enables easy access to the
> descriptor components is a pre-requisite for such contributions.
>
> Thanks!
>
>
> On Wed, Dec 2, 2020 at 5:43 AM Shyam Prasad N <nspmangalore@gmail.com> wr=
ote:
> >
> > Hi Boris,
> >
> > At a high level, the changes look good to me. Will go through the
> > changes in more detail tomorrow morning.
> >
> > On a related note, we may need more test coverage in this area.
> > Can you please share your testing output against your changes?
> > Or even better, if you can contribute some xfstests for this use case:
> > https://wiki.samba.org/index.php/Xfstesting-cifs
> >
> > Regards,
> > Shyam
> >
> > On Wed, Dec 2, 2020 at 12:24 AM Boris Protopopov
> > <boris.v.protopopov@gmail.com> wrote:
> > >
> > > Hello,
> > > I am checking in to see if anyone had a chance to take a look at this
> > > patch. I would appreciate any feedback.
> > > Thanks!
> > >
> > > On Tue, Oct 27, 2020 at 5:01 PM Boris Protopopov via samba-technical
> > > <samba-technical@lists.samba.org> wrote:
> > > >
> > > > Add SYSTEM_SECURITY access flag and use with smb2 when opening
> > > > files for getting/setting SACLs. Add "system.cifs_ntsd_full"
> > > > extended attribute to allow user-space access to the functionality.
> > > > Avoid multiple server calls when setting owner, DACL, and SACL.
> > > >
> > > > Signed-off-by: Boris Protopopov <pboris@amazon.com>
> > > > ---
> > > ...
> >
> >
> >
> > --
> > -Shyam
