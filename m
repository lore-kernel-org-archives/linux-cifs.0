Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F6BC4338F
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Aug 2021 16:41:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 850726101A
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Aug 2021 16:41:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbhHXQl7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Aug 2021 12:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbhHXQl6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 24 Aug 2021 12:41:58 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EE6C061757;
        Tue, 24 Aug 2021 09:41:14 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id o10so46807599lfr.11;
        Tue, 24 Aug 2021 09:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aSziwwwdyIEOJ4mYpFaEyyynDBylrGdfxWjE78omM94=;
        b=DCMmJs4FRG79pqa2rFUGIv1mI88LNPFRfH2H3rCOUVKwIzKqHGC+5U1glL5+Yp8/Cu
         WpqwYj/8GWmDxLMsEyOasYKwMr6QNRYxcOBKYMLJhRwXSnoQ6eRxmfYW3wv1No5d/JBe
         Uo8pM1XuZ6G33c06ZYp0iZUz5JwzZAMlMjB+ld+DkY4Kk9paDbwS7Pi7JRUgxCmMgqFg
         slGFdFrgvOXSv/o23LL3YYIe1Y0/yY//9PLZwr0c0PQ5b0yiQPuqEgZ7EwMo/FRC1iN0
         Tnd6yMAG/hqzagdMGxE4whdKhVAuZKjlXo1R5HQMJDpjOIYWUXux5Y8SZv8iBjpPQmCz
         DclA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aSziwwwdyIEOJ4mYpFaEyyynDBylrGdfxWjE78omM94=;
        b=LSZNEowWI438vAkhWHLFvO01p9vDxh+xL+Bk1eKhF9fA8iW+pwgTrSSQ3LAQecfpbC
         o3TQ8G4CT4UshaVQZFjou1vAVlY5TPfIM8s7ANMC2jPL3ywd9tbCpaJDlUqQQkDbipg3
         VOj3a6DJYU4byQJiL4Ql0K09XRQG/WfaC6z3FH5PubdvdmcQHdfU73Kjgm/ZEw1VTWuJ
         aThkNml3zkuvFS9z/1plxCatoleFObIVDRIvx72wqdMt+BDSV61yI4NWNdgUaThRXH6o
         Wp4AujmcLcySHSLr8o5kY6NBtoao8YLAtskGTIHDhIAUxsvb09gpdX33ONCL/r2+8FB9
         GmAQ==
X-Gm-Message-State: AOAM533bQCT6cQYs1U7apx1hQyxSqO915O4186k0Yk81TqlvJJUYERev
        ccRV8rr5pM/xEaV9/L9gF0yE0QxGX3Td/7/AEXw=
X-Google-Smtp-Source: ABdhPJx05vOHbejCKOArldt/GrSeSIg5FEQsOgVl5tYNq+RPz63GDpgaJzlNqDIHHaZ38bIfDvCTpAz7z3Edcq+N724=
X-Received: by 2002:ac2:4561:: with SMTP id k1mr5393956lfm.313.1629823272322;
 Tue, 24 Aug 2021 09:41:12 -0700 (PDT)
MIME-Version: 1.0
References: <YRXlwDBfQql36wJx@sol.localdomain> <CAN05THSm5fEcnLKxcsidKPRUC6PVLCkWMBZUW05KNm4uMJNHWw@mail.gmail.com>
 <YRbT7IbSCXo4Dl0u@sol.localdomain> <CAN05THScNOVh5biQnqM8YDOvNid4Dh=wZS=ObczzmSEpv1LpRw@mail.gmail.com>
 <YRrkhzOARiT6TqQA@gmail.com> <CAMj1kXH93HU5SNUDLpn+c0ryJUYWpRKVXeoPK8jPOSwiS3_79A@mail.gmail.com>
 <CAN05THS27h9QFpNuVVQmqz8k8_SKD8V8TbzZVYxco7S86i0zWA@mail.gmail.com> <627872ec0f8cc52a06f8f58598f96b72b5b9645a.camel@redhat.com>
In-Reply-To: <627872ec0f8cc52a06f8f58598f96b72b5b9645a.camel@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 24 Aug 2021 11:41:01 -0500
Message-ID: <CAH2r5mtsgYXi2VxQZ5bDLdsAgmgjgJVqeXUxe5Sb1CiA_RyFQA@mail.gmail.com>
Subject: Re: Building cifs.ko without any support for insecure crypto?
To:     Simo Sorce <simo@redhat.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Aug 23, 2021 at 5:05 AM Simo Sorce <simo@redhat.com> wrote:
<snip>
> Another way to handle this part is to calculate the hash in userspace
> and handle the kernel just the hashes. This would allow you to remove
> MD4 from the kernel. I guess it would break putting a password on the
> kernel command line, but is that really a thing to do? Kernels do not
> boot from cifs shares so you can always use userspace tools (or pass
> hexed hashes directly on the command line in a pinch).

We can boot from cifs (and given the security features of SMB3.1.1 it probably
makes more sense than some of the alternatives) albeit with some POSIX
restrictions unless booting from ksmbd with POSIX extensions enabled.
Paulo added the support for booting from cifs.ko in the 5.5 kernel.


> > I have patches for both DES removal and forking ARC4 prepared for linux-cifs.
> > MD4 will require more work since we use it via the crypto_alloc_hash()
> > api but we will do that too.
> >
> > What about MD5? Is it also scheduled for removal? if so we will need
> > to fork it too.
>
> MD5 is still used for a ton of stuff, however it may make sense to
> consider moving it in /lib and our of /lib/crypto as it is not usable
> in cryptographic settings anymore anyway.

Seems reasonable

-- 
Thanks,

Steve
