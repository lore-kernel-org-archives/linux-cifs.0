Return-Path: <SRS0=FePp=Q5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E0C1C43381
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Feb 2019 19:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B4BB206B6
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Feb 2019 19:14:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QNEcdXar"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbfBVTN7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Feb 2019 14:13:59 -0500
Received: from mail-oi1-f178.google.com ([209.85.167.178]:39438 "EHLO
        mail-oi1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbfBVTN7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 22 Feb 2019 14:13:59 -0500
Received: by mail-oi1-f178.google.com with SMTP id b4so2571548oif.6
        for <linux-cifs@vger.kernel.org>; Fri, 22 Feb 2019 11:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4Y/mCFBPnHSg3sQCsv8G0cmiP9pb/pAxIAKKEkkyv6M=;
        b=QNEcdXarT5C5cKf+mkQoomqbz80fdDTcWWZySp5uHgtyiHI1EUZQtYvGlYNhDxdmlF
         LTNihcvYC4LQjEoK2OLC+YDGVHRG2F3A7J9Yx26M+JrfoeMx5CtqKC93N/BDqfHlx/1v
         hHKMN/w/k0r7uc1lPqKhFuF0UJd0njXiBLhRSjWM6DEovapeGKqaQ/r9sVLufVUsJKbm
         O5+Kyc0Cyxf+Hv5oiXONrapvfcIYToUzHrQpYZbFnbpvDtnBCZWHBZ0Ch0DXmevkBC5b
         fQ6Vq0bwQ7jCHM1agM8Sas5l7z0nTotw4qZdPrrDNqcbqhGoEfM0+g91NhXd+TqK02YC
         ntbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4Y/mCFBPnHSg3sQCsv8G0cmiP9pb/pAxIAKKEkkyv6M=;
        b=CfdbvIw7eppKztKNvjEXHy4vG7m8EdPgz/G/DYi0BSs4RUIzPdRAEE0fvOJX8rx1Wo
         xulnbFBpXKflD6+QohOZog/Y2ZSyMo1g8un1tBB1fj+srIdGSuT1b63tCiM8QgaZFk/5
         ZrAT08kOBgNBbv/L/7Eo0OEqMDeW5ZwR2525lMsDqLCRFz8lDoBSxJNkr/EmmjFZrGF0
         yaHCpgvdDSc9lu6vRuGDxv8JQnzvEuZrGMiuejQFOzd+/J9S5jhZKv49IckQMLaQMZv2
         Tb/q9QQ0aIgSygz0PV3Oik1apsF8m/HBq+TMYSo8na/FxXI45sDmYeOC2JPPiH+8V0BB
         rSTw==
X-Gm-Message-State: AHQUAuZXoUAda76q5OjkbBwssHxCLJ97sqM3a37NhyJS2yNxbXBez0O7
        KjWaDx/LyWl4FTfBSK4EGslCrkHcllt/pG5I0WE=
X-Google-Smtp-Source: AHgI3IZ7iwu6JPKOT2SGSD/pY/VBSdQWPeo88EoLMQ6A1WSWt42XJSNDS1G8sLwoHknzHjWmPgDEHp6XkQWrJIJ7NR0=
X-Received: by 2002:aca:f408:: with SMTP id s8mr3328446oih.6.1550862838206;
 Fri, 22 Feb 2019 11:13:58 -0800 (PST)
MIME-Version: 1.0
References: <637c6227392d4f67b76aa6ebb8b71d0c@UL-EXC-PR-MBX20.ulaval.ca> <1550849364135.34775@ulaval.ca>
In-Reply-To: <1550849364135.34775@ulaval.ca>
From:   "Robin P. Blanchard" <robin.blanchard@gmail.com>
Date:   Fri, 22 Feb 2019 13:13:46 -0600
Message-ID: <CAJUwKM3kKM-g6L+vAVNUvVbCds6ezFmaB8J2BQT2zWyHBmmc6Q@mail.gmail.com>
Subject: Re: mount -t cifs fails while smbclient succeed
To:     =?UTF-8?B?QWxleGlzIEZvcnRpbi1Dw7R0w6k=?= 
        <alexis.fortin-cote.1@ulaval.ca>
Cc:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Compare:

failed: lines 21-42

I think you may need to mount with a different sec option:


       sec=3D
           Security mode. Allowed values are:

           =C2=B7   none - attempt to connection as a null user (no name)

           =C2=B7   krb5 - Use Kerberos version 5 authentication

           =C2=B7   krb5i - Use Kerberos authentication and forcibly enable=
 packet
               signing

           =C2=B7   ntlm - Use NTLM password hashing

           =C2=B7   ntlmi - Use NTLM password hashing and force packet sign=
ing

           =C2=B7   ntlmv2 - Use NTLMv2 password hashing

           =C2=B7   ntlmv2i - Use NTLMv2 password hashing and force packet =
signing

           =C2=B7   ntlmssp - Use NTLMv2 password hashing encapsulated in R=
aw
               NTLMSSP message

           =C2=B7   ntlmsspi - Use NTLMv2 password hashing encapsulated in =
Raw
               NTLMSSP message, and force packet signing

           The default in mainline kernel versions prior to v3.8 was sec=3D=
ntlm.
           In v3.8, the default was changed to sec=3Dntlmssp.

On Fri, Feb 22, 2019 at 9:30 AM Alexis Fortin-C=C3=B4t=C3=A9
<alexis.fortin-cote.1@ulaval.ca> wrote:
>
>
> Hi,
> I have trouble mounting a windows share on my Ubuntu 18.04 workstation.
> I've tried every thing I found using google search to no avail.
>
> The following smbclient command works, so I know my Username and Password=
 are working
> smbclient -U ulaval.ca\\alfoc //132.203.235.15/Partages/FSS
>
> But the following mount fails with errors :
> sudo mount -t cifs -o cred=3D/home/alexis/smbcred,vers=3D2.0 //fssdc1.fss=
.ulaval.ca/Partages/FSS/ /home/alexis/win/
>
> mount error(22): Invalid argument
>
> I've logged the failing and successful trace with wireshark
> failed : https://pastebin.com/7UTBNgs2
> success : https://pastebin.com/kQ80vVmr
>
> I'm using Kernel 4.20.11-042011-generic
> I'm not sure about the server configuration, but it looks like its a wind=
ows server that support smb vers=3D1.0 and vers=3D2.0
> mount.cifs version: 6.8
>
> dmesg with debug information reads when it fails:
> [ 2021.652324] Status code returned 0xc0000016 STATUS_MORE_PROCESSING_REQ=
UIRED
> [ 2021.667748] CIFS VFS: DFS capability contradicts DFS flag
> [ 2021.673168] Status code returned 0xc0000257 STATUS_PATH_NOT_COVERED
> [ 2021.675001] CIFS VFS: cifs_mount failed w/return code =3D -22
>
> Thanks for helping,
> Please respond (cc) to this address.
>
> Alex
>
>
