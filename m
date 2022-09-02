Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B5BECAAD5
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Sep 2022 15:07:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236502AbiIBPHU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 2 Sep 2022 11:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235995AbiIBPG5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 2 Sep 2022 11:06:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416B214D470
        for <linux-cifs@vger.kernel.org>; Fri,  2 Sep 2022 07:36:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0578B829D6
        for <linux-cifs@vger.kernel.org>; Fri,  2 Sep 2022 14:35:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A6AC4347C
        for <linux-cifs@vger.kernel.org>; Fri,  2 Sep 2022 14:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662129311;
        bh=br02KTcVt9eUOM+AGTme3p22OVGqGIKW8zJ99RUg0UY=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Clwhum732iqKSMBazkodIpFAEkVJC+Pc8EZ36VYp/zEgx209TvVquZz2uGYWBVo6u
         vIamJEo1+0LXjbhyk4k55QONsFAyPVfTUtGiGU1dHQEz5uo/Aybyt+Y4DoWpckgkzD
         0V3xKvVewsoE8ZlAp1xoiQNvHhKnwVlx3PEz2Sg+aOlXojn1K1hFB3r9FhAJS4wXCP
         nVknYU+AFGclmdxIdwX/oXg7B//x9UiOr1B3e4EWk6WHydE4Onn4zxuUiW23j+vHwx
         cd7ligBFmCyd0hYjDYmkkZH+kqWFVX+8sRYxyBTAEeeRyhcrw/Yhkh/sdlCKaKWFrA
         GIlqmoI8U4YUQ==
Received: by mail-ot1-f47.google.com with SMTP id m21-20020a9d6ad5000000b00638df677850so1562568otq.5
        for <linux-cifs@vger.kernel.org>; Fri, 02 Sep 2022 07:35:11 -0700 (PDT)
X-Gm-Message-State: ACgBeo1oqRI4uMK3spsFJv2d0bxaDnv0iW2D6nGq8NI75trCFafKXNcf
        fNj+ctYoWbG/mMzBjjzgyUKR0yLTKeMQsIgSWwE=
X-Google-Smtp-Source: AA6agR7KfeZC4zfhnk3X7USIZJ9v21xh8vid0DXW29rW47EbMThtuwoG/01+6KzqZPtWlR4uY7Raq/BdB1L/Yh2B4L4=
X-Received: by 2002:a9d:7519:0:b0:636:d935:ee8e with SMTP id
 r25-20020a9d7519000000b00636d935ee8emr14483618otk.339.1662129310419; Fri, 02
 Sep 2022 07:35:10 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Fri, 2 Sep 2022 07:35:10
 -0700 (PDT)
In-Reply-To: <0d601836-3748-7f4f-827b-af1b53eac0fd@talpey.com>
References: <20220901142413.3351804-1-zhangxiaoxu5@huawei.com>
 <20220901142413.3351804-4-zhangxiaoxu5@huawei.com> <0d601836-3748-7f4f-827b-af1b53eac0fd@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 2 Sep 2022 23:35:10 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8-doFuN2Ez1fpVO=EEFzA66GC1vce_E6gM8cPMQq2wRw@mail.gmail.com>
Message-ID: <CAKYAXd8-doFuN2Ez1fpVO=EEFzA66GC1vce_E6gM8cPMQq2wRw@mail.gmail.com>
Subject: Re: [PATCH v4 3/5] ksmbd: Fix wrong return value in smb2_ioctl() when
 wrong out_buf_len
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc:     Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, smfrench@gmail.com,
        hyc.lee@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-02 22:29 GMT+09:00, Tom Talpey <tom@talpey.com>:
> Reviewed-by: Tom Talpey <tom@talpey.com>
>
> On 9/1/2022 10:24 AM, Zhang Xiaoxu wrote:
>> When the out_buf_len is less than the size of struct
>> validate_negotiate_info_rsp, should goto out to initialize the
>> status in the response header.
>>
>> Fixes: f7db8fd03a4bc ("ksmbd: add validation in smb2_ioctl")
>> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>> Cc: <stable@vger.kernel.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Zhang, Can you add cc me on next-spin ?
