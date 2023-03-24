Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D531DC7619A
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Mar 2023 00:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbjCXAYd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Mar 2023 20:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbjCXAYb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Mar 2023 20:24:31 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4522F05E
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 17:24:14 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id eh3so1649869edb.11
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 17:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679617450;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=p1ulscs7oHKGvLbhngHcxrLtguKvoY65NPrHd+gZYkY=;
        b=Dsh2yyyG9JnvmiO6YEjkMPAnlvdRKSA4LxApDx/kIvbin30kCxBth4rQsAtIRchJKQ
         iy55/Rn3TLgVAOglnyA9VvWz1Lewywmx3/q40qtxoNkZj48KVJFGtgJufWQLjrqfePbl
         h+QR1jjJ3+RdDtaqz/kD1qfm2xoE9K0ImT5tEa/u1lwa7qGiOQH4P61+DAUK30aWuZW9
         JHy+xL0M6wecAaKNvVdt7LHOo4P9/+X4VETSSLpaMWfTGtDcTApPs/Ar96uXRjO/+veE
         nedtJcas5VpvExBRFGcivocjkMDNLcBBorEwLNrhaK2582tNFqY+utSrTHKwvB3JWjc0
         XaVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679617450;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p1ulscs7oHKGvLbhngHcxrLtguKvoY65NPrHd+gZYkY=;
        b=cUXLv3zusoEeNqAbIorDRP1vObgB8HGsvchKJEhIS2GptrfQpIW+6TYRMDg/O89BkZ
         ASZK6wTvGgOTp5PU5r+y1o7NkhDyRMW0QK5gAKmB/harADNkfX7xXTIKNupQkIdkOucQ
         2hmjxYQDza+k9li6rw0qydi4oZBod9vnTXBPqH8R61bmuyf3+TnTGVoLRfxfVkQB3V2e
         ZTP3GPoWbbaqdZbipmfhhHNicpyrS+lppZXyQT00m1492VB7ssS1GnkS0e2GULT3Zdkq
         zX9yTJvuD1zPEuca8nRq0s0vK2oguwUcqmrgW9Jdv8GyyeLM2Sm/X+18yOaLYfnudXCJ
         FFhg==
X-Gm-Message-State: AAQBX9dcprdoXi0S9RAzLZX4OmyKA3VYMk7N85M5+iCOoeCReMACL9+H
        9WOkgSBw0XyyQ+ORKJs8TWcLNbmTMHThsbWP8+J4pl/fM0XW+g==
X-Google-Smtp-Source: AKy350Z2+FACEho97tQcc/KVXqSs5MtNf5GLaVzM5bzF0jwZ7nGzHfS7X37ndKqh5y8QY9v4CTTb8wxysiz8poWc2pQ=
X-Received: by 2002:a50:a6d1:0:b0:4fa:da46:6f1c with SMTP id
 f17-20020a50a6d1000000b004fada466f1cmr632487edc.2.1679617450418; Thu, 23 Mar
 2023 17:24:10 -0700 (PDT)
MIME-Version: 1.0
From:   Charlie Oehlrich <charlieloehlrich@gmail.com>
Date:   Fri, 24 Mar 2023 13:23:59 +1300
Message-ID: <CABebRoYBLuv-EVMGE+eWJ_Ka6J_dYFduNFSxnFOQ0q13FVaC9w@mail.gmail.com>
Subject: Cannot list files in a directory with New Nintendo 3DS MicroSD
 Management twice in a single session
To:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

After mounting a New Nintendo 3DS using the 3DS=E2=80=99s MicroSD Managemen=
t
after going to the directory where it is mounted I can only run the ls
command once before the ls command starts erroring.

I had narrowed the issue down to the New Nintendo 3DS (which uses
version 1 of the SMB protocol) not supporting the
=E2=80=9CSMB_FIND_FILE_DIRECTORY_INFO=E2=80=9D information level code in SM=
B1 (instead
returning the not implemented error) while supporting all of the other
find information level codes 0x0102 and 0x0104 to 0x0106 apart from
supporting FileIds (Not sure about 0x0103 since I could only get it to
return a not found error when using 0x0103) and the default
information level code used in Linux being
=E2=80=9CSMB_FIND_FILE_DIRECTORY_INFO=E2=80=9D when the server is detected =
to not
properly support FileIds.

Tried on 5.15.90.1-microsoft-standard-WSL2 (wsl2) and
5.15.0-1045-azure (hyper-v virtual machine).
Mount.cifs version on both is 6.14.
