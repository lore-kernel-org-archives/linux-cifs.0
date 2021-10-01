Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96006C433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 01:10:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D4DB61A3F
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Oct 2021 01:10:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349773AbhJABLz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Sep 2021 21:11:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349760AbhJABLz (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 30 Sep 2021 21:11:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16CEE61A57
        for <linux-cifs@vger.kernel.org>; Fri,  1 Oct 2021 01:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633050612;
        bh=ijk9ONabiMGfJInpon+X+Q8Ex/XCsCcc3ikTKZxhEcU=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=HC9xtxjMR0E8OCikjtIbgJqQHNodCE68LBMxcLbOCHUYXt92ZOTlUO7sWx08J4VbZ
         yzAo2qrWHv60dLQeikTkNrk+JTUEDr5cv7KFwZHy0u3C4MqeTc68/1ZzeEDlrb/7HA
         9gm8cLMwXEiU3merUeSvGuTsmiD014L169POrE0Hd6EuO+qr2Ip25b5Xl2nHeL6sRH
         goqKoadK6Ur0diDqqoVZB38IP/qOM0d+c2OyrxGMpTZQnGjxYxVaEQzXLCiuJoGxom
         TxW8Ux8sc8yfGpWdGhaqy/5FnkDtcCIbRXk8aAqzsEaYITZ2e6wzg1i3l+zUiWX0//
         LG1KaIaLwgN/w==
Received: by mail-ot1-f51.google.com with SMTP id 5-20020a9d0685000000b0054706d7b8e5so9617095otx.3
        for <linux-cifs@vger.kernel.org>; Thu, 30 Sep 2021 18:10:12 -0700 (PDT)
X-Gm-Message-State: AOAM5337GiMUyeItpGGseDP5CQHKvVMEf56n3rQqgtp5kM72SUTfWwYk
        gqKSlaCyZt+AXy5S/82xGy85XruOpNnCH72CYwU=
X-Google-Smtp-Source: ABdhPJzJ8orDgs78RebM4AzVMOyJ7Bzrkvavp8H66cEFKU/QdJvH2UCBGdyCYfUXw+Uyc29U024DHjyo2D/runmaEfI=
X-Received: by 2002:a9d:729d:: with SMTP id t29mr8078182otj.61.1633050611365;
 Thu, 30 Sep 2021 18:10:11 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Thu, 30 Sep 2021 18:10:10
 -0700 (PDT)
In-Reply-To: <40575524-51ff-0c78-98d9-23878e8390fb@samba.org>
References: <20210929084501.94846-1-linkinjeon@kernel.org> <bf665917-cf8c-30ca-4ce0-4614adaf0988@samba.org>
 <CAKYAXd-A4FLznKAVesfOiSpNy0KPAkXUppN4rkbGPBMdBMQLkA@mail.gmail.com>
 <2b536a89-cba6-88a0-b7d8-c5435d183679@samba.org> <CAKYAXd87aCAMZ56Ch68-NRjCH41MDdYYHUOSo3mfiMAOq_+QFA@mail.gmail.com>
 <40575524-51ff-0c78-98d9-23878e8390fb@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 1 Oct 2021 10:10:10 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8uU=4U1+_rXNeNtu1sAztshzXVi2SGVjcuSSmVtTc+8A@mail.gmail.com>
Message-ID: <CAKYAXd8uU=4U1+_rXNeNtu1sAztshzXVi2SGVjcuSSmVtTc+8A@mail.gmail.com>
Subject: Re: [PATCH v4 0/9] ksmbd: a bunch of patches that is being reviewed
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-30 22:33 GMT+09:00, Ralph Boehme <slow@samba.org>:
> Am 30.09.21 um 15:17 schrieb Namjae Jeon:
>> 2021-09-30 21:53 GMT+09:00, Ralph Boehme <slow@samba.org>:
>>> yes, this was next on my list, sorry forgot to mention this. Afaict in
>>> the current code the session and tcon checks are only done once on the
>>> first SMB2 PDU for a series of compound non-related PDUs, while for
>>> non-related PDUs the calls to check_user_session() and
>>> smb2_get_ksmbd_tcon() should be probably be done inside
>>> __process_request(), or eventually just inside
>>> ksmbd_smb2_check_message().
>> check_user_session and get_ksmbd_tcon should not be moved inside
>> __process_request()
>> because session id and tree id of related pdu is 0xFFFFFFFFFFFFFFFF
>> and 0xFFFFFFFF.
>
> of course, but that must just be handled by those functions. I'm
> currently working on tentative fix for this.
1. You need to check header size of related pdu of compound request is
already checked in the is_chained_smb2_message function.

is_chained_smb2_message()
...
        if (next_cmd > 0) {
                if ((u64)work->next_smb2_rcv_hdr_off + next_cmd +
                        __SMB2_HEADER_STRUCTURE_SIZE >
                    get_rfc1002_len(work->request_buf)) {
                        pr_err("next command(%u) offset exceeds smb msg size\n",
                               next_cmd);
                        return false;
                }

2. session id and tree id only needs to be checked in the header of
the first pdu regardless of compound and single one.

So I don't know what would be better if I moved it.

Thanks!
>
>>
>>>
>>>> is_chained_smb2_message is
>>>> checking next command header size.
>>>>>
>>>>> You also dropped the fix for the possible invalid read in
>>>>> ksmbd_verify_smb_message() of the protocol_id field.
>>>> Where ? You are saying your patch in github ? If it is right, I didn't
>>>> drop.
>>>
>>> this one:
>>>
>>> <https://github.com/smfrench/smb3-kernel/commit/ffc410f1d19a0f06a952c7f28e9bca4fa4bd4a74>
>> Ah.. You pushed this patch to ksmbd-for-next-pending ?
>> Sorry for that, my mistake, I will check branch before applying my patch.
>
> Yeah, the whole patchset is in the branch ksmbd-for-next-pending which
> is actually the one you correctly used for the comments on github. :)
Ah.. okay.
I will carefully check it next time.

Thanks!
>
> Cheers!
> -slow
>
> --
> Ralph Boehme, Samba Team                 https://samba.org/
> SerNet Samba Team Lead      https://sernet.de/en/team-samba
>
