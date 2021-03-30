Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC6A4C433DB
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Mar 2021 22:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC657619C5
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Mar 2021 22:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbhC3WKL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Mar 2021 18:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbhC3WJm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Mar 2021 18:09:42 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6863C061574
        for <linux-cifs@vger.kernel.org>; Tue, 30 Mar 2021 15:09:41 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id z1so19968084edb.8
        for <linux-cifs@vger.kernel.org>; Tue, 30 Mar 2021 15:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zwhiZe8TIsL3OsV/iDJSmlPY4dzPfUf+DdrUAE1NBJ8=;
        b=c2LuPCJ1PATZjtqDZ7A9K4h3dluHvY8YdYMyqPivuV9teACHFtvsu0QdTlUWxIGVFl
         xEhfDY5UakEK5ok2Ogbf38FGyWXoM611t4WJLsV4DHvuoPX+3OKZJ+H8xdfsI+rf08Yv
         7y+jW69mBaN6XqE2h6shMuYNrzirHn3Ms5gPkZiBvC/rmJ54sfZn6EZdKVMWkSh1KU2s
         7Si76z/MqYlBVx7Hmqbf6Gb6rRki5DSgKz1sDynIwjmwksB7Oz5B0tX5bWufmBxQjPt+
         BCLCKr0KYpeMo10Z8gTFpJqdywJ3Wc48YxX7ms+LWj5J28mXs7vJEVv6Cx9lrRtKtAQ0
         kSVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zwhiZe8TIsL3OsV/iDJSmlPY4dzPfUf+DdrUAE1NBJ8=;
        b=DxP512yf5Veu9cQE3CuQEYhr10kIBrT7eKbZToVZO6QBJO9X+2ojv8QlhFcNNTjoIT
         zmaa83XCon0Mb6+7Bi+JEcH3fCjP+u3eHpPGvrlO7vouS4XHdLP0jSMzTd5mMuWp2nZo
         8XaWt94eG1uQKt+vlgDPHPJepUjEdHkuzCNTadzmipEmFsnivBzaoqIPiZq0MFRKoZWj
         kvbA/fqYdPqLl9nCkPJLWJXU3jHP1RV1MUnsRKAdW06lLNXBxSAp/owmdvdkl8Cop/xC
         7o4DhuNFi/ekqmixOCR5w9Scr6dnfGdYMk0dxwzqx09yhnZL9FzcZlLuUS87SKvq+vQO
         9yrw==
X-Gm-Message-State: AOAM532DHDCDtcZWQOELbcVe242XtXzzuoYGS8ZgnvHdcQpjnCTF6XND
        y/ze4SP+RRhfBAmKQ+mPf2HS48Pnhi6qecZPXNo=
X-Google-Smtp-Source: ABdhPJxoTQ8k+5MSEiSdjdP65zP6AY5xB2QNI+MNH7raoBnXn3wXxK5cNRtbCjNbYULY4/Tqo4XBSptBxAlOBWDadXU=
X-Received: by 2002:a05:6402:b2d:: with SMTP id bo13mr33829edb.120.1617142180498;
 Tue, 30 Mar 2021 15:09:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210326195229.114110-1-lsahlber@redhat.com> <87eefwpvsc.fsf@suse.com>
In-Reply-To: <87eefwpvsc.fsf@suse.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 31 Mar 2021 08:09:29 +1000
Message-ID: <CAN05THR6kWTL0qyCAoYc1p7bguAS7okxQ0jRDigfyXaE_jr5eA@mail.gmail.com>
Subject: Re: [PATCH] cifs: add support for FALLOC_FL_COLLAPSE_RANGE
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Mar 31, 2021 at 12:22 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrot=
e:
>
> Ronnie Sahlberg <lsahlber@redhat.com> writes:
> > +static long smb3_collapse_range(struct file *file, struct cifs_tcon *t=
con,
> > +                         loff_t off, loff_t len)
> > +{
> > +     int rc;
> > +     unsigned int xid;
> > +     struct cifsFileInfo *cfile =3D file->private_data;
> > +     __le64 eof;
> > +
> > +     xid =3D get_xid();
> > +
> > +     if (off + len < off) {
> > +             rc =3D -EFBIG;
> > +             goto out;
> > +     }
>
> loff_t is defined as 'long long' for me which is signed, and signed
> overflow is Undefined Behaviour, unless we compile with -fwrapv which
> I'm not sure it is something we can assume.
>
> Also, vfs_fallocate() in fs/open.c already does an overflow check before
> calling f_op->falloc(), this is probably not needed. (It's also relying
> on signed overflow so I guess it is ok...?)

Thanks.
Steve, can you drop this check from the patch?

>
> Rest of the patch looks good otherwise.
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>
