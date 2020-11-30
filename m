Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E05CC63777
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Nov 2020 20:12:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AE142074A
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Nov 2020 20:12:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U2s0uF9p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727375AbgK3UMv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Nov 2020 15:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbgK3UMv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Nov 2020 15:12:51 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34281C0613D2
        for <linux-cifs@vger.kernel.org>; Mon, 30 Nov 2020 12:12:05 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id qw4so14221792ejb.12
        for <linux-cifs@vger.kernel.org>; Mon, 30 Nov 2020 12:12:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ggE4bVAaHfAbh8XYFXQbErcK6Amu2EDF91c87FMGw8w=;
        b=U2s0uF9pY9+bSX6zdiUuuLAzSq3DiB9pM5SU2dwlxVjr+JSxWj5Sb9dZ1wozH/RH5X
         0VO7Z62ezv3O60WdU7iJB2h51pN1NNar2Kh6ARx98hoO1oY6KuLzd6t0zJIVHQ+ytf4Z
         hhUBJn10nLxWjDhmkT2WBB+rotjowD1Kw9Sl71wcOQ9z2M87lkb+4ywRzWlcqDwSMxVy
         3WzEP9dJkzFwBh97IEPjcaHO5ZsZ+VQ7uuO/y0g8ytngocfb8vTTtpIirVirgRjY6fG3
         DWU9hszzhKwO27oc+qwmqsgXYZWPO7mkApi5bHgKPtcCvmLDsNLZkPOGS/5LSJWnhtFW
         O5Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ggE4bVAaHfAbh8XYFXQbErcK6Amu2EDF91c87FMGw8w=;
        b=msZciAynfMUXTZVWEfWWxjLmtqn8SepE8/mGwoE3YwhNcZzn9Wjuzt08XCIetPsYCN
         wu9H1d4nUbkkj/XCyGmNHMsycpw5i/atO/f7ohYQWwFsbXm3zE15z08Z9yz8131X6sf+
         VWsKTss/UwhlgH1AlIi7qc36eCDDGIzBnoEK+6fp4qLoldRy2jXyrdZsMRi9hloRPuoa
         RVmYT24orRUdMDx2QPU2F/7NkI6eF1dScDbUajc9x+x6uowXN3waDI0eqbK0cDHwLzww
         RMYbOpZ98kkWSraaFnexGRGh2ErXtQbRV9PoH4dJVajMsaPVpbC6Ocv8cY06ZuUEvlnX
         WgQQ==
X-Gm-Message-State: AOAM530gOrMMiqWqaoh8RKZoXpZUkA0jb1k9KHvyIzwsoImW1IGR+o3q
        MAoSWnZKKh3U63jrw6uUCbbNp81nsI6bL+OzSA==
X-Google-Smtp-Source: ABdhPJy4A0NrPE3PPjiG108U7NWdp/E9P83atB5MIwHJUz4/6/xjXSzTzTOgOlkqTi7THeNqQSb690J22HF5O7ymitw=
X-Received: by 2002:a17:906:f753:: with SMTP id jp19mr22661812ejb.280.1606767123853;
 Mon, 30 Nov 2020 12:12:03 -0800 (PST)
MIME-Version: 1.0
References: <20201128185706.8968-1-pc@cjr.nz> <87sg8rdtoj.fsf@suse.com>
 <87pn3vhua0.fsf@cjr.nz> <CAH2r5msicAhu-NDzf+JxghVEj8dBRrDnMjGEKkE-DbrW=Dm64A@mail.gmail.com>
 <87pn3uhkhq.fsf@cjr.nz>
In-Reply-To: <87pn3uhkhq.fsf@cjr.nz>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 30 Nov 2020 12:11:52 -0800
Message-ID: <CAKywueTu_z44CwPnqtZzyB4NwUq_PHypyM+-GTCDmr+Q4TU4dg@mail.gmail.com>
Subject: Re: [PATCH] cifs: allow syscalls to be restarted in __smb_send_rqst()
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Steve French <smfrench@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Agree with the patch. The original change was inspired by the existing
code returning -EINTR potentially after partially sending an SMB
packet. Returning -ERESTARTSYS seems like a right thing to do here.

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky

=D0=BF=D0=BD, 30 =D0=BD=D0=BE=D1=8F=D0=B1. 2020 =D0=B3. =D0=B2 08:35, Paulo=
 Alcantara <pc@cjr.nz>:
>
> Steve French <smfrench@gmail.com> writes:
>
> > On Mon, Nov 30, 2020 at 7:02 AM Paulo Alcantara <pc@cjr.nz> wrote:
> >>
> >> Aur=C3=A9lien Aptel <aaptel@suse.com> writes:
> >>
> >> > Paulo Alcantara <pc@cjr.nz> writes:
> >> >> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> >> >> index e27e255d40dd..55853b9ed13d 100644
> >> >> --- a/fs/cifs/transport.c
> >> >> +++ b/fs/cifs/transport.c
> >> >> @@ -338,10 +338,8 @@ __smb_send_rqst(struct TCP_Server_Info *server=
, int num_rqst,
> >> >>      if (ssocket =3D=3D NULL)
> >> >>              return -EAGAIN;
> >> >>
> >> >> -    if (signal_pending(current)) {
> >> >> -            cifs_dbg(FYI, "signal is pending before sending any da=
ta\n");
> >> >> -            return -EINTR;
> >> >> -    }
> >> >> +    if (signal_pending(current))
> >> >> +            return -ERESTARTSYS;
> >> >
> >> > Can we keep the debug message call?
> >>
> >> Yes.
> >>
> >> Steve, could you please update for-next with above debug msg?
> >
> > Done. Please check to see if my lightly modified debug message text is =
ok.
>
> OK for me.  Thanks!
