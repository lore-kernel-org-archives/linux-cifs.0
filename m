Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7822C6FA82
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Sep 2022 23:46:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbiITXqr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Sep 2022 19:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiITXqp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Sep 2022 19:46:45 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912BE4B0FF
        for <linux-cifs@vger.kernel.org>; Tue, 20 Sep 2022 16:46:44 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id u9so9936380ejy.5
        for <linux-cifs@vger.kernel.org>; Tue, 20 Sep 2022 16:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=YlluWgCfETNgn4FFmeLmQWLo6/k4gnwRT2ed+plKflE=;
        b=Cpu2mfkHnGSO7rqOxzUATm3rgUx29NgI5Y0mkXu9YoCJXLVEtozVFpHbM/x/h6XV3Z
         3lHxxsztHZDWJZAdb6oLmmi0h3TOai+gsjlOiErIrLlNgrJHCOijYVhr8TNtKDo2/Enq
         ExVT24ImYZnyRCpKaMpIzjbmAil00vOC8ZQKmcG7oATDbLsNG9NA/I1YId72yfhvtr6i
         etfcYsuO3uAo5x+Z56JFzAD94EMbg2ltcFAG5H/CT8U1QPFReQcPmeD8YqsRZAaSkAid
         5nrbMQcoHMlN7481r1ppfIjGwvw1/8R9fjerz6fTE1Sk0LCc7TuqaVMerzfxmZlmRk/c
         nlCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=YlluWgCfETNgn4FFmeLmQWLo6/k4gnwRT2ed+plKflE=;
        b=vqW4WlwvyeeLGS8xQjubd+M8NCkzVeWNGYZnyinlwAqzWmsc3B5DjtgHtZuaerzZbI
         fi5GRqYC5lkJYbR64PENzjt9s5JYj5bARVlr+nWYOxWBocTWhrh8WBgOfxMIBXHz5dUC
         TNEZkk6Kr98vbfjBKeGvJ+sWRmNEYW9eMOrOodVCRU+rLLVR/EcMotLUaR7ffNmzlBqG
         97yRBwEhK0jUN9E90jsNkvALAfKYWUsl+//wGjTHtZdYS7GqD7oHxUwwid2WSuEuyJDi
         7MGaQquD6Hs4/oi7eDKdgjuPEGAd9T1TA5uuCwaFNS5paVXzyYYaBQS1iSdfWR1whbeg
         ZhPg==
X-Gm-Message-State: ACrzQf0RFOcbG02sKINAIBFn7VqnAcxd+1StVtHYWIqkFz6pOKvXHSgb
        Sx44QDWMuMkm9uE7LS57t1hQXJoUdcJLR+MUuQcBdi59
X-Google-Smtp-Source: AMsMyM61NHAX2DfJVJKQWdMKyllCnk8WVlF9pnIJ5IL0wZdF2+k/x3RAdIWVQUSurJXjuX0e59cVPAtdelqqT5WHzV0=
X-Received: by 2002:a17:907:1b12:b0:72f:9b44:f9e with SMTP id
 mp18-20020a1709071b1200b0072f9b440f9emr18877894ejc.653.1663717603117; Tue, 20
 Sep 2022 16:46:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220919213759.487123-1-lsahlber@redhat.com>
In-Reply-To: <20220919213759.487123-1-lsahlber@redhat.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 21 Sep 2022 09:46:30 +1000
Message-ID: <CAN05THS+oteC6=RiWTPx-5P7paAg9HpHyXLkL2z0QpJ=Sv+Mpg@mail.gmail.com>
Subject: Re: Updated patch for the corruption with cache=none and mmap
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I have also added a test for this to cifs/109 in the buildbot.  (After
fixing a previous issue in the test, the tests pass now with the
current patches applied.)

On Tue, 20 Sept 2022 at 07:40, Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Steve, Enzo,
>
> Updated patch that removes the redundant conditionals that Enzo pointed out
> on the list.
>
>
