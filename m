Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,BIGNUM_EMAILS,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79F08C2BB9A
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Dec 2020 15:07:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DBD92253A
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Dec 2020 15:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729408AbgLOPGn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Dec 2020 10:06:43 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41020 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727833AbgLOPGf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Dec 2020 10:06:35 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BFF5qaS005187;
        Tue, 15 Dec 2020 15:05:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=lj/lRvNbrjTXZPLC7d2TuNn0S49zfkmuAYhKviaqJxo=;
 b=Jj1a9ipcFkwyf2w46eqhG9xf6COEXwFvnR+WIwd1zUiYZzQklWbBGBZ/LEAXzboPY+kn
 AncH3r3L8WHlog0vX5lm9CA1PqcmgnDihLpBH2kFZhWGq+yvK33IwBq8+pP9Md+EXkfY
 /MyXy32ZUifgmpN6ptov/AbVlnOCnzfCcKsBOvr04uGEZbBY4Ts9ScdE2ueGanZoz+cy
 y15bGpqeu+XAW79g3vUxvwX/GWC0WokQCO3BtuCk1S5/tt2ckZtuF4tScN5lz96Fq69T
 fh9ttyK9jDbbCiNt7CIzIYvCBeD/nrg13eLVnSHdtBxoRGiV2dt9J9rSWkIhAbNYI2Xq QQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 35cntm2yng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Dec 2020 15:05:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BFEuQZw071651;
        Tue, 15 Dec 2020 15:05:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 35d7swb3cy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Dec 2020 15:05:51 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BFF5o93006645;
        Tue, 15 Dec 2020 15:05:50 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Dec 2020 07:05:50 -0800
Date:   Tue, 15 Dec 2020 18:05:43 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     lsahlber@redhat.com
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] cifs: add an smb3_fs_context to cifs_sb
Message-ID: <X9jQx1UL0vVELxC+@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9835 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=899 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150106
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9835 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=909 impostorscore=0 priorityscore=1501 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012150107
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Ronnie Sahlberg,

The patch d17abdf75665: "cifs: add an smb3_fs_context to cifs_sb"
from Nov 10, 2020, leads to the following static checker warning:

	fs/cifs/cifsfs.c:876 cifs_smb3_do_mount()
	error: double free of 'cifs_sb->prepath'

fs/cifs/cifsfs.c
   813          rc = cifs_setup_cifs_sb(cifs_sb);
   814          if (rc) {
   815                  root = ERR_PTR(rc);
   816                  goto out;
   817          }
   818  
   819          rc = cifs_mount(cifs_sb, cifs_sb->ctx);
   820          if (rc) {
   821                  if (!(flags & SB_SILENT))
   822                          cifs_dbg(VFS, "cifs_mount failed w/return code = %d\n",
   823                                   rc);
   824                  root = ERR_PTR(rc);
   825                  goto out;
   826          }
   827  
   828          mnt_data.ctx = cifs_sb->ctx;
   829          mnt_data.cifs_sb = cifs_sb;
   830          mnt_data.flags = flags;
   831  
   832          /* BB should we make this contingent on mount parm? */
   833          flags |= SB_NODIRATIME | SB_NOATIME;
   834  
   835          sb = sget(fs_type, cifs_match_super, cifs_set_super, flags, &mnt_data);
   836          if (IS_ERR(sb)) {
   837                  root = ERR_CAST(sb);
   838                  cifs_umount(cifs_sb);

cifs_umount() frees everything.  Smatch doesn't catch some of it because
it happens in a delayed thread.

   839                  goto out;
   840          }
   841  
   842          if (sb->s_root) {
   843                  cifs_dbg(FYI, "Use existing superblock\n");
   844                  cifs_umount(cifs_sb);
                        ^^^^^^^^^^^^^^^^^^^^
This frees "cifs_sb".

   845          } else {
   846                  rc = cifs_read_super(sb);
   847                  if (rc) {
   848                          root = ERR_PTR(rc);
   849                          goto out_super;
   850                  }
   851  
   852                  sb->s_flags |= SB_ACTIVE;
   853          }
   854  
   855          root = cifs_get_root(cifs_sb->ctx, sb);
                                     ^^^^^^^^^^^^
So this is a use after free.

   856          if (IS_ERR(root))
   857                  goto out_super;
   858  
   859          cifs_dbg(FYI, "dentry root is: %p\n", root);
   860          return root;
   861  
   862  out_super:
   863          deactivate_locked_super(sb);
   864  out:
   865          if (cifs_sb) {
   866                  kfree(cifs_sb->prepath);
   867                  smb3_cleanup_fs_context(cifs_sb->ctx);
   868                  kfree(cifs_sb);

All these three are double frees.

   869          }
   870          return root;
   871  }

regards,
dan carpenter
