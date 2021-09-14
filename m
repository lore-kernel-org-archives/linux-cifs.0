Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A42A1C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Sep 2021 04:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B13260F35
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Sep 2021 04:14:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhINEQH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Sep 2021 00:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhINEQH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 14 Sep 2021 00:16:07 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A775C061574
        for <linux-cifs@vger.kernel.org>; Mon, 13 Sep 2021 21:14:50 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id s12so21316367ljg.0
        for <linux-cifs@vger.kernel.org>; Mon, 13 Sep 2021 21:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fk5npy068OgmDV0FJiWIYC2aMiqadNbg9v3BldokMwQ=;
        b=WM/itaV7eQFGJhf+ut/Gi991yYdBohhD7SdazDTHAFwv9VKd2vKHKooUE7AahtWbzS
         Wp+wcfn/hQsFUTnag8WVBYE4qhYDs0ruiKKAHTifyfSIQTyPlC64ooFV9YctB5diCtH6
         Dsmd48SRDriWu/kBiO9jpIwghSPzYTwI47c2QX0pe5ogfX404H+fxwOZpUKDlhefJ9Oo
         /ubitx4mgD2k25hp4/5q9Nkf8nU5n2Zmlle21O8ZH/NjhBJeSMnL/T8h8UdTEkMwVm/k
         nWIYjjOU8xfu/odao53UkeakVe0K0gxFSTIZvjiY7gKqTClmGVKBSSV6Vl+S9yjhUFXd
         kn6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fk5npy068OgmDV0FJiWIYC2aMiqadNbg9v3BldokMwQ=;
        b=S+UxzQK1mH/0msnzj7YSEQyIGxlBQI1C/RiHtPzzK0LKWNfqvfHpbq1mrIYWmUgEV0
         LvhpI6k25bP3CB7hbpb485CfxytM/ajFqsvTqgXeYO1C7fLgG+/iCA7WI78mpkCzGS4n
         g8MO3r7ZJe1946NdAs9W0tFo+yRYrVkBxH5p60Euau5fVJPyRel6BWtS28PHGfHkDJgE
         X2dvqTct0JIzo36VS54QcU+Vrvm5FEdmKfYJqumBdROLnPBFrDS/DvDe7hSJU2CFMK39
         pU30qVjlnydLvmaslcwKQIvwtW3heUYnGIpjFn+yf4DojOGFt4Bw7/0NiUt3cTPMzIVk
         /hHA==
X-Gm-Message-State: AOAM531d7t04A6C59lnkEuR73fTuQsYVeg7lURo6ZrHtnW5paGSNBpgl
        2LXp9eFWi4sog4IBjUdt8OzbJEkKyuEGuYietk9Iz5IX
X-Google-Smtp-Source: ABdhPJzaLLNRj8vrhhNRwLPGqsQsPoHZir/7AzhIrkrQkQ4S574j5Ukleo7R8h5NRI086wb9A70pZCg+yq/6UqcW0sU=
X-Received: by 2002:a2e:4e01:: with SMTP id c1mr12814315ljb.460.1631592888353;
 Mon, 13 Sep 2021 21:14:48 -0700 (PDT)
MIME-Version: 1.0
References: <202109132243.2u0FFC0r-lkp@intel.com>
In-Reply-To: <202109132243.2u0FFC0r-lkp@intel.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 13 Sep 2021 23:14:37 -0500
Message-ID: <CAH2r5msMZFtQt-u+5bw=hXTe4J_s8ugb2JR9RLCP4+9J3Pkzmg@mail.gmail.com>
Subject: Re: [cifs:for-next 1/1] fs/smbfs/cifsroot.c:83:12: warning: no
 previous prototype for 'cifs_root_data'
To:     kernel test robot <lkp@intel.com>, Paulo Alcantara <pc@cjr.nz>
Cc:     kbuild-all@lists.01.org, CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Paulo,
This doesn't look like an error - there is a prototype for this in
init/do_mount.c

Is a change needed? Or something to quiet the buildbot ..

On Mon, Sep 13, 2021 at 10:00 AM kernel test robot <lkp@intel.com> wrote:
>
> tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
> head:   bba805a46c91e7a8a1d04704e5409f890acf8b66
> commit: bba805a46c91e7a8a1d04704e5409f890acf8b66 [1/1] cifs: rename fs/cifs directory to fs/smbfs
> config: x86_64-allyesconfig (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
> reproduce (this is a W=1 build):
>         git remote add cifs git://git.samba.org/sfrench/cifs-2.6.git
>         git fetch --no-tags cifs for-next
>         git checkout bba805a46c91e7a8a1d04704e5409f890acf8b66
>         # save the attached .config to linux build tree
>         make W=1 ARCH=x86_64
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
> >> fs/smbfs/cifsroot.c:83:12: warning: no previous prototype for 'cifs_root_data' [-Wmissing-prototypes]
>       83 | int __init cifs_root_data(char **dev, char **opts)
>          |            ^~~~~~~~~~~~~~
>
>
> vim +/cifs_root_data +83 fs/smbfs/cifsroot.c
>
> 8eecd1c2e5bc73 fs/cifs/cifsroot.c Paulo Alcantara (SUSE  2019-07-16  82)
> 8eecd1c2e5bc73 fs/cifs/cifsroot.c Paulo Alcantara (SUSE  2019-07-16 @83) int __init cifs_root_data(char **dev, char **opts)
>
> :::::: The code at line 83 was first introduced by commit
> :::::: 8eecd1c2e5bc73d33f3a544751305679dbf88eb4 cifs: Add support for root file systems
>
> :::::: TO: Paulo Alcantara (SUSE) <paulo@paulo.ac>
> :::::: CC: Steve French <stfrench@microsoft.com>
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org



-- 
Thanks,

Steve
