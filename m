Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3AE5C3DA78
	for <linux-cifs@archiver.kernel.org>; Tue, 17 Jan 2023 17:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbjAQRIO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 Jan 2023 12:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233582AbjAQRIM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 Jan 2023 12:08:12 -0500
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4412842BCE
        for <linux-cifs@vger.kernel.org>; Tue, 17 Jan 2023 09:08:11 -0800 (PST)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-1433ef3b61fso32604436fac.10
        for <linux-cifs@vger.kernel.org>; Tue, 17 Jan 2023 09:08:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=quOzrEE/SsUihkZ4I0M3vxz2IDmDR8jbeRiEMas6kiQ=;
        b=TxHK+YTYuSKw3JOjYFYEiCDWcRPrndf+SkTeG1U9MrlcbRs0kwnP8pYLV3DN+fys50
         p2LWcTOltCE+xriI2ZRNsivXL7Aoo9HXGFTu0zlzJSLI4AZYZwC4wMODf8GFL10P1Evv
         27rh6DDmcxpEODMsdp8B0KdQf8W9/fY7F6VgufMOIbba5umyamMXCpdzAMDI1dKKIgaU
         azGLOeFfsVFjLcCqVxOeN0wvQNB0Mg9tWf4clRaBz6OVGkP06/J7jeV86wudaS2nXoey
         0kTv121xPcycMgH1/HbGLpq7YKb/yK2XVDQ3SAtC9r+i1g1AaiRcRrSgJvp2b6qYTohM
         1AQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=quOzrEE/SsUihkZ4I0M3vxz2IDmDR8jbeRiEMas6kiQ=;
        b=jyvU/aDUha7vimAPZkMPq+1B+UhwBO9LhihDoEMX7twpTIRWeZJRP4ZZFsK8oRP3J3
         MzkWVqLw0+o+inmDIRIQn0tVGkXTseTB2ymuEDHM4TNiRqowWOSCLfxjb000dqWee31y
         AHMZcf4lvCjL4hCpLhYGjNMpRn9ZmwtYf6GWiDooK5cvvNF1l2AQ+dD6PApPJUqy9qhX
         71Vww70x1h8V/dYBbNlcHVprF+lj6aU5f099axQ20rGjM4OulrEhau9OjbsILYg82O9R
         MgJyxNX6RB4/O6kVWrw5xyZy37tFpn/Of1esxmwY7Mf4cSDZ52spUO620+N8d+Rixcgq
         Lj4Q==
X-Gm-Message-State: AFqh2krx2Q982JRqfYP37m1BKTEHmPVQ985gBsM+v6NRHb2sidgGy9yC
        pBh/GpfNhlJTqXJkJKU1yFecRDCRzUNgMpFuryU=
X-Google-Smtp-Source: AMrXdXuvBwrQSg30y3nfG6lFsWdzteEJRQWMJIAwU1hF9WqrOtuwIrJomxBAYylrA45y2yeAorE/qcYWRdT+YnGihhE=
X-Received: by 2002:a05:6871:409a:b0:144:e47:b897 with SMTP id
 kz26-20020a056871409a00b001440e47b897mr265216oab.107.1673975290517; Tue, 17
 Jan 2023 09:08:10 -0800 (PST)
MIME-Version: 1.0
References: <20230117000952.9965-1-pc@cjr.nz> <20230117000952.9965-2-pc@cjr.nz>
In-Reply-To: <20230117000952.9965-2-pc@cjr.nz>
From:   =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aurelien.aptel@gmail.com>
Date:   Tue, 17 Jan 2023 18:07:59 +0100
Message-ID: <CA+5B0FPp5ELawadvymYumQPSaCrCL15=2_KiCX2=91u6KBoVyw@mail.gmail.com>
Subject: Re: [PATCH 1/5] cifs: fix potential deadlock in cache_refresh_path()
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Jan 17, 2023 at 1:35 AM Paulo Alcantara <pc@cjr.nz> wrote:
> -       down_write(&htable_rw_lock);
> +       down_read(&htable_rw_lock);
>
>         ce = lookup_cache_entry(path);
> -       if (!IS_ERR(ce)) {
> -               if (!cache_entry_expired(ce)) {
> -                       dump_ce(ce);
> -                       up_write(&htable_rw_lock);
> -                       return 0;
> -               }
> -       } else {
> -               newent = true;
> +       if (!IS_ERR(ce) && !cache_entry_expired(ce)) {
> +               up_read(&htable_rw_lock);
> +               return 0;
>         }
>
> +       up_read(&htable_rw_lock);

Please add a comment before the up_read() to say why you do it here
and where is the dead lock.

Otherwise looks good
