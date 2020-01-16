Return-Path: <SRS0=6r7N=3F=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C04EC33CAF
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jan 2020 22:06:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EABC20748
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jan 2020 22:06:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nc0X5ckw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389764AbgAPWGw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Jan 2020 17:06:52 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:40937 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729260AbgAPWGw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Jan 2020 17:06:52 -0500
Received: by mail-io1-f68.google.com with SMTP id x1so23695988iop.7;
        Thu, 16 Jan 2020 14:06:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=knzeQPpwpmUJ11TawlbFVOi7iUcMTe9UXbqXHmIy6x8=;
        b=Nc0X5ckwS0Uncvh6W9RMln28oDNFJf92A6ApU1c+wkQPPYhW1nbCAiqa/woL1MRNct
         8y1KcS2KVv7lCAEthRdvlIIB9F/whSaW+ngES7vrub2eyoGIGn28Z2yEyAWC/oHfJxR8
         bcdgICJ76pHCkarN8qfZe9gRvcDncD08jVk1fSHMJ8lJejjeeSgGDSgXkaDec+59yQ//
         /wAKv1uAlXU2wdf8TfZI2HzllyGqSSMjMh1pV00RwhDJgQVAM1/dDBf143Teaa/pB1MJ
         KxqOuGZhQ4YXUUXu/mMiToQcY4VqNHxOqGa/H3Lib8ObAFwnHLgc8Ri5mkbmSOHLX+sW
         xQdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=knzeQPpwpmUJ11TawlbFVOi7iUcMTe9UXbqXHmIy6x8=;
        b=aKFJQC7XZInBHRtIFdQapLmbcbqrxrncAHvoxZO3j20RTxraXG4pQqTtvpEp9pxSQO
         +i503SExvx34kEEpZG0Lci/jEWx0Lkhnv9WW3ka80kFp5kFJt97Lm7Hy2+3pCPto+kU/
         V0FJv7gwbmJEsGa9y6rg039fA82Hjm6NMI56g4+qKKrzhXgmRP6AVnn1uj35N0p35fO9
         l8rycI/vzh0YpsJLpIEDNrd9uHJWzGVHbgZaFHV8w2pRbWnBu4cZw92QG9OPr7PpwtRJ
         sVqruhrGYRGzNyUiif+fu3OzyJYu1KziedVHJkJKkOdmmmDEGRnA8SCNUU7m5dY5klgr
         y8Fw==
X-Gm-Message-State: APjAAAW9oWSFRf1XI7bUzGqGy/SRAt34veeBUcFrF7sVH7si+NnBqtyn
        DIq+rGKtBWZKSRR8xasE5lAXKNF3lvhE3ANayRc=
X-Google-Smtp-Source: APXvYqxLK0nmek4moXMlWTzFOChCalpCN0T4wM+Ql3A33S8tK9KrwjxQPrkF8tPOqUuEVelBvumhZG++ugI41Oliorc=
X-Received: by 2002:a05:6638:6a6:: with SMTP id d6mr30886433jad.132.1579212411258;
 Thu, 16 Jan 2020 14:06:51 -0800 (PST)
MIME-Version: 1.0
References: <26f61914-3c0d-4911-7f21-23967839554c@canonical.com>
In-Reply-To: <26f61914-3c0d-4911-7f21-23967839554c@canonical.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 16 Jan 2020 16:06:40 -0600
Message-ID: <CAH2r5msT7GjFLGBbu40cYu3ZuwvWtdsCNM5V8n67o4uguC95Yg@mail.gmail.com>
Subject: Re: cifs: Avoid doing network I/O while holding cache lock
To:     Colin Ian King <colin.king@canonical.com>
Cc:     "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Added the one line patch from Paulo to address what Colin reported and
added a "Reported-by" for Colin mentioning Coverity.  merged into
cifs-2.6.git for-next

