Return-Path: <SRS0=edh0=32=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68EE7C35247
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Feb 2020 22:26:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1865621775
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Feb 2020 22:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbgBFW0c (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 Feb 2020 17:26:32 -0500
Received: from mga07.intel.com ([134.134.136.100]:26741 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726502AbgBFW0c (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 6 Feb 2020 17:26:32 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 14:26:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,411,1574150400"; 
   d="gz'50?scan'50,208,50";a="279805326"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Feb 2020 14:26:27 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1izpbP-0001FP-0t; Fri, 07 Feb 2020 06:26:27 +0800
Date:   Fri, 7 Feb 2020 06:26:22 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Steve French <stfrench@microsoft.com>
Cc:     kbuild-all@lists.01.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, Aurelien Aptel <aaptel@suse.com>
Subject: [cifs:for-next 10/11] fs/cifs/smb2pdu.c:1985:38: error: macro
 "memcmp" passed 18 arguments, but takes just 3
Message-ID: <202002070617.AbeYy9qc%lkp@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qumsip6mzmg6sn4e"
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


--qumsip6mzmg6sn4e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
head:   58b322cfd219fd570d4fcc2e2eb8b5d945389d46
commit: 3d9d8c48232a668ada5f680f70c8b3d366629ab6 [10/11] smb3: print warning once if posix context returned on open
config: m68k-multi_defconfig (attached as .config)
compiler: m68k-linux-gcc (GCC) 7.5.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git checkout 3d9d8c48232a668ada5f680f70c8b3d366629ab6
        # save the attached .config to linux build tree
        GCC_VERSION=7.5.0 make.cross ARCH=m68k 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   fs/cifs/smb2pdu.c: In function 'smb2_parse_contexts':
>> fs/cifs/smb2pdu.c:1985:38: error: macro "memcmp" passed 18 arguments, but takes just 3
        0xDE, 0x96, 0x8B, 0xCD, 0x7C}, 16) == 0)
                                         ^
>> fs/cifs/smb2pdu.c:1983:8: error: 'memcmp' undeclared (first use in this function); did you mean 'memchr'?
       if (memcmp(name, (char []) {0x93, 0xAD, 0x25, 0x50,
           ^~~~~~
           memchr
   fs/cifs/smb2pdu.c:1983:8: note: each undeclared identifier is reported only once for each function it appears in

vim +/memcmp +1985 fs/cifs/smb2pdu.c

  1951	
  1952	void
  1953	smb2_parse_contexts(struct TCP_Server_Info *server,
  1954			       struct smb2_create_rsp *rsp,
  1955			       unsigned int *epoch, char *lease_key, __u8 *oplock,
  1956			       struct smb2_file_all_info *buf)
  1957	{
  1958		char *data_offset;
  1959		struct create_context *cc;
  1960		unsigned int next;
  1961		unsigned int remaining;
  1962		char *name;
  1963	
  1964		*oplock = 0;
  1965		data_offset = (char *)rsp + le32_to_cpu(rsp->CreateContextsOffset);
  1966		remaining = le32_to_cpu(rsp->CreateContextsLength);
  1967		cc = (struct create_context *)data_offset;
  1968	
  1969		/* Initialize inode number to 0 in case no valid data in qfid context */
  1970		if (buf)
  1971			buf->IndexNumber = 0;
  1972	
  1973		while (remaining >= sizeof(struct create_context)) {
  1974			name = le16_to_cpu(cc->NameOffset) + (char *)cc;
  1975			if (le16_to_cpu(cc->NameLength) == 4 &&
  1976			    strncmp(name, SMB2_CREATE_REQUEST_LEASE, 4) == 0)
  1977				*oplock = server->ops->parse_lease_buf(cc, epoch,
  1978								   lease_key);
  1979			else if (buf && (le16_to_cpu(cc->NameLength) == 4) &&
  1980			    strncmp(name, SMB2_CREATE_QUERY_ON_DISK_ID, 4) == 0)
  1981				parse_query_id_ctxt(cc, buf);
  1982			else if ((le16_to_cpu(cc->NameLength) == 16)) {
> 1983				if (memcmp(name, (char []) {0x93, 0xAD, 0x25, 0x50,
  1984					0x9C, 0xB4, 0x11, 0xE7, 0xB4, 0x23, 0x83,
> 1985					0xDE, 0x96, 0x8B, 0xCD, 0x7C}, 16) == 0)
  1986					parse_posix_ctxt(cc, NULL);
  1987			}
  1988			/* else {
  1989				cifs_dbg(FYI, "Context not matched with len %d\n",
  1990					le16_to_cpu(cc->NameLength));
  1991				cifs_dump_mem("Cctxt name: ", name, 4);
  1992			} */
  1993	
  1994			next = le32_to_cpu(cc->Next);
  1995			if (!next)
  1996				break;
  1997			remaining -= next;
  1998			cc = (struct create_context *)((char *)cc + next);
  1999		}
  2000	
  2001		if (rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE)
  2002			*oplock = rsp->OplockLevel;
  2003	
  2004		return;
  2005	}
  2006	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--qumsip6mzmg6sn4e
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
MJxghK7+/0O6SxJzDgEA

--qumsip6mzmg6sn4e--
