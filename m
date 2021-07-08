Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BDF8C07E96
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 23:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0534D61457
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 23:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbhGHXQo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Jul 2021 19:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhGHXQn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Jul 2021 19:16:43 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B70C061574
        for <linux-cifs@vger.kernel.org>; Thu,  8 Jul 2021 16:14:00 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id he13so12549781ejc.11
        for <linux-cifs@vger.kernel.org>; Thu, 08 Jul 2021 16:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5GPzH47x8ZRY0lxryJnF9OGMKEB7+hx1KBY7B1JmtAc=;
        b=Kqtluh0q3I56KvpTZpYJjX8c3lfncrZp0UDF7tzY7ePrHL2tZUzyaZLshcGiGjU2iM
         p12YTbzsT8WSweq8vV53UNN6WHBm1NdeH/94n+SVYRbtD/k2C7htx0A+jKbWKHazA0rc
         MV1g4st6CfuwsqHV1Vs8DOJGND/TSeNJQah7UEgJyll7nhFmTGdWv38MiFQ/cKCTo2l4
         s8AaXuWzc/udoMIuMxJ2hgykghuenStXKova3TsxmeVUCxo9jI+HPbdF0AcQ3zEIFgGd
         qBB2OPx/bk9Bb5Lt8gtJXB49DCMzpSlhe49/7aU8WVESI6PBydX30lKWTHj/bJdte3Cr
         8L3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5GPzH47x8ZRY0lxryJnF9OGMKEB7+hx1KBY7B1JmtAc=;
        b=CZbmUYpSSIo1hUgdbGFsOSyDzni3s59RiThzgE5ikWCqLCi5SG9QB4DTzmXxSeqXk2
         6QyDaNbP9CVvJkLI9llsNZRQreygqEkOGHUNiOXW6Bq32+OSYtHZkSQXTeD+lkRuTMp9
         A7gLSOnsVV71ixrJ44CmuC7RVHafOH8b7yt9UwRYbpSReFrNo1OZ4EWRtCRv+bT6fHQD
         x3aAUv42mYanFfnU+EOjtTCzZcgo184xX6Rr2AnctBLnJPkD9uJwNic4GQDdUMVxp9Yp
         pYAMDlPv8NHkFez5guUnkh+UPLj9dyo4IcFiogbLdClzZwMkZIF5jKPA/WxQIZ2ygKmc
         4GGg==
X-Gm-Message-State: AOAM530+YSHTCGnKspvxbXYR9M+40m/zWAgpsl+kl9xRT4eg6ABFncoy
        izrssdfcsVgOSfZ6nBclsJFD8ywG7Yy1mc1Vzg==
X-Google-Smtp-Source: ABdhPJycB82iXTL6qBLnCNs9rKHJAF98dPn542mFsvmKmIzw1B5eZ2beA3tvHJ311ep25CqRxHjcIBDcJWkgKYeczkg=
X-Received: by 2002:a17:906:3ed4:: with SMTP id d20mr34388692ejj.515.1625786039317;
 Thu, 08 Jul 2021 16:13:59 -0700 (PDT)
MIME-Version: 1.0
References: <871r9ktfli.fsf@suse.com>
In-Reply-To: <871r9ktfli.fsf@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 8 Jul 2021 16:13:48 -0700
Message-ID: <CAKywueS+dusKVAw0vC_SV_+rY2N2QpOXZCG0XWBc6fsX37ytzw@mail.gmail.com>
Subject: Re: [PATCH cifs-utils] fix regression for kerberos mount after CVE fix
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks for the patch! Merged the patch into next on github.
--
Best regards,
Pavel Shilovsky

=D1=81=D1=80, 2 =D0=B8=D1=8E=D0=BD. 2021 =D0=B3. =D0=B2 09:07, Aur=C3=A9lie=
n Aptel <aaptel@suse.com>:
>
> Hi,
>
> I see that the fix for the CVE regression is not in Pavel's repo. Could
> you merge it please? We've been running it for suse customers for over a
> month with no problems.
>
> See patch file here
>
> https://build.opensuse.org/package/view_file/openSUSE:Factory/cifs-utils/=
0001-cifs.upcall-fix-regression-in-kerberos-mount.patch?expand=3D1
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>
