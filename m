Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 561CAC433F5
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Oct 2021 01:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 267B961A7D
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Oct 2021 01:26:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbhJCB1y (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 21:27:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229447AbhJCB1p (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 2 Oct 2021 21:27:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C62C661AF7
        for <linux-cifs@vger.kernel.org>; Sun,  3 Oct 2021 01:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633224358;
        bh=AeGJ+3Bph5tIov3xl9QYb+CicrqtW2waxLLnl6wR5Y4=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=ucQyOK7XzwZyCg6qiibOUK6+0C9mNueTZpoSlz4hsN81EyHc0L2Bk4Eh78Jk7xTQN
         lz3jhmz00bYrg2wE7wNtC9S6Lp78OWQGxwJQW4lJbP+4f6hraSqlhe+LJrLpNdYIDa
         56owj4pB+k8t3FljcfZfnt4zBTXLXTMo5Z5gcwBtv+ezRIjNHmZEFLAy6GHcohJdWS
         VeGECtV8hKfDzD5vjymC9NETeLgEc4grIxEtBB6fONaAxpM6VT7RMPABc5yrtIonV2
         XSJ4qgNGZDUZhZ8m7cddNO79QzzKKkuHl2yZAeqCsDyfV2qtkzFZGwtm0KNPAR0k+2
         SHKdSmOk27IsQ==
Received: by mail-oo1-f48.google.com with SMTP id a17-20020a4a6851000000b002b59bfbf669so4154489oof.9
        for <linux-cifs@vger.kernel.org>; Sat, 02 Oct 2021 18:25:58 -0700 (PDT)
X-Gm-Message-State: AOAM5315evsYmFVmokZzBRvszzGX7kqTsp4Egj2dXAQW0+8hT/0m86fG
        6NvSV9xIoRgXb94cnaaM/SZKYoxGMG9f22scUn4=
X-Google-Smtp-Source: ABdhPJzW3kFFd7AeLI+DRju1SD9pwTJVisuA/tJhgutD8j0xlspS2AlTkP1HVxnOIsh7+JqaAR3nW9urgmyjeRE+6R4=
X-Received: by 2002:a05:6820:1018:: with SMTP id v24mr4397849oor.27.1633224358111;
 Sat, 02 Oct 2021 18:25:58 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Sat, 2 Oct 2021 18:25:57 -0700 (PDT)
In-Reply-To: <965d1971-239c-0cfc-9abb-5b20c9b698e9@samba.org>
References: <20211001120421.327245-1-slow@samba.org> <20211001120421.327245-17-slow@samba.org>
 <CANFS6bauPdTuE-QRuUwLDJD59C62M9dd6Kxoq-emUOib=xiysg@mail.gmail.com> <965d1971-239c-0cfc-9abb-5b20c9b698e9@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Sun, 3 Oct 2021 10:25:57 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-1URTC0gMvEF61M+gHwkZ2rZ7TH0GGX-zbdJrTO7m77g@mail.gmail.com>
Message-ID: <CAKYAXd-1URTC0gMvEF61M+gHwkZ2rZ7TH0GGX-zbdJrTO7m77g@mail.gmail.com>
Subject: Re: [PATCH v5 16/20] ksmbd: check PDU len is at least header plus
 body size in ksmbd_smb2_check_message()
To:     Ralph Boehme <slow@samba.org>
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-02 21:49 GMT+09:00, Ralph Boehme <slow@samba.org>:
> Am 02.10.21 um 14:45 schrieb Hyunchul Lee:
>> Hi Ralph,
>>
>> 2021=EB=85=84 10=EC=9B=94 1=EC=9D=BC (=EA=B8=88) =EC=98=A4=ED=9B=84 9:25=
, Ralph Boehme <slow@samba.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>>>
>>> Note: we already have the same check in is_chained_smb2_message(), but
>>> there it
>>> only applies to compound requests, so we have to repeat the check here =
to
>>> cover
>>> both cases.
>>>
>>> Cc: Namjae Jeon <linkinjeon@kernel.org>
>>> Cc: Tom Talpey <tom@talpey.com>
>>> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>>> Cc: Steve French <smfrench@gmail.com>
>>> Cc: Hyunchul Lee <hyc.lee@gmail.com>
>>> Signed-off-by: Ralph Boehme <slow@samba.org>
>>> ---
>>>   fs/ksmbd/smb2misc.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
>>> index 7ed266eb6c5e..541b39b7a84b 100644
>>> --- a/fs/ksmbd/smb2misc.c
>>> +++ b/fs/ksmbd/smb2misc.c
>>> @@ -338,6 +338,9 @@ int ksmbd_smb2_check_message(struct ksmbd_work
>>> *work)
>>>          if (check_smb2_hdr(hdr))
>>>                  return 1;
>>>
>>> +       if (len < sizeof(struct smb2_pdu) - 4)
>>> +               return 1;
>>> +
>>
>> Do we need this check before accessing any fields of smb2_hdr in
>> ksmbd_verify_smb_message()?
>
> well, my idea was to have the core PDU size checking logic in
> ksmbd_smb2_check_message() and ksmbd_verify_smb_message() merely
> switches between SMB1/SMB2.
Hyunchul  pointed out that this header buffer check should be moved to
the above check_smb2_hdr(). I think that it should be move to the
above ksmbd_smb2_cur_pdu_buflen().

>
> -slow
>
> --
> Ralph Boehme, Samba Team                 https://samba.org/
> SerNet Samba Team Lead      https://sernet.de/en/team-samba
>
