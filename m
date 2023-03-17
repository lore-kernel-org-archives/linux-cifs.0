Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2956EC6FD1D
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Mar 2023 18:26:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjCQS0L (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Mar 2023 14:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjCQS0K (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Mar 2023 14:26:10 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BD712CDF
        for <linux-cifs@vger.kernel.org>; Fri, 17 Mar 2023 11:26:09 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id bi9so7542447lfb.12
        for <linux-cifs@vger.kernel.org>; Fri, 17 Mar 2023 11:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679077567;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l7EdGCUYnU+ketKcT05CW+inXCF4z/VeUYMeA6JOCS4=;
        b=kNywasH0ubYcThG8Zwxp4f8HO1hHfyunyMem7NeAfwbMvF9OFeQEf/KmWIB/5tA+5V
         PYnvx2Rz3Y2GjzYhacG9Cq6sEnEHO5H23GY9tO8PBdGl5tx+XrSpReIpi/PKKlEzglgS
         ZkHE0peNmx7w1Aod42e0HLrRYrUB4/WMZl8CfqT3V76P9H8349WfyIULYSOIli3tN89e
         d05Gh7DmJX8MRiAnigmjBOzBDV8UYVAmMlsBscOb9eyqsOajCva1zjIIo/ji12U38EaN
         QPTh4DiqpoQo7kSh+HyJD/yG9GPsskE7/2szKb9a6RQNU+gQb98ZvtD+0k81HYvBOHuA
         sMhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679077567;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l7EdGCUYnU+ketKcT05CW+inXCF4z/VeUYMeA6JOCS4=;
        b=onpzGjzPtSeYDgEThpGPWJSihHV2/pWX47hyb78YQra3NvkJOcgUp0SNWIS26PQTUt
         JJRlMl7wX/XcsM1sVn9e6EXLaUJ72phxJcoW9tk+2f63sJBWdp1SkSQqBXbA9DoTAH5M
         wiZZlbvbDsaRZonyMzPg+u0Dmdz8G3z7Y8/s9eehC9WqfBW2+YN7WGZWysC1ValVX1/0
         MO4HZ2Csp9DOfckaHmMrTfzJDF0t7Rykc2wygZ0bvWOaJfDMJuvClpTrwcpuwcnsxIOL
         nnvh1mxO6Bm5oZxOmdCql02I+umuYwGZN3zeTHz4xe40pLoePSBY3q6mVgsRavFBCS6E
         BlQw==
X-Gm-Message-State: AO0yUKW0v5AZmgSSB9plOVi/ovlirjInWWjXeKMg7YBeKiNwxe+5gV+C
        /CU3u/3bIAqXVYnDcKgN/V7HdCHnL/1B0mxypbFJ4eER
X-Google-Smtp-Source: AK7set97x/bVhRu52gfRpweI195civClA1wLR3wCwGBftT0iDQ0n0lS6bEW7RlNqDhNJ/j0rdssrsSce5Bkib59beMA=
X-Received: by 2002:a05:6512:3d22:b0:4e8:4409:bb76 with SMTP id
 d34-20020a0565123d2200b004e84409bb76mr2252219lfv.2.1679077566720; Fri, 17 Mar
 2023 11:26:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230310153211.10982-1-sprasad@microsoft.com> <95f468756e26ebfb41f00b01f13d09da.pc.crab@mail.manguebit.com>
 <CANT5p=pfZNefhzGSytg9tuGXhNgvesVecTGoZFhWnUmnLxb-9g@mail.gmail.com>
 <ee7ad068976dcf1a7356fb6cd230fb69.pc@manguebit.com> <CANT5p=qyFkJn0cCfiyJma3RFcmeBcjq4C4qDhw7CL8A+fiAUEQ@mail.gmail.com>
 <4913391e6b2ed4672fd427b479460eae.pc@manguebit.com>
In-Reply-To: <4913391e6b2ed4672fd427b479460eae.pc@manguebit.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 17 Mar 2023 13:25:55 -0500
Message-ID: <CAH2r5muFNQDEYQzg4CqV1nGxLHVyOQTuo7sRZNOwXwOPcyJUtg@mail.gmail.com>
Subject: Re: [PATCH 01/11] cifs: fix tcon status change after tree connect
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>, bharathsm.hsk@gmail.com,
        tom@talpey.com, linux-cifs@vger.kernel.org,
        Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

updated for-next with this newer version of the patch

On Fri, Mar 17, 2023 at 7:35=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
>
> > Here's the updated patch.
>
> Thanks!
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>



--=20
Thanks,

Steve
