Return-Path: <SRS0=COnU=XH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01FF9C49ED9
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Sep 2019 07:22:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C871521479
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Sep 2019 07:22:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l8erAlqG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfILHW5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Sep 2019 03:22:57 -0400
Received: from mail-io1-f45.google.com ([209.85.166.45]:45935 "EHLO
        mail-io1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbfILHW5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Sep 2019 03:22:57 -0400
Received: by mail-io1-f45.google.com with SMTP id f12so52101096iog.12
        for <linux-cifs@vger.kernel.org>; Thu, 12 Sep 2019 00:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qnnBn+SZ4v0P83O2zx0v8u1iki5NbL0knBgkgi8SgCE=;
        b=l8erAlqGDiSGD3MAyg7NYUI0yNJrHma6vpei7hR0diShQq8iWt+aQgBvY4Vd/Mc0ZW
         fFmWUpdyP//zzZD03qej8unRCfBHwWWMxAdOeOTQkwrMiot8EKJ7rcJ1lAJsmZ09m0es
         a30EU8z+OtTFgPJZBDM1Updm2ed7yBXS79JTzEKOTLZLAqlh6A8J3LPmFmfES6UFxWDu
         gkDAemCYwvWdwf//vQUkOAjOXial0SYeGpHfUbAeFo67myquVmuNmC/2M/xdsWP2/w/j
         U6pLpY9GAtXPDBM/c2kh4Pk9V/zpwVV4eCtWKcqM8g83FD8f6Sac38OuD9wj5+9ZLORF
         EU4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qnnBn+SZ4v0P83O2zx0v8u1iki5NbL0knBgkgi8SgCE=;
        b=YNL0GfNOWXhfP06D+8cggC+vEGtB+Y8/RH1LZ32mB1DWeTqSW2xLwuyHNgEtbVGWX/
         K+nB/DChQb/oRE58Lr+Omg+k6lFbN/9XMk8JOZTwQwPW5lIm9I19ADtrXysooA9ZrUP2
         yRq9CznLgPT2O/WIvQVIwiJOO27PBg4QzUWF4Mc0c07VDtn1dytq1XPau3dUMNThn4Th
         EKHb+CcR4Q3t5H61lvGkHUsV8hwEoMhRcT9FvU62Gm0hb9YipILod7YdvRq8Ji+Tik4U
         HKWkFLwudD2kQ++tL2LH2/np8MOr8EdVNxpqYcgMXZ0TZK2b2iEB0IkzqiQ+VVQIyY81
         FZdw==
X-Gm-Message-State: APjAAAUYUW8VCGuHNoAxRkY5oF2MlpggfkLyqISdt7dRLC0OBsmZ/gNz
        0e8F3fLMpRDrLnN3QO/psK6AgxTut1gPxlIp/oo=
X-Google-Smtp-Source: APXvYqy9QiHwbL8UiFczwxRn4mU+CIuvOXTswA0SGLqJjV7nT3fXIhUkoDJmcsSzyed/tacbWMTYvhrW7etA2arGd34=
X-Received: by 2002:a6b:8d06:: with SMTP id p6mr2030779iod.219.1568272976463;
 Thu, 12 Sep 2019 00:22:56 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtc2A-s1is6eZXZx5neDWZs_4aSW_Tx72PH8sBA4pmqhg@mail.gmail.com>
In-Reply-To: <CAH2r5mtc2A-s1is6eZXZx5neDWZs_4aSW_Tx72PH8sBA4pmqhg@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 12 Sep 2019 17:22:44 +1000
Message-ID: <CAN05THSKORVny25_fR6wgK1noJ_DoLHHucpwVhvDD_zNJeHL0A@mail.gmail.com>
Subject: Re: [PATCH][SMB3] allow disabling requesting of leases
To:     Steve French <smfrench@gmail.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed by me.

We need a big patch to the manpage after all these new mount options

On Thu, Sep 12, 2019 at 5:03 PM Steve French <smfrench@gmail.com> wrote:
>
> smb3: allow disabling requesting leases
>
> In some cases to work around server bugs or performance
> problems it can be helpful to be able to disable requesting
> SMB2.1/SMB3 leases on a particular mount (not to all servers
> and all shares we are mounted to). Add new mount parm
> "nolease" which turns off requesting leases on directory
> or file opens.  Currently the only way to disable leases is
> globally through a module load parameter. This approach is more
> granular (and easier for some) as Pavel had noted in a recent suggestion.
>
> --
> Thanks,
>
> Steve
