Return-Path: <SRS0=6FgL=DG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A8A1C4727C
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Sep 2020 17:52:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C99B0208B8
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Sep 2020 17:52:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VmwW6QjD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgI2RwT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 29 Sep 2020 13:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727360AbgI2RwQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 29 Sep 2020 13:52:16 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5217C061755
        for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2020 10:52:16 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id k2so4265737ybp.7
        for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2020 10:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=dZs/KCwyiW2hXyAexOW+0L1ALZd2I3YmhzmWjDZNnws=;
        b=VmwW6QjD7I87ks0V28l80s0yg/XRjkegqyibRPNe7mTXMRPbSrgwWr1dvjGBW1WWpT
         vTX7eYXsnrraOlxQBP1Vo1Ta6zsF9O40oTDrVqNabvbiIOSLjfJbMdcsp75ddsagXCgy
         YgDRJV8/LNF8U7yALLB72c5vtd9KnihIuoZohYmEF/bqcjCw0cTIxR3BbXXRUA7U3MYd
         8QCwbKYwo6k+sfac9A6M8cFW+Sl0FtOFrelWfkFB0hHLJuJyQ73vslBSs2+8F20zUAAe
         zXtS5bIqatAvFG2WJkCNgy3f8VX/bqxmg1B9G2uGlSD8woNR16DnQaM/jFngvF7y8Ze/
         Mqyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=dZs/KCwyiW2hXyAexOW+0L1ALZd2I3YmhzmWjDZNnws=;
        b=DVBB3H4WVC+Dd7qhkq/kz7tt8OaPKtQ8XTZJynQiKBCfX1Se3nAK4qv/s+0jQu870i
         5bCklanhHU3aVls6k/5/NNcsxmA2supp5Ky0/hk0q6cWCyh3u2ik7L4gmG3x3QiYlrcY
         KrQQKla1sOipEhlEDTpBMH4VcCB3KW1956SS1YMScmyed7iKpwQnW6TEtlOLmapUwHua
         z3dLNc7mTQV/wwsJ+H1wRqlGWwbQRM5yRg0/DhtpABoU+t+LCZIeRIP4YZJI2CM1izbe
         XiQmaTUFBjBoudUNG3CbLUCFTrWWwPV/YD7NVk1USqlvn0TAhK03Ua/s3CHTo/REQAgP
         70Ew==
X-Gm-Message-State: AOAM530Q5I1dRJJ4617rZ+0zHq4cSucYRZo4M8jLveaB/1rYndSILoyX
        4RVF7P2dh1TLBnseWT8gQO9QaM94E5A9T/OIdus=
X-Google-Smtp-Source: ABdhPJwGjbEDzpvas9JRsQoSwwRda/NUCXhewrxfTRdhqsnKWLoBWGBWZsiGjZlI9p0FXpGImJDTBOUP/nyvvS8gZec=
X-Received: by 2002:a25:d848:: with SMTP id p69mr7647135ybg.414.1601401935936;
 Tue, 29 Sep 2020 10:52:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200924003638.2668-1-pboris@amazon.com> <CAHhKpQ4UFhtfRhByRiAm6KPy=KAzttYzZADLfakbMwpsp5GjpA@mail.gmail.com>
 <9f6ee329-b91b-9d43-a787-0450a2c8143d@talpey.com> <CAHhKpQ4QzPR-87yRxNOzdQknEmH=6ju6FgAHze+rNgQsBSkmeg@mail.gmail.com>
In-Reply-To: <CAHhKpQ4QzPR-87yRxNOzdQknEmH=6ju6FgAHze+rNgQsBSkmeg@mail.gmail.com>
From:   Boris Protopopov <boris.v.protopopov@gmail.com>
Date:   Tue, 29 Sep 2020 13:52:04 -0400
Message-ID: <CAHhKpQ7e890bbXswqk01-6TJyBtgVQCkvdbZy55iGj8-owKHcw@mail.gmail.com>
Subject: Fwd: Fwd: [PATCH] Convert trailing spaces and periods in path components
To:     Steve French <smfrench@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

---------- Forwarded message ---------
From: Boris Protopopov <boris.v.protopopov@gmail.com>
Date: Tue, Sep 29, 2020 at 1:51 PM
Subject: Re: Fwd: [PATCH] Convert trailing spaces and periods in path compo=
nents
To: Tom Talpey <tom@talpey.com>


Windows Server 2019, should have mentioned above.

