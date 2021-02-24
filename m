Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB655C433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Feb 2021 12:44:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E3C264EC3
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Feb 2021 12:44:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbhBXMoj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Feb 2021 07:44:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53777 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbhBXMog (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 Feb 2021 07:44:36 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lEtWD-000284-Ck; Wed, 24 Feb 2021 12:43:53 +0000
To:     Shyam Prasad N <sprasad@microsoft.com>
From:   Colin Ian King <colin.king@canonical.com>
Subject: re: cifs: Retain old ACEs when converting between mode bits and ACL.
Cc:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <1ca0f87e-83b3-b4dd-4448-b44f2a9d1698@canonical.com>
Date:   Wed, 24 Feb 2021 12:43:52 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

Static analysis on linux-next with Coverity had detected a potential
null pointer dereference with the following commit:

commit f5065508897a922327f32223082325d10b069ebc
Author: Shyam Prasad N <sprasad@microsoft.com>
Date:   Fri Feb 12 04:38:43 2021 -0800

    cifs: Retain old ACEs when converting between mode bits and ACL.

The analysis is as follows:

1258 /* Convert permission bits from mode to equivalent CIFS ACL */
1259 static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd
*pnntsd,
1260        __u32 secdesclen, __u32 *pnsecdesclen, __u64 *pnmode, kuid_t
uid, kgid_t gid,
1261        bool mode_from_sid, bool id_from_sid, int *aclflag)
1262 {
1263        int rc = 0;
1264        __u32 dacloffset;
1265        __u32 ndacloffset;
1266        __u32 sidsoffset;
1267        struct cifs_sid *owner_sid_ptr, *group_sid_ptr;
1268        struct cifs_sid *nowner_sid_ptr = NULL, *ngroup_sid_ptr = NULL;

    1. assign_zero: Assigning: dacl_ptr = NULL.

1269        struct cifs_acl *dacl_ptr = NULL;  /* no need for SACL ptr */
1270        struct cifs_acl *ndacl_ptr = NULL; /* no need for SACL ptr */
1271        char *end_of_acl = ((char *)pntsd) + secdesclen;
1272        u16 size = 0;
1273
1274        dacloffset = le32_to_cpu(pntsd->dacloffset);

    2. Condition dacloffset, taking false branch.

1275        if (dacloffset) {
1276                dacl_ptr = (struct cifs_acl *)((char *)pntsd +
dacloffset);
1277                if (end_of_acl < (char *)dacl_ptr +
le16_to_cpu(dacl_ptr->size)) {
1278                        cifs_dbg(VFS, "Existing ACL size is wrong.
Discarding old ACL\n");
1279                        dacl_ptr = NULL;

NOTE: dacl_ptr is set to NULL and dacloffset is true

1280                }
1281        }
1282
1283        owner_sid_ptr = (struct cifs_sid *)((char *)pntsd +
1284                        le32_to_cpu(pntsd->osidoffset));
1285        group_sid_ptr = (struct cifs_sid *)((char *)pntsd +
1286                        le32_to_cpu(pntsd->gsidoffset));
1287

    3. Condition pnmode, taking true branch.
    4. Condition *pnmode != 18446744073709551615ULL, taking false
branch.

1288        if (pnmode && *pnmode != NO_CHANGE_64) { /* chmod */
1289                ndacloffset = sizeof(struct cifs_ntsd);
1290                ndacl_ptr = (struct cifs_acl *)((char *)pnntsd +
ndacloffset);
1291                ndacl_ptr->revision =
1292                        dacloffset ? dacl_ptr->revision :
cpu_to_le16(ACL_REVISION);
1293
1294                ndacl_ptr->size = cpu_to_le16(0);
1295                ndacl_ptr->num_aces = cpu_to_le32(0);
1296
1297                rc = set_chmod_dacl(dacl_ptr, ndacl_ptr,
owner_sid_ptr, group_sid_ptr,
1298                                    pnmode, mode_from_sid);
1299
1300                sidsoffset = ndacloffset + le16_to_cpu(ndacl_ptr->size);
1301                /* copy the non-dacl portion of secdesc */
1302                *pnsecdesclen = copy_sec_desc(pntsd, pnntsd, sidsoffset,
1303                                NULL, NULL);
1304
1305                *aclflag |= CIFS_ACL_DACL;
1306        } else {
1307                ndacloffset = sizeof(struct cifs_ntsd);
1308                ndacl_ptr = (struct cifs_acl *)((char *)pnntsd +
ndacloffset);

    5. Condition dacloffset, taking false branch.

1309                ndacl_ptr->revision =
1310                        dacloffset ? dacl_ptr->revision :
cpu_to_le16(ACL_REVISION);

    Explicit null dereferenced (FORWARD_NULL)

    6. var_deref_op: Dereferencing null pointer dacl_ptr.

1311                ndacl_ptr->num_aces = dacl_ptr->num_aces;


Line 1309..1311, when dacloffset and dacl_ptr is null we hit a null ptr
dereference on dacl_ptr.

