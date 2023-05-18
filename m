Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1302C77B7A
	for <linux-cifs@archiver.kernel.org>; Thu, 18 May 2023 00:37:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjERAhz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 May 2023 20:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjERAhy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 May 2023 20:37:54 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8301A273D
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 17:37:53 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-64384274895so1036861b3a.2
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 17:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684370273; x=1686962273;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OrlyUekt20DvitevBQQLauHNoDRB8rZulKjcpobuDVc=;
        b=g74gwONIU2+wgsrxQyhyPotaf/Jr3ty0qsIwa49gNNLnIILD0Wh8zHOSBBTLpzUM7d
         o4lGx2O7QVHDVxuayqafs9JZuJlsITP+oGX/1i+7kDoCubc+I6ue0uz86CoLS+5xQA3n
         drJ/Wc91zPy9idqM5sYFp9UHpoL1WdKZb3iUQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684370273; x=1686962273;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OrlyUekt20DvitevBQQLauHNoDRB8rZulKjcpobuDVc=;
        b=EBVPySchx5l6NrNzW8C+jtzWxmIxYPYZPiYe82ihN7ZHjUEvmSHctiC8dyYjcpinI0
         yNUYJn3nABH8rFkirvm4H89598WaeWBREr6Usy/WBVP3TFkqdGZ9f4g7ZDl64ItFiIzZ
         aCqadQc/inEWJqDD6fmUDdHW/bAiV+r2lmcULKvl2UYVMcEIlNuba9EoDXoNF3vvQXzQ
         SfeFt6qMBQy24ksLxllyL7+TAg+hbNTQWxBGbbpQRkdNwBncdzl2Q3SKN48s6BECWV7F
         8AQNVL7DyUcID4AAAlneoSVEWFWk2Kj0ohMQx8lDj3IAWv0WUimma3d6bmC9J0Oc1rVp
         rH8w==
X-Gm-Message-State: AC+VfDyRDoRrHV53nIivDx8Q7TR342iwPPTWL+rHXwaaLRXsb+ulRHCb
        PJiSzyeu1KmwJOzlqimZ8Rqrxw==
X-Google-Smtp-Source: ACHHUZ55V2t+RjKhfw42YSxvrFaGtkYSm7WQ7u8cnW2piIVTg5cWT9v6jB0V4rPAdYhCTwBg0Ih+Dw==
X-Received: by 2002:a05:6a00:2e9d:b0:643:6aed:3a9 with SMTP id fd29-20020a056a002e9d00b006436aed03a9mr2365556pfb.0.1684370272974;
        Wed, 17 May 2023 17:37:52 -0700 (PDT)
Received: from google.com ([110.11.159.72])
        by smtp.gmail.com with ESMTPSA id l1-20020a62be01000000b006466f0be263sm122464pff.73.2023.05.17.17.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 17:37:52 -0700 (PDT)
Date:   Thu, 18 May 2023 09:37:48 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Hex Rabbit <h3xrabbit@gmail.com>
Cc:     Jeremy Allison <jra@samba.org>, linkinjeon@kernel.org,
        sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com,
        linux-cifs@vger.kernel.org
Subject: Re: [PATCH] ksmbd: fix multiple out-of-bounds read during context
 decoding
Message-ID: <20230518003748.GE20467@google.com>
References: <20230517185820.1264368-1-h3xrabbit@gmail.com>
 <ZGUk3O75foDOPaJ7@jeremy-rocky-laptop>
 <CAF3ZFedA=Q+ghkKNR=wnbNQ63LXPwagetmez0KqZthMySBNTJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF3ZFedA=Q+ghkKNR=wnbNQ63LXPwagetmez0KqZthMySBNTJA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (23/05/18 03:28), Hex Rabbit wrote:
>
>    Maybe it might be worth addressing these issues in the upcoming patches.
>

I guess that would be nice to see
