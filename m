Return-Path: <SRS0=cCOQ=RU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A309C43381
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Mar 2019 08:56:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC45621019
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Mar 2019 08:56:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UJ57Krv9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbfCQI41 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 17 Mar 2019 04:56:27 -0400
Received: from mail-qt1-f173.google.com ([209.85.160.173]:33439 "EHLO
        mail-qt1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfCQI41 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 17 Mar 2019 04:56:27 -0400
Received: by mail-qt1-f173.google.com with SMTP id k14so9039331qtb.0;
        Sun, 17 Mar 2019 01:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wWopYmyEkT0X2L6ez9CfhtStoXM9VUn8VAdYl/EYq5o=;
        b=UJ57Krv9p3gmc7LEKNFuhGzTSPO+oGi1IAWuvBWCP+diuBNp7tRU7CkkeMbtlrrQ84
         hx1UG/cE43q+/6XEq1RHSqlOE7/lesv0kByZA6+rm2ihrsGF1NQd4vCtTAGu2qazGM54
         kALs0I85t09ak0NJxLYwF0n3bgJIl3OUicpFiBK7Mfk+Ay1OtRvh+72YXtseNsVpfXSY
         Xl4TSY8WyLeA1iTHeTsgNhALfvXYLbupNdUo2NdpvO4Qk6/g6/r+WquLo2RFtxm04TtC
         1Pa1Zs8FCbJhRYIbWjSSE4QDdPMM3VsEO2DcIGFyDgQ26O3JdygnyekjKdY5xUaqql90
         m+fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wWopYmyEkT0X2L6ez9CfhtStoXM9VUn8VAdYl/EYq5o=;
        b=Dan8wbrgrfQa9MlN63gw/uYBJxqcHD6RSPMw4MsuydTCOW6yBCwkaPKmZ2VlkQ1Pof
         9K2Qo2lTtx90omzmixESvBMJer6A6bqpSxBxSb+YRsIqlXXvLvlXNuNUn6omhPtZwPvp
         +i48po6fDeNMZP8nHiXo1CLsTzReoZUJcvqdByvvPfQO9ajONevC1vS6DVEEbt0hI6Bp
         gVFek73OX7FlafkZG3IZ1712fB3bP9bGa7mOZYfBvvcfwHu30/9DX70cuRdKOwDctW5J
         c3bGLeJDTj6QvwwqF1uWkRJrKTj+pbxWzVX9eTuJSiDlB2ZAXNVgLlUpDCQE5tpPY7V/
         CEow==
X-Gm-Message-State: APjAAAXlju7CAqJmb9r1uHgyo0UQ1uLbpHdA36fEL6U9xonaL+7RySXV
        Bxa/bG/suQbDYzHTL2Bsf5run24RA8c+zgXvUzM=
X-Google-Smtp-Source: APXvYqwZQ1iYcvy2ji8q+XkxAkh9dyvF61T2Ry6N76u4n4DMoQ+Cl0EVCG+YqBuUbY0cS/GKzQs6AhyR64i7xyr9Evk=
X-Received: by 2002:a0c:d0db:: with SMTP id b27mr8933663qvh.223.1552812985961;
 Sun, 17 Mar 2019 01:56:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv0e3aZ1upukVL5ZJt8AtqjVQbpw=KuHH1DjYydKoyAaQ@mail.gmail.com>
In-Reply-To: <CAH2r5mv0e3aZ1upukVL5ZJt8AtqjVQbpw=KuHH1DjYydKoyAaQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Sun, 17 Mar 2019 18:56:14 +1000
Message-ID: <CAN05THQTim0tqoje3A7ar3cBSkGkX-p8AM7EbjR2+tCAwk9-mw@mail.gmail.com>
Subject: Re: Suggestions for POSIX error code mapping for OBJECTID_NOT_FOUND
To:     Steve French <smfrench@gmail.com>
Cc:     samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ENOENT / ENOTSUPP / EINVAL?

ENOENT feels appropriate since this is not a permanent condition.
Someone could create the object buffer after which it will exist and
there will no longer be an errror when asking for it.

I guess for a long time smbinfo.c will be the only consumer for this
on the non-windows side  so whatever we decide will be what will be
how things are and others will follow.

On Sun, Mar 17, 2019 at 6:40 PM Steve French <smfrench@gmail.com> wrote:
>
> Any thoughts as to the best POSIX error code to map status code
> "0xC00002F0 STATUS_OBJECTID_NOT_FOUND" to?
>
> It means an object ID was not found for the file, which is a
> reasonably common situation over the network even to Windows servers.
>
> I was mapping it to EIO for cases where tools asks for the object id
> of the file (or volume).
>
> --
> Thanks,
>
> Steve
