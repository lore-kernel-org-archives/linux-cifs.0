Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_ADSP_ALL,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08BBBC4743C
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 12:17:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1BEB6100A
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 12:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbhFWMTk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Jun 2021 08:19:40 -0400
Received: from mx.cjr.nz ([51.158.111.142]:8658 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230019AbhFWMTj (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 23 Jun 2021 08:19:39 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 8DB2C80285;
        Wed, 23 Jun 2021 12:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1624450641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SStqJhK30+XmEyg3h35gWWIFB44ZcetsXIIf6L7S2lQ=;
        b=zpRMqegaNPsZmco/K+Gg9LkfHErTGg0Kf/n3f6r2d63AHQbw+fdGm3lYbj7xTA1NM4n7tj
        9gDMDiAkTYoSCmulABMxlSAnCodX/U5x5TbkOoy6MmStPW8svxyD2HxTtPQPUcNmF7L5E+
        BioEGF+szvq7QCzWyMlIAAMB1HiSAVrYltABF/xujbQnLj9yKphOAdOwUv/gXHrDgf3c3p
        sy6kaBTfg8J/qJCM9ye/2EUqKKvloBynqd/6lG8bkqZwD8YW5tWhvhfMr8wD9kd0xh6gsn
        lwVNkGD0fVi6k45d92zeciI8kVIdsBUN0FMpaC7l+S1zp4/YczxsbMoQzd4NDg==
Date:   Wed, 23 Jun 2021 09:17:12 -0300
In-Reply-To: <875yy4red3.fsf@suse.com>
References: <CAH2r5mvxp8OZthKPQGCv82xEkNW+z7SN_QhdRUMnHJ2Fm4pJqA@mail.gmail.com> <875yy4red3.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] cifs: missing null pointer check in cifs_mount
To:     =?ISO-8859-1?Q?Aur=E9lien_Aptel?= <aaptel@suse.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
CC:     ronnie sahlberg <ronniesahlberg@gmail.com>
From:   Paulo Alcantara <pc@cjr.nz>
Message-ID: <B3F6DE12-CA6D-47BD-9383-B4BD2F73FCBC@cjr.nz>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Agreed=2E

On June 23, 2021 8:48:24 AM GMT-03:00, "Aur=C3=A9lien Aptel" <aaptel@suse=
=2Ecom> wrote:
>Steve French <smfrench@gmail=2Ecom> writes:
>> We weren't checking if tcon is null before setting dfs path,
>> although we check for null tcon in an earlier assignment statement=2E
>
>If tcon is NULL there is no point in continuing in that function, we
>should have exited earlier=2E
>
>If tcon is NULL it means mount_get_conns() failed so presumably rc will
>be !=3D 0 and we would goto error=2E
>
>I don't think this is needed=2E We could change the existing check after
>the loop to this you really want to be safe:
>
>	if (rc || !tcon)
>		goto error;
>
>
>Cheers,
