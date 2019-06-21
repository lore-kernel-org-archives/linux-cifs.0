Return-Path: <SRS0=xi1p=UU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ECA1C43613
	for <linux-cifs@archiver.kernel.org>; Fri, 21 Jun 2019 22:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E9992070B
	for <linux-cifs@archiver.kernel.org>; Fri, 21 Jun 2019 22:13:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CiD4j/Ja"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbfFUWNn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 21 Jun 2019 18:13:43 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:45680 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfFUWNn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 21 Jun 2019 18:13:43 -0400
Received: by mail-pf1-f176.google.com with SMTP id r1so4247705pfq.12
        for <linux-cifs@vger.kernel.org>; Fri, 21 Jun 2019 15:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=ZwSHbv/THAdwiXhmKHyA3vsk/LOzmghk7EjuNn7MHz8=;
        b=CiD4j/JaWgqAwQpPOEcajSZGunP2GgCSOjq0Hyf6miBgbMHDcINXsAV15jabPqiu8T
         XlDHK4yX4YiYshROh2QJzdJR3oMNvS2fCSeaWzJB7Baoz7Xya9sDzUDfINxOsFw4YNoq
         5nQCUgV4adS0uQ0gY3OlfBfGSBqLrdO9feiY/AeosYZ4dp3HvZkQcHWrgUuUS1LepcSL
         bwNq25ea/sPeNu7HO0bam1sc9ff49rLf+UhA9HZ8h6HPCf9Ii+EMtBDFRUv76oqUv9Ip
         CHwqSY4iseKmJXN9clmUMQZN2z2upTqTQdxqd64sLuDGwoQI5YLVK/7XUq9AQbDK9Vgz
         PoMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ZwSHbv/THAdwiXhmKHyA3vsk/LOzmghk7EjuNn7MHz8=;
        b=q0ZwOat9tNm1xBFghXup0H6qvYnyrgBOnL+tUMHO9Xj0zYQxO93gEWo3Q7awjbp8Oi
         PAAJWmdBduoWHcgoWzyCIQCULKgl64rvTik8fTtPXCJ4CR2x7cJH/cfLXbCr+cMQR27f
         HRhuY7DI+6TjkJeX+KAvHzKTY0gKxuOVM3tRuKFw6OZyOVUFnktKS7oNLViafat1aoX0
         3jXtI0LMDtlWbHRog0crZuaB+y/U2jYJlUcJVCR5AA6Wv584PbXf2bhRMXAkrJjeg30I
         I2+5j05oZzXikVlbjQo6pANRpifTl7DRfO2KF+4R0WrhPGf+q4zoEPBJSkumDsQr6aWd
         8UCQ==
X-Gm-Message-State: APjAAAUgjxlZw12L2LW4hKvjlJj5Mufb6Z+jvQbCA+VkHuHUrPSHJ2dD
        fO2lcieWPGylgHJ9UgwWzedHqjnhIMJBSz/VtMhCsA==
X-Google-Smtp-Source: APXvYqwFByfIj1cJoZKAgrqphyapSlUpC/falTH/0HAqyYO30ApSwRepjsSZytYJShmuJq3UBaxECkAIxR94Ud8KWRQ=
X-Received: by 2002:a17:90a:fa07:: with SMTP id cm7mr9159368pjb.138.1561155222397;
 Fri, 21 Jun 2019 15:13:42 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 21 Jun 2019 17:13:31 -0500
Message-ID: <CAH2r5mujbX5Ngo+wQvVgMmJWEmqkZ3EXVyXBPgqV3ZAbioPtjA@mail.gmail.com>
Subject: git trees (cifs-2.6.git for-next) and github tree updated
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Updated with current linus tree (rc5+ and 8 cifs/smb3 fixes in for-next)

-- 
Thanks,

Steve
