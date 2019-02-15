Return-Path: <SRS0=lRaz=QW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80747C43381
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Feb 2019 19:54:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C7B9214DA
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Feb 2019 19:54:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SefN0rBG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729810AbfBOTyC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 15 Feb 2019 14:54:02 -0500
Received: from mail-lj1-f169.google.com ([209.85.208.169]:42665 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728750AbfBOTyC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 15 Feb 2019 14:54:02 -0500
Received: by mail-lj1-f169.google.com with SMTP id l7-v6so9357348ljg.9
        for <linux-cifs@vger.kernel.org>; Fri, 15 Feb 2019 11:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VJlBQsjl5cmeK6fgz1A4EBadtC1yOPBnH+6+KtMJ9xI=;
        b=SefN0rBGSV+MjH4mJO/nDd34pQR20YGP4ySY5loLfrFiFGXQ6JXaBkxmqNbmr+fTC9
         mYLhcIinc7zx1uT4X5Iz8FsbEAQ+O6JGjyKXHK2RvDTazOF8eGVR4MfX9Q0BDBZIUah1
         olxrUHLuc22frybAKI4bCVEs+F22XuIKRjhCaRdk2pRkfMYM70ZhQkHMuLPg4By/hYg1
         Eo3Nz8n5/516MDj+pV3lDHqrJlp1RRIyLs8EZWtd3I9+JHsbxnSn3XyDVF2GvCqx5dlq
         jYm6hNDZMRHFaHEHSqgleluvFO1GqWu8C4Zy86Rb6vkcmdT83KnCXSC+spKCM8SgQm2S
         kOIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VJlBQsjl5cmeK6fgz1A4EBadtC1yOPBnH+6+KtMJ9xI=;
        b=LK3gRoJpE50DtR3JkCJVe5a55V66h6g+X985sOVl+RO6q7hTGufufBEFehcXMBmWIV
         0+4wSKliXg7PrPDS0yXaTp6sM5xfpdhIoqG/OeILKzsl4AuvK8pzVQ8kTX0H0hvrGhG/
         PGWc6ipmaFM2gkJRTQeXkyEzLpgbI619a/VDwrPEl0UberTLOvkMNWXyAYk5TShJsSq8
         7661TGjsqCxhQJqjuMKSEPRT9scqmal+Y4bBoqaadX0QbupbPUBJSp+rgJ2OA+qwlqvt
         QbQWuUW1DoDucTFQy4/0VmFDrzMUt0FEPcYlLLz46s+jHVFVFa7pcm84evvgyofX8CCk
         vKxA==
X-Gm-Message-State: AHQUAuYCNGHQJXb0J7rzPfYyFm/6SEeFB21YkCJC1OfIrmEWPMg228fv
        +KunrYXNwpF/BzZ1z8nTVvjJMhOQnnSfXfmBd6GhYuc=
X-Google-Smtp-Source: AHgI3Ibo+C39xis7dhCjZnfE6zZtYXxqGegw87KUnz3o+cICnBuM8AWJyD07ICt5Q+RB4vmFbJZCiN6vO6OswARxhEk=
X-Received: by 2002:a2e:124e:: with SMTP id t75mr6857383lje.23.1550260440237;
 Fri, 15 Feb 2019 11:54:00 -0800 (PST)
MIME-Version: 1.0
References: <CAKywueRwez4Djs50dMityuA=hnE6SMeWUJ8xdTYs+jEhNvdCog@mail.gmail.com>
 <878syhqmny.fsf@suse.com>
In-Reply-To: <878syhqmny.fsf@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 15 Feb 2019 11:53:49 -0800
Message-ID: <CAKywueQpAMRG0tumuCsUyMTGmERcKTyvF33p2AG1GYf=h1gNoA@mail.gmail.com>
Subject: Re: [cifs-utils] next branch is updated
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Paulo Alcantara <palcantara@suse.de>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D1=82, 15 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 04:08, Aur=
=C3=A9lien Aptel <aaptel@suse.com>:
>
> Pavel Shilovsky <piastryyy@gmail.com> writes:
> > Please take a look in case anything is missed.
>
> Last commit is missing signed off tag, otherwise LGTM.

Thanks.

--
Best regards,
Pavel Shilovsky
