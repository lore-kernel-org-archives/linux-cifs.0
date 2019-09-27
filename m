Return-Path: <SRS0=ovf2=XW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FAE3C4360C
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Sep 2019 08:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53D22217D7
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Sep 2019 08:05:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rgBxjCxj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbfI0IFX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 27 Sep 2019 04:05:23 -0400
Received: from mail-io1-f50.google.com ([209.85.166.50]:41449 "EHLO
        mail-io1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfI0IFW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 27 Sep 2019 04:05:22 -0400
Received: by mail-io1-f50.google.com with SMTP id r26so13976107ioh.8
        for <linux-cifs@vger.kernel.org>; Fri, 27 Sep 2019 01:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aII4M2SwZO+GRDmd3nm0B9UpYMTlksmgmY752Xryfwg=;
        b=rgBxjCxjhPdcbOfu4hiaChXBj51sjdBd/pOIfRwcGb+gHt0bYoxcDGmZBzFmhe4/ui
         2YKrQX3qA93oZbxUdftjoSrdCYpGdvZTLDz8clv7fXMwSNIa1XygnIOaX5KTQMA4dYbw
         oT7z7CECOUmtiGIbWpJpqQasaug3PjG0RVD0LDrbcLrrbR0fDPp2ijbckxj16XvZxCYl
         oJbh6VgOaK3DLAhFbJu2heVPX6FhSRCBOfTKyIC3wUnTMyN6zL4Di0Z87y2WGC/ZLran
         TSnOWrVXNhN2kfJLugBVMGjaTe0mjnzUGaKgTD832t70AbOrd6FP40h2j44cBtGGt2JN
         T7dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aII4M2SwZO+GRDmd3nm0B9UpYMTlksmgmY752Xryfwg=;
        b=KMPy6YdBmMvmnvYJvL+q7tB1rT/++svFd/EI+PDwapwYKys4m03lchvvajX2n8jaOs
         EfZv45yRbHZJPSty7QtDWPTRrJwq10gcXN+AcCVZ0pZ+QL0u9wCYne7jYQlV41lwRMW9
         8yu+PbZb847JjhKWmAUtAWD8d92sSQ0Whir/iQuXEKyrZX6wsi2H2mainwskp3heaMfW
         LHQJXhXUgcpnA0cfn2iH6o69q/ygVdnopWDS2r6Oc7v7hQQQQCQPSTIhz3gODeHcy2dj
         zIRkVTUHOzCyJWNK9KWikSQmLK53cXGXXNPE0J2rY73fTBwcB98xyFIdIZxagpLz5LWA
         YseQ==
X-Gm-Message-State: APjAAAXXXtRLimoLGomrr8AIyAyBc0Pl3GtoXatbCI0aQ52cZrQqhiKf
        EPI34t+7eZ2X9AihzhO8IUbW20DmIdNxHohrYYs=
X-Google-Smtp-Source: APXvYqyy5KszHwxSTkUamxhjSmdfrXjsdptssDmQF/MWhvmTa3qKwsUQDohWBRPumTR2JE1fiwGXLHlJ55ffxIrjQ+E=
X-Received: by 2002:a02:3e91:: with SMTP id s139mr7333168jas.22.1569571521958;
 Fri, 27 Sep 2019 01:05:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mueOCtAsWjOc3n2OgnygSMmj22uycsvfNKPAiqhx68xsg@mail.gmail.com>
In-Reply-To: <CAH2r5mueOCtAsWjOc3n2OgnygSMmj22uycsvfNKPAiqhx68xsg@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 27 Sep 2019 01:05:10 -0700
Message-ID: <CAN05THT-hc84ZOK-c7ZAxRitCKWDVtRCJpvBzYfv9=CqpSNdmA@mail.gmail.com>
Subject: Re: Getting the SID of the user out of the PAC ...
To:     Steve French <smfrench@gmail.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Please don't.

You can't get the sid from NTLMSSP

On Thu, Sep 26, 2019 at 11:39 PM Steve French <smfrench@gmail.com> wrote:
>
> Is there a way to get the SID of the user out of the MS-PAC through
> Samba utils (or winbind)?
>
> This would help cifs if when we upcall as we do today to get the
> kerberos ticket, we were also given the user's SID not just the ticket
> to use to send to the server during session setup.
>
>
>
> --
> Thanks,
>
> Steve
