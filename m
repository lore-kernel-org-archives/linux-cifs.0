Return-Path: <SRS0=S2FA=RS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BE5BC43381
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Mar 2019 00:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E86C21872
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Mar 2019 00:42:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="abJ3vivQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbfCOAmY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Mar 2019 20:42:24 -0400
Received: from mail-qt1-f173.google.com ([209.85.160.173]:43787 "EHLO
        mail-qt1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727254AbfCOAmY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Mar 2019 20:42:24 -0400
Received: by mail-qt1-f173.google.com with SMTP id v32so8298506qtc.10
        for <linux-cifs@vger.kernel.org>; Thu, 14 Mar 2019 17:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vEbj3vMSN8kom/6K+tes01YphMY3mE5kZIGVvuzSyh8=;
        b=abJ3vivQmqxorEnW8HoQmEctcg/RLM/GyM9A14eAInBFQJtX2Rm4phGULmOJo/aPYN
         T8Se060/PwxdFMJqsYKqSibH6AUWerMCNi3/NHNptFW4bQlwWSuoBNOpYS7r0RTwIRQ+
         yHCaSQJb89zBWi9VA/e6sgrFvnymNDrap1JoC9OIpO/yArrx4hxmFHZabZI0SEoQlwrn
         tXbjhPVPXJfEKCr1s5QvXBnAQtFE36UF/9OIu0Djl5zuAtkJAy2rkqQsBOcGyZebt4ay
         kVXxgaPF4aPFgQ8CdUu181B3nbnBrPTLplDTkX1N43CTP+xxjQvhXVhsWIJ/d/8Ea9ym
         ISoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vEbj3vMSN8kom/6K+tes01YphMY3mE5kZIGVvuzSyh8=;
        b=IvI+EBgmoShxeAd0hBcQDeaFRwRJhWFMEktlIbXFKV7QE6JFh0JGdkD4QI3ffNr/VN
         k8TU5gEWoQDGFwslOulViJqu5acNJEIdTGn/hACU+2rtstpaPJMR03kRTnwgyp3gr14N
         FprjnINTCwM0BwezrFrMRyoRc/4qimQPzxAtPYOZoRa15lUwXrhI601iUAJXbxI9i9bR
         k4e/4G8fTHiLqt2Jb9ud6CA9PLzuublDoxTp1Bms4ylc7oDFiD0tu6LQwkHEBWiE80zt
         fJiDbXJck7vgig4q8JXNwIomy5VaWuCmvjKYoPzNh5fIOiCGMXlHcQffaw2AKpVW5zsO
         wN0Q==
X-Gm-Message-State: APjAAAV6aWmwDpBm+4gaoDgTHFzPgEgYYV6sk01tMgHaoZ/6vhDSN3hU
        KVc6dKyu97PzQ8gpIaKgFzk4jJzgiCJpPko3g3o=
X-Google-Smtp-Source: APXvYqy0jwY4ftDld50yFnLPpRgv7kG7TlqaX5oN8j7BOM2cH/CAsYlJFUuLdSoHRGUcVcUR8JQJRTK+wNbVlQsF0Mo=
X-Received: by 2002:ac8:7642:: with SMTP id i2mr684558qtr.287.1552610543696;
 Thu, 14 Mar 2019 17:42:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5ms=Mb8Ogx2+5jdzXOkTwfexKB0Xn=ukb6LroBbq2F+Q=Q@mail.gmail.com>
In-Reply-To: <CAH2r5ms=Mb8Ogx2+5jdzXOkTwfexKB0Xn=ukb6LroBbq2F+Q=Q@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 15 Mar 2019 10:42:12 +1000
Message-ID: <CAN05THRPnkQd2ANuQtHJYVY7ViuTk8y4jo0kbM37gv-Wj9pn6Q@mail.gmail.com>
Subject: Re: [SMB3] [PATCH] Pass through FSCTL for tools like smbinfo
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Note that we pass NULL as indata for SMB2_ioctl_init() so for the time
being we can only use this for those ioctl/fcntl that does not
write data to the server. But there are very many of those.

We can start populating smb2info.c with handlers for this and once it
all looks good we can add support to also write to the server (which
will be easy to do but it would make the patch bigger)

On Fri, Mar 15, 2019 at 10:21 AM Steve French <smfrench@gmail.com> wrote:
>
> Forwarding Ronnie's patch to the broader list
>
> For debugging purposes we often have to be able to query
> additional information only available via SMB3 FSCTL
> from the server from user space tools (e.g. like
> cifs-utils's smbinfo).  See MS-FSCC and MS-SMB2 protocol
> specifications for more details.
>
> --
> Thanks,
>
> Steve
