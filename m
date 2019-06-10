Return-Path: <SRS0=PPE7=UJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E220C43218
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Jun 2019 18:02:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4374F207E0
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Jun 2019 18:02:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="z5hPzYT2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388509AbfFJSCd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 10 Jun 2019 14:02:33 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38198 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388411AbfFJSCd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 10 Jun 2019 14:02:33 -0400
Received: by mail-io1-f66.google.com with SMTP id k13so7614906iop.5
        for <linux-cifs@vger.kernel.org>; Mon, 10 Jun 2019 11:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lu5N6/KNKD5VUMrQnVAhjjyYsb/Sww0cQNsD4HFG8x0=;
        b=z5hPzYT2Cdbtva6C58RE41cxsrcMsv0vxVCPx4m2X2A/lgngiPmRmtP3bScRThxGoA
         ReyWGClTftzlU4GHQ5fCVB4b75b2pFiH4japkADHJIcsst+9HuIsliuzKvebha22eUwW
         dwSZBJvN6f2rh720IMcjhI4ZvjVYFWhjd91X/Y9u06dgGPQK3mggUeshMMxWc12o9sfz
         W4UDRnK5sZrc9atVMjVJcBejVjzIX3pniK0vUlK7o7Fsuft+O13LazxrqPnikfih+z4B
         a8jeZ1Ge8jBzB+48Uc+PsHtmy5Il+rOqvre1/rPTSD5s2YLLqQ4BFSz1D7X7XW6snjWp
         6ZGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lu5N6/KNKD5VUMrQnVAhjjyYsb/Sww0cQNsD4HFG8x0=;
        b=La4oPKQN+v2pQZaiD+jvR0W0hPCsabmaBEs4zwCrrFbkqueISCCnP/RWOtySFQy6F5
         Y3sKQswFzMVlAuYWaeKZAuq/1bb4W6dxql226di3OmKFREvmpGCrmzbVxioVZJtiXL8f
         fnf91MRegM3LORZ54YAquswqIUUC/xQynzWiBoOkCwxUb6g8L1Dam5eoRchnJfLub1O0
         dzx+veFY2JdYs+GwiFQDaa5VtdtOwiYifHEXbN7lkjoeXY6Kp1X0gz/9sn6sB2L0R8qG
         ZwRbJw4ICy14JDADCmPVvnHDGmDA9Lxc7JBKFFAcRyxRlnL/kw84E1SEVMge1vYuwbfO
         y9+g==
X-Gm-Message-State: APjAAAVTM3oAalZoE8CdKSdXoDOw31EKOhjMJHuq53gdePEv1NUv9qzc
        1gnk5+M0joTa7Apt2m0Fn7zCTRGUBd1l8LmRqFRlSA==
X-Google-Smtp-Source: APXvYqzUnWMa+z+DRqz2950vmd2LSpei9FFUcY/5BboA6W08ZPUTd64l5PXt5AsdkJhMfvGWJ50cBsiFnuF38jxh1nw=
X-Received: by 2002:a05:6602:98:: with SMTP id h24mr102795iob.49.1560189752879;
 Mon, 10 Jun 2019 11:02:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190609115509.26260-1-ard.biesheuvel@linaro.org>
 <20190609115509.26260-8-ard.biesheuvel@linaro.org> <CAH2r5mvQmY8onx6y2Y1aJOuWP9AsK52EJ=cXiJ7hdYPWrLp6uA@mail.gmail.com>
 <20190610161736.GB63833@gmail.com> <CAH2r5mu+87PZEZTMKsaFKDg9Z4i4axB6g9BA8JW823dFKWmSuQ@mail.gmail.com>
In-Reply-To: <CAH2r5mu+87PZEZTMKsaFKDg9Z4i4axB6g9BA8JW823dFKWmSuQ@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 10 Jun 2019 20:02:20 +0200
Message-ID: <CAKv+Gu8n2Vc5uE6Q0V+Hu8swB5Oxp9ViEQXTQqFqSHHKw7NGsQ@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] fs: cifs: switch to RC4 library interface
To:     Steve French <smfrench@gmail.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        CIFS <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, 10 Jun 2019 at 19:54, Steve French <smfrench@gmail.com> wrote:
>
> On Mon, Jun 10, 2019 at 11:17 AM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > Hi Steve,
> >
> > On Sun, Jun 09, 2019 at 05:03:25PM -0500, Steve French wrote:
> > > Probably harmless to change this code path (build_ntlmssp_auth_blob is
> > > called at session negotiation time so shouldn't have much of a
> > > performance impact).
> > >
> > > On the other hand if we can find optimizations in the encryption and
> > > signing paths, that would be really helpful.   There was a lot of
> > > focus on encryption performance at SambaXP last week.
> > >
> > > Andreas from Redhat gave a talk on the improvements in Samba with TLS
> > > implementation of AES-GCM.   I added the cifs client implementation of
> > > AES-GCM and notice it is now faster to encrypt packets than sign them
> > > (performance is about 2 to 3 times faster now with GCM).
> > >
> > > On Sun, Jun 9, 2019 at 6:57 AM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > > >
> > > > The CIFS code uses the sync skcipher API to invoke the ecb(arc4) skcipher,
> > > > of which only a single generic C code implementation exists. This means
> > > > that going through all the trouble of using scatterlists etc buys us
> > > > very little, and we're better off just invoking the arc4 library directly.
> >
> > This patch only changes RC4 encryption, and to be clear it actually *improves*
> > the performance of the RC4 encryption, since it removes unnecessary
> > abstractions.  I'd really hope that people wouldn't care either way, though,
> > since RC4 is insecure and should not be used.
> >
> > Also it seems that fs/cifs/ supports AES-CCM but not AES-GCM?
> >
> > /* pneg_ctxt->Ciphers[0] = SMB2_ENCRYPTION_AES128_GCM;*/ /* not supported yet */
> >         pneg_ctxt->Ciphers[0] = SMB2_ENCRYPTION_AES128_CCM;
> >
> > AES-GCM is usually faster than AES-CCM, so if you want to improve performance,
> > switching from CCM to GCM would do that.
> >
> > - Eric
>
> Yes - when I tested the GCM code in cifs.ko last week (the two patches
> are currently
> in the cifs-2.6.git for-next branch and thus in linux-next and are
> attached), I was astounded
> at the improvement - encryption with GCM is now faster than signing,
> and copy is more
> than twice as fast as encryption was before with CCM (assuming a fast
> enough network so
> that the network is not the bottleneck).  We see more benefit in the write path
> (copy to server) than the read path (copy from server) but even the
> read path gets
> 80% benefit in my tests, and with the addition of multichannel support
> in the next
> few months, we should see copy from server on SMB3.1.1 mounts
> improving even more.
>

I assume this was tested on high end x86 silicon? The CBCMAC path in
CCM is strictly sequential, so on systems with deep pipelines, you
lose a lot of speed there. For arm64, I implemented a CCM driver that
does the encryption and authentication in parallel, which mitigates
most of the performance hit, but even then, you will still be running
with a underutilized pipeline (unless you are using low end silicon
which only has a 2 cycle latency for AES instructions)

> Any other ideas how to improve the encryption or signing in the read
> or write path
> in cifs.ko would be appreciated.   We still are slower than Windows, probably in
> part due to holding mutexes longer in sending the frame across the network
> (including signing or encryption) which limits parallelism somewhat.
>

It all depends on whether crypto is still the bottleneck in this case.
