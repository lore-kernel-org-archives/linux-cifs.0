Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15936C49EA6
	for <linux-cifs@archiver.kernel.org>; Sat, 26 Jun 2021 16:48:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E87A161C32
	for <linux-cifs@archiver.kernel.org>; Sat, 26 Jun 2021 16:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhFZQvP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 26 Jun 2021 12:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbhFZQvP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 26 Jun 2021 12:51:15 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53A8C061574
        for <linux-cifs@vger.kernel.org>; Sat, 26 Jun 2021 09:48:51 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id j4so22146584lfc.8
        for <linux-cifs@vger.kernel.org>; Sat, 26 Jun 2021 09:48:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=NLmft7BFDAw89nJTJt+TFhz0eJX3OVF/x/Zcwe4/S24=;
        b=cDWHscMkkZhgrksxgNX7kF5+px69aJ0K4fxxC5YJjxRONbFTVPZljkRniPlkmR5LeQ
         tD+jPpf2UyDIFs8BY+xOr29ly8oJ5rQZJGe0ZVDa5iW36VKoshjH4c699CQGw4lQKTZK
         qRC5IPMXgPNsW6Dt0ncTigehXGY3RlDEzmV2E7oHauNIklDK7/TEjrr3ilmdszaIJ7aA
         ncofH08taGaaOCaeYL871Ad303KVUxUEz+PlkpSpSwjLQ/LrjoMuYF7T6tbovTipTSzn
         K+mGuYaJzq8ZDkBDgxdiusD6+sA9IiEkhFfsLjvlX4SF4uTRmE3AiWjDLnKWfTZ/Hiyh
         bUpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=NLmft7BFDAw89nJTJt+TFhz0eJX3OVF/x/Zcwe4/S24=;
        b=tP9l+ee2zYmYvhgbdAxWu+AQBGM2yU1fK7FkiAOlbFYi2IrcvhmFriaPnGlzckuOF2
         kS9L50rI27fEaHYC7LkZ+IPIDyiOLanlgYwziGqu8fNkcAG7l0mqa8E/GKxSKYO2Yh9+
         ff5p8VhV9lEV6jtMXPoe8jEF9XjB6OGm3RKeUB4TOoGXvCPTC8y0cg2Lt09FipbR4k5T
         vmqMzonNIkuJK7f1WxbDkWzV/9UxJk7Z+h27DLPIpWqjEJPwg/pbkkhp/wHH43UrdWLS
         43y24QJk4xsLuuvVdGfG21IzhHFX3N0OzOwp33zDkanImfN44F/6nG/y0pUWjXe+lsxQ
         2g9g==
X-Gm-Message-State: AOAM530d+tZWP0Bg3q57IKzYYFDPjeKXhQrcb4570wbkVutnkMQ1LMG6
        m8fXJJeXEF8m/RWSKhx8wIN9BbHKmM32ozqz1cEdSN8q/h4=
X-Google-Smtp-Source: ABdhPJzUdQLQOfTPk5FAPKMoDsQztklnlX3KZCNRAOLYy+xCPQTfn9vDK0O1q52Bt20P9Hungy79R2WhD9q3WEIkn98=
X-Received: by 2002:ac2:4d8f:: with SMTP id g15mr12204567lfe.133.1624726129635;
 Sat, 26 Jun 2021 09:48:49 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 26 Jun 2021 11:48:38 -0500
Message-ID: <CAH2r5ms9kX=kzHneUkRXOQ-McbRxEck4uBVOQmjHq6q0rhGTCg@mail.gmail.com>
Subject: Signing negotiate context
To:     samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I tried an experiment to Samba 4.13.3 and also to Azure sending the
new signing negotiate context during negprot.   Azure ignored it as
expected, but Samba server rejected it with "STATUS_INVALID_PARAMETER"
(it wasn't obvious at first glance what was invalid about it but
perhaps Samba wants different rounding than Azure).

Has anyone tested the signing negotiate context (e.g. newer Windows)
to Samba server?

-- 
Thanks,

Steve
