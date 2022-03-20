Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC9F3C433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 20 Mar 2022 01:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244605AbiCTBYY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 19 Mar 2022 21:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234519AbiCTBYY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 19 Mar 2022 21:24:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE68DF492
        for <linux-cifs@vger.kernel.org>; Sat, 19 Mar 2022 18:23:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2398660F3C
        for <linux-cifs@vger.kernel.org>; Sun, 20 Mar 2022 01:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9F4C340EC
        for <linux-cifs@vger.kernel.org>; Sun, 20 Mar 2022 01:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647739381;
        bh=5qoLzp6wXzU524X4sV0YEUlTc/HFg2HaFBF50dgPW6Y=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=EW0tMpqkpuA9eHIoxwbZUkT+uR2Uk8tn18zeHTI18E5Iyq0017zjJnChqeZRa54/Z
         dwwilDWyJAgMLJoxAkZKIhIDe/OHuctJo5jqIfyPo7k6xSEWJNlF+jfU5bk7idHY6R
         +XwmQ32kxHInug4P95qdY23rlYNL81FkLLbq/7HQ9F4VXWSjsJQf++mxqlur0aIsJO
         /+dYdV7mPeGs4PlX/m5Z93Ow2tXTbH2fIZjyGSZzzlJOul2ydZqdzx2tvwi0WY5jtx
         goZk+hwY9a8Ft10xhBS91EyVOpmt7QNK/Mjt1kGg2Q6geVEMpm7vIDjZWZc77JAY7L
         C/dZqSd6iwl+w==
Received: by mail-wm1-f43.google.com with SMTP id n35so5132083wms.5
        for <linux-cifs@vger.kernel.org>; Sat, 19 Mar 2022 18:23:01 -0700 (PDT)
X-Gm-Message-State: AOAM530yQylBkeiuC1f09PUSP2xUrgaDRJAa1aXjFXoixSjMt5OblKsn
        2eaAzGs3R7fLLnmr/oG1NfmMtIWpLv0LGSQt0rk=
X-Google-Smtp-Source: ABdhPJwihkwEasKi70S0CacybMCxegJEc4r+ksc6ifOF84lrI7HFjBNvCM4HRvs6xSNNth0IWXAIXu8fBgLJYgWMHm0=
X-Received: by 2002:a05:600c:3511:b0:38a:1ca:da21 with SMTP id
 h17-20020a05600c351100b0038a01cada21mr13738636wmq.170.1647739379744; Sat, 19
 Mar 2022 18:22:59 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6000:2c1:0:0:0:0 with HTTP; Sat, 19 Mar 2022 18:22:58
 -0700 (PDT)
In-Reply-To: <CAH2r5mv2E=zQ+nVjMuLGvz3CGMLxM2Cq4aUEnLd3ieRCQTOM8Q@mail.gmail.com>
References: <CAH2r5mvG6jmUKVi4zqRouFgYSjYxJjTExjmPtH64PAjFahE8dQ@mail.gmail.com>
 <570f1f21-ecd2-6f88-e78f-7c57a22ba7e9@talpey.com> <283E0E80-BDAA-45B4-B627-C7BF44C0D126@cjr.nz>
 <CAH2r5mv2E=zQ+nVjMuLGvz3CGMLxM2Cq4aUEnLd3ieRCQTOM8Q@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 20 Mar 2022 10:22:58 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_dUnBLmAutFVWpOczRH-3U21vR51nHsNTjAVfUk1KEig@mail.gmail.com>
Message-ID: <CAKYAXd_dUnBLmAutFVWpOczRH-3U21vR51nHsNTjAVfUk1KEig@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix bad fids sent over wire
To:     Steve French <smfrench@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, Tom Talpey <tom@talpey.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-03-20 3:34 GMT+09:00, Steve French <smfrench@gmail.com>:
> They probably should be always 'u64' everywhere (not le64) and change
> the code back in fs/smbfs_common/smb2pdu.h (was this due to ksmbd
> using the file and converting these fields in fs/smbfs_common) rather
> than the ones you changed
I don't understand why only FileId fields should be declared as u64 not le64.
It means that FileID doesn't need byteswap in client? samba seems to
stores them in little-endian byte order.

#define SBVAL(p, ofs, v) PUSH_LE_U64(p, ofs, v)

        SBVAL(outbody.data, 0x40,
              out_file_id_persistent);          /* file id (persistent) */
        SBVAL(outbody.data, 0x48,
              out_file_id_volatile);            /* file id (volatile) */

Am I missing something ?
>
>
> On Sat, Mar 19, 2022 at 11:01 AM Paulo Alcantara <pc@cjr.nz> wrote:
>>
>> Yes, I agreed. Why not simply store them as le64 and avoid the
>> byteswapping altogether?
>>
>> On 19 March 2022 09:06:55 GMT-03:00, Tom Talpey <tom@talpey.com> wrote:
>>>
>>>
>>> On 3/19/2022 12:23 AM, Steve French wrote:
>>>>
>>>> Any comments on Paulo's patch? It fixes an endian conversion problem
>>>> that can affect file ids used on big endian archs.  I will add cc:
>>>> stable
>>>>
>>>> https://git.cjr.nz/linux.git/commit/?h=cifs-bad-fid-fixes&id=a857bb6b15646a7946fafb281878ddf498107dc3
>>>
>>>
>>> It seems a bad idea to be storing opaque fields in le64 integers, then
>>> byteswapping them when they go back on the wire. Wouldn't it be better
>>> to make them u8[8] arrays and just use memcpy/memcmp?
>>>
>>> Tom.
>
>
>
> --
> Thanks,
>
> Steve
>
