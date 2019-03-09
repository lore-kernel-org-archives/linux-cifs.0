Return-Path: <SRS0=BG3M=RM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1E4CC43381
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Mar 2019 01:06:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FEC520851
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Mar 2019 01:06:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hYjOBKNR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbfCIBGs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 8 Mar 2019 20:06:48 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39002 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbfCIBGs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 8 Mar 2019 20:06:48 -0500
Received: by mail-lj1-f194.google.com with SMTP id g80so18927071ljg.6
        for <linux-cifs@vger.kernel.org>; Fri, 08 Mar 2019 17:06:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SnB+u6mTTTh9bPCnlOTbHzOhtQvs5la/3cYL97wWwiI=;
        b=hYjOBKNRvvfoVeWv/TSWeC0MmI4kb7ktDF59Cn4eqMFLFdVBs5A/Z1S6T8GRTAYmeX
         146QAfQi+uLvdeyDesA+h+f6VIjiXGQotpHL3gSd/q1mp1AV69janA9BHSmdLzLRCEED
         oQ//TVaaGTfx8f6F206WRUfAJiODkNrOSezun/frsrwP1WJD3YBntdoNByWAGhPr1qr2
         Y5yXMmHNgsm3c34DfuZUy+J1lOGRYN6VC4CbZho4alFWiQy3JXFR5MyhSFxJP0uWhEwU
         44ciRlaXP/mUHg3cPQK0/+DTlgNz1QD4N+0mzIRgWy87AC4Ol7ElTxOth/rgEFAyZz48
         QVQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SnB+u6mTTTh9bPCnlOTbHzOhtQvs5la/3cYL97wWwiI=;
        b=XybuDlLsvB8wNB+oqSjakran+bmT/1dJijiN6B3M+qO7AwCxhziYXdSB7/ZNszDeow
         zPW0Wl2vh6yuQMkUq0MVV290ouwEjcbxXG2FtxPCL2+SfT2vnW1mQW4WEkbliQU/CgJd
         dZUl4Q3Bd42+EtNA9WFBgAGzmDWKEIGdfNR89iWr5v9Zk2Gj+UcQ+zUVgpFa0zk8DG3F
         5j0rB0yShvMW03Frm4Q+uAy5aa84RZlRvdfu74vd3fec0m58r/nrrWl5vDEb9Q+xUES1
         Ytg4c4tU6RySbqao72NwtLLESjB3R8vJyyj7RiS6hjFp8Qohpl7i91rb2NniXQL5wyZI
         BXCw==
X-Gm-Message-State: APjAAAU6RL+1NZtgTnvCBQlN4s1CzIvJMfU/bYg8jBOoDxJV2o2Hwwuz
        hXk3Xhvb2mNfnKRBYEdjLLFcqaFu3brC5VOUEHP/tLE=
X-Google-Smtp-Source: APXvYqxpp4Gb3oj5bwuYBPiVPLZdocFAyIAIdzlBx5FmyJfa1zaUI2QvETKKZGKU4bqDhqL+sLpj/bwMVRN/AAlsDgc=
X-Received: by 2002:a2e:3807:: with SMTP id f7mr10621261lja.9.1552093605901;
 Fri, 08 Mar 2019 17:06:45 -0800 (PST)
MIME-Version: 1.0
References: <20190308025823.24382-1-lsahlber@redhat.com> <20190308025823.24382-6-lsahlber@redhat.com>
 <CAKywueRQwi1qxmtO3q9v_sCHB+tQxVY1uba9mi468-y9=18H_w@mail.gmail.com> <CAH2r5ms3METKgX9sMet44r0RKdVAEe_x=vuB_6JZobJn95x4_Q@mail.gmail.com>
In-Reply-To: <CAH2r5ms3METKgX9sMet44r0RKdVAEe_x=vuB_6JZobJn95x4_Q@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 8 Mar 2019 17:06:34 -0800
Message-ID: <CAKywueTb1=Xhpg5_AxQAyEiLenjG4J8KgO8fNPdOWqjKAb30Tg@mail.gmail.com>
Subject: Re: [PATCH 5/6] cifs: add a timeout argument to wait_for_free_credits
To:     Steve French <smfrench@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <pshilov@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D1=82, 8 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 17:03, Steve French=
 <smfrench@gmail.com>:
>
> Any ideas how to simulate the timeout to test the proposed trace points
>

We can use Samba's max credit setting and set it to some small number.

--
Best regards,
Pavel Shilovsky
