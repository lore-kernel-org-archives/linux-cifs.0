Return-Path: <SRS0=MBFb=3L=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34903C2D0CE
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Jan 2020 00:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05EFD217F4
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Jan 2020 00:26:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oNlMToH7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgAVA0j (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Jan 2020 19:26:39 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46835 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgAVA0j (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Jan 2020 19:26:39 -0500
Received: by mail-lf1-f68.google.com with SMTP id z26so3845320lfg.13
        for <linux-cifs@vger.kernel.org>; Tue, 21 Jan 2020 16:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4m772X36tBr4fuhxY0C/k9ViGcw/8CVNj/UQZUwSgeQ=;
        b=oNlMToH73ZJVh7HCMmEyNcHI1vzBX6M7c2Wwc1/pVCrznPRLw7+abGTJfZ1MpLGrNO
         lEPl5VryXOXK3OzmQkQXfFzqhC/1/6fWQUtbOXJiSBvhzAYNBmvLj0rmEO0cmMtQcfBb
         8aKjOS1CsrOFd3hBh/RuKsR0G7AsmrQTiGWQB//tWcRhxmpi3AY1alYECSg1Y0WvDJcK
         2EsCA/rD70nTlFNamCjcdGz1zOHhWUIKdbNJkN4aREaTt3JKnMDiMl0pYptKP2I4b6pa
         /3qWwFAahdZqyIyAqizrOpz4BOVVBjOTrU532wcVFy+3SliY+74sfbWwwWziIAvdPtis
         BiuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4m772X36tBr4fuhxY0C/k9ViGcw/8CVNj/UQZUwSgeQ=;
        b=QX/saESNIgg0ufBc/soXYFeisl8UqiNLNpw5K7Tr+5wTLUjlra+ek45nT5Hydhg9xZ
         YHKg6fJSi3ManozzufH/dev8bGbMpLTL+znpMXwFmrvu6ee1nLi7/agpVk8CxwrPYt4E
         syn1Cpfkjxv1v3oZGf8uciIQcmduKuRtMDEue3vB6zoUlYX7x+5B4TDFNKtafatDqWyA
         VUzozTAx83irUoBOft6fSnb5GhsBb0cPYWTYFQOkm+Qr64MqVlw3ynlFpHefi7cnPwmI
         gm3mtMQC63KSeVw/lhJEF16ZG8LbyQ8IDglPnKZv+4ZtuDbkzvg7wpXX6OUEWOYaKn+C
         +/Mw==
X-Gm-Message-State: APjAAAVmOJ9m7pJQxlSVVaLqvWhnGR9zR8L60dkdXgz8+VzA61DnyP/y
        znYEVJ0Vd3MUh7ZzJjeZPn7huvRznZlGQ4tLVw==
X-Google-Smtp-Source: APXvYqw0kQ1PlgK71tBSG1Y4WBK5KxMSHBcHgdFR/EcYGDIrsWrYdgTMgsxsCZYPtY6O5x7lrEYG1KTg1PXqpWjBAUw=
X-Received: by 2002:ac2:4c2b:: with SMTP id u11mr222742lfq.46.1579652797747;
 Tue, 21 Jan 2020 16:26:37 -0800 (PST)
MIME-Version: 1.0
References: <20200106163119.9083-1-boris.v.protopopov@gmail.com>
 <20200106163119.9083-2-boris.v.protopopov@gmail.com> <CAKywueSK-_zzF-K3_ehmLT3yje_hGaQU-1z-G3hYugMv3ZV-eA@mail.gmail.com>
 <CAHhKpQ7PCQXgvXkjTUuPtX2OHVxee9seGyRT=omJXvZLt3=ygg@mail.gmail.com> <CAKywueSXxYxZLDAXPwsHTyUSHyWV5WmssOwvo7xF-Wgf57XEsg@mail.gmail.com>
In-Reply-To: <CAKywueSXxYxZLDAXPwsHTyUSHyWV5WmssOwvo7xF-Wgf57XEsg@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 21 Jan 2020 16:26:26 -0800
Message-ID: <CAKywueS8_Vxn0YWQYXRdMadghSBc9V6=RquObmD03VeyL8BOSw@mail.gmail.com>
Subject: Re: [PATCH] Add support for setting owner and group in ntsd
To:     Boris Protopopov <boris.v.protopopov@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        samba-technical <samba-technical@lists.samba.org>,
        sblbir@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 9 =D1=8F=D0=BD=D0=B2. 2020 =D0=B3. =D0=B2 10:29, Pavel Shilov=
sky <piastryyy@gmail.com>:
>
> =D1=87=D1=82, 9 =D1=8F=D0=BD=D0=B2. 2020 =D0=B3. =D0=B2 08:07, Boris Prot=
opopov <boris.v.protopopov@gmail.com>:
> >
> > Yes, there is a patch that I have recently posted to linux-cifs and
> > linux-kernel list (subject line "Add support for setting owner info,
> > dos attributes, and create time") that enable setting owner/group in
> > ntsd, file native attributes, and file create time.
>
> Thanks for clarifying!
>
> We need to make sure that the appropriate error is returned for old
> version of the kernel that don't have the patch.
>
> --
> Best regards,
> Pavel Shilovsky


Merged into "next". Thanks!

--
Best regards,
Pavel Shilovsky
