Return-Path: <SRS0=Z9xR=A3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B75C433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jul 2020 01:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AABA20787
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jul 2020 01:17:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TaSf54Uk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgGPBRK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Jul 2020 21:17:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47487 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726479AbgGPBRK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Jul 2020 21:17:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594862228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+63YRqB6c9Z14UfaTHUiokO772+iBLe1WUhDacAGx7c=;
        b=TaSf54UkiHCK7+j09pjrFGCRex3uVuCK9HSZUR57QcmEsBBC8kfJ5dlIHIWaeLOfg2mdM/
        60Vo/rPq2rqBjFxZXe5Drb6dqcbmd3oU4wgL1BmtE5ecThlNHSKRDR4rqNEaXYPsHkzhsB
        1RGGPBgEh4pvGFaSfh9GQL+XsDhbVJs=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-hyfxhVCfOuivkWCNuI893Q-1; Wed, 15 Jul 2020 21:16:58 -0400
X-MC-Unique: hyfxhVCfOuivkWCNuI893Q-1
Received: by mail-qt1-f197.google.com with SMTP id r9so2708400qtp.7
        for <linux-cifs@vger.kernel.org>; Wed, 15 Jul 2020 18:16:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+63YRqB6c9Z14UfaTHUiokO772+iBLe1WUhDacAGx7c=;
        b=mFdZckA/xweDBzubSNIjmwK2VCtUMTpw2M2rHuEAO+YKjhWqzV3E7G6br21KxyNf0P
         jR2FK9ZB4tYWxrcF3D69tOdppAJ6dYMDQfHzvXhfSuDDOnd4CPWVidO+060ar/0s8rbH
         G20zLIooxXDrKqCvBCM5SwxA8K142z8mA7fotPPPg7WaKyTj1OaPhfQ92nBv4bBzRMib
         1Hf6owdP/RPkeN083VydBqzJ1/4ihwF23rSakuLAe6XMd1Lz0CcelqUlc75pAFKgbCmc
         vjyop0o8GBKI/ny6Fsbd56JLe6MkLawfLb1DuopQacGbhrcJ/6Tq+YpVa9uKpHZP9P4x
         qxaw==
X-Gm-Message-State: AOAM530oKVoxh8kKdou2LoTQj6ta2BT1/ljY2TVnbIU69DqARrMrjEsr
        vJZ+b8MtmOFzhrn2GME+QhfpCtxR39wbAu51p42UgccZc3shbdbR9PjHBqEVJB0W5UZDQ4prLFd
        Meb5CON7WXLFAoxbHhYC810g35EV9z/r0FX3LNg==
X-Received: by 2002:a05:620a:210a:: with SMTP id l10mr1814331qkl.11.1594862218191;
        Wed, 15 Jul 2020 18:16:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyq4uUYasKtfYzpzIDd644i2nFaS/WPjGKhqRlYvA8lM1a2HCTlptnowwO3AYtoBCV9QwhKMAmVJgXjQW1TOuw=
X-Received: by 2002:a05:620a:210a:: with SMTP id l10mr1814319qkl.11.1594862217874;
 Wed, 15 Jul 2020 18:16:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200714221805.3459-1-lsahlber@redhat.com> <202007150917.me5MHt9a%lkp@intel.com>
 <CAH2r5msN7gPvma9GFriSCYVVhWO3+ACBXeK9HW-e2TBvpxSFwg@mail.gmail.com>
In-Reply-To: <CAH2r5msN7gPvma9GFriSCYVVhWO3+ACBXeK9HW-e2TBvpxSFwg@mail.gmail.com>
From:   Kenneth Dsouza <kdsouza@redhat.com>
Date:   Thu, 16 Jul 2020 06:46:46 +0530
Message-ID: <CAA_-hQKmz8ZKW2yMCTHPFWXHucjYothteJPE-nD8+utq4jbG0w@mail.gmail.com>
Subject: Re: [PATCH] cifs: smb1: Try failing back to SetFileInfo if
 SetPathInfo fails
To:     Steve French <smfrench@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Tested-by: Kenneth D'souza <kdsouza@redhat.com>

