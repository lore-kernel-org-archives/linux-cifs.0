Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D52BFC433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jan 2021 07:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 979682073C
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jan 2021 07:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbhA0HaH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Jan 2021 02:30:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S317646AbhA0AaI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 26 Jan 2021 19:30:08 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C56C061573
        for <linux-cifs@vger.kernel.org>; Tue, 26 Jan 2021 15:17:51 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id f1so64404edr.12
        for <linux-cifs@vger.kernel.org>; Tue, 26 Jan 2021 15:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HMKDp9LAgkueuM1/9yGSm7Oksa/vLtKF4FHbvnepNbc=;
        b=qC4TIWCHP3wy+B3LnVwVA9XyxqxodpNeu6JzSg5QVcAEQCPknRNyCCY2yBc+sP67YG
         R4HNNjhbeeGE1ec2aL4CmrVj8INPPCGWzzr/LOuiwzIFY3ouOTW1+ILX8HknA0Dpss+G
         f64xN4QkM6hOn6XNXKIshPAl8Paf+Nb4LpZSVm//99OkFaOYbb0Vf+LhP/vtn3M3U58e
         M4dolF5rvuJ2TCKM766Yca2wpaNCqFbuDMunGuLD+5EMgp29VWHP1wXt2qH34VjJOUu4
         Q2XSuahrX2teCj8PfP4r/il4mQ2s9m4QRhBtJ6wbOdgziQhIblIRal4vZvyv6zKNizOr
         l6tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HMKDp9LAgkueuM1/9yGSm7Oksa/vLtKF4FHbvnepNbc=;
        b=kyNTatcxWREXGeTdMDlll86ayFhUV87w6O7b+QGMlVf69ukeKX9cQN4iX9+QAucrsS
         DpMrFcEcUpBQvlkKSgJbfOV4YxhwzMiw6kT6X/2GJfybcMCsKntSHN4j8xFFX1jlshk6
         zCSJRf08YManpzUftbQk8jOOwlC7UDZCnFiEw49qyLGIKjovthxxp63+OnpFPPCMYGMZ
         ABMWVVHedStM4zXNNMvcpj78De2b/TCcg0RvG0f0FPwdjgqbO8IR51wFN1pIjbhQPD8J
         K7BLp9ymU4H+kQcFsDG7Q3/DEmqOpBF8rewmleTm4RRVP6nr/9cLeVJFpr/enA1NXG5N
         CltQ==
X-Gm-Message-State: AOAM531P1P7JHDjqBvkxcv4Qca92U10S12XEV7OXF6YrWPe+NizdXoi2
        MjEODI7ag5g5zpJ8fl2vtXao9+rYxuxvIBh6ug==
X-Google-Smtp-Source: ABdhPJyrU27X27s0JMHclBYS8qrq+57RitAZnuo/CxA4JQGLqE4LBd4z3gbUu2yY/M9dNXrSp3X3buETV7B0GU3sxx0=
X-Received: by 2002:a50:fd84:: with SMTP id o4mr6381864edt.340.1611703070360;
 Tue, 26 Jan 2021 15:17:50 -0800 (PST)
MIME-Version: 1.0
References: <20210120043209.27786-1-lsahlber@redhat.com> <CAH2r5mvmCG2SN0nO8uZftTRMOkN8jgbfYrO1E5_A=5FpK9H0bQ@mail.gmail.com>
 <CAKywueRWJxk9KuuZe6Ovb7MhxXsbsE-_7WJG05hAPTZ2o5m7mg@mail.gmail.com>
 <87y2gmk3ap.fsf@suse.com> <877do6zdqp.fsf@cjr.nz> <CAN05THQjj04sQpcjvLqs+fmbdeu=jftM+GdeJnQMg33OEq6xEg@mail.gmail.com>
 <CAKywueSTX9hq5Vun3V6foQeLJ8Fngye0__U-gj73evKDwNLEKg@mail.gmail.com>
 <CAN05THQGBvLy6c+DK1eOuj2VKXTXONZkk8Je+iLM2DZFmHsPBA@mail.gmail.com>
 <CAH2r5mttuSULg0UvKuNRydtkNAP1QRZVXQuNaaHGFLRrvfSnfQ@mail.gmail.com> <CANT5p=o5pjCLUzLv2=i+T+7XE=0Wxcg3p_TSbAeARAWNzmmgEw@mail.gmail.com>
In-Reply-To: <CANT5p=o5pjCLUzLv2=i+T+7XE=0Wxcg3p_TSbAeARAWNzmmgEw@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 26 Jan 2021 15:17:39 -0800
Message-ID: <CAKywueQiB__NmPqv0Q7OmGLqLRLShoQmoxELyFdBEANJz3GY1Q@mail.gmail.com>
Subject: Re: [PATCH] cifs: do not fail __smb_send_rqst if non-fatal signals
 are pending
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 25 =D1=8F=D0=BD=D0=B2. 2021 =D0=B3. =D0=B2 08:39, Shyam Prasa=
d N <nspmangalore@gmail.com>:
>
> Hi Pavel,
>
> Sorry for the late review on this. A few minor comments on __smb_send_rqs=
t():
>
>     if ((total_len > 0) && (total_len !=3D send_length)) { <<<< what's
> special about total_len =3D=3D 0? I'm guessing send_length will also be 0
> in such a case.


Should be. I don't think there should be a case of sending zero-length SMBs=
.


>         cifs_dbg(FYI, "partial send (wanted=3D%u sent=3D%zu): terminating
> session\n",
>              send_length, total_len);
>         /*
>          * If we have only sent part of an SMB then the next SMB could
>          * be taken as the remainder of this one. We need to kill the
>          * socket so the server throws away the partial SMB
>          */
>         server->tcpStatus =3D CifsNeedReconnect;
>         trace_smb3_partial_send_reconnect(server->CurrentMid,
>                           server->hostname);
>     }
>
> I'm not an expert on kernel socket programming, but if total_len !=3D
> sent_length, shouldn't we iterate retrying till they become equal (or
> abort if there's no progress)?

Given that this is a blocking send, total_len !=3D send_length may
happen for several reasons: tcp buffers are full and signal is pending
or a connection is reset or closed.

> I see that we cork the connection before send, and I guess it's
> unlikely why only a partial write will occur (Since these are just
> in-memory writes).

For the reasons mentioned above partial send may occur any time.

> But what is the reason for reconnecting on partial writes?

partially sent SMBs would mean corrupted packets on the server and the
server will close the connection anyway.

>
> smbd_done:
>     if (rc < 0 && rc !=3D -EINTR)   <<<<< Not very critical, but
> shouldn't we also check for rc !=3D -ERESTARTSYS?

It doesn't seem like ERESTARTSYS may occur above but not 100% sure
here - needs investigations.


>         cifs_server_dbg(VFS, "Error %d sending data on socket to server\n=
",
>              rc);
>     else if (rc > 0)
>         rc =3D 0;
>
>     return rc;
> }
>
> Regards,
> Shyam



--
Best regards,
Pavel Shilovsky
