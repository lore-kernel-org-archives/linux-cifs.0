Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B97CC433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Sep 2021 03:01:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2A5C60F56
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Sep 2021 03:01:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234655AbhICDCw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Sep 2021 23:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbhICDCv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Sep 2021 23:02:51 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E589C061575
        for <linux-cifs@vger.kernel.org>; Thu,  2 Sep 2021 20:01:51 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id jg16so5926014ejc.1
        for <linux-cifs@vger.kernel.org>; Thu, 02 Sep 2021 20:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y/OVXvDuDAR0okjyfNr/JnNdFq/R9G4ZWHtYk19cX+U=;
        b=mYzPb8cC66a6GpkVa2Qa9Tc1x/Jhmz3YmL4Nc07rt4G3mit2xJZIJ9Lqrbkls56++7
         uNMrTpjGGuT4SlKmOQV0CqpxCAtifDygUDBgj6LM2g5M8Mo8gOl0nH6T36keqwP0gAQ9
         Nayiub1DbWxydYAthfbFQSJCnjfnIAzrnV0qegMhAk9R/dREX8LOIKRSr+4C31gPqFAQ
         iiwWudXHrO8KkvhLb8tlTRTjQ925aNsPoVW5E0Ejpk68u6F+S68s7+XgSRhf70OpbsG6
         56ya9t1lf5hMDQ06c6AapQngXbdbPvuo9FgwFFE/+DZB4f6y6eahigp+uCMvM/nkcmEz
         iKoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y/OVXvDuDAR0okjyfNr/JnNdFq/R9G4ZWHtYk19cX+U=;
        b=a6tlKjst3GDbBDSqurChxNcy9AzHGcSx3d8t1evwojhnlmsf46GVADTYTLr+WZl5q6
         APGWgBVoEV1FCCSW2x9fbsuAKA0a6Q6ihe8WqfhcT5HXN5UIH/MRu66ugzT9QJR9Porm
         qxsOsId8D2rgt98aafpWfsnUIADKxZkZ9xMQ4/bok6RswcXIp9ML9u4o/wfwZv3/yOrK
         kpiJxTfnbOFbz7nS0AucCNwD6tWdrAj/5itlYzkdz0lFK7mq89g0kaaUwXHCSXheBnq/
         w+tJs+kL378+Q9aMasco2+wI8fPQgK/pgV9jZ/Bjs63xPEnb8sv/y6VijhYErZ5etiNk
         ZKsw==
X-Gm-Message-State: AOAM532Da77VdK3ftwbt5uehEikFQfktlSRKHGrSMu2S4ZPZT75lEwvH
        5h36UZU3KAFWrVaBd56hFqXpzjE2H3MZI7vN7/1nLsw7
X-Google-Smtp-Source: ABdhPJwbDBYG47PmrLebrx9VCqNdsJ17iqE2mKqv2OxyvTlaNGHOKolUGOZQwuhcXLyahMJ0LEyKiR1OUpuXQSdx0rw=
X-Received: by 2002:a17:906:d52:: with SMTP id r18mr1596694ejh.47.1630638109946;
 Thu, 02 Sep 2021 20:01:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210902233716.1923306-1-lsahlber@redhat.com> <CAH2r5muXpRLNFPisye2NVHa1_G3U6BacZz75P9=kDmZH1Z9n7Q@mail.gmail.com>
In-Reply-To: <CAH2r5muXpRLNFPisye2NVHa1_G3U6BacZz75P9=kDmZH1Z9n7Q@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 3 Sep 2021 13:01:38 +1000
Message-ID: <CAN05THREpo31vmCJB0y2pmDv-Cac3F3igeDxVVFktEOhYfrJkA@mail.gmail.com>
Subject: Re: [PATCH 0/3] cifs: create a common smb2pdu.h for client and server
To:     Steve French <smfrench@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Sep 3, 2021 at 12:16 PM Steve French <smfrench@gmail.com> wrote:
>
> The smbfsctl.h should also be easy to move ... but the obvious
> question is whether "common" headers belong in "fs/cifs_common" or in
> include/linux ...
> (as e.g. nfs does with common headers between server and client)

Maybe. I think things that should never be used by any other,
non-cifs, modules might be better in cifs-common than make
them world visible in include/linux.
Especially things like pdu structures that should never be used by any
other modules.

But I do not feel strongly about it  so feel free to git mv the file over there.




>
> On Thu, Sep 2, 2021 at 6:37 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
> >
> > Steve,
> >
> > Here is an initial set of patches that starts moving SMB2 PDU definitions
> > from the client/server into a shared smb2pd.h file.
> >
> > It moves the command opcode values into cifs_common,
> > it renames cifs smb2_sync_hdr to smb2_hdr to harmonize with ksmbd naming
> > and it moves the tree connect and disconnect PDU definitions to the shared
> > file.
> >
> >
> >
>
>
> --
> Thanks,
>
> Steve
