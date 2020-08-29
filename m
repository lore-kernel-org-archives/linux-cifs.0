Return-Path: <SRS0=eHRh=CH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29C32C433E6
	for <linux-cifs@archiver.kernel.org>; Sat, 29 Aug 2020 00:23:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0142020714
	for <linux-cifs@archiver.kernel.org>; Sat, 29 Aug 2020 00:23:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cIBeLLqT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgH2AXB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Aug 2020 20:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgH2AW6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Aug 2020 20:22:58 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62ADAC061264
        for <linux-cifs@vger.kernel.org>; Fri, 28 Aug 2020 17:22:58 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id b17so1322237ejq.8
        for <linux-cifs@vger.kernel.org>; Fri, 28 Aug 2020 17:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PA05Hr75q3UEXQH/HT/t78AEzp+lm2U5EN5slv0VNUw=;
        b=cIBeLLqTagLszwYEQF+JDEg7f6v/pThrXA1J0b7pUVSrCzggjrG8dc/mrkeHFPLcwV
         Sim/lYAUlLh1lse3hhMaKW0BuqFZXFOPHlkzhieTFUxYgZl+oaKb+qvavuWZf5qyzwnr
         s6GnXbqDHYC8CmegBEeq18FDIlH129N4UwQpyvQf2VUEEKg/SC5+u+ye58NJqwWhiBnH
         KT/huheLuE6pg6+7KVPAiM85clcyZhhp9xDUWGqTxRjtbbl95Kcf05tBeXywTUBLNLZ4
         Nj0oIl4HhjXE6q974yakkorARtZeNtAU4ZR/mez7p5SOpsXH3OKwjgGZxW2Zpwx0F9TX
         iULg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PA05Hr75q3UEXQH/HT/t78AEzp+lm2U5EN5slv0VNUw=;
        b=a/Cbpx6EPZxCoVCGlWEv1tezMasmjaDuYNr6F4ApkZLpKWsmNstWSofYUTbBU3JZ/h
         /0YSYTMUvZDvQPdLX3YtRWreDlwyAvb/o874HFLzL+KSh2orOVLVggEMYfw/Hsusqmk7
         +MII+UmvCPMLNOJDxI5v8sSTg0TPGUYCoID29nKtHHyBIPQcgCdrsbXcqK1XbTKDFcqE
         2fDXx1CRTFdFwYDwy9PYvEIzX6NeJVsElWPcCuDIwV0sZ/fFD0PUFg1D63H2tNXi0H8p
         enqYV+L9/in/OGuRRkzFsXiEE3ccnFjK8HkW2A9Icf4pG2IHiWpQBYGL7eG5VIyArwIw
         rXZA==
X-Gm-Message-State: AOAM532jpl54qLhxTDfvT38cT6Y42JgDwa5dTWR14ShMT/FAlIaR4wMo
        aggRSoQe+1ZomBlYJRVH6Zyo1GFP6qtpr+sY0NfGb5s=
X-Google-Smtp-Source: ABdhPJwcnOz+zIOn7kqDfK8j+zzu+8XEX8PgE994ejWiFF+3KmxkI8fCin5NWO5ScMoB7s3BaDhRHTWMFc4kNwOQNA0=
X-Received: by 2002:a17:906:c294:: with SMTP id r20mr1292039ejz.280.1598660577087;
 Fri, 28 Aug 2020 17:22:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200609180044.500230-1-sergio.durigan@canonical.com>
In-Reply-To: <20200609180044.500230-1-sergio.durigan@canonical.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 28 Aug 2020 17:22:46 -0700
Message-ID: <CAKywueTDHV112-y125ROPK2aa+w6A1Fd_4x82YVEU6LauaAS9g@mail.gmail.com>
Subject: Re: [PATCH] Separate binary names using comma in mount.cifs.rst
To:     Sergio Durigan Junior <sergio.durigan@canonical.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Merged. Thanks!
--
Best regards,
Pavel Shilovsky

=D0=B2=D1=82, 9 =D0=B8=D1=8E=D0=BD. 2020 =D0=B3. =D0=B2 11:03, Sergio Durig=
an Junior
<sergio.durigan@canonical.com>:
>
> According to lexgrog(1), when a manpage refers to multiple programs
> their names should be separated using a comma and a whitespace.  This
> helps silence a lintian warning when building cifs-utils on Debian.
>
> Signed-off-by: Sergio Durigan Junior <sergio.durigan@canonical.com>
> ---
>  mount.cifs.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/mount.cifs.rst b/mount.cifs.rst
> index 354269b..6ad84f1 100644
> --- a/mount.cifs.rst
> +++ b/mount.cifs.rst
> @@ -1,6 +1,6 @@
> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> -mount.cifs mount.smb3
> -=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +mount.cifs, mount.smb3
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  --------------------------------------------------
>  mount using the Common Internet File System (CIFS)
> --
> 2.25.1
>
