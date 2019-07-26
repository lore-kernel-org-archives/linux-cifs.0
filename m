Return-Path: <SRS0=vxna=VX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C087C7618B
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Jul 2019 08:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06EE1216C8
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Jul 2019 08:22:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RHsXV5Tc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725869AbfGZIW0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Jul 2019 04:22:26 -0400
Received: from mail-ed1-f42.google.com ([209.85.208.42]:37590 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbfGZIW0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 Jul 2019 04:22:26 -0400
Received: by mail-ed1-f42.google.com with SMTP id w13so52564947eds.4
        for <linux-cifs@vger.kernel.org>; Fri, 26 Jul 2019 01:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=meBFpW1PsXERwFNtDWDvTdEVrdNEdtaXYXc2y7ba6ss=;
        b=RHsXV5TcbcbIxT5pEU8BD8LLGDPWrK4543t6dSCuIxauQSBCVmcNYe9IUl2025Hx4F
         k7Jeq6mPGMFzPcrXohDISZf5hK9chT9E/FZ4HXyI7d+DF1/avgooeKpdXw0uZc7/BvP8
         Y0oT5m+t9GIf+u9mAWRZfJmloiIcM31Hmgaz7zfUh54aZAn9hCEkj2vB3rFaMIO2xA4q
         f9TR9j4k67n+oJiGDOpRqNpX88muQL1iuxGXJrJUnkNaaivqR4I+XRTRHAdocTSmKDdP
         x9PRRFe+nfRVkt3S554DbEO1Jhv4rmKVJ2x7jm4OZRyw+JnHZwMy8lgeBww7Nq2F0yU2
         Y1WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=meBFpW1PsXERwFNtDWDvTdEVrdNEdtaXYXc2y7ba6ss=;
        b=tk2WBB5b4yp0NgVFnNE6UQ6yO7B+tGykAHIGVX/eC7jRMG1PlP31gs3nkUY00LwyTO
         gyAhz2UidrzuLN8dC6r24s4aje6jcuT8kz+3JqztNApCE456129IX07677N2IrbYBD6V
         98s8rlyZri9899Y5hZ7rPoFERh8caa+lEM3ASajgg61iyj+BBtqR1frnLoHc4iCOA8Wm
         cZXTluELsWYdGzTN7hEkzpSUkQ4xFp34o0Ne51jfwIhdAwPiW/nJCqv24NQvI0r/+ZLN
         THMZPvux7slzbfha+N4wkPoJ9smh5BVQp79BUjhAroEnECJjsO8xc2u8mZNXipth9Ha6
         HTBQ==
X-Gm-Message-State: APjAAAWC3pS8Wu8HVaKz5HZJQfdiDSyqCS/mAMeMZC44G7yXuecjz3a9
        8iqB3Y1GJkupUA8e5Vw8s+FwFJnGRIL/OYQ1t8nDxopa
X-Google-Smtp-Source: APXvYqwNtsIwryuOiuK/fOJVul+NDZYbxLijOGtZHSkQQo5V4K0Wp3jW0uuLvmRC3HUpRDZbKSp6zV5VWODVL2MQtt4=
X-Received: by 2002:a17:906:84f:: with SMTP id f15mr5334065ejd.22.1564129344590;
 Fri, 26 Jul 2019 01:22:24 -0700 (PDT)
MIME-Version: 1.0
From:   Gefei Li <gefeili.2013@gmail.com>
Date:   Fri, 26 Jul 2019 16:22:13 +0800
Message-ID: <CANidX5ScMgPfd_7N9QMTv3+nhzBxtE7tQVhrAncjrH0JG7q4vg@mail.gmail.com>
Subject: Search for advice on testing whether a local CIFS fd closed remotely
To:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

From some stack overflow result I know that on a local ext4/fat32
system, we can test whether a file descriptor is valid through
"fcntl(fd, F_GETFD)". But in cifs cases, a fd typically bind a local
fd to remote handle, do we have some c function/syscall that can test
whether the fd is remotely closed?

I've tried some windows way like "ioctl", which works well, and in
linux local file system "fcntl" works. Tried to use "fcntl" on kernel
5.1.15, found no server request is received.. Could you please give me
some advice on testing whether a fd is remoted closed in CIFS client?

Appreciate for your help!

Best Regards,
Gefei
