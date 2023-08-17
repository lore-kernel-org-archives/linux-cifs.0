Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5F89C3DA45
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Aug 2023 15:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352756AbjHQPfo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Aug 2023 11:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353238AbjHQPf2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Aug 2023 11:35:28 -0400
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78AD30DE
        for <linux-cifs@vger.kernel.org>; Thu, 17 Aug 2023 08:35:26 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=L3TdGOB09yuHzHodf32k9qZeUpG9cgywUb5exfqeM7Y=;
        b=TpKyvdLQCXY34Cc7zz0z792+B2EdwUIF9KU6/XncnG8JX6MhbUIveK6dLB1Ud8pBRis2aP
        H3s6cLq5laTiea7Y8QfN7mlW7WmkWFbSCUp/MMutoChEXypj0VnXKsIItxGe2Ubp9IFWNS
        4o+Zpr43kh9IFKaOyQ4VqhY/XHtJJ/LG/Oo5wU64MXgf/5SaZ5gfd8uVIKFjOaQhiHpy4b
        LGmwGbBp8HyZsKhGmRReqdLP1qolbnVZhY+AL2R40JfWFvi6C3/r+bK2Qm9k/zcdzwcFTr
        SIkhoqK6YbeUoseJMzYwQC5Tyx/yYPu+DIsPk5gU26nZPGaeNybSr1PPXSxl8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=L3TdGOB09yuHzHodf32k9qZeUpG9cgywUb5exfqeM7Y=;
        b=Zho60JC4W+aAqiSupT4CFyHJd47Py+agi7jsdeX44y+pcbymXobptDcqXB6p0enNNXiRSg
        2j/6QN6XWa7aI8PklRKwteJ3Vd42gFM5tRJqvucvWHfmigpi8ein5yRlQA9LmRo7NZqzfR
        wvkHOfyWmsD2t0hiRZe2MC4Ztbgzm6Fk/uKo9CPZyuLNJ0p4KUdFkCEjUW1plom/uoBb6V
        bGcG4nomCvInal4b3qFfs/oR7ovAlHq4Ya5wOT0gqlNS9adsKa8Ex1BfS86iEQ740Cjdm0
        cENgZ7CtDKy1BHwZZUZ0kKdFaHUJN5d7jRk8EPlt0hX7sN78qI04dvrHqw0NsQ==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1692286525; a=rsa-sha256;
        cv=none;
        b=YTrYDWYeCpfCT1eEoptveKpenQBeUv7BzwTbPUry49A5SytO4GzWNwBOgIvRWsGqEkOksI
        PixIXDwxuGS3OPZAWaS/6p+S0YmBCnhaFZpo4T9XgwJqc/m/+iEyrLj+KB9c5bjiakhLla
        OXaCHKoeVbyZNPwsyEq1gl/8NLj3pSVgXvKvkXq+8ozi4fYfy4xXIkw26zLr2rHB+tweNe
        D/Wno8Qu2FTTkgYJDFw6PWA8LJUD848lyrDgHuSPTvFLYmIhigHrN/S+I9nQnQY5Lof5pz
        izaZQxOBblb2RtQ8L80HKz85lTre1WNgfgcv3FbcWHaScqYrS7buV+FkEp/Ehw==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 00/17] cifs.ko fixes
Date:   Thu, 17 Aug 2023 12:33:58 -0300
Message-ID: <20230817153416.28083-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

Follow patchset with DFS, reparse point and -Wframe-larger-than fixes
for v6.6.

Please review & test.

Paulo Alcantara (17):
  smb: client: introduce DFS_CACHE_TGT_LIST()
  smb: client: ensure to try all targets when finding nested links
  smb: client: move some params to cifs_open_info_data
  smb: client: make smb2_compound_op() return resp buffer on success
  smb: client: rename cifs_dfs_ref.c to namespace.c
  smb: client: get rid of dfs naming in automount code
  smb: client: get rid of dfs code dep in namespace.c
  smb: client: parse reparse point flag in create response
  smb: client: do not query reparse points twice on symlinks
  smb: client: query reparse points in older dialects
  smb: cilent: set reparse mount points as automounts
  smb: client: reduce stack usage in cifs_try_adding_channels()
  smb: client: reduce stack usage in cifs_demultiplex_thread()
  smb: client: reduce stack usage in smb_send_rqst()
  smb: client: reduce stack usage in smb2_set_ea()
  smb: client: reduce stack usage in smb2_query_info_compound()
  smb: client: reduce stack usage in smb2_query_reparse_point()

 fs/smb/client/Makefile                        |   5 +-
 fs/smb/client/cifsfs.c                        |   2 +-
 fs/smb/client/cifsfs.h                        |  11 +-
 fs/smb/client/cifsglob.h                      |  69 ++-
 fs/smb/client/cifsproto.h                     |   9 +-
 fs/smb/client/connect.c                       |   8 +-
 fs/smb/client/dfs.c                           | 291 +++++-----
 fs/smb/client/dfs.h                           | 141 +++--
 fs/smb/client/dfs_cache.c                     |  10 +-
 fs/smb/client/dfs_cache.h                     |  12 +-
 fs/smb/client/dir.c                           |   4 +-
 fs/smb/client/inode.c                         | 530 ++++++++++--------
 fs/smb/client/{cifs_dfs_ref.c => namespace.c} | 113 ++--
 fs/smb/client/readdir.c                       |  23 +-
 fs/smb/client/sess.c                          |  68 ++-
 fs/smb/client/smb1ops.c                       |  26 +-
 fs/smb/client/smb2inode.c                     | 199 ++++---
 fs/smb/client/smb2ops.c                       | 283 +++-------
 fs/smb/client/smb2proto.h                     |  17 +-
 fs/smb/client/transport.c                     |  29 +-
 20 files changed, 993 insertions(+), 857 deletions(-)
 rename fs/smb/client/{cifs_dfs_ref.c => namespace.c} (62%)

-- 
2.41.0

