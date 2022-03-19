Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 985AAC433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Mar 2022 18:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243930AbiCSSgW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 19 Mar 2022 14:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243929AbiCSSgV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 19 Mar 2022 14:36:21 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47A92986DE
        for <linux-cifs@vger.kernel.org>; Sat, 19 Mar 2022 11:34:59 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id s25so15143436lji.5
        for <linux-cifs@vger.kernel.org>; Sat, 19 Mar 2022 11:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zNxu1T5tIYTeNaXB/2ss2NoCpCskC8zpCncNKeN8VpE=;
        b=K+mWANBDO9AfP58DM08vpU64r0MS8DFRRAfhDK+B5ygmC8Z21/kzH9NPCQphXy2oiV
         xEPA+Or5Z+kCTjmP+z6iElVIbXwxraLLl4lDnWj+8Wswe/kOsS1E1bmWJvyKw6rgkOO5
         jwwIHWmGv4w9k5DL/WKr6k7H6lwCVTEz+kDOf+qeW+AVOCDHJS7smRb2YoRe3YZEK+06
         1ixsNb58m9U8BL9P608ftbpQB+ZojvER6Pl2AU6ypTl1uot//ncrDuYMI+aH6eiQCBoM
         WV3MXx9jbForzqCjLmW/Qb0D8yt6CUPiMNGI3jdO07UlH7X68ex3qXUWvvYMlcyvc6ql
         v0ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zNxu1T5tIYTeNaXB/2ss2NoCpCskC8zpCncNKeN8VpE=;
        b=YQ4LOWJjDmiBPUqb4I6qpBQ/1m8Ig6dyg9J2kLeaDknUMi3uFaLrmZSWxN8Dbiu/pi
         PspGDn7xVFcZngrc33uDQkO4mk74YxZZDCLAs3R8M4fwbvn9ERZmVTjLSO6tmm5pjzKG
         pHehLAYKFZoRD5xSISTe17vZ6tMT4nInsMpYxMHCSMATpN1J2J5kS+g2K3hs/+7c9SoF
         bPBssaA5PBCF5w+TOMynYbarinGgNHSMT7ZOVm4ruhw3TOhKJeUqlN8j0DpPWbA3VZHw
         wTnjmQh1i1iedKurgCRuD3VdadSVC4nO51fAKKPgXXOs3YVn7DwOuWH43JSIgOUNMgq6
         SN8Q==
X-Gm-Message-State: AOAM530hJPAoWIzKnNPa4VxeXlowh9Vkm4vHWj7dxTJWjgD00lKZAns+
        oAuRa8YvVOmYBZBCfjxSEUy//yIkety0voiwgsg=
X-Google-Smtp-Source: ABdhPJx3JpitaN00IUzbFVlpqPzRkk/zB6hyj4AUpEmVoxJaJxemNb+R0yvJTXPEbfI4dNaAaqWMP9wpuwBLtq25S3U=
X-Received: by 2002:a2e:a58c:0:b0:249:7ecf:6075 with SMTP id
 m12-20020a2ea58c000000b002497ecf6075mr660153ljp.460.1647714897958; Sat, 19
 Mar 2022 11:34:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvG6jmUKVi4zqRouFgYSjYxJjTExjmPtH64PAjFahE8dQ@mail.gmail.com>
 <570f1f21-ecd2-6f88-e78f-7c57a22ba7e9@talpey.com> <283E0E80-BDAA-45B4-B627-C7BF44C0D126@cjr.nz>
In-Reply-To: <283E0E80-BDAA-45B4-B627-C7BF44C0D126@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 19 Mar 2022 13:34:47 -0500
Message-ID: <CAH2r5mv2E=zQ+nVjMuLGvz3CGMLxM2Cq4aUEnLd3ieRCQTOM8Q@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix bad fids sent over wire
To:     Paulo Alcantara <pc@cjr.nz>, Namjae Jeon <linkinjeon@kernel.org>
Cc:     Tom Talpey <tom@talpey.com>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

They probably should be always 'u64' everywhere (not le64) and change
the code back in fs/smbfs_common/smb2pdu.h (was this due to ksmbd
using the file and converting these fields in fs/smbfs_common) rather
than the ones you changed


On Sat, Mar 19, 2022 at 11:01 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Yes, I agreed. Why not simply store them as le64 and avoid the byteswapping altogether?
>
> On 19 March 2022 09:06:55 GMT-03:00, Tom Talpey <tom@talpey.com> wrote:
>>
>>
>> On 3/19/2022 12:23 AM, Steve French wrote:
>>>
>>> Any comments on Paulo's patch? It fixes an endian conversion problem
>>> that can affect file ids used on big endian archs.  I will add cc:
>>> stable
>>>
>>> https://git.cjr.nz/linux.git/commit/?h=cifs-bad-fid-fixes&id=a857bb6b15646a7946fafb281878ddf498107dc3
>>
>>
>> It seems a bad idea to be storing opaque fields in le64 integers, then
>> byteswapping them when they go back on the wire. Wouldn't it be better
>> to make them u8[8] arrays and just use memcpy/memcmp?
>>
>> Tom.



-- 
Thanks,

Steve
