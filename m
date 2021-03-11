Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=BAYES_05,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04BACC433DB
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Mar 2021 19:55:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE4AD64F80
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Mar 2021 19:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhCKTzF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Mar 2021 14:55:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbhCKTzC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Mar 2021 14:55:02 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E97EC061574
        for <linux-cifs@vger.kernel.org>; Thu, 11 Mar 2021 11:55:02 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id y1so3736921ljm.10
        for <linux-cifs@vger.kernel.org>; Thu, 11 Mar 2021 11:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=9bRrSUHYhZA8NTAkaYTMFIA3G+IRBOVgXJxr4dld+F4=;
        b=CHBUsb9m7nGfPE2/n/7kLVExM1kZb8Ld96pNbNDl2nS7JCXCohmypcayyAxgRAb8Ht
         sq4LS2IT9GEDTDaweAkcKBXwsM/76+IDvU2WrDiin/LBCcsuQjzn9QiZzqzcjXalmmZu
         bmwssOsa25fm2/w8IEWHpV337oo0upG91q8GN/kiMbJkF/tJRPrBVjtRD2qTkBYZRirR
         VLpPQDQ95XnHKHCkNfhVd521CJT+W6Kf66PcGcbr5xFn+RaOKFx+pb5VI7R/BwNgQF8Q
         HdifA3sBpt3Sc/xTaYgeMo7p1zE3j7KL91CRWriNERw/Qi/32kH0KMi/elJLW4vioQtQ
         K9Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=9bRrSUHYhZA8NTAkaYTMFIA3G+IRBOVgXJxr4dld+F4=;
        b=O4guYL2oXYq58Zju/Z3/R+N/T+UGh+CSRBV2FX94Q5LYe4N3lJ9XKicJLyd3fRbq5L
         YHHAhJtSbksSKtfkxPUWRAAL/awmRN+j7SeZ+j7K0hJYfw5g8DXDr69dyh/uB0iIUqOq
         YJUoyqgfR+Tnx+HoUKS9IHUac92jlAUaVL3TLZ9Ruhf+q+ijYtqZcHCFojzH3sPalNbL
         Wve80GedIOddgNsBG83tfX+o1aBjpgqXofJYMhdaM2tJdWC6PLZOvfzHqkWCMCUdoCj7
         ZV4q6gBkivzIbqSJ1K2vib5wsyiW1S67zbJVTx9bOWznvgB6LllWAKXId/fLSaBWUTSd
         Q/2g==
X-Gm-Message-State: AOAM531+5d8s9YDsZ+WpoSVtg0v9GuMkdahMz491bb0Zsc57/lKbjOVr
        81lhjfySoqUBgUFr4s26ZCkiOb2wm8LondVIi0r9y26lQI4=
X-Google-Smtp-Source: ABdhPJxaxHt+UuXqFGSmd1tIblh5LIrpIrpRGyRmmJFXxlq3zm+TBZLpzEh4ez7g/OWl3/z95WenR1xyok2zKzHzB2k=
X-Received: by 2002:a2e:96d5:: with SMTP id d21mr311562ljj.148.1615492500388;
 Thu, 11 Mar 2021 11:55:00 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 11 Mar 2021 13:54:49 -0600
Message-ID: <CAH2r5msr1FREG1HY=mY+fnPjTwH0xvL0ku=+kPzPeJpF7+C=Qw@mail.gmail.com>
Subject: cifsacl and xfstests 554 and 569
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Debugging the swap tests cases in xfstests can get a little strange.
Tests 472 and 554 and 569 work to Azure but not Windows (when mounted
with cifsacl for test 569 and modefromsid/idsfromsid for tests 472 and
554).

-- 
Thanks,

Steve
