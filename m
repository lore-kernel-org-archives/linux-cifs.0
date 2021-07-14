Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C272C07E95
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Jul 2021 00:15:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F2FE6128C
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Jul 2021 00:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237113AbhGNASS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Jul 2021 20:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236981AbhGNASR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Jul 2021 20:18:17 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34606C0613EE
        for <linux-cifs@vger.kernel.org>; Tue, 13 Jul 2021 17:15:26 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id o5so231552ejy.7
        for <linux-cifs@vger.kernel.org>; Tue, 13 Jul 2021 17:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pV8TLkIm18kzqeSazBXDYDS3UNRXyk80X0MU+3ArHLw=;
        b=A9TEU8B02DAJIEQC8SudaKLGjOsIp2RJRvKTyan2manVD/ponRIEF7yc9aIzZdGRpx
         ObXYrOlooJ9LGuWQyUQEjhUD5nP80d6QSx59xQQ6rvABo5Jb8aznDnhKeeKiVuTadh17
         OEPEzIFFctkpDRfdzsadD5kGm47wRW/KDUVr4uy8F5BebenlxRLZdpl+a2HmEquIEuGa
         D1HIVCF3/5MnnIRpJupK3AK9+3EyYHGYOCpBMHwchcEn23qOaPprN3IjFOMG/rNuWMRx
         1Iq824vjSpEDIU3zC4AUl3qJinH97eCcSiFs00bFAHq59sJN5mn6oAE1emsgOa7WfXzF
         ApVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pV8TLkIm18kzqeSazBXDYDS3UNRXyk80X0MU+3ArHLw=;
        b=JOb/pcNadyN8AhO8KZZvYA4oDEfnJXeePgc/IEebaxWygIwXGx5cQZctHeddjZG5wO
         pzn3S/iNRIFAk4ia+AaxgWgSRPBbb5jJgdn1oNDBzQTWdD8/eCV7NMQRu3uGxfyFDu4g
         bMUk3VJJZz9g0s3qT+Dq+0KPUdwshOeWPInWTL5+rGl7nfFIe/6Bxa/ws6KeksxXFXJP
         XnudSpgDRJtFH87OCFU3SBf9ZU6dOivSi71uBdu4nK01nlt3TXNESNxHmJbvUwO0AMUp
         dt/as71PZDU6e3k+nAVe44vSaDa7KthlJIMLFrq6KnYkTKhXGxD+EW6jt6GzNQ59SOrk
         Fxdg==
X-Gm-Message-State: AOAM530cJ46Id2iU61GOebNUUY4rxAtpB+jsPAu5SoYx2JgAijIeJn+A
        t6kwlgBgWQleS0U4q9vUeEop8HAawcd6kZ6IuiQ=
X-Google-Smtp-Source: ABdhPJwWVLHjeN4hI0c/Cs+dxN+ccHjQwXGNwAN+5mMWdxh42kyyFnAaN+99ph665MB3dfEQxyBuPeLMpKrUETD8VSY=
X-Received: by 2002:a17:906:2da1:: with SMTP id g1mr8780247eji.47.1626221724729;
 Tue, 13 Jul 2021 17:15:24 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=pDrNBRQSHAarXzxTRNF9Lo=-q-hsnbBTHJZue=ggGzXw@mail.gmail.com>
 <CAH2r5mvxj-A3F1tPr9OH1D00bdznVYyx7FzyjLZt=Xq41TCVxw@mail.gmail.com> <CAKywueR3aTzrC-QM=P3tJ3RuS1AWAPsgcK-eqyX55HYtH-M_bQ@mail.gmail.com>
