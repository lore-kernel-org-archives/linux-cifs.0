Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA08C07E99
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Jul 2021 22:47:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9397C61283
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Jul 2021 22:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhGIWts (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Jul 2021 18:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhGIWtr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Jul 2021 18:49:47 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE29AC0613DD
        for <linux-cifs@vger.kernel.org>; Fri,  9 Jul 2021 15:47:02 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id p1so26219075lfr.12
        for <linux-cifs@vger.kernel.org>; Fri, 09 Jul 2021 15:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=s5yoLw2WRqpJs8l0Ui074mPt4/oHoJpnyh699GyX3ig=;
        b=RGA7TWro5cv1sxgIfpx26NtvaP8mUMPeg56BCFt9VqZoeO7CYCc7wU0fcHsdu4qbmO
         4bEQS4WzfDxlaIoOeh2KXOTqGbG2YeZNgchStsEXiDdYAhWNN8JujTeFA+mwcLyjMXMB
         TytudGxFoXwz410cYJgR26VwZpPCBUi49eCEOGZYEn0QE1NdwZRHM7lvnGatwJU/nBE4
         CxMu3SE0wOjKMWlS333ZsJ9DfZdB3LTx7v2Lx5+qEI4SDbndLPsKbZ4P12AGuSwPQ3Sk
         aYHyUpckg8YqO2OSWclV0N3Odk5UBVdtUMFShQU60gKeysqaB912BAipKpgGmGBwzo5A
         i1aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=s5yoLw2WRqpJs8l0Ui074mPt4/oHoJpnyh699GyX3ig=;
        b=E4y0T0601ajRS8Ih8LCmDWldrrWUHThRseupk7pPJkOQviXYoCjBLatZPMX3Aup3OU
         uoU8aZOito3v/uaDw3fkmlSUq/NQlqOxMtzao2bJusAWtelkzjHEYEYZUWoIhkRuv8lY
         We5DXA+GtWs42RBhoJgM07lcSM/t2iYktJAHOcV9cdqDWEO29GVDZaWVf4fpMcjxIIKc
         jqwvducA65GVN7Y/62jH2XeIdaef+U4+DmlNraSsdlFrEMdXWAD+vQvFM11CzAJRlRVW
         Q2qjlhwBNeXhwH6Gyu/sJOKbrbZA0KyV6tps1uxbMRLMgM10MwdHwgyNUH/gJKeCSLkr
         v6zw==
X-Gm-Message-State: AOAM533NwJNM+x2pslUHbaArFCWkHhWS7R3c5pCQ8EybIoRXX6C5jdI1
        ZTL4q77tnxKBl6C2WKZJoZ2WoQvkTYUtA/c0VXtemM0A6c8=
X-Google-Smtp-Source: ABdhPJynYijf8xhdztinCKdwSMuHZ5vjwOfUnqzNbQ1EG2E1Yly2JK1NBpiftnFv1CCMIWJxruqVwz9acBFsLaBMPls=
X-Received: by 2002:ac2:53aa:: with SMTP id j10mr11787860lfh.184.1625870820529;
 Fri, 09 Jul 2021 15:47:00 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 9 Jul 2021 17:46:47 -0500
Message-ID: <CAH2r5msu6Or-pOXFx23S9d7_3Uu8UoftiJMqL5dBL7Ji=MsxaQ@mail.gmail.com>
Subject: DFS name resolution bug
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I saw a strange error testing DFS today.

When I connected to the server it gave out the referrals with the
server hostname.  Since the client wasn't configured for DNS, I had
added an entry in /etc/hosts for that hostname with the correct ip
address.

When I ping the hostname it works ... but mount still fails and in
cifs.ko I get "dnfs_resolve_server_name_to_ip: unable to resolve: ..."

It looks like a locally configured (/etc/hosts) address doesn't work
with DFS on Linux client.

Ideas?

-- 
Thanks,

Steve
