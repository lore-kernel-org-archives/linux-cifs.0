Return-Path: <SRS0=EeRJ=6F=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4BB2C2BA19
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Apr 2020 04:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B214E208E4
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Apr 2020 04:23:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I87b6t3H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgDUEXT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Apr 2020 00:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725730AbgDUEXS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 21 Apr 2020 00:23:18 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8FBBC061A0F
        for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2020 21:23:18 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id l5so6684006ybf.5
        for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2020 21:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=eDZW2mHdBXstG6Ls5f6VyykFoiU7c4nJSuLfTb8PW2Y=;
        b=I87b6t3HKK6psRogsi6DEGrc9+F7QZJe9tWS2Y63LO1HQubp8M/8b13Z29glekX3Xs
         NRpPTVKeo/OymwWEXoAtc5bviVURbWXtwux27ZoO2AQA6CQRPJG53fEWbDbbo+QPI+xP
         iO9mh1UqvpTab5gLqv13zbMS5IEja8t14FVg2rInWGtL9zEzUdQT3xOqUrkqs7pGmgAk
         tFWOQ4AetkZX6ieKts9t0SiwOaeB3KgGc9PFdGOfI2/1LmR7LsoT7i23amDhNKDzYZuL
         +m+K8AYPoOWwy/f53z1qvWVGKX469ok/KIC3c59SAJCaTQe5u8JoRfGWOGLSvt07bCpO
         zs/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=eDZW2mHdBXstG6Ls5f6VyykFoiU7c4nJSuLfTb8PW2Y=;
        b=Z94sWxQwGq+NZes55Dqs0cw/pTXgIbvRDtcBFVrxPW5X59B1+N3fDuIEA4WncxSsD8
         A9hWmpgtFWeshfzpWv7EZWix20NcDyPh7vcdkMujOsofFtKIztcZdS/IQkYxbcg7CW3T
         7fnDG6Q0rLhzhT7rglS/SuqynOtUmc/LIsoeSbpX9JxcPar+I9EEwnJJSfcGpPvoKu0c
         1v7CKWGpWQ6vnGWj3TDIMp6H66Chz7ryOlJudt9d0HPzl6DiPLDFDg5uxV1hNamLg8F5
         lka7KglcJfQ6K+ZkcoFjoqoqHk8zH8kvlLszkkIaWR96xKHPn572DBNrmjG08zmgSBaU
         wtXQ==
X-Gm-Message-State: AGi0Pub9MWa8dOMTlq20xlsh6O/5DZgJnSXAZy9p0mqnlNifxQismyDo
        T8W1V6fAa3zCkipZRdx1lAZHLc7Gj3LvOT5wlnuHxR1z
X-Google-Smtp-Source: APiQypL9zSgrayZvvaqbMD0CwrXUlAboTH+sNjsgnKPIc3fCucSTKqKbBj+3zzqu07vizZq4d3ydZ/Kqaj7A9/5ywsM=
X-Received: by 2002:a25:aa0c:: with SMTP id s12mr24480516ybi.183.1587442997787;
 Mon, 20 Apr 2020 21:23:17 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 20 Apr 2020 23:23:06 -0500
Message-ID: <CAH2r5msSe_j8xyRd7noarQ-9mkiS4WmM+6w1+kLP1gYf+=0avA@mail.gmail.com>
Subject: smbinfo --version
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Do we need to add a --version (or -V) option to smbinfo to display the
version number (as we do with mount.cifs e.g.)

-- 
Thanks,

Steve
