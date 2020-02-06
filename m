Return-Path: <SRS0=edh0=32=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58DE2C33CAC
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Feb 2020 18:17:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30D2E214AF
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Feb 2020 18:17:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XNEWU9fQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgBFSRm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 Feb 2020 13:17:42 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41975 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbgBFSRm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 Feb 2020 13:17:42 -0500
Received: by mail-lf1-f65.google.com with SMTP id m30so4784230lfp.8
        for <linux-cifs@vger.kernel.org>; Thu, 06 Feb 2020 10:17:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8/fyfxU1+Htws/4RotJnl8KPVpoqgcX7lsfsk1YiPk4=;
        b=XNEWU9fQaGpknGhOS4wOtd5H2AgttTAZ+Yw8x1EnF3ZqVxpGpEgQSY0Dt4iBfwOdvm
         9EkJRFrXM5szegbV2PY8SqUkuJywANaay1OekuemO0RGQUx2C0JqvQpSGlValfWCV1wv
         My93TsNI+g40SxSsVKtnP+Ni8vXePSaFt5qXIke+sgz1BvAz7ekL9SA4hr3iY6zMwfBf
         zmFLOWtm/rrivarnn2EjrKaCCIk7eDQ4Msk4HaW6Zs0aDTMzT0iMRNsrQckl4Ad3rS1W
         fQBqGrilkD/BcklAlHg/YDzxgdmFWHvcLPPtSRxF9gO59POGRku20uwApfLey36kExD5
         sVbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8/fyfxU1+Htws/4RotJnl8KPVpoqgcX7lsfsk1YiPk4=;
        b=FQnthdykPEePg5jH5obcVPCxzEenofw1KEaCyejCbwY773YawkmaIB2tChr6raJMUx
         Vx3VjGjFgqjAUalwNGHdQH1ICbtVmkMxN6lKKQFvpxJjZ6zJ+WPSUvID9bMZIhhhoM4y
         DsdJfUWnt2/sXPZCwTYOf6SZ+ZyANncRrtQ7/11vF6qME+qSbnTGzP6VMZ74SclSl6L/
         h5zfNDRSRc4e5TQRVMQnlwO9dKZBlTIftcNoAb3fCPwUKhsO9ZmY29XDz5LniBp6DEBg
         SxnJW3Bd/+eDjOaQjIyIY7ogI470IOPS8PYno4T/RChIAMhTyzea/9o7yoCVUP3d9564
         T9tw==
X-Gm-Message-State: APjAAAXVW+E1mnBT/7DUT+lEpyvLkd+ogSBYKM/DDaw+QqIPDusrAVTe
        owaZjs5ToFmdU/DVi6UEVo/hmVKFYiwczyaUpA==
X-Google-Smtp-Source: APXvYqwHTZYXyJcscWD2ZWLJLySoCA3fbBoARuj6SsrJQS/SiYgkOeAaAknBnFs+dKVH3l4yRvw/ZvR0oGMxO4+J2vo=
X-Received: by 2002:a19:9d5:: with SMTP id 204mr2461049lfj.120.1581013060476;
 Thu, 06 Feb 2020 10:17:40 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mu985seFnTzTLM197oO1K012NjSwYY=ey=xc5PsWfCUsA@mail.gmail.com>
In-Reply-To: <CAH2r5mu985seFnTzTLM197oO1K012NjSwYY=ey=xc5PsWfCUsA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 6 Feb 2020 10:17:29 -0800
Message-ID: <CAKywueRLK1pFgQj5+FRzdxwma5KR=+q43Y-bTuPHRCnYapjeKA@mail.gmail.com>
Subject: Re: [CIFS][PATCH] Add dynamic trace points for flush and fsync
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>, Oleg Kravtsov <oleg@tuxera.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=81=D1=80, 5 =D1=84=D0=B5=D0=B2=D1=80. 2020 =D0=B3. =D0=B2 16:32, Steve =
French <smfrench@gmail.com>:
>
> Makes it easier to debug errors on writeback that happen later,
> and are being returned on flush or fsync
>
> For example:
>   writetest-17829 [002] .... 13583.407859: cifs_flush_err: ino=3D90 rc=3D=
-28

The patch is missing to add a similar tracepoint to cifs_strict_fsync().

--
Best regards,
Pavel Shilovsky
