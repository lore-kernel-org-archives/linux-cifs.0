Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44950C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Jan 2022 06:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240670AbiARGkP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 18 Jan 2022 01:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiARGkP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 18 Jan 2022 01:40:15 -0500
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF157C061574
        for <linux-cifs@vger.kernel.org>; Mon, 17 Jan 2022 22:40:14 -0800 (PST)
Received: by mail-vk1-xa2a.google.com with SMTP id w5so4424178vke.12
        for <linux-cifs@vger.kernel.org>; Mon, 17 Jan 2022 22:40:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6Kox8iEi+x0Y+6Ez3+6/MBasLAtS7u3jE0QcMTeBWbs=;
        b=qtWDrfAAFV0QBxvRB8YkNiufr0xi6XTAJNI7Aqv3IM+pqx6jXAdnlSht0Fo3C0EGXN
         2vzZAUhpXDpCYZt1sUYrMsmtxfx03RQK9X5PkEHS+CY/0PUrCsKDP4NF+VoDU1ae/Aap
         7HTI4msjStGPoPobT5ck7v6a/L7RDDSVLr1sitGL3M23zCODmWntaLp4xZ4FcJFPNVUC
         3g912qlcPc29yNRxo3prd40sxwJ6Gv53+3cqPGJzA1mF4CGvml3OTu39vjaj2IMP5yJg
         9sFMWkEFe/mcCUqen0XHKXAZYEB35fcMRZ45HxZSagYJlAqejONeSi8y9I5T3JMe5Zbx
         jv6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6Kox8iEi+x0Y+6Ez3+6/MBasLAtS7u3jE0QcMTeBWbs=;
        b=yd4g1fsPstdGswRFWEbFix38q3WMSNCv93cJ32ehZw2++iS8Fb6V9lUKYTgHqwanZI
         qDs1HG75+XX+FIU04IdwkqC2khV8MpwsZazzIBUYC7MVSTUPElAfqbn1dLsM3LbEESBf
         7XiYBCNk8im0WjbWKJKlvXceU5S2/c8RIiNtYbIJEfZwhxWcRiPYZYfkRW4jVLjbuFz4
         IMZBavIm8moNpolTMrJN2/F12J11qkSXhlDocH4mqRk+s6L89ylqqB4AtgDe/6Ea/Iu+
         K0SIJjNBxmDG+mzG5fDrgf4vQMRzF/IfAw18zKkeF/1Cqkqi+9O7qD8/y/Uo0MuRCTuJ
         ayDQ==
X-Gm-Message-State: AOAM533DTEf1Krdb/Hd7sEXKH25+qhM6vY61JapFMIjALwGaXnwN5QlF
        iTD4tcY3b2UD94Bgf67iiWMpUdO++ob0eLXikyU=
X-Google-Smtp-Source: ABdhPJxJX28jWVwzBvluagMqiYMtslSSsT8A0DngX7A1NbK5NTbJuHfo8LNnSF9Uc2CfYIjignq5w7WOyZ0c7YPtcAo=
X-Received: by 2002:a1f:a84c:: with SMTP id r73mr9191276vke.6.1642488013905;
 Mon, 17 Jan 2022 22:40:13 -0800 (PST)
MIME-Version: 1.0
References: <20220107054531.619487-1-hyc.lee@gmail.com> <20220107054531.619487-2-hyc.lee@gmail.com>
 <CAKYAXd9qYgpf9oGhK5bdE2M6nbfpeTEAOg+zDGGXomOLaNmR9Q@mail.gmail.com>
 <CAH2r5mtTs5bxF9+_M0-3a7YkZB4zqBCm4_kL_QpHAPhEVAG-WA@mail.gmail.com>
 <CAKYAXd9ndasXA3q2F05f9JMXHPT6cQRf0M8owP-dwdv_LWggwQ@mail.gmail.com>
 <CANFS6baREfEidN+FqZROiF+6QtOQ6FXae6f0L9EVKaUFK2L3hg@mail.gmail.com> <CAKYAXd8uQ4MG=y8_GqhAwPX0CVfk9EoEu=WZuO7+UCCYJ2RBDw@mail.gmail.com>
