Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F722C47089
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Dec 2022 00:22:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiLFAW1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 5 Dec 2022 19:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiLFAW1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 5 Dec 2022 19:22:27 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1525B1B791
        for <linux-cifs@vger.kernel.org>; Mon,  5 Dec 2022 16:22:26 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id h10so15422864ljk.11
        for <linux-cifs@vger.kernel.org>; Mon, 05 Dec 2022 16:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=H694Zl4fuyaFnmFu6c5KEaMiRGwxTHB1/hDpJCcCWiE=;
        b=qYAubKKB7OSoHz7TqL7MAQGCxhiT2AYQEi9dgcalRstBt2+pjYJzX90cg+gTiSIcms
         Ok5jJbbWDm3FLoslWSyLJmRFqW4+bejT8dOAxNz8aP68azpNWhocK4Zve7RN/8Pba8A+
         PoNvRvWajb/BxYr3dvZjqXCDek+QMHt5OVGdSTvQ7CEmhFxXwIfGExGc0/jRLCp5QGIx
         JYNAOYecKhDqUAX0f4tvzzsGJsvDzzKJV29YUWsNYQUnMsenPp33SwoIyIiw5rzoaydc
         54w+OtrBxh3z/onXGZP6IOVtMIYTb/R8kueR6M3J+9pPbesZPLTh5aSI6T/0zPBO6ATL
         rUnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H694Zl4fuyaFnmFu6c5KEaMiRGwxTHB1/hDpJCcCWiE=;
        b=b7H1+eLD9gkNnRfM5xv2NqNHi3/NupFHu2XgBp3Da1mrzPQUSVZ51v5Xw3iv+fXCvC
         XWrxJ8yBVNvIybDaK9DmKlTHfgbETlgZKHRtQIOvgRxnDsfemWRU46k3pw7WIqI7rVJL
         5DanqqbvWIagJr9guqCTOOYhxNerm7yD/OyB3sk4+6Bvkc9pqtVdqfJBobkP2LVOhzoa
         3iWJUT5vWzPKXsvsEURRxMERPqCb4jVuFhiduxJh7QPH0itz1dvuhg2UfxBp0Ow/sRtt
         cqf7vBBSIsfnHUKxuBpx27egTnzt+ONLLv3rSaiuuQMNxjQPLuTEXAaZ6DJnivfH4cWM
         4KwA==
X-Gm-Message-State: ANoB5pnItBAVCoqC1PTnvunzX92wzi/c4QY5dTXqBEL6Es/cz5MGpdfL
        qC0XKltKyrbBjdY+ySoJuKBqQao02XvDGotf06E=
X-Google-Smtp-Source: AA0mqf4hOep1WmelKygDBBwlxRDMVBjC97s6BQwXHulk6/L+/k9z0uF/xWQSGQY08/S4jZavDn+5gh83pBwKus/EYIs=
X-Received: by 2002:a05:651c:12c1:b0:277:2fd5:482 with SMTP id
 1-20020a05651c12c100b002772fd50482mr22878275lje.194.1670286144170; Mon, 05
 Dec 2022 16:22:24 -0800 (PST)
MIME-Version: 1.0
References: <20221116131835.2192188-1-hch@lst.de> <CAH2r5msoMJ6jNFDtHigKOqq9EwxEb9buxGVi8duW8EMz6wwgBg@mail.gmail.com>
 <20221204081913.GB26937@lst.de>
In-Reply-To: <20221204081913.GB26937@lst.de>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 5 Dec 2022 18:22:12 -0600
Message-ID: <CAH2r5mvZh+5S74fec0o8EGf+OdjP4LaRKsK-FKh-ctf4uzHX0Q@mail.gmail.com>
Subject: Re: RFC: remove cifs_writepage
To:     Christoph Hellwig <hch@lst.de>
Cc:     Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Sorry about the delay - was out of town.

Ran some tests today with the three patch (remove writepage for
cifs.ko) series.  Let me know if any updates for those.  Also let me
know which gti branch you would like to see these merged from (mine or
yours e.g.)

I did see an intermittent  failure (when run with these three patches)
that doesn't appear to be obviously related to yours but am still
investigating it.   Test 043 failed once, and on one of retries of the
group  -  test 045 failed once. See example below.  This looks related
to an issue with deferred close (handle leases) and reference counts
holding up unmount, and not related to these patches (at least at
first glance).   Continuing to debug

generic/043 49s ... [failed, exit status 1]- output mismatch (see
/home/smfrench/xfstests-dev/results//generic/043.out.bad)
    --- tests/generic/043.out 2020-01-24 17:11:18.676861985 -0600
    +++ /home/smfrench/xfstests-dev/results//generic/043.out.bad
2022-12-05 18:11:44.744440542 -0600
    @@ -1 +1,6 @@
     QA output created by 043
    +umount: /mnt-local-xfstest/scratch: target is busy.
    +mount error(16): Device or resource busy


On Sun, Dec 4, 2022 at 2:19 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Wed, Nov 16, 2022 at 12:29:41PM -0600, Steve French wrote:
> > I can run some tests on this later this week.
>
> Did you get a chance to do that?



-- 
Thanks,

Steve
