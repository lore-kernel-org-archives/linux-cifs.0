Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 695D2C678DB
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Mar 2023 04:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjCGELr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Mar 2023 23:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjCGELq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Mar 2023 23:11:46 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0B8580E9
        for <linux-cifs@vger.kernel.org>; Mon,  6 Mar 2023 20:11:34 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id a9so12773895plh.11
        for <linux-cifs@vger.kernel.org>; Mon, 06 Mar 2023 20:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1678162294;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GwqFmgMhFlilb/ec9/lg/gjrwDDGgbEHovNbKwK6jh0=;
        b=PXRhbl9fUPXupWi8mLtUo71CG2viw2j1Ck+LnGplvsfBbTrx2JA/HxdhC7ZarlHkMM
         UOTxqh4l1vS+06mLOZ+f2teEOH7AjEO1HJr6ju3UFB66XXsPo+saFFHx8nl+59NVlhw7
         FhyF14yqkYOoHzjtM5i+MZ5+RyGLiu6Ha803c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678162294;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GwqFmgMhFlilb/ec9/lg/gjrwDDGgbEHovNbKwK6jh0=;
        b=qplrEE9KYwzTDdaW6jOj9XhUIWgDuHGKjx8qYSQYDCgLdviL+0uMyA480eT4tmO9Vr
         rDcc/WmPD+CEt/0ZpMly8SsHE3k6aJo5cDLrtAJrIK+wePU+rrt7R2oZoySGwiOnxv5U
         g9yD7G4d/ikAF2O7JnfIOSJPrQtnn9HK2RSxk08jWuFQQqZ2Ji4R9g3jfevYvZWGafvF
         5eOg9o/Fl7WycnDqE5ytiprJUiwuDFAdzmhGfVP0WWh8damQ4bBqBQRy3PIxibLFrCUj
         8Zx648TyuM3kcEehjbeI8wgoX4ro1JfK8qedL11KMgwq+bMOXnCYASlNs9sOqnse/NlV
         lEzA==
X-Gm-Message-State: AO0yUKXPKpWl5OZAE4lWlB9p4skfwosX/r+k/dxJ9TamIVOdCeSYi/cv
        PfUo30LPu4EcBZNU2L8qNEpHbA==
X-Google-Smtp-Source: AK7set+K/Jqq3sWKaIgSRW49JXkNV7S3BQj7x0cbb6lQBzLlBS24CqmNFK8ghWXPUmR4qXcXJM1Dig==
X-Received: by 2002:a17:902:720b:b0:19c:171a:d346 with SMTP id ba11-20020a170902720b00b0019c171ad346mr11787890plb.44.1678162294349;
        Mon, 06 Mar 2023 20:11:34 -0800 (PST)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id lh3-20020a170903290300b0019a91895cdfsm7487621plb.50.2023.03.06.20.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 20:11:33 -0800 (PST)
Date:   Tue, 7 Mar 2023 13:11:30 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: add low bound validation to
 FSCTL_SET_ZERO_DATA
Message-ID: <20230307041130.GG5231@google.com>
References: <20230305123443.21509-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230305123443.21509-1-linkinjeon@kernel.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (23/03/05 21:34), Namjae Jeon wrote:
> Smatch static checker warning:
>  fs/ksmbd/smb2pdu.c:7759 smb2_ioctl()
>  warn: no lower bound on 'off'
> 
> Fix unexpected result that could caused from negative off and bfz.
> 
> Fixes: b5e5f9dfc915 ("ksmbd: check invalid FileOffset and BeyondFinalZero in FSCTL_ZERO_DATA")
> Reported-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
