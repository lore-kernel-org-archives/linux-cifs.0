Return-Path: <SRS0=IAhR=2D=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB8EC3F68F
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Dec 2019 00:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D984D2073B
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Dec 2019 00:25:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j6mBTlNV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730883AbfLMAZK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Dec 2019 19:25:10 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41236 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731313AbfLMAZK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Dec 2019 19:25:10 -0500
Received: by mail-lf1-f67.google.com with SMTP id m30so621512lfp.8
        for <linux-cifs@vger.kernel.org>; Thu, 12 Dec 2019 16:25:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PrZTh2RUXWweRegz/rs4F6o/Fpos7TnzFefrYo+y2a0=;
        b=j6mBTlNVh+ke6S+mK9By8YZfwCEar3jEYJNUcVl63B533MGBL8xx2OUBoDAolcISW8
         EDhwzQp//JZXwNR6IciDbSI76cwquUUjXN5qP44QimRyTOP1mchJZGTixfXXDCh9uSLu
         VG1ZZHHeJDaMD1OwkhblvD/CSIytJcexIcV8KgJHe0ONmO/NNdVi4MnkDDInFktb5HRj
         4Q3E/odVp31tgkBolNaaksJGdoi/kC4C/+wtNE1hbhESQShJsEltM9mh86f4XHArDbFl
         3kno4a3AGqq3Z6ATijokKSG1zX5hLvHcCIQt+e86KlYcnfoCPlMYqoGSrg5720DgFHvH
         V/Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PrZTh2RUXWweRegz/rs4F6o/Fpos7TnzFefrYo+y2a0=;
        b=gHkStq7+XFrsShSOtlpY+LS+LIYoBkhXdQ7vUxOIl2YsSy+69w8IumxgnaNapO4CCd
         rkj5mL3l4t9F/uMtEGFkmJ7pe8CrXpUsvX028Mg/i2NScvmReROfz/W3bh60+rmGV3dN
         vaUBkoYfsnxtU+Cnbocm8iby8F0DGC31VHAhbkM6QKxZe8+hFj60wWg6wHap61pBCrwx
         gPrdG4NYnJIRFw63JJ9UEfT8JRrqwHv4583KrgnYVpAN/Mewf+wWn1VktvfBi/g5XVtm
         aHbfOy2wuKYiRmTK25OMS6Y1c/c1CmH6G+TJ1sU6yzurjO5Db8hobZYS2vN4KaU3XzIQ
         AMfA==
X-Gm-Message-State: APjAAAWKdygkfkJOjzNXPTVYToT/S5WaHZY/EJzPZiHUK5JlsvtM6H1d
        oGUV+urRbPACnsaPkH4xZYEU/KmPxgIRd/maDA==
X-Google-Smtp-Source: APXvYqzGOZvT91jE23mGpIa8JpE/0Vn4Nm5Cjh8eLuZCOtP462pd5KYbZsJTnB1tRWZ+bIyQYT9DADJbD6/hwESkZ4U=
X-Received: by 2002:ac2:57cc:: with SMTP id k12mr7585722lfo.36.1576196708362;
 Thu, 12 Dec 2019 16:25:08 -0800 (PST)
MIME-Version: 1.0
References: <20191009060151.7913-1-kdsouza@redhat.com> <87r23mf5ji.fsf@suse.com>
In-Reply-To: <87r23mf5ji.fsf@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 12 Dec 2019 16:24:57 -0800
Message-ID: <CAKywueTyRz=+UbrAE4YTarTqPFFD8RS9kcndfxCc+ThJZJ+bkw@mail.gmail.com>
Subject: Re: [PATCH v3] mount.cifs.rst: remove prefixpath mount option.
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     "Kenneth D'souza" <kdsouza@redhat.com>,
        Steve French <smfrench@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fixed 3.1 -> 3.10 in the description and merged.
--
Best regards,
Pavel Shilovsky

=D1=81=D1=80, 9 =D0=BE=D0=BA=D1=82. 2019 =D0=B3. =D0=B2 05:48, Aur=C3=A9lie=
n Aptel <aaptel@suse.com>:
>
> Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
