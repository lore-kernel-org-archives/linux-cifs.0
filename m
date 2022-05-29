Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B028C433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 29 May 2022 03:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiE2Dxo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 28 May 2022 23:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiE2Dxj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 28 May 2022 23:53:39 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BC460B89
        for <linux-cifs@vger.kernel.org>; Sat, 28 May 2022 20:53:38 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id m2so7831590vsr.8
        for <linux-cifs@vger.kernel.org>; Sat, 28 May 2022 20:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=giHaGcrnS96RQDZzPa4m01m6+h3jecgHXpJNe+dYIBc=;
        b=i45UUAr8myc6PEZyDBHGu6sE38KbmeuNMXysdpziY3FmLdllrMf/XFwXRq/Fqhxy8p
         B1zyFmsb3ZsEdXI1OQfQqRn/CCeB0SEwhg/CHldGbAXktnAvY3mIkczJNnHa4dztEuSM
         7w6j34Nwh1WK8XNTbYN7PYQxtONYORqsdTHAwCA90EYxFD3bPavqpoGuf+pGAlbD6jbn
         ljjxf9S4hrVMNGnbzCDzsAxolTzJmX+RS28PtfcXakzRAkGu4osm2pSeMS5vqhVbnu9T
         3KNATQp41R4cUXCNKi/RtuVYCVnIIc6EHUqQ4SQp1EeIWD9UIYRNWZ06MVtzLBOdrJ2H
         s+Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=giHaGcrnS96RQDZzPa4m01m6+h3jecgHXpJNe+dYIBc=;
        b=NF3rZhXNg+e+J/NkHNMvYsI2eqDq+PCiafVVZ0if6MpxBRn3m/BxRNlXuu0qb3xoXn
         gKLfgGEN6ryJHYEcnC1+mv8xpYpRTo/fjC4y3WgsSeHYcrbWnSNKHymo3xiwXHy6IgVT
         6rEBAu1znIR8SZVhrloFwlwYpaFWX9CBjmy/b8gJmV/bXqNJT4Veg6L9wnszTMgJ77V2
         u+pAOZg2mXlXv05GeT6BzxobrbaLkFoU3Vim1AIwxLQz3GHPoB91pu3ztetq4ZUXIS9S
         Wr3JqjaW8IfA3rpaMu3BqNdCKgYw8ZIsrSYHgER2FSAIi1qHRUOqkWn7dl8/OJQq0vs4
         u6PA==
X-Gm-Message-State: AOAM5337evAOinFURNPxeOYQG3cIpL5mpNdPK+WylQn7ThkEu4MeTXM/
        0MIKR+vBEBZZtwz1dWr284YJQYBxlqJI7HQKeyXcNRtPq0g=
X-Google-Smtp-Source: ABdhPJwY4H6q7NaupupMQTIeIYFuOnPAWRU6SZyi84r/xgkUkAWCoo535sBbw7ix1tNQYx2sUxFetIodOwEZPEBhCj8=
X-Received: by 2002:a67:d601:0:b0:337:e4b9:d2e0 with SMTP id
 n1-20020a67d601000000b00337e4b9d2e0mr8407504vsj.61.1653796417473; Sat, 28 May
 2022 20:53:37 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 28 May 2022 22:53:26 -0500
Message-ID: <CAH2r5muLr-UKAhcoP-s2Hn=U=Hbe2PtTLKODD+biSzQS8FkfZg@mail.gmail.com>
Subject: xfstests passed for current mainline against current ksmbd-for-next
To:     CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/8/builds/108

-- 
Thanks,

Steve
