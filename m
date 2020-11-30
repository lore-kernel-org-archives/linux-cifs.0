Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63726C64E7B
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Nov 2020 16:25:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0778D2073C
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Nov 2020 16:25:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H/9yKzWH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgK3QZ1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Nov 2020 11:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbgK3QZ1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Nov 2020 11:25:27 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01C0C0613D2
        for <linux-cifs@vger.kernel.org>; Mon, 30 Nov 2020 08:24:46 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id r24so22724690lfm.8
        for <linux-cifs@vger.kernel.org>; Mon, 30 Nov 2020 08:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pGf0a41nZDs3Z3hfGOJZaG54afuEs6GnX3JhkKC9Ctg=;
        b=H/9yKzWHr1TnYbWe4NdTL8Kjni5eS1kYW8Sq2W7ONftgtDSuBgQMyJri4z1fjFWOKf
         II1ojJljvxO4ubXssHSldewDxXuXxP0kz8bdcojAcdn2OAaQPZ19Tcf8Abf8uXDyz9hR
         KhBbQhcz4Obs3iG2cNU7jrKqpTaSvkNCjhjMi9BeYuuwkVoAWbnW8nU5idZvRmpwK31B
         m5vNpkNO9dVZHHdN+YLW4dxMChXcnLnEthMReWDPUTMg8pTzXC7j3QDFYv/y29RE4PI+
         A7dMUfCygz3+HjaVw0p1iVVhkEHAp4ToIacAm36TqFGsuBxMDgzgwtMyBgXuSFBalUeW
         0upA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pGf0a41nZDs3Z3hfGOJZaG54afuEs6GnX3JhkKC9Ctg=;
        b=jyfo30y8IL/z9AIee8m34bYFdMeXYiULH3RNwn3Hd16QKeS9FYjWsmn6p+2X0RMGG/
         R3HqsJie7GKv2+5G012N4Xlr6TcKPvwIwtLQnbpEBvS0SFwa1PSoKhUVaKW4vUr0gkbz
         rRw+2mlchxpCw26A2sTpJVf1rBy6mDpCDtcgsRS00FwKqK8WXbuvRTS+21+t+3XUnrLQ
         mJ/xq1UlVy+/DbU3L4MTSccwA1ThsNuPZbt2MjXESTyYXrDRrrYjrg6+QHg2nzNjFyvz
         r9leNl1Thzrg5FG8DGfFlXHS7CSjdEHZrxtj4uqNqfUqJb2Ru5+XVsbX632RxOVzHBV6
         8QcA==
X-Gm-Message-State: AOAM531yPNdXsZaV4aq1SO8OQu6igcv/X+4rqE0JZ/jsrmG4PyqP/8JP
        QN4OfU/VxZTEAYrPT0TPPyLaRYwi2kLMg6PXuF3UG/tWt4A=
X-Google-Smtp-Source: ABdhPJzBhKe7JWLV2Tpd/P9n32vpk8+X2EMLHyHZLwwJGiRaYAXMNDDiz/0pVhMGQZqk1HBA9EyezbASLUOiAbq3Adw=
X-Received: by 2002:a19:4941:: with SMTP id l1mr10283414lfj.136.1606753485422;
 Mon, 30 Nov 2020 08:24:45 -0800 (PST)
MIME-Version: 1.0
References: <20201128185706.8968-1-pc@cjr.nz> <87sg8rdtoj.fsf@suse.com> <87pn3vhua0.fsf@cjr.nz>
In-Reply-To: <87pn3vhua0.fsf@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 30 Nov 2020 10:24:34 -0600
Message-ID: <CAH2r5msicAhu-NDzf+JxghVEj8dBRrDnMjGEKkE-DbrW=Dm64A@mail.gmail.com>
Subject: Re: [PATCH] cifs: allow syscalls to be restarted in __smb_send_rqst()
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Nov 30, 2020 at 7:02 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Aur=C3=A9lien Aptel <aaptel@suse.com> writes:
>
> > Paulo Alcantara <pc@cjr.nz> writes:
> >> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> >> index e27e255d40dd..55853b9ed13d 100644
> >> --- a/fs/cifs/transport.c
> >> +++ b/fs/cifs/transport.c
> >> @@ -338,10 +338,8 @@ __smb_send_rqst(struct TCP_Server_Info *server, i=
nt num_rqst,
> >>      if (ssocket =3D=3D NULL)
> >>              return -EAGAIN;
> >>
> >> -    if (signal_pending(current)) {
> >> -            cifs_dbg(FYI, "signal is pending before sending any data\=
n");
> >> -            return -EINTR;
> >> -    }
> >> +    if (signal_pending(current))
> >> +            return -ERESTARTSYS;
> >
> > Can we keep the debug message call?
>
> Yes.
>
> Steve, could you please update for-next with above debug msg?

Done. Please check to see if my lightly modified debug message text is ok.

--=20
Thanks,

Steve
