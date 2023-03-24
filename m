Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 641B8C6FD20
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Mar 2023 05:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjCXFnd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Mar 2023 01:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjCXFnc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 Mar 2023 01:43:32 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7492912CD1
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 22:43:31 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id mp3-20020a17090b190300b0023fcc8ce113so4057336pjb.4
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 22:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1679636611;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F76Phfkz1u+jrtufJMqP/X9zOtnEG1YNV3bStv8/YkQ=;
        b=MNlPx7F965w6MHH9XIdjykHG18n4oXE4fxU+BTn2L9tiI98R/srylAxqEPmDOqa6pj
         SLHHWUtwY6863OVFVFlItbWra8zysaJyjxWGCrmHdyBTUfppjQWvon61Xc6YtlRxLtjs
         C3Jv8BDCwowo3ubn13B/mYAsVLCU9M0UFvpZ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679636611;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F76Phfkz1u+jrtufJMqP/X9zOtnEG1YNV3bStv8/YkQ=;
        b=MAlPn8U22hQjqgJQDqbPpP6WIEvkBiZfOPbc4IL4fnUTVq2FXznrTE6l+iFg9tQ4OV
         n136oVrMthft/mBcw916SPf1VrpiRWc8FHV6Gl5O6CbGtogjcOfXSLYkwGxHIGuj6/+k
         8YURjM4BIt7y881aZ4nmhaqy1ZE1M8K/jzbozED/Z90nA2dDlCdx1nnhunIq2mkNS1AU
         yrpBCBV7rZtcrlUZ6M9vCKsgOz2RgHQ8IcpfXpZ8C/pS1OFx+BDTUNH58/z9JGLTOxKX
         UmfJv7SL2Hz+6ltSqzmHrHDNlasNpJBKsN42C+f9tuHzgSIcloF23AEgdxsTqBDVynyK
         2cNw==
X-Gm-Message-State: AAQBX9du/ezabyrlmVt7cc8Inotk70wfqGnYq0MrWp52tmu3Q2TRnON9
        hELptFs2egtGoIk99LkN/awkiw==
X-Google-Smtp-Source: AKy350aHJAaqTq+nt9lbjBVHQkFW1xPzVRG2lo5I6LkrUBm3O1679rvDNajTVR23ok8J/3sdPskGGg==
X-Received: by 2002:a17:90b:4d81:b0:23b:3422:e78a with SMTP id oj1-20020a17090b4d8100b0023b3422e78amr1688232pjb.6.1679636610950;
        Thu, 23 Mar 2023 22:43:30 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id k2-20020a170902e90200b0019c919bccf8sm13303343pld.86.2023.03.23.22.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 22:43:30 -0700 (PDT)
Date:   Fri, 24 Mar 2023 14:43:26 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com,
        Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH] ksmbd: don't terminate inactive sessions after a few
 seconds
Message-ID: <20230324054326.GF3271889@google.com>
References: <20230321133312.103789-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321133312.103789-1-linkinjeon@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (23/03/21 22:33), Namjae Jeon wrote:
> Steve reported that inactive sessions are terminated after a few
> seconds. ksmbd terminate when receiving -EAGAIN error from
> kernel_recvmsg(). -EAGAIN means there is no data available in timeout.
> So ksmbd should keep connection with unlimited retries instead of
> terminating inactive sessions.
> 
> Reported-by: Steve French <stfrench@microsoft.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
