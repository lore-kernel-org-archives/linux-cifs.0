Return-Path: <SRS0=FuFi=55=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECDC6C2BA19
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Apr 2020 16:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C34C1206DA
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Apr 2020 16:37:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gkp8FwXM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731657AbgDMQhx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 Apr 2020 12:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731652AbgDMQhw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 13 Apr 2020 12:37:52 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC58C0A3BDC;
        Mon, 13 Apr 2020 09:37:51 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id r24so9377796ljd.4;
        Mon, 13 Apr 2020 09:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5m0R0HH7xPMq9eV0wmAE5UEDNS7eZKBSnZWMR5kVcDw=;
        b=gkp8FwXMYf5wvGgoKzptwHCycc7Ie2RYdjk6B0M83HhH/7yF6wQOB6lmwLhkWGXPFS
         3jFIkxEWYMSbRYovjFGWQWtFgRMV6GX5T0nttEM9mjdG2UdM5KwlRqDGRex1qy8IJtT8
         AixbzhT0O6by7knmIcP9NQFxzMo0X0V7MQllsWgpwhtfmcdHnBv7QCE6lPAj5DRVVlIh
         +3zUnM30fa2Eqs8pWZ9gRci0tYxna4mZOZtsg8e6spoAOBjuoMlirOgwJNNxUzZqv7Yh
         eTL5eDwfSSFf407pWo1BJ/ENmoQ9Chd/KPOTiG75kDg42ZCgWhSClyp++045164UqYYL
         WFTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5m0R0HH7xPMq9eV0wmAE5UEDNS7eZKBSnZWMR5kVcDw=;
        b=EZ14ut4f8CwXPnaGfiacYXtnmNDMX1MYdC78lkL/6CKloB02v8MqD0fr4Nuf0Zr7ct
         /kZA7I6ejLPfK1ms+VpaQ/yKaOrex+Z3Ctw2Kw5hcP5VXAnLFzggHJwSZSQvszB+d+cE
         JxA9Jw7le1hRqs2/7ER4EOtXeE+FeqrdDeyNc1q0N3Q3whQ8Wb3oplmwMeo6/wyqbL1U
         kcMP4amRVVx3+Y3ez5BYsdNcJx5GWHe8KBgVZSbYaxiAUDxvvR8WLMOaVxcSssTVsEvY
         P/aBOhGsWqZIfluHijTacn/G127IkywrgTFUii4JLEJf/wmKvQ2Y+CrV8J1o6VSBXatG
         SenA==
X-Gm-Message-State: AGi0PuauoM7EVIqhK0rNo2F+EmH1pIGPhfIaqgkpsRQuaZhpNzFsQrE4
        GHRIwnHTVAm9ZYLPfVagVAZqMSTvyb7rd9diHg==
X-Google-Smtp-Source: APiQypKwJ7dCuFOX7Y93nrccvrccezhTEhgLknrZUISWmmHboFRRxHEMB6PMFWIu0dTkl7gqf/FfWgTspjJhsV2Eemg=
X-Received: by 2002:a2e:b53b:: with SMTP id z27mr2036328ljm.109.1586795870329;
 Mon, 13 Apr 2020 09:37:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAEUGjKiLPQP9wp0AgLUvHgKBOe9We2a-RQaZ7cd7CvhnarwWiw@mail.gmail.com>
 <CAKywueT0Q9WkANNsg8cEDwGZSMaaE5c4LHuEeMhVDzJAzycroQ@mail.gmail.com> <CAEUGjKhSBNQboKOMFMgos9OQfxcLQZsXp8aBrUSFcaSe1saH2Q@mail.gmail.com>
In-Reply-To: <CAEUGjKhSBNQboKOMFMgos9OQfxcLQZsXp8aBrUSFcaSe1saH2Q@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 13 Apr 2020 09:37:38 -0700
Message-ID: <CAKywueTsaRfut9C4qj96Qc5VaeuRKO2WjahS==bz5kAqWB1KNQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: improve read performance for page size 64KB &
 cache=strict & vers=2.1+
To:     Jones Syue <jonessyue@qnap.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Samba Technical <samba-technical@lists.samba.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good, thanks!

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky

=D0=B2=D1=81, 12 =D0=B0=D0=BF=D1=80. 2020 =D0=B3. =D0=B2 19:23, Jones Syue =
<jonessyue@qnap.com>:
>
> Hello Pavel
>
> Thanks for kindly reviewing!
> Please find the attached v2.patch.
>
> --
> Regards,
> Jones Syue | =E8=96=9B=E6=87=B7=E5=AE=97
> QNAP Systems, Inc.
>
>
> On Sat, Apr 11, 2020 at 2:25 AM Pavel Shilovsky <piastryyy@gmail.com> wro=
te:
> >
> > Hi Jones,
> >
> > Thanks for the patch!
> >
> > It will work although it is probably a little bit cleaner to
> > initialize server->max_read to server->maxBuf for SMB1 and use the
> > server->max_read in the readpages condition check instead.
> >
> > @Others, thoughts?
> >
> > --
> > Best regards,
> > Pavel Shilovsky
