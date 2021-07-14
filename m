Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C28C07E9A
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Jul 2021 06:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C22B6136E
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Jul 2021 06:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238162AbhGNGx7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 14 Jul 2021 02:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238104AbhGNGx6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 14 Jul 2021 02:53:58 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0E8C06175F
        for <linux-cifs@vger.kernel.org>; Tue, 13 Jul 2021 23:51:07 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id t186so1548500ybf.2
        for <linux-cifs@vger.kernel.org>; Tue, 13 Jul 2021 23:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=82D4FTeLAjLdvBc/a8nl3djctU4zlftnltKsQgulRT4=;
        b=P+1MIAXDUAoz0Ij9/o5yAcbNWBBkQIapPLBHiMWMIIMkvEiEFT7glMn8oXTRPyiJ8H
         mggvDB5gB2LfW0Pway0oG432WZgXnTdFpxeXV2S78mC9OUL+hHAg42j4lwiFryh5JLL0
         CsIMm7z2bsBnnUn1WpaKX2gSCIU6NMVuLpXeJPu+A03wy0lcYj3n87I3XX6pN4+4GeVc
         bbGTar4oLApGrsm8L9ydTqwNy6YBB2ylijipwRffRbIGa/kNgr9XJKGY58RuXVW5Dq2G
         Bp+HUMLwHsZ7SWBQYaLfZ+0ZdhwAFhB7yYA1EgxQnnweubqg+Q1putKV+wuY0V42MzAU
         JF7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=82D4FTeLAjLdvBc/a8nl3djctU4zlftnltKsQgulRT4=;
        b=Q7bF0L+3w3txWDFWfcnEMvbQEp9qgzEKxxxdVoUjd33kr7v7ipmHqlCsijwL9QW5jM
         w+37hYaT6hdtCCLCihX0gW2Ap+qiGtXsYAWyWPIuFbRCPxsXrtG9qCRj3r0xbTrRVxzf
         1UBQ36ZXi2LWZGimaaYKKJgr3wMlhCWQZS8ZCafz60e4v6EXNxljgQ1NACmB8efE0QUE
         sc0RJvUzic2ccmtQWdxnRqlrPnxev4KfSH1ELOsP89zB2FUNnMUDjkapeJYtOqGzMDV2
         a2/8F8fI7GINrEDxWmDbYEsWghlTuEW6Fk/PfFuz6R2r4pdqNKFLlx/dXVomFqvknaHo
         hfbA==
X-Gm-Message-State: AOAM530oFvSOdAF80fmXROMJvcDq7Fglnozs3ksPKD0bn3OBcW0aMlDX
        xcK0pu6ioQ/FWEBeqnGrf8y+HT6sxo0INw/eb5E=
X-Google-Smtp-Source: ABdhPJwqRos1/C8h0YoM1C+Pkr+2cjPiWlzLx4io621SvoLOmQgASaSs3vU4QOGTn31vB92NwHDoaS3KXN8IF1un7Kc=
X-Received: by 2002:a25:4209:: with SMTP id p9mr10475967yba.3.1626245466872;
 Tue, 13 Jul 2021 23:51:06 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=pDrNBRQSHAarXzxTRNF9Lo=-q-hsnbBTHJZue=ggGzXw@mail.gmail.com>
 <CAH2r5mvxj-A3F1tPr9OH1D00bdznVYyx7FzyjLZt=Xq41TCVxw@mail.gmail.com>
 <CAKywueR3aTzrC-QM=P3tJ3RuS1AWAPsgcK-eqyX55HYtH-M_bQ@mail.gmail.com> <CAN05THQL3GTN0oG8rREQ3W9bxEoAV+NppbSgAuytdzPyH3cuhA@mail.gmail.com>
