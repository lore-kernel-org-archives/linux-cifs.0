Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F39FC433F5
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 12:45:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2FE461AA9
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 12:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbhJBMrO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 08:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbhJBMrO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Oct 2021 08:47:14 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44CFC0613EC
        for <linux-cifs@vger.kernel.org>; Sat,  2 Oct 2021 05:45:28 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id x1so14407861vsp.12
        for <linux-cifs@vger.kernel.org>; Sat, 02 Oct 2021 05:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yRINJ/bwOnL2izz2Bvx36MbdkDPWAc9YjnDgNvRaJz4=;
        b=orsrYtWP3XrtlZI8m4KOrGUojfR+3TQPBftEhNHTnK4XQUDWyd0zjPLjPU1SYzchkI
         6B3B8Az3cn1kJ4yUbGilxKU/QiBB9GVBAkXjM9vyU/3jG84l9u7doO8ZmTgqAF8QOGmf
         GriH1DAdu02N4pvqQQmLFoDyHmjYE3Hd2iHJkxIUlQclUrtsO0amClzrgoLtTrlbKG6a
         8f4gpdFG8uiP+HnQpmFaN3EM7wuJK9kA9iNzWFE8Nk2On38m2DvCMKb1vGGeTOfb2AD+
         P/kPNxEN96rJZip6AB1R35mHARHNk/3yFDhG9t0MIAFm59ms+TGFY7IJ96ZCMY1/maKC
         fUwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yRINJ/bwOnL2izz2Bvx36MbdkDPWAc9YjnDgNvRaJz4=;
        b=ahEBb3mX+6+1PLQLUgaIBanmMAxtDo+TRVS/yixvrh7ZPrVdxdUddpPk+k1WsaC+QF
         oRS9CXdO5OkwzzthpZfEQAYm8FWZD1GoWG/C3nQGkEisQhOuIT3mxtT4/Sk7YFbnomF2
         GACY1FsAc2h5oeOzJ8oE8kOdFe+rmzwF8V58+S2r+5estOqtaKhrBz/VInS6IVuGA8nf
         9U5OevyE4DK2xyCEkYS/HIV0SYwY0UZlRf7h7f2LP53FuwXbeWvtHJUP1rlNGBsvDVG8
         G5vbUt+feVS9PX9vZ1ENEHcDSnWFfjzMlxkX3NhW1M+BAGmpt3uNVybkDXGj5PLlc/ZQ
         nHgA==
X-Gm-Message-State: AOAM530ZAe8dHwH/B+a0r1drYbDiAmspW4VI2UfvPbve7/S2sLRGhY37
        0bAIF1XZ9vtBvpNHrADxmWukdX333xUE0aCyXDI=
X-Google-Smtp-Source: ABdhPJzrUSzlea1Uprxa54oKaUAfbvPlXZDJIkX2d8gD/BNUuaCEYq1NnoX3N18jsR9/HMe34geXAo78BY/ci013wUo=
X-Received: by 2002:a67:e11c:: with SMTP id d28mr368757vsl.44.1633178727839;
 Sat, 02 Oct 2021 05:45:27 -0700 (PDT)
MIME-Version: 1.0
References: <20211001120421.327245-1-slow@samba.org> <20211001120421.327245-17-slow@samba.org>
In-Reply-To: <20211001120421.327245-17-slow@samba.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Sat, 2 Oct 2021 21:45:16 +0900
Message-ID: <CANFS6bauPdTuE-QRuUwLDJD59C62M9dd6Kxoq-emUOib=xiysg@mail.gmail.com>
Subject: Re: [PATCH v5 16/20] ksmbd: check PDU len is at least header plus
 body size in ksmbd_smb2_check_message()
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Ralph,

2021=EB=85=84 10=EC=9B=94 1=EC=9D=BC (=EA=B8=88) =EC=98=A4=ED=9B=84 9:25, R=
alph Boehme <slow@samba.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> Note: we already have the same check in is_chained_smb2_message(), but th=
ere it
> only applies to compound requests, so we have to repeat the check here to=
 cover
> both cases.
>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Signed-off-by: Ralph Boehme <slow@samba.org>
> ---
>  fs/ksmbd/smb2misc.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
> index 7ed266eb6c5e..541b39b7a84b 100644
> --- a/fs/ksmbd/smb2misc.c
> +++ b/fs/ksmbd/smb2misc.c
> @@ -338,6 +338,9 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
>         if (check_smb2_hdr(hdr))
>                 return 1;
>
> +       if (len < sizeof(struct smb2_pdu) - 4)
> +               return 1;
> +

Do we need this check before accessing any fields of smb2_hdr in
ksmbd_verify_smb_message()?

>         if (hdr->StructureSize !=3D SMB2_HEADER_STRUCTURE_SIZE) {
>                 ksmbd_debug(SMB, "Illegal structure size %u\n",
>                             le16_to_cpu(hdr->StructureSize));
> --
> 2.31.1
>


--=20
Thanks,
Hyunchul
