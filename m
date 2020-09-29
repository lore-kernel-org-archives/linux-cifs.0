Return-Path: <SRS0=6FgL=DG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9110C4727C
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Sep 2020 17:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AD6A20848
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Sep 2020 17:46:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pyzHejmP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbgI2RqT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 29 Sep 2020 13:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728302AbgI2RqS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 29 Sep 2020 13:46:18 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8D7C061755
        for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2020 10:46:18 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id k2so4252213ybp.7
        for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2020 10:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NqzvTOopU0yHW8j9nTxmOcgZNCV7823wJz6R6suVIjU=;
        b=pyzHejmPsKkZ86vrtOgHC7pV/4Q40lyP+CgYNty+K3yuH0y8ceIJLXLZcVsJKpFKrq
         1fQcLXv2rKP8qKr7VbSMVRVjjYPtaqtdKlUAyT1TldqeUQ7TRLtmtEqLUx0J7+DpEvBO
         WcFZx7cNfqfm7iT65wa0AJBP7B0yI+Mq1sVG4Gy9nR+D2nEt3i9dhnVzXbVppsF4qg7N
         gAoV+smSAuN5FrY9nuVvkx79D8c9qCT8WCxVhaFCkpgt4aggu+58T0cUFfitjWY3qDSR
         dGhTXUA81P0vvPN/pVnqGfa2jCt2CPWB5M27MxpoSnwZBZ9xrhniV5N43sBFebMz1MQL
         cmGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NqzvTOopU0yHW8j9nTxmOcgZNCV7823wJz6R6suVIjU=;
        b=HrZYQF1PH+GKQEI4hZkBZZG/K1fctXIUVVdPvYiu4aX54vNUWRo2r4DdESB7iVVVFZ
         w4uR2YUPgP2mOUZoe/lgagFqp8orcinsCF5naLQlaeyqF1jKCiJMHvHuUdGgzpR03AEi
         MdlBlNh+3uQWTUY1e80iohBq098AKojsHt5GUtvL8LFnP3imDvPmhCJ77rSArDjVCWfs
         mzQRGKYlZaoLV9mCUnpv1Ci7jIym+1r5QGzZqW5Y+ewY+hCkgR+ugbrPO/q6ZpEYwIN0
         bWDNDUcGYJfk9Q1v73vNfyZemDFM+gdXRGg/0bb1WneGczeu8QesN2w/sAYYnfjSYGGv
         ilxw==
X-Gm-Message-State: AOAM533Pnj4FwFMprlFODx5RAN/RG9eCl3VXAOyU8AhO1kAxk5cH3O+y
        HQCNiFKly/oRCqmKo80HHdU6tbpJiGpEHEXQ8BU=
X-Google-Smtp-Source: ABdhPJw8X8GS6om2H9Qa4Go25JfJTjpil+mlh2o2GBN+ecrU3obt/ZyLQ/h+VXcMfrzieNkpHAjKjWjGmyzRlxmFWM4=
X-Received: by 2002:a25:ce52:: with SMTP id x79mr7332605ybe.183.1601401577914;
 Tue, 29 Sep 2020 10:46:17 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=ojR_Aac4bWSBqb3_FmzzjA6sHQBdN5z4o6c4nFDKmNDQ@mail.gmail.com>
 <87blhok9jd.fsf@suse.com>
In-Reply-To: <87blhok9jd.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 29 Sep 2020 12:46:07 -0500
Message-ID: <CAH2r5murtQh0Mvp53bc_DRh7AwuMNPq=dqPq=gh3ESsQ0Lkwsg@mail.gmail.com>
Subject: Re: [PATCH] cifs: Return the appropriate error in cifs_sb_tlink
 instead of a generic error.
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged ... running the usual functional tests
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/bui=
lds/399

On Tue, Sep 29, 2020 at 8:16 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
> > One of the cases where this behaviour is confusing is where a
> > new tcon needs to be constructed, but it fails due to
> > expired keys. cifs_construct_tcon then returns ENOKEY,
> > but we end up returning a EACCES to the user.
> >
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
>
> LGTM
>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)



--=20
Thanks,

Steve
