Return-Path: <SRS0=c2dJ=YS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A79A4CA9EA0
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Oct 2019 23:11:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 738E421D81
	for <linux-cifs@archiver.kernel.org>; Fri, 25 Oct 2019 23:11:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="erludULF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfJYXLR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 25 Oct 2019 19:11:17 -0400
Received: from mail-io1-f41.google.com ([209.85.166.41]:41174 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbfJYXLQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 25 Oct 2019 19:11:16 -0400
Received: by mail-io1-f41.google.com with SMTP id r144so4224050iod.8
        for <linux-cifs@vger.kernel.org>; Fri, 25 Oct 2019 16:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=KnTcDYXXpjD1yT/jmxvjd7eJGJ/Z3tvsfbSmVkRY5Ow=;
        b=erludULFYm52mTunga5JjNwZokQpEPCNDoitswqWcpKbYQhb/pofwnDPmng1Ft4ebX
         Kzx04KM8xwnR6H0U1TcUWpStSg2h5LCUgU1aWm00NP2TtAjhcs72Fw5EhR9lz9XAvCr/
         p/jAnXnExfaFmFrTZMbhltl2NwUQ7I5MFkaXGLzftDIcJ5rNnj43PjD6JOlv29C/OIS3
         YfDsYn9MOHe01mpnRvX5cNuqo0HGXDmBWu1/dn/Ipkprdh651IxZfwfPLUiW1ALz1Kug
         ylY4HU++LSSAJPEKKWIkifvHi1EyNYiOX6JhIW1CKHHduWGC2B7s5wrNmaOrWnNGgzIZ
         erCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=KnTcDYXXpjD1yT/jmxvjd7eJGJ/Z3tvsfbSmVkRY5Ow=;
        b=BVr66dcT4xEJ/z7iY3K3KsV/7bHH9VjYYjAM/EXuV6JzHUohRPWjpcH8ZB5D+pywja
         9VNxyAqwVxpbS4b85QRNV1k9beBHsBlmhbm3zCtBoeIq2KwH1HC/m1rrUE0C62ft2ABM
         MiSYX2DoRt3PS+QD5U84ykSDJnjwlYJHLkOioJQt/lgORBYHouX6EnP3VFN2vQ3FcfjP
         SKzbe+JohvNzEMKsMC+xd7zCZxBsqme6R1Mke2kkhC0sywUOcv4FD55f218csfdkfdAP
         zuhvZQ0zoZSk/RmL4MwJEqm++L25n1D6TCxSZzY8g0Rm96u6cvF+vMzuK+Frs8siqh1L
         Eqwg==
X-Gm-Message-State: APjAAAWj/VBQhbZrqRTj8K76h7Ep/t6vES72QUr0s6fNCpDdXf+eB7Sm
        imGBpCxcCwOdWQKvzbG/pwMw25H5uPKXBI8IIPtn+jZ59Z0=
X-Google-Smtp-Source: APXvYqy2tPYfJAAKChjcCf9KLbf8TzAoWfkVhCTosOzT0UCu1gS/5yjq6qVJzFH10tmUXh2f/8Z4VG5BLvR5HGzRm8o=
X-Received: by 2002:a5e:9b13:: with SMTP id j19mr6464444iok.169.1572045074169;
 Fri, 25 Oct 2019 16:11:14 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 25 Oct 2019 18:11:03 -0500
Message-ID: <CAH2r5msVwUK7Hw3H=gE0QzuQTAtxLzAECn3PK2vUDTQnu0mb-g@mail.gmail.com>
Subject: list of cifs patches to be sent upstream for next rc
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I planned to send these seven cifs/smb3 patches (current for-next)
upstream for next RC.  The cifs-testing (and Windows and Azure) test
group passed with them
(http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/272)

d46b0da7a33d (HEAD -> for-next, origin/for-next) cifs: Fix
cifsInodeInfo lock_sem deadlock when reconnect occurs
1a67c4159657 CIFS: Fix use after free of file info structures
abe57073d08c CIFS: Fix retry mid list corruption on reconnects
783bf7b8b641 cifs: Fix missed free operations
03d9a9fe3f3a CIFS: avoid using MID 0xFFFF
553292a6342b cifs: clarify comment about timestamp granularity for old servers
d532cc7efdfd cifs: Handle -EINPROGRESS only when noblockcnt is set

Let me know if any objections

-- 
Thanks,

Steve
