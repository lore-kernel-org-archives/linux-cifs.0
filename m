Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB4AC48BCF
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Jun 2021 14:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 764806139A
	for <linux-cifs@archiver.kernel.org>; Wed,  9 Jun 2021 14:44:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236549AbhFIOq3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Jun 2021 10:46:29 -0400
Received: from mail-yb1-f182.google.com ([209.85.219.182]:40816 "EHLO
        mail-yb1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236867AbhFIOq3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Jun 2021 10:46:29 -0400
Received: by mail-yb1-f182.google.com with SMTP id e10so35829779ybb.7
        for <linux-cifs@vger.kernel.org>; Wed, 09 Jun 2021 07:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=hR1kDHgE4G7eNHc4NZs6vH3sDBt5Uoz19ntcd5wj0nc=;
        b=a/vCw6maMv3YC0uNst5VTsMT80lF7E0+tZaVcsV8f9uXs/bcJOM5zfCb8443ujNpY+
         SLaf5sckDC7g5LjlnjmIciHWjoUBu4xIzYwaQ0BzjPME2F5+QvGtXsp2ICo1omWO1bM9
         XZ11UDJXQZRSdkQ9hnpib9riItj2KXMw5XtDmKpzedsHMl1pj5eiX89rfa2QCax4fl+K
         Pm3jJoRRjcy0soJfzHhbsdUb3fIChSmnEJZ6lrNyJ9is3yU+tw+u3ts6F+rh4nSPdTSb
         Y7n3+bdVvTMt6b8Fpfou1EX6Y643kJ2YWxIbD2r90k0t3A/VZM/U9Z0hPCmXK5WlGQzx
         ol3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=hR1kDHgE4G7eNHc4NZs6vH3sDBt5Uoz19ntcd5wj0nc=;
        b=fbmMJcHo43xeYkCvw61KEjxru4Tez2tMJqXh5VHNcMx1HBg9475LaqOQJcPMGcPmUH
         cTMBY4kotCVkuK4Wa6I1jziS3LJILQRLabm7wfKY8wk9Nqu34rt9BJtSn8bQrXFPBXG7
         Nb2tzOaYTjrPbKihQXxp4GzAUBkdr4wvujHhrJo5vRAbH+9HbSn4yWLlFAeTxAzXuwDt
         qOMWZ9d2RvmagDkdfPQDjLdYNZyoITXD9hgUshJg6ehcoNls5UgyTgwzT8z6Hx5pP2gp
         X1q+XnVyfEQJlYb44c90QW8d9OeCUXwRMJnfOvKM/dAxA3SsEXq3s2AoiV+8qewlBFW4
         0pYA==
X-Gm-Message-State: AOAM533+IPM6awmhFmpwZHQzDzmZ69+YTyE2727Tra3ICzsNSvJDKN7j
        YBlr/YKkRtY6cU8mU4DFIzjJ+py8066u4XqgZIU=
X-Google-Smtp-Source: ABdhPJzlcd1/lrq+OWMpBNuAkRHpqy0dOWMXsC69TluYi6jPHlqr5N9HowwYPDKyao1RjHh6YiUG3BI/ZeDuYwpNUe8=
X-Received: by 2002:a25:ef42:: with SMTP id w2mr521836ybm.34.1623249814157;
 Wed, 09 Jun 2021 07:43:34 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 9 Jun 2021 20:13:23 +0530
Message-ID: <CANT5p=prtZ5ZZGSrFFb4sOc_+-tytDpL1s4VzMnsk1vGq2d5Jg@mail.gmail.com>
Subject: fscache metadata query
To:     David Howells <dhowells@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi David,

I was exploring the cifs.ko implementation of fscache recently for a
customer use case.
For this use case, I felt that it would be quite useful to obtain info
about what data (pages) are currently cached by fscache. Is there
already a mechanism to be able to get this information? Or is
something planned on similar lines?

Even if fscache provides netfs a way to provide callback functions
which can get called when older data is culled by fscache, the netfs
can maintain this metadata internally.

More thoughts?

--
Regards,
Shyam
