Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CDF2C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Sep 2021 13:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45EDD613A7
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Sep 2021 13:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350632AbhI3NTN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Sep 2021 09:19:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350846AbhI3NTM (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 30 Sep 2021 09:19:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 623F5613A7
        for <linux-cifs@vger.kernel.org>; Thu, 30 Sep 2021 13:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633007850;
        bh=By1OvL0LX2mnfUweruemegd44RileLdcFc7ukBhhYkA=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=qapPKNwEfd0hIak3peuW2k3f2Mpws/GOP9GuaFBARZGseBjY0rWRivoN/NY7JDm8V
         qs3ZIy4PoTjOOE6CLA5JrorvaSKoHMLM/o7K183t4VUMiS4L5XiPaCT+8/itshfMVB
         ujW1yNnOUryThvvxSl6mfGPkX0Ggl4PHLx81j35pkVrb3Dr94toINmDdK3UTkqIHWS
         c7iZHf2n8r72L1cLHqTy8M6NpAiyFQabtdJ64AdP4KhP7H6HBPc763RJ+ma3Ohq22w
         AuUj8otJiT2SRgBsMOmRAMcRYmD3arvNno2+y9MBxnOZXSg5TZt7jq2qZZLD3fY5pc
         zrhYB+QIt/Tqg==
Received: by mail-oi1-f173.google.com with SMTP id t189so7185311oie.7
        for <linux-cifs@vger.kernel.org>; Thu, 30 Sep 2021 06:17:30 -0700 (PDT)
X-Gm-Message-State: AOAM530WBWFce/vjrAHlzW5ODH41KPDCEX0H4eDmiQ0HIjF54ReiG3D4
        DnWZituhVRu4t6nMUkuFPPcL0MKPhH3OCG9MXh8=
X-Google-Smtp-Source: ABdhPJxXau3kSlC8cb1eKMAaOGhRx++7zbIu5K5ZnThU+366DP6E3nUCCWzL5TnntZexTobyJnI6vRT6aKxwT9qIWiU=
X-Received: by 2002:aca:3704:: with SMTP id e4mr2757298oia.32.1633007849704;
 Thu, 30 Sep 2021 06:17:29 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Thu, 30 Sep 2021 06:17:29
 -0700 (PDT)
In-Reply-To: <2b536a89-cba6-88a0-b7d8-c5435d183679@samba.org>
References: <20210929084501.94846-1-linkinjeon@kernel.org> <bf665917-cf8c-30ca-4ce0-4614adaf0988@samba.org>
 <CAKYAXd-A4FLznKAVesfOiSpNy0KPAkXUppN4rkbGPBMdBMQLkA@mail.gmail.com> <2b536a89-cba6-88a0-b7d8-c5435d183679@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 30 Sep 2021 22:17:29 +0900
X-Gmail-Original-Message-ID: <CAKYAXd87aCAMZ56Ch68-NRjCH41MDdYYHUOSo3mfiMAOq_+QFA@mail.gmail.com>
Message-ID: <CAKYAXd87aCAMZ56Ch68-NRjCH41MDdYYHUOSo3mfiMAOq_+QFA@mail.gmail.com>
Subject: Re: [PATCH v4 0/9] ksmbd: a bunch of patches that is being reviewed
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-30 21:53 GMT+09:00, Ralph Boehme <slow@samba.org>:
> Am 30.09.21 um 03:01 schrieb Namjae Jeon:
>> 2021-09-30 2:55 GMT+09:00, Ralph Boehme <slow@samba.org>:
>>> Am 29.09.21 um 10:44 schrieb Namjae Jeon:
>>>> Cc: Tom Talpey <tom@talpey.com>
>>>> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>>>> Cc: Ralph B=C3=B6hme <slow@samba.org>
>>>> Cc: Steve French <smfrench@gmail.com>
>>>> Cc: Hyunchul Lee <hyc.lee@gmail.com>
>>>> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
>>>>
>>>> v2:
>>>>     - update comments of smb2_get_data_area_len().
>>>>     - fix wrong buffer size check in fsctl_query_iface_info_ioctl().
>>>>     - fix 32bit overflow in smb2_set_info.
>>>>
>>>> v3:
>>>>     - add buffer check for ByteCount of smb negotiate request.
>>>>     - Moved buffer check of to the top of loop to avoid unneeded
>>>> behavior
>>>> when
>>>>       out_buf_len is smaller than network_interface_info_ioctl_rsp.
>>>>     - get correct out_buf_len which doesn't exceed max stream protocol
>>>> length.
>>>>     - subtract single smb2_lock_element for correct buffer size check
>>>> in
>>>>       ksmbd_smb2_check_message().
>>>>
>>>> v4:
>>>>     - use work->response_sz for out_buf_len calculation in smb2_ioctl.
>>>>     - move smb2_neg size check to above to validate
>>>> NegotiateContextOffset
>>>>       field.
>>>>     - remove unneeded dialect checks in smb2_sess_setup() and
>>>>       smb2_handle_negotiate().
>>>>     - split smb2_set_info patch into two patches(declaring
>>>>       smb2_file_basic_info and buffer check)
>>>
>>> it looks like you dropped all my patches and didn't comment on the
>>> SQUASHES that pointed at some issues.
>>>
>>> Did I miss anything where you explained why you did this?
>> Please see v4 change list in this cover letter
>>    - use work->response_sz for out_buf_len calculation in smb2_ioctl.
>>    - split smb2_set_info patch into two patches(declaring...
>>
>> I didn't apply "SQUASH: at this layer we should only against the
>> MAX_STREAM_PROT_LEN =E2=80=A6"
>> because smb2 header is used before ksmbd_verify_smb_message is reached.
>> See init_rsp_hdr and check_user_session() in __handle_ksmbd_work().
>
> Let me check.
>
>> Have you checked my comments on your squash patches of github ?
>> I didn't get any response from you :)
>
> Oh my! Looks like I didn't get github email notifications so I wasn't
> aware of your comments... Sorry! :) Currently taking a look.
>
>>>
>>> The changes I made imho consolidated the SMB2 PDU packet size checking
>>> logic. With your changes the check for valid SMB2 PDU sizes of compound
>>> offsets is spread across the network receive layer and the compound
>>> parsing layer.
>>>
>>> The changes I made, adding a nice helper function along the way, moved
>>> the core PDU validation into the function were it should be done: insid=
e
>>> ksmbd_smb2_check_message().
>> ksmbd is checking whether session id and tree id are vaild in smb
>> header before processing smb requests.
>
> yes, this was next on my list, sorry forgot to mention this. Afaict in
> the current code the session and tcon checks are only done once on the
> first SMB2 PDU for a series of compound non-related PDUs, while for
> non-related PDUs the calls to check_user_session() and
> smb2_get_ksmbd_tcon() should be probably be done inside
> __process_request(), or eventually just inside ksmbd_smb2_check_message()=
.
check_user_session and get_ksmbd_tcon should not be moved inside
__process_request()
because session id and tree id of related pdu is 0xFFFFFFFFFFFFFFFF
and 0xFFFFFFFF.

>
>> is_chained_smb2_message is
>> checking next command header size.
>>>
>>> You also dropped the fix for the possible invalid read in
>>> ksmbd_verify_smb_message() of the protocol_id field.
>> Where ? You are saying your patch in github ? If it is right, I didn't
>> drop.
>
> this one:
>
> <https://github.com/smfrench/smb3-kernel/commit/ffc410f1d19a0f06a952c7f28=
e9bca4fa4bd4a74>
Ah.. You pushed this patch to ksmbd-for-next-pending ?
Sorry for that, my mistake, I will check branch before applying my patch.
>
> And also the cleanup commits using ksmbd_req_buf_next() in a few places.
>
>>> I might be missing something because I'm still new to the code. But
>>> generally we really sanitize the logic while we're at it now instead of
>>> adding band aids everywhere.
>> I saw your patch and it's nice. However, we have not yet agreed on
>> where the review will be conducted. You also didn't respond to my
>> comments on my squash patch in your github. So I thought I'd take a
>> deeper look if you send the patch to the list.
>
> I realize that my well thought idea to idea of simplifying things by
> pushing my larger changes to github is not going very well. :) Therefor
> I'll resubmit the patchset to the ML later on.
>
> Fwiw, here's is what an actual review on github on a MR would look like:
>
> <https://github.com/smfrench/smb3-kernel/pull/72>
>
> This was just an experiment. It demonstrates a few features: tracking
> comments, tracking new pushes to the source branch and other related
> actions.
>
> Note that I'm NOT PROPOSING using github MRs right away. Just showing
> what's possible. :)
Sound good. Thanks for your check:)
>
> -slow
>
> --
> Ralph Boehme, Samba Team                 https://samba.org/
> SerNet Samba Team Lead      https://sernet.de/en/team-samba
>