On Tue, Sep 29, 2020 at 1:23 PM Tom Talpey <tom@talpey.com> wrote:
>
> What was the server for these tests?
>
> On 9/29/2020 1:08 PM, Boris Protopopov wrote:
> > Testing:
> >
> > Prior to the patch:
> >
> > % mount -v
> > =E2=80=A6
> > //host/share/home on /tmp/diry type cifs (rw,relatime,vers=3Ddefault,..=
.
> > % ls -l /tmp/diry/tmp
> > total 0
> > % mkdir /tmp/diry/tmp/DirWithTrailingDot.
> > % ls -l  /tmp/diry/tmp/DirWithTrailingDot.
> > total 0
> > % touch  /tmp/diry/tmp/DirWithTrailingDot./file
> > touch: cannot touch =E2=80=98/tmp/diry/tmp/DirWithTrailingDot./file=E2=
=80=99: No such
> > file or directory
> > % mkdir  /tmp/diry/tmp/DirWithTrailingDot./dir
> > mkdir: cannot create directory
> > =E2=80=98/tmp/diry/tmp/DirWithTrailingDot./dir=E2=80=99: No such file o=
r directory
> > % find  /tmp/diry/tmp/DirWithTrailingDot.
> > /tmp/diry/tmp/DirWithTrailingDot.
> > % find  /tmp/diry/tmp/DirWithTrailingSpace\
> > find: `/tmp/diry/tmp/DirWithTrailingSpace ': No such file or directory
> > % mkdir  /tmp/diry/tmp/DirWithTrailingSpace\
> > % ls -l  /tmp/diry/tmp/DirWithTrailingSpace\
> > total 0
> > % touch /tmp/diry/tmp/DirWithTrailingSpace\ /file
> > touch: cannot touch =E2=80=98/tmp/diry/tmp/DirWithTrailingSpace /file=
=E2=80=99: No
> > such file or directory
> > % mkdir /tmp/diry/tmp/DirWithTrailingSpace\ /dir
> > mkdir: cannot create directory =E2=80=98/tmp/diry/tmp/DirWithTrailingSp=
ace
> > /dir=E2=80=99: No such file or directory
> >
> > After the patch:
> >
> > % umount /tmp/diry
> > % modprobe -r cifs
> > # load the fix
> > % modprobe cifs
> > % mount -t cifs -o...  //host/share/home /tmp/diry
> > ...
> > % mkdir /tmp/diry/tmp/DirWithTrailingSpace\ /dir
> > % touch /tmp/diry/tmp/DirWithTrailingSpace\ /file
> > % mkdir  /tmp/diry/tmp/DirWithTrailingDot./dir
> > % touch  /tmp/diry/tmp/DirWithTrailingDot./file
> > % find  /tmp/diry/tmp/
> > /tmp/diry/tmp/
> > /tmp/diry/tmp/DirWithTrailingDot.
> > /tmp/diry/tmp/DirWithTrailingDot./dir
> > /tmp/diry/tmp/DirWithTrailingDot./file
> > /tmp/diry/tmp/DirWithTrailingSpace
> > /tmp/diry/tmp/DirWithTrailingSpace /dir
> > /tmp/diry/tmp/DirWithTrailingSpace /file
> > % rm -rf /tmp/diry/tmp/*
> > % find  /tmp/diry/tmp/
> > /tmp/diry/tmp/
> >
> > ---------- Forwarded message ---------
> > From: Boris Protopopov <pboris@amazon.com>
> > Date: Wed, Sep 23, 2020 at 8:39 PM
> > Subject: [PATCH] Convert trailing spaces and periods in path components
> > To:
> > Cc: <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
> > Boris Protopopov <pboris@amazon.com>
> >
> >
> > When converting trailing spaces and periods in paths, do so
> > for every component of the path, not just the last component.
> > If the conversion is not done for every path component, then
> > subsequent operations in directories with trailing spaces or
> > periods (e.g. create(), mkdir()) will fail with ENOENT. This
> > is because on the server, the directory will have a special
> > symbol in its name, and the client needs to provide the same.
> >
> > Signed-off-by: Boris Protopopov <pboris@amazon.com>
> > ---
> >   fs/cifs/cifs_unicode.c | 8 +++++++-
> >   1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
> > index 498777d859eb..9bd03a231032 100644
> > --- a/fs/cifs/cifs_unicode.c
> > +++ b/fs/cifs/cifs_unicode.c
> > @@ -488,7 +488,13 @@ cifsConvertToUTF16(__le16 *target, const char
> > *source, int srclen,
> >                  else if (map_chars =3D=3D SFM_MAP_UNI_RSVD) {
> >                          bool end_of_string;
> >
> > -                       if (i =3D=3D srclen - 1)
> > +                       /**
> > +                        * Remap spaces and periods found at the end of=
 every
> > +                        * component of the path. The special cases of =
'.' and
> > +                        * '..' do not need to be dealt with explicitly=
 because
> > +                        * they are addressed in namei.c:link_path_walk=
().
> > +                        **/
> > +                       if ((i =3D=3D srclen - 1) || (source[i+1] =3D=
=3D '\\'))
> >                                  end_of_string =3D true;
> >                          else
> >                                  end_of_string =3D false;
> > --
> > 2.18.4
> >
> >
