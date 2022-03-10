Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0989EC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Mar 2022 02:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbiCJCMq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 9 Mar 2022 21:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiCJCMq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 9 Mar 2022 21:12:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E428211B5C8
        for <linux-cifs@vger.kernel.org>; Wed,  9 Mar 2022 18:11:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8346FB82327
        for <linux-cifs@vger.kernel.org>; Thu, 10 Mar 2022 02:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38BBCC340EF
        for <linux-cifs@vger.kernel.org>; Thu, 10 Mar 2022 02:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646878299;
        bh=W0XUCYC17+SxMm29JaGqyE7XcmwNIT8SFCnptf3gXAI=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=hG1NzyOMUprfjonW1LGYC2FRA4P7aergQbKC51AiCy9xi6wAt0YAEggvZjQ/nFHZb
         EWDUy1sUqG1qEPvjB76h+mhTiil5u9OO2Dcc8HMclC7KwZOZCTkz97V88REkrJA7ea
         p9P5WYQaJmsEfKjFE69kBb+vZhDGRfgFXTQU36KpJSae4IsG4g95hrPbHCi68/d/yt
         ZzNtyK5zUeMIfemaND7TZGnzxkrgP+nGTiaSSEY6RsuRpew9LuXjZzDyQBt9nEFabD
         lAjR7QK89OObwKtVveuv3L40Yd00GoCi4sxfXYkXJy+AsXwrEL9Fd74HJ07WXFz3Hj
         s4Jo5EEgB2IPw==
Received: by mail-wr1-f45.google.com with SMTP id j26so5752489wrb.1
        for <linux-cifs@vger.kernel.org>; Wed, 09 Mar 2022 18:11:39 -0800 (PST)
X-Gm-Message-State: AOAM531TX/D/51aFTckobJFA8iLM9e40lH3KbcUzcfthvDBlbT734RSr
        znsYzvXa62s+u89l56PNOSgST+XO/y2VNMWTFQw=
X-Google-Smtp-Source: ABdhPJxpg1/vRuK1xONoc59T4R/lhsOQq+uaD2/LF6Iv88cSsrn9PF7cIN3rLur8i9nI1cTCm3rva9Z/eGwWS7biJsA=
X-Received: by 2002:a5d:4387:0:b0:1ed:a13a:ef0c with SMTP id
 i7-20020a5d4387000000b001eda13aef0cmr1720798wrq.62.1646878297468; Wed, 09 Mar
 2022 18:11:37 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6000:1d93:0:0:0:0 with HTTP; Wed, 9 Mar 2022 18:11:36
 -0800 (PST)
In-Reply-To: <20220307013344.29064-1-ematsumiya@suse.de>
References: <20220307013344.29064-1-ematsumiya@suse.de>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 10 Mar 2022 11:11:36 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_NK53bi3kv0ftqKw=7HK0c2xJOWtYudpMDws=dN99Hrg@mail.gmail.com>
Message-ID: <CAKYAXd_NK53bi3kv0ftqKw=7HK0c2xJOWtYudpMDws=dN99Hrg@mail.gmail.com>
Subject: Re: [PATCH 0/9] Unify all programs into a single binary "ksmbdctl"
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, senozhatsky@chromium.org,
        sergey.senozhatsky@gmail.com, hyc.lee@gmail.com, smfrench@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-03-07 10:33 GMT+09:00, Enzo Matsumiya <ematsumiya@suse.de>:
> Hello,
Hi Enzo,

First, Thanks for your work:)
>
> This commit unifies all existing programs
> (ksmbd.{adduser,addshare,control,mountd}) into a single ksmbdctl binary.
>
> The intention is to make it more like other modern tools (e.g. git,
> nvme, virsh, etc) which have more clear user interface, readable
> commands, and also makes it easier to script.
>
> Example commands:
>   # ksmbdctl share add myshare -o "guest ok=yes, writable=yes,
> path=/mnt/data"
>   # ksmbdctl user add myuser
>   # ksmbdctl user add -i $HOME/mysmb.conf anotheruser
>   # ksmbdctl daemon start
>
> Besides adding a new "share list" command, any previously working
> functionality shouldn't be affected.
>
> Basic testing was done manually.
>
> TODO:
> - run more complex tests in more complex environments
> - implement unit tests (for each command and subcommand)
If testcases are added to .travis.yml, It can be automatically tested
whenever a patch is applied.
> - create an abstract command interface, to make it easier to add/modify
>   commands
Could you please elaborate more what is abstract command interface ?

