Return-Path: <SRS0=OUxG=UX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B85C43613
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jun 2019 19:07:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEF3E20663
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Jun 2019 19:07:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LVew9pMa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbfFXTHJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Jun 2019 15:07:09 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34124 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbfFXTHJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 24 Jun 2019 15:07:09 -0400
Received: by mail-lf1-f66.google.com with SMTP id y198so10867816lfa.1
        for <linux-cifs@vger.kernel.org>; Mon, 24 Jun 2019 12:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rJia6rsurMt3iChC0Zc+7fFHTzWy8U6qXnydOeaoTyo=;
        b=LVew9pMa6coXyzv1A6fkEuhA5QYIdV/BeOo6yY3HFk40GVrt1fESrk2+tOoJaRbyzk
         Zx7kazqtRapliP8n2Sq5641wUI7VDcZaHoEdPQZYO46wysqDI3FahkVDYS9mAdEbJ5TS
         Av0fs4tZLD5cz+C+iODRLTUMrxIHO7692a+6zIDp1Y1LP55JNwBHSf/41bOJAGtWyf4/
         zkHMhlD6k/ck1mNRc+XGEo1ctjUZRbCo+OtiM3Tucd43lTo6VptjfHLeUlFXx9KrGatH
         DUsC/VqEL9+tibNhETCTH+VWnVyaBjc00PI3URP5FypfcHEHmueg13jvzd3jfGnI2F+A
         ybtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rJia6rsurMt3iChC0Zc+7fFHTzWy8U6qXnydOeaoTyo=;
        b=SZORFjs9BfAeS3RPsOm71tRisa8A7DBQ9FglH91R6Gg3hfhPXi75Qq6ell9LVHWVr6
         RAQgVbXaWNVnOoXh4W56zziwDV2OWxkq51IqTlkTBEUC2mL6X8Br4obHLNw4LDJeqEy4
         QirVoy3o2F1ohP0xiKBPmjCkV5JXueBWt4y3cUUdvEpKkrWtYllBEZrMrLwK1myBJciO
         KB/AcFYwm26FrCLKB+Sx4tfiEmY0ycmTpxuSJr00fOY9NHENHgYR32fb/Hh8jM/Ocz3u
         OG+CYfzAYGlYhMQwQD2/7NuAMlnsNUXGN5PLbVqNOTl1HjclonRdaUPXaoDvGDQhe5r7
         D4bg==
X-Gm-Message-State: APjAAAW9nF/eE1/6HEFpZtusb2KJPJs42Hdg096e7HRSCCfXW34o/Iw+
        zs5Sa9yD/XyNyFccAhxz4uSkKbjYEiT0bTZ8Uw==
X-Google-Smtp-Source: APXvYqzvAx2Q9wBIwfU2JNIu68rzbXHusoHaqBVDCasimzxNOVspIvy5emGSm36+QpRNlS3saztcltt1t9dw0nZZPIs=
X-Received: by 2002:a19:7110:: with SMTP id m16mr77013843lfc.4.1561403227288;
 Mon, 24 Jun 2019 12:07:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvN2LQG_eWhfes3_tpBwhmg-Q=+L7U+=xFHb4W01_wVJg@mail.gmail.com>
In-Reply-To: <CAH2r5mvN2LQG_eWhfes3_tpBwhmg-Q=+L7U+=xFHb4W01_wVJg@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 24 Jun 2019 12:06:56 -0700
Message-ID: <CAKywueR8h1ipuWQYZAph729O9f05tUEC2+kzf9RwKTyWgqtV_Q@mail.gmail.com>
Subject: Re: [SMB3][PATCH] add mount option to allow retrieving POSIX mode
 from special ACE
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Can't we use the existing idfromsid for this purpose? We already have
a plenty of mount options and the list keeps growing.

--
Best regards,
Pavel Shilovsky

=D0=BF=D0=BD, 24 =D0=B8=D1=8E=D0=BD. 2019 =D0=B3. =D0=B2 00:20, Steve Frenc=
h <smfrench@gmail.com>:
>
> See e.g. https://docs.microsoft.com/en-us/previous-versions/windows/it-pr=
o/windows-server-2008-R2-and-2008/hh509017(v=3Dws.10)
>
> where it describes use of an ACE with special SID S-1-5-88-3 to store the=
 mode.
>
> Followon patches will add the support for chmod and query_info (stat)
>
>
>
> --
> Thanks,
>
> Steve
