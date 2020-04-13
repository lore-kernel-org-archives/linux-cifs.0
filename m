Return-Path: <SRS0=FuFi=55=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FDA6C2BA2B
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Apr 2020 23:26:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D52022075E
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Apr 2020 23:26:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YQaZcA6C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389974AbgDMX04 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 Apr 2020 19:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727839AbgDMX0z (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 13 Apr 2020 19:26:55 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808C4C0A3BDC;
        Mon, 13 Apr 2020 16:26:55 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id g6so6157441ybh.12;
        Mon, 13 Apr 2020 16:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=yG3fNKshW7r+Tp/fTvnCfUCdvteVMueq4fN0wsYEHcE=;
        b=YQaZcA6CjuIVjCyRDtvWOiL+ETSg+H2a9wd1B9wUtMgB+mn9AHOGrxWZZRFv28uCo/
         nhxW2vXFxAwhy+cJ1FWvSdV5fekdxKcYBFDKsi5jetBk9+sB+BGQY4aBQOSWfua3jEig
         xoC24kNoPjwW81FmxVRzkyCJP4ddlGncBliDWJGPsszMIHkENqoiYL1LQCsVpP9eDn5m
         QoY5zeoTr9Mdrd4SFn5vnAZ2RmxPLAtFiou2m/ljjLJZSzemIoLXYQlkhCf2BvgdmWSv
         J40Dl9Yf+cfA9J6QvMTs1y2DRVqMvBX4O0PqReb1arokN8YAFRLaAqYP4+s0fTInOQY4
         QWtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=yG3fNKshW7r+Tp/fTvnCfUCdvteVMueq4fN0wsYEHcE=;
        b=Yal+RR1E7sPNiwHmh3iF8kEjHpTZWgN55UIrs8GcM9yIn5uv1v6X0JV8J1mr6pDKxD
         9K+poqDixY842lzdPbUUdKgSUe4N7NH7O8Hs5B7JyamVXmJD0v6fYdSPA73hqP+zD29J
         oBmZgU2LANc7Ly+7DveBdgMcYtNq6IeHpJKZKmfPS4SA8DUMEfEo0gQkDNHXnGpfyjAT
         eXktSRCuMvVi9JA91tXc0dx0v6zBNtucctC/3PqfmHE5Oxa/1uq9AmFbqyxfGC+ekf0K
         42ClN9lZdkbpy71QV/ANKJvRpn1fF3JGVw7Nr8L63Fz5wHUF4dpMnBBv2qAZ4aAVeeNX
         39vg==
X-Gm-Message-State: AGi0PuaTPXrIMaEsDl/AY8S6tCCt9UoQZGMRJvB5mnnY8m7VaMo64ex6
        2xdscsNFO2JEed0FSFoqnmYx1S2nizMcY7hROLML2mQO
X-Google-Smtp-Source: APiQypJR10P9Uy26BeYm1oqKqfY8jQeBMRG+1HNT0uLUY8vzndes77nStCt4NQU6cAJnXqSuBxGNbjZV85fMAPtO1rU=
X-Received: by 2002:a25:b78b:: with SMTP id n11mr33636844ybh.376.1586820414396;
 Mon, 13 Apr 2020 16:26:54 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 13 Apr 2020 18:26:43 -0500
Message-ID: <CAH2r5msrX8CqNRnhObAuNs501sGAib4fOfsTbVhR6eY15=zmGw@mail.gmail.com>
Subject: how to create VM for testing with page size 64K
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I was trying to test a file system patch for a case where page size is
64K (apparently possible with ARM) - any easy way to build the kernel
for the usual VMs (amd64 etc.) where page size is 64K instead of 4K so
I can test the patch ...?

-- 
Thanks,

Steve
