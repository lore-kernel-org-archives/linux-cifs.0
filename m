Return-Path: <SRS0=EeRJ=6F=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A88E5C2BA19
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Apr 2020 04:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 647652076C
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Apr 2020 04:37:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kh8ar7FW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbgDUEh0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Apr 2020 00:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726018AbgDUEh0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 21 Apr 2020 00:37:26 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7DA8C061A0F
        for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2020 21:37:25 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id i2so6684809ybk.2
        for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2020 21:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ay2dIo1RjLmRFd23j8lK23Ms3Eq62ibz55kMXBO7SZI=;
        b=Kh8ar7FWeJWhwG8ejYDBXRDq7aDfT63Ns6+SoD/v4pg0syoKGevZPQTW3eZovMtpIa
         4pzf8pMl/Lt/cKzYNe7BXMQyXdwZgOJ/g9Ct3u1IuSn5Fd62lj9NcXf4VI0LX+ucrzOW
         AXBjubKcOqZiRtMa5FcG6w1X6ojVWLssemRKd8EVlJ3AVKs9TlQEJkYZRhIo6JwO0xzO
         EupjS49qjIkKCnAOgIrCb8V6g50CpljLbkt7AiWMSb2iEAXsZ5aJV2YEUczd1zOdTiD7
         RLrmyg7irGuonSNYH1M6dWR8tVm6zinG6uAimraCIgExm5MA0RTR3UFqW2m7tlEcjp0d
         mgZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ay2dIo1RjLmRFd23j8lK23Ms3Eq62ibz55kMXBO7SZI=;
        b=o3wjfwns0UPTh4uUemJnZyfnoxtjGQ664v5PwVvNpleh3+tyQSIQ9kMAhapgZmIi5M
         xDxOoPKe9pn769Xqr2imCHbiR/9P4hsf6f10Sgay6tWVJmOZ8T+FkMHGn+6zqHGQvAUC
         WyLZxgC0f40V5fFCsuoVYOz8ST4f2eK5WAHoZdqB0sLa13np56JRPDcXCjcyx2V5aJV1
         7QASBKPE8S79xIIPGBFk/gri39UZ6Af8xKTgQT775KZzdIBNaZUgNdicbLHvhqnnHVcD
         HW8D60Xod8tcdJMBja1dPSHmnk8DwQoY1ZTI42ejretInMQQ1z9nGCgCPQTEt/RZCv4b
         ddmw==
X-Gm-Message-State: AGi0PuYpQRMHl2qiEUCr28EcJlF4nyJdSF1ULu8UWhQTc7Vz5w9XVbg6
        tY44NyLdzMKVKVUCDb/DG1fu3IG0yVaQfa6PgsA=
X-Google-Smtp-Source: APiQypIhcNKTk+6eXDX6ZtaKHrp4iKXdvSMsUzOAJUKosY5LifzoDmLvo+m0TyJqqtyQJvHN0udCvzQltFmif6B/5Qw=
X-Received: by 2002:a25:9b04:: with SMTP id y4mr19762453ybn.91.1587443844787;
 Mon, 20 Apr 2020 21:37:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msSe_j8xyRd7noarQ-9mkiS4WmM+6w1+kLP1gYf+=0avA@mail.gmail.com>
 <1484605579.23547436.1587443624135.JavaMail.zimbra@redhat.com>
In-Reply-To: <1484605579.23547436.1587443624135.JavaMail.zimbra@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 20 Apr 2020 23:37:14 -0500
Message-ID: <CAH2r5ms6BdCMMtkVYXAopc5RwyTcOOESozk-580FQGY6yQ_gAg@mail.gmail.com>
Subject: Re: smbinfo --version
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I can guess the smbinfo version from the mount.cifs -V  (mount.cifs
version) but probably safer to have smbinfo print its version too in
the unlikely possibility that smbinfo and mount.cifs were packaged
differently

On Mon, Apr 20, 2020 at 11:33 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
>
>
>
>
> ----- Original Message -----
> > From: "Steve French" <smfrench@gmail.com>
> > To: "CIFS" <linux-cifs@vger.kernel.org>
> > Sent: Tuesday, 21 April, 2020 2:23:06 PM
> > Subject: smbinfo --version
> >
> > Do we need to add a --version (or -V) option to smbinfo to display the
> > version number (as we do with mount.cifs e.g.)
>
> Would not hurt. As it is a simple python script I expect it to have bursts of contributions and
> features added or changed quite a bit so it would be useful to easily identify the exact version of the script.
>
> >
> > --
> > Thanks,
> >
> > Steve
> >
> >
>


-- 
Thanks,

Steve
