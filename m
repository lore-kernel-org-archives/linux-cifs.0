From: kbuild test robot <lkp@intel.com>
Subject: [cifs:for-next 12/12] fs/cifs/cifsfs.c:1056:5: sparse: symbol
 'cifs_dir_fsync' was not declared. Should it be static?
Date: Fri, 11 May 2018 08:50:25 +0800
Message-ID: <201805110802.lpBxehxn%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        linux-kernel@vger.kernel.org
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
head:   c3d5c2a93abfc181d9f274dd5e4b18749dc0643f
commit: c3d5c2a93abfc181d9f274dd5e4b18749dc0643f [12/12] smb3: directory sync should not return an error
reproduce:
        # apt-get install sparse
        git checkout c3d5c2a93abfc181d9f274dd5e4b18749dc0643f
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   fs/cifs/cifsglob.h:1653:41: sparse: symbol 'cifs_tcp_ses_list' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1664:41: sparse: symbol 'cifs_tcp_ses_lock' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1676:28: sparse: symbol 'GlobalCurrentXid' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1677:28: sparse: symbol 'GlobalTotalActiveXid' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1678:28: sparse: symbol 'GlobalMaxActiveXid' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1679:26: sparse: symbol 'GlobalMid_Lock' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1684:24: sparse: symbol 'sesInfoAllocCount' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1685:24: sparse: symbol 'tconInfoAllocCount' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1686:24: sparse: symbol 'tcpSesAllocCount' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1687:24: sparse: symbol 'tcpSesReconnectCount' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1688:24: sparse: symbol 'tconInfoReconnectCount' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1691:24: sparse: symbol 'bufAllocCount' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1693:24: sparse: symbol 'totBufAllocCount' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1694:24: sparse: symbol 'totSmBufAllocCount' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1696:24: sparse: symbol 'smBufAllocCount' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1697:24: sparse: symbol 'midCount' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1700:20: sparse: symbol 'enable_oplocks' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1701:20: sparse: symbol 'lookupCacheEnabled' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1702:28: sparse: symbol 'global_secflags' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1704:28: sparse: symbol 'sign_CIFS_PDUs' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1705:20: sparse: symbol 'linuxExtEnabled' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1706:28: sparse: symbol 'CIFSMaxBufSize' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1707:28: sparse: symbol 'cifs_min_rcv' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1708:28: sparse: symbol 'cifs_min_small' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1709:28: sparse: symbol 'cifs_max_pending' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1712:30: sparse: symbol 'uidtree' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1713:30: sparse: symbol 'gidtree' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1714:26: sparse: symbol 'siduidlock' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1715:26: sparse: symbol 'sidgidlock' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1716:30: sparse: symbol 'siduidtree' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1717:30: sparse: symbol 'sidgidtree' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1718:26: sparse: symbol 'uidsidlock' was not declared. Should it be static?
   fs/cifs/cifsglob.h:1719:26: sparse: symbol 'gidsidlock' was not declared. Should it be static?
>> fs/cifs/cifsfs.c:1056:5: sparse: symbol 'cifs_dir_fsync' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
