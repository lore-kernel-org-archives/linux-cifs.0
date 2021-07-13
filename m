Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64976C07E95
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Jul 2021 22:58:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4108161288
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Jul 2021 22:58:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbhGMXBI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Jul 2021 19:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235417AbhGMXBH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Jul 2021 19:01:07 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D7DC0613DD
        for <linux-cifs@vger.kernel.org>; Tue, 13 Jul 2021 15:58:16 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id gn32so16641ejc.2
        for <linux-cifs@vger.kernel.org>; Tue, 13 Jul 2021 15:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xz8vftRy9wmu25OjXAXAx4zolXeFQVXrgP0Hs5UctwI=;
        b=am2TsIhXh5aFjpl4u9yY8hqxMRB2reiRfQPJ/5dOe/eAtXEsIxRNny0JjACYyjGDHn
         0N/XyPsjgKwlB4gu2cUEb6ny6wXf67I/zWKzP5jG6ZO1XRJJ6T++RPpB1YcxMkwDensI
         tw+bpkohbhxZ6oumscRO4Qa8CRHhQ4/cwW04CwsFtf90sRuQgBqqaNfCzq4mLmqzCiDH
         m37SYcNsRO4zcQv3uo/1yBiyQBScQ0ELk01lPPIhoxQNZbZF1CDPe7l4m0CpL8xn3bLN
         wJjytp2wb9O02goMBU/Ey1lGfvaWXbpx7kvBvfeilEWvPFM7diWiQYkaP2o5RF1Nq4RX
         xw2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xz8vftRy9wmu25OjXAXAx4zolXeFQVXrgP0Hs5UctwI=;
        b=i1nU5g9r/nxZCfkKvEbUb0bQ3W0s7BfBEnxB9fpEJ3xJXLIrllgh+rUwNRaR69R9lR
         gq+LG4ix1QwNLIUmtpSGcLyZGjiUGA2z8Stiz1mrv72v6HwSvE6k0B5EA4LaG5QtkfQB
         /rG63tcZn5p6rMRrgawQ86c/YfdzPeQU2qPueFfE5psLhqaK8z94xthkZ/RsbFPcdQ8n
         n2VXrnZDgo+FkXwq1lKqBdYZ64A0RGIQfrjw5QF8bGTiN6s0XjhMiPjPDypSIrOEHIza
         ROY3egC6X/ibu2rQN2k3RLBuZuxQuPs7cMGVKzcnnH8QS+JQfXcQ5weGxi8Kyx8TFeqh
         5r/g==
X-Gm-Message-State: AOAM530VKad+nZz1AFvp8BjJ8ZgDehEEWepHPc/MfDTDM3BR0IouBPnk
        L/uLQsK1j9CEn0gY7MdRyUSSCz17xy6YcaRe7Q==
X-Google-Smtp-Source: ABdhPJytNw7SOKBwk71dE48GQUKmasK24zsIIMQ/OHVVf2WtSU0xKSnFg+bpS3LW4/NBMHW3KVj0iiWLKvkbnc4oH44=
X-Received: by 2002:a17:906:3ed4:: with SMTP id d20mr8591357ejj.515.1626217094622;
 Tue, 13 Jul 2021 15:58:14 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=pDrNBRQSHAarXzxTRNF9Lo=-q-hsnbBTHJZue=ggGzXw@mail.gmail.com>
 <CAH2r5mvxj-A3F1tPr9OH1D00bdznVYyx7FzyjLZt=Xq41TCVxw@mail.gmail.com>
In-Reply-To: <CAH2r5mvxj-A3F1tPr9OH1D00bdznVYyx7FzyjLZt=Xq41TCVxw@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 13 Jul 2021 15:58:03 -0700
Message-ID: <CAKywueR3aTzrC-QM=P3tJ3RuS1AWAPsgcK-eqyX55HYtH-M_bQ@mail.gmail.com>
Subject: Re: cifs.ko page management during reads
To:     Steve French <smfrench@gmail.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 12 =D0=B8=D1=8E=D0=BB. 2021 =D0=B3. =D0=B2 22:41, Steve Frenc=
h <smfrench@gmail.com>:
>
> And don't forget "esize" mount option to allow offload of decryption...
>
> On Tue, Jul 13, 2021, 00:37 Shyam Prasad N <nspmangalore@gmail.com> wrote=
:
>>
>> Hi all,
>>
>> I'm trying to understand our read path (big picture is to integrate
>> the new netfs helpers into cifs.ko), and I wanted to get some
>> understanding about why things are the way they are. @Pavel Shilovsky
>> I'm guessing that you've worked on most of this code, so hoping that
>> you'll be able to answer some of these:

Thanks for taking a look at this.

>>
>> 1. for cases where both encryption and signing are disabled, it looks
>> like we read from the socket page-by-page directly into pages and map
>> those to the inode address space

Yes, we read directly into pre-allocated pages. For direct IO we read
into pages supplied by the user and for non-direct IO (including page
IO) we allocate intermediate pages.

>>
>> 2. for cases where encryption is enabled, we read the encrypted data
>> into a set of pages first, then call crypto APIs, which decrypt the
>> data in-place to the same pages. We then copy out the decrypted data
>> from these pages into the pages in the address space that are already
>> mapped.

Correct. Regardless of whether offloading is used or not there is an extra =
copy.

>>
>> 3. similarly for the signing case, we read the data into a set of
>> pages first, then verify signature, then copy the pages to the mapped
>> pages in the inode address space.

Yes.

>>
>> for case 1, can't we read from the socket directly into the mapped
>> pages?

Yes - assuming no signing or encryption, we should be able to read
directly into the mapped pages. But I doubt many people use SMB2
without signing or encryption although there may be some use cases
requiring performance over safety.

>> for case 2 and 3, instead of allocating temporary pages to read
>> into, can't we read directly into the pages of the inode address
>> space? the only risk I see is that if decryption or sign verification
>> fails, it would overwrite the data that is already present in the page
>> cache. but I see that as acceptable, because we're reading from the
>> server, since the data we have in the cache is stale anyways.

Theoretically we may try doing this with signing but we need to make
sure that no one can modify those pages locally which may lead to
signing errors. I don't think today we reconnect an SMB session on
those today but we probably should.

For encryption, we do not know where read data starts in an encrypted
SMB packet, so there is almost no point to read directly because we
would need to shift (copy) the data afterwards anyway.

--
Best regards,
Pavel Shilovsky
