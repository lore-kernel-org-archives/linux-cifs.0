Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A7E7C4338F
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Aug 2021 04:46:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6772E610A5
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Aug 2021 04:46:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236420AbhHMErB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 13 Aug 2021 00:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234019AbhHMErB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 13 Aug 2021 00:47:01 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DE7C061756;
        Thu, 12 Aug 2021 21:46:35 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id d6so13484415edt.7;
        Thu, 12 Aug 2021 21:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xkxv6+rPgNFYK0bumQmdFxc99xFlqWZ0vPYKbCDn8/k=;
        b=Kzg19FPkyWXsZFoUcJlKFXqgNZCxjU5l0w2yvoZGadKGRsoud4alyqsDXsDAht79SA
         vp06uvlACdNppSbFEiUcpjoWf/r2o+KmvRaTSOL7sPC2x+S+qRj94p810QJnm47BMOpy
         gyKxuDFBmZplr0/Vg0tAkDD1y5Dbf5n26kDj2DSgPNruRc6lr21uaRm7lUCwQEGqlDls
         SY6cpxc7E/o1nBgrtWAOXpJwPmqi10gMOtG2TYJ/wG8y7shA9n6Tx5b4pow57AywBAlk
         S2El78ZwtrLideuIQK27S4LpDyUHa9Eulc4QvlJPKQuGYV7hc66a5fSu99nRseEcL3Mg
         ngcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xkxv6+rPgNFYK0bumQmdFxc99xFlqWZ0vPYKbCDn8/k=;
        b=ScA/WLIN9HZxT8/2b/T+VngNOnpXyAd/SrVqXCf4gaTNxMNYyoMNLRXayF0eBJee0K
         U8HPVFsagf3jS0EQHsbWw3ScqKZUzbjJU1UHXBLmpUQNGSJlyMDwjUTuITP3dX2OJMdK
         W0JTjnFgHB3pEr+svoJBaF5hvEsGwNZeghkSPSUVDSbwT4qBhgKFm7Sgz2xv2LDcNJwX
         nrn0JZ6Y2O6jvCmtGoVLhAvuZxNvZ7fqbuzo8Xy3hT5utN2NxWqhJ1feof8ekK0lgcVC
         /ZpvH16PuCU5Ne4NoXctConN75cuVjeu1ImVQ7x9qyEeda/1isJLxVVJR9ZRBMW/kptC
         tUaw==
X-Gm-Message-State: AOAM533ay5DHFm9bvYG54c/dXFD34tsPA2/aWBfaaF2ft5KZ53AES4oD
        dLbh1lC4FSCF7AmHwkKpJV+ZeiZAw8OaS7ST8mc=
X-Google-Smtp-Source: ABdhPJz2VhmAjqKpRRUfXVkPaiiPfiNQgQjDqJb79/5r4bZoazl7SM8EcjXa7XtLx9Xcj3mC6RA4Y//JTyRgJUvtKVQ=
X-Received: by 2002:a05:6402:b7a:: with SMTP id cb26mr634654edb.33.1628829993727;
 Thu, 12 Aug 2021 21:46:33 -0700 (PDT)
MIME-Version: 1.0
References: <YRXlwDBfQql36wJx@sol.localdomain>
In-Reply-To: <YRXlwDBfQql36wJx@sol.localdomain>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 13 Aug 2021 14:46:21 +1000
Message-ID: <CAN05THSm5fEcnLKxcsidKPRUC6PVLCkWMBZUW05KNm4uMJNHWw@mail.gmail.com>
Subject: Re: Building cifs.ko without any support for insecure crypto?
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Aug 13, 2021 at 1:34 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> Hi!
>
> We should be working to eliminate any uses of insecure crypto algorithms (e.g.
> DES, ARC4, MD4, MD5) from the kernel.  In particular, it should be possible to
> build a kernel for a modern system without including any such algorithms.
>
> Currently, CONFIG_CIFS is problematic because it selects all these algorithms
> (kconfig options: CONFIG_CRYPTO_LIB_DES, CONFIG_CRYPTO_LIB_ARC4,
> CONFIG_CRYPTO_MD4, CONFIG_CRYPTO_MD5).
>
> It looks like these algorithms might only be used by SMB2.0 and earlier, and the
> more modern SMB versions don't use them.  Is that the case?  It mostly looks
> like that, but there's one case I'm not sure about -- there's a call chain which
> appears to use ARC4 and HMAC-MD5 even with the most recent SMB version:
>
>     smb311_operations.sess_setup()
>       SMB2_sess_setup()
>         SMB2_sess_auth_rawntlmssp_authenticate()
>           build_ntlmssp_auth_blob()
>             setup_ntlmv2_rsp()

md4 and md5 are used with the NTLMSSP authentication for all dialects,
including the latest 3.1.1.
The only other authentication mechanism for SMB is krb5.

This means that if we build a kernel without md4/md5 then we can no
longer use NTLMSSP user/password
style authentication, only kerberos.
I guess that the use cases where a kernel without these algorithms are
present are ok with kerberos as the
only authentication mech.

Afaik arc4 is only used for signing in the smb1 case.

>
> Also, there's already an option CONFIG_CIFS_ALLOW_INSECURE_LEGACY=n which
> disables support for SMB2.0 and earlier.  However, it doesn't actually compile
> out the code but rather just prevents it from being used.  That means that the
> DES and ARC4 library interfaces are still depended on at link time, so they
> can't be omitted.  Have there been any considerations towards making
> CONFIG_CIFS_ALLOW_INSECURE_LEGACY=n compile out the code for SMB2.0 and earlier?

I think initially we just wanted to disable its use. If we want to
compile a kernel completely without arc4/md4/md5 I think we would need
to:

1, Change CONFIG_CIFS_ALLOW_INSECURE_LEGACY=n to compile out the code
as you suggests.
This should remove the dependency for arc4. I think this would be a
good thing to do.

2, Have a different CONFIG_... to compile out the use of NTLMSSP
authentication. This must be a different define
since md4/md5 are also used for non-legacy dialects.
And this should remove the dependency of md4/5.

For the latter, I guess we would need a global, i.e. not
cifs-specific, config option for this. I assume other users of
rc4/md4/md5
would also want this.
A new CONFIG_INSECURE_CRYPTO=n ?

Ronnie Sahlberg

>
> - Eric
