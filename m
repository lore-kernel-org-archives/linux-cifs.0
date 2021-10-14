Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 141D4C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Oct 2021 10:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEE86610D0
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Oct 2021 10:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhJNKoD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Oct 2021 06:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhJNKoC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Oct 2021 06:44:02 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978F5C061570
        for <linux-cifs@vger.kernel.org>; Thu, 14 Oct 2021 03:41:57 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id z20so22500954edc.13
        for <linux-cifs@vger.kernel.org>; Thu, 14 Oct 2021 03:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=PmFvocnv0o/Zzee6LPyIglqGy1MwTWb9E6dtnPse8gE=;
        b=pvdJlLxK1nt4cMzxkcC3N/kYccKJyO30LQmNlsnKuPkUj5yTMhx02nm7mNn4RIY18A
         qpw1KJ4Q6Er+Yp1fD26GhhSAkzNeOFJQnvOE4ve9rAWbKofI8m5iaWbk5yyVi8fEWjkj
         vHI7vKB115KTGZlgBnuKI2eQHlLnSiN3fsf8s/gkZdSp6rlxBt9w8hV67us4Hy2AdLM6
         vYomrZ3qx6GHHm7AEHH+fvd3fFo+4RBZKtpMyU8WapFBUYgp02SttE5fhWdnPztMZVDx
         rJGbIK/VdDLgbR0u55958F+I5Jo3qZuNDIcKxPy96JNloxvLaGcrbss3BXdTx66KAf4x
         +GRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=PmFvocnv0o/Zzee6LPyIglqGy1MwTWb9E6dtnPse8gE=;
        b=j8hSOnn3vDFzliCN0bO1wAeGLiAZ6md8FPU5PW+P1LSZ4oS0qugUJOhJLLmta2kDEP
         m5yVAr8w3HhIIWkq/XzyHGix5Box4pFJ1NJ60mAtQ4gI7/zIAeIqVcCc384AtxLxTtQf
         Rbx/5tx2OzUtB9mQkQRLo/jU08Kslqi+pioDs/Jk0svYAEKRxmbEO+LYAb54pbO8U84u
         jUIgOyl97CFUpFXXRZ0/OEMU0ZmU3Iypqqykb8gP/jRBmjhxclwsHItHgrAh26jyVxD4
         tTMpLlPAzbs/u1FuDHiXQ1jJsVce1H3GNSaaBVk/CjD0nkeS189mGkhb7EK+JPx2yrf2
         vEAg==
X-Gm-Message-State: AOAM530VSsh0xc5Xbwjmx2fJUrjtyEOQBv6Z/cT8bYFe6ywn6Bfda0tw
        1gEYfgGyw1j+DiqQnb8U/+00ESc5dwnM/6DIVBk=
X-Google-Smtp-Source: ABdhPJzHzcm9ekrQwHKvFgxXnTPJzGr/CsRUxGRKCWMVqkX7lWlrSRE7U79EYcJ2wLmAzFO2zGQz0xT2OvPCKl8V8OA=
X-Received: by 2002:a17:906:4fc7:: with SMTP id i7mr3058830ejw.14.1634208116051;
 Thu, 14 Oct 2021 03:41:56 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=qBKEj5Nz_5Vwj0WWL7-V_78j6Fry5OjvDXGCrejnsu3Q@mail.gmail.com>
In-Reply-To: <CANT5p=qBKEj5Nz_5Vwj0WWL7-V_78j6Fry5OjvDXGCrejnsu3Q@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 14 Oct 2021 16:11:44 +0530
Message-ID: <CANT5p=ovLNLKwxsnik4pNkCbaznydWKAJz1AbBp6EhBy=nGTiQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: for compound requests, use open handle if possible
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

I don't think this patch was taken. Can we take this?
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/34c44cf16b97ee71b6d07720199b97ed328e7c97.patch

Regards,
Shyam

On Fri, Jul 30, 2021 at 10:44 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Hi Steve,
>
> Please review the patch.
> It fixes the issue of some compound requests unnecessarily breaking leases held by the same client.
>
> https://github.com/sprasad-microsoft/smb3-kernel-client/pull/2/commits/34bf1885b26db09a60bc276ea1a3f798f4cbb05f.patch
>
> We saw this yesterday when testing with generic/013 xfstests with the multichannel fixes.
>
> --
> Regards,
> Shyam



-- 
Regards,
Shyam
