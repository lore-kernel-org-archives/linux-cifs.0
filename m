Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5665C71153
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Aug 2023 15:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237049AbjH2PF6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 29 Aug 2023 11:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237050AbjH2PFa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 29 Aug 2023 11:05:30 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF38199
        for <linux-cifs@vger.kernel.org>; Tue, 29 Aug 2023 08:05:26 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id 3f1490d57ef6-d77b9d574f8so3969492276.2
        for <linux-cifs@vger.kernel.org>; Tue, 29 Aug 2023 08:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693321526; x=1693926326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bQl0BGw22qTxaEhf2na9LSuyxRInVzmVAP1kL4EUs/c=;
        b=r8qKCYGI/hwE7Uv11JC68gR7Ua0xvpyC2t9ZIj00Wzni/N+pFgYIVQjyburqLAx1SP
         jF1zs29qPAvgJw7tMFygT/wS6dscNBw5EzSj/xGWnDw0CQIy08YMWB5ght2ru8+tSXz9
         BAHBiEWRdnrX23TSghOEKWRRATOG0JbRLk9lkLxqf/uIm9ZbIdOPjonlc6aLrki25RxV
         LX9lF53M+GO3ZPFFMZE0o/Bp0iZZbHxIJQf3uKGQFC90dIrjYLH99DoOTAmIoKsRWU8+
         T+3yUmtRfB1OEydku3S/QDZgsSOaMZxBfvixezbFmAZG//5QoeQ0nC3dtBkBF9HlFT+c
         Zv5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693321526; x=1693926326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bQl0BGw22qTxaEhf2na9LSuyxRInVzmVAP1kL4EUs/c=;
        b=cSYfWZH+ITcibAiEXmm2tTutyMoK2gEktuqWE2G92ZPkaAT894Pdk3qZTVGFPsKp0H
         sxBd0/FyE1J4SjkhaVVZLmYASdIG1tchw1456dQksKzkybeaofLZUrXUlGVqLc+zHk0T
         +5Hl94lcZEsbsAwZ7U9lru+qltDdfdkEP8QDnnBFjw9GIqW9bem4jpr4ZIEIZznXZ9lc
         4wQRaDPNn7LO1d0TdW4z3NrnSur+mk5uaHy5GVtph+8HKNJWmPFaXdxHpHtihR0Gh3e4
         Ssws1nY9X1RBZgmCY0t9KMNtrQ7rmcJyn9f/BLxRIZJ/dMH/K2bg2QRyCHE0dbBMUrCc
         2YRQ==
X-Gm-Message-State: AOJu0YwrJWSL+3MGL/5nBy8CgGGfDr9+afHuCfpLXuMeJFeaH+I2XPPI
        MZMXDFeChMIYtLpikHAI4lWEOOImU70tBq4tjI0gPRf2sWv4Ng==
X-Google-Smtp-Source: AGHT+IEIff9fzli9lbJlqF4gMm7OCVY96k3zvYWdmo+pSZxvdrxAgtuTdZstJJq2KKImkXZPPfuQSmC948FJCvYGIp4=
X-Received: by 2002:a25:fc15:0:b0:d62:ba45:539f with SMTP id
 v21-20020a25fc15000000b00d62ba45539fmr30652724ybd.43.1693321525914; Tue, 29
 Aug 2023 08:05:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mviQ_UEwqwvaz33dgZwzsqJxYT-xXccNmjW-GvuYokgbA@mail.gmail.com>
 <CADvbK_djw8qB5kfBH6W1-qDtAWqhqc=VSXxe3LdkXkmgvuq-Bw@mail.gmail.com> <CAH2r5msBn-yiZKL8sfd8NyCLnCzrTiDjr_9pqg73icZ_4V3LkA@mail.gmail.com>
In-Reply-To: <CAH2r5msBn-yiZKL8sfd8NyCLnCzrTiDjr_9pqg73icZ_4V3LkA@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 29 Aug 2023 11:05:05 -0400
Message-ID: <CADvbK_foNCexbH4g=9GeJwJ8LD+c43moOkXMg4qtc3yNmZZ7VA@mail.gmail.com>
Subject: Re: SMB3.1.1 QUIC mounts from Linux kernel
To:     Steve French <smfrench@gmail.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Aug 28, 2023 at 2:02=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> For more detail on SMB311 over QUIC (which is already supported by some s=
ervers) which I find exciting and very relevant to many use cases there are=
 some overview presentations at eg:
>
> https://snia.org/sites/default/files/SDC/2020/103-Dantuluri-SMB-Over-QUIC=
-Files.pdf
>
> And
>
> https://www.snia.org/sites/default/files/SDCEMEA/2021/snia-SMB-over-QUIC.=
pdf
>
> And setup instructions for the windows example can be found here: https:/=
/learn.microsoft.com/en-us/windows-server/storage/file-server/smb-over-quic
>
Thanks for sharing the slides, Samba over QUIC is indeed quite mature.

After reading the slides, I can understand how these two QUIC features
work in Samba:

- All packets are always encrypted and handshake is authenticated with TLS =
1.3
- Improved congestion control and loss recovery

But it seems not clear to me how some other features are used in samba:

- Parallel streams of reliable and unreliable application data

Multi-streaming:
How is Samba using the multi-streaming of QUIC? I saw there are Multichanne=
l
in Samba, but I'm not sure it's using multiple connections or multi-streami=
ng
in their implementation.

Unreliable application data:
Does Samba need to transmit unreliable data?

- Exchanges application data in the first round trip (0-RTT)

0-RTT: does Microsoft's Samba over QUIC implementation really support this?
As the handshake of linux in-kernel QUIC happens in userspace, 0-RTT
becomes difficult to implement.

- Survives a change in the clients IP address or port

Connection Migration: This could be a useful feature, but I don't see any
spec in the slides, has their implementation supported it?

Thanks.

> On Sun, Aug 27, 2023, 10:32 Xin Long <lucien.xin@gmail.com> wrote:
>>
>> On Fri, Aug 25, 2023 at 9:08=E2=80=AFAM Steve French <smfrench@gmail.com=
> wrote:
>> >
>> > Xin Long,
>> > I am very interested in trying out LInux kernel SMB3.1.1 mounts using
>> > QUIC but wasn't sure how far along your kernel code was.   Do you have
>> > an update on it?   There was at least one other server type that
>> > implements SMB3.1.1 over QUIC, but probably easiest to test to Windows
>> > server (e.g. in Azure).
>> Got it.
>>
>> As for https://github.com/lxin/quic, it has implemented the basic suppor=
t
>> for most main features, but still some important ones are missing, like
>> Streams and Connection IDs Managements. I'm recently doing interoperabil=
ity
>> testing with other C implementations like picoquic.
>>
>> It still has a long way to go to get into the upstream kernel, but I'm p=
retty
>> sure the need by kernel SMB and NFS will speed this up. I think at the s=
ame
>> time, some work can be done in fs/smb to move things forward.
>>
>> >
>> > The SMB3.1.1 changes are small to support QUIC, and I could do those
>> > (or review yours if you have already done it).
>> >
>> Cool.
>>
>> I don't really have patches and don't know much detail of fs/smb. So it =
will
>> be great if you can try this out on fs/smb.
>>
>> For the test to Windows server, I will let you know once the basic suppo=
rt
>> of the rest features is done in the QUIC implementation, maybe in 1-2 mo=
nths.
>> Meanwhile, on fs/smb side, I think checking tls_server/client_hello_x509=
()
>> API use in net/sunrpc might be helpful for you to design the code in fs/=
smb.
>>
>> Thanks.
