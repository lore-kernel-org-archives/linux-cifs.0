Return-Path: <SRS0=o2U4=56=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2695C2BA2B
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Apr 2020 01:13:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AF1B206B6
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Apr 2020 01:13:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fmR7HTlF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728694AbgDNBNr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 Apr 2020 21:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728066AbgDNBNr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 13 Apr 2020 21:13:47 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66000C0A3BDC;
        Mon, 13 Apr 2020 18:13:45 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id g6so6273981ybh.12;
        Mon, 13 Apr 2020 18:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2sFM4m+/5d21PqXw6kWTfIsYI0G/LoNNZv0ieGfL4mY=;
        b=fmR7HTlFN8bGdgVEuVFhcrWDbj6/YppDbyyN1mukit2yis/44I+arnJOqNlnimdoNM
         ldNi1L6NHj9Mc93EwF76K3W3Fw/R1It1LhVbLGjAupuzpwhjFdzknMpjOB6713LOHl2/
         HcAuhVo57ujEqqMjbM3CSmBvX+8DAMjlQbEIkL6iMf3EiDXINCqLyv76wzM5hPYsLhhC
         rJepqxkg9AjLLcRLKRycDDh5sks4o7r9liuYZlvRIR7KCoGAnS8M3YBuUQsKxzbkjl6G
         885j+DnhsY3coLPx27US9GZlz35DY4FbvfO54ht1IYJL9Zp/WgfqQ8D6lLaPlH1gjXod
         wgHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2sFM4m+/5d21PqXw6kWTfIsYI0G/LoNNZv0ieGfL4mY=;
        b=ebB1HR+kiOEl2dlJyBBMKLa6TtTOHfcJ1sayAIM9yQ/zdSwyphTFvuWdAHyRxD5eFd
         oAzPCxIDfTNWCaOcDGFEi/WqFiEak/xXnjVO4EudWbPUEf+mbww7zMQrUXsrlQoUwvMt
         9/MHcNGU7ftXNGQtZQ9rMUBQQDyFJxSnwwg+cSwEg9wGhwFprqO9/rqlj8JxzIGGLT0t
         AQsIKGZsUkr4Y/iJIT6FBYsM3BGI35OqCIo4ryFNXV9DjugJtf6A3A/vxsaPAAUzPmx1
         ZD2KCbBha6Ji/8MEMLd3QEWcMuathYaKEiCnpEUuc9AAjd8NTG5gP7zsBkjXq/YgnxWi
         7TCQ==
X-Gm-Message-State: AGi0PuajLSGfTHyFExNw9Gsm/qxHwOAV+lljjT78+P1WFuRugFSRRR8Z
        0h01UYXp0FQVdKldQUWvf6tsrpmuCCbLojvQu7e6d3Fh
X-Google-Smtp-Source: APiQypIRYMTbUeX+KJRP1eOtVtG/KITpkD0lHYLP/DV/y5FEmDRT58Z7li7yhzS//x4ix2pavP/YpuAas7Yhp/BuvNc=
X-Received: by 2002:a5b:443:: with SMTP id s3mr31274381ybp.14.1586826823528;
 Mon, 13 Apr 2020 18:13:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAEUGjKiLPQP9wp0AgLUvHgKBOe9We2a-RQaZ7cd7CvhnarwWiw@mail.gmail.com>
 <CAKywueT0Q9WkANNsg8cEDwGZSMaaE5c4LHuEeMhVDzJAzycroQ@mail.gmail.com>
 <CAEUGjKhSBNQboKOMFMgos9OQfxcLQZsXp8aBrUSFcaSe1saH2Q@mail.gmail.com> <CAKywueTsaRfut9C4qj96Qc5VaeuRKO2WjahS==bz5kAqWB1KNQ@mail.gmail.com>
In-Reply-To: <CAKywueTsaRfut9C4qj96Qc5VaeuRKO2WjahS==bz5kAqWB1KNQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 13 Apr 2020 20:13:32 -0500
Message-ID: <CAH2r5msxaB5tC=09Kz3AoFb2e6x55V_HHWoqpYPAa4-pXhP71g@mail.gmail.com>
Subject: Re: [PATCH] cifs: improve read performance for page size 64KB &
 cache=strict & vers=2.1+
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Jones Syue <jonessyue@qnap.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Samba Technical <samba-technical@lists.samba.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next pending testing

On Mon, Apr 13, 2020 at 11:39 AM Pavel Shilovsky via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> Looks good, thanks!
>
> Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
>
> --
> Best regards,
> Pavel Shilovsky
>
> =D0=B2=D1=81, 12 =D0=B0=D0=BF=D1=80. 2020 =D0=B3. =D0=B2 19:23, Jones Syu=
e <jonessyue@qnap.com>:
> >
> > Hello Pavel
> >
> > Thanks for kindly reviewing!
> > Please find the attached v2.patch.
> >
> > --
> > Regards,
> > Jones Syue | =E8=96=9B=E6=87=B7=E5=AE=97
> > QNAP Systems, Inc.
> >
> >
> > On Sat, Apr 11, 2020 at 2:25 AM Pavel Shilovsky <piastryyy@gmail.com> w=
rote:
> > >
> > > Hi Jones,
> > >
> > > Thanks for the patch!
> > >
> > > It will work although it is probably a little bit cleaner to
> > > initialize server->max_read to server->maxBuf for SMB1 and use the
> > > server->max_read in the readpages condition check instead.
> > >
> > > @Others, thoughts?
> > >
> > > --
> > > Best regards,
> > > Pavel Shilovsky
>


--=20
Thanks,

Steve
