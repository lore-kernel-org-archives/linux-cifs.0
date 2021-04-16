Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32C96C433ED
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Apr 2021 18:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01D596137D
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Apr 2021 18:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239488AbhDPS4R (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 16 Apr 2021 14:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236466AbhDPS4N (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 16 Apr 2021 14:56:13 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5B5C061574
        for <linux-cifs@vger.kernel.org>; Fri, 16 Apr 2021 11:55:46 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id x19so15891241lfa.2
        for <linux-cifs@vger.kernel.org>; Fri, 16 Apr 2021 11:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=dspdFmmMU9hrcpWkzCZAOBEW2/CFETxqS7fH1drKSLo=;
        b=rtOD//MM9vaHhf8PgiGQUhjpJ/QBc6lTik1hmxA/jHtmmwVUaOO1ZGl1A+Pr5w4rUc
         ryKhhTi3mjefngErGxjjG8aRFOnkrSttBzPVLLZDRQQlr1y760y5L4AIyX6tPvyAznrm
         tExUCmT9mI9s7KDj0WPI93IXrM6lqz/nBQojYszjJ6GNm1+cacbMDt83GpdIe4c7TyCd
         cu0NR+JOqjdNpZ2MqMz4ZJCuUx9yqLpbsos9fV1JiIupnkLN736RZPo1pMd2BtTrKrk2
         9ekM7IDHmvC0A0uGfV+dIIzQ6wcWQQpK3rSm5yBgGFoZusTIWucG/W0LpJ60Yse4CvnS
         4JIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=dspdFmmMU9hrcpWkzCZAOBEW2/CFETxqS7fH1drKSLo=;
        b=XQYGMh2JMMJCUh+Kc5ObM6jHE5AtzNX9C7lcy3FrAKoHJUPak0qghj0j5OmMUipAft
         +obiHGPi/SNgKZ72F1ye9ltSG5ZFDhOJc6AzulSA1d3iu8k6HggZ39gjjRxO9JjT9Vi0
         zhkhvokU16ugE+kZm28FQjTnP58oFef2Ydg7+pmlE3ZxnxerpIt6if1r/Nb6ayWOPy24
         SdgkQn06VCUjJgNkfWCP3jTW70rnj3JTDKMqkpXm2UJPAxiniZTVB3a0F+8up9QiK75F
         UG++4gLdjEW2hPJvKlfP17AWcx11ZET77OitDZLhL3/og2yo7WF7sO9y2zurb5yakKXi
         MWlw==
X-Gm-Message-State: AOAM532qJfCM5hWaNTrHrFwX39xE29TtgpxX2cmQ4B5VCg/JBUhS+2U/
        m0ea3jDqG9sPw2U1h8e/YG+LSTSKSael64+kqNVgyFmG
X-Google-Smtp-Source: ABdhPJxwXpncP6VFWku6hTivpVSNVremY/dXOQq16ngVqt+gA71ijHyyynN0LV/hTUrSYepC30tFpYjNjsh4biRpPm8=
X-Received: by 2002:ac2:5cab:: with SMTP id e11mr3946211lfq.175.1618599345266;
 Fri, 16 Apr 2021 11:55:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtjCnXosTKnV7J33=T4aVxD4kkkU6PcuHisMw=trLycbg@mail.gmail.com>
In-Reply-To: <CAH2r5mtjCnXosTKnV7J33=T4aVxD4kkkU6PcuHisMw=trLycbg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 16 Apr 2021 13:55:34 -0500
Message-ID: <CAH2r5mu581SM=A3r2PucVO486tVR7KSuSjnL0JC0mbaWSCH+fQ@mail.gmail.com>
Subject: Fwd: Deferred close patch - performance improvements
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

---------- Forwarded message ---------
From: Steve French <smfrench@gmail.com>
Date: Fri, Apr 16, 2021 at 1:55 PM
Subject: Deferred close patch - performance improvements
To: rohiths msft <rohiths.msft@gmail.com>


I noticed some significant improvements in perf of some xfstest cases
on the latest buildbot run (and some test cases where perf got worse,
but fewer cases of that) with Rohith's recent deferred close patch (it
is possible, although less likely that some other patches in for-next
contributed to the performance changes - it is probably mostly due to
Rohith's patch). Some examples:

cifs/104 improved from 28 to 4 seconds, 85% faster
generic/011 from 8:24 to 7:28, 11% faster
generic/032 from 8:10 to 5:34, 32% faster
generic/117 from 5:35 to 5:01, 10% faster
generic/239 from 1:41 to 1:22 19% faster

But a few got much slower:
generic/070 from 5:08 to 8:48
generic/100 from 3:44  to 5:10
generic/263 from 3:32 to 10:17

Although there is some variable in perf on individual tests due to the
usual temporary load factors, overall the run was 10 to 20 minutes
faster (5 to 10% faster) than usual (which will be helpful going
forward in multiple ways) with current for-next, and is promising.
--
Thanks,

Steve


-- 
Thanks,

Steve
