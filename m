Return-Path: <SRS0=zBrE=SU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E33DC10F0E
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Apr 2019 04:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FAB02184B
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Apr 2019 04:41:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lWrdxBYf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbfDREly (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Apr 2019 00:41:54 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:45611 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbfDREly (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Apr 2019 00:41:54 -0400
Received: by mail-pl1-f174.google.com with SMTP id bf11so534210plb.12
        for <linux-cifs@vger.kernel.org>; Wed, 17 Apr 2019 21:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=N6R+geIcQJmcjwgKaqOAaVGrrLEcfPmz3kdpDIVLJ/4=;
        b=lWrdxBYfE/upMotd/Rtqvomido0u1Mf7FrQWrpQnfypxrJ1xvD9m81ryr/9zdpmYrY
         Rqg2M1grxPO8uO+tRgk00JvNOw/JX0Xb6L+5Ykr6ER5eVoZzYMKDb2x1Wo00fd3kn1Ax
         4JwH9aEhxFHjg+nQw3SJuSDvznnssjTBSDT2MalAM6Ey6Gar1gXhybCr8npTESGpLcpt
         DYl3Oymf/xOM3e8yO2xa4Xa6PKgeOM6qz6sz5Y2BbC9TBK1jfbM5aM8Tqh9SFiR+C7o7
         pjONKvyrYI2v9xCHPIF5xYbSifboFeVSfeeN5z4J6Q7aZAb5S/p8m75uJGnALLc/8Ah3
         xEwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=N6R+geIcQJmcjwgKaqOAaVGrrLEcfPmz3kdpDIVLJ/4=;
        b=DjOgjP2p8kaq/12AUA9xQj+919zx+CjtphOkIneYlb/CfelduNsh/NOUSXqCFq1J1j
         Pz1S9s2qHAR5gcIqCIjf3Cvh+YNLUQIm1sccYi4JHPPNX6F8UY8b4FGmFWQNPFcyoV3/
         19a4Ert23zqKicMtyh64BqoWK/L4UbAOa8WSQ8U31iOAerKE+UW9S48DeFFwqX8LcR33
         qsfcmijuVYDUePtnH4uLMNYc7mf55cc3721Q3sJLDQfhAqJnYK83jT0XIiTtGlz//+sQ
         FOMJBf7drA0X1xTbIEKahwhLjui53mzfDQh4xMSQjU4q5eei8IPZgF2yVymqXZl4MRLb
         ha5A==
X-Gm-Message-State: APjAAAVyRXgG7Jkvlj3CnCLXZESU37dMtUe6h/d/mK9IYJo38JG1LBDd
        4BvOt91t9Zj3LGwoVfjhlBxqOFNo+7W7PdDxYzQ8DR1Q
X-Google-Smtp-Source: APXvYqz2uAEzJqkd/DD/PHMl+miGHwmDQGtHfC9OGznA8KMk5C4tRbD+kwVMmJBkmRZ+ycAJ8x9oI9a3WkBK2xNvugU=
X-Received: by 2002:a17:902:4501:: with SMTP id m1mr65494117pld.290.1555562513082;
 Wed, 17 Apr 2019 21:41:53 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 17 Apr 2019 23:41:41 -0500
Message-ID: <CAH2r5mt+GGF7qwghbNuPEfgMQtyFmKWz8pSeri=mw0W_3wieCQ@mail.gmail.com>
Subject: Full backport of all 83 CIFS/SMB3 fixes in 5.1 to the 5.0 kernel
To:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://github.com/smfrench/smb3-cifs-linux-stable-backports/blob/linux-5.0-full-backport/full-5.1-smb3-backport-to-5.0-kernel.zip

The README file in the zip file has directions on how to build and load it.

It passes current xfstests.  See for example:
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/145

-- 
Thanks,

Steve
