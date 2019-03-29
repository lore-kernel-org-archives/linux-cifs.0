Return-Path: <SRS0=xN7r=SA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C0BC43381
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Mar 2019 19:06:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0CA8218A5
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Mar 2019 19:06:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EpxJobra"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729842AbfC2TGJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 29 Mar 2019 15:06:09 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36978 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729766AbfC2TGJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 29 Mar 2019 15:06:09 -0400
Received: by mail-lf1-f68.google.com with SMTP id u2so2163132lfd.4;
        Fri, 29 Mar 2019 12:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tlfrLQCCm16d15r9Re73RV2BIPNK3T5w84CXTYUXmMk=;
        b=EpxJobravxAPR/2nf/jYBBXJAWqIub7QBjR4cI1G6Z1pAgRYmKGyeKUVt00zJFxCcc
         S3hUROpEDAw20F/BhJe0q4GFNUGcE9UG8B7YHtGwxxguc9i+qsuN4Zx5gadG1ahMISAF
         zMsZHcDiAWd4WiaTPXXtZDju+YCaBmmPbfA3nkXrE8zijvMKzhXGVpicuSD5659dJ5Hk
         f3jcUhWal2ZU/5tOE+BGG/7UAEW+MprMxxNObfFROLq+6W3UXLStEXg8UpxPR8QWAJGC
         ENNvMFsKROlaWwWJEa5Q5rVKIOH/dCIArxG7URpu2YVanBxpzInXciJi1dgPRKzwEGvs
         QFPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tlfrLQCCm16d15r9Re73RV2BIPNK3T5w84CXTYUXmMk=;
        b=m5snw0R56QUnuHIp2Wggshjyt9Pv7jzWhAJ1dGgFYd0qBtAFXspBIkJTOBbVHqke0l
         bG1Mn96hLajMcmOLzou4K5z59vJ/yOHJuDLnEn2ohNfYp4YNwj3ekdUuwymM6dWbflNU
         Ve50hwOCJR5xCJeCoGwCCpbog1ct3fydoEpEGZt35X2PGzPjUQxPp1mlyOTw0MFAUc7b
         VsjKBnMnDcRThgnCJ/0qPBFZBPyH5jF8osWhFYwww+/nFjAJkX8qAidJAPeAi/ukvIY0
         H2QfLntBBi/vXYVA+98F5Rk69VfhPy8QNayC9NMNYIeNSt9e6LuBnFjQQy+ZqNmt9pVt
         CNFQ==
X-Gm-Message-State: APjAAAX6H7KXfHN/jeTRyh32BBJD9mwYLj2aegdXwk+jKrBWs+rPngcN
        PUGcqJSny1o/EhPUaaOkkiSKdaomLKVAuGOXMxuA
X-Google-Smtp-Source: APXvYqyVNlCtvK6jMuhYbWaffsmS7AJRK8nbIrYOgQQn+AtHoF9COViiGhEmY8ABlg31UWfddbQILWg6iz5HwSE9PoQ=
X-Received: by 2002:ac2:4985:: with SMTP id f5mr19551284lfl.90.1553886366749;
 Fri, 29 Mar 2019 12:06:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvQ+KmoBgoxT51SRMpCXZ4OFwg+B1x_SD3DFkcrUcdZQQ@mail.gmail.com>
 <20190328170219.29c72cbf@echidna.suse.de> <CAH2r5mvb=SbYV9Qmt=n_ht7toPgKs03Y2oHXpJE7=_byptstKg@mail.gmail.com>
 <CAH2r5mvyt0rjrtzvZOMeJvHF7FK3LM_pyr7pv2PxzH1n9CxZaQ@mail.gmail.com>
In-Reply-To: <CAH2r5mvyt0rjrtzvZOMeJvHF7FK3LM_pyr7pv2PxzH1n9CxZaQ@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 29 Mar 2019 12:05:55 -0700
Message-ID: <CAKywueRr0pzHAFHe=RrBqHrak+ZgeT0saPb9FeafJtNJsjhuHw@mail.gmail.com>
Subject: Re: [PATCH][smbinfo cifsutils]
To:     Steve French <smfrench@gmail.com>
Cc:     David Disseldorp <ddiss@suse.de>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good, thanks.
--
Best regards,
Pavel Shilovsky

=D0=BF=D1=82, 29 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 11:44, Steve Frenc=
h <smfrench@gmail.com>:
>
> Added man page update for this new smbinfo parm
>
>
> On Fri, Mar 29, 2019 at 3:14 AM Steve French <smfrench@gmail.com> wrote:
> >
> > As requested I changed the buffer size malloced to be more obvious -
> > in this case to match exactly what is returned from the first call (ie
> > snapshot length + the sizeof the snapshot info structure which
> > precedes the snapshot list, ie 16 bytes).  The snapshot array size is
> > 12 bytes, but rounding it to 8 byte boundary causes the minimum to be
> > 16 bytes.
> >
> > On Thu, Mar 28, 2019 at 11:02 AM David Disseldorp <ddiss@suse.de> wrote=
:
> > >
> > > On Thu, 28 Mar 2019 05:05:35 -0500, Steve French wrote:
> > >
> > > > +     /* Now that we know the size, query the list from the server =
*/
> > > > +
> > > > +     /* Make sure the buf size is big enough even to handle unexpe=
cted server behavior */
> > > > +     buf =3D malloc(snap_inf.snapshot_array_size + 300);
> > >
> > > The buffer length calculations seem pretty arbitrary here, wouldn't i=
t
> > > make sense to use something like the following (with a maximum limit)=
?
> > > sizeof(struct smb_snapshot_array) +
> > >         (snap_inf.number_of_snapshots * GMT_TOKEN_LEN)
> > >
> > > Cheers, David
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
