Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9CAFC433E0
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Jan 2021 18:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8837D23403
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Jan 2021 18:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732808AbhAOSh7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 15 Jan 2021 13:37:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732398AbhAOSh7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 15 Jan 2021 13:37:59 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B4BC0613C1
        for <linux-cifs@vger.kernel.org>; Fri, 15 Jan 2021 10:37:19 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id o10so14529285lfl.13
        for <linux-cifs@vger.kernel.org>; Fri, 15 Jan 2021 10:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=L4y+codSSrGoZPaftKKTttufu+8wPiPdv3lIK/WIHqY=;
        b=UYnTKXsTLRmZh0Z+LtXoU6J67YcYAp80Qx3SxTMzfSoP7r6/nxKfXEvC0him3P2pos
         0jP/nrD/FT+BuhjH1ihqMhk6Pw01rj9vdmLrTTGKfp3Rd0DvEDDbb3lb7KiVlNHN2XPa
         iLFnlVDwdmJV+Cnf3PA0WgnlXv4t3cHcLbCu63NHTSZola3+/Xag97jOLTViogq7VFKE
         rWXGzHBQGvaSvX3auEm4jW5wrNa24XkD6uJC5FJ3ufA1RL/F/IruoTIFzwCssrGD2xBn
         oXaZMFIFm2uRlUuDSPwordyoa0J4XKpFqdGkQUPJn5uBdjHOYeq59HmAfjUoRr5CccOT
         mJyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=L4y+codSSrGoZPaftKKTttufu+8wPiPdv3lIK/WIHqY=;
        b=rqhd66RYzrchkOPMR0NA/M2VWhiruyqCIt828bZZLRSGiKvOv7+wpNQSuxF/UM3jDe
         Q5ng1MCU3y2Sk149LWF95FB6SD4O1tsjSB3pfeDPGaZYv8ZMNj3MfH4cL6Kh4OpSHi/V
         1NbhlKlCJ1SSwablCzPbAUg0+P0/vZZ+ZcYU9TDfyJ7OQneyiAVH1fxhQ243AKDGInpD
         hcZFTd65JFeReva2rkre7/uVcuXg+zdIiS7sWs6JldnuGF7rKnpRciDPdFjLIiyNx7TK
         z7fCF3kclbzBcVb4bKV3mYqBfltOH+7fZcTF1a5UaH5vkdOuJlzyPAl38r6pHgtdJNHL
         GxwA==
X-Gm-Message-State: AOAM5338GBcsOLUxLpFwFVFYpjs8kY1zNzuEVJMKI7GCylVloB39HALD
        SO9ntnCHnAer2N/cQ7NJh80NbpWg+eHWLVU6hAfg4OWFSRrpdg==
X-Google-Smtp-Source: ABdhPJyQLuy7MuXKkcmL0TNWvpVaVGZQeuWDtbTFQx6MCQni88U1HHQwI6Pk3q6v42DjHnhcs474KjVpAZw7LDw5mvg=
X-Received: by 2002:a19:f11e:: with SMTP id p30mr5778030lfh.395.1610735837387;
 Fri, 15 Jan 2021 10:37:17 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 15 Jan 2021 12:37:06 -0600
Message-ID: <CAH2r5mtz-NfvKaN=9a0fBk4jbGVx0Z5ijqhScM28VmZCADEeLg@mail.gmail.com>
Subject: Added more tests to buildbot
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Aurelien added test cifs/106, and I added that and a few other tests
in that group to various test groups.   Azure test group e.g. now has
four more: 100, 102, 103, 106

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/272

-- 
Thanks,

Steve
