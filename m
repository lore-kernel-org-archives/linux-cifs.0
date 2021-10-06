Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84E16C433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Oct 2021 08:43:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 542B761152
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Oct 2021 08:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237801AbhJFIpl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 6 Oct 2021 04:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237740AbhJFIpk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 6 Oct 2021 04:45:40 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B56EC061749
        for <linux-cifs@vger.kernel.org>; Wed,  6 Oct 2021 01:43:49 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id e7so1205924ual.11
        for <linux-cifs@vger.kernel.org>; Wed, 06 Oct 2021 01:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9lkKasew1pT7L4GqA/g9RRp7Gm3bsXJrnHqmoK7TBCo=;
        b=gExv2G0eXGSNyDvm1qnklbbNGnx0w4QlD03opNrxLJc8PIcUe/nNBO+K7e7GfSTu7K
         80TFVIP4AURJ3DUJTlqN9U8EsfeUJfVx+QdiJwJBt/mZ0Ld8DD0TrVX7cJH8AM7cj3YN
         LFl3+RJApHGeztf8MTWmCnjgQ038JI5VYqc8MNWXo4gcFXwuOvkU6h2Kj+tHaBqs3erz
         6TVa8k0/b+e7F9J/6WinqHrGHR6irBr4td9KFi8HPxVSfVUfYzE+tg53dWkOeiXq58lT
         Ql1eh5YdY4X0kLJEZy9TWYDwJaE/eYs2e2Bl3OgIqDzksQNYH8/coLa1889UXfvv83Qb
         VSSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9lkKasew1pT7L4GqA/g9RRp7Gm3bsXJrnHqmoK7TBCo=;
        b=S8/UwYeWXB/cKrHgEYajOaVlleh8O60Jet3gcFIsjrt8cX8oMExztXm75VysqHd0fg
         AbPA2i+mWtcbUYfWz09PVruNvcbRThO4XxBzMde/aYDrnlJaXDTyM8mOK9B7SpMNRGvz
         CxrfXEhYllpEDuF/ITkV6QvRkQRLymCW24XHZIsZO4uyXtMfLzgeC0i4/3Ssjz20eorR
         SE4JwUz5VtqJZMLuWGaDcWv5OXIumcIhdWmGpaC9EvRnPjYGK9sMN4h9tSMQxTN3oCF5
         sVMGfZ5ZCJ/p1b6SPRNhMXOX6ohKoz9Do6x0elpFOjTjtDec1NIF21QY9dcAcGM7EVjq
         GRjQ==
X-Gm-Message-State: AOAM532DSNXylWttvJ1BZKAUcGKzChttKgAUaYSRybSJsSfuq9E5wk32
        CJJYHlyQIPVt5cCnTlm5wbOvrXhykasNECoOzGg=
X-Google-Smtp-Source: ABdhPJz3P2pfzxIKgadzp5W+37u37mK8JpUbYc12xWaJUOPPyluAMgeeE4MUK04heLk3ahhMleG5s7RAw/lUtm4uLxE=
X-Received: by 2002:ab0:6dd0:: with SMTP id r16mr3986761uaf.82.1633509828408;
 Wed, 06 Oct 2021 01:43:48 -0700 (PDT)
MIME-Version: 1.0
References: <20211005100026.250280-1-hyc.lee@gmail.com> <de0ecb81-0313-266e-cc5b-94ec40201141@samba.org>
In-Reply-To: <de0ecb81-0313-266e-cc5b-94ec40201141@samba.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Wed, 6 Oct 2021 17:43:37 +0900
Message-ID: <CANFS6basCNTcN7Myz0bAd_LTXEji43HiqLE0B8McpaemUjSp8Q@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: improve credits management
To:     Ralph Boehme <slow@samba.org>, Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021=EB=85=84 10=EC=9B=94 6=EC=9D=BC (=EC=88=98) =EC=98=A4=ED=9B=84 4:15, R=
alph Boehme <slow@samba.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Am 05.10.21 um 12:00 schrieb Hyunchul Lee:
> > * For an asynchronous operation, grant credits
> > for an interim response and 0 credit for the
> > final response.
>
> fwiw, Samba also does this but this can cause significant problems as it
> means the server looses control over the receive window size. We've seen
> aggressive client go nuts about this overwhelming the server with IO
> requests leading to disconnects (iirc). So this may need careful
> checking how Windows implements this server side.
>

Okay, I will drop this in the patch. And could you elaborate
on the situation that clients cause the problem?

Namjae, What do you think about Ralph's comment?

Thank you for your comments!

> Cheers!
> -slow
>
> --
> Ralph Boehme, Samba Team                 https://samba.org/
> SerNet Samba Team Lead      https://sernet.de/en/team-samba



--=20
Thanks,
Hyunchul