And totally looks good to me. Please run checkpatch.pl on these patches.

>
> Enzo Matsumiya (9):
>   ksmbd-tools: rename dirs to reflect new commands
>   ksmbd-tools: move control functions to daemon
>   ksmbd-tools: use quotes for local includes
>   share: introduce share_cmd
>   user: introduce user_cmd
>   daemon: introduce daemon_cmd
>   daemon/rpc_samr: drop unused function rpc_samr_remove_domain_entry()
>   Unify all programs into a single binary "ksmbdctl"
>   README: change to markdown, updates for ksmbdctl
>
>  Makefile.am                        |  14 +-
>  README                             | 100 -------
>  README.md                          |  57 ++--
>  addshare/addshare.c                | 172 -------------
>  addshare/share_admin.h             |  15 --
>  adduser/adduser.c                  | 180 -------------
>  adduser/user_admin.h               |  15 --
>  configure.ac                       |   7 +-
>  control/Makefile.am                |   7 -
>  control/control.c                  | 128 ---------
>  {mountd => daemon}/Makefile.am     |   2 +-
>  mountd/mountd.c => daemon/daemon.c | 401 +++++++++++++++++++++--------
>  daemon/daemon.h                    |  55 ++++
>  {mountd => daemon}/ipc.c           |  27 +-
>  {mountd => daemon}/rpc.c           |  21 +-
>  {mountd => daemon}/rpc_lsarpc.c    |  13 +-
>  {mountd => daemon}/rpc_samr.c      |  22 +-
>  {mountd => daemon}/rpc_srvsvc.c    |  11 +-
>  {mountd => daemon}/rpc_wkssvc.c    |  10 +-
>  {mountd => daemon}/smbacl.c        |   4 +-
>  {mountd => daemon}/worker.c        |  32 +--
>  include/config_parser.h            |   2 +-
>  include/ksmbdtools.h               |  24 +-
>  ksmbdctl.c                         | 182 +++++++++++++
>  lib/config_parser.c                |  15 +-
>  lib/ksmbdtools.c                   |  26 +-
>  lib/management/spnego.c            |   6 +-
>  lib/management/spnego_krb5.c       |   4 +-
>  {addshare => share}/Makefile.am    |   2 +-
>  share/share.c                      | 227 ++++++++++++++++
>  {addshare => share}/share_admin.c  |  97 +++++--
>  share/share_admin.h                |  44 ++++
>  {adduser => user}/Makefile.am      |   2 +-
>  {adduser => user}/md4_hash.c       |   2 +-
>  {adduser => user}/md4_hash.h       |   0
>  user/user.c                        | 238 +++++++++++++++++
>  {adduser => user}/user_admin.c     | 263 ++++++++++---------
>  user/user_admin.h                  |  44 ++++
>  38 files changed, 1458 insertions(+), 1013 deletions(-)
>  delete mode 100644 README
>  delete mode 100644 addshare/addshare.c
>  delete mode 100644 addshare/share_admin.h
>  delete mode 100644 adduser/adduser.c
>  delete mode 100644 adduser/user_admin.h
>  delete mode 100644 control/Makefile.am
>  delete mode 100644 control/control.c
>  rename {mountd => daemon}/Makefile.am (95%)
>  rename mountd/mountd.c => daemon/daemon.c (55%)
>  create mode 100644 daemon/daemon.h
>  rename {mountd => daemon}/ipc.c (95%)
>  rename {mountd => daemon}/rpc.c (98%)
>  rename {mountd => daemon}/rpc_lsarpc.c (98%)
>  rename {mountd => daemon}/rpc_samr.c (98%)
>  rename {mountd => daemon}/rpc_srvsvc.c (98%)
>  rename {mountd => daemon}/rpc_wkssvc.c (97%)
>  rename {mountd => daemon}/smbacl.c (99%)
>  rename {mountd => daemon}/worker.c (95%)
>  create mode 100644 ksmbdctl.c
>  rename {addshare => share}/Makefile.am (74%)
>  create mode 100644 share/share.c
>  rename {addshare => share}/share_admin.c (68%)
>  create mode 100644 share/share_admin.h
>  rename {adduser => user}/Makefile.am (69%)
>  rename {adduser => user}/md4_hash.c (99%)
>  rename {adduser => user}/md4_hash.h (100%)
>  create mode 100644 user/user.c
>  rename {adduser => user}/user_admin.c (52%)
>  create mode 100644 user/user_admin.h
>
> --
> 2.34.1
>
>
