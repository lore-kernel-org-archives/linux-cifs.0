Return-Path: <SRS0=mIXx=TJ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F91C04AB1
	for <linux-cifs@archiver.kernel.org>; Thu,  9 May 2019 17:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9DFD2173C
	for <linux-cifs@archiver.kernel.org>; Thu,  9 May 2019 17:12:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="erGoDUXW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfEIRMQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 May 2019 13:12:16 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:33326 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfEIRMP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 May 2019 13:12:15 -0400
Received: by mail-pl1-f179.google.com with SMTP id y3so1460074plp.0
        for <linux-cifs@vger.kernel.org>; Thu, 09 May 2019 10:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ytusQMcByJQahZzRREU2eM9mbbuNf9MdQH93t94FTEE=;
        b=erGoDUXWH3qWz3wEprB3TSYig1izjHg4Kqial9nZG7Qz2Q8Lx3iSzmcV7iOh//fPw7
         y/TPiuEwTNqmifvHyOxbXqz4D9nGpcZbs8qm1/jedNQCRtj9Z6tu2MuFuD7lPrh7lPAS
         7Ok1C7gZhii9YIo37neL+/8f5CeNJ5nQThW7mIk8gI6C22KEVWEVYwGrfsMaY78o8aS6
         7LbJp4raI7DDgzSfA1L+deAAQlIG8GElqkhpwchca8L+LKCwkOGKQdWMXVATlHpQDHu6
         GkhLa/hkQdOkIJE/ElAdxRNtzZUq/SFF7oLgodBDuNVNUIj5mXwD59Z6DzhuVqavqJ0T
         UcIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ytusQMcByJQahZzRREU2eM9mbbuNf9MdQH93t94FTEE=;
        b=PmWrjcrKa3CEz5MHDqEUBkbxgAD8341ZxJygvtQnmcdPRPAyv5NitpyyyS47Ywkt8H
         qI+Pr1hf9n8IJynL3EF0L9bpnVyan6OkD3XXOYpGARziVFlT7u9T81Wcp/r+3r7c2ov3
         Ujnf6NV4eNZZn2fNj+z6LJL4YBZU8UquMpgi4CCvWucQri8Qj7GjaEC9VcMJpJ1QWCPe
         Jdi8yX6BDW/ewshZm5raOWwyrh5K6yKwmO1Dxsn6XpbDVjHZEd3asnaWiJ9Ee4cLNsWo
         8IYk87RsqHQPcA0P0jIppe6DZHvpf2vcoEiYCQbft/ug6LxB8Rzdk3IK5S1S3qr5ChCI
         5U+Q==
X-Gm-Message-State: APjAAAVasdeVlT4H8L1Fs+NaRTflsmsdbJrpqYJ2ZV+2kQqa9XaIM4FB
        obn8EvbvdMOg0FIxEcL+r/+SpSr3U88IB9RMcrSTpA==
X-Google-Smtp-Source: APXvYqy6MulJcaDTOmbNrJ9eycoBZ1itIE+yp5AEayqUEYNvQbslvAGHcmsYBiZ27aHvo8UFEYSa4NDshQf1khPpYTs=
X-Received: by 2002:a17:902:e00a:: with SMTP id ca10mr6894296plb.18.1557421935143;
 Thu, 09 May 2019 10:12:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtP-mPWTO0gCHraUg6m=V5WNH0u1dOnd=k4114Z8AVE6w@mail.gmail.com>
 <CAKywueTkEw0n_n5naYDtyG_U_ie+xAX_MWWhgC3VgpLEvnLnpg@mail.gmail.com>
In-Reply-To: <CAKywueTkEw0n_n5naYDtyG_U_ie+xAX_MWWhgC3VgpLEvnLnpg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 9 May 2019 12:12:04 -0500
Message-ID: <CAH2r5mtCgDJtpW-fOP6QOC2MYsDmi7-6DyqyG5F93OTSjyxKpw@mail.gmail.com>
Subject: Re: [SMB3][PATCH] Display session id in /proc/fs/cifs/DebugData
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, May 9, 2019 at 12:07 PM Pavel Shilovsky <piastryyy@gmail.com> wrote=
:
>
> =D1=81=D1=80, 8 =D0=BC=D0=B0=D1=8F 2019 =D0=B3. =D0=B2 21:37, Steve Frenc=
h <smfrench@gmail.com>:
> >
> > Pavel noticed that we don't display the session id in
> > /proc/fs/cifs/DebugData yet it is important.  Patch to add this
> > attached
>
> Could you make it hex to align with other IDs we are printing in
> DebugData or open_files?

Sure - that is easy

--=20
Thanks,

Steve
