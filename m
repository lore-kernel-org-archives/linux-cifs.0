Return-Path: <SRS0=edh0=32=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE097C35247
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Feb 2020 23:16:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A771621775
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Feb 2020 23:16:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vCR8XHsQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgBFXQe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 Feb 2020 18:16:34 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:40907 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbgBFXQe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 Feb 2020 18:16:34 -0500
Received: by mail-il1-f195.google.com with SMTP id i7so146893ilr.7
        for <linux-cifs@vger.kernel.org>; Thu, 06 Feb 2020 15:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DN86R3v3uBgYqz7Tgg9oVuZdUyiUcLMMfP+Un9k4dLI=;
        b=vCR8XHsQ581wt5nCT6vDs95UGDTtm++B5uVCwRTtDC8qKoOJLR4e23kdVOOhpjExVf
         Cz5P3FCQ4WLRAGPapZzb3WaoPzdLIVLetAp+MKv22xqIB2edHhkTUxbeDEDNfihf3N8y
         00sMkDjvMnPJ5gdHS+/DF44gBPZaR7zuyVraAnUxX3sYGN3+/Csj6MhzyajXZScRUnjz
         O8jEUUHaJ0Zt1MGMIXsDa20xtZlxbQmHvbxk4kZIOb5Tzou8Mnhs2e4z+/dXRJQqCCRA
         3gCMy9AuSDIMsXyE0Tx35OjPGLeTnmZ7nFYR2QGvkALGdl8ZPy0t4/yzJXv5oMkgdbwt
         4f5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DN86R3v3uBgYqz7Tgg9oVuZdUyiUcLMMfP+Un9k4dLI=;
        b=S/Q9RKCojH33GvagueyCBCtboxPnO7zGy8xa9fvOmRQ4qi/LzHbMQ0BCBnU7wIvjZ5
         aUI1iJQIVahIUcKAffe/SFQG08rrqn/MEp7iAOQjBJwRGoUs7cbFH0ShTdRtVz+9a0t/
         pP4bzNN4atDwPQLVXY+DBGo/Xn8yvfOboT5+t6Iu/50MmcVATosSmJlnjfiqwr/+q6vY
         qWiULVrRXAXGitwTQ69Lw0guweqNFZ0cH7iuhYzD4vipmjxRW8C4E6FrMGjRStwQvmiY
         3wWbuwt7WHJlJJdApVNJnhGr+0vIl+9JPaRogNe0Wi/3nRI57lnYStsEonpG4DfizfYd
         i+Xw==
X-Gm-Message-State: APjAAAUdR9GPdbAJxQUHM9xS8FSsc+A5gfaakyf/TaU/xCKglWjiPPaH
        QhjWu5Y58Sq5MA4jRVRQBidsamPDxgBYvsGBBt4=
X-Google-Smtp-Source: APXvYqwZgg+7el87MdZ55aIoIxwzXgHqN76ZtgeafLLVKKz5wIW9napGhY3b7/Vm0EIe9F5mI/L7HoHg8aa3eIVwNFo=
X-Received: by 2002:a92:1553:: with SMTP id v80mr6627216ilk.49.1581030993040;
 Thu, 06 Feb 2020 15:16:33 -0800 (PST)
MIME-Version: 1.0
References: <202002070617.AbeYy9qc%lkp@intel.com> <CAH2r5mtHY6OGMpMdpLcxZ_xyjzZHANhqr_NoeGERiFiQyfc-PQ@mail.gmail.com>
In-Reply-To: <CAH2r5mtHY6OGMpMdpLcxZ_xyjzZHANhqr_NoeGERiFiQyfc-PQ@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 7 Feb 2020 09:16:22 +1000
Message-ID: <CAN05THQ8ajLM58-dyQA0teD56Hkt7wmJMRtHB8DW1Yh5qKBrjg@mail.gmail.com>
Subject: Re: [cifs:for-next 10/11] fs/cifs/smb2pdu.c:1985:38: error: macro
 "memcmp" passed 18 arguments, but takes just 3
To:     Steve French <smfrench@gmail.com>
Cc:     kbuild test robot <lkp@intel.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

It is probably that m68k lage quite behind in GCC versions and
probably that compiler can not handle this construct:
> 1983                          if (memcmp(name, (char []) {0x93, 0xAD, 0x25, 0x50,
  1984                                  0x9C, 0xB4, 0x11, 0xE7, 0xB4,
0x23, 0x83,
> 1985                                  0xDE, 0x96, 0x8B, 0xCD, 0x7C}, 16) == 0)
and you would probably need something like this:
     const char foo[] = {0x93, 0xAD, 0x25, 0x50, 0x9C, 0xB4, 0x11,
0xE7, 0xB4, 0x23, 0x83, 0xDE, 0x96, 0x8B, 0xCD, 0x7C};
     if (memcmp(name, foo, sizeof(foo)) == 0)
...

