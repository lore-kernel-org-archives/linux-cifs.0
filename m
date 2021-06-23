Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF23C2B9F4
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 00:57:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C16BF61361
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 00:57:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhFWA7V (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Jun 2021 20:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhFWA7V (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Jun 2021 20:59:21 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107AFC061574
        for <linux-cifs@vger.kernel.org>; Tue, 22 Jun 2021 17:57:05 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id t32so941943pfg.2
        for <linux-cifs@vger.kernel.org>; Tue, 22 Jun 2021 17:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gnarbox-com.20150623.gappssmtp.com; s=20150623;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :to;
        bh=G5ZjeAnajbyrxi0D5iJMdPjbcUmv3A9Kls8M+Z12iCs=;
        b=AQQwnqtM4WcrC8/pFpyRk6fUCsucVGQO+HHMjPIXtv3e7v4QkJOL2RvfgfbEb4qsnb
         5ZHlpuGI4WSJoEySx/GR47E1RKattNezcvL26PbCzFz9Hd/zk5ZctXt04VRuBTiGWBqG
         hF0Nm8Fjk/4DL2QqXtS/thaZ147meonLG78JfVd0Ctqa9hgFyKpmhhGZMjOhYcnv6zgy
         llvwV4W+aWsGU2coU+xmHCWeg64sm429GUIXy+z5ZrZ1hG9piX2d+bgvVDXPNJ2paHgc
         ctmc7Vmb2c3Cj3AzkrJ0v/5Lk6+21EBHIULEYyeKzBtCWIxADffkDpnEPapZuUXS0Fo9
         XgHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:to;
        bh=G5ZjeAnajbyrxi0D5iJMdPjbcUmv3A9Kls8M+Z12iCs=;
        b=r1lDT/rBOnWzQXJkVTWF+kJk+JocL8IKdrIJKplKBsgXXGnamDmGylHP65Q0VPK8PD
         BPb1xNVFRiG4hfWegmOh0BS0gplZ4lW1yZoYlC2zgin8L8n5/MpgjKm7e/H1IAEH18K7
         QYgW8D9N+7BbD3E2y6nKjKl6ZDvE9EtuMesDIcvSaF0Vr9oNfwYvvYInFSKeDwAP8Bon
         b4NhcDXJkClKHmMntGNLLiZPL1VpSIMEVLTc40aWaf9I5cItLFQ38O61H1IFMc+nEXEe
         onOSklMb8rF33RZ8na4BRJccUcSsjDPYyEpBtCGF32DDeGSWQo88qLob0957ZPteYFMc
         I7KQ==
X-Gm-Message-State: AOAM531/4Fl/sMt8SrwPA4yZFZ5kWLUva6GpJXkyhFrEzL5RuVOItFeH
        dXPlaMTAozhkOCKJbjUhQSaIQIraYrICXg==
X-Google-Smtp-Source: ABdhPJwtjFuHQG4jTsdsC6UnOIAXLTDbGZIrjsKigkUMZaK9ehHBWCYCA1adJR4BDJhOgfO4r+rCIg==
X-Received: by 2002:a65:438d:: with SMTP id m13mr1252140pgp.87.1624409824065;
        Tue, 22 Jun 2021 17:57:04 -0700 (PDT)
Received: from smtpclient.apple ([47.151.138.208])
        by smtp.gmail.com with ESMTPSA id n23sm20261785pgv.76.2021.06.22.17.57.02
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Jun 2021 17:57:03 -0700 (PDT)
From:   David Manpearl <david@gnarbox.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: linux-cifs TEST
Message-Id: <2F25465F-9533-44AE-893F-06E0F2008D3C@gnarbox.com>
Date:   Tue, 22 Jun 2021 17:57:01 -0700
To:     linux-cifs@vger.kernel.org
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is a test message to linux-cifs@vger.kernel.org which I am sending =
to debug reasons for my previous message not appearing to send.
No action requested.
 - Thanks, David=