In-Reply-To: <CAKywueR3aTzrC-QM=P3tJ3RuS1AWAPsgcK-eqyX55HYtH-M_bQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 14 Jul 2021 10:15:13 +1000
Message-ID: <CAN05THQL3GTN0oG8rREQ3W9bxEoAV+NppbSgAuytdzPyH3cuhA@mail.gmail.com>
Subject: Re: cifs.ko page management during reads
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Jul 14, 2021 at 8:58 AM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> =D0=BF=D0=BD, 12 =D0=B8=D1=8E=D0=BB. 2021 =D0=B3. =D0=B2 22:41,Steve Fren=
ch <smfrench@gmail.com>:
> >
> > And don't forget "esize" mount option to allow offload of decryption...
> >
> > On Tue, Jul 13, 2021, 00:37 Shyam Prasad N <nspmangalore@gmail.com> wro=
te:
> >>
> >> Hi all,
> >>
> >> I'm trying to understand our read path (big picture is to integrate
> >> the new netfs helpers into cifs.ko), and I wanted to get some
> >> understanding about why things are the way they are. @Pavel Shilovsky
> >> I'm guessing that you've worked on most of this code, so hoping that
> >> you'll be able to answer some of these:
>
> Thanks for taking a look at this.
>
> >>
> >> 1. for cases where both encryption and signing are disabled, it looks
> >> like we read from the socket page-by-page directly into pages and map
> >> those to the inode address space
>
> Yes, we read directly into pre-allocated pages. For direct IO we read
> into pages supplied by the user and for non-direct IO (including page
> IO) we allocate intermediate pages.
>
> >>
> >> 2. for cases where encryption is enabled, we read the encrypted data
> >> into a set of pages first, then call crypto APIs, which decrypt the
> >> data in-place to the same pages. We then copy out the decrypted data
> >> from these pages into the pages in the address space that are already
> >> mapped.
>
> Correct. Regardless of whether offloading is used or not there is an extr=
a copy.
>
> >>
> >> 3. similarly for the signing case, we read the data into a set of
> >> pages first, then verify signature, then copy the pages to the mapped
> >> pages in the inode address space.
>
> Yes.
>
> >>
> >> for case 1, can't we read from the socket directly into the mapped
> >> pages?
>
> Yes - assuming no signing or encryption, we should be able to read
> directly into the mapped pages. But I doubt many people use SMB2
> without signing or encryption although there may be some use cases
> requiring performance over safety.
>
> >> for case 2 and 3, instead of allocating temporary pages to read
> >> into, can't we read directly into the pages of the inode address
> >> space? the only risk I see is that if decryption or sign verification
> >> fails, it would overwrite the data that is already present in the page
> >> cache. but I see that as acceptable, because we're reading from the
> >> server, since the data we have in the cache is stale anyways.
>
> Theoretically we may try doing this with signing but we need to make
> sure that no one can modify those pages locally which may lead to
> signing errors. I don't think today we reconnect an SMB session on
> those today but we probably should.
>
> For encryption, we do not know where read data starts in an encrypted
> SMB packet, so there is almost no point to read directly because we
> would need to shift (copy) the data afterwards anyway.

Yes. But even if we knew where the data starts, it will not be aligned
to a page anyway so we need to memcpy() it anyway.

But I think it is possible, with a lot of effort. And probably not
worth the effort.

But, I have been toying with the idea of trying to do "zero-copy" SMB2
READ in libsmb2.
It, does read all the unencrypted READ payloads straight into the
application buffer without a copy
already, but just like cifs.ko it uses an intermediate buffer for
encrypted packets.And thus an extra memcpy()

The solution I was thinking of would be something like :
1, Read the first 4 + 64 bytes into a buffer.  This will be
enough to hold, either
1a, unencrypted case:
      inspect the SMB2 header to find the opcode, then read the
response header  (16 bytes for smb2 read/write responses)
      then read the payload straight into the application buffer.
      I do this already and it works without too much pain.
      Now we are finished for the unencrypted case.
2, encrypted case:
      In this case we have the full transform header and also part of
an encrypted smb2 header.
      We know how big the transform header is so we can copy the
partial smb2 header into a 64 byte
      temp buffer and then read the remaining part of the smb2 header.
3,   Start decryption, but only run it for the first 64 bytes, i.e.
the smb2 header.
3a, OPCODE !=3D READ: Inspect the decrypted smb2 header, IF it is NOT a
read response then just read all remaining data into
      a temp buffer, continue the decryption and handle it the normal way.
4,   If the opcode is a READ, then read an additional 16 bytes into a
temp buffer and continue the decryption of these 16 bytes.
5,   What follows now is the read response payload so read this
decrypted data straight into the application buffer (or pages)
      and again, continue the decryption and decrypt the data in-place.
      Voila, zero-copy encrypted read handling.  Which would really
help on a PS2 since memcpy() is pretty expensive on its very slow
memory.


I think this would work, and it would be very interesting to implement.
Not sure if it is worth it to do in kernel code because there will be
hairy special conditions to handle.


For kernel code I think it would be better/safer to have fast hw
offload for memcpy()


regards
ronnie sahlberg


>
> --
> Best regards,
> Pavel Shilovsky
