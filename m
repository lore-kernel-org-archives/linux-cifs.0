Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9DE8C433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Oct 2021 23:42:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94A62610FB
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Oct 2021 23:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbhJFXob (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 6 Oct 2021 19:44:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230213AbhJFXoa (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 6 Oct 2021 19:44:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2155610E6
        for <linux-cifs@vger.kernel.org>; Wed,  6 Oct 2021 23:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633563757;
        bh=Z4p58elpy5bG1NJHNYxrkiQH0sSfV+N6oSnPlqFQI+Q=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=gyFdphtluDuiEJujgKK39OIlOyg1618PklHGpDwSd7eIcCDyCirAYd0mWx7O1taBs
         7bonSE9yzhDuH8KLoGGgKJo1LmpKCgXpBLYW81oV56Qb1GGUuy1SknficdQMlzNTXU
         aJ7BqADG/wtBYtEAgVart0ZW4FF2DTLDm4YPYy2u3a9RXv0d5Xzt63uo8AM1et3aa0
         P+2iv2JT4QNwa2Zl5o5QpPkGPZIGoRFvVLRjATy5EqpfM+mY4NMxEYps+748valmU/
         0BPu+qOmswc7X4Ks8uNcTY98vQPG8/6NsrXlB/SQOsDYSixf4HO/EPOkcoQwfgSl7u
         MOLPwNMu8PLOA==
Received: by mail-ot1-f49.google.com with SMTP id g15-20020a9d128f000000b0054e3d55dd81so147928otg.12
        for <linux-cifs@vger.kernel.org>; Wed, 06 Oct 2021 16:42:37 -0700 (PDT)
X-Gm-Message-State: AOAM531DIj7IazftH1kXEyp1R2sgDOS4p3N7xirAmcMGYEy0DxCY7pwZ
        uMFUFsxI/sBetCly9JoBvuMfK299H4BRTJP4G0g=
X-Google-Smtp-Source: ABdhPJxCVFKFRjoKu9XhWo/94gjdiWHMwiDopgSl/O9Gn8gF9p8vIJ+dbQpdIkEFgPPlj9OTl9sEG+Q6fxDG5uLhA3A=
X-Received: by 2002:a05:6830:17da:: with SMTP id p26mr995482ota.116.1633563757330;
 Wed, 06 Oct 2021 16:42:37 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Wed, 6 Oct 2021 16:42:36 -0700 (PDT)
In-Reply-To: <2565d01b-0145-fe8b-1ce4-9c8f2e658b62@samba.org>
References: <20211005050343.268514-1-slow@samba.org> <20211005050343.268514-4-slow@samba.org>
 <CAKYAXd8TxcswXC3oySaLKOuCGzV2Dvfdv_1DaG9S_ErY_MvDMQ@mail.gmail.com> <2565d01b-0145-fe8b-1ce4-9c8f2e658b62@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 7 Oct 2021 08:42:36 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_n9cBO6+ND9axR8qFtEpfL9qvq+Zyon1PiLbZ0=AOPWQ@mail.gmail.com>
Message-ID: <CAKYAXd_n9cBO6+ND9axR8qFtEpfL9qvq+Zyon1PiLbZ0=AOPWQ@mail.gmail.com>
Subject: Re: [PATCH v7 3/9] ksmbd: add and use ksmbd_smb2_cur_pdu_buflen() in ksmbd_smb2_check_message()
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-05 16:46 GMT+09:00, Ralph Boehme <slow@samba.org>:
> Am 05.10.21 um 09:29 schrieb Namjae Jeon:
>> 2021-10-05 14:03 GMT+09:00, Ralph Boehme <slow@samba.org>:
>>> -		if (ALIGN(clc_len, 8) == len)
>>> +		if (ALIGN(clc_len, 8) == ALIGN(len, 8))
>> Can I know why you align rfc1002 len with 8 here ?
>
> this should match the previous behaviour where for compound requests we
> called round_up(len, 8).
>
> This could be done differently though:
>
> len = ksmbd_smb2_cur_pdu_buflen(work);
> if (work->next_smb2_rcv_hdr_off)
>          len = ALIGN(len, 8);
I think that this code is wrong, we don't need to add pad about last
compound *request* length.

Thanks!

>
> and then just do
>
>                  if (ALIGN(clc_len, 8) == len)
>
> -slow
>
> --
> Ralph Boehme, Samba Team                 https://samba.org/
> SerNet Samba Team Lead      https://sernet.de/en/team-samba
>