In-Reply-To: <CAKYAXd8uQ4MG=y8_GqhAwPX0CVfk9EoEu=WZuO7+UCCYJ2RBDw@mail.gmail.com>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Tue, 18 Jan 2022 15:40:03 +0900
Message-ID: <CANFS6bZMH00MzjFrBVNFrtDvwGRkXtiZM6TOCUDk+mGouRk4Dw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: smbd: change the default maximum read/write,
 receive size
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022=EB=85=84 1=EC=9B=94 18=EC=9D=BC (=ED=99=94) =EC=98=A4=EC=A0=84 8:33, N=
amjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> 2022-01-10 10:37 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> > 2022=EB=85=84 1=EC=9B=94 9=EC=9D=BC (=EC=9D=BC) =EC=98=A4=ED=9B=84 9:56=
, Namjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
> >>
> >> 2022-01-09 15:44 GMT+09:00, Steve French <smfrench@gmail.com>:
> >> > Do you have more detail on what the negotiated readsize/writesize
> >> > would be for Windows clients with this size? for Linux clients?
> >> Hyunchul, Please answer.
> >>
> >
> > For a Linux client, if connected using smb-direct,
> > the size will be 1048512. But connected with multichannel,
> > the size will be 4MB instead of 1048512. And this causes
> > problems because the read/write size is bigger than 1048512.
> > It looks like a bug. I have to limit the ksmbd's SMB2 maximum
> > read/write size for a test.
> >
> > For Windows clients, the actual read/write size is less than
> > 1048512.
> In the case of my Chelsio device, Need to set it to about
> 512K(512*1024 - 64) for it to work.
> The 1048512 value seems insufficient to cover all devices. Is there
> any other way to set the minimum read/write value? Calibrate this
> minimum value by looking at
> the device information? For example variables in ib_dev->attrs.
>

Let me check it. But I think multiple buffer descriptors caused
this problem. because of a client's device limitation, a client
seems to send a read/write request with multiple buffer descriptors
for sending 1048512 bytes.

To check this assumption, can you tell me the buffer descriptors'
content when the default read/write size is 1048512?

> >
> >> >
> >> > It looked like it would still be 4MB at first glance (although in
> >> > theory some Windows could do 8MB) ... I may have missed something
> >> I understood that multiple-buffer descriptor support was required to
> >> set a read/write size of 1MB or more. As I know, Hyunchul is currently
> >> working on it.
> >> It seems to be set to the smaller of max read/write size in smb-direct
> >> negotiate and max read/write size in smb2 negotiate.
> >>
> >> Hyunchul, I have one question more, How did you get 1048512 setting va=
lue
> >> ?
> >> >
> >
> > I remember when the size was 1MB, Windows clients requested read/write =
with
> > 1048512 and 64.
> >
> >> > On Sat, Jan 8, 2022 at 8:43 PM Namjae Jeon <linkinjeon@kernel.org>
> >> > wrote:
> >> >>
> >> >> 2022-01-07 14:45 GMT+09:00, Hyunchul Lee <hyc.lee@gmail.com>:
> >> >> > Due to restriction that cannot handle multiple
> >> >> > buffer descriptor structures, decrease the maximum
> >> >> > read/write size for Windows clients.
> >> >> >
> >> >> > And set the maximum fragmented receive size
> >> >> > in consideration of the receive queue size.
> >> >> >
> >> >> > Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> >> >> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
> >> >
> >> >
> >> >
> >> > --
> >> > Thanks,
> >> >
> >> > Steve
> >> >
> >
> >
> >
> > --
> > Thanks,
> > Hyunchul
> >



--=20
Thanks,
Hyunchul
