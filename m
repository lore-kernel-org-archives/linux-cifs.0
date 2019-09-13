Return-Path: <SRS0=frs6=XI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F13C49ED7
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Sep 2019 13:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D7E320830
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Sep 2019 13:57:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WfrOstkz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388349AbfIMN5k (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 13 Sep 2019 09:57:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48814 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388170AbfIMN5j (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 13 Sep 2019 09:57:39 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8DDrwck156345;
        Fri, 13 Sep 2019 13:57:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=fBz+hKZQK0dDgBowutuUmdN79legw3CALxr/lmBl0H4=;
 b=WfrOstkztklES2gWGJajHOowLggWlFPo+Pw4m2uF4gVoee80A614AINLcyctJfuGL8n0
 fkn+GxrVzC8K1vtBt+Dapw1lDZHoly3uXRabVbBSbXztZXYTPYO+oc72j4O+Ul1HGoLu
 ArM14EqrzdSyFs7/hD0wKJkr43KNW+ob9N9Ocm3cB4SqJx6661HPi7geiUobihoVW5Ws
 82J8vvIOdh3UXiD0zfhGN3Pl3hEpsEKHQzw1FvpYCEI1PXuOEhqbPYk0/V6nPRAPWxps
 QdpAIVpHu71bluEcgib0wxmoZvlp5O6Q+eEQky18HWV2616/hWGUJeVDi0j3Qr8yrPo0 Bg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2uytd34vq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Sep 2019 13:57:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8DDsh1q189242;
        Fri, 13 Sep 2019 13:55:24 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2uytdmqqsw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Sep 2019 13:55:24 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8DDtMB5016511;
        Fri, 13 Sep 2019 13:55:23 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Sep 2019 06:55:22 -0700
Date:   Fri, 13 Sep 2019 16:55:11 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@01.org, Steve French <stfrench@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>
Cc:     kbuild-all@01.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [cifs:for-next 31/31] fs/cifs/smb2ops.c:786 open_shroot() error:
 double unlock 'mutex:&tcon->crfid.fid_mutex'
Message-ID: <20190913135510.GS20699@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9378 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909130138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9378 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909130138
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
head:   5fc321fb644fc787710353be11129edadd313f3a
commit: 5fc321fb644fc787710353be11129edadd313f3a [31/31] smb3: fix unmount hang in open_shroot

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

New smatch warnings:
fs/cifs/smb2ops.c:786 open_shroot() error: double unlock 'mutex:&tcon->crfid.fid_mutex'

git remote add cifs git://git.samba.org/sfrench/cifs-2.6.git
git remote update cifs
git checkout 5fc321fb644fc787710353be11129edadd313f3a
vim +786 fs/cifs/smb2ops.c

fs/cifs/smb2ops.c
   726                  /*
   727                   * caller expects this func to set pfid to a valid
   728                   * cached root, so we copy the existing one and get a
   729                   * reference.
   730                   */
   731                  memcpy(pfid, tcon->crfid.fid, sizeof(*pfid));
   732                  kref_get(&tcon->crfid.refcount);
   733  
   734                  mutex_unlock(&tcon->crfid.fid_mutex);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Unlock (recently added)

   735  
   736                  if (rc == 0) {
   737                          /* close extra handle outside of crit sec */
   738                          SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
   739                  }
   740                  goto oshr_free;
   741          }
   742  
   743          /* Cached root is still invalid, continue normaly */
   744  
   745          if (rc) {
   746                  if (rc == -EREMCHG) {
   747                          tcon->need_reconnect = true;
   748                          printk_once(KERN_WARNING "server share %s deleted\n",
   749                                      tcon->treeName);
   750                  }
   751                  goto oshr_exit;
   752          }
   753  
   754          o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
   755          oparms.fid->persistent_fid = o_rsp->PersistentFileId;
   756          oparms.fid->volatile_fid = o_rsp->VolatileFileId;
   757  #ifdef CONFIG_CIFS_DEBUG2
   758          oparms.fid->mid = le64_to_cpu(o_rsp->sync_hdr.MessageId);
   759  #endif /* CIFS_DEBUG2 */
   760  
   761          memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid));
   762          tcon->crfid.tcon = tcon;
   763          tcon->crfid.is_valid = true;
   764          kref_init(&tcon->crfid.refcount);
   765  
   766          /* BB TBD check to see if oplock level check can be removed below */
   767          if (o_rsp->OplockLevel == SMB2_OPLOCK_LEVEL_LEASE) {
   768                  kref_get(&tcon->crfid.refcount);
   769                  smb2_parse_contexts(server, o_rsp,
   770                                  &oparms.fid->epoch,
   771                                  oparms.fid->lease_key, &oplock, NULL);
   772          } else
   773                  goto oshr_exit;
   774  
   775          qi_rsp = (struct smb2_query_info_rsp *)rsp_iov[1].iov_base;
   776          if (le32_to_cpu(qi_rsp->OutputBufferLength) < sizeof(struct smb2_file_all_info))
   777                  goto oshr_exit;
   778          if (!smb2_validate_and_copy_iov(
   779                                  le16_to_cpu(qi_rsp->OutputBufferOffset),
   780                                  sizeof(struct smb2_file_all_info),
   781                                  &rsp_iov[1], sizeof(struct smb2_file_all_info),
   782                                  (char *)&tcon->crfid.file_all_info))
   783                  tcon->crfid.file_all_info_is_valid = 1;
   784  
   785  oshr_exit:
   786          mutex_unlock(&tcon->crfid.fid_mutex);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Double unlock.

   787  oshr_free:
   788          SMB2_open_free(&rqst[0]);
   789          SMB2_query_info_free(&rqst[1]);
   790          free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
   791          free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
   792          return rc;
   793  }

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
