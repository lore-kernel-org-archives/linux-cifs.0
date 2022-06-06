Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E6BFC433EF
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jun 2022 23:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbiFFXXC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Jun 2022 19:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiFFXXC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Jun 2022 19:23:02 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15544C414
        for <linux-cifs@vger.kernel.org>; Mon,  6 Jun 2022 16:23:00 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id f1so2633251vsv.5
        for <linux-cifs@vger.kernel.org>; Mon, 06 Jun 2022 16:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=15P6YdYonttyMBlvmkphQiNJqk70sp0DQVoXXVX4p3M=;
        b=D86sGNeHeaVPnoQl8Q7UCyOWO6Jqatd7sPcm4XBWpdCPLuOtS6+swQBG1oSvLIaKEI
         oS+gPJ7o8Q+r+GvYnPspTrLqQ+Dnn6Vg8n380FPdBszYsaeKsyijukAdrvTeFzOn/uDn
         iPUgS2E4urb76bIxs4jIlaYI4Vfp3saQxiEmBclAVG0SyJ6ShLSh5IWdijLYcAx5wyeV
         Fecv8e4LkmewJAewI9IvDnJ4gnDiNeUEbDs1YL9p0daaStwQb+D6/6NJxDy9Bl4bo0+W
         58OxTmg9+7evmyjKZH5sbzOrxmG/gcymFnW6u2lM/cO5nMFPHejhyB8itVp3+6jvEGGW
         0BrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=15P6YdYonttyMBlvmkphQiNJqk70sp0DQVoXXVX4p3M=;
        b=It5mKRRBajcV6fKax8wyWAA7NdTZWhcuM7WR5zGl0Mzp58A5fi9dmcEmzExV4v/1T7
         PedSIOnWTBFI8CwSWxv+4tmz0znCmV918Z404HzRXSamxY+6v0YqTutuQOllnFAh6OOG
         SO/oiADFtbg2MoFPdvd0/u2QppR7XFdBUng7UMHOuzplRCNUXsDxwdSJiQ+FlnRdb3sw
         CcOOnwAqHQ2JmqWevuCG08oMRe59u89BJRxu4CsEYIh9CMiRxkODLW8pWnc3tzcJge/e
         KW2jxiPZdkXLsKP4PPF/E9j5QYjtD0uxyjrcf4nkTZkdiVI10LnIKxsgouhtrDIXBM3w
         sGCQ==
X-Gm-Message-State: AOAM530jM+NlIsoXxIRNgeUe9Xl45S99Lut9fI+z1rX4CxtuzbYDR/VJ
        Qrynqfon5wmES6NKP9ERELLWlzG0Q1u6mAZqDYNBbgzE
X-Google-Smtp-Source: ABdhPJyh8nLG9wwICbZhChCXo6m9tHJTjsqVvQFTsQg06k0N5YenmlKFZ/r4O1xyYGUFsXmwDsJPY1396IsD3RzubEQ=
X-Received: by 2002:a67:6186:0:b0:34b:cd23:9836 with SMTP id
 v128-20020a676186000000b0034bcd239836mr2605068vsb.60.1654557779940; Mon, 06
 Jun 2022 16:22:59 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=p24djme0_rDzVHTJAZWEqnQRQXkXFf6hNAaLORDp-MfQ@mail.gmail.com>
 <20220606203117.hbpv3i5na5v2abdw@cyberdelia>
In-Reply-To: <20220606203117.hbpv3i5na5v2abdw@cyberdelia>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 6 Jun 2022 16:22:48 -0700
Message-ID: <CAH2r5mv2J+ynLAmuu23PYNVcos6SurfAFWr_rvCas+V5jdmNqQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: return errors during session setup during reconnects
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

presumably I should add cc:stable as well

On Mon, Jun 6, 2022 at 1:33 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> On 06/06, Shyam Prasad N wrote:
> >I think we discussed this fix in the past, but never got to actually fixing it.
> >It looks like we missed this validation for when negotiate went
> >through, but session setup failed. Please review this change.
> >
> >https://github.com/sprasad-microsoft/smb3-kernel-client/commit/c0bad5b3c5eec5c612723b404e619cac4b370bb8.patch
>
> Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
>
> Cheers,
>
> Enzo



-- 
Thanks,

Steve
