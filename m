Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C07ABC433ED
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Apr 2021 20:39:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95F1F61164
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Apr 2021 20:39:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349843AbhDNUji (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 14 Apr 2021 16:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343809AbhDNUi7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 14 Apr 2021 16:38:59 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B0CC061574
        for <linux-cifs@vger.kernel.org>; Wed, 14 Apr 2021 13:38:36 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id p23so21021658ljn.0
        for <linux-cifs@vger.kernel.org>; Wed, 14 Apr 2021 13:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=8fcj+tibl6GsmTAtgnMcKVReBlyewQ9LGH6F1XACcoc=;
        b=JLILpgpPCRiB3yhLzfoiaXapnrvrJEVOG5Gw/m87EUTNL5oUL5dmI9XNllnGDweUhM
         tSeMPJZNtPzWjeMkBAqQd1PZ20fzh07w85neHS3l89dBGc/RPSJ6XjSb0sXPqVUDv9Mt
         EgDFUVY82G7ZVF6Cwo1xk45hshdfynXUZIyb3LZqLzhULX0k0oYa+JLZAMvEdhmK75gT
         MfmCi0Kjk3L+afvokubtNVAXY9TINsMFioLz76ucy4Rhlnb6oaiNADF+8JL7n6fPaZGx
         XWMi4BU1LBZYKM9Dxqlrgj6mc/f0KkqdS6wFF0GDouBAAu8iRxqMq8Z6QL7ydqEqeQvq
         e6YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=8fcj+tibl6GsmTAtgnMcKVReBlyewQ9LGH6F1XACcoc=;
        b=gXRLhpV7q7pG7S8JuIa0YqTD75/GWMsYk3zY1JnScrdeUcAOvmEpgojgneRLmTOcFj
         dEyfSHtj3Pp3l+WYAIxexn1d4uA7D8KyhXhVDIDOdbiqcHeVCpmzS007GeDJnnzNwTUs
         M+1GNF44CD/OM6ZN+gWgV9qw2RdGb3VvpVd2OGmD/N85zOJFs17lDZLLTFiwiBm20GRO
         iumg0CZSqrE0ho8JWFRDLzfbAeTVwf+Q5TfgmbV2yVmXsRJXa2Dia44CbOWGLhMjP8FS
         srumrX+tGdp/oO2oeOElvomEeYSxfHra1xQjJIwGnLr2+zkmJ96sl5WOYUF3cP5a7s5r
         YqHQ==
X-Gm-Message-State: AOAM531BBzlHFDKnEZ6UHmzLNTqK1b1/BMGiq07pUbapkXaNDwh7/+nz
        lVJRBpFianuKfHS13xXKTpWaUiXHrV1rRebGKFh9Zeq1jJg=
X-Google-Smtp-Source: ABdhPJyyAR/W+s6gCb2f5oo9phT40SB2GX8NN7pxwLaBv7fVa2jRhFC0cL3q8PkrWpoeDQI0hyBswqt8BAKSIK6/avM=
X-Received: by 2002:a2e:9082:: with SMTP id l2mr8915576ljg.272.1618432715075;
 Wed, 14 Apr 2021 13:38:35 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 14 Apr 2021 15:38:24 -0500
Message-ID: <CAH2r5mtnRaESzGuZf+J89H+G6FdF-dPfJxqURGLT2G4H3FZR4w@mail.gmail.com>
Subject: Buildbot kernel build rpm error
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Any ideas why every other build of the kernel (for the buildbot
automated testing) fails with this (even if no code changed):

See e.g. http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/569
(and every other test run before that in last few days)

Wrote: /root/rpmbuild/RPMS/x86_64/kernel-5.12.0_rc7-1.x86_64.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/kernel-headers-5.12.0_rc7-1.x86_64.rpm
Executing(%clean): /bin/sh -e /var/tmp/rpm-tmp.1YI7Dw
+ umask 022
+ cd .
+ rm -rf /root/rpmbuild/BUILDROOT/kernel-5.12.0_rc7-1.x86_64
+ exit 0
[*] stored new cache build
/tmp/kbuildcache/148df99b5d245d132a1fba07a172097721299031be12e092d324a1c02fcd68f5
[*] removing old cache entry
/tmp/kbuildcache/9bbac9f327189cbe0e7ab4816965528b82ac537e1f2b5267d139ef874f48874f
Traceback (most recent call last):
  File "/root/buildbot/scripts/kernel-cache", line 117, in <module>
    main()
  File "/root/buildbot/scripts/kernel-cache", line 37, in main
    cache.add_cache(args.rev, args.config, args.files)
  File "/root/buildbot/scripts/kernel-cache", line 92, in add_cache
    shutil.rmtree(e)
  File "/usr/lib64/python3.6/shutil.py", line 477, in rmtree
    onerror(os.lstat, path, sys.exc_info())
  File "/usr/lib64/python3.6/shutil.py", line 475, in rmtree
    orig_st = os.lstat(path)
TypeError: lstat: path should be string, bytes or os.PathLike, not tuple


Repeating the build it works (this seems new to 5.12-rc7)


-- 
Thanks,

Steve
