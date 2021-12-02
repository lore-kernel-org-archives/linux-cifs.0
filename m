Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A5B7C433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Dec 2021 12:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241895AbhLBMF4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:05:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357802AbhLBMFq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Dec 2021 07:05:46 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA59C0613ED
        for <linux-cifs@vger.kernel.org>; Thu,  2 Dec 2021 04:02:20 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id g14so115012245edb.8
        for <linux-cifs@vger.kernel.org>; Thu, 02 Dec 2021 04:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=zGfYDDkDk6d5v1nLgtOCNQOtLJ9EWXHvGVmOeZ9aU+M=;
        b=TzZnbOjsdicYXf+nmR0llE/d5LoxU4sfaA0XFVp6uR68dxCcq721l1dIjsa64wwBQI
         HDSi/MKhdXEywMgNFPVREQuT3FxugsCec3bQWzDa7/hs9GDfU70y8qIMcJNpGmIunyZ8
         ppKpwV+5Y5E5VaDcm6qI6mNktZ7ojnxKN92zoAYHRDoip8w4sNm0XcOgIWSmT6vhcnFi
         Oak4BcL8YHpK4H0mUZ5/BBI6R/w46RzcLvrSyylPGEOxYS1rRBxigaAmgBnAD9VIRheq
         4cSeiZz5arffedULATxN/xb//QvER2Vxb6AEXa/VDg2uLW/Boa54B+M3Mp2YKTkvTFiD
         e7SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=zGfYDDkDk6d5v1nLgtOCNQOtLJ9EWXHvGVmOeZ9aU+M=;
        b=zah7PcTVAYpJDtrKpX591/MkCNRuKEwd8ZKMRTaT/zM1xdrS1ve3ZYBLKpPAfxYFpa
         rRnPwMy+Dq5ilTAyDFqXNsIFJatjQ6EhiA2j+CLmOUyBFBlWq58Jwrj5+kP/G8k1QzWV
         dNK7Q2DUIaOgf3wdw3xsnfBd4gtSVgT9UTFeGG2iKlNnvAQMQft+XVVtCDD19k27piOe
         qqlF5NG1MqxDb74tQiv8HRD7knb12wtNNA5u8EfIIaKkQzJHslEPl1vU9ZLZp0ujG8vg
         SFVyPPpEMC1bdhzcJZu4SO8I6pzaUM4/DOqnAdnznLq9gWkYhcEwrhWvCuL+ryRP1WBF
         3uOQ==
X-Gm-Message-State: AOAM531ATC9NSEH+fykJmUVXNmwYyq5vAQ3r0G0EPTH8XdWd6RNpMfGr
        74bOBURzBzJhKiZk5aDCtNyzfD1i9p61pXq9Jp3CP8oM0+5+MB/o
X-Google-Smtp-Source: ABdhPJxYsbrhdUp+CIDWWl1ZD292gqHmuZT+dKcrHe4CFVI7hcjAC/RRDACZ7lh/yIc7e7R3uNn/CXdRm0rHogHMnzU=
X-Received: by 2002:a17:907:608e:: with SMTP id ht14mr14837269ejc.120.1638446535881;
 Thu, 02 Dec 2021 04:02:15 -0800 (PST)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 2 Dec 2021 17:32:04 +0530
Message-ID: <CANT5p=qfOdaFQF+EUgjgQx=zGb09FCu=zjZ7q622G--dUy7F3w@mail.gmail.com>
Subject: [PATCH SET] fscache fixes
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

Please review and consider the following fixes in fscache integration
of cifs.ko.

https://github.com/sprasad-microsoft/smb3-kernel-client/commit/d70e50047c7daa3de17c7c41a0c4ef4f9e4443c9.patch
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/089dd629653b857b6096966e9d2df301653a36ea.patch
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/a9a62cdfe26c782dadd0b94ab529b883426d0acd.patch

-- 
Regards,
Shyam
