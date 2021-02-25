Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83161C433E9
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 18:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A82464F26
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Feb 2021 18:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbhBYS3n (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Feb 2021 13:29:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232403AbhBYS3B (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Feb 2021 13:29:01 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62C2C06121E
        for <linux-cifs@vger.kernel.org>; Thu, 25 Feb 2021 10:27:26 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id g1so7581743ljj.13
        for <linux-cifs@vger.kernel.org>; Thu, 25 Feb 2021 10:27:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UMLJvMJse1VKb1ue1H1FLmWhyWVix6B4PkkzBUdSdbY=;
        b=IL4+v+ZA58BmI3jUWWZEaO3wRKqlLyQkscxcxE85dRGRWEwDQCTLsYqe/o786ZEcYA
         XdGH5mT5xKqMATIfIn84P28Ez1HRiVGiNU1aYetjP1jAo3BxVHfmzIUqwtZfmgceJRq2
         dTVXHEoPcV6r0WHUmlvrYogBlkCCAH4J9/RH7R9JdkK6vOWrN610W55q8duf9FhpFSjT
         g/2e3ECMuLycpDUOxgRHWspHEEKhQ34SutR6RU5roTnrdsCWazRwX8+1A1wlyLPcATac
         PO4T63IRhiGcjE5Zia6UF8OP7xgRyqM7rf8MgjY3+ZzucLmw9tT3zV2qeJ1vjLngmaoA
         Nlrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UMLJvMJse1VKb1ue1H1FLmWhyWVix6B4PkkzBUdSdbY=;
        b=rbijvdxcTlH4nZ6ownPGMBp0xnivzk9Trgfov67ggQkOrXs1Ezdkah/RwJ3C5LOSWg
         vFGo1dunK8Akugfb3jXE0Zx9EWiL67+N/ni39oUSsiTKj2jYN4wCScOvVgxH5RyV0GS5
         GF5X87aCG9s5t1mnhUY38YSlqIykWtyeyPXM/Z2wRLsJSbZhwPLaRNXY7gyKOSvVLTei
         k3j/LUnb0pPcYhSqFi1HSgtAOgZnGJjx1l0ydA7ZRp/9LswFbUYqSikwbADUwR+qstap
         CSb7kEhJ4apIUw2Hklw0HMj4S7FwMdYUwtdBxCEmaqOyKgcOZglP9lZ/3RhJIKrkQkbI
         6+3A==
X-Gm-Message-State: AOAM530W6qTtutXYMO01mFD2/ThNdqIdVYZZwToknSXu1poOTFe7zXxM
        pzo9kw1AwTOz8AFIpCHqqwTLoptfGt5Rs05+0wc=
X-Google-Smtp-Source: ABdhPJyBET8cfXbV9yKpG1x2f2IWphtPwCa4GLT/sQD1JDjeJWB4mhpG5J8+uc/WmHdNRYQSZ+r9foTXc3c0Zl+Dvy4=
X-Received: by 2002:a2e:98c5:: with SMTP id s5mr2258268ljj.218.1614277643670;
 Thu, 25 Feb 2021 10:27:23 -0800 (PST)
MIME-Version: 1.0
References: <20210225073627.32234-1-lsahlber@redhat.com> <CAH2r5mtJtxYUZOnJDzO9dPO-REPQqLLosPykgfArz-7AOaF9Gg@mail.gmail.com>
In-Reply-To: <CAH2r5mtJtxYUZOnJDzO9dPO-REPQqLLosPykgfArz-7AOaF9Gg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 25 Feb 2021 12:27:12 -0600
Message-ID: <CAH2r5mtQGnN8Py0-Y5DXb=3Cc+tY9qWw0cWux-V89-NpYFofdg@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix handling of escaped ',' in the password mount argument
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Simon Taylor <simon@simon-taylor.me.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

And also added Simon's Reported-by and Tested-by

On Thu, Feb 25, 2021 at 12:26 PM Steve French <smfrench@gmail.com> wrote:
>
> added cc: stable # 5.11 and pushed into cifs-2.6 for-next
>
> On Thu, Feb 25, 2021 at 1:36 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
> >
> > Passwords can contain ',' which are also used as the separator between
> > mount options. Mount.cifs will escape all ',' characters as the string ",,".
> > Update parsing of the mount options to detect ",," and treat it as a single
> > 'c' character.
> >
> > Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/fs_context.c | 43 ++++++++++++++++++++++++++++++-------------
> >  1 file changed, 30 insertions(+), 13 deletions(-)
> >
> > diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> > index 14c955a30006..892f51a21278 100644
> > --- a/fs/cifs/fs_context.c
> > +++ b/fs/cifs/fs_context.c
> > @@ -544,20 +544,37 @@ static int smb3_fs_context_parse_monolithic(struct fs_context *fc,
> >
> >         /* BB Need to add support for sep= here TBD */
> >         while ((key = strsep(&options, ",")) != NULL) {
> > -               if (*key) {
> > -                       size_t v_len = 0;
> > -                       char *value = strchr(key, '=');
> > -
> > -                       if (value) {
> > -                               if (value == key)
> > -                                       continue;
> > -                               *value++ = 0;
> > -                               v_len = strlen(value);
> > -                       }
> > -                       ret = vfs_parse_fs_string(fc, key, value, v_len);
> > -                       if (ret < 0)
> > -                               break;
> > +               size_t len;
> > +               char *value;
> > +
> > +               if (*key == 0)
> > +                       break;
> > +
> > +               /* Check if following character is the deliminator If yes,
> > +                * we have encountered a double deliminator reset the NULL
> > +                * character to the deliminator
> > +                */
> > +               while (options && options[0] == ',') {
> > +                       len = strlen(key);
> > +                       strcpy(key + len, options);
> > +                       options = strchr(options, ',');
> > +                       if (options)
> > +                               *options++ = 0;
> >                 }
> > +
> > +
> > +               len = 0;
> > +               value = strchr(key, '=');
> > +               if (value) {
> > +                       if (value == key)
> > +                               continue;
> > +                       *value++ = 0;
> > +                       len = strlen(value);
> > +               }
> > +
> > +               ret = vfs_parse_fs_string(fc, key, value, len);
> > +               if (ret < 0)
> > +                       break;
> >         }
> >
> >         return ret;
> > --
> > 2.13.6
> >
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
