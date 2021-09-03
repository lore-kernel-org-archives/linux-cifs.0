Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABEBBC433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Sep 2021 16:54:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F99160F42
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Sep 2021 16:54:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349862AbhICQzL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Sep 2021 12:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349856AbhICQzK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 3 Sep 2021 12:55:10 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D1BC061575
        for <linux-cifs@vger.kernel.org>; Fri,  3 Sep 2021 09:54:10 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id f2so10546955ljn.1
        for <linux-cifs@vger.kernel.org>; Fri, 03 Sep 2021 09:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yMGUPPIVRSPLKaR4AOg15K96eBPIDFLzmbGpGd/opgw=;
        b=fZTvItVv5xOfsoTxrKQTaIz0rYko2gET+WukQ2H3JZnSCqF/GL6j94TC4n6r8APCV1
         G4G/VsdNUGi9cAWg/mZ1USvLC+3aH1Js/ViKoMPEiol6SzaL6xwlw6JFsjbvUkgEq0Vw
         SgSyL6Rf+vgZNSLDQIhCTWqeDCFrkLvjLzz0xsBhnAhI+nk9XBtU/57voh0M6FKkEodW
         vHr3Dc0D9FbH3QpdRVZkOgLju1PbB8XnjFnytj+tRtqAwbBBfk7EqHcE+ENcQ5wrdZ9z
         1U0uuPAKWLVrhWfMaKfEVuZq0ogvle2W33aaUAqt70ZGTqP16xMY2BDz7P1gnRBo2RLm
         EzZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yMGUPPIVRSPLKaR4AOg15K96eBPIDFLzmbGpGd/opgw=;
        b=cuxEm2sdlq4lVecYc/OlJ7ifANzf+nIXXRpLyzLNpb4EXtV3bwF8Ysuyot8Ee8LvV0
         1QmIl4Cc3KMko9xPc1BtjCcMQMUsWBE5FYyLNrsyFRDU5r1opwY+Qos2yKVv+3eyroNa
         54l43yHC8HTuWo3YrxwwtQw4AJA2TF468dUqnC925MU/A2IWVyQ8u0pKhvxpE7YSewnX
         MxpV9OGL1oYn9X2Vp42n+QykaWiqjctbr90qWI377Hgd7GSq+gBhYFHap8uMnvoajLm0
         4NTUUV4atNgj6C6v7LI+muuhlIQZcXFFkC3r1HjlaaMipAd8IgH9akJRdsyFx6aE0dlB
         PALw==
X-Gm-Message-State: AOAM531yuDhtPdWJpMQ9JqQKpLBNpXWrnIIszAZRUJhzDj8N+ORv77Ff
        TXcHqyaYhb4N0WKa2N8n0zf9zUdER/e+2M7d0rU=
X-Google-Smtp-Source: ABdhPJwbE+eMtP1qhkqTQImT/AKTlQytkc8Od3GCQznNCnrxRcGF2pVlEAnhgV3ijPXxEc0yENXYnIvHDGaanEXT1jM=
X-Received: by 2002:a05:651c:33b:: with SMTP id b27mr11570ljp.314.1630688048492;
 Fri, 03 Sep 2021 09:54:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210902233716.1923306-1-lsahlber@redhat.com> <CAH2r5muXpRLNFPisye2NVHa1_G3U6BacZz75P9=kDmZH1Z9n7Q@mail.gmail.com>
 <CAN05THREpo31vmCJB0y2pmDv-Cac3F3igeDxVVFktEOhYfrJkA@mail.gmail.com>
In-Reply-To: <CAN05THREpo31vmCJB0y2pmDv-Cac3F3igeDxVVFktEOhYfrJkA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 3 Sep 2021 11:53:57 -0500
Message-ID: <CAH2r5muE2-r0gtTWW_VzpjxiZvmRLjUoVXT3POa+qGHUycTkkQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] cifs: create a common smb2pdu.h for client and server
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

should be fine in cifs_common - there is precedent in two headers
already, and nfs also has an example where they do the reverse
"include ../nfs/nfs4_fs.h" in nfs_ssc.c

On Thu, Sep 2, 2021 at 10:01 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> On Fri, Sep 3, 2021 at 12:16 PM Steve French <smfrench@gmail.com> wrote:
> >
> > The smbfsctl.h should also be easy to move ... but the obvious
> > question is whether "common" headers belong in "fs/cifs_common" or in
> > include/linux ...
> > (as e.g. nfs does with common headers between server and client)
>
> Maybe. I think things that should never be used by any other,
> non-cifs, modules might be better in cifs-common than make
> them world visible in include/linux.
> Especially things like pdu structures that should never be used by any
> other modules.
>
> But I do not feel strongly about it  so feel free to git mv the file over there.
>
>
>
>
> >
> > On Thu, Sep 2, 2021 at 6:37 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
> > >
> > > Steve,
> > >
> > > Here is an initial set of patches that starts moving SMB2 PDU definitions
> > > from the client/server into a shared smb2pd.h file.
> > >
> > > It moves the command opcode values into cifs_common,
> > > it renames cifs smb2_sync_hdr to smb2_hdr to harmonize with ksmbd naming
> > > and it moves the tree connect and disconnect PDU definitions to the shared
> > > file.
> > >
> > >
> > >
> >
> >
> > --
> > Thanks,
> >
> > Steve



-- 
Thanks,

Steve
