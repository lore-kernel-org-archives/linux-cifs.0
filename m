Return-Path: <SRS0=O53D=RY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94EA1C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Mar 2019 12:26:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62C31218D8
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Mar 2019 12:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbfCUM0J (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Mar 2019 08:26:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42865 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728013AbfCUM0I (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Mar 2019 08:26:08 -0400
Received: from mail-ot1-f69.google.com ([209.85.210.69])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <andreas.hasenack@canonical.com>)
        id 1h6wlq-00038y-Sz
        for linux-cifs@vger.kernel.org; Thu, 21 Mar 2019 12:26:07 +0000
Received: by mail-ot1-f69.google.com with SMTP id x8so2945286otg.17
        for <linux-cifs@vger.kernel.org>; Thu, 21 Mar 2019 05:26:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ws2Psd/8zuzwO7kWeYJ/C3YcGh12RxBZQuK6sc6RFo8=;
        b=mTqBzk0QsoWg9cuf8RQvNc0JXiYDWzHH0LY0cWZev6cpn5Zu2wp/ks4DHUkjuqIGbE
         CSeixzZWnIHiwf6eip53LNbjL4JGQ4Ic54WdluvO/sjSOy1TEmoXJzHL/XjkojaZp5IU
         VYjzEI4QbUQXpWEtNRGb2rPPSodDbvI2iI9bw1OTXV+fHI2lvLmy8L9APiM/QIXQ3dFm
         8b8CZrbsaLNvVcNVfFxs1mGCSI+8+unWLuc4Rpzl+Dm2/pvRtePlW5C6Xfjxubxomd/T
         DReAKPUTgrnlAUpSVf/5dilZpkaegEYpos9HmFXcwHOgBEODx/sL6PH0OyhyN32F6g+g
         xUCg==
X-Gm-Message-State: APjAAAVKMLMOc727jKNMzt47gEWRAC15gpDcJd33r2U6VQpNEyrQZZaQ
        qZQrD3aMACjOT1Ls4s6kG5I550xgxlR3NdyqkhCsAc7+MFMHxYyK6GSBjuvUDmTmUxryBDWOYGl
        9/wRyO21MjWv2lwz0x1ufJ0xLYskBs0KJjZq5EjzDBj7iLxX+6Sg0nV4=
X-Received: by 2002:aca:3885:: with SMTP id f127mr1881110oia.96.1553171165873;
        Thu, 21 Mar 2019 05:26:05 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwY8LqYbArBtidwCZG0b4Z4MtumMN+XSolEZVt8xCXXVnO8yM6sVBCWKqQxQr4JO0/4+GeA6U9Avv2ZGuKhc2s=
X-Received: by 2002:aca:3885:: with SMTP id f127mr1881102oia.96.1553171165651;
 Thu, 21 Mar 2019 05:26:05 -0700 (PDT)
MIME-Version: 1.0
References: <CANYNYEFJos5tzAyN7kdHKaAVeV_cD8QF8=wAs4XXhu9PXWgE3A@mail.gmail.com>
 <CAN05THQb3-p=XX=WpCxv1zfP4e3sBLMY54bg+n=wy9HQCOiJiw@mail.gmail.com>
In-Reply-To: <CAN05THQb3-p=XX=WpCxv1zfP4e3sBLMY54bg+n=wy9HQCOiJiw@mail.gmail.com>
From:   Andreas Hasenack <andreas@canonical.com>
Date:   Thu, 21 Mar 2019 09:25:54 -0300
Message-ID: <CANYNYEH3qVQA_05H-FeJdRgQe81O8gaULXuCGz42e_nKVgMnkg@mail.gmail.com>
Subject: Re: "Bad SMB2 signature for message" with kernel 5.0.0, works with 4.19.0
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Ronnie,

On Thu, Mar 21, 2019 at 2:03 AM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> Hi Andreas.
> I have reproduced the issue and sent a patch to the list.
> It should show up shortly with the title "cifs: allow guest mounts to
> work for smb3.11"
>
> Can you try that patch and verify that it fixes the issue?

Thanks for this, I will try it and report back.
