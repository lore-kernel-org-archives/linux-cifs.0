Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3E7EC433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Mar 2021 11:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66BBA64EFC
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Mar 2021 11:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhCRLx7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Mar 2021 07:53:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35216 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbhCRLxy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Mar 2021 07:53:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12IBo7Kx035575;
        Thu, 18 Mar 2021 11:53:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=MJF1SF1Hvku2wLSsYXA1b9PjXSkvAotS0JtTPIiW5FA=;
 b=uyomP87zLWlB34SyIC/K9R0/L6IMiLuhx/LW+QdEyGDAA/DcMTI687n32GEtmpunr92R
 3+ZQ6Sf8zcz9JgHGqC6GMwJEhDrxQVPj1qJg67lT+awh12dPkoixSK2PX7zwim+Hmu1t
 Ko/UCJbfoNnt0Zv8vUvoVlkPetH5oq3I30ogvhSdoMMYNJolxQgrlKcPNTgKilQfN8D5
 cTGd2TBoAtQwXqOmSFUI9VaDBco5MXw97bKXa1sxHTbNFhnj9k5GPcBkbHvM11F+bwoR
 G7BXNOkzpk6QW6+9ywEKslP6CZmCDZRHcJK8m5O5xvelUOLLjAfki7u3PHA4W4Dxt9GL TQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 378p1ny6ec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 11:53:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12IBimXH136515;
        Thu, 18 Mar 2021 11:53:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3796yw3s1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 18 Mar 2021 11:53:49 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 12IBrl5Z008271;
        Thu, 18 Mar 2021 11:53:47 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 18 Mar 2021 04:53:46 -0700
Date:   Thu, 18 Mar 2021 14:53:40 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     namjae.jeon@samsung.com
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] cifsd: make xattr format of ksmbd compatible with
 samba's one
Message-ID: <YFM/RCfCojoRxvsy@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9926 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103180090
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9926 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 adultscore=0
 spamscore=0 clxscore=1011 phishscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103180090
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Namjae Jeon,

The patch affbd69c2cb5: "cifsd: make xattr format of ksmbd compatible
with samba's one" from Jan 28, 2021, leads to the following static
checker warning:

	fs/cifsd/smbacl.c:1140 smb_check_perm_dacl()
	error: we previously assumed 'pntsd' could be null (see line 1137)

fs/cifsd/smbacl.c
  1119  int smb_check_perm_dacl(struct ksmbd_conn *conn, struct dentry *dentry,
  1120                  __le32 *pdaccess, int uid)
  1121  {
  1122          struct smb_ntsd *pntsd = NULL;
  1123          struct smb_acl *pdacl;
  1124          struct posix_acl *posix_acls;
  1125          int rc = 0, acl_size;
  1126          struct smb_sid sid;
  1127          int granted = le32_to_cpu(*pdaccess & ~FILE_MAXIMAL_ACCESS_LE);
  1128          struct smb_ace *ace;
  1129          int i, found = 0;
  1130          unsigned int access_bits = 0;
  1131          struct smb_ace *others_ace = NULL;
  1132          struct posix_acl_entry *pa_entry;
  1133          unsigned int sid_type = SIDOWNER;
  1134  
  1135          ksmbd_debug(SMB, "check permission using windows acl\n");
  1136          acl_size = ksmbd_vfs_get_sd_xattr(conn, dentry, &pntsd);
  1137          if (acl_size <= 0 || (pntsd && !pntsd->dacloffset))
                                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^
Presumably this should be "if (acl_size <= 0 || !pntsd)
				return 0;

If pntsd is NULL then we are toasted.

  1138                  return 0;
  1139  
  1140          pdacl = (struct smb_acl *)((char *)pntsd + le32_to_cpu(pntsd->dacloffset));

But as I look at this warning, I am much more concerned that we are
trusting pntsd->dacloffset at all.  It doesn't appear that we have
bounds checked the upper limit.

Unrelated and minor:  The ndr_read_bytes() function has the src, dest
parameters reversed which is going to chaos and confusion and in the
future.  ;)

  1141          if (!pdacl->num_aces) {
  1142                  if (!(le16_to_cpu(pdacl->size) - sizeof(struct smb_acl)) &&
  1143                      *pdaccess & ~(FILE_READ_CONTROL_LE | FILE_WRITE_DAC_LE)) {
  1144                          rc = -EACCES;
  1145                          goto err_out;
  1146                  }
  1147                  kfree(pntsd);
  1148                  return 0;
  1149          }

There is another similar sort of static checker warning:

fs/cifsd/smbacl.c:803 parse_sec_desc() warn: 'dacl_ptr' can't be NULL
   778  int parse_sec_desc(struct smb_ntsd *pntsd, int acl_len,
   779                  struct smb_fattr *fattr)
   780  {
   781          int rc = 0;
   782          struct smb_sid *owner_sid_ptr, *group_sid_ptr;
   783          struct smb_acl *dacl_ptr; /* no need for SACL ptr */
   784          char *end_of_acl = ((char *)pntsd) + acl_len;
   785          __u32 dacloffset;
   786          int total_ace_size = 0, pntsd_type;
   787  
   788          if (pntsd == NULL)
   789                  return -EIO;
   790  
   791          owner_sid_ptr = (struct smb_sid *)((char *)pntsd +
   792                          le32_to_cpu(pntsd->osidoffset));
   793          group_sid_ptr = (struct smb_sid *)((char *)pntsd +
   794                          le32_to_cpu(pntsd->gsidoffset));
   795          dacloffset = le32_to_cpu(pntsd->dacloffset);
   796          dacl_ptr = (struct smb_acl *)((char *)pntsd + dacloffset);
                                                      ^^^^^
pntsd is non-NULL so dacl_ptr can't be NULL.  We're trusting a lot of
these offsets to be non-malicious.

   797          ksmbd_debug(SMB,
   798                  "revision %d type 0x%x ooffset 0x%x goffset 0x%x sacloffset 0x%x dacloffset 0x%x\n",
   799                   pntsd->revision, pntsd->type, le32_to_cpu(pntsd->osidoffset),
   800                   le32_to_cpu(pntsd->gsidoffset),
   801                   le32_to_cpu(pntsd->sacloffset), dacloffset);
   802  
   803          if (dacloffset && dacl_ptr)
   804                  total_ace_size =
   805                          le16_to_cpu(dacl_ptr->size) - sizeof(struct smb_acl);
   806  
   807          pntsd_type = le16_to_cpu(pntsd->type);
   808  

regards,
dan carpenter
