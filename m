Return-Path: <SRS0=BG3M=RM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 788B1C43381
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Mar 2019 00:38:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46458206DF
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Mar 2019 00:38:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o8aieUoU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbfCIAio (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 8 Mar 2019 19:38:44 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46505 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726311AbfCIAin (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 8 Mar 2019 19:38:43 -0500
Received: by mail-lj1-f195.google.com with SMTP id v16so18851886ljg.13
        for <linux-cifs@vger.kernel.org>; Fri, 08 Mar 2019 16:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=p+54onMSv1wE1ZLr4v12Ha/KBNVAq4xZ9ofeTdonrK8=;
        b=o8aieUoUoBG1OMUnynrjZp+se+wnhGruG+RHZlSgHp/5/z4/SLD7IAOsur1P5IGDPy
         VwDiXyFlquMMqTExo/cE26XIWIEq6BKayLGONGtLr6M8eIoh0FzXNaYIuLKmEfDl2+u1
         KNIBun8QW7o6pDQgCIpqJw5Y1I5ZCp7HoHIGI2fzGIAUQ0RZr5VPtfu9nj0KeZmwDhe5
         0S1vK18Q+XTo4IInT+xbJpNKWHSgMOS5NhCVF/Z3i521tKTBKO8kinCiBlPy4tN3r6nb
         FMvBgmnBTTvzWhJFNXzE/QeePd32cxn5VaNgkLDX2Cf3c02wHYr3/QDeHfUhBWQ0ZGBd
         wzzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=p+54onMSv1wE1ZLr4v12Ha/KBNVAq4xZ9ofeTdonrK8=;
        b=srgMtcjM7R7Q+35F0YHzlaxXmoBdzN0pT1ngELO3esff5nU2SC2ZkJJsXddX/WH64K
         M7Jqf19mLdFFOCfCAZl3EBGhvF0bWzbugAZs65hgbxTYc2Tc5gAWmiAp6wUYpWMj1ZG4
         uSVlkZrWcrWhq8/x38ZML2mK+VtMr/6W4S9ry5ldUAXCHEsWp9FVOeVckRJgJIRkUpQN
         pL7zH+Y5O4/yRnC+nNAeiw4xKQT4f6vHb2iGPW5ArmG6aX1p7QBsOhcvz2Exe2BWkXmb
         kaEfh1+rHjAq4VBqSyJJlWWIyOdth2W6gpUpQfCOCjOy/7R2HrQ86L0R+sLx06gNWIGa
         vVyg==
X-Gm-Message-State: APjAAAXTgAbNhkpaK/1mZ/u3VbxydQOP7DKvoivBe855TXdY6WJicANR
        /ptAoRGkRr77rSMZf+dytW3y56YBPOyVDqocKg==
X-Google-Smtp-Source: APXvYqzbELe3v9s++L2cWa9U4mhIyOpoaGHG1jmbAdEsCREoAjzazGsrHcDF9Wav/Of4CGnsA4m/b/KRuk0oNU2lfBs=
X-Received: by 2002:a2e:251:: with SMTP id 78mr10506750ljc.90.1552091921847;
 Fri, 08 Mar 2019 16:38:41 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mufwdyGa0vs2=7cNDLbUXz3nVNvnQfcUOTbm7+6GPnNmQ@mail.gmail.com>
In-Reply-To: <CAH2r5mufwdyGa0vs2=7cNDLbUXz3nVNvnQfcUOTbm7+6GPnNmQ@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 8 Mar 2019 16:38:30 -0800
Message-ID: <CAKywueQtz9vt2AdrP1Cds6WEJU=ABD_-S3j-67mQhBJMBERLiw@mail.gmail.com>
Subject: Re: [PATCH] setcifsacl - fix adding ACE when owner sid in unexpected location
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D1=82, 1 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 21:14, Steve French=
 <smfrench@gmail.com>:
>
> Patch to fix setcifsacl when owner/group owner are at end instead of
> beginning. Seems to work (see below).
>
> $ setcifsacl -a "ACL:Administrator:ALLOWED/0x0/FULL" /mnt/file1
> main: setxattr error: Invalid argument
> $ getcifsacl /mnt/file1
> REVISION:0x1
> CONTROL:0x8404
> OWNER:NT Authority\SYSTEM
> GROUP:NT Authority\SYSTEM
> ACL:NT Authority\SYSTEM:ALLOWED/I/FULL
> ACL:BUILTIN\Administrators:ALLOWED/I/FULL
> ACL:S-1-5-21-859164523-2028333235-149708467-500:ALLOWED/I/FULL
> $ ./setcifsacl -a "ACL:Administrator:ALLOWED/0x0/FULL" /mnt/file1
> $ getcifsacl /mnt/file1
> REVISION:0x1
> CONTROL:0x8004
> OWNER:NT Authority\SYSTEM
> GROUP:NT Authority\SYSTEM
> ACL:NT Authority\SYSTEM:ALLOWED/I/FULL
> ACL:BUILTIN\Administrators:ALLOWED/I/FULL
> ACL:S-1-5-21-859164523-2028333235-149708467-500:ALLOWED/I/FULL
> ACL:\administrator:ALLOWED/0x0/FULL


merged, thanks.
--
Best regards,
Pavel Shilovsky
