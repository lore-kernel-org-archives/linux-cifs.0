Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCCA3C54E94
	for <linux-cifs@archiver.kernel.org>; Wed, 25 Jan 2023 23:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbjAYXoB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 Jan 2023 18:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235793AbjAYXn7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 25 Jan 2023 18:43:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E305E51F
        for <linux-cifs@vger.kernel.org>; Wed, 25 Jan 2023 15:43:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0FB3616C5
        for <linux-cifs@vger.kernel.org>; Wed, 25 Jan 2023 23:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABA0C4339E
        for <linux-cifs@vger.kernel.org>; Wed, 25 Jan 2023 23:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674690180;
        bh=qHk3TpXTZuccOhOJ9OM3fuKdZLCnha39JKERSTcxlhE=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=DoHpMNtbh6GspZM8Tc+fvgU4DROQK2enSMDKVAl1tjoZ9YgeE1e2e1/OG5E3b1xtR
         Q16/nEWniU+QyXP3YPzXr/Nr70g1gWyzEae0p/iMUiSapRB5/kMH2CjXn8djwdAuOB
         5HAIxC6PhLgkh2xi67PMqCHgoJ8yYaCP0lQTlnFTQ7q2/qnPR0nQzg2B3NT2jQ1Nxh
         iMEDXPjqcTawjWccWJE4R1nRnfXp7bkq9VySwsd3Qy0TiM+/J3psN5JBaIjGtsKC4r
         Pgt/CO9dK3n66THra2uaIx1wg0j6AVJIz39NknSjfN3PFh15WoJWW3ht++1oT0xYIG
         eqke25P9zlRwQ==
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-1633e6f83d4so618020fac.0
        for <linux-cifs@vger.kernel.org>; Wed, 25 Jan 2023 15:43:00 -0800 (PST)
X-Gm-Message-State: AFqh2koSlHwP+2St+wMwxYF+KW7Kwtreeg9jVWxk2cXYoT79chzjVowy
        x0kFDKL0AXLlna80ZnU++0hS6jkaXDVZnLxxPjQ=
X-Google-Smtp-Source: AMrXdXvuz63Tl5kePbVOwYXITxHGtvL1gQ3DZNwHgeekGxP9A0cX7T1FD0x2WMY9hqLtil+Q98rA7XpjJPAXThWUbqQ=
X-Received: by 2002:a05:6870:8c11:b0:15f:de79:36c7 with SMTP id
 ec17-20020a0568708c1100b0015fde7936c7mr1320176oab.215.1674690179368; Wed, 25
 Jan 2023 15:42:59 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:6f93:0:b0:49e:db28:779a with HTTP; Wed, 25 Jan 2023
 15:42:58 -0800 (PST)
In-Reply-To: <2341329.1674686619@warthog.procyon.org.uk>
References: <fa35788a-c858-11c5-5d9a-1d5c837020b6@talpey.com>
 <1130899.1674582538@warthog.procyon.org.uk> <2132364.1674655333@warthog.procyon.org.uk>
 <2302242.1674679279@warthog.procyon.org.uk> <3006f2ac-c70f-57d0-8286-ffd5892571f7@talpey.com>
 <2341329.1674686619@warthog.procyon.org.uk>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 26 Jan 2023 08:42:58 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_Zy+7WC=gSsp+3KbQNTCrGgyGoQdZo0aky80NcJfjCBA@mail.gmail.com>
Message-ID: <CAKYAXd_Zy+7WC=gSsp+3KbQNTCrGgyGoQdZo0aky80NcJfjCBA@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix oops due to uncleared server->smbd_conn in reconnect
To:     David Howells <dhowells@redhat.com>
Cc:     Tom Talpey <tom@talpey.com>, Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Long Li <longli@microsoft.com>,
        Stefan Metzmacher <metze@samba.org>,
        Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-01-26 7:43 GMT+09:00, David Howells <dhowells@redhat.com>:
> Tom Talpey <tom@talpey.com> wrote:
>
>> What are you trying to test?
>
> I'm trying to make sure my iteratorisation patches work, including with
> RDMA.
> I have some functions to decant some data an iterator either into a
> scatterlist and into an RDMA SGE array without the need to get refs on
> pages.
>
>> Since encrypted SMBDirect traffic is known to have an issue, I guess I'd
>> suggest turning off encryption-by-default on the share.
>
> How do I do that?  In the ksmbd config?
>
> 	[global]
> 		smb3 encryption =3D yes
I recently changed the input of the smb3 encryption parameters. It is
"auto" by default. Requests/responses will not be encrypted unless you
give the seal option in the mount options. So please update the latest
ksmbd-tools for your test.

man ksmbd.conf

smb3 encryption (G)
              Client is disallowed, allowed, or required to use SMB3
encryption.  With  smb3  en=E2=80=90
              cryption  =3D  disabled, SMB3 encryption is disallowed
even if it is requested by the
              client.  With smb3 encryption =3D auto, SMB3 encryption is
allowed if it is requested
              by the client.  With smb3 encryption =3D mandatory, SMB3
encryption is required. i.e.
              clients that do not support encryption will be denied
access to the share.

              Default: smb3 encryption =3D auto

Thanks.
>
> David
>
>
