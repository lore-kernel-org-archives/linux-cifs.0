Return-Path: <SRS0=6r7N=3F=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B104DC33CAF
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jan 2020 19:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 880C62073A
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jan 2020 19:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388093AbgAPTKM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Jan 2020 14:10:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48777 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbgAPTKL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Jan 2020 14:10:11 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1isAWt-0006N4-Si; Thu, 16 Jan 2020 19:10:07 +0000
From:   Colin Ian King <colin.king@canonical.com>
Autocrypt: addr=colin.king@canonical.com; prefer-encrypt=mutual; keydata=
 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
To:     "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: re: cifs: Avoid doing network I/O while holding cache lock
Message-ID: <26f61914-3c0d-4911-7f21-23967839554c@canonical.com>
Date:   Thu, 16 Jan 2020 19:10:07 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

static analysis with Coverity has detected an issue with the following
commit:

commit 03535b72873ba74e80e6938b5f772cf5b07ca76b
Author: Paulo Alcantara (SUSE) <pc@cjr.nz>
Date:   Wed Dec 4 17:38:03 2019 -0300

    cifs: Avoid doing network I/O while holding cache lock



This commit removed a memset on the vol object, causing the issue as
reported below by Coverity:

1342static struct cifs_ses *find_root_ses(struct vol_info *vi,
1343                                      struct cifs_tcon *tcon,
1344                                      const char *path)
1345{
1346        char *rpath;
1347        int rc;
1348        struct cache_entry *ce;
1349        struct dfs_info3_param ref = {0};
1350        char *mdata = NULL, *devname = NULL;
1351        struct TCP_Server_Info *server;
1352        struct cifs_ses *ses;

    1. var_decl: Declaring variable vol without initializer.
1353        struct smb_vol vol;
1354
1355        rpath = get_dfs_root(path);

    2. Condition IS_ERR(rpath), taking false branch.
1356        if (IS_ERR(rpath))
1357                return ERR_CAST(rpath);
1358
1359        down_read(&htable_rw_lock);
1360
1361        ce = lookup_cache_entry(rpath, NULL);

    3. Condition IS_ERR(ce), taking true branch.
1362        if (IS_ERR(ce)) {
1363                up_read(&htable_rw_lock);
1364                ses = ERR_CAST(ce);

    4. Jumping to label out.
1365                goto out;
1366        }
1367
1368        rc = setup_referral(path, ce, &ref, get_tgt_name(ce));
1369        if (rc) {
1370                up_read(&htable_rw_lock);
1371                ses = ERR_PTR(rc);
1372                goto out;
1373        }
1374
1375        up_read(&htable_rw_lock);
1376
1377        mdata = cifs_compose_mount_options(vi->mntdata, rpath, &ref,
1378                                           &devname);
1379        free_dfs_info_param(&ref);
1380
1381        if (IS_ERR(mdata)) {
1382                ses = ERR_CAST(mdata);
1383                mdata = NULL;
1384                goto out;
1385        }
1386
1387        rc = cifs_setup_volume_info(&vol, mdata, devname, false);
1388        kfree(devname);
1389
1390        if (rc) {
1391                ses = ERR_PTR(rc);
1392                goto out;
1393        }
1394
1395        server = get_tcp_server(&vol);
1396        if (!server) {
1397                ses = ERR_PTR(-EHOSTDOWN);
1398                goto out;
1399        }
1400
1401        ses = cifs_get_smb_ses(server, &vol);
1402
1403out:

    5. uninit_use_in_call: Using uninitialized value vol.username when
calling cifs_cleanup_volume_info_contents.

    6. uninit_use_in_call: Using uninitialized value vol.password when
calling cifs_cleanup_volume_info_contents.

    7. uninit_use_in_call: Using uninitialized value vol.domainname when
calling cifs_cleanup_volume_info_contents.

    8. uninit_use_in_call: Using uninitialized value vol.UNC when
calling cifs_cleanup_volume_info_contents.

    9. uninit_use_in_call: Using uninitialized value vol.iocharset when
calling cifs_cleanup_volume_info_contents.

 Uninitialized pointer read
   10. uninit_use_in_call: Using uninitialized value vol.prepath when
calling cifs_cleanup_volume_info_contents.

1404        cifs_cleanup_volume_info_contents(&vol);
1405        kfree(mdata);
1406        kfree(rpath);

The vol object is memset as a result of calling cifs_setup_volume_info()
but this is too late for the earlier jumps to the error cleanup path at
label out.  I did think about putting this back but it adds an
unnecessary memset, a better fix may be return immediately or to exit
via the kfree(mdata) at the end of the function.

Not sure what is best, so I'm flagging this up as an issue that needs
fixing.

Colin
