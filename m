Return-Path: <SRS0=r/yF=XE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36705C433EF
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Sep 2019 10:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09C2D21920
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Sep 2019 10:41:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MW2IA4PY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729828AbfIIKli (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Sep 2019 06:41:38 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:37261 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728358AbfIIKli (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 Sep 2019 06:41:38 -0400
Received: by mail-pf1-f174.google.com with SMTP id y5so6154062pfo.4
        for <linux-cifs@vger.kernel.org>; Mon, 09 Sep 2019 03:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=J2a86CSDGl5Hc1scZy6729srDrxCmCveWLJMm/qm8zs=;
        b=MW2IA4PYrdXuVEovyo4V6Aaml+b/wVO8SE3LMkgpxlO+7F2t0PApJmpSDXYkuUjP0P
         YEba3uaLRNuKv3HFPssF+mumZVuAvv9VJOdb9YEaGPwlhUlSSjh/x8zt3mDfU03zXBMg
         ySoAUh7nc0B4P8Z8wdwrHlrqHJ3ss989PhfOeeCKJ/Ws8SEkBe4ritoCWTKbZ3foNgcE
         vP6yDe61uHUy9nG259O/LcCMOgBsK4pAZvSqiU+XZIG2nlhDNxsaNvAH0GXUjuqLCJB2
         1fMqNoAp1ko6vig8tWHMq4t9CNNrcZda2F2zESZ3XDEwC5jIbssBVtpRgzI3NeuUuaBR
         curw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=J2a86CSDGl5Hc1scZy6729srDrxCmCveWLJMm/qm8zs=;
        b=APcSTE/PYQ8JTFPIIpTYgDx7j8BQBs2EuiQ0X5Eqs4K1bLteVHy8nwc5Py32QoiqL7
         5bFRauk+hGXTQjp+wnj7//uTSUS44F/WSJZdKmEzhFSyhqOXAedBP92c7IC0R7ChBiAV
         8pA8e/HNNOaiWVLUbiMgw/obFRVZe5HxKNksJjGrXYeQLVKmR8MeijzE9NyGdg2Kssy2
         MJSSajUt2NF2tzAB74ZZMnHvmBYH2ydC/Tmxk29ZS/4UEYH/yVJm3OHfT3MnFMDJDst8
         YSvR6Cd1DouT7vTQCL2v8Md+m+bGlCCOwvXYJrTMUnmib7xACzYyAq68bFtkys9J/2Ji
         2NsQ==
X-Gm-Message-State: APjAAAU82nR9zztSueHaOSKLPVct7OMxCrY+APy+V2qfq8c2AUBi87Zc
        UkY+bQfmm9kikvDkkBxlzvfxJOwl
X-Google-Smtp-Source: APXvYqxI0NIeRgaLtDgmAB1VuxrRHguTaDdpytY5pG8oIZuBEP7rQMiCbAaxVJExOKHxit1JzCmY9w==
X-Received: by 2002:a62:b415:: with SMTP id h21mr26855091pfn.198.1568025695894;
        Mon, 09 Sep 2019 03:41:35 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 129sm17172275pfd.173.2019.09.09.03.41.34
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 03:41:35 -0700 (PDT)
Date:   Mon, 9 Sep 2019 18:41:27 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     linux-cifs@vger.kernel.org
Subject: Are the xfstests exclusion files on wiki.samba.org up to date?
Message-ID: <20190909104127.nsdxptzxcf5a6b72@XZHOUW.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

As $subject. Is this wiki being maintained ?

Looks like the last update was in January 2019.

https://wiki.samba.org/index.php/Xfstesting-cifs#Exclusion_files

Thanks!
M
