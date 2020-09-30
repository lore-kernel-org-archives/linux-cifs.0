Return-Path: <SRS0=H1OG=DH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27BBEC4727E
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Sep 2020 15:18:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFBC92071E
	for <linux-cifs@archiver.kernel.org>; Wed, 30 Sep 2020 15:18:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NUhID/aL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgI3PSR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 30 Sep 2020 11:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgI3PSR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 30 Sep 2020 11:18:17 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5AA5C061755
        for <linux-cifs@vger.kernel.org>; Wed, 30 Sep 2020 08:18:15 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id j76so1568790ybg.3
        for <linux-cifs@vger.kernel.org>; Wed, 30 Sep 2020 08:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dW+fZnTZ/PLdwnQ0b/S35apHrtG7BTASnfjoQCSkGJo=;
        b=NUhID/aLlrIMdmd94L5wT6v//QQLh0lqH6Lp0ANgjSx32eQx51t1O76AGO8kne/sw9
         n2K8mj8I+z7QZdjug39NHsGVAJDLZ9DqW+01/4j7F2b4PSPdmf63rVt86WdanEPkJ9Mj
         cjkTHtUW/fP6N4dvHU7oVgPfdUCEULavNyoCqd2MvDvnw6aP57ZeFHzZHbP0p9C3QCZI
         zjj2q4k7e8iugqh9L9tnL/BrSoL8HI8tg5cb7ubRuAbuog6IoXF+kwBU/tqP7ezvvraQ
         veaiU5NjqQpKSIrlG7K1VX76+fQ26P+2ZHfbvQ3E0ve8XbU67BcoNA2d5ULu6wyNiggZ
         Wasw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dW+fZnTZ/PLdwnQ0b/S35apHrtG7BTASnfjoQCSkGJo=;
        b=Ge8LWHRCthZ2aHgVWJ1MUTqXVCN85oAwkr8JCRoGYVBV7yCEhVfdFIQn4LGTWm3pby
         qEc6C5FqoZgOyudw7rUR2glg5juVZeqA8I7e2Zgf/8/Xvk6nds1tlv0rzaHJzkGIPIdr
         mKwIw4xpJOz5wWjdOBvrizgQnsJyDN0rE9w6w/y8dZeHFDwec+aXh4h17+VreNhfCWt+
         la3LSE0OMV3Mom22/We3OjNL5bH3myknSnoVOx2KEMThDAFb2vAhYnTTCQOKV25UevAn
         QRz+A2IrHy9XC86BSY1jSXbsu8Eou+ZHVZG5/Br7kEceZXAjnGP8AJUp3YM0imOVdPf/
         fGHA==
X-Gm-Message-State: AOAM530nR4868I1CrmRcgFw92xQk4BVf9QRanHvcmlW1kzVSoGk934YE
        th7Rx6i4ook4PbWSVrg6GqVvuo31ZUTyOYTt7og=
X-Google-Smtp-Source: ABdhPJyRAkFoPwMCJSDGiyVl/UtkpzYX2B37b0xyVeqSj4coouhc7G9ATV56+gPCjssf5J1oLo6/GhzTEUS6WlxGH7M=
X-Received: by 2002:a25:1405:: with SMTP id 5mr3902862ybu.97.1601479094791;
 Wed, 30 Sep 2020 08:18:14 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=ojR_Aac4bWSBqb3_FmzzjA6sHQBdN5z4o6c4nFDKmNDQ@mail.gmail.com>
 <87blhok9jd.fsf@suse.com> <CAH2r5murtQh0Mvp53bc_DRh7AwuMNPq=dqPq=gh3ESsQ0Lkwsg@mail.gmail.com>
In-Reply-To: <CAH2r5murtQh0Mvp53bc_DRh7AwuMNPq=dqPq=gh3ESsQ0Lkwsg@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 30 Sep 2020 20:48:04 +0530
Message-ID: <CANT5p=q=8MLgWogmUiGUCRX53qNOsg_tRyXP_YMDjfrfai7awQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Return the appropriate error in cifs_sb_tlink
 instead of a generic error.
To:     Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

It looks like xfstests smb3 multiuser cifsutils-101 and cifs-101 are failin=
g.
Maybe they were written keeping in mind the current error code
returned by cifs.ko in this situation? Let me take a look.
I guess @ronnie sahlberg will be able to debug the failing tests
faster. The failing test has his name in the code. :)

On Tue, Sep 29, 2020 at 11:16 PM Steve French <smfrench@gmail.com> wrote:
>
> tentatively merged ... running the usual functional tests
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/b=
uilds/399
>
> On Tue, Sep 29, 2020 at 8:16 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wro=
te:
> >
> > Shyam Prasad N <nspmangalore@gmail.com> writes:
> > > One of the cases where this behaviour is confusing is where a
> > > new tcon needs to be constructed, but it fails due to
> > > expired keys. cifs_construct_tcon then returns ENOKEY,
> > > but we end up returning a EACCES to the user.
> > >
> > > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> >
> > LGTM
> >
> > Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> >
> > Cheers,
> > --
> > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnber=
g, DE
> > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)
>
>
>
> --
> Thanks,
>
> Steve



--=20
-Shyam
