Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A416C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 03:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F3D861156
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 03:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbhIVDBe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 23:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbhIVDBd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Sep 2021 23:01:33 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA48C061574
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 20:00:04 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id t10so5791601lfd.8
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 20:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=r/Oa3CHu4mwOkGGMpUYWM/fpwNUlGKRID/EkX4C8+9E=;
        b=RpELRQtgyvBIhdYKRyqZyxhKXMaMuidq0slkkEcj5hRBo5t++i1fMCtcQ01chApRI2
         U4ZBFe11eTTxLtZFTUt21BzLYmmBaM8qF7lNFSo5KgWL0PDQlNDSFEurlgavNDig4w1F
         txiJjh88zJ1C3bsuckPtJFiZQrMT6sw3OKau2XmTmtJYtktreJk0lPxV073cfkMFUkkL
         nGk/wxG7SvY3SWJzY7fKZVb7EHtxFG/RO1iWl+o753VPZZKPsLAGG4Hhe/ym55kJdkVS
         NsZdHkP7dgsjDPv2aR3dZ73/zufBQQ3laEI+349kwdi5jaxHikNegE9Q/RaXFhd7doU1
         AbAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=r/Oa3CHu4mwOkGGMpUYWM/fpwNUlGKRID/EkX4C8+9E=;
        b=TEM2oLr8EiSWpCOB9vM0/9MMjqtbq2HyHS8XifpKZIrEUSxHw18CAFLU27tHOfxsXC
         JxElVdjNjpuQOa2149C5Xq1wiBOxSoqH7qBdjFx5R+mLxGBqQNgXlKY/grGXM/HkOIEn
         B6EdJqq9kInunLC73D3YpuBRoj+j5Rtc1PgX7aVgsUL//FpOrTHaqK6lyGYD0D2659Jp
         uyrB6mqEWQIkgWxhh+AzCGRJls8eze7n0q4vEYZI1vnljdRqXU6Hq5re5RbrMUp4yYGH
         VONbJyDdhou1nYdoq663faXkQ+/HxUAExTIewAjGh9JqnjqtVe9cvICUGRnajMoTel1V
         ACUA==
X-Gm-Message-State: AOAM531d+othDFrIAbQZUr9A+YFhxr5Mtbce7DjHo8uTD1Wrq/d4onuJ
        m3YJRlunDoqnBpGfhVoWTQVi4rOosNECPcAUQasx4DvjjcQ=
X-Google-Smtp-Source: ABdhPJySuhCBeMTVt7nZrRkHOcGNyQ4AFN9FUU93LsS68vxNQhInNOuVVf4xgdnIp86VBM0nwghP2+pnYx8rJjx+E1E=
X-Received: by 2002:a05:6512:3f8c:: with SMTP id x12mr25877164lfa.320.1632279602572;
 Tue, 21 Sep 2021 20:00:02 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 21 Sep 2021 21:59:51 -0500
Message-ID: <CAH2r5muwjDt1Maq43hywyi9VoOq0wh2TUbnY7U3KD2A9aE04fw@mail.gmail.com>
Subject: ksmbd security review status wiki page
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

It was suggested that we help the ksmbd developers track the security
features (and bugs) very carefully, by creating a wiki page showing
the status of the reviews, and allowing others to contribute to the
reviews and help verify that all missed checks are added.  Namjae,
Hyunchal and others have done a great job responding quickly to recent
problems that have been identified, but it is important that we go
through this carefully.  See

https://wiki.samba.org/index.php/Ksmbd-review

This page includes detailed descriptions of the types of checks:
 - by protocol operation
- and also specifically for path name processing (for open, and query
dir and rename e.g.)
- and a list of all key functions that need to be rereviewed for any
security issues (we have made a start on reviewing some of them and
marking when reviewed on the page)
- and also the current implemented set of SMB3.1.1 security features in ksmbd

It would be a big help if others look through the list in the wiki
page above, add anything they see missing, and help updated the
missing information, and add reviews where possible so we can work
through any additional security bugs in ksmbd rapidly.

Feel free to update or improve the wiki page.

-- 
Thanks,

Steve
