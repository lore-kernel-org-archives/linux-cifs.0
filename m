Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D735ECCA489
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Jul 2022 09:44:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238231AbiGZJo7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Jul 2022 05:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiGZJo6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 26 Jul 2022 05:44:58 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18F231391
        for <linux-cifs@vger.kernel.org>; Tue, 26 Jul 2022 02:44:57 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id v2so27094qvs.12
        for <linux-cifs@vger.kernel.org>; Tue, 26 Jul 2022 02:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=FHGUzKmZ0uw6/+29Eqiy2YbZDIOJkhs2A8bSr/a08+o=;
        b=MdMz1Pq9sh/rTGAfwtIXPSMselPOSSDys5vFqmggJPyf3nA3U/VZ24VRHj0ROlZ0Kj
         vLMAIDF/M/Oq6cSlq/fIxkMKN5G/e/fUT5aXw8Nawet2DkvjWsmi2nywTKiEmnBrqQnB
         6EQVAD4t9vzn8LUMT+pc9hqYANOqoWIInOxgeydlHkaV4FRuq/9CqxLFX2pd+we/hz1N
         JTWPzUKwBL8mBC6uESGVkpVoeq6HrGWCgnkbFYcHlSGHQUGExBDwdqNiSgVXHI0pFkY4
         ZwAeodc+rSCjTOeGJDHpsEF16hcIWjDkLLeBiWJ5mkwWkJWk4apix0uhumxan7eDpQsm
         UT2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=FHGUzKmZ0uw6/+29Eqiy2YbZDIOJkhs2A8bSr/a08+o=;
        b=pN4JIwz8PqlBbtI6zskX6tukWZD2AqljfOAR6PBVcHPRFT7quu8MyILmOJ5yVDVHbd
         3JtXKqvoA/sged2HDTll4tDfRkpdq0Nr2cBARXYEjQiNBZDW/uDKOWpJytjK1igJ10aI
         qYwGznj5IIwej20oDDMzFIyeqkTBD08Ue6UR8ihH2fvHGqadYtVINf3uTPjgrU4Ks/PN
         O4RViqEKVm5tzMqDyDs4pEfdKHWuZrdv4ujS4v96zjdbSCjklRwQ1uV4ZWMjNg61XUZx
         E4B7eiJAGwyfTdHM5spIpNXrBKtc3016zcVESP7sbfmUwADXoysCfFI89JMr8kTN+o+S
         dRrg==
X-Gm-Message-State: AJIora/rsXS4dTT13OZAlgwWKkPElIc3S+UVyLQikBpIERi30reAZcmc
        2BUM02d+OgkvxwogLivw9n6IoyHGvrqcw3lqJptHuyV+1rA=
X-Google-Smtp-Source: AGRyM1uspLOT3XCSzQ5LAXbtu+kZWmohmsiqcZQ76cTvOuRPXkSM6Y4c1UMmz0urnjyqyXjC8H+LvthFrMo8g863XIg=
X-Received: by 2002:a05:6214:5096:b0:474:4c82:a907 with SMTP id
 kk22-20020a056214509600b004744c82a907mr6825160qvb.81.1658828696714; Tue, 26
 Jul 2022 02:44:56 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 26 Jul 2022 15:14:46 +0530
Message-ID: <CANT5p=qSoPWqBmLGDNOj3fiWVPCBn_MvwC59wbdU861uc7Ejdg@mail.gmail.com>
Subject: Winbind active directory without domain join
To:     samba@lists.samba.org, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi all,

I'm wondering if I can use winbind services without having to domain
join the active directory?
i.e. to login as AD users (with the help of pam-winbind) and to map
UID/GID to SID and back (using wbclient.h).

Searching on the internet leads me to believe that domain join is
mandatory to avail these services, but no conclusive answer.
I Wanted to confirm the same.

-- 
Regards,
Shyam
