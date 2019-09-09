Return-Path: <SRS0=r/yF=XE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D48F0C4740A
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Sep 2019 17:30:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8C8321A4A
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Sep 2019 17:30:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i5fOD6WM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbfIIRa1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Sep 2019 13:30:27 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42423 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726931AbfIIRa1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 Sep 2019 13:30:27 -0400
Received: by mail-lf1-f68.google.com with SMTP id u13so11156564lfm.9
        for <linux-cifs@vger.kernel.org>; Mon, 09 Sep 2019 10:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KiRRT3+CWpt2a05y8Tkw8H4bN+6EZygju3KxunnjCwE=;
        b=i5fOD6WMGLTM3aa+QzyZdLVG3yFN97FFjYznd2dVUDMv5STBcGmHFesK29oc3Lu0Rn
         ce1IPfX/4mp9NHul/P5PVLS9EFqbJLjQB6sq3HAv/5gY6r1qJoebEkXbNvBeb0ZT0432
         O2JAWgnQAAC1IZ07Y450kDk9MG74CyPrKM6HAt6lED3j/No8Ss1kkZvgYvubKdiyLlrU
         WoIfQcsx2SqCBxtn2xsa1vIBBzfXOK290MfuGt9obND0n4io98ASBtovA6/PwRMOBswe
         e6KmSTSUY+imDS3+R5FYjD9xhv/Z8N4YiJrmQPQPGrsSSu2qvpTU0ylNOluIoSxW9GEc
         VT6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KiRRT3+CWpt2a05y8Tkw8H4bN+6EZygju3KxunnjCwE=;
        b=ldGTKgJl/S0o+yFRJmBU24P1Nvrkos5XDH5BKWxkr/G25RxSl3mHwj+AO3+3skI7QL
         eI8Co2uFdsY9XUbh+xVadxTYjr4OOuXlgGjId8K4JrTVlgDl1drNbI91g4DS9ShBaqU4
         NuFFtHfKmOhYnGYy4b1hLBizo5TSj2/ewgai1elDFVQyaEWDjQ+hVglUqInCb1cM3mA/
         o0kcFFPRycvNb9eFR1EOhRnLJrFSUIBdr4VRWOUcfyeJE01hdhEvm/Z1Q2b9g53g1Fxo
         z63RJJzrRgcCUtGcNctpjx6WYV+XADcIFq+nO14Pnf67LcH7nZGY1FC0/syZZfGMXzYn
         e2xw==
X-Gm-Message-State: APjAAAVhJhxSV2YP+CgnG/fOIXz2Em78yU4wNJTGUekCZ3Qrx00H7yth
        WdnBFmiVvLyqSCn5WoMY9gHd5rH/G6n1Aa0UkQ==
X-Google-Smtp-Source: APXvYqwe/H7ZrogBPbi+CkjQZ4o4TrFLBT6aMBdpZDie2L8zxhCQuV8Izga4oF5VIdGzDPvRW3wriqhPRlZLphIbxTM=
X-Received: by 2002:a19:3805:: with SMTP id f5mr17066721lfa.173.1568050225097;
 Mon, 09 Sep 2019 10:30:25 -0700 (PDT)
MIME-Version: 1.0
References: <1566447421-16203-1-git-send-email-zhengbin13@huawei.com> <CAH2r5msWGOYt7Q6PhnmLcnboiR+55+LZXsGGbqScW+mqWHNtpQ@mail.gmail.com>
In-Reply-To: <CAH2r5msWGOYt7Q6PhnmLcnboiR+55+LZXsGGbqScW+mqWHNtpQ@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 9 Sep 2019 10:30:14 -0700
Message-ID: <CAKywueSjOkq8gJ2ZXAUG-zaZK7tjxjXQ3dk1B40y+8YEbcw73w@mail.gmail.com>
Subject: Re: [PATCH] fs/cifs/cifsacl.c: remove set but not used variables 'rc'
To:     Steve French <smfrench@gmail.com>
Cc:     zhengbin <zhengbin13@huawei.com>, Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Yes, it looks like a bug: we should initialize rc=3D0 at the beginning
of the function and then return it at the end. Otherwise the errors
are being hidden.

--
Best regards,
Pavel Shilovsky

=D1=81=D1=80, 21 =D0=B0=D0=B2=D0=B3. 2019 =D0=B3. =D0=B2 21:17, Steve Frenc=
h <smfrench@gmail.com>:
>
> Isn't this a different bug - we set rc to -EINVAL but then don't
> return rc, we return 0 which looks wrong.
>
> On Wed, Aug 21, 2019 at 11:11 PM zhengbin <zhengbin13@huawei.com> wrote:
> >
> > Fixes gcc '-Wunused-but-set-variable' warning:
> >
> > fs/cifs/cifsacl.c: In function sid_to_id:
> > fs/cifs/cifsacl.c:347:6: warning: variable rc set but not used [-Wunuse=
d-but-set-variable]
> >
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: zhengbin <zhengbin13@huawei.com>
> > ---
> >  fs/cifs/cifsacl.c | 3 ---
> >  1 file changed, 3 deletions(-)
> >
> > diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> > index 1d377b7..2b34337 100644
> > --- a/fs/cifs/cifsacl.c
> > +++ b/fs/cifs/cifsacl.c
> > @@ -344,7 +344,6 @@ static int
> >  sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
> >                 struct cifs_fattr *fattr, uint sidtype)
> >  {
> > -       int rc;
> >         struct key *sidkey;
> >         char *sidstr;
> >         const struct cred *saved_cred;
> > @@ -405,7 +404,6 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs=
_sid *psid,
> >         saved_cred =3D override_creds(root_cred);
> >         sidkey =3D request_key(&cifs_idmap_key_type, sidstr, "");
> >         if (IS_ERR(sidkey)) {
> > -               rc =3D -EINVAL;
> >                 cifs_dbg(FYI, "%s: Can't map SID %s to a %cid\n",
> >                          __func__, sidstr, sidtype =3D=3D SIDOWNER ? 'u=
' : 'g');
> >                 goto out_revert_creds;
> > @@ -418,7 +416,6 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs=
_sid *psid,
> >          */
> >         BUILD_BUG_ON(sizeof(uid_t) !=3D sizeof(gid_t));
> >         if (sidkey->datalen !=3D sizeof(uid_t)) {
> > -               rc =3D -EIO;
> >                 cifs_dbg(FYI, "%s: Downcall contained malformed key (da=
talen=3D%hu)\n",
> >                          __func__, sidkey->datalen);
> >                 key_invalidate(sidkey);
> > --
> > 2.7.4
> >
>
>
> --
> Thanks,
>
> Steve