In-Reply-To: <CAN05THQL3GTN0oG8rREQ3W9bxEoAV+NppbSgAuytdzPyH3cuhA@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 14 Jul 2021 12:20:56 +0530
Message-ID: <CANT5p=oCJ5MRSVcNHV3-+Jg2TcGc3m785GGJBzScGThkS24eMw@mail.gmail.com>
Subject: Re: cifs.ko page management during reads
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jul 14, 2021 at 5:45 AM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> On Wed, Jul 14, 2021 at 8:58 AM Pavel Shilovsky <piastryyy@gmail.com> wro=
te:
> >
> > =D0=BF=D0=BD, 12 =D0=B8=D1=8E=D0=BB. 2021 =D0=B3. =D0=B2 22:41,Steve Fr=
ench <smfrench@gmail.com>:
> > >
> > > And don't forget "esize" mount option to allow offload of decryption.=
..
> > >
> > > On Tue, Jul 13, 2021, 00:37 Shyam Prasad N <nspmangalore@gmail.com> w=
rote:
> > >>
> > >> Hi all,
> > >>
> > >> I'm trying to understand our read path (big picture is to integrate
> > >> the new netfs helpers into cifs.ko), and I wanted to get some
> > >> understanding about why things are the way they are. @Pavel Shilovsk=
y
> > >> I'm guessing that you've worked on most of this code, so hoping that
> > >> you'll be able to answer some of these:
> >
> > Thanks for taking a look at this.
> >
> > >>
> > >> 1. for cases where both encryption and signing are disabled, it look=
s
> > >> like we read from the socket page-by-page directly into pages and ma=
p
> > >> those to the inode address space
> >
> > Yes, we read directly into pre-allocated pages. For direct IO we read
> > into pages supplied by the user and for non-direct IO (including page
> > IO) we allocate intermediate pages.
> >
> > >>
> > >> 2. for cases where encryption is enabled, we read the encrypted data
> > >> into a set of pages first, then call crypto APIs, which decrypt the
> > >> data in-place to the same pages. We then copy out the decrypted data
> > >> from these pages into the pages in the address space that are alread=
y
> > >> mapped.
> >
> > Correct. Regardless of whether offloading is used or not there is an ex=
tra copy.
> >
> > >>
> > >> 3. similarly for the signing case, we read the data into a set of
> > >> pages first, then verify signature, then copy the pages to the mappe=
d
> > >> pages in the inode address space.
> >
> > Yes.
> >
> > >>
> > >> for case 1, can't we read from the socket directly into the mapped
> > >> pages?
> >
> > Yes - assuming no signing or encryption, we should be able to read
> > directly into the mapped pages. But I doubt many people use SMB2
> > without signing or encryption although there may be some use cases
> > requiring performance over safety.
> >
> > >> for case 2 and 3, instead of allocating temporary pages to read
> > >> into, can't we read directly into the pages of the inode address
> > >> space? the only risk I see is that if decryption or sign verificatio=
n
> > >> fails, it would overwrite the data that is already present in the pa=
ge
> > >> cache. but I see that as acceptable, because we're reading from the
> > >> server, since the data we have in the cache is stale anyways.
> >
> > Theoretically we may try doing this with signing but we need to make
> > sure that no one can modify those pages locally which may lead to
> > signing errors. I don't think today we reconnect an SMB session on
> > those today but we probably should.
> >

How can someone modify those pages? Don't we keep the pages locked
when the read is in progress?

> > For encryption, we do not know where read data starts in an encrypted
> > SMB packet, so there is almost no point to read directly because we
> > would need to shift (copy) the data afterwards anyway.
>

Understood.

> Yes. But even if we knew where the data starts, it will not be aligned
> to a page anyway so we need to memcpy() it anyway.
>
> But I think it is possible, with a lot of effort. And probably not
> worth the effort.
>
> But, I have been toying with the idea of trying to do "zero-copy" SMB2
> READ in libsmb2.
> It, does read all the unencrypted READ payloads straight into the
> application buffer without a copy
> already, but just like cifs.ko it uses an intermediate buffer for
> encrypted packets.And thus an extra memcpy()
>
> The solution I was thinking of would be something like :
> 1, Read the first 4 + 64 bytes into a buffer.  This will be
> enough to hold, either
> 1a, unencrypted case:
>       inspect the SMB2 header to find the opcode, then read the
> response header  (16 bytes for smb2 read/write responses)
>       then read the payload straight into the application buffer.
>       I do this already and it works without too much pain.
>       Now we are finished for the unencrypted case.
> 2, encrypted case:
>       In this case we have the full transform header and also part of
> an encrypted smb2 header.
>       We know how big the transform header is so we can copy the
> partial smb2 header into a 64 byte
>       temp buffer and then read the remaining part of the smb2 header.
> 3,   Start decryption, but only run it for the first 64 bytes, i.e.
> the smb2 header.
> 3a, OPCODE !=3D READ: Inspect the decrypted smb2 header, IF it is NOT a
> read response then just read all remaining data into
>       a temp buffer, continue the decryption and handle it the normal way=
.
> 4,   If the opcode is a READ, then read an additional 16 bytes into a
> temp buffer and continue the decryption of these 16 bytes.
> 5,   What follows now is the read response payload so read this
> decrypted data straight into the application buffer (or pages)
>       and again, continue the decryption and decrypt the data in-place.
>       Voila, zero-copy encrypted read handling.  Which would really
> help on a PS2 since memcpy() is pretty expensive on its very slow
> memory.
>
>
> I think this would work, and it would be very interesting to implement.
> Not sure if it is worth it to do in kernel code because there will be
> hairy special conditions to handle.
>

Very interesting.
Understood that this will be significant changes. But curious as to
what special conditions you're referring to?

>
> For kernel code I think it would be better/safer to have fast hw
> offload for memcpy()
>

Understood.

>
> regards
> ronnie sahlberg
>
>
> >
> > --
> > Best regards,
> > Pavel Shilovsky



--=20
Regards,
Shyam
