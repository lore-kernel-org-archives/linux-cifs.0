Return-Path: <SRS0=T6pO=QX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE73C43381
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Feb 2019 19:40:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52846222E0
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Feb 2019 19:40:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CCU+l+0u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbfBPTk5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 16 Feb 2019 14:40:57 -0500
Received: from mail-pf1-f172.google.com ([209.85.210.172]:40570 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfBPTk4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 16 Feb 2019 14:40:56 -0500
Received: by mail-pf1-f172.google.com with SMTP id h1so6489939pfo.7
        for <linux-cifs@vger.kernel.org>; Sat, 16 Feb 2019 11:40:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=+rf8Be+Mpr00+09Ikv7y0C0lhQEVYoql56AohfU3B6I=;
        b=CCU+l+0uUnz9gk6KilTwNl8KlpB+01yZUEYt5kjgvOxm9VVloJAlCuZoDrXSYUjaV7
         E3kj/6Y3R5Cto/mStUboWj6E86wJLob0zYQ0pdQwCG4jL8nJFD/LwCLFXJrW2I0kXcrJ
         dxJzcqAb0y0M3TrzzqXFa1cSnU7CaWRV9sWx9GePMN5dn8W5ovd6R3GV5xSwOMgKi63o
         9VkezLDgMLy+xtxXjLxcCJN7mwGH/U2eTK5VK7tJsaaz5rPKcThNqpSRgN90rXdK6B9u
         vDq+Ap1ggE0+3jlJZJmriguIHBL7HuctM0HBS8NIqAnAMmzaeJQ9LkZkrsKvQ8feU9Ne
         Keeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=+rf8Be+Mpr00+09Ikv7y0C0lhQEVYoql56AohfU3B6I=;
        b=ZR4DuvSvS0lNkRWjBIk19BrNalvfLCBnoON/J/DK6OZmDplygYslGcXvjRi2a40zrl
         KSWcDzKmCm6ZXVLjFzhXN74A2X4MiJwfHJcCHekhBOrFa1KZ8AvW0Jv704TFVA5Wzp+Q
         QW45fTLJpIAhbDgNPZUnf+qfuBtjhYpkXnu24BlpmeL/V/aVxdxSMHc1d1CByhZN9TZB
         4ZOeUfrMSDWRrtPJ4+kyWup0EPGIpKx8lis2LrVKBf6hElHRgavd0oMcC65YKAwDruBi
         5mQFkVDKDw8IN2EqJja5XJXyXA8o5/DF2TD/zWyGsB0j1Dm164ZHTGrl6UQA4MNmGFqH
         R1kw==
X-Gm-Message-State: AHQUAuYhSbgSuzqOurbSa59PrXobWXPZk2PmJE6WH9ALcwWRbAv5iPgD
        bv4Y4dtYMTG62NJ+KSzq+qdDn/sEqRZy+JP24sSqW/Pl
X-Google-Smtp-Source: AHgI3IafY+HnhOnWepxLQjnV+N2RV9150WVWJqZIZ1dXzzGvLK7Cd92qIwIrI5RV6oQPPRy7GWK3TDhBV0FqHtlan+g=
X-Received: by 2002:a62:168e:: with SMTP id 136mr16269010pfw.116.1550346055961;
 Sat, 16 Feb 2019 11:40:55 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 16 Feb 2019 13:40:45 -0600
Message-ID: <CAH2r5msBMW=pvWiovXeTnVXogwyANArU9zBx4c1S1quGqcz9kg@mail.gmail.com>
Subject: xfstests and current cifs for-next patch set
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

With 5.0-rc5 and current for-next (29 paches) two tests 310 (read and
readdir simultaneously) and 422 (delayed allocation stat, number of
blocks) fail I see this in the azure test bucket in the buildbot).
see this run: http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/80

These don't fail when I select only the first 8 cifs fixes in for-next
ontop of 5.0-rc5.  See
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/82
 so am trying to narrow it down.    This run (in progress)
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/83
has the first 19 (of the 29) cifs patches (ontop of 5.0-rc5 mainline
as with the runs above) so we can bisect which commit causes the
problem with tests 310 and 422.

This seems unrelated to the problem I see in slightly more current
mainline (that we can see with no cifs changes) in xfstest 422 that
was introduced with 5.0-rc6.

Let me know if others (or other scenario problems) see the tests
310/422 failure.

-- 
Thanks,

Steve
