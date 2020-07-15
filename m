Return-Path: <SRS0=SAbX=A2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05046C433E1
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Jul 2020 04:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4F822067D
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Jul 2020 04:17:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HvI0gTSp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgGOERf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Jul 2020 00:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgGOERe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Jul 2020 00:17:34 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BFEC061755
        for <linux-cifs@vger.kernel.org>; Tue, 14 Jul 2020 21:17:34 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id x138so493267ybg.9
        for <linux-cifs@vger.kernel.org>; Tue, 14 Jul 2020 21:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aIUoX/lfRA4O2oRe87PMq1zQU6cl+9JxK87frUvGag0=;
        b=HvI0gTSpO2D2PMEBZ+kjzgQT+1Rzl8HxuePcy9SEeIcwJv5S7yUnpIsKdcplvHWw6g
         bDdV/LHjARA5S9Norl9lPWUTCfE/T6iQjUiXcQq+a87iPv3j1sbvXrnNZ91kdDpbAsuV
         x2M+CtcKdc3KZCk0sATsZq9XmXn3H9t8wcuuo1HLFF5+1H0kzUPOe93sTTm+RQr4GPWB
         F2ji+KOZze9T8BL5AxuzLAvnROw8+68vlxvqWY+HVGDCVvhgDhC3sgrErNJOpd8MSZ0D
         D/EIWU2YUnvGIkil8tvCvgt6tZwA1uKCAsME6bLYy/A04uS/zdj3yHPD+RR21kLf9WLw
         9S7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aIUoX/lfRA4O2oRe87PMq1zQU6cl+9JxK87frUvGag0=;
        b=F9m8KzO50DLi7FGGlJzZD3qmcu0dyyhyj4R1JTl/IOJbSeXXDQQ+PehGM3yIFFbYGG
         oNvw15zQhbHR9Tg4yiF8hP4XqUM0625+V7TYQG5Y70KwIz0bnOZyc4332K/j3R4Yrh9w
         odY7V7xkWD6mJTlLMr7ab7MiPhWeEwL2jyK6xsCrXWYT7wp6G62oHScOocCZQDEAJ96s
         Cl1SJqcyvEE6tuob/fC2gJWUVC4Em/gye/RdJ5SuJ461x0mJPdONDKT6189BvPTq7eB5
         k2jpOJnW1t4ECv64mZ3+cRJUIb7D7H0KQEiI5Ge+4bZh9vtHpGYQqsz+6zPpuAPy9np6
         cKwQ==
X-Gm-Message-State: AOAM533tV++OnygkxmcDuw0Q7DO5vb96OS4HZ9jgvSLeZ2tevGemA25l
        YlXEh8MfddNupfzltXI1/MXR/D96ozZTOYJCZE6GEpQe
X-Google-Smtp-Source: ABdhPJyx5xYFBY+geFI3o25MiHf9KA+ThEM2cLsKs/LGXoY0FKEPxpliJG7OnpemQadg8JoG6IBoiGoJ/Pffqlu3Kmg=
X-Received: by 2002:a25:afd1:: with SMTP id d17mr13713909ybj.91.1594786653573;
 Tue, 14 Jul 2020 21:17:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200714221805.3459-1-lsahlber@redhat.com> <202007150917.me5MHt9a%lkp@intel.com>
In-Reply-To: <202007150917.me5MHt9a%lkp@intel.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 14 Jul 2020 23:17:22 -0500
Message-ID: <CAH2r5msN7gPvma9GFriSCYVVhWO3+ACBXeK9HW-e2TBvpxSFwg@mail.gmail.com>
Subject: Re: [PATCH] cifs: smb1: Try failing back to SetFileInfo if
 SetPathInfo fails
To:     kernel test robot <lkp@intel.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>, kbuild-all@lists.01.org,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

patch updated - and merged into cifs-2.6.git for-next pending additional review

On Tue, Jul 14, 2020 at 8:30 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi Ronnie,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on cifs/for-next]
> [also build test WARNING on v5.8-rc5 next-20200714]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use  as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/0day-ci/linux/commits/Ronnie-Sahlberg/cifs-smb1-Try-failing-back-to-SetFileInfo-if-SetPathInfo-fails/20200715-061927
> base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
> config: arm64-randconfig-r005-20200714 (attached as .config)
> compiler: clang version 11.0.0 (https://github.com/llvm/llvm-project 02946de3802d3bc65bc9f2eb9b8d4969b5a7add8)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install arm64 cross compiling tool for clang build
>         # apt-get install binutils-aarch64-linux-gnu
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=arm64
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
> >> fs/cifs/cifssmb.c:5917:1: warning: no previous prototype for function 'CIFSSMBSetPathInfoFB' [-Wmissing-prototypes]
>    CIFSSMBSetPathInfoFB(const unsigned int xid, struct cifs_tcon *tcon,
>    ^
>    fs/cifs/cifssmb.c:5916:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
>    int
>    ^
>    static
>    1 warning generated.
> --
>    In file included from fs/cifs/cifssmb.c:40:
>    In file included from fs/cifs/cifsglob.h:32:
>    fs/cifs/smb2pdu.h:28:10: error: 'cifsacl.h' file not found with <angled> include; use "quotes" instead
>    #include <cifsacl.h>
>             ^~~~~~~~~~~
>             "cifsacl.h"
> >> fs/cifs/cifssmb.c:5917:1: warning: no previous prototype for function 'CIFSSMBSetPathInfoFB' [-Wmissing-prototypes]
>    CIFSSMBSetPathInfoFB(const unsigned int xid, struct cifs_tcon *tcon,
>    ^
>    fs/cifs/cifssmb.c:5916:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
>    int
>    ^
>    static
>    1 warning and 1 error generated.
>
> vim +/CIFSSMBSetPathInfoFB +5917 fs/cifs/cifssmb.c
>
>   5915
>   5916  int
> > 5917  CIFSSMBSetPathInfoFB(const unsigned int xid, struct cifs_tcon *tcon,
>   5918                       const char *fileName, const FILE_BASIC_INFO *data,
>   5919                       const struct nls_table *nls_codepage,
>   5920                       struct cifs_sb_info *cifs_sb)
>   5921  {
>   5922          int oplock = 0;
>   5923          struct cifs_open_parms oparms;
>   5924          struct cifs_fid fid;
>   5925          int rc;
>   5926
>   5927          oparms.tcon = tcon;
>   5928          oparms.cifs_sb = cifs_sb;
>   5929          oparms.desired_access = GENERIC_WRITE;
>   5930          oparms.create_options = cifs_create_options(cifs_sb, 0);
>   5931          oparms.disposition = FILE_OPEN;
>   5932          oparms.path = fileName;
>   5933          oparms.fid = &fid;
>   5934          oparms.reconnect = false;
>   5935
>   5936          rc = CIFS_open(xid, &oparms, &oplock, NULL);
>   5937          if (rc)
>   5938                  goto out;
>   5939
>   5940          rc = CIFSSMBSetFileInfo(xid, tcon, data, fid.netfid, current->tgid);
>   5941          CIFSSMBClose(xid, tcon, fid.netfid);
>   5942  out:
>   5943
>   5944          return rc;
>   5945  }
>   5946
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org



-- 
Thanks,

Steve
