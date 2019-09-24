Return-Path: <SRS0=4YGq=XT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECC0EC432C1
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Sep 2019 15:19:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B232B20665
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Sep 2019 15:19:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CJcKb3e1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731501AbfIXPTB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Sep 2019 11:19:01 -0400
Received: from mail-lf1-f44.google.com ([209.85.167.44]:40647 "EHLO
        mail-lf1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730610AbfIXPTB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 24 Sep 2019 11:19:01 -0400
Received: by mail-lf1-f44.google.com with SMTP id d17so1713081lfa.7
        for <linux-cifs@vger.kernel.org>; Tue, 24 Sep 2019 08:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XwtCxduiaizIi6QX2xQuk08roAb1261lgMxAYujwlvk=;
        b=CJcKb3e1eLxmmiyWUgs3KY2VSLm/xP7+ZORZTXMeJtVezPXb72HGW6v83LE9Td4Ova
         j1I3dhCQQFOKpKRzQhtVImFLO3xIgSnIh4wncvLm1Gt4JKqCM5JLmaVPBmLqLgoaZR5F
         O2TnEdvsFtjB6ostsQ5RgGW3alTIOPqSXErZGO4av+R2v2r9B1lL1eroEvu3GMxVTuz4
         nzYZDWmaHUfBFIm3hMUULp558gL/DeucEZYzcRqEmfwSadaIgBGO84pdhDSE5noPQTh/
         2l67MQRt2nO3pprBpf0/pIUeiqlf2HgV4wAo23DskLf8BtKwIpQRAV/CbEVHE2LkuvxG
         PKDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XwtCxduiaizIi6QX2xQuk08roAb1261lgMxAYujwlvk=;
        b=HNvxduvKA2tn/hz6wLmukJUANZYThh71hyIvYA2IiDMhMHEsl01H/6ovQwBPkj6uL7
         Tux2D3BuoTcbbZ30g9XtXHoSHqns40Kv5IFhFURvlaVtk5vSmxI15Mt2cOatauUa+s/q
         xdFPxqifiRte/oDJWSp9Ot+bsCtrVFxOl7H0hHY1Vd5U5FI9Pv07dSNdKJPNHF4kBaen
         7/iyB5585/54KhsHP9Lu932I8A4G9rWy69r23J0jp4IcNSpMFPiDNaoLXxUubPQUee6K
         tup+SQwvDdN5e5PQZKRHRSX5iDHECztHPkBV8D36CwVzQpMSvtKacEXZO9JueH1UCIVE
         YYLQ==
X-Gm-Message-State: APjAAAUXYF0o3+wn6JwgEJnOayIxAJ6SNn29L9E+HuDUTUcT65ap3lXM
        UYrZYmz1GQCV6oBOA4yaQFah1EOFc9TzRViPdA==
X-Google-Smtp-Source: APXvYqz3xR04ZEaUDGlftEt8ejCiYNfgkT/PNEOcVLaEDDTrk6n2myIo5qvB44+GJgz33di6Vr/r62VRkAP7Z2Bbvqo=
X-Received: by 2002:ac2:4308:: with SMTP id l8mr2226416lfh.25.1569338339168;
 Tue, 24 Sep 2019 08:18:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvfb3nkdz8r8sAUXGJkx678XZkt4dn=4xiuq0UD2vxFrw@mail.gmail.com>
In-Reply-To: <CAH2r5mvfb3nkdz8r8sAUXGJkx678XZkt4dn=4xiuq0UD2vxFrw@mail.gmail.com>
From:   Pavel Shilovsky <pavel.shilovsky@gmail.com>
Date:   Tue, 24 Sep 2019 08:18:47 -0700
Message-ID: <CAKywueQXsnMzS30q2QidWAjvMinCXXWQg0ysUH=62RWLnPW1UQ@mail.gmail.com>
Subject: Re: [PATCH] smbinfo dump encryption keys for using wireshark
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

+ if (keys_info.cipher_type =3D=3D 1)
+ printf("CCM encryption");
+ else if (keys_info.cipher_type =3D=3D 2)
+ printf("GCM encryption");
+ else if (keys_info.cipher_type =3D=3D 0)
+ printf("SMB3.0 CCM encryption");

Do we need to mention SMB3.0 here? It is the same CCM as cipher_type
1, why don't just extend the 1st IF to

if (keys_info.cipher_type =3D=3D 0 || keys_info.cipher_type =3D=3D 1)

+ else
+ printf("unknown encryption type");

Best regards,
Pavel Shilovskiy

=D0=BF=D0=BD, 23 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 21:51, Steve=
 French via samba-technical
<samba-technical@lists.samba.org>:
>
> Updated with feedback from Aurelien and Pavel
>
>
>
> --
> Thanks,
>
> Steve
