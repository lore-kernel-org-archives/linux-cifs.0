Return-Path: <SRS0=MBFb=3L=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B23F8C2D0CE
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Jan 2020 00:04:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82EE724655
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Jan 2020 00:04:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YMDSbD16"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgAVAEq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Jan 2020 19:04:46 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40796 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgAVAEq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Jan 2020 19:04:46 -0500
Received: by mail-lj1-f193.google.com with SMTP id u1so4758557ljk.7
        for <linux-cifs@vger.kernel.org>; Tue, 21 Jan 2020 16:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=y/Ajp2Z27bCzKH6Yb4QKQSOWD/W+krohknSFQu5P+qY=;
        b=YMDSbD161QKsfw4NhR4pVjQvgPk55qZ+jYLqpCclb9BVDy9YUG8azRRnEpwP2kUtD4
         iVOS090Bl2qc3f0eJeiLh1w6e6W4JWl+dNKMq+75zfDWB0s1fOeeiW0zl7DPg2+35m4+
         t6aWGyf+qloVz17fobYxZvhjnRc5rZxUA5VCe55XF5xfxBKFnUcORamsPPkX5bXHP73q
         iz0Y8q9Z3UhrxHNEsY1f3hgqKsmRhdtq9TPHpEns27P8cZNg/akkg+bO6CDbhTOiUh2+
         /Dw9V9SVdiBzB4fuaatZQls9qrsRC75sr5gIQy/zB9GAwY64XYhrbsLGgybY8vAj8Gg7
         Y7Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=y/Ajp2Z27bCzKH6Yb4QKQSOWD/W+krohknSFQu5P+qY=;
        b=rj3yCQAzF1uc9HedjeaFlWJM00QgqN9QiBnh4fmgMqX6IsAS96ZmRtlx6yv7EQBkfq
         E1yNNDlf2bhZafFQxxm41FW56ji53D7JA3/b6f0KiQ6q97upPfMm9XszTky3GKNZ4mrZ
         yaR5OzaQAIlB8vZfqSa4yPwkKV1JMoNrrDuSSC6mdInKDMOqakhGVMUCfbBpd5kJULuU
         BJxl1CZ2o1kmyyVTZj3lnCD0ZwiX4fFPrvpx9JM7v5kAyId9Cz91Q79dojlQiP/GLvil
         15hYhs/W66Bt6wyD7hsTW8RwHVpSxKHHGr1lapNECB0e7O7D9vzNaUzK6NxrXrgziJh/
         QdPA==
X-Gm-Message-State: APjAAAUJHT4+9ykpXlTQvd/aRAhZsclatJxPOWM8/Zf9Y62Zo/1d5hg5
        25IejxrKH25HFTxTZ+V2rM9dfexZNeZ3/lEPRA==
X-Google-Smtp-Source: APXvYqxa0H5jIWe+cs6vHhI8uL6lmfGUTxNZ/4YWmZA4Up+kO+RId1cfO5pxGKrvtlZV1wMMitsTTcn2yBRqVsM5FBc=
X-Received: by 2002:a2e:9708:: with SMTP id r8mr17744893lji.92.1579651483750;
 Tue, 21 Jan 2020 16:04:43 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mvLCqTXVFG93AgSJHTu8daMLwV_hpbjgJs-7orUwr7ffg@mail.gmail.com>
 <644970174.6192265.1579230257768.JavaMail.zimbra@redhat.com> <CAH2r5mvGDLY0CN3i0R3sLK9exaGbTVohVNzRjh8-482mp-d_yg@mail.gmail.com>
In-Reply-To: <CAH2r5mvGDLY0CN3i0R3sLK9exaGbTVohVNzRjh8-482mp-d_yg@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 21 Jan 2020 16:04:32 -0800
Message-ID: <CAKywueS+3KdMHzg60Mp=NLbUv3EYwzaUROq5w4uD7jj1Ph42kQ@mail.gmail.com>
Subject: Re: [PATCH][SMB3] Fix modefromsid newly created files to allow more
 permission on server
To:     Steve French <smfrench@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good.

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky

=D1=87=D1=82, 16 =D1=8F=D0=BD=D0=B2. 2020 =D0=B3. =D0=B2 21:26, Steve Frenc=
h <smfrench@gmail.com>:
>
> updated with your suggestion and reviewed-by
>
> On Thu, Jan 16, 2020 at 9:04 PM Ronnie Sahlberg <lsahlber@redhat.com> wro=
te:
> >
> > Reviewed-By: Ronnie Sahlberg <lsahlber@redhat.com>
> >
> > But drop the extra parenthesises here :
> > +                (2 * sizeof(struct cifs_ace));
> >
> > ----- Original Message -----
> > From: "Steve French" <smfrench@gmail.com>
> > To: "CIFS" <linux-cifs@vger.kernel.org>
> > Sent: Friday, 17 January, 2020 12:28:03 PM
> > Subject: [PATCH][SMB3] Fix modefromsid newly created files to allow mor=
e permission on server
> >
> >     When mounting with "modefromsid" mount parm most servers will requi=
re
> >     that some default permissions are given to users in the ACL on newl=
y
> >     created files, and for files created with the new 'sd context' -
> > when passing in
> >     an sd context on create, permissions are not inherited from the par=
ent
> >     directory, so in addition to the ACE with the special SID (which co=
ntains
> >     the mode), we also must pass in an ACE allowing users to access the=
 file
> >     (GENERIC_ALL for authenticated users seemed like a reasonable defau=
lt,
> >     although later we could allow a mount option or config switch to ma=
ke
> >     it GENERIC_ALL for EVERYONE special sid).
> >
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve
