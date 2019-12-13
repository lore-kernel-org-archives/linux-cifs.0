Return-Path: <SRS0=IAhR=2D=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ABDAC43603
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Dec 2019 01:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68FB82073D
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Dec 2019 01:00:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZQWhtqMu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbfLMBAG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Dec 2019 20:00:06 -0500
Received: from mail-lj1-f178.google.com ([209.85.208.178]:32835 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727119AbfLMBAF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Dec 2019 20:00:05 -0500
Received: by mail-lj1-f178.google.com with SMTP id 21so765667ljr.0
        for <linux-cifs@vger.kernel.org>; Thu, 12 Dec 2019 17:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Es6cerqj7pKUEajTnQEKygZ6+SrfVMJY9jCccRdIEZU=;
        b=ZQWhtqMusbh3otfeph5fF5HrXoH80uk7cLt/+ERCRNeaUlSIh0Z2T0tWlFQitIjCXS
         mzWjuq+8dTvRKePsf+mQS6iTokyAzuA/A5CrJ/DEf1NcM6Z6FLX0yV77Hp5O9cZ3UjAb
         LFCCobgCmUTJ8tijK9Vih6a9mJit3GQR4K1vRJ5cJRKIJgpk6iChDH2/Aj3+pvz6mWBv
         0vIEAh08xBQDuwacO5IioHs0r6mh7Cb2fXgn46gmT3awZ5VT3qDmfjnBihYegP/LW8mH
         Rt1KdZwDSWAJNptND+G8lpOt+IIWDz0jXDnivZh6mGbcxpI8pYjEcTe4s0tE9ThEVwiC
         WpYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Es6cerqj7pKUEajTnQEKygZ6+SrfVMJY9jCccRdIEZU=;
        b=tEU/y7XTu5Ofvqb+rzGTpQwaLe7xSsgZh5VAi9SGCZ7SRE/+lyfcaFI1kXASRUj80y
         WtIokasYVOx1WA6B+FGN7vWenS9dvy8mq5qqau+39dtyvZFKiWop6aZzp4IyZ2yRMUW5
         hP3CrPg6ymE8UXtRzqolLhhKRrW7vExA/0XO3MlXLJB/AA7cB1enYzonIUSEWNs+uwFs
         uzMLDrInArDuuKpnxlsyrP7DhekASWcgXCSfo9vk0gfZaCVz9pTXI3b5SRVMGcAxq5HH
         dKsnB6qdlsObNCB17am2P7Rl2tFbGTVdOvOSEw4NtN2fUYvdPFpLGSe9tokzEiPKQ3rf
         Yrlw==
X-Gm-Message-State: APjAAAVLsrNSYdLKIiSvIb0g2D5YLgSCt7ItX25ulM1BmxQVwrCzdjKi
        kqoyiXD0AYLUbk3GBf2/ZtPNp/mLRAGAU8dMpQ==
X-Google-Smtp-Source: APXvYqwnssqjGL/tg0lUEbyA9W5fR1tYY7D3PUb3ZWTzLqqdk9QBCek/w6vJxV/yLurvZsf14FJ6rsHEXthSd1kZ4+A=
X-Received: by 2002:a2e:2d11:: with SMTP id t17mr7597310ljt.177.1576198803899;
 Thu, 12 Dec 2019 17:00:03 -0800 (PST)
MIME-Version: 1.0
References: <20190924045611.21689-1-kdsouza@redhat.com> <87o8yqf4f6.fsf@suse.com>
 <CAA_-hQL8MpS9YEcaQpuiQnbsuJwerutnbxWhE-Fyk1X4jpvwcw@mail.gmail.com>
 <87k19ef0si.fsf@suse.com> <CAN05THSfA9e1DP9+nM=CkgU-mKRnUeJp2p96umrOA3aBiWe9Gg@mail.gmail.com>
 <87h84hf4k6.fsf@suse.com> <CAKywueRD76842q22OpZePdhO9+febBv-CxdhZZiCjCrCjrpAGQ@mail.gmail.com>
 <CAN05THT=mH5_iNnJ581w8V2f2+Rxr_KkYfy9gibu0-ZOsDV2RQ@mail.gmail.com>
In-Reply-To: <CAN05THT=mH5_iNnJ581w8V2f2+Rxr_KkYfy9gibu0-ZOsDV2RQ@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 12 Dec 2019 16:59:52 -0800
Message-ID: <CAKywueQu5ifJjYqY=b6WWWDYqvpP_n029psp5KQ=MyjvknCOug@mail.gmail.com>
Subject: Re: [PATCH] smb2quota.py: Userspace helper to display quota
 information for the Linux SMB client file system (CIFS)
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Steve French <smfrench@gmail.com>,
        Kenneth Dsouza <kdsouza@redhat.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 12 =D0=B4=D0=B5=D0=BA. 2019 =D0=B3. =D0=B2 16:34, ronnie sahl=
berg <ronniesahlberg@gmail.com>:
>
> The patch is pretty small.
> You might need to massage it a little bit since I recall that we
> renamed the smb2quota util
> but that is not yet in github
>

Thanks. Merged:

https://github.com/piastry/cifs-utils/commit/c10c217b117ae6417be29ca4a0b901=
b98566898b

--
Best regards,
Pavel Shilovsky
