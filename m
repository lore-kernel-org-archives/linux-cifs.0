Return-Path: <SRS0=AHfl=CY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E65BC433E2
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Sep 2020 08:25:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B85A206BE
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Sep 2020 08:25:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VFRvKmxw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgIOIZO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Sep 2020 04:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbgIOIO6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Sep 2020 04:14:58 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5949EC061788
        for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2020 01:14:42 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id s19so1984841ybc.5
        for <linux-cifs@vger.kernel.org>; Tue, 15 Sep 2020 01:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=3z4hdmUKTqraBA0Uq6EwHsoH2Zas08kdcwUINGeFTp0=;
        b=VFRvKmxwDBFLXc2VP0MBILbQ1NNLgSHR3PK/NQruokyFBGLk7cU83wES9w1ViQO6z5
         K2Wdqt2H/PzJDbdaPoNWQSPWhrDjSnRODRofAzQquHc1YTCKaNXNyrg2ydm3TR/TTxyv
         QZrNmp/6JjHf2F5GG5TLnPFtvTxWw+0Ca0n9EhoZZJjrW+Btlm01/PckeSkdFYrJR021
         bplpejUh9meTodMMVRoAv1ILhGdxEME+1R3jNTwiwSOpmNbg5UbeMOgtuPiyiKffnIal
         qY8wjaQTZhdKZP52/lQJwgHyzgDRRavVzWnY8e4Yu55eFL+YRmT3/wlA7Xjz6t5ygIQr
         vfLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=3z4hdmUKTqraBA0Uq6EwHsoH2Zas08kdcwUINGeFTp0=;
        b=sFjAQxdU1daQ27f5j8C3j5aHh+wR8kcwCY0te5RlVoI19wrWMNrs4ctbfmquOTnFiI
         kZvOfO2yq08KwPnaaw8hcWy7R/ETYCU6HC63Diw02VGb1msCeaNOuRiV0HVtMXDz80TV
         mtD9IpFJguI/iAabmbPxz2u21hjygIg3sDCAI8gLGlzXo4mc8e7DXLz8cruvoUGIRDya
         aItDMJQowGb1skaXnoHVlwksOopJlojAZEEcBZk3j9FlF4yNL4bfWbI4fwrGZefP5TpS
         m976pMTD0KaCDQDRAyYgPta+35tZd0jO5xlBFaXM65hiVqoHtzKr0Zm17sNHu6iYWbXm
         tQPg==
X-Gm-Message-State: AOAM531YET8kgCYMlo7QNeHDj3QtZYJg73vh4nyguIHJtkRuu9/tNo2A
        TEWvxmCldAjpTMFJGXOPjTSWvz6m2P6pkUO/aPI=
X-Google-Smtp-Source: ABdhPJyIXNfgPDc1G/C5R/4/Gh/9/d3vFvK1V5hEIDgPEeBrlAS6i3sUP7hcc/Y2O9ZhjYr9E29pjwYzaGvRiAXlI0c=
X-Received: by 2002:a25:aca3:: with SMTP id x35mr24418717ybi.3.1600157680689;
 Tue, 15 Sep 2020 01:14:40 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 15 Sep 2020 13:44:29 +0530
Message-ID: <CANT5p=rNZoOqt59zaX_C6vnm-a_wFMsEVgAf7_Kemwabfs-a0Q@mail.gmail.com>
Subject: Use case for init_cc_from_keytab
To:     Jeff Layton <jlayton@redhat.com>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Jeff,

Recently, I've been spending some time with the cifs.upcall code which
does a "kinit" for a user using the system keytab file. git blame
shows that you were the author of this function init_cc_from_keytab().

I want to understand these patches mainly:

commit 2dcecd21262513a0866c321643fc33d3d0135915
Author: Jeff Layton <jlayton@samba.org>
Date:   Thu Feb 23 18:28:24 2017 -0500

    cifs.upcall: unset $KRB5CCNAME when creating new credcache from keytab

    We don't want to trust $KRB5CCNAME when creating or updating a new
    credcache since we could be operating under the wrong credentials.
    Always create new credcaches in the default location instead.

    Reported-by: Chad William Seys <cwseys@physics.wisc.edu>
    Signed-off-by: Jeff Layton <jlayton@samba.org>

commit 69949ba0086ac7a4f07ade7558fbe5c537220ebb
Author: Jeff Layton <jlayton@samba.org>
Date:   Fri Feb 24 10:48:57 2017 -0500

    cifs.upcall: use a MEMORY: ccache when instantiating from a keytab

    Using a more permanent ccache is potentially problematic when we're
    instantiating a new one. We might be operating under different creds
    than expected. Just use a MEMORY: ccache since we don't need it to
    last longer than the life of the upcall anyway.

    Reported-and-Tested-by: Chad William Seys <cwseys@physics.wisc.edu>
    Signed-off-by: Jeff Layton <jlayton@samba.org>

Few things I want to understand about this:
1. What was the purpose of this code path in the first place? i.e.
init_cc_from_keytab
2. It looks like we read the cred cache file at it's default location.
Why can't we write the cred cache file as indicated by the env as
well? Why do we want to create an in-memory cache here, and not dump
the TGT in the default cc as indicated by env? Why waste the
authentication which was already done?

The reason why I ask this is because I'm exploring the possibility of
populating the keytab file in mount.cifs, and let cifs.upcall acquire
tickets when needed.

-- 
-Shyam
