Return-Path: <SRS0=COnU=XH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83199C4CEC5
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Sep 2019 15:07:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52093206CD
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Sep 2019 15:07:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gyRuqScm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732812AbfILPHC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Sep 2019 11:07:02 -0400
Received: from mail-lj1-f171.google.com ([209.85.208.171]:46294 "EHLO
        mail-lj1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732708AbfILPHB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Sep 2019 11:07:01 -0400
Received: by mail-lj1-f171.google.com with SMTP id e17so23915140ljf.13
        for <linux-cifs@vger.kernel.org>; Thu, 12 Sep 2019 08:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WwhaOpQykUwdFhRACbuzdePefFIFgv6XtO7J9ETelbY=;
        b=gyRuqScmPQLegU6GqHdXGHqKEKHzgMw/blfPaLVxadWh6/J31nLJGHOeWkzOcCUBz8
         5XGrC6rwkiHlbAuTE17oDD63EdqLkfPAqm+PRTkRuLBVZqemxrVqHTdyTCsUv9vh3kWc
         15yfAbZJBbonSN2uzSe1rLGeD4S/BQ9SLa8OVl2IcQ0taVbFx3HPNjrdRR0xKBcALCLO
         Yte/XR2j+bOew6FZKp/nCqpk45Z3sVfl6pf/gLDYkYfQXg9ePkqGcLTtXNwmYzDkP9xm
         T3piBdwJAiTm0TTg4dJwY00aS83AaG8OyuTbNmCY5wUCUqxHndYWmO6ncGG6Rop1F2IP
         Wf3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WwhaOpQykUwdFhRACbuzdePefFIFgv6XtO7J9ETelbY=;
        b=bLsUC8hr9VPNMkSFHvZX0UKH+1gsLbQDxusLxWHad9vrOgLKS/al8EuOqMzTsydAOq
         AB7ieRjKxyC/UCYQHfsHPAJZ1jN19Ik5F8+DvUQeCzo+NImPR2B2yCvZsF6uAKsOLnK0
         ZU92km11E+T2phxjlxc+NE0ST2hTe6QIfTkCW3B8j8e3kNQIwBgtZtHBNWSAphRaD70I
         SkqThkSNwr9ByDMo80GyZhWuX9oiaacjU3BxAdGuxLc2t82tZZlWo8UIkC0oly/xNc/m
         AW4IjYHkm2MXOr75Q37bxm9scTjvNlQd+1va2TqNJo51n9rbMepB8HgFqfHsBtxO3HlH
         Fhpw==
X-Gm-Message-State: APjAAAVGaip2kjUOhfQGYjYlgBNS7mn7EiQkA+KIMSHpnCin9eroW0BE
        rEm+ncu8DaWRTNQ+m2gGHhhZiamtsj6tc9Mavg==
X-Google-Smtp-Source: APXvYqyA42WdtF2BnnF2t7hWe67qYv1ug/+x+8UdSHaen/gL8038yJEgFZgMIXXcJfSmySxsrrhXpMY/S3aSIpw0pCA=
X-Received: by 2002:a2e:8744:: with SMTP id q4mr26507175ljj.77.1568300819907;
 Thu, 12 Sep 2019 08:06:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtc2A-s1is6eZXZx5neDWZs_4aSW_Tx72PH8sBA4pmqhg@mail.gmail.com>
 <CAN05THSKORVny25_fR6wgK1noJ_DoLHHucpwVhvDD_zNJeHL0A@mail.gmail.com> <CAH2r5msD1zHubHyMjLoz=-kJUPqM=npBfMEv+bJwJh1sYWHO1Q@mail.gmail.com>
In-Reply-To: <CAH2r5msD1zHubHyMjLoz=-kJUPqM=npBfMEv+bJwJh1sYWHO1Q@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 12 Sep 2019 08:06:44 -0700
Message-ID: <CAKywueQ3qxbo5bF06kbziVtUFYf1C2MnQPC2fugkKoC_fbZ9dw@mail.gmail.com>
Subject: Re: [PATCH][SMB3] allow disabling requesting of leases
To:     Steve French <smfrench@gmail.com>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good. Stable candidate?
--
Best regards,
Pavel Shilovsky

=D1=87=D1=82, 12 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 00:59, Steve=
 French <smfrench@gmail.com>:
>
> Agreed
>
> On Thu, Sep 12, 2019, 00:22 ronnie sahlberg <ronniesahlberg@gmail.com> wr=
ote:
>>
>> Reviewed by me.
>>
>> We need a big patch to the manpage after all these new mount options
>>
>> On Thu, Sep 12, 2019 at 5:03 PM Steve French <smfrench@gmail.com> wrote:
>> >
>> > smb3: allow disabling requesting leases
>> >
>> > In some cases to work around server bugs or performance
>> > problems it can be helpful to be able to disable requesting
>> > SMB2.1/SMB3 leases on a particular mount (not to all servers
>> > and all shares we are mounted to). Add new mount parm
>> > "nolease" which turns off requesting leases on directory
>> > or file opens.  Currently the only way to disable leases is
>> > globally through a module load parameter. This approach is more
>> > granular (and easier for some) as Pavel had noted in a recent suggesti=
on.
>> >
>> > --
>> > Thanks,
>> >
>> > Steve
