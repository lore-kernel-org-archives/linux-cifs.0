Return-Path: <SRS0=5TF8=26=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B2CC282DD
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jan 2020 00:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BC14206ED
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jan 2020 00:34:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cXUoRpj8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgAIAek (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 8 Jan 2020 19:34:40 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44910 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbgAIAek (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 8 Jan 2020 19:34:40 -0500
Received: by mail-lj1-f194.google.com with SMTP id u71so5222432lje.11
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jan 2020 16:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7rzMaTh66FkaYqt380FhGOk9tcwct7H9UTiMLKaM11g=;
        b=cXUoRpj8jUYqv0eu+ftoEwAMTPltS4NVSmA0IYZoQY0RnSVhXRv317/esnDBv3dFhW
         V0BhYTSvT+4wQ+0JAo2Wf9k1EnutnEUzUE04OSRzqFjQywGa0WImc1PdMoFMN8fxJ3Vd
         a6EmekF974dn3nDSXzgatHrttMKjDWJPnh1ja54l50T0+Wn+BGPUvO0YeY9xpyqWeAqj
         mUqSZkhNK9ThaaXVFGDeijyiVnLaT0Kb4GhadHlW65vFtStHBqiOWN3TUFV/ki+K4HL0
         S+TjLvuYMHL++e2+LE6U75zWie1c2xD/lePvoSkwBeYc2XcVPuoWuogNN8twkckRAzKp
         65TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7rzMaTh66FkaYqt380FhGOk9tcwct7H9UTiMLKaM11g=;
        b=jM6FJhHlLQQWEzdd8XL1cF8P1xgEy47ApqTqLpPQz4c2BrFX2R4ThuT4cOGxxbsj/v
         XNv6OVp5HdlxIlWDExsofcWDiQz+A4O3hjvERqQUyAQpx64d0FbIdQBbHUobH+HwPD41
         NADo7JGteYVZ9B/RSguQIeQoyM4/EKABEIkGpX48gBg2ADw/PMA4RgGBxFcPRzYTDKC1
         NFr1Gn8B1FVwaasXvZzh6ohDJ77pkAOkPqTswWGB0+HODXYLsPE1fFQOceVpwSGACJI+
         8yHm38N3TtcxaLAgyiymeoN/r/7WJSVFXFrChicyP5KS+3ykWWmzKv+dtmw5LdJpObVQ
         qcxA==
X-Gm-Message-State: APjAAAWYydb7qqaz3OEk9CthH2DBKHih4Dnd6q4rAbH8RGvxVMEYYnJD
        Kb7ncnwq/LAOvS9mq6nKiA5uHZTSZgmHewM5IvYkmQg=
X-Google-Smtp-Source: APXvYqwA29squZNyaiGOKPhI0brxuEs5x+gJDmhisANfIXaNUfi3T0BoM95Q8e1Cslpgc4NbI+F4L6e5Q24TM5J1gxo=
X-Received: by 2002:a2e:9692:: with SMTP id q18mr4471650lji.177.1578530078779;
 Wed, 08 Jan 2020 16:34:38 -0800 (PST)
MIME-Version: 1.0
References: <20200108030807.2460-1-lsahlber@redhat.com>
In-Reply-To: <20200108030807.2460-1-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 8 Jan 2020 16:34:27 -0800
Message-ID: <CAKywueRmjCYPGnZvVbM01Pc1kibKZQKit4mPfsE8ou+t=wOGXw@mail.gmail.com>
Subject: Re: [PATCH 0/4] cifs: optimize opendir and save one roundtrip
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=82, 7 =D1=8F=D0=BD=D0=B2. 2020 =D0=B3. =D0=B2 19:08, Ronnie Sahlb=
erg <lsahlber@redhat.com>:

>
> Pavel, Steve
>
> Please find an updated version of these patches.
> It addresses Pavels concerns and adds an extra patch to set maxbufsize
> correctly for two other functions that were found during review.


Looks good overall, thanks!

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

Do we need a stable tag on the last patch?

--
Best regards,
Pavel Shilovsky
