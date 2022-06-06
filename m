Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85E03C433EF
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jun 2022 05:42:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiFFFmr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Jun 2022 01:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiFFFmq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Jun 2022 01:42:46 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C205B846
        for <linux-cifs@vger.kernel.org>; Sun,  5 Jun 2022 22:42:44 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id n28so17317361edb.9
        for <linux-cifs@vger.kernel.org>; Sun, 05 Jun 2022 22:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CeftkUezjB0S8LUXq75AktLO55X+JbY7sztBjqZZ+m0=;
        b=hbr6q9/MjfzWXaMWJaZfBSYhTr+yqUIN8CfUno1yCO2j3TJqgT4nduLcVTU3Pt4qnC
         epQT4c6Qw1RVOSraAyAHLK2bz5e6mJAgEjNUFYj5subslnqSuwzqkupE6pJUThndFaSc
         d03hKFzj6pMbPueTRA8tRgbblavHPKvgH0RBjDAT9RcZqsNXyOtvzrGzKn1E8h0mKPq6
         9iPDmBN1bmgYmvd4i+/h6L0Uu4Ciw/qAbJj8Q1tpS0we9P1/DLFENkgwrEI4eBqQVMud
         YbKD4R5eTUADwmto/RDqjru8jGFZHRRFmZ2Mgi6WSIo9gLmujZ4myrMEREehGNq5uqPu
         hT/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CeftkUezjB0S8LUXq75AktLO55X+JbY7sztBjqZZ+m0=;
        b=1ZETca0H9ty6N0+B91KeR1r0otRS8KL19fyvKaJSaKW4UOVn3mTTmTCGyTP522pCAK
         5xk6p9thY3nkOtnGWxss13cqLQQOP91QYduk8VHQt0XkD+OVc9YbdkV6u2nxhP3FWE4k
         3e8zMQWqQ1RMGSIOz6JGGwX9EAKa5ICuTnCwk6nqhxo+bVB2V1a2squCCcyfRBmz54KV
         oryTcVfqwDhyzwihiS/lNXUqNMCyApkkJZhLunUp8YoxWkx6GCbpmUy5w3cqvQWS6KUE
         aLVId8DJ2cerU+ENpG9qyl7lMJA4p2lkgXD+VutSleiWUqB9ZqPgsanPtZI7npTQgZX+
         6ifw==
X-Gm-Message-State: AOAM533RG74PG7GcrANvhL7YS1ZCESKnU5aRnYf32mnzgardATuefG8f
        rqLwwgNYxK3BVWNLLy4B5ENb9lE055WwJoy/6QRdeuwpIeM=
X-Google-Smtp-Source: ABdhPJzaRb3S5865/t6y2jJy03a8u/+ipQ5LF3NOX/TB2lV/lM//xJJTrQjXsDHOWAVJ3ASfgcONUp72gGngyl67igo=
X-Received: by 2002:aa7:ce84:0:b0:42d:ce51:8c6e with SMTP id
 y4-20020aa7ce84000000b0042dce518c6emr25445922edv.10.1654494162660; Sun, 05
 Jun 2022 22:42:42 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=pfEF91j3frZFJgxMLU6XmaC-pn=_oQnOF2BQPaj7Bh+Q@mail.gmail.com>
 <874k1m3b56.fsf@cjr.nz>
In-Reply-To: <874k1m3b56.fsf@cjr.nz>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 6 Jun 2022 11:12:31 +0530
Message-ID: <CANT5p=rRTWpBR6MKiXrMtH0r_PD_jKyLhUhM_Of_oev=7rybDA@mail.gmail.com>
Subject: Re: Multichannel fixes
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Paulo,

Sorry for the late reply.
Good point. Tested basic DFS mounts. I was facing setup issues while
setting up DFS for failover.
Steve will be running the buildbot DFS tests anyway, which will
contain DFS failover.

On Thu, May 19, 2022 at 12:45 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
>
> > This time, I've verified that it does not break the multiuser
> > scenario. :)
>
> Thanks!  What about DFS failover scenario?  :-)



-- 
Regards,
Shyam
