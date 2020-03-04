Return-Path: <SRS0=Ot+p=4V=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA9D0C3F2CD
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Mar 2020 06:53:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C44AB2073D
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Mar 2020 06:53:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M4hSOtOD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgCDGx2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 Mar 2020 01:53:28 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:41906 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbgCDGx2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 Mar 2020 01:53:28 -0500
Received: by mail-il1-f194.google.com with SMTP id q13so897612ile.8;
        Tue, 03 Mar 2020 22:53:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pL5/NIk1WWlkMiptdFdVT6f4DEpBMO2Ea9hV7O9FFZ8=;
        b=M4hSOtODII7mizcjKB/B4luuRboPGxO2AiYJ6R/Am+xbZ6Bo5nSNCut2W43ABHcYOG
         KUgpPAmS+/TKUY3WHauUqWVJaTz+tZthcFwEjv1+WOPKtJh5nmp2lwxbqav1grzN4q5J
         YqEKcYNBJy4HMWKVWv3s6x8ISVYBB8LYURCscgUGkqDdLFpDi+xXgGtUYFziA4Vc2NGr
         R01Ir2imRORlTcAC2VMDEuXGEd6P8UPT30xYvLCjgdZd2W3ONH2aG2DdFAmHYdcBZyay
         yPcFhQDFcPLKoY3/cWpdhUUXmgyaB8pU0MGI/2s7NUPDsS5lO3FuB8BUA4sMBx3nlrby
         8t5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pL5/NIk1WWlkMiptdFdVT6f4DEpBMO2Ea9hV7O9FFZ8=;
        b=TUBqRwD/b2D2HtBUvhcfFuiwZd/wtypmvJUljGmmF4DP4o4AiXHl8BhaC8KcN11/1E
         b9Ccznn6/2DJhE/ImsGFDaQXRfRmT0AVL7Tyn470KE+lVZhme4zFHX+h1u42t1CwQEf+
         ub0x1/GRQSHZ3DYOHFa6ZT5bFjaVtA1s9KNU8xyvuo2j4JEDKDRM7KExz1uxpcfZL/qy
         2UdMcY0AAUMJABfkE8zBhcJ1c8S+aoSVSPzGFH5oi/AOfzYxGLPkDeTjMPX2tPvc4B95
         mklF7YGaUzI/o8a5zhCr3CHpyNyWJehwqxiVpXKysuLHil+ZFGZWhTLPBXUVQXCqhXzt
         DPtQ==
X-Gm-Message-State: ANhLgQ3Jc1kSN3dCqp5M85Q2iE1qgiTWSnEfGItXAAM2Z8fZrVPzK/R9
        gV+xdShmN7QVHxQedQtgcGzMEUMN00HMUX5my3WmsDIr
X-Google-Smtp-Source: ADFU+vtdgQ77PTbZP47ZnF50mr6bhBdcxckt57uNbK6qW0UzdS1cbUXppYi1UXcVK8kr/cjEnBFzVIGpVfVJ9c+2ZB4=
X-Received: by 2002:a05:6e02:ea8:: with SMTP id u8mr903581ilj.0.1583304807491;
 Tue, 03 Mar 2020 22:53:27 -0800 (PST)
MIME-Version: 1.0
References: <1583278783-11584-1-git-send-email-hqjagain@gmail.com> <CAH2r5mv9N_vo+vX7TaaPc2MBNFgsOAO6nGZcfaiaz8JqjM0BnQ@mail.gmail.com>
In-Reply-To: <CAH2r5mv9N_vo+vX7TaaPc2MBNFgsOAO6nGZcfaiaz8JqjM0BnQ@mail.gmail.com>
From:   Qiujun Huang <hqjagain@gmail.com>
Date:   Wed, 4 Mar 2020 14:53:16 +0800
Message-ID: <CAJRQjoeS+qPb6GkDCx6sbVFR2SszSAYuHC2VsTCE2YJU8p-GBA@mail.gmail.com>
Subject: Re: [PATCH] fs/cifs/cifsacl: remove set but not used variable 'rc'
To:     Steve French <smfrench@gmail.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Mar 4, 2020 at 2:23 PM Steve French <smfrench@gmail.com> wrote:
>
> Isn't it not used because of a potential bug - missing returning an
> error in two cases.

I get it, thanks.

>
> If we leave the two lines you removed in - and set rc=0 in its
> declaration (and return rc at the end as you originally had suggested)
> - doesn't that solve the problem?  A minor modification to your first
> proposed patch?

ok, I'll send v2.
>
> On Tue, Mar 3, 2020 at 5:39 PM Qiujun Huang <hqjagain@gmail.com> wrote:
> >
> >  It is set but not used, So can be removed.
> >
> > Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
> > ---
> >  fs/cifs/cifsacl.c | 3 ---
> >  1 file changed, 3 deletions(-)
> >
> > diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> > index 716574a..1cf3916 100644
> > --- a/fs/cifs/cifsacl.c
> > +++ b/fs/cifs/cifsacl.c
> > @@ -342,7 +342,6 @@
> >  sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
> >                 struct cifs_fattr *fattr, uint sidtype)
> >  {
> > -       int rc;
> >         struct key *sidkey;
> >         char *sidstr;
> >         const struct cred *saved_cred;
> > @@ -403,7 +402,6 @@
> >         saved_cred = override_creds(root_cred);
> >         sidkey = request_key(&cifs_idmap_key_type, sidstr, "");
> >         if (IS_ERR(sidkey)) {
> > -               rc = -EINVAL;
> >                 cifs_dbg(FYI, "%s: Can't map SID %s to a %cid\n",
> >                          __func__, sidstr, sidtype == SIDOWNER ? 'u' : 'g');
> >                 goto out_revert_creds;
> > @@ -416,7 +414,6 @@
> >          */
> >         BUILD_BUG_ON(sizeof(uid_t) != sizeof(gid_t));
> >         if (sidkey->datalen != sizeof(uid_t)) {
> > -               rc = -EIO;
> >                 cifs_dbg(FYI, "%s: Downcall contained malformed key (datalen=%hu)\n",
> >                          __func__, sidkey->datalen);
> >                 key_invalidate(sidkey);
> > --
> > 1.8.3.1
> >
>
>
> --
> Thanks,
>
> Steve
