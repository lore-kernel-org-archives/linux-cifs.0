Return-Path: <SRS0=GFFJ=XG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5777DECDE27
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Sep 2019 05:24:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 281A721928
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Sep 2019 05:24:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I17guJ+d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725379AbfIKFYu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 Sep 2019 01:24:50 -0400
Received: from mail-io1-f42.google.com ([209.85.166.42]:37766 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbfIKFYu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 11 Sep 2019 01:24:50 -0400
Received: by mail-io1-f42.google.com with SMTP id r4so42995283iop.4
        for <linux-cifs@vger.kernel.org>; Tue, 10 Sep 2019 22:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gC+StTiefWzyBTRgGPssIYo3St+v+GS9PY3gxWMJrHQ=;
        b=I17guJ+dzzy3X53Bej2yOLdGXqMqUL2PpN1aixw0FudvsFfGYPoviQ5YAxBtdoTtOt
         IujOdsk8skUVnoYmVLBURFy8rdJ0QTe04D6DAwR8JULsoncEgju/DpxsMceV5WNulQc+
         eHqoWr8gWTh+oMJkhbQyF3sJ1Leeso33t8ez5JqSMWStDdulHK31FeM6NxC+U9CW6sYP
         ZufvDsodO+7o2PqMxI9j0TBGOlOvlEVOcHL44Q65sKgWWDgqy4nLzwvXvYej+K0adE23
         TnKUzzbH3WFuSNjPU8vU6Vbxydx21aSsrBL07oD+3Oe78jOBY7+nUtrtJt7zu+2+qGT+
         zjDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gC+StTiefWzyBTRgGPssIYo3St+v+GS9PY3gxWMJrHQ=;
        b=jqo57YW5AU2cf+jeCG2AkZxOqIW1mVPSuqVXPRiiG2jWY6u+tBnhiE8fegAV1t2eKN
         1vS1hIfuEC6EmwS+prqu1+IWrKjL+HikHptxxx55/utdSiEYWSR07z7D3HM5rjvMcgoY
         cvON+C6/homlRCYqVY7j7atO4bxWPTUzH8Jv8rX9CoLiHIofVQaoEwlKcrdxr1kYw70R
         lLufwuDVz3Bd4kiL3roX6AftHqMKOxUijLOxU8sL6/DwOaRaV6USAMheGfjGIM1yyJtd
         ZhgsCohpvFB0u/mS7ITbI7FtUNPGnCgmhm3QgNQbYaZkevODR9QDwZvQK33fYqpY6mxg
         lZYg==
X-Gm-Message-State: APjAAAX3Z+v/VYpgVUoC/y/CCYozy0AbFkg3+1nMGMFpse2ehxeUv4bh
        nQ3xPaz9oO1j6Vh7rnNmfxnknSmE1tgi5/sfIHfyLg==
X-Google-Smtp-Source: APXvYqzEn1PN4Zr9xzhRqtNHP2FqV7OE/+OpBa3mjD4pr7miIX+Ti41vd5RjBWdwHcCRVH/0Isr6eSYToc9kgku/gPU=
X-Received: by 2002:a5d:894a:: with SMTP id b10mr14493653iot.49.1568179488383;
 Tue, 10 Sep 2019 22:24:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtFA5c5XxL6ohwyGqj=zPc0mUR1_VNvcMyhrZZJuwcBPA@mail.gmail.com>
In-Reply-To: <CAH2r5mtFA5c5XxL6ohwyGqj=zPc0mUR1_VNvcMyhrZZJuwcBPA@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 11 Sep 2019 15:24:36 +1000
Message-ID: <CAN05THSjpqqgXgfvDndFyZS2TwyvKDCNMSfxxgMApQVECk=cSA@mail.gmail.com>
Subject: Re: [SMB3][PATCH] Fix share deleted and share recreated cases
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good.


We also need to handle the case where the share is deleted but is
never added back.

On Wed, Sep 11, 2019 at 3:15 PM Steve French <smfrench@gmail.com> wrote:
>
> When a share is deleted, returning EIO is confusing and no useful
> information is logged.  Improve the handling of this case by
> at least logging a better error for this (and also mapping the error
> differently to EREMCHG).  See e.g. the new messages that would be logged:
>
> [55243.639530] server share \\192.168.1.219\scratch deleted
> [55243.642568] CIFS VFS: \\192.168.1.219\scratch BAD_NETWORK_NAME:
> \\192.168.1.219\scratch
>
> In addition for the case where a share is deleted and then recreated
> with the same name, have now fixed that so it works. This is sometimes
> done for example, because the admin had to move a share to a different,
> bigger local drive when a share is running low on space.
>
> --
> Thanks,
>
> Steve
