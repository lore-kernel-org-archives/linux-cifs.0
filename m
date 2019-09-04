Return-Path: <SRS0=RvcV=W7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D286AC3A5A2
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Sep 2019 02:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B46A22CED
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Sep 2019 02:37:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mKqZ/8en"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbfIDCh7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 Sep 2019 22:37:59 -0400
Received: from mail-io1-f47.google.com ([209.85.166.47]:38231 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727805AbfIDCh7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 3 Sep 2019 22:37:59 -0400
Received: by mail-io1-f47.google.com with SMTP id p12so40809817iog.5
        for <linux-cifs@vger.kernel.org>; Tue, 03 Sep 2019 19:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UxMatm/CQf2ot9Kix+hu0VMV+wiVFkLkB7Tb6FurN2s=;
        b=mKqZ/8enJY45V9FrziIB6qjL8snoYFwXgW+pjZ9Z4iXm+LgdRKZYiq53wxGsw9FM/e
         efq0v4bXhZGBGc5UHddQkeXV1J3ugqwsuuQ0uBjNVObj+tsWKH1U62yvpup4u+fWcTOS
         lqCX11ejMy3latdkWBja054xMDsY0kV6DI2iDYuRb5qEyy33WFGa4g996TAJbCmeepV9
         an41wGij4owNsZwbiPDWReFY7HNzjO4m15a3qew8zbFhUtDmclusXB+v6N3Air7/WVFB
         HpzlUC7f4UCgzg8scrzTlJpZ585vAKQQwrkPJWnS1wGeuc4NqThIm9XFQtZdWC/QlDuG
         e5/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UxMatm/CQf2ot9Kix+hu0VMV+wiVFkLkB7Tb6FurN2s=;
        b=sk/sUuxND0zjn20Sw1X15NjrREkPvppomOWcwpeWBXr7ftGz1mqYzP5V/nG4I8+y2x
         iwtXu4UZVJ67FnXGDCdzRmsj7gAQKNghQ70RhHprzILosmybsFwu58rCfDPW1pbN/EZe
         5uuT2d0/uM/LVCtK/nmXLVjfvV2zE/AaHtTPKcbU2fq5bcT9s3KNMyaJh4NVoYWz3z4y
         hOHihHPbLBL79TAgPYyhdZ67lfQDUG1L9gkMgwrqYm6ZGUnvW6K28Ka65GARGp0S3BOx
         c6ZiE3a/glKd4P/2NgTpqbWdISoCvV8uuB6C1JtsyreB8NUm164N0rXxSWFjbuimTLb/
         y5Tg==
X-Gm-Message-State: APjAAAUESEP12x2fu7CB0dmoLpXEQB0OyGzNcoF3JEDS6S+pKlzpsIM/
        LdPhd72qSoA4X8C5mZ8nv0wwg43exyj0Yot0TEv1Nd7p
X-Google-Smtp-Source: APXvYqznRUiBa3bFX/4JYauFqEBSC85Xl+P5XGaevounsO8S4ZvgF/liKyMOEA978Y00gbDYLt922aQRf2bIh5Qsy+c=
X-Received: by 2002:a6b:4404:: with SMTP id r4mr22106756ioa.159.1567564678298;
 Tue, 03 Sep 2019 19:37:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muznTsxD2BsyPBX8jfRP5SngyAYf-GFX-tEY+-1DfdMSg@mail.gmail.com>
In-Reply-To: <CAH2r5muznTsxD2BsyPBX8jfRP5SngyAYf-GFX-tEY+-1DfdMSg@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 4 Sep 2019 12:37:44 +1000
Message-ID: <CAN05THTAvysJEiXp3mXaxTSzZOyRSd3y22Pw2MMJe8gQXdwZhQ@mail.gmail.com>
Subject: Re: [PATCH][SMB3] Allow skipping signing verification for perf
 sensitive use cases
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Change
bool ignore_signature;
to
bool ignore_signature:1;

And shouldn't this be part of CIFS_MOUNT_MASK too ?


On Wed, Sep 4, 2019 at 12:25 PM Steve French <smfrench@gmail.com> wrote:
>
> Add new mount option "signloosely" which enables signing but skips the
> sometimes expensive signing checks in the responses (signatures are
> calculated and sent correctly in the SMB2/SMB3 requests even with this
> mount option but skipped in the responses).  Although weaker for security
> (and also data integrity in case a packet were corrupted), this can provide
> enough of a performance benefit (calculating the signature to verify a
> packet can be expensive especially for large packets) to be useful in
> some cases.
>
>
> --
> Thanks,
>
> Steve
