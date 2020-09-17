Return-Path: <SRS0=/4jl=C2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE001C43461
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Sep 2020 10:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 638292087D
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Sep 2020 10:13:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=suse.com header.i=@suse.com header.b="L+PnOrQA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgIQKNZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Sep 2020 06:13:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:47280 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbgIQKNO (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 17 Sep 2020 06:13:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=cantorsusede;
        t=1600337592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J7eP0z26BsJd9MiNvhLduMDSaOEQjZ+vz5WWEQrTxls=;
        b=L+PnOrQAsPzbow10zwHme1Q9aIneo/G0o3rQfIVfIhgS4u4/YQ7MR76eUraIx60GUWUxI3
        AiuHC16wz+2ClW9MOtO2aEl1tA4GKtE9aj4QRJmAn/MCHd8BT/zpoA91keV4swyk6pm2RS
        FAXaHkm/P7qWth+E0QPnynIlwrMzhtN5nZ1XaV3PZwfOIHwnlvrllJiCCzaeaWwyN/bgWy
        qHkWRRWDROUcBY4kxyNVgQ/7EX71b62S++tfRquHCRozs1AdNazoG6a0B7Xg+unZg26ZxD
        n/hlBvm3fkvF9fZeNf/3fNLrPKSBeV12R2houD4NOQ7MmYmr91sLJzkGz21tvA==
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 515D6ACDB;
        Thu, 17 Sep 2020 10:13:46 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com
Subject: Re: [PATCH][SMB3] mount.cifs: use SUDO_UID env variable for cruid
In-Reply-To: <CANT5p=rarYr0bErP77GF5QOu8=xx7Ovfy2dWdUNxnOTGkLXMKQ@mail.gmail.com>
References: <CANT5p=oiTY63d5yVyywiTrCqpAmvaugMVVpQRV7RT7ZA9HU2+Q@mail.gmail.com>
 <87r1r2ugzw.fsf@suse.com>
 <CANT5p=qV6BWojwBET+kYUwJf7tQDFoRtUb8O+pWHrqWMw5e5LQ@mail.gmail.com>
 <87wo0slr0c.fsf@suse.com>
 <CANT5p=rarYr0bErP77GF5QOu8=xx7Ovfy2dWdUNxnOTGkLXMKQ@mail.gmail.com>
Date:   Thu, 17 Sep 2020 12:13:11 +0200
Message-ID: <87o8m4lnig.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:
> Attaching the patch with the review comments incorporated.
> Tested a few positive and negative test cases. Works as expected.

Great, I only have one small comment:
> +	reinit_parsed_info =3D=20
> +		(struct parsed_mount_info *) malloc(sizeof(*reinit_parsed_info));

Don't cast malloc return value (void* gets implicitely promoted to
any pointer type).

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, DE
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)