On Thu, Jan 16, 2020 at 1:10 PM Colin Ian King <colin.king@canonical.com> wrote:
>
> Hi,
>
> static analysis with Coverity has detected an issue with the following
> commit:
>
> commit 03535b72873ba74e80e6938b5f772cf5b07ca76b
> Author: Paulo Alcantara (SUSE) <pc@cjr.nz>
> Date:   Wed Dec 4 17:38:03 2019 -0300
>
>     cifs: Avoid doing network I/O while holding cache lock
>
>
>
> This commit removed a memset on the vol object, causing the issue as
> reported below by Coverity:
>
> 1342static struct cifs_ses *find_root_ses(struct vol_info *vi,
> 1343                                      struct cifs_tcon *tcon,
> 1344                                      const char *path)
> 1345{
> 1346        char *rpath;
> 1347        int rc;
> 1348        struct cache_entry *ce;
> 1349        struct dfs_info3_param ref = {0};
> 1350        char *mdata = NULL, *devname = NULL;
> 1351        struct TCP_Server_Info *server;
> 1352        struct cifs_ses *ses;
>
>     1. var_decl: Declaring variable vol without initializer.
> 1353        struct smb_vol vol;
> 1354
> 1355        rpath = get_dfs_root(path);
>
>     2. Condition IS_ERR(rpath), taking false branch.
> 1356        if (IS_ERR(rpath))
> 1357                return ERR_CAST(rpath);
> 1358
> 1359        down_read(&htable_rw_lock);
> 1360
> 1361        ce = lookup_cache_entry(rpath, NULL);
>
>     3. Condition IS_ERR(ce), taking true branch.
> 1362        if (IS_ERR(ce)) {
> 1363                up_read(&htable_rw_lock);
> 1364                ses = ERR_CAST(ce);
>
>     4. Jumping to label out.
> 1365                goto out;
> 1366        }
> 1367
> 1368        rc = setup_referral(path, ce, &ref, get_tgt_name(ce));
> 1369        if (rc) {
> 1370                up_read(&htable_rw_lock);
> 1371                ses = ERR_PTR(rc);
> 1372                goto out;
> 1373        }
> 1374
> 1375        up_read(&htable_rw_lock);
> 1376
> 1377        mdata = cifs_compose_mount_options(vi->mntdata, rpath, &ref,
> 1378                                           &devname);
> 1379        free_dfs_info_param(&ref);
> 1380
> 1381        if (IS_ERR(mdata)) {
> 1382                ses = ERR_CAST(mdata);
> 1383                mdata = NULL;
> 1384                goto out;
> 1385        }
> 1386
> 1387        rc = cifs_setup_volume_info(&vol, mdata, devname, false);
> 1388        kfree(devname);
> 1389
> 1390        if (rc) {
> 1391                ses = ERR_PTR(rc);
> 1392                goto out;
> 1393        }
> 1394
> 1395        server = get_tcp_server(&vol);
> 1396        if (!server) {
> 1397                ses = ERR_PTR(-EHOSTDOWN);
> 1398                goto out;
> 1399        }
> 1400
> 1401        ses = cifs_get_smb_ses(server, &vol);
> 1402
> 1403out:
>
>     5. uninit_use_in_call: Using uninitialized value vol.username when
> calling cifs_cleanup_volume_info_contents.
>
>     6. uninit_use_in_call: Using uninitialized value vol.password when
> calling cifs_cleanup_volume_info_contents.
>
>     7. uninit_use_in_call: Using uninitialized value vol.domainname when
> calling cifs_cleanup_volume_info_contents.
>
>     8. uninit_use_in_call: Using uninitialized value vol.UNC when
> calling cifs_cleanup_volume_info_contents.
>
>     9. uninit_use_in_call: Using uninitialized value vol.iocharset when
> calling cifs_cleanup_volume_info_contents.
>
>  Uninitialized pointer read
>    10. uninit_use_in_call: Using uninitialized value vol.prepath when
> calling cifs_cleanup_volume_info_contents.
>
> 1404        cifs_cleanup_volume_info_contents(&vol);
> 1405        kfree(mdata);
> 1406        kfree(rpath);
>
> The vol object is memset as a result of calling cifs_setup_volume_info()
> but this is too late for the earlier jumps to the error cleanup path at
> label out.  I did think about putting this back but it adds an
> unnecessary memset, a better fix may be return immediately or to exit
> via the kfree(mdata) at the end of the function.
>
> Not sure what is best, so I'm flagging this up as an issue that needs
> fixing.
>
> Colin



-- 
Thanks,

Steve
