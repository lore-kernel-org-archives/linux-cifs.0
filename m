Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C56DCC4332F
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Nov 2023 04:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjKBEs3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Nov 2023 00:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjKBEs3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Nov 2023 00:48:29 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99249A6
        for <linux-cifs@vger.kernel.org>; Wed,  1 Nov 2023 21:48:26 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-50943ccbbaeso614971e87.2
        for <linux-cifs@vger.kernel.org>; Wed, 01 Nov 2023 21:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698900504; x=1699505304; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jUK2OFOHdQ/M+3WjJ/KELS0HXDPAQ2YgwHWn93QqnPo=;
        b=BEPr6qXDmtwTjOLLqyMUMCkUNHg+y6R468cin5jG/LwwB/mu8xxbZJn/y+h+Ia5mZi
         hqb+TsJEatsm32cmvzONE1EDIWuwCtTrXT9BCMFy3OlP/pgt/H1alEqjtT4dI4QwYx0K
         0LSUY+nZo60pJLF+ID2P0QA+tKDfjrJiKmGY7BdLRF7yH6e7gT+1H8XB+mAIFmemMCUa
         FveEK6Xm378Rh/B7bgJ7ks0+I7dnXUL6wpGCzrxaYftSvntN5OwI48doMU9ershpkb0q
         cMb9iq7cXyM6z8zRS1YZoUdl0E5mWt0pAY7a5J5zz0fV5iqKPMAxRIaJePlcT2LIU15e
         cwmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698900504; x=1699505304;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jUK2OFOHdQ/M+3WjJ/KELS0HXDPAQ2YgwHWn93QqnPo=;
        b=koeGiErxJmNdpwkZyu9pZSF9A7SZbN0kEl7jCYrSxqduGvVCF+Io6RV0tB3mDtpQG+
         xz2zhH+MHY2p58EMn3xfEspI9/V8BGm3ZJSnPEVEhr9nSGOH4uUUkfGRO8xGzI7vO4lJ
         yDjGfNi1STDzmOaPGGUWYGHtQQwIuGfHMBNcG8j3TIITahdIi61mCcJbJX+Ud0eqJUrh
         WARpPR0EZhebOHjJd07xtAECTwGYbvjmAxV4v+fNsLgQEfKhTUVyt5dbuJXDZkmRV6eb
         G3l0dCf9J37Cr8bLYcf1v63hMZ/jF/yfd/Cx8+metPpVOWnVrKWdP2mEGqd+tFmGS6lf
         CD1Q==
X-Gm-Message-State: AOJu0YycZwpWuNlUKvu8y0LUb7ebH7TmD3SO7VRnrntf9XGRQj80FNnT
        nf4KAlHwk9r7QIi0HtG1ylhrfyifGiRLVNWlh63cglBksto=
X-Google-Smtp-Source: AGHT+IEF/LSZq7klBx3ImkNzZXYRNVO1cRm/CCnHHJHtQq5UIB2UQjobYQirEDFzsMCSGXRoNrWVUdwxfg6KwteRres=
X-Received: by 2002:ac2:54bc:0:b0:4ff:9a75:211e with SMTP id
 w28-20020ac254bc000000b004ff9a75211emr13026150lfk.42.1698900504309; Wed, 01
 Nov 2023 21:48:24 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 1 Nov 2023 23:48:13 -0500
Message-ID: <CAH2r5mvwvguCuvt4yU=vEuWeZBYrYuSwt9smvj14zX25wb0SKg@mail.gmail.com>
Subject: Experiments with password change
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I was doing some experiments with changing the password for a user on
the server then forcing a reconnect (which as expected gives
STATUS_LOGON_FAILURE repeatedly until the mount is unmounted).

When I tried to do a "remount" with a new password I expected it to
fail but it did not return an error (as it would if the session were
up).  Looking at the traces - in the example where the server is
unreachable - then specifying remount causes a readlink to fail with
EINVAL on the mount point (presumably causing remount to exit out
before it calls the fs to reconfigure the mount context - so it
doesn't get to the place where we would check the mount parms
specified and fail)

Any thoughts? I was hoping to make a minor change to allow us to
update a password for a existing mount (where the mount is currently
down - ie when we are disconnected due to LOGON_FAILURE)

-- 
Thanks,

Steve
