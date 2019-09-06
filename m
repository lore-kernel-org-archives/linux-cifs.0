Return-Path: <SRS0=DBI+=XB=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 248EBC43331
	for <linux-cifs@archiver.kernel.org>; Fri,  6 Sep 2019 18:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDC6920578
	for <linux-cifs@archiver.kernel.org>; Fri,  6 Sep 2019 18:23:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WOrzTTIP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404445AbfIFSXU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 6 Sep 2019 14:23:20 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41879 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404380AbfIFSXU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 6 Sep 2019 14:23:20 -0400
Received: by mail-lj1-f196.google.com with SMTP id a4so6859445ljk.8
        for <linux-cifs@vger.kernel.org>; Fri, 06 Sep 2019 11:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uCLv6UOlbd4cayn8R8aUNxYyxSjQeoscl9yzq2HaJUY=;
        b=WOrzTTIPQ3FQ6xilJi3hPhjrDP9tdiSJ6H35ZPam21NvEM9y5sMsZDeb+fK3XWrI7F
         6WgngsUohtcx4w0tgq2YDLrQC0335bZYjv/IyhQLG8ISgQ+WP6Wg8dgCXQkNdR74bVIq
         5PBhaBygnV/RZEfn6k5A15f1tjzmB/JmEJdkFwkHp2ivpDxfztTnyzZT7EgVNqf6r9BL
         45lnBrixAZdwujiPGaSKE9w1dP5k37ThREh8YRLEqh1MrGeXKfUJZX/GjF3n4CLeGibX
         fFzCgDN3Oa4OVahX/LkzXU97K3TpI0594xtrwNmnKkqstbbRpo2Aw/NSs7X0yAB1bZLL
         5IqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uCLv6UOlbd4cayn8R8aUNxYyxSjQeoscl9yzq2HaJUY=;
        b=nYBTXcylH+A9Mh6rjIt7rbRIFqaYzA8pbFsI+PA54IC9vqkwt5m76ugQnh3iFFjd/e
         RjxYty/R83F4oaD+G9mog0XUUNWgYI851/Kxe7/bNoBk+PKV9Apmmd2uvoaI/FhWMfll
         tgPtcp2ecoJ/NirrWLYWy3c+PWf9M7aCnagh2jH0cSp5LcwThYnTGL29xtvhWR6yujaQ
         CgVFFbdcrQuCtTgftvdTaGlFygdcUKtCLg28Ce2U6M319KPDkz7/KwlXbcP1utavomMP
         UJRmY+5ifb9zzjOyx8IazIpGgSvqpaBHtoDw9qlQVIRHt+4B/d4ke7onOqeKgx//OUiP
         2nBQ==
X-Gm-Message-State: APjAAAVXJLHq7k3NffSVEg022CW+gGuaaTk/B7iajVH/PXgFFYuiluTU
        9GxgWwK63/gtGWa/I7yo6wCuGyOfvXRXHKsBAw==
X-Google-Smtp-Source: APXvYqzhSUC+ugt52DqH9o6x2Dua7PpuiMVuoQXFBuSUGCInxAB9yYcdqAoWP5rpIds1c6bvP3lmPv++pRUX9Lyx4S8=
X-Received: by 2002:a2e:8744:: with SMTP id q4mr6443785ljj.77.1567794198337;
 Fri, 06 Sep 2019 11:23:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msoo-XH7h6AAc-7jrFteW37fu6dDYs0Fhg1K6UwEW9aAw@mail.gmail.com>
In-Reply-To: <CAH2r5msoo-XH7h6AAc-7jrFteW37fu6dDYs0Fhg1K6UwEW9aAw@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 6 Sep 2019 11:23:07 -0700
Message-ID: <CAKywueTmwCYrrPygAWXRLj832yLavuo3Yef7YR2v1Y_25vOYrQ@mail.gmail.com>
Subject: Re: decrypt large read offload patch
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 5 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 16:24, Steve =
French <smfrench@gmail.com>:
>
> I am getting EBADMSG from the call (in crypt_message in smb2ops.c) to
> crypto_wait_req when trying to decrypt a 512K array of pages from an
> SMB3 read in a worker thread (rather than in the usual cifsd thread
> which works) - see attached patch (doesn't fail with non-offload
> case).
>
> Any obvious bug anyone spots here?  Looking at the crypto library for
> CCM wasn't exactly clear to me what could be going on
>

+ if (server->pdu_size > (512 * 1024)) {
+ dw =3D kmalloc(sizeof(struct smb2_decrypt_work), GFP_KERNEL);
+ if (dw =3D=3D NULL)
+ goto non_offloaded_decrypt;
+ dw->buf =3D kmalloc(sizeof(struct smb2_transform_hdr), GFP_KERNEL);
+ if (dw->buf =3D=3D NULL) {
+ kfree(dw);
+ goto non_offloaded_decrypt;
+ }
+ memcpy(dw->buf, buf, sizeof(struct smb2_transform_hdr));

^^^
here buf contains transform header + read rsp -- see
decrypt_raw_data() function for details. Should be sizeof(struct
smb2_transform_hdr) + server->vals->read_rsp_size.

--
Best regards,
Pavel Shilovsky
