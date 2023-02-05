Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C99BC636CC
	for <linux-cifs@archiver.kernel.org>; Sun,  5 Feb 2023 17:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjBERDs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 5 Feb 2023 12:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjBERDr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 5 Feb 2023 12:03:47 -0500
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51781199E8
        for <linux-cifs@vger.kernel.org>; Sun,  5 Feb 2023 09:03:45 -0800 (PST)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-15fe106c7c7so12616168fac.8
        for <linux-cifs@vger.kernel.org>; Sun, 05 Feb 2023 09:03:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Fmd512l+mjQ2+eFd1xg/VITiCnDFMmoMOMITdfNR7Bs=;
        b=NzqpEyTrrS9y81tqQmLiDTNx7IaZzfocFhbGLPLJAuG+XnyhWRs7+d5raXYZ9ZWKez
         Iu0Xlz9IL9a/2goZTFf38/e3zWoZM1D0dH2EDUfhE8eth9jpOi3uvvDibiIq2SKZAVQH
         Oddn50J2ho69o/w3RQWP0U3ohvfb9wD1ZqHvi3jX34mS/mlvjhyjYskxfG3BrlMuskc5
         ubhjJTyPj3PNuvtYmsJCv1CHMFUrSJxu6604czWFS1HmFDQdalTAzxwJ5XOIldemWRfh
         U/x8yXtKtMykR3VvZMWgCZoWeI10BSlJ1qsAannhE0RVpcJ61mbDrx5jlNbM/uNuH+5m
         vFEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fmd512l+mjQ2+eFd1xg/VITiCnDFMmoMOMITdfNR7Bs=;
        b=AXoA7kMGJfMX402kOYeya7Ri247HcxbDJA5SvaZCUBmk/+CV0JiPAT1ZYswRmsqjtM
         dQrQ8yoGSofNz/i7ZgLZS5AVM0v5yVRoi5g9JiEypFbFCK9FQLGp9wq0iQM82opYAmx2
         +gyREeZw05xikXs2Thtpp00EkgcgZu2mYeD6xeGin7Be1fmk4mYvf+9WzeVRpgYxLVQ6
         /l4x2aZC7tl7FZr22gg7+1eRM0xJOl1Xy5TPmXp3OsmiBl1lTW6Kce4XtwwQzWmtcZY1
         YagvPloADN0hMz0kgZeSOFZE9tQPHWLypPEsf4lYc52jA9fu8CSzbjzY87K0Axpj02zn
         ktbg==
X-Gm-Message-State: AO0yUKUcNuG7b+0shnUFzjMpRdaO5STIDxmwNICswVyUz1DLSQw8rxKq
        HMApqMTPg8LdYmmjC30b3bAaPZFHOnrNXwLP1vQ=
X-Google-Smtp-Source: AK7set9iDINAK78yhozcpfIiE28/tckCyTt2jOlMljinnuoIJkk2RyfjkI96SUjhiNu7wWYHIjKyltUVQebtjx4iUjE=
X-Received: by 2002:a05:6870:c892:b0:163:a89a:c5e6 with SMTP id
 er18-20020a056870c89200b00163a89ac5e6mr1159369oab.276.1675616624193; Sun, 05
 Feb 2023 09:03:44 -0800 (PST)
MIME-Version: 1.0
References: <CAMBWrQnRKQVPh8Vi8bY4eL_VSZhnPu_5OALv1nKZuXvoEMsLzQ@mail.gmail.com>
 <CAH2r5muwLzMk5q=9xOTm0SA-hpB46do7fUy9=BwwdRPM_QGJKA@mail.gmail.com>
In-Reply-To: <CAH2r5muwLzMk5q=9xOTm0SA-hpB46do7fUy9=BwwdRPM_QGJKA@mail.gmail.com>
From:   Stan Hu <stanhu@gmail.com>
Date:   Sun, 5 Feb 2023 09:03:33 -0800
Message-ID: <CAMBWrQkETrYh=HtnWx07r3cpVbAWzHQtaY=BwjvncYa6ZzeUdQ@mail.gmail.com>
Subject: Re: curious about a CIFS bug fixed in Linux 5.13
To:     Steve French <smfrench@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Rohith Surabattula <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, Feb 5, 2023 at 7:13 AM Steve French <smfrench@gmail.com> wrote:
>
> Can you also verify that this works (on previous releases) with
> "nolease" mount option (so we are more sure that this relates to
> leases) and second can you (on recent kernels where "closetimeo" mount
> option is supported) try it on a recent kernel with "closetimeo=0"
> (which disables deferred close)

Thanks for the tips. It looks like:

* On Linux 4.19.0 and 5.12.0, the "nolease" mount option appears to
fix the problem.
* On Linux 6.1.0, "closetimeo=0" doesn't appear to cause the problem
to resurface.
