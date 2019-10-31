Return-Path: <SRS0=po33=YY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3388CCA9ECB
	for <linux-cifs@archiver.kernel.org>; Thu, 31 Oct 2019 22:38:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04F3C20873
	for <linux-cifs@archiver.kernel.org>; Thu, 31 Oct 2019 22:38:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NEZIVVJc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbfJaWi6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 31 Oct 2019 18:38:58 -0400
Received: from mail-lf1-f54.google.com ([209.85.167.54]:36939 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbfJaWi6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 31 Oct 2019 18:38:58 -0400
Received: by mail-lf1-f54.google.com with SMTP id b20so5917340lfp.4
        for <linux-cifs@vger.kernel.org>; Thu, 31 Oct 2019 15:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DMsu+pzAlqXLFqCFHczAJnKB7kERRvXtZgg7glElDEE=;
        b=NEZIVVJcOEyp+FmstITkLUPvzz9/amNUR4Eb+sTJTAU/6h9jcva0x8v7wuRfSzwIjh
         29vRZFNvd0kagZ92Uca7GefZgSX536LI4zoGenuOWd/hcg39WfrKhc0JHhXrjr567IHm
         YEaPttYRkiBUrhjmF9WmZ5egmPrFiJHSR1a+NbqaKAZ0L8bIRhTdLz/WPfgIyQ7C0l16
         heKNRoTCVJl/173+aJbBzTFMiBMDd8wvyVp/t45BKJsOADZWKMJWMEsP8c0vUd4xp/RM
         nRaVFIAVN5T1R7ZX0889H3ArewCkluBM1BkK+Wa0y7Wz09GXDQp9Lo0O9DlrdJaEVzL5
         NKeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DMsu+pzAlqXLFqCFHczAJnKB7kERRvXtZgg7glElDEE=;
        b=sZp45n6XRIrGQqpov5lCAgkVur0eBwrIv48i9D7GXV2IGYT8n2mqfCLZz4UlwgXxa/
         fiQ5sYj+HCMsRT+LtlmU7+7hCRf32wrrZNrI+NA5MQJWBfCsBFcwH1E9u/7F2Ifi//FF
         dc9wuKAToXxefKnzNRkeUmBPtiuphtgSDW/lEUAMDSQrPKRzSbCmzrdRcorLji70v/4q
         ZyaakrKGvp6UhLZJAcX9lx0ykxQTjQAvs68LJIQCdKDxOaKvX/ZPCfPtJvP2kfdTbeSB
         XZqH0HBzspr0dz1NfFEYaygZSTLPf3OZZamG4YNyWUkfyRpcJ5z9T5y3dYIg79h8/gGk
         P/Fg==
X-Gm-Message-State: APjAAAVdu6BezfusSbRT94z4gX7PYWp+AQCQCYN5VUUfrm/TVqbqTWOY
        J4HIyQFFIJzCDaOtZ/g4jgXruxamT1cd5ZmgE9YA
X-Google-Smtp-Source: APXvYqzKd9r93QAg17E/2JmGkVuAU91vw06mrBRJQpRUyQNpII1YFdInRFvW6WXcUMJ9fmuyojM+54xE988qdA6WcEs=
X-Received: by 2002:ac2:5bc2:: with SMTP id u2mr5097690lfn.173.1572561536258;
 Thu, 31 Oct 2019 15:38:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muCW3ow-9UkdtBK9sxRrgK92MjVQZfe6W+DS0XKYVRF9Q@mail.gmail.com>
In-Reply-To: <CAH2r5muCW3ow-9UkdtBK9sxRrgK92MjVQZfe6W+DS0XKYVRF9Q@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 31 Oct 2019 15:38:45 -0700
Message-ID: <CAKywueRROHSqc+tiggojNabwqOtfcvvTfMPbT6bmS4r9WDEZXw@mail.gmail.com>
Subject: Re: SMB3 Buildbot regression tests added
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

cifs-testing group has 109 but not 091. Let's try to keep  the Azure
bucket as a quick subset of tests that we have in cifs-testing one.

Best regards,
Pavel Shilovskiy

=D1=87=D1=82, 31 =D0=BE=D0=BA=D1=82. 2019 =D0=B3. =D0=B2 13:19, Steve Frenc=
h via samba-technical
<samba-technical@lists.samba.org>:
>
> Added xfstests 091 and 109 to the (SMB3 Linux kernel client) Azure target=
 bucket
>
> --
> Thanks,
>
> Steve
>
