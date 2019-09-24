Return-Path: <SRS0=4YGq=XT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6967C432C1
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Sep 2019 21:06:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93B9420872
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Sep 2019 21:06:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eoaJGoq5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730496AbfIXVGl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Sep 2019 17:06:41 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46717 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727476AbfIXVGl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 24 Sep 2019 17:06:41 -0400
Received: by mail-lf1-f68.google.com with SMTP id t8so2472048lfc.13
        for <linux-cifs@vger.kernel.org>; Tue, 24 Sep 2019 14:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tjtYCZsjasKxsEUg4Ni3aXksZAft4zXZ7+eYF1bSzD4=;
        b=eoaJGoq5DodMblTTbDB67yS37E10WTIUsnWwChIq+ieIhbcXU56SSwhfPjPeO46vhK
         yUCKpV1ElReeQbinxGirtNtLCQxDTnSyroErWv2M5Vd4cNg6nnOOrwI9CyQt8enfxClS
         zqf7KX3DNmCK1yZhdouDKU58eziVEC7gX20d9nkzWOm8zoluLBBeZntNZCEuRQOSL7Ed
         gYJIkHycfXl9Y7TpVF7Tdr9vYGCT74tmGunbb9tzxZpYzfngk6zr7SPHaKnl2GuzJRDu
         f776egZozSS6JM7XQ5YxcIv3wnUd3YKSdCmkIiqJZByGyZ/jf8ZBuv7o478QmqqYtZj2
         rQKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tjtYCZsjasKxsEUg4Ni3aXksZAft4zXZ7+eYF1bSzD4=;
        b=SJ+5rGMnKSCU6uEApTVCLkj/5JechNKkN3AxK3+lfdoizlFIT9WkbzEVmWKM8dJ/+K
         rnUNos2HSR7oru0T6SZL05t/Y1gJak3PdCKAT1MI9fJiZshVSEZEhrvEC8903XDj28I8
         s+PcK4cqmItMc7eV5MTh51dA4gNEAPvKUr7aSYR6CLvosQ5ACgksuzB9LbxU/OHMtlHU
         8OD5X7OvC0yVi7EW+Haqc21uBGwIiM9QoVhR6sDSzBz7cl4fAr671kkyjdRSJ0aJlddH
         Z43NeLXRNbn/7AzdDQRzVm2Bru1NnIKI3ch83IhxW9tF7GPMWmg+slm1sfJathfl+/CX
         bklQ==
X-Gm-Message-State: APjAAAXUFk+vPG+iI75jN/+O2LaPprmj1Eg1L+FH5j4SrhNwlsrdKGsA
        yOlhr6Joqh01HyPXMxZF+PF719EU+UHuWbTB6A==
X-Google-Smtp-Source: APXvYqzPd4vT7Of4U1LVGZU15nZWc1Zho5FvEKe+9rFiFreCLFOeVkeKhVYJ+mKV9QignRtBR7OqXpGf6QIkqpiXZzA=
X-Received: by 2002:a19:8a0b:: with SMTP id m11mr3198075lfd.4.1569359198566;
 Tue, 24 Sep 2019 14:06:38 -0700 (PDT)
MIME-Version: 1.0
References: <61d3d6774247fe6159456b249dbc3c63@moritzmueller.ee>
 <CAKywueT=hWCTM=Crsafrj-8P=1mD93DY73oK=Ub8JeWc5X85fQ@mail.gmail.com>
 <4a017b583eb0f5fab477ecbe0e43b3a1@moritzmueller.ee> <CAN05THR5FE80VsnbKfpBzvt+g5jPu3rtiOqWkzU5yKoKUkhkiA@mail.gmail.com>
 <CAKywueTOjoP-Jh7WWCi5XJhfzgK+KZs3kvHKuVG_HW0fnYYY7A@mail.gmail.com>
In-Reply-To: <CAKywueTOjoP-Jh7WWCi5XJhfzgK+KZs3kvHKuVG_HW0fnYYY7A@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 24 Sep 2019 14:06:27 -0700
Message-ID: <CAKywueQUuwRK7hbbJhdquVVPre2+8GBCvnrG76L-KodoMm9m6g@mail.gmail.com>
Subject: Re: Possible timeout problem when opening a file twice on a SMB mount
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Moritz M <mailinglist@moritzmueller.ee>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=82, 24 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 12:05, Pavel=
 Shilovsky <piastryyy@gmail.com>:
>
> Thanks Moritz for providing this information.
>
> It seems like a new long-term bug in the client code. The client
> requested a lease but the server responded with a batch Oplock value
> (0x9). Since the mount is SMB3.1.1 the client assumes that the server
> always responds with a lease thus interprets this as a Lease State -
> 0x9 matches in the bit mask only a READ lease flag (0x1). Later on
> when the client receives an oplock break from the server caused by the
> second OPEN, it looks at the caching level which is READ and skips the
> OPLOCK BREAK ACK step (according to the spec). That's why the app
> hangs waiting for the oplock break to be timed out.
>
> In order to fix it, we would need to tech the client to recognize
> Oplocks on SMB3+ mounts assuming that the server may return both
> Oplocks and Leases in response to CREATE command.
>
> Ronnie, what is the version of Samba are you using? It is up to the
> server to decide if Oplock or Lease is returned.
>

Moritz,

Could you try the following patch in your setup to see if it fixes the prob=
lem?

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 047066493832..00d2ac80cd6e 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3314,6 +3314,11 @@ smb21_set_oplock_level(struct cifsInodeInfo
*cinode, __u32 oplock,
        if (oplock =3D=3D SMB2_OPLOCK_LEVEL_NOCHANGE)
                return;

+       /* Check if the server granted an oplock rather than a lease */
+       if (oplock & SMB2_OPLOCK_LEVEL_EXCLUSIVE)
+               return smb2_set_oplock_level(cinode, oplock, epoch,
+                                            purge_cache);
+
        if (oplock & SMB2_LEASE_READ_CACHING_HE) {
                new_oplock |=3D CIFS_CACHE_READ_FLG;
                strcat(message, "R");


--
Best regards,
Pavel Shilovsky
