Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1704C77B75
	for <linux-cifs@archiver.kernel.org>; Mon, 22 May 2023 06:40:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjEVGkH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 May 2023 02:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjEVGkG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 May 2023 02:40:06 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63228A1
        for <linux-cifs@vger.kernel.org>; Sun, 21 May 2023 23:40:04 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2af98eb6ef0so12329901fa.3
        for <linux-cifs@vger.kernel.org>; Sun, 21 May 2023 23:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684737602; x=1687329602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VV/ehKbV1iIQDJGQSm6zCQ7DyGUIKWnG+QaHD5Qb+gk=;
        b=oaweLlErQs9IW1mUjYS2GcJVJmCcCBcub8429joPEegTmdZA4Dh28nuGlfO9dhRDyo
         Vf1YKBAl9ADNhafTQo/UkbC3AM0XqynPbRtVyaYL9CdIj0W4XnmHHKTlbIHc/p4j/yX/
         HbS5lmYelAau/+qrlvHh634vl+/1aVh0Nk49GB2+XJvfy01ELs5PhEfTVpPoX+VxCla7
         V1jhRo1hYfa1CNqwgxSvOR5Xmio8485zE+wveWK9WYGgDAmQfXaTyC7I8pyYDBJjvC+m
         EB1K2dFHQwePB89P5I/yx2AIf1rTwi6lJxsB9rFLDV4r9BgXOaOi7Q7Oc9ADqWK7hK4G
         u74A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684737602; x=1687329602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VV/ehKbV1iIQDJGQSm6zCQ7DyGUIKWnG+QaHD5Qb+gk=;
        b=hgfWLbLqW9CuA3cIiWQdJ2W6hns2WzjmGjkv6JjiQshSBJ5hF0cy1G41+aIm2PhSND
         ISJNExxwVTTwXta2sDRx+NNH623b8ylo9PeOL1T5sp38NLJmPIqzjLc7ZiPH5PHhns96
         mPtyOduOmRYQE+NcKWeyqxLOQnKPXBjRogwleLeufdDRMPu7Ue6yc0eIPheZTmpSpLf8
         a5sWr/slJUuFgbm9jkU/gPYCAC7GZVEjn4z8Znj688j2VR3nA37RQ3TNqaZKYp4+b22G
         P+k7og03VUsX45y8ETjk6OeIlkK83nQHxP5a+ayHqOCt/CgRwfs9aoDfcBpkd8WA8PdP
         93YQ==
X-Gm-Message-State: AC+VfDx4MKqdLROqMHMEoIBQ0jdI4oCi3rmhuRjAEnSSZ+t4FvnYN9hM
        GzwbpQwm0MS3C2m3H7kcLkOzxaCyqPBCUaFeNKw=
X-Google-Smtp-Source: ACHHUZ74gSfXpfdK7tBjZe+RbkZ3a44uSJ/MFtndDmkpCxkDwETOvz+Tpw8keNpSbj/qNKmEFgqiqJsApRYmKVOvHgc=
X-Received: by 2002:ac2:4907:0:b0:4f4:af57:19af with SMTP id
 n7-20020ac24907000000b004f4af5719afmr640473lfi.2.1684737602225; Sun, 21 May
 2023 23:40:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv8nAncg-f=Z5u8LkH4o7kfJLJdtoksYQgiguF7efKZkQ@mail.gmail.com>
 <CAN05THRKq9XPD11rBWXyTL_OGSh4pP6mQyufeW+xc+J3wvkMmw@mail.gmail.com>
In-Reply-To: <CAN05THRKq9XPD11rBWXyTL_OGSh4pP6mQyufeW+xc+J3wvkMmw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 22 May 2023 01:39:50 -0500
Message-ID: <CAH2r5mtJfSiQXBRUwv6zcR5rhG2Q-pCvjH+n+_SZmVQo1pMeVg@mail.gmail.com>
Subject: Re: Displaying streams as xattrs
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, May 21, 2023 at 11:33=E2=80=AFPM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> A problem  we have with xattrs today is that we use EAs and these are
> case insensitive.
> Even worse I think windows may also convert the names to uppercase :-(
> And there is no way to change it in the registry :-(

But for alternate data streams if we allowed them to be retrieved via xattr=
s,
would case sensitivity matter?  Alternate data streams IIRC are already
case preserving.   Presumably the more common case is for a Linux user
to read (or backup) an existing alternate data stream (which are usually
created by Windows so case sensitivity would not be relevant).

> On Mon, 22 May 2023 at 12:09, Steve French via samba-technical
> <samba-technical@lists.samba.org> wrote:
> >
> > Looking through code today (in fs/cifs/xattr.c) I noticed an old
> > reference to returning alternate data streams as pseudo-xattrs.
> > Although it is possible to list streams via "smbinfo filestreaminfo"
> > presumably it is not common (opening streams on remote files from
> > Linux is probably not done as commonly as it should be as well).
> >
> > Any thoughts about returning alternate data streams via pseudo-xattrs?
> > Macs apparently allow this (see e.g.
> > https://www.jankyrobotsecurity.com/2018/07/24/accessing-alternate-data-=
streams-from-a-mac/)
> >
> >
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
> >



--=20
Thanks,

Steve
