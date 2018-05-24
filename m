From: kbuild test robot <lkp@intel.com>
Subject: [cifs:for-next 16/19] fs/cifs/cifsfs.c:903:25: sparse: symbol
 'smb3_fs_type' was not declared. Should it be static?
Date: Thu, 24 May 2018 16:53:36 +0800
Message-ID: <201805241613.jA5dMoyL%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
To: Steve French <stfrench@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
head:   fd65f4d1d6b9daaf5265f965640b221701d088f8
commit: 64a051adf5911e8a71a46413c60beaf17ce7143d [16/19] smb3: add module alias for smb3 to cifs.ko
reproduce:
        # apt-get install sparse
        git checkout 64a051adf5911e8a71a46413c60beaf17ce7143d
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   fs/cifs/cifsglob.h:1658:41: sparse: symbol 'cifs_tcp_ses_list' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1669:41: sparse: symbol 'cifs_tcp_ses_lock' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1681:28: sparse: symbol 'GlobalCurrentXid' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1682:28: sparse: symbol 'GlobalTotalActiveXid' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1683:28: sparse: symbol 'GlobalMaxActiveXid' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1684:26: sparse: symbol 'GlobalMid_Lock' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1689:24: sparse: symbol 'sesInfoAllocCount' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1690:24: sparse: symbol 'tconInfoAllocCount' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1691:24: sparse: symbol 'tcpSesAllocCount' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1692:24: sparse: symbol 'tcpSesReconnectCount' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1693:24: sparse: symbol 'tconInfoReconnectCount' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1696:24: sparse: symbol 'bufAllocCount' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1698:24: sparse: symbol 'totBufAllocCount' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1699:24: sparse: symbol 'totSmBufAllocCount' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1701:24: sparse: symbol 'smBufAllocCount' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1702:24: sparse: symbol 'midCount' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1705:20: sparse: symbol 'enable_oplocks' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1706:20: sparse: symbol 'lookupCacheEnabled' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1707:28: sparse: symbol 'global_secflags' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1709:28: sparse: symbol 'sign_CIFS_PDUs' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1710:20: sparse: symbol 'linuxExtEnabled' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1711:28: sparse: symbol 'CIFSMaxBufSize' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1712:28: sparse: symbol 'cifs_min_rcv' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1713:28: sparse: symbol 'cifs_min_small' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1714:28: sparse: symbol 'cifs_max_pending' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1717:30: sparse: symbol 'uidtree' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1718:30: sparse: symbol 'gidtree' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1719:26: sparse: symbol 'siduidlock' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1720:26: sparse: symbol 'sidgidlock' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1721:30: sparse: symbol 'siduidtree' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1722:30: sparse: symbol 'sidgidtree' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1723:26: sparse: symbol 'uidsidlock' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1724:26: sparse: symbol 'gidsidlock' was not declared. Should it be static?
>> fs/cifs/cifsfs.c:903:25: sparse: symbol 'smb3_fs_type' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
