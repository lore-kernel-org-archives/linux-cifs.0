Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99F65C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  8 Mar 2022 11:38:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346008AbiCHLjw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 8 Mar 2022 06:39:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343635AbiCHLjv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 8 Mar 2022 06:39:51 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F16E2B26C
        for <linux-cifs@vger.kernel.org>; Tue,  8 Mar 2022 03:38:55 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id g3so11845297edu.1
        for <linux-cifs@vger.kernel.org>; Tue, 08 Mar 2022 03:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=Vgx8PLh+VQnRAmezLr3x4gHkjfkm/VCWkF/TV1mXC78=;
        b=Wks59qmoId9aFMHEl2PKYxR6l9pr8fT/P2t4du2Oafafiji2wDQE7e8+7uqvdXfLrd
         sWh14Jv0yeQdxE+OSVdzHzVvo9xoFao8lNGjvD6tLc6Sq+QTcKHmesGRWoRAXWs0qBWW
         ui7MW7AVGIqyeIpChA73kfEWrPwyFMKIJAa8TwMnKNz4IFrI80aMXyIEJpAyLQ4tr8SD
         5mBQeEDjvZDaMtXuiXs8igaH0WyjA5oSc0vQpFFYsr63F1fdhVySBVmE3+Gq1RAm/2l8
         oOzxaqQ8g1446LrM5Km9HdtFs5gbuGDEO377Cj2f9GDYlvYSinya4B1uNTtYOvPyxQAh
         6/mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Vgx8PLh+VQnRAmezLr3x4gHkjfkm/VCWkF/TV1mXC78=;
        b=NjCCEZSMF2gWKyGNoiudI1qkRT2Mv6I41/UfbL/VZo5OHqQhiF8tLQ9Ej73wOdw2Tu
         5TVZ+W34Q/mgOzjQHveA9Bn6UDrIyZj/B6p3DvdvKXQvydoo3v6oxBUHH0RECxe59Xxt
         7ws2G8V9bUloZxyC7Y/MqvmkFSDT1cLYedqCePgYZ3RRxin0ZaAfVRq43qOCaqAGfF9q
         H0uF3xjOUzv8gYDb8xe2RsFxnkbAH5gEdl75F/jkYzZIBOxNnIGwChHrCC0Ba5BB8lQC
         hnKPD/uNaQ5wSh+u7k6WPMKbwh/NxukrA9RbUNdkZkxJiz87qL37pjwpHycQXsaY1E+K
         XSWw==
X-Gm-Message-State: AOAM533h1JysQJ3usFiDoAiFil33ClpJfEwBA2oeeoomheRvOrzsrSk2
        sSYAf8J2n+B9Yl6fQJKulM9FiPBsR8x7KuT0iY+YgTMuu+k=
X-Google-Smtp-Source: ABdhPJxoTcURlTCcYDogtEbkUmsUIXUua5upOWV0DJRdVzUA3GtLt798XWELYLRQ5BeKeZLevV0sLfme04HonGo+ErQ=
X-Received: by 2002:a05:6402:1387:b0:416:2747:266e with SMTP id
 b7-20020a056402138700b004162747266emr14028334edv.409.1646739533755; Tue, 08
 Mar 2022 03:38:53 -0800 (PST)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 8 Mar 2022 17:08:42 +0530
Message-ID: <CANT5p=okysnTQhdXixXwJ8KAzukM=dkh2LRxKFKcpsVBW=Ex7w@mail.gmail.com>
Subject: DFS tests failing in buildbot
To:     CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

Once every few runs, we see the DFS tests failing in buildbot.
I did some digging into this, and here's my conclusion.
Please let me know if you can point out some issue with the root cause
or the fix.

There is a race condition that exists between cifsd and I/O threads
when the tcp connection is broken. The cifsd thread marks the
server/session/tcon structures for reconnect, and recreates the
socket, and sets 1 credit for this server. This only changes after the
next negotiate/session-setup completes, where it can get more credits.
During this window, if any ongoing I/O requires more than 1 credit,
then it will return with smb3_insufficient_credits (note that slightly
earlier in the same code, we identify reconnect with
smb3_reconnect_detected, but do nothing about it). The I/O will now
leak -EHOSTDOWN or -EAGAIN into userspace.

I feel that we should return a special error (-ERESTARTSYS?) when
smb3_reconnect_detected, and use this errno to ask the caller to
restart the syscall.

Ronnie/Pavel/Paulo: Please let me know what you think about this.

-- 
Regards,
Shyam