On Wed, Jul 15, 2020 at 9:47 AM Steve French <smfrench@gmail.com> wrote:
>
> patch updated - and merged into cifs-2.6.git for-next pending additional review
>
> On Tue, Jul 14, 2020 at 8:30 PM kernel test robot <lkp@intel.com> wrote:
> >
> > Hi Ronnie,
> >
> > Thank you for the patch! Perhaps something to improve:
> >
> > [auto build test WARNING on cifs/for-next]
> > [also build test WARNING on v5.8-rc5 next-20200714]
> > [If your patch is applied to the wrong git tree, kindly drop us a note.
> > And when submitting patch, we suggest to use  as documented in
> > https://git-scm.com/docs/git-format-patch]
> >
> > url:    https://github.com/0day-ci/linux/commits/Ronnie-Sahlberg/cifs-smb1-Try-failing-back-to-SetFileInfo-if-SetPathInfo-fails/20200715-061927
> > base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
> > config: arm64-randconfig-r005-20200714 (attached as .config)
> > compiler: clang version 11.0.0 (https://github.com/llvm/llvm-project 02946de3802d3bc65bc9f2eb9b8d4969b5a7add8)
> > reproduce (this is a W=1 build):
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # install arm64 cross compiling tool for clang build
> >         # apt-get install binutils-aarch64-linux-gnu
> >         # save the attached .config to linux build tree
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=arm64
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> > All warnings (new ones prefixed by >>):
> >
> > >> fs/cifs/cifssmb.c:5917:1: warning: no previous prototype for function 'CIFSSMBSetPathInfoFB' [-Wmissing-prototypes]
> >    CIFSSMBSetPathInfoFB(const unsigned int xid, struct cifs_tcon *tcon,
> >    ^
> >    fs/cifs/cifssmb.c:5916:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
> >    int
> >    ^
> >    static
> >    1 warning generated.
> > --
> >    In file included from fs/cifs/cifssmb.c:40:
> >    In file included from fs/cifs/cifsglob.h:32:
> >    fs/cifs/smb2pdu.h:28:10: error: 'cifsacl.h' file not found with <angled> include; use "quotes" instead
> >    #include <cifsacl.h>
> >             ^~~~~~~~~~~
> >             "cifsacl.h"
> > >> fs/cifs/cifssmb.c:5917:1: warning: no previous prototype for function 'CIFSSMBSetPathInfoFB' [-Wmissing-prototypes]
> >    CIFSSMBSetPathInfoFB(const unsigned int xid, struct cifs_tcon *tcon,
> >    ^
> >    fs/cifs/cifssmb.c:5916:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
> >    int
> >    ^
> >    static
> >    1 warning and 1 error generated.
> >
> > vim +/CIFSSMBSetPathInfoFB +5917 fs/cifs/cifssmb.c
> >
> >   5915
> >   5916  int
> > > 5917  CIFSSMBSetPathInfoFB(const unsigned int xid, struct cifs_tcon *tcon,
> >   5918                       const char *fileName, const FILE_BASIC_INFO *data,
> >   5919                       const struct nls_table *nls_codepage,
> >   5920                       struct cifs_sb_info *cifs_sb)
> >   5921  {
> >   5922          int oplock = 0;
> >   5923          struct cifs_open_parms oparms;
> >   5924          struct cifs_fid fid;
> >   5925          int rc;
> >   5926
> >   5927          oparms.tcon = tcon;
> >   5928          oparms.cifs_sb = cifs_sb;
> >   5929          oparms.desired_access = GENERIC_WRITE;
> >   5930          oparms.create_options = cifs_create_options(cifs_sb, 0);
> >   5931          oparms.disposition = FILE_OPEN;
> >   5932          oparms.path = fileName;
> >   5933          oparms.fid = &fid;
> >   5934          oparms.reconnect = false;
> >   5935
> >   5936          rc = CIFS_open(xid, &oparms, &oplock, NULL);
> >   5937          if (rc)
> >   5938                  goto out;
> >   5939
> >   5940          rc = CIFSSMBSetFileInfo(xid, tcon, data, fid.netfid, current->tgid);
> >   5941          CIFSSMBClose(xid, tcon, fid.netfid);
> >   5942  out:
> >   5943
> >   5944          return rc;
> >   5945  }
> >   5946
> >
> > ---
> > 0-DAY CI Kernel Test Service, Intel Corporation
> > https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
>
>
>
> --
> Thanks,
>
> Steve
>

