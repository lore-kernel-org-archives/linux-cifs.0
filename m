Return-Path: <SRS0=I8uG=XP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74A35C3A5A2
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Sep 2019 17:14:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4700D2086A
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Sep 2019 17:14:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hjKqmRJC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729421AbfITROW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 20 Sep 2019 13:14:22 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:32997 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbfITROW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 20 Sep 2019 13:14:22 -0400
Received: by mail-lf1-f67.google.com with SMTP id y127so5603651lfc.0
        for <linux-cifs@vger.kernel.org>; Fri, 20 Sep 2019 10:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ESelHwgO3+2i5rz/QsN8eVcv4qgUjVwoX52Nxx4zS84=;
        b=hjKqmRJCPl40qD7zxg2LKEsqEBNkD20wHn7YdPpTvX5yP4s5YwEBKSL6akQAEyLQmJ
         KTF5b4K00ibaDFdf+tzJ7KUcgtf/FweY+oNfoIKvoIx3yoF5sQjP4REJIKrFY9AMSO+Y
         tcCDebC04dzdb603NNXd/iPiiVQsHvJdE0+/aG4TCoAQW8aTQSRpRCsbA4YDj2g89a4r
         Ai0AWM4AKK8126fb8H39kf5pelIEvaZipvFqWwTj3CQpvLoRcEitNyQMn0xfsBN+a8gk
         XoABSLooJAqql6eEXuEuVpziMX8KRSWqkIQuYfAjawlubyo+PVhUSUSL5T1+Xn6hvL4d
         i5bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ESelHwgO3+2i5rz/QsN8eVcv4qgUjVwoX52Nxx4zS84=;
        b=ZDJVDkM0GHfJeSu3JCqDTqrnmD0Jpv/zC1x7vmVW0vbbESgpxOPbf7ctNc8+OHTp5m
         ANb4hzyp+9q7vRo2Eu/00+eoh4vtEo2Drl9SUoc+wRMGTGFKDpxLog2gNwvNoPrEggaO
         MVXhrIb0XKsB0DDaxvwD2+2wCStvQkK/czwlw5fJ1aMlI+OqnunuZ8ELPndVLEXyzR7I
         lv2DXEihdGMYMEp2HZkwmxjLsaGc1yG3dYSf/+Y7OlLYje6AGYzSHcTJNuNhtolADXdg
         Itj4pnzdzrQ+1YCtg8IIlqt7h/FxswW90kSriUvtJ+9jj3ZnwS9RMDtx/yv4+JW+sG5G
         o8Bw==
X-Gm-Message-State: APjAAAVW7dhdYL/abWQWFwKGGUlmKcjAEvXloTvhJpyIm8xXDdYReOAQ
        OiW/QeDG1KiS1FyQVoYmiUowltVhe/GcZRjwdA==
X-Google-Smtp-Source: APXvYqxSS//pQQ+Tt4bM3mO16/k+oliOsClZKficPGR4VWE8Mb1aaCigHd1+4k9l+jzr2O3qSeQ1gmG1Mr5Pm1qEhYI=
X-Received: by 2002:ac2:4308:: with SMTP id l8mr9201715lfh.25.1568999660621;
 Fri, 20 Sep 2019 10:14:20 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvcRuSihH58GgrzXTAHuXnQ9a0N-d8AkLLOigQrqincKg@mail.gmail.com>
 <CAH2r5mvAw3ShBpy39OodU8EgXqR0rFBmAk0TXJbug1N22R8o4w@mail.gmail.com>
In-Reply-To: <CAH2r5mvAw3ShBpy39OodU8EgXqR0rFBmAk0TXJbug1N22R8o4w@mail.gmail.com>
From:   Pavel Shilovsky <pavel.shilovsky@gmail.com>
Date:   Fri, 20 Sep 2019 10:14:09 -0700
Message-ID: <CAKywueQW84FxiG1QEmWSJdJiUAiVbYr+0hYVPc4ypW8OAtTZYQ@mail.gmail.com>
Subject: Re: [SMB3][PATCH] dump encryption keys to allow wireshark debugging
 of encrypted
To:     Steve French <smfrench@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks, this is very useful functionality! A couple comments below.

kernel patch:

+ cifs_dbg(VFS, "ioctl dumpkey\n"); /* BB REMOVEME */

please remove this or change to FYI.

user space patch:

+ if (keys_info.cipher_type =3D=3D 1)
+ printf("CCM encryption");
+ else if (keys_info.cipher_type =3D=3D 2)
+ printf("GCM encryption");
+ else if (keys_info.cipher_type =3D=3D 0)
+ printf("SMB3.0 encryption");
^^^
SMB3.0 encryption is CCM, so, let's not confuse users and print "CCM
encryption" for both cipher_type values of 0 and 1.


Best regards,
Pavel Shilovskiy

=D0=BF=D1=82, 20 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 00:20, Steve=
 French via samba-technical
<samba-technical@lists.samba.org>:
>
> And updated patch for cifs-utils ("smbinfo keys <filename>")
>
>
> On Fri, Sep 20, 2019 at 2:07 AM Steve French <smfrench@gmail.com> wrote:
> >
> > kernel patch updated to check if encryption is enabled
> >
> > In order to debug certain problems it is important to be able
> > to decrypt network traces (e.g. wireshark) but to do this we
> > need to be able to dump out the encryption/decryption keys.
> > Dumping them to an ioctl is safer than dumping then to dmesg,
> > (and better than showing all keys in a pseudofile).
> >
> > Restrict this to root (CAP_SYS_ADMIN), and only for a mount
> > that this admin has access to.
> >
> > Sample smbinfo output:
> > SMB3.0 encryption
> > Session Id:   0x82d2ec52
> > Session Key:  a5 6d 81 d0 e c1 ca e1 d8 13 aa 20 e8 f2 cc 71
> > Server Encryption Key:  1a c3 be ba 3d fc dc 3c e bc 93 9e 50 9e 19 c1
> > Server Decryption Key:  e0 d4 d9 43 1b a2 1b e3 d8 76 77 49 56 f7 20 88
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve
