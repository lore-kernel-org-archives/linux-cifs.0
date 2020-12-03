Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E771FC4167B
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Dec 2020 23:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9484B2245C
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Dec 2020 23:06:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgLCXGm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 3 Dec 2020 18:06:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgLCXGm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 3 Dec 2020 18:06:42 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42B6C061A52
        for <linux-cifs@vger.kernel.org>; Thu,  3 Dec 2020 15:05:55 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id s27so5165120lfp.5
        for <linux-cifs@vger.kernel.org>; Thu, 03 Dec 2020 15:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gPW6ADOscTvoFGGv+PY85+kFAHW62TzEPZAwbYhY3Wk=;
        b=M9CKwoM7joh4IVUhQGI8US46dBZtpMKo4rTTJHDCvKEftOSUb1vNr1MRCQ8ZhjLglS
         qrXOv4bZJRhre7aZWR8Dho5IxmVGKsaImlWo9Neehf62y2123Ux6EUbJT3hn0HpowvIc
         7QC65tiFlXbxf5mvYEudqcgUsWvgi16M2gPA2JkPQkfbeZbt09gfK+OijG6hLg7jxU5B
         bduoO8j1XuHeNKCp26cuhEo1sHK8IPmKk5dK1a1sSZzW+8KaPM03OdpbBB1IZPH2xPbt
         d2M+2s9ysqbUsDX9LTyjW/tUUxV7hZXaEfKr0SDcXILTvCHHAemqpgM2KWL99IXQMfvP
         PWkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gPW6ADOscTvoFGGv+PY85+kFAHW62TzEPZAwbYhY3Wk=;
        b=F2hND2g/sOpAS8aJsnvSUZzuFQgjfC4uT//zcoIQHYdOxgvHveIE/h2XohZGh3Xj4+
         gJWHXWBPG3QEoH6qRqbHrVemv0w6GZOyiDvTXr0JQhTtb+CZOs5jSzowFKCi12XC6m4D
         taeu/Xz4UAjSDVw+pdodEFwCKmoUHBTKBvrGmbc3dHRPFnNyaAURynrhQ4Ap86iiZubN
         wtpDXsJNI9yao8hrt0ECcrVvrGE5lZea8RJZ65pk7V1aMATaKAmTCjim1mtO9iZNb9X1
         LAnu28yRXbtMeRI0rUtNB/1iw+yVf6ZbF4zazsM3No+F0W3SNSH9KSi+8opKKr3YFUy6
         ekOQ==
X-Gm-Message-State: AOAM533CZs5L8HN1nGcVdDIK9KYLLuwMRCAsgBEiJ/bS3D1Ite4MkyPT
        gwF4lK8Vbonwt+yvKzVi9r2Skz1xgz0nufO6EYA=
X-Google-Smtp-Source: ABdhPJw2WBGoSAGFtm9o/3/hLjajIBrDMe82yp5OXZdu7igfLIB24Ojbt1FUL3z9yOvkgYlmNFFncum+QL4KnG+3Z4w=
X-Received: by 2002:a19:228f:: with SMTP id i137mr2059162lfi.477.1607036754367;
 Thu, 03 Dec 2020 15:05:54 -0800 (PST)
MIME-Version: 1.0
References: <CGME20201203033831epcas1p4c69684156cd4e393f048472a24238e6c@epcas1p4.samsung.com>
 <20201203033136.16375-1-namjae.jeon@samsung.com> <CAN05THQdg9XQH2kNh43G60WkhUNFpbGA7P=x++kHtTRVprM5DQ@mail.gmail.com>
In-Reply-To: <CAN05THQdg9XQH2kNh43G60WkhUNFpbGA7P=x++kHtTRVprM5DQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 3 Dec 2020 17:05:42 -0600
Message-ID: <CAH2r5musGCUknmciO+KzZSVkec7f0gxbupG201oMvfDGqjTpRg@mail.gmail.com>
Subject: Re: [PATCH] smb3: set COMPOUND_FID to FileID field of subsequent
 compound request
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Namjae Jeon <namjae.jeon@samsung.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

updated ... also just noticed that no need for cc:stable since this
was added after 5.9

On Thu, Dec 3, 2020 at 3:23 PM ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
>
> Looks good to me,
> please add "Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>"
>
> (How could this ever have worked?)
>
>
> Can you add a line :
> Fixes: 2e4564b31b645 ("smb3: add support ....
>
> On Thu, Dec 3, 2020 at 1:38 PM Namjae Jeon <namjae.jeon@samsung.com> wrote:
> >
> > For an operation compounded with an SMB2 CREATE request, client must set
> > COMPOUND_FID(0xFFFFFFFFFFFFFFFF) to FileID field of smb2 ioctl.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > ---
> >  fs/cifs/smb2ops.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index 504766cb6c19..3ca632bb6be9 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -3098,8 +3098,8 @@ smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
> >         rqst[1].rq_nvec = SMB2_IOCTL_IOV_SIZE;
> >
> >         rc = SMB2_ioctl_init(tcon, server,
> > -                            &rqst[1], fid.persistent_fid,
> > -                            fid.volatile_fid, FSCTL_GET_REPARSE_POINT,
> > +                            &rqst[1], COMPOUND_FID,
> > +                            COMPOUND_FID, FSCTL_GET_REPARSE_POINT,
> >                              true /* is_fctl */, NULL, 0,
> >                              CIFSMaxBufSize -
> >                              MAX_SMB2_CREATE_RESPONSE_SIZE -
> > --
> > 2.17.1
> >



-- 
Thanks,

Steve
