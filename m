Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1263AC433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Sep 2021 04:16:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFAEB61074
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Sep 2021 04:16:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbhIIESE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Sep 2021 00:18:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229466AbhIIESE (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 9 Sep 2021 00:18:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AB8F61176
        for <linux-cifs@vger.kernel.org>; Thu,  9 Sep 2021 04:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631161015;
        bh=Tn4os64hSNEXerA9xyRFds8OGdPO55TJqkw4M8VZdHk=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=qIZhRnr8qtErCC+1h/LB7AMX6hGZgwv2BfNqPEzLVrlIOM/4VnE6ykUzyMIxq7iab
         3c0H0bHrQkqyduiFDSGSSStW7e6+CisTcdgTu9HQbdZKYQEUdnBMyI4gV+ieoHL6T9
         L7zjn3UqynnJsRSbMaKEwfhFFsESSzvUuap/W/B5wTcuZ9c3wDM5Y4uGqzupUdNdiG
         zz4A6uEpoq6yEqJyxDaw+/LnUKOh1TEbc66uok4F/Y/xaoWFlsVwqnSlkQwbhMQuPm
         HVdXkQLkmtw6xvG9OgYiBmRB61jpbdREo0K8BhRx4atJA4E5/57bt7GkbdpluxDtF0
         ACHXhUejsDF+Q==
Received: by mail-oi1-f178.google.com with SMTP id s20so927911oiw.3
        for <linux-cifs@vger.kernel.org>; Wed, 08 Sep 2021 21:16:55 -0700 (PDT)
X-Gm-Message-State: AOAM530yunEtOZHg0WI24CaCG9Yxnq9PIxcXiEyDzGhfIuO2l639UVLj
        O385y2MGDVUbJcJEquPScTJ5ym9/w6zN1JvWFTI=
X-Google-Smtp-Source: ABdhPJwxZO5cc8jZGNDbfdcFhUv7PUz+CMXLZhJ76wkbEcTYvS6DaiS5sptz3zrTu4X+AQOwkQYhyzp2lD1j6Kt0lZI=
X-Received: by 2002:aca:bfc6:: with SMTP id p189mr651429oif.167.1631161014845;
 Wed, 08 Sep 2021 21:16:54 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:74d:0:0:0:0:0 with HTTP; Wed, 8 Sep 2021 21:16:54 -0700 (PDT)
In-Reply-To: <CAH2r5muPAMpzx==_9hh6owMWLX_Gh2c8ecYOUA_LSP6ZEiNDZg@mail.gmail.com>
References: <CAH2r5muuLpCj2W1JFUm8UqvLhb6Js+qR76pTMmWu4jiyzV6QEQ@mail.gmail.com>
 <CAKYAXd_Ld1X2tmeBQkDEWd6rzW8xDNsO+SgR6adifgnKtRX7Ug@mail.gmail.com> <CAH2r5muPAMpzx==_9hh6owMWLX_Gh2c8ecYOUA_LSP6ZEiNDZg@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 9 Sep 2021 13:16:54 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8+dtNF9jTcDVkM8Gj3wXReChbTCFajj+F_9DDyKQ3YZg@mail.gmail.com>
Message-ID: <CAKYAXd8+dtNF9jTcDVkM8Gj3wXReChbTCFajj+F_9DDyKQ3YZg@mail.gmail.com>
Subject: Re: updated smbfsctl.h to allow for future common version
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-09 13:02 GMT+09:00, Steve French <smfrench@gmail.com>:
> can I simply call it "#ifndef __SMBFSCTL_H"
Yep, Looks good!

Thanks!
>
> On Wed, Sep 8, 2021 at 11:01 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
>> 2021-09-09 11:50 GMT+09:00, Steve French <smfrench@gmail.com>:
>> > Here is an updated fs/cifs/smbfsctl.h that includes most of the changes
>> in
>> > fs/ksmbd/smbfsctl.h and is updated to include one missing #define from
>> more
>> > recent MS-FSCC
>> >
>> > This would allow us to use a common version of fs/cifs/smbfsctl.h for
>> > server and client
>> We need to rename header guard in diff when moving it to fs/cifs_common.
>> +#ifndef __KSMBD_SMBFSCTL_H
>> +#define __KSMBD_SMBFSCTL_H
>>
>> +#endif /* __KSMBD_SMBFSCTL_H */
>>
>> Thanks!
>> >
>> >
>> >
>> > --
>> > Thanks,
>> >
>> > Steve
>> >
>>
>
>
> --
> Thanks,
>
> Steve
>
