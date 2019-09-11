Return-Path: <SRS0=GFFJ=XG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB4FC49ED6
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Sep 2019 20:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7A5C2084F
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Sep 2019 20:23:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fnVo69RC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729144AbfIKUXA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 Sep 2019 16:23:00 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:44649 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729054AbfIKUXA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 11 Sep 2019 16:23:00 -0400
Received: by mail-io1-f66.google.com with SMTP id j4so48991825iog.11
        for <linux-cifs@vger.kernel.org>; Wed, 11 Sep 2019 13:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=riXNoPTdWcH1kMsR+lmN099mpTuR/MFCa0oDI6ih5/w=;
        b=fnVo69RCik7rmJiyZkjM+Yx+sbyun+1Nmb8vVF3o997GbxQwtal8+i6df9yh4e2NvO
         zemj2NqTR3wMgoHM5aefXCOuyFOiw/P62sHaaKfukIh63W5QUIXd44b6VvpdjPNjiBuk
         epM/RGinHYJkbNHAtQPM8D6B1ArcC1vu6DpsopUsUjIT+y3WhqEjO4O4SibRq1GIdUqF
         /3cYHDcXFV89iO9XU1lX0TC7MTIlUDjElxZ+sYldv66VkhK7wTzt2XGGGxRVLlP9aaUx
         tInRUq5+K8LNweyzwIIyZqb72Gr9SE6pigSRrvT+UPImKai/LjXu2s0AudJpHmD6T3+u
         ZwVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=riXNoPTdWcH1kMsR+lmN099mpTuR/MFCa0oDI6ih5/w=;
        b=heRWJzojdJ5QkeYc8md9d1B/NkSp8ElrQcVa1yVO6pz5wNWVo3ZPwHbwbvFEd1QzuU
         khtdv68tzyMI93uw917w3iR4qoTVkg8jIvsWbpvO+Xv7aAyG2mXZGFuh5d+F1233z9T6
         AJSaoRYWpMVZ/MOsHVctJxlLl9PiISShbrb7JZPmYU6rPaKoOE73osFLrTYxvY343259
         taLCraxR00XN50eLCsshjWveR41BjEhUKKyrndp6K5VT6pA6rUGpFZeV0vP4Xl1NuYZU
         G8MC4IXvgkWdcKvzYR/ojShQFK8gAj0iVY/fOrMAhifTRCMXXuEZ0E9QZ3LAgrlNbWW0
         Z5qQ==
X-Gm-Message-State: APjAAAVxIwlTU3hhRE6Y9c6E2z3FJKuCBmso1ZQo3S52WgDKUfKKS0qx
        9k0Fbw3pfwhTCvEv0AFzneZmna3uQkfQzSPeTxOpXS/I
X-Google-Smtp-Source: APXvYqzpsC+61YDoxPcCH64yGUMbo7Gyu9AFYwGvZty/dN6X4vN93zUXa3+3HcGIisz962ZmZIQnxlYzC370ZvKdqT4=
X-Received: by 2002:a6b:2b07:: with SMTP id r7mr9530835ior.173.1568233379608;
 Wed, 11 Sep 2019 13:22:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190829222546.11779-1-lsahlber@redhat.com> <CAKywueR3VUUJT_VqM=FVLGnzqx1whKOBCNAbKS2Gm7tmjaEQWw@mail.gmail.com>
In-Reply-To: <CAKywueR3VUUJT_VqM=FVLGnzqx1whKOBCNAbKS2Gm7tmjaEQWw@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 11 Sep 2019 15:22:48 -0500
Message-ID: <CAH2r5msQoQnv1-N1Qv8Y3b=g3KUL84kZeVWRR039QeBzHmk_Fg@mail.gmail.com>
Subject: Re: [PATCH] cifs: create a helper to find a writeable handle by path name
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Even so ... we shouldn't ask for open/query/close or
open/setinfo/close if just a query-info or set-info (no open/close) is
possible - it will make server's lives much easier ...

On Wed, Sep 11, 2019 at 3:06 PM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> =D1=87=D1=82, 29 =D0=B0=D0=B2=D0=B3. 2019 =D0=B3. =D0=B2 15:26, Ronnie Sa=
hlberg <lsahlber@redhat.com>:
> >
> > rename() takes a path for old_file and in SMB2 we used to just create
> > a compound for create(old_path)/rename/close().
> > If we already have a writable handle we can avoid the create() and clos=
e()
> > altogether and just use the existing handle.
> >
> > For this situation, as we avoid doing the create()
> > we also avoid triggering an oplock break for the existing handle.
>
> Hi Ronnie,
>
> Another SMB2_CREATE from the same client shouldn't cause a lease break
> if we ask for a lease with the same lease key. The lease key is
> associated with the inode, all opens that can cause a break should ask
> for the lease with the lease key.
>
> Currently smb2_compound_op doesn't ask for a lease: see at the
> beginning of the function:
>
> oplock =3D SMB2_OPLOCK_LEVEL_NONE
>
> What we need to do is to change this to SMB2_OPLOCK_LEVEL_BATCH for
> operation that modifies the file like SET_EOF and SET_INFO. In this
> case the lower layer will map it to the appropriate lease state. Note
> that parms->fid->lease_key should be populated.
>
> --
> Best regards,
> Pavel Shilovsky



--=20
Thanks,

Steve
