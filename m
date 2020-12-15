Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,BIGNUM_EMAILS,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 022D9C4361B
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Dec 2020 14:46:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5A31223D6
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Dec 2020 14:46:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729657AbgLOOp5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Dec 2020 09:45:57 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49800 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729651AbgLOOpy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 15 Dec 2020 09:45:54 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BFEdlCa141986;
        Tue, 15 Dec 2020 14:45:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=iJLMPEQ9ei4n18iHp10vmtNy1zjFKjOrFKDpxy1Ru1o=;
 b=eDNh8CFYkRZhksI4uYVkxpc5lljs939JF9oMRLzB+S2T52bjA1ePkxxkIlZg5aGjZ/HZ
 3xSc4Czy50qwo2i2ehrCINBJwS6Qikuc9mKhruPB1lpR0g0XPX2aP7HoUKM870reIhOT
 5ipBZnmXZau+Kbl1eZeC8CpHxSssiOMe4Fi8dFmDjW3/J8QNaF24SA877DUIp49XS821
 JPSCQbQoCe6VDVFfChXj/QMvrw8c7vX29wR1jZ46mj5oGX/+bTAPwnl6dwqp8NQaZUkP
 LfRogxM4Fg6MMUOf1cKyFpu30Ah4uApft33Xtb6ORgjZ4sw1TNYy/ue0xpZA6amhp6LJ FQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35cntm2u52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Dec 2020 14:45:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BFEZ84o162639;
        Tue, 15 Dec 2020 14:45:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 35e6jr75ns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Dec 2020 14:45:10 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BFEj8AA017660;
        Tue, 15 Dec 2020 14:45:08 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Dec 2020 06:45:07 -0800
Date:   Tue, 15 Dec 2020 17:45:01 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     scabrero@suse.de
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] cifs: Send witness register and unregister commands to
 userspace daemon
Message-ID: <X9jL7XurwuwzmIsm@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9835 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012150105
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9835 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012150105
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Samuel Cabrero,

The patch bf80e5d4259a: "cifs: Send witness register and unregister
commands to userspace daemon" from Nov 30, 2020, leads to the
following static checker warning:

	fs/cifs/cifs_swn.c:265 cifs_find_swn_reg()
	warn: passing a valid pointer to 'PTR_ERR'

fs/cifs/cifs_swn.c
   254  static struct cifs_swn_reg *cifs_find_swn_reg(struct cifs_tcon *tcon)
   255  {
   256          struct cifs_swn_reg *swnreg;
   257          int id;
   258          const char *share_name;
   259          const char *net_name;
   260  
   261          net_name = extract_hostname(tcon->treeName);
   262          if (IS_ERR_OR_NULL(net_name)) {
   263                  int ret;
   264  
   265                  ret = PTR_ERR(net_name);
                        ^^^^^^^^^^^^^^^^^^^^^^^

When a function returns *both* error pointers and NULL then NULL is not
an error.  Probably it's an optional feature which has been disabled.
If the function returns an error pointer then the function needs to
clean up and fail in the proper way.  Maybe print an error message.  If
it returns NULL then that means the feature has been diliberately
disabled.  Don't print an error code.

The extract_hostname() is not optional and never returns NULL pointers.

   266                  cifs_dbg(VFS, "%s: failed to extract host name from target '%s': %d\n",
   267                                  __func__, tcon->treeName, ret);
   268                  return NULL;
                        ^^^^^^^^^^^^

I guess probably the intention was to return an error pointer here and
a NULL if we were able to search for the existing swn reg.  But probably
it's simpler to just return either error pointers or NULLs on error and
be consistent about it.  There is no point in optimizing for the failure
case because that's not a fast path and it will just lead to bugs.

This function has two callers and one checks for both NULL and error
pointers and the other only checks for NULLs so returning an error
pointer would lead to bugs.

   269          }
   270  
   271          share_name = extract_sharename(tcon->treeName);
   272          if (IS_ERR_OR_NULL(share_name)) {
   273                  int ret;
   274  
   275                  ret = PTR_ERR(net_name);
   276                  cifs_dbg(VFS, "%s: failed to extract share name from target '%s': %d\n",
   277                                  __func__, tcon->treeName, ret);
   278                  kfree(net_name);
   279                  return NULL;
   280          }
   281  
   282          idr_for_each_entry(&cifs_swnreg_idr, swnreg, id) {
   283                  if (strcasecmp(swnreg->net_name, net_name) != 0
   284                      || strcasecmp(swnreg->share_name, share_name) != 0) {
   285                          continue;
   286                  }
   287  
   288                  mutex_unlock(&cifs_swnreg_idr_mutex);
   289  
   290                  cifs_dbg(FYI, "Existing swn registration for %s:%s found\n", swnreg->net_name,
   291                                  swnreg->share_name);
   292  
   293                  kfree(net_name);
   294                  kfree(share_name);
   295  
   296                  return swnreg;
   297          }
   298  
   299          kfree(net_name);
   300          kfree(share_name);
   301  
   302          return NULL;
   303  }

[ snip ]

   309  static struct cifs_swn_reg *cifs_get_swn_reg(struct cifs_tcon *tcon)
   310  {
   311          struct cifs_swn_reg *reg = NULL;
   312          int ret;
   313  
   314          mutex_lock(&cifs_swnreg_idr_mutex);
   315  
   316          /* Check if we are already registered for this network and share names */
   317          reg = cifs_find_swn_reg(tcon);
   318          if (IS_ERR(reg)) {
   319                  return reg;

This code checks for errors but the cifs_find_swn_reg() function only
returns NULL or valid pointers.

   320          } else if (reg != NULL) {
   321                  kref_get(&reg->ref_count);
   322                  mutex_unlock(&cifs_swnreg_idr_mutex);
   323                  return reg;
   324          }
   325  
   326          reg = kmalloc(sizeof(struct cifs_swn_reg), GFP_ATOMIC);
   327          if (reg == NULL) {
   328                  mutex_unlock(&cifs_swnreg_idr_mutex);
   329                  return ERR_PTR(-ENOMEM);
   330          }

regards,
dan carpenter
