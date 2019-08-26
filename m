Return-Path: <SRS0=RY9s=WW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0028EC3A59E
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Aug 2019 06:55:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CCF2217F4
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Aug 2019 06:55:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=monash.edu header.i=@monash.edu header.b="TZ29GlZ2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729437AbfHZGz7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Aug 2019 02:55:59 -0400
Received: from mail-qk1-f170.google.com ([209.85.222.170]:41377 "EHLO
        mail-qk1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728033AbfHZGz7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Aug 2019 02:55:59 -0400
Received: by mail-qk1-f170.google.com with SMTP id g17so13239138qkk.8
        for <linux-cifs@vger.kernel.org>; Sun, 25 Aug 2019 23:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=monash.edu; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=q2LTA7CZW3gpxBvIJltRc7WeWp1FSGcqC7hJfmrsbzM=;
        b=TZ29GlZ2WaRyZVhQRkm50uDGrPOTma8qoFMLMvFrGR/edKqpxJheIqxYwbQv55FbY3
         QVM36VZhDx/bMbtvzFRLpPvIfY5AVobfFT6klYYJkb04nOlJcK6voc/E6hq0/OsXpEkL
         Ao9cjyZtvWL4/V1IupfRM0T5Zac8iya8aNfrcmxqE9l4T+z4A8UUD+BZcj6aGkRBNF26
         ngHWIK3IvL6q+D03DHvEG/SEEXL+RoExnoLRO8cfDuHInp0Jk7U/SuyiWwWuzXAxtsVF
         Zi9A7W+FR4uxkal5EBGCSnAtxNitqwGO/XWKXKSwWjjRmcZssR60OZVh3SBtc0ztxE3L
         BG3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=q2LTA7CZW3gpxBvIJltRc7WeWp1FSGcqC7hJfmrsbzM=;
        b=I4DZGE2Vd8NLie89pzlcc4GqUGQJOoe7rZlwiySRjYCS0PZ28b91SllpRia2Ma8x7X
         gh8ZrxGOxQdu9vYe9AMoHCQPThEx5+Gc15yaL2NljHkuS7EikgFFMGznzJurOlz0utog
         vn5qiQ1aQF+X7vv+692P09cVPNSjw6FwUqpYyxrllAy1fzbqYmg9c/iueNn0oOESsBWi
         czU11682HwBg8Lbk6MIjN7VjmRMCRyGIAgvgzgFVtxhNrmamNbzkxWKk5rRGo6nRMpHJ
         errljMrP60T30fEx5j6KZLHVQt2JFVdqw62wmE+v2UpRbW5sWOkvM9J+1/TCgWwMD+f6
         g3yw==
X-Gm-Message-State: APjAAAXX7l0xEDRmUonpGL/QjisNrvhtmebPfluDR3Eu9JFCB07nLSmp
        33XFWORPuV80RIQUe1dWq0FY0JXk8U6UH+sE2z8N4MyFt2Q=
X-Google-Smtp-Source: APXvYqxzoxSxxYcnoC1xLMdzsreEb4CyXf1/ZPW7vNRHQbnLyu8yBbV0FzbZNzGJXX47syGBpMooLwF2NsKFNXByTNU=
X-Received: by 2002:a05:620a:632:: with SMTP id 18mr15614535qkv.205.1566802557756;
 Sun, 25 Aug 2019 23:55:57 -0700 (PDT)
MIME-Version: 1.0
From:   James Wettenhall <james.wettenhall@monash.edu>
Date:   Mon, 26 Aug 2019 16:55:47 +1000
Message-ID: <CAE78Er-YVBzqaf8jCBio_V_1J2kRiWZ_SH-HnHm7KG3t46=j6w@mail.gmail.com>
Subject: Frequent reconnections / session startups?
To:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

We run a Django / Celery application which makes heavy use of CIFS
mounts.  We are experiencing frequent reconnections / session startups
and would like to understand how to avoid hammering the CIFS server
and/or the authentication server.  We've had multiple reports of
DoS-like hammering from server admins, causing frequent
re-authentication attempts and in one case causing core dumps on the
CIFS server.

Our CIFS client VMs have the following:

OS: Ubuntu 18.04.3
Kernel: 4.15.0-58-generic
mount.cifs: 6.8

Current mount options:
rw,relatime,vers=3.0,sec=ntlmssp,cache=strict,soft,nounix,serverino,mapposix,rsize=1048576,wsize=1048576,echo_interval=60,actimeo=1

We don't run the CIFS server, but we can request any information
required to diagnose the issue.

Over the past 10 hours, one of our virtual machine's kernel log has accumulated:

8453 kern.log messages including "CIFS"

To break that down, we have:

8305 "Free previous auth_key.response" messages
111 "validate protocol negotiate failed: -11" messages
26 "Close unmatched open" messages
7 "has not responded in 120 seconds" messages
4  "cifs_mount failed w/return code = -11" messages

The server is an HSM (Hierarchical Storage Management) system, so it
can be slow to respond if our application requests a file which is
only available on tape, not on disk.

The most common operation our application is performing on the
CIFS-mounted files is calculating MD5 checksums - with many Celery
worker processes running concurrently.

We would appreciate any advice on how to investigate further.

Thanks,
James
