Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BB63C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Feb 2022 13:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353777AbiBNNCo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Feb 2022 08:02:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiBNNCo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 14 Feb 2022 08:02:44 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58CD74C7A4
        for <linux-cifs@vger.kernel.org>; Mon, 14 Feb 2022 05:02:36 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id f17so26957395edd.2
        for <linux-cifs@vger.kernel.org>; Mon, 14 Feb 2022 05:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1pff2KaA2YsJBdWQk9iXxsMw8KxxWwYcdZ74mkRkdQs=;
        b=Qg6HAyrj3mzu+1gg1+eeRTV6lkAV5fsWdFHN9OTi/39hS9jq27O3VsEtpdfm+7JUkH
         nDBLTocNtttAnDHN0Fxp0rnoTFCxZc3hTyyYtVktmx81POtUqlH+n7MpPH8HCtgpJ+pu
         YRJTGU1lQ8cvtbJjfK7pRHskIHnuvHP39YpVK3R0nx4VEZWuwWe8Lsfbc2EjTkRapNsV
         fLbEI11KPV0Ah29VFjuCeifWzp6MOANbtzRN0smcu3JWpnH2BlULHA8ISOa3GxokjI2+
         5ykyQk031pR8hlsQYuNxzMi5aCKCsykj6yo+1dHaAt8+yHOmbGY1SmalgwEnZhUunIFK
         TyZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1pff2KaA2YsJBdWQk9iXxsMw8KxxWwYcdZ74mkRkdQs=;
        b=BIBOmOAHnlJOff9o6lM1QZFQ1wR4fG5bJY+mxa5jhdUgDugmWkdrZjRh5AHXUiFlox
         eX6ot2Zr0rY6RkJ/eQPUv3Sfzd6PubBAlLPWAmlD/TM759uHh/4S89h2edurZUuJ9M3b
         0vXH5McpDE6CKKK1jlunjeuggeOeLk6UKBFwepb9qrj9XN/UYIKY9+Ci3ij7b0xg7w1A
         Ezx6/yvFrk6j5tl3qT37YQm5lQEL1reMGUx6S2uJc0+lKK7kK+iKKi3QrzyHyMaiDKpA
         NIW/r2lQ5HJZRshTDXJ9vvi5Y8UhMmsFaEHpUb3LNFRZeCDHiFLvhJzlbBrmVZXhCQSy
         m8JQ==
X-Gm-Message-State: AOAM5308sOPT5towshfQrYXROuGD6Sv+CMXcAEBkBdyX19PW2U/mre8y
        G5LwlBgi8S4daGt0V6fcarHjUy8m41TqntfEynw=
X-Google-Smtp-Source: ABdhPJzSGoiVW0AAY80f/Z8XOuuvOtG1NJDwaQ/T8qJvEk94okmCQxE98ED+QjHS3x2lwocvYMaaWhF2tV41+kBl+L4=
X-Received: by 2002:a50:cccb:: with SMTP id b11mr15438435edj.57.1644843754633;
 Mon, 14 Feb 2022 05:02:34 -0800 (PST)
MIME-Version: 1.0
References: <20220213224052.3387192-1-lsahlber@redhat.com> <20220213224052.3387192-2-lsahlber@redhat.com>
 <CAH2r5ms+mW2ujPBObv4MbSe2VkXwthwVqJYQjd75MmyAU1YC-w@mail.gmail.com>
In-Reply-To: <CAH2r5ms+mW2ujPBObv4MbSe2VkXwthwVqJYQjd75MmyAU1YC-w@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 14 Feb 2022 18:32:22 +0530
Message-ID: <CANT5p=ptM__+A6kjuxp5_Dm-ccMyUhabP+xb=LSX0FOsQDwe0g@mail.gmail.com>
Subject: Re: [PATCH] cifs: modefromsids must add an ACE for authenticated users
To:     Steve French <smfrench@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Feb 14, 2022 at 3:45 PM Steve French <smfrench@gmail.com> wrote:
>
> Should I add:
>    cc:Stable # 5.12+
>
> Thoughts?
>
> On Sun, Feb 13, 2022 at 4:41 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
> >
> > When we create a file with modefromsids we set an ACL that
> > has one ACE for the magic modefromsid as well as a second ACE that
> > grants full access to all authenticated users.
> >
> > When later we chante the mode on the file we strip away this, and other,
> > ACE for authenticated users in set_chmod_dacl() and then just add back/update
> > the modefromsid ACE.
> > Thus leaving the file with a single ACE that is for the mode and no ACE
> > to grant any user any rights to access the file.
> > Fix this by always adding back also the modefromsid ACE so that we do not
> > drop the rights to access the file.
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/cifsacl.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> > index ee3aab3dd4ac..40cda87ce384 100644
> > --- a/fs/cifs/cifsacl.c
> > +++ b/fs/cifs/cifsacl.c
> > @@ -949,6 +949,9 @@ static void populate_new_aces(char *nacl_base,
> >                 pnntace = (struct cifs_ace *) (nacl_base + nsize);
> >                 nsize += setup_special_mode_ACE(pnntace, nmode);
> >                 num_aces++;
> > +               pnntace = (struct cifs_ace *) (nacl_base + nsize);
> > +               nsize += setup_authusers_ACE(pnntace);
> > +               num_aces++;
> >                 goto set_size;
> >         }
> >
> > @@ -1613,7 +1616,7 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
> >         nsecdesclen = secdesclen;
> >         if (pnmode && *pnmode != NO_CHANGE_64) { /* chmod */
> >                 if (mode_from_sid)
> > -                       nsecdesclen += sizeof(struct cifs_ace);
> > +                       nsecdesclen += 2 * sizeof(struct cifs_ace);
> >                 else /* cifsacl */
> >                         nsecdesclen += 5 * sizeof(struct cifs_ace);
> >         } else { /* chown */
> > --
> > 2.30.2
> >
>
>
> --
> Thanks,
>
> Steve

Good catch. Changes look good.
Please run the tests with memory sanitizers enabled for this one.

Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>

-- 
Regards,
Shyam
