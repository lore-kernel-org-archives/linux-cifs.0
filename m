Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D9F2C47083
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Jun 2021 12:44:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72B0C613DE
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Jun 2021 12:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhFBMqb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 2 Jun 2021 08:46:31 -0400
Received: from mail-yb1-f182.google.com ([209.85.219.182]:46014 "EHLO
        mail-yb1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbhFBMqa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 2 Jun 2021 08:46:30 -0400
Received: by mail-yb1-f182.google.com with SMTP id g38so3582103ybi.12
        for <linux-cifs@vger.kernel.org>; Wed, 02 Jun 2021 05:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=qHVbnrRtKO9AZhpB3zXIQWgc1oKDDN66E5Zre0bVh1U=;
        b=W227I9vA5vG3QJNOKPsHgYS6yLHOX8SL7pUu6PvBklZF16R0nTtWvophU2vl6AvbZE
         CyMTPV3nx9/zWEOw90cylpYj7w2CmdX29bVpb4znupWET0aBgnOqqc/PD8YA8dtlWB2I
         ljsQHNtpFbXKY/Vjl45URSw+428Glhymch094ajyRQx0jLK2V1Ab5qP+F5F+hQFCHAcN
         TTy2FqfF1m2sWzhPYV5vPOJo7xe2BXIsDue/B++XbSjPfiUnFbMI8thalCHUjXbB7YYd
         WvoCAbq2jNwJLhELO/34ZJZnX2Cf/L5ibUlPakqZHv26q2AMojD95+X9Z3BJZivoBnhA
         iXFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=qHVbnrRtKO9AZhpB3zXIQWgc1oKDDN66E5Zre0bVh1U=;
        b=LqAVbrSqUbdKYP9P6LdLxcTHfvUSkZ8DVPbYPoIVHwxU5X+Wq4mQ6lWoSFnvxi0Awy
         L1X2ed4JjciG6vSVYYQxauoPFO2Tty3+bU6aq6+DLjFC/C+0TvoCgVdX30s2SuX8/NMn
         2qld4rpRopKDIId5u9xHn9uqcoAVbY8ZSO7R+kttfYHs4CSbUPtJzbAKU5bUThg619qo
         CgY5nwIUqhMHczo12lU5HIzrFsQVj3O8eyGU21i/UXRwqR5kkJWdCPav9ZRGs9ddMREU
         uFakn8wkXfuP3/WlNGNPs/K05bn6uLORgTGYg5iW/jut0xchEN++FGKgtWg0EmwiZeSd
         DiRg==
X-Gm-Message-State: AOAM5308pN76w6gEWV3DegyFs3ClP8bXUpQZKDXBSaNTjP+We/PiyX2S
        6inU0GnvVN2VCJSfa+7ZlEk+PpVvDiGi+z1cZc4=
X-Google-Smtp-Source: ABdhPJwTOhYDLyneZ89XrQZ6oUDRYXKLJ76qardibmhiQE1BdlXh1Jyb7O8A+DLhatE1NYSmTJMTmcfk68L9B4Bdu3A=
X-Received: by 2002:a25:ef42:: with SMTP id w2mr42583113ybm.34.1622637817022;
 Wed, 02 Jun 2021 05:43:37 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 2 Jun 2021 18:13:26 +0530
Message-ID: <CANT5p=oMLZei+OhXZ-8Hr2NCx=pRYWF1zQ0vRQ5D_NkvLGwJDg@mail.gmail.com>
Subject: Multichannel patches
To:     Steve French <smfrench@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Made a bunch of fixes in mchan reconnect scenarios with these patches.
The reconnect codepath did not play well with mchan. Making it work
involved several changes described in the commits.

https://github.com/sprasad-microsoft/smb-kernel-client/commit/03059a751fa7315ecd44ad61342200d20ab3f0cb.patch
A trivial ref-counting fix in session find codepath.

https://github.com/sprasad-microsoft/smb-kernel-client/commit/2615c7300f93a7ae2d9350da25ed117492f8edbf.patch
Fixes in reconnect codepath, involving changes to introduce a
per-channel bitmask for a session, instead of a boolean, and to
reconnect the session only when we have all channels marked for
reconnect. This makes sessions more resilient in mchan scenarios.

https://github.com/sprasad-microsoft/smb-kernel-client/commit/5bcce1741beea482e770f1c25f4ff285a1505ca4.patch
Fix to get rid of the serialization of requests during channel
binding. This involved passing the channel server pointer to all
negotiate and session setup related functions. This has increased the
diff size, otherwise the changes are quite minimal.

https://github.com/sprasad-microsoft/smb-kernel-client/pull/4

P.S. There is a logic in cifs_reconnect to switch between the targets
for the server. I don't think these changes will break the DFS
scenario. The code will likely take effect only for when the primary
channel reconnects (as DFS server entries are cached with super block
as the key). Perhaps more changes will be needed there to also switch
between the targets for individual channels (maybe use superblock +
channel num as the key for caching entries?). Folks with better
knowledge than me with this code may want to check on this?

@Steve French It'll be good to let a few cycles of buildbot to run
with this code, before submitting to upstream. I have run a bunch of
tests with this. However, more soak time will be safer.

-- 
Regards,
Shyam
