Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 775A9C77B73
	for <linux-cifs@archiver.kernel.org>; Sun,  7 May 2023 00:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbjEGAzY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 6 May 2023 20:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbjEGAzJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 6 May 2023 20:55:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070A2B6
        for <linux-cifs@vger.kernel.org>; Sat,  6 May 2023 17:53:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6C6C60BCC
        for <linux-cifs@vger.kernel.org>; Sun,  7 May 2023 00:52:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416BDC4339B
        for <linux-cifs@vger.kernel.org>; Sun,  7 May 2023 00:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683420765;
        bh=LztuYNVT8NGSUZLbFhvcaPY4HS/xBVu17LhtSP6Hsbo=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Hx8kErMv275sHfcnpg+PeyfSXJdQCO2rhQrwjgVvnIozLm3tQjb/8h4jGHSaMlmfF
         BnXNw2K1993LcZZAFKLYO/6GRrHUCMjwlAiUSKokU9Z9iaUne82YOI3Ym2vWq6cgkH
         fzPe6uPK0BgnYKVeQXDXhmkX/4zL911ZAWQCVmmAwCraoowgDoX2NMlctGF2vZwHmu
         EGUc0A3mKsWrOTH6vXbN5jfDAITcZ1kij855k+CMUqJmjOMdCtonDynKU5vptSjL8g
         PPD706RCg9WJd7qSzwpfDzh7Jd6gLCusvxLYrjg/J/z0EVxf1c9gj66i2eVwJVRQYJ
         22nhGHdOUZZKw==
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-541f2112f82so1047332eaf.1
        for <linux-cifs@vger.kernel.org>; Sat, 06 May 2023 17:52:45 -0700 (PDT)
X-Gm-Message-State: AC+VfDzc446JONFuAIut2HA/MfFNwqVFVp8ypeawS+ZvRHIOpahHSjef
        UlmKkuJ17/MZxW8TtJ+Y2d8ynVuoW+h+aqwhqiw=
X-Google-Smtp-Source: ACHHUZ6gsJ8YkcYIiPgvZKN9AvivUSbiPlrWaVB2ltSNrZTfX0YrrqE7FFVJvOTNxcmUEHtprq//6Ghgy6oGb604sBM=
X-Received: by 2002:a05:6808:286:b0:390:77fa:1fce with SMTP id
 z6-20020a056808028600b0039077fa1fcemr2531781oic.40.1683420764422; Sat, 06 May
 2023 17:52:44 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:981:0:b0:4d3:d9bf:b562 with HTTP; Sat, 6 May 2023
 17:52:43 -0700 (PDT)
In-Reply-To: <20230506031039.GD3281499@google.com>
References: <20230505151108.5911-1-linkinjeon@kernel.org> <20230505151108.5911-2-linkinjeon@kernel.org>
 <20230506031039.GD3281499@google.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 7 May 2023 09:52:43 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9SARDpzhwJ=MbNK5usEGnbD8KgCnVejsJVK4Z6qjRoRg@mail.gmail.com>
Message-ID: <CAKYAXd9SARDpzhwJ=MbNK5usEGnbD8KgCnVejsJVK4Z6qjRoRg@mail.gmail.com>
Subject: Re: [PATCH 2/6] ksmbd: fix wrong UserName check in session_user
To:     Pumpkin <cc85nod@gmail.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, tom@talpey.com,
        atteh.mailbox@gmail.com,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-05-06 12:10 GMT+09:00, Sergey Senozhatsky <senozhatsky@chromium.org>:
> On (23/05/06 00:11), Namjae Jeon wrote:
>> The offset of UserName is related to the address of security
>> buffer. To ensure the validaty of UserName, we need to compare name_off
>> + name_len with secbuf_len instead of auth_msg_len.
>>
>> [   27.096243]
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> [   27.096890] BUG: KASAN: slab-out-of-bounds in
>> smb_strndup_from_utf16+0x188/0x350
>> [   27.097609] Read of size 2 at addr ffff888005e3b542 by task
>> kworker/0:0/7
>> ...
>> [   27.099950] Call Trace:
>> [   27.100194]  <TASK>
>> [   27.100397]  dump_stack_lvl+0x33/0x50
>> [   27.100752]  print_report+0xcc/0x620
>> [   27.102305]  kasan_report+0xae/0xe0
>> [   27.103072]  kasan_check_range+0x35/0x1b0
>> [   27.103757]  smb_strndup_from_utf16+0x188/0x350
>> [   27.105474]  smb2_sess_setup+0xaf8/0x19c0
>> [   27.107935]  handle_ksmbd_work+0x274/0x810
>> [   27.108315]  process_one_work+0x419/0x760
>> [   27.108689]  worker_thread+0x2a2/0x6f0
>> [   27.109385]  kthread+0x160/0x190
>> [   27.110129]  ret_from_fork+0x1f/0x30
>> [   27.110454]  </TASK>
>>
>> Signed-off-by: Pumpkin <cc85nod@gmail.com>
>
> Do we still have a requirement that there should be a real name in SoB?
Hi =E5=BC=B5=E6=99=BA=E8=AB=BA,

I will update SoB if you tell me your english real name.

Thanks.
>
