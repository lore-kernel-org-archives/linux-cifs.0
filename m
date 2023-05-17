Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF6E5C7EE22
	for <linux-cifs@archiver.kernel.org>; Wed, 17 May 2023 23:48:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbjEQXs2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 May 2023 19:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjEQXs2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 May 2023 19:48:28 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297DC171F
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 16:48:27 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4f122ff663eso1588841e87.2
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 16:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684367305; x=1686959305;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HqIeDXs/uBIIxxH+qOZtSPprrWbaIl+L9zVQFhOIvh8=;
        b=gC52qANOtlsRCKuCl6CrgXpPJx5vD/kjHv2uudMqfHo9dJ2wXAJMSlYNaASfIJvIL0
         G47iKJZR6lihjSHEgsdm7kWZzaxBKXJjYBElcoJQBdnhL+FB/D0JkmG1pAPHYWYHt/8S
         5tfxUM/qgXFAdqxEpys6V5+lZciSKpVcEtzj5berjEYdMzvawhNDJGFa76+bD24LPYsK
         E0p3saqqw3umSioluEO5PniMoMA+ZqXsCV9tkXk5ifeiIPNUvcVEj++31Vm7BCvkktIG
         T5hkv0fLcrRlwPIVUK/7m0BNirWSRiSrS1OsWIJMXw+dDt3UmFq6PLkc47n9sBk0KuGB
         UNag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684367305; x=1686959305;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HqIeDXs/uBIIxxH+qOZtSPprrWbaIl+L9zVQFhOIvh8=;
        b=h9B9rxjpUwP2JR6uw4oMX8ZCNsVhkF2DPBI68NB2vd4RpSqWgdGfeqBCigwmMOBVqe
         egGDNC1vVPP3pkBPUdsd5GffBq0LIUUCjli85iS/UxExPL0mGZKXkzPOxzr6FAwmKAht
         uuW6hGP+TbwjW0uMAS52Wnv/0uxGs8HIZguMcds5Ta3VbdrFCM0L69NcD1+PlrI0PQ19
         gkFqTPQlfo6VY4nClky8mGCFSen6FpyQrRCk3U5ercCUTCMyht6gbGci/CR98noqbr3U
         I2GV5zUDq0AxDufJ4rNQk0bK73iMeqYXOth0I5dsduGx2mmwY4DpQVOD1oNcVXZQQRNF
         Jq5w==
X-Gm-Message-State: AC+VfDznFE8SYdbIja+scAObct3rxhRbiSLSx6U8VegvEdcMj3Nz+YPu
        fMW9dtvNlJxUR37dwtMTeJxokOw8JR9uwrd/D91P7M+mRJW9ig==
X-Google-Smtp-Source: ACHHUZ7aYn9WF9pnfcTOamk1w5amgbJbgoRv1fp8WvQhAYZKylWPgNfdtjLAfDCIkexYAKCmoynEFdz6LEEmXkvv13w=
X-Received: by 2002:ac2:5464:0:b0:4eb:5232:5397 with SMTP id
 e4-20020ac25464000000b004eb52325397mr660474lfn.21.1684367304708; Wed, 17 May
 2023 16:48:24 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mt=+=Xh+aNdfcFgB-yQuU_6NkUExpkYh5M4a9Axk4V9eQ@mail.gmail.com>
In-Reply-To: <CAH2r5mt=+=Xh+aNdfcFgB-yQuU_6NkUExpkYh5M4a9Axk4V9eQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 17 May 2023 18:48:13 -0500
Message-ID: <CAH2r5ms__suipEpVK3ffQui_4XhJkQvkiuhn-zYkPV4SSYB7-A@mail.gmail.com>
Subject: Re: Linux client test automation improvements
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

And added almost 10 tests to this multichannel test group:

http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/1/=
builds/29

(test run is against current for-next branch for cifs-2.6.git, ie
6.4-rc2 + 2 deferred close related patches)

On Wed, May 17, 2023 at 3:56=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> Migration of our Linux SMB3.1.1 client test automation (cifs.ko) to
> the new host is showing progress, I have added additional tests, and
> the tests run slightly faster overall.  Here is an example of a recent
> run:
>
> http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/=
7/builds/11
>
> With another test group (Azure multichannel) I did see a few
> intermittent test failures although those may be related to the test
> system or network not cifs.ko (see
> http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/=
1/builds/28
> e.g.), still investigating those.
>
> I will be rerunning the ksmbd and samba and samba POSIX test groups
> today with the new setup (adding the additional tests which now work
> with cifs.ko) and then finish by adding the main test group (which
> crosses many server types)
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
