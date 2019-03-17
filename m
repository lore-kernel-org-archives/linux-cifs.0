Return-Path: <SRS0=cCOQ=RU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89958C43381
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Mar 2019 08:40:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E5AD21738
	for <linux-cifs@archiver.kernel.org>; Sun, 17 Mar 2019 08:40:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cMRkjRH4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbfCQIkS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 17 Mar 2019 04:40:18 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:34552 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbfCQIkS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 17 Mar 2019 04:40:18 -0400
Received: by mail-pg1-f174.google.com with SMTP id v12so9337120pgq.1;
        Sun, 17 Mar 2019 01:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=qHSZ/mh8Mi7bEXim3YSl7JsIAy8bnxrb7pT432XOzMg=;
        b=cMRkjRH4NHCnFoWm9JAA+TAWe7mvCpRuBVxFTYcWAYSp6SIJp9cJ0Fe2Qcori2sWV3
         P8g9n9F9DtNmVuWZRZJBLZM9y+Qs+QtrEBjCxQCtiuuKhyG3cwLOmmUIDHjQ8lRFMhwo
         dAT856lFLQDvnSfGEJIRVWz5kvAxJYMsjR85M9TQsR7Htp60Ss6teiIQfQ+ef2yIBMa7
         U2RHVrGrWEYucG5hZMfACN84LUVXVV7KPv0zC39E+ic/yRyCjYpsU6o0UYL1l1rIlW19
         pFl1nH34apnkwUk+WZR5UkAbVJeGPpc93/XfejDZQJc5XzX0rpGSz6UuUE+5s/JA+pUj
         dvaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=qHSZ/mh8Mi7bEXim3YSl7JsIAy8bnxrb7pT432XOzMg=;
        b=cBmX5vA1oHmD2cF6OgeCbTKk12hZw8i0at0uxlmwSMgbgPlnAz3l3XOygusmqm1pSr
         ItvzPgben8YGt9DrQ59v1Y/8i7dO+y4HhwTyyxVbhnrmnXvuo8QQjmOB4GaTsSz7EpMU
         maPTgnhQ9pXfW7oCVC3TH28jF+zu58gfivz1dIt3khGXAPKxKYpcUV/Gfhtz/CHQZI68
         NRNoXOzvoJjbxHU1Av1t+K3bRBkdZNkoYDzxfg47f7VHyC3IMniY8GkF8Hbc5Qa08TQ3
         zLclYoZ48nYOeZEiksKTxAyZ8Cp/z1ksCvGz2tLQgB3eLZVF/XS2P2CB67GTortDKEZV
         XBUg==
X-Gm-Message-State: APjAAAXuuz7ddrmLmcFDkv6ahofKnCMk/FdOVDhEJkYSvHGK63WtmmzE
        eb/vORpJBpQZEOZXQffyg2IRVCQJHCns+PcnaRQ=
X-Google-Smtp-Source: APXvYqwcTO4zIADNYH0C8DrcWWqvnnvtxN4+t102anOj2O/IMnZ3qyNEMgyL0p2h0qWZC1S/dKLqeaCivCS8g2eOeIc=
X-Received: by 2002:a17:902:1744:: with SMTP id i62mr13608487pli.24.1552812017437;
 Sun, 17 Mar 2019 01:40:17 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 17 Mar 2019 03:40:06 -0500
Message-ID: <CAH2r5mv0e3aZ1upukVL5ZJt8AtqjVQbpw=KuHH1DjYydKoyAaQ@mail.gmail.com>
Subject: Suggestions for POSIX error code mapping for OBJECTID_NOT_FOUND
To:     samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Any thoughts as to the best POSIX error code to map status code
"0xC00002F0 STATUS_OBJECTID_NOT_FOUND" to?

It means an object ID was not found for the file, which is a
reasonably common situation over the network even to Windows servers.

I was mapping it to EIO for cases where tools asks for the object id
of the file (or volume).

-- 
Thanks,

Steve
