Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38FBCC77B7A
	for <linux-cifs@archiver.kernel.org>; Sun, 21 May 2023 01:22:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjEUBWx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 20 May 2023 21:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbjEUBWr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 20 May 2023 21:22:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E31F133
        for <linux-cifs@vger.kernel.org>; Sat, 20 May 2023 18:22:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7E7761028
        for <linux-cifs@vger.kernel.org>; Sun, 21 May 2023 01:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C75CC433D2
        for <linux-cifs@vger.kernel.org>; Sun, 21 May 2023 01:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684632149;
        bh=Y3lkFsSBsLBAem8XPuae70PRukkgqDdWJ9aLl/2cttg=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=jjSHJVplav7evcvZhKMdaglhyFqnM3REf0tnOLaOCtpdlvdMDuDUbT9594vNy8dXb
         Z5bojVyluzsGLCv7NQ/Mg8x/2iOQHySDwKo1iUfY+yub4/LFdVECALBBHG7JLyW8O9
         CBg9tsS41gnl75PzAbpF7AsSpmah3Q+s2mHdwtshMZjZtMbi+s3TwZC5NeqDKUTHNT
         OvN2Dq0IHH+oIsJ6INoOKbXBfJxlEicppPV6lZy+gY/Y96S9L31OE96O2kdCHQWefo
         PRvtXH2tqCznGylAOkIre2KvA+b0vkuZadcKVl5hYM0Z795MMSMRg3hZO2kRVs+8ga
         eGWRixDGB8YYg==
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-38ea3f8e413so2607237b6e.2
        for <linux-cifs@vger.kernel.org>; Sat, 20 May 2023 18:22:29 -0700 (PDT)
X-Gm-Message-State: AC+VfDzkeQqw8xQkJjh35Nj0xZtfIiD8AEVVvM3cT3YqO4sgRuT9xXoC
        Yu/lsMT1oRN0UYB+y7TRArInJVpotjVsqqzpGxU=
X-Google-Smtp-Source: ACHHUZ4A7BW30LMlnnQb4LzC+4TTCt5IFmpqSCdYljnudpwyQd8wLPYWWmdxjm0G32jlNTjqi6sVFQ4qpw6KxbUg2pg=
X-Received: by 2002:a05:6808:3a1:b0:392:1037:f50c with SMTP id
 n1-20020a05680803a100b003921037f50cmr3423283oie.0.1684632148367; Sat, 20 May
 2023 18:22:28 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:6415:0:b0:4da:311c:525d with HTTP; Sat, 20 May 2023
 18:22:27 -0700 (PDT)
In-Reply-To: <CAAn9K_sJBAEcz=EM1O+sJOmtp=Yq3nW6g_Z+mYJLnCmj1ZANSw@mail.gmail.com>
References: <CAAn9K_sJBAEcz=EM1O+sJOmtp=Yq3nW6g_Z+mYJLnCmj1ZANSw@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 21 May 2023 10:22:27 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9_jm_4y2NvkyjYZaDLQMLiaBaOy4d860F9uzrvKrTbMQ@mail.gmail.com>
Message-ID: <CAKYAXd9_jm_4y2NvkyjYZaDLQMLiaBaOy4d860F9uzrvKrTbMQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: check the validation of pdu_size in ksmbd_conn_handler_loop
To:     =?UTF-8?B?5by15pm66Ku6?= <cc85nod@gmail.com>
Cc:     linux-cifs@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>, tom@talpey.com,
        atteh.mailbox@gmail.com, Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-05-21 2:25 GMT+09:00, =E5=BC=B5=E6=99=BA=E8=AB=BA <cc85nod@gmail.com>:
> From ec0d45674df77bd3344717de3eae68de70210829 Mon Sep 17 00:00:00 2001
> From: Pumpkin <cc85nod@gmail.com>
> Date: Sun, 21 May 2023 01:04:41 +0800
> Subject: [PATCH] ksmbd: check the validation of pdu_size in
>  ksmbd_conn_handler_loop
>
> The length field of netbios header must be greater than the SMB header
> size, otherwise the packet is an invalid SMB packet.
>
> If `pdu_size` is 0, ksmbd allocates a 4 bytes chunk to `conn->request_buf=
`.
> In the function `get_smb2_cmd_val` ksmbd will read cmd from
> `rcv_hdr->Command`,
> which is `conn->request_buf + 12`, causing the KASAN detector to print th=
e
> following error message:
>
> [    7.205018] BUG: KASAN: slab-out-of-bounds in get_smb2_cmd_val+0x45/0x=
60
> [    7.205423] Read of size 2 at addr ffff8880062d8b50 by task
> ksmbd:42632/248
> ...
> [    7.207125]  <TASK>
> [    7.209191]  get_smb2_cmd_val+0x45/0x60
> [    7.209426]  ksmbd_conn_enqueue_request+0x3a/0x100
> [    7.209712]  ksmbd_server_process_request+0x72/0x160
> [    7.210295]  ksmbd_conn_handler_loop+0x30c/0x550
> [    7.212280]  kthread+0x160/0x190
> [    7.212762]  ret_from_fork+0x1f/0x30
> [    7.212981]  </TASK>
>
> Signed-off-by: Pumpkin <cc85nod@gmail.com>
Real name? please change your gitconfig.
> ---
>  fs/ksmbd/connection.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
> index 4ed379f9b..2a7748694 100644
> --- a/fs/ksmbd/connection.c
> +++ b/fs/ksmbd/connection.c
> @@ -343,6 +343,11 @@ int ksmbd_conn_handler_loop(void *p)
>   READ_ONCE(conn->status));
>   break;
>   }
> +
> + if (pdu_size < sizeof(struct smb2_hdr)) {
> + pr_err("PDU length(%u) is less than SMB header size\n", size);
> + break;
> + }
OK. It will block smb1 negotiate request, We need to allow only smb1
negotiate in smb1 commands for auto negotiation. It will cause windows
client connection failure. So We need to check if protocol id is smb2
for this check. and +4 is needed for rfc1002 length If you want
pdu_size to be greater than or equal to the smb2 header size. i.e.
declare the macro like the following.

#define KSMBD_MIN_SUPPORTED_HEADER_SIZE	(sizeof(struct smb2_hdr) + 4)

Thanks for your work!
>
>   /*
>   * Check maximum pdu size(0x00FFFFFF).
> --
> 2.39.2 (Apple Git-143)
>