On Fri, Feb 7, 2020 at 8:48 AM Steve French <smfrench@gmail.com> wrote:
>
> It compiled and tested ok.  Is this warning a limitation of the kbuild robot?
>
> On Thu, Feb 6, 2020 at 4:26 PM kbuild test robot <lkp@intel.com> wrote:
> >
> > tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
> > head:   58b322cfd219fd570d4fcc2e2eb8b5d945389d46
> > commit: 3d9d8c48232a668ada5f680f70c8b3d366629ab6 [10/11] smb3: print warning once if posix context returned on open
> > config: m68k-multi_defconfig (attached as .config)
> > compiler: m68k-linux-gcc (GCC) 7.5.0
> > reproduce:
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         git checkout 3d9d8c48232a668ada5f680f70c8b3d366629ab6
> >         # save the attached .config to linux build tree
> >         GCC_VERSION=7.5.0 make.cross ARCH=m68k
> >
> > If you fix the issue, kindly add following tag
> > Reported-by: kbuild test robot <lkp@intel.com>
> >
> > All errors (new ones prefixed by >>):
> >
> >    fs/cifs/smb2pdu.c: In function 'smb2_parse_contexts':
> > >> fs/cifs/smb2pdu.c:1985:38: error: macro "memcmp" passed 18 arguments, but takes just 3
> >         0xDE, 0x96, 0x8B, 0xCD, 0x7C}, 16) == 0)
> >                                          ^
> > >> fs/cifs/smb2pdu.c:1983:8: error: 'memcmp' undeclared (first use in this function); did you mean 'memchr'?
> >        if (memcmp(name, (char []) {0x93, 0xAD, 0x25, 0x50,
> >            ^~~~~~
> >            memchr
> >    fs/cifs/smb2pdu.c:1983:8: note: each undeclared identifier is reported only once for each function it appears in
> >
> > vim +/memcmp +1985 fs/cifs/smb2pdu.c
> >
> >   1951
> >   1952  void
> >   1953  smb2_parse_contexts(struct TCP_Server_Info *server,
> >   1954                         struct smb2_create_rsp *rsp,
> >   1955                         unsigned int *epoch, char *lease_key, __u8 *oplock,
> >   1956                         struct smb2_file_all_info *buf)
> >   1957  {
> >   1958          char *data_offset;
> >   1959          struct create_context *cc;
> >   1960          unsigned int next;
> >   1961          unsigned int remaining;
> >   1962          char *name;
> >   1963
> >   1964          *oplock = 0;
> >   1965          data_offset = (char *)rsp + le32_to_cpu(rsp->CreateContextsOffset);
> >   1966          remaining = le32_to_cpu(rsp->CreateContextsLength);
> >   1967          cc = (struct create_context *)data_offset;
> >   1968
> >   1969          /* Initialize inode number to 0 in case no valid data in qfid context */
> >   1970          if (buf)
> >   1971                  buf->IndexNumber = 0;
> >   1972
> >   1973          while (remaining >= sizeof(struct create_context)) {
> >   1974                  name = le16_to_cpu(cc->NameOffset) + (char *)cc;
> >   1975                  if (le16_to_cpu(cc->NameLength) == 4 &&
> >   1976                      strncmp(name, SMB2_CREATE_REQUEST_LEASE, 4) == 0)
> >   1977                          *oplock = server->ops->parse_lease_buf(cc, epoch,
> >   1978                                                             lease_key);
> >   1979                  else if (buf && (le16_to_cpu(cc->NameLength) == 4) &&
> >   1980                      strncmp(name, SMB2_CREATE_QUERY_ON_DISK_ID, 4) == 0)
> >   1981                          parse_query_id_ctxt(cc, buf);
> >   1982                  else if ((le16_to_cpu(cc->NameLength) == 16)) {
> > > 1983                          if (memcmp(name, (char []) {0x93, 0xAD, 0x25, 0x50,
> >   1984                                  0x9C, 0xB4, 0x11, 0xE7, 0xB4, 0x23, 0x83,
> > > 1985                                  0xDE, 0x96, 0x8B, 0xCD, 0x7C}, 16) == 0)
> >   1986                                  parse_posix_ctxt(cc, NULL);
> >   1987                  }
> >   1988                  /* else {
> >   1989                          cifs_dbg(FYI, "Context not matched with len %d\n",
> >   1990                                  le16_to_cpu(cc->NameLength));
> >   1991                          cifs_dump_mem("Cctxt name: ", name, 4);
> >   1992                  } */
> >   1993
> >   1994                  next = le32_to_cpu(cc->Next);
> >   1995                  if (!next)
> >   1996                          break;
> >   1997                  remaining -= next;
> >   1998                  cc = (struct create_context *)((char *)cc + next);
> >   1999          }
> >   2000
> >   2001          if (rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE)
> >   2002                  *oplock = rsp->OplockLevel;
> >   2003
> >   2004          return;
> >   2005  }
> >   2006
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
