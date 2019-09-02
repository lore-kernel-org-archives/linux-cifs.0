Return-Path: <SRS0=HOJ7=W5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E068C3A5A4
	for <linux-cifs@archiver.kernel.org>; Mon,  2 Sep 2019 00:23:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1600A21744
	for <linux-cifs@archiver.kernel.org>; Mon,  2 Sep 2019 00:23:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=monash.edu header.i=@monash.edu header.b="HThed39q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbfIBAXq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 1 Sep 2019 20:23:46 -0400
Received: from mail-qt1-f174.google.com ([209.85.160.174]:41719 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729163AbfIBAXq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 1 Sep 2019 20:23:46 -0400
Received: by mail-qt1-f174.google.com with SMTP id i4so13958430qtj.8
        for <linux-cifs@vger.kernel.org>; Sun, 01 Sep 2019 17:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=monash.edu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q6lakCCnhlnA1yhPcvlcr3Hr91fQuL2Ay4fc5a36s10=;
        b=HThed39q3wVl+lil8k3Mj4NTzl/FmPudYoJQKnb75qGRcSNoaEoDPzl+i9vW7p1J+/
         ZdKbR0prmI4CvlXkTl5JsxF3RBFeghgkzzst8UN07KtzkrN+hMgOD9M4N36imfBPt9fC
         NmbhgWYKCG5PIJTBwLTTraMvmLH9eQsf7caxr9kUnQ2u+3o9ZZr64axl38rKTh4wTa+4
         r+XBLOjc6QwOhigglLkJlwXVji/gfgPDEOVO1VrZf5NOMsWe2JFzAT/t/1iHTSsMQZb/
         AggOAhh/csF449+60WQlLmStsL8riwo/XpTZMns6FfWncFhG+U0no2L4JO1BDhAiFK0c
         pCsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q6lakCCnhlnA1yhPcvlcr3Hr91fQuL2Ay4fc5a36s10=;
        b=O1uekRL12Db0vQagOCdY2wJSJxXlwju9tCC25mOMvxaaWBWa+S/qhSvB7S1UzkVOt5
         jPRV9C1Iu2PPANot4N0XyyakQzSae/7VsQMjxDIpPgWasyUR+V0CW8IiItTazoqlfkR4
         t8aN0nb/JPJW5T3n6M9mLCtOSIvSakjT3r50m1TcYPoqGtMRXBF4vIEh8guRPsy//Zwx
         m2igQztOG6edLH1HFBY2V3GFEZuiZLTr4+clr8vMm2Bfzwa0FKHiWWUn4fl8zRaTnQ7S
         3nbV6agS7Rh3ZJoUu8F6fPihgSW090isTyaAjr8f447GC8sDHMgA+iRikQEk4ccfrBlP
         JtMg==
X-Gm-Message-State: APjAAAWNdTabhav4UJ3/MC9c2NLCXs0++yhi6tVi4Kn66OHC28HpMGT2
        VsYyMHiqPpvPraFqPn4D9FxzrFn+5LEGuteTtFkq8Q==
X-Google-Smtp-Source: APXvYqzfh83a++FiarSKN40GgqytSC5mXYjBssv4rqQukv58pTT7L7oDY15INCJDYrRyatbTjUgr7v1A3IK3xJM+jnU=
X-Received: by 2002:ad4:5145:: with SMTP id g5mr8554767qvq.127.1567383824801;
 Sun, 01 Sep 2019 17:23:44 -0700 (PDT)
MIME-Version: 1.0
References: <CAE78Er-YVBzqaf8jCBio_V_1J2kRiWZ_SH-HnHm7KG3t46=j6w@mail.gmail.com>
 <CAH2r5mu446ssSPrACP8q859Cs0ynUMpJopH0t5qAsR=sGrByFA@mail.gmail.com>
In-Reply-To: <CAH2r5mu446ssSPrACP8q859Cs0ynUMpJopH0t5qAsR=sGrByFA@mail.gmail.com>
From:   James Wettenhall <james.wettenhall@monash.edu>
Date:   Mon, 2 Sep 2019 10:23:33 +1000
Message-ID: <CAE78Er8KYhRts+zKNsP6_11ZVA0kaTrtjvZPhdLAkHqDXhKOWA@mail.gmail.com>
Subject: Re: Frequent reconnections / session startups?
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

We've been running the newer kernel - upgraded from 4.15.0 to 5.0.0
using Ubuntu 18.04's LTS Enablement Stack - for several days, and it
has certainly solved the frequent reconnection problem, so thanks for
letting me know about the reconnection fixes that went in almost a
year ago.

The only negative we are experiencing since the upgrade is that our
VMs sometimes become unresponsive - appearing to require a reboot -
with kernel messages like this:

[74146.705917] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[74146.716713] rcu:     (detected by 0, t=285034 jiffies, g=15795253, q=11)
[74146.718805] rcu: All QSes seen, last rcu_sched kthread activity
285035 (4313428844-4313143809), jiffies_till_next_fqs=1, root ->qsmask
0x0
[74146.723702] rcu: rcu_sched kthread starved for 285036 jiffies!
g15795253 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
[74146.727649] rcu: RCU grace-period kthread stack dump:
[74160.609964] watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [cifsd:2854]
[74172.594002] watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [cifsd:2441]

I wonder if this could be a different symptom of the same underlying
problem?  Of course we would prefer not to have production VMs
becoming unresponsive, but maybe this way, we are detecting and
containing the problem earlier, so we can take the required action
(reboot), instead of waiting for our CIFS service providers or
authentication service providers to complain about the frequent
reconnections?

Cheers,
James
