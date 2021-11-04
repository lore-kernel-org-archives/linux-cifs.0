Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB610C433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Nov 2021 00:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE6E260E98
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Nov 2021 00:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbhKDANa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Nov 2021 20:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhKDAN0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 Nov 2021 20:13:26 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA04C06127A
        for <linux-cifs@vger.kernel.org>; Wed,  3 Nov 2021 17:10:49 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id o14so4047026pfu.10
        for <linux-cifs@vger.kernel.org>; Wed, 03 Nov 2021 17:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DZ3jPl3PPBYENWWpmyV11Z/WC/C6R82IpL6uLEjtT0s=;
        b=WKGq3m1WuqQbJD72bygTQI77zDusyeC2AMh9QymuD45i7wluG1pnjJ8EpWY1xth0ov
         eWcV+U30NOhDH5YZTmYwkPHCEZHzbcRmbxUQXNRHmpg4RwMcfsbQlZynWuNTVftXpZTJ
         LAh2yP8cDQLVQ18fQydTSR6ykGEFNjkWgpGU4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DZ3jPl3PPBYENWWpmyV11Z/WC/C6R82IpL6uLEjtT0s=;
        b=CNKYlYZ6iw7yUOL/LfStYBQ7OkffMmywu51/3ffzc44/9/oy3uqeyBCeTMutb6RUhJ
         iKwRt1mNmVTMaXCZRieIofDRDKDT7nnap/HM94S7Py270nAhH0k72oXPieEzspei/m5O
         rDOxw59pCxa1ML87/HfDAieUl4U9Af+U4ajqY7VXXIV2Vl0Do5VmU9slWki6kfe9jCZc
         YFktstaav+QyGOLC1j3VF4bdHA6Tt1Re+RUakv7N/X2pybcPiIZWEE4aJ/wMDOekWT61
         q8jJH7roplxrRihmrK6b1fZvd8m4ZcCVTeCvY6zUqMhSAHeB2B+gYReGoTPrTweqGtKE
         oP8A==
X-Gm-Message-State: AOAM530LxZOTH0J0+dk1pNtRb9rryIN4l8+uFdmI0LgKoQs/oKe9cMi7
        xl7WZSQDuA/IgThOh58saX+B0w==
X-Google-Smtp-Source: ABdhPJyfZf9MlDRaAZHY7ketZgyOwuXeEM5a2jZNaLLAx7WzPNmwByDZEJM6t0JG1nZEKh7ZlUIKJw==
X-Received: by 2002:a63:d644:: with SMTP id d4mr24808925pgj.360.1635984649365;
        Wed, 03 Nov 2021 17:10:49 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:1f56:281c:d78b:3f3a])
        by smtp.gmail.com with ESMTPSA id h10sm3712340pfh.2.2021.11.03.17.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 17:10:48 -0700 (PDT)
Date:   Thu, 4 Nov 2021 09:10:44 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Guo Zhengkui <guozhengkui@vivo.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <sfrench@samba.org>,
        Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@vivo.com
Subject: Re: [PATCH] ksmbd: fix flexible_array.cocci warnings
Message-ID: <YYMlBCuhyqgdVHiC@google.com>
References: <20211103131901.28695-1-guozhengkui@vivo.com>
 <CAKYAXd8dd83NoCetj+-Cza5EnTvSZXBbu4UWR0WHT5YjAD-05g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKYAXd8dd83NoCetj+-Cza5EnTvSZXBbu4UWR0WHT5YjAD-05g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (21/11/03 22:51), Namjae Jeon wrote:
> 
> 2021-11-03 22:19 GMT+09:00, Guo Zhengkui <guozhengkui@vivo.com>:
> > Fix following coccicheck warning:
> > ./fs/ksmbd/transport_rdma.c:201:20-27: WARNING use flexible-array
> > member instead.
> Is there only one here? It would be better to change them together in
> this patch.

I guess I see more than one

fs/ksmbd/ksmbd_netlink.h:       __u8    spnego_blob[0];         /*
fs/ksmbd/ntlmssp.h:     __u8 Content[0];
fs/ksmbd/ntlmssp.h:     char DomainString[0];
fs/ksmbd/ntlmssp.h:     char UserString[0];
fs/ksmbd/smb2pdu.h:     __u8   Buffer[0];
fs/ksmbd/smb2pdu.h:     __u8 Buffer[0];
fs/ksmbd/smb2pdu.h:     char   FileName[0];     /* New name to be assigned */
fs/ksmbd/smb2pdu.h:     char   FileName[0];     /* Name to be assigned to new link */
fs/ksmbd/smb2pdu.h:     char FileName[0];
fs/ksmbd/smb2pdu.h:     char   StreamName[0];
fs/ksmbd/transport_rdma.c:      struct scatterlist      sg_list[0];
