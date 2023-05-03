Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 084C9C77B75
	for <linux-cifs@archiver.kernel.org>; Wed,  3 May 2023 22:21:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjECWVs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 May 2023 18:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjECWVr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 May 2023 18:21:47 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894EA8A41
        for <linux-cifs@vger.kernel.org>; Wed,  3 May 2023 15:21:42 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1683152498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qS6Z0gpNfpvyhubK+TNPGYfmfNyo5Q+wVyCrg0Wv+y8=;
        b=sdTXJmKPWW+R5Jqn80LvwIVp/kVxFefE5r9QaVII4fclS5VNAoyT0mh/nhk/0EE3O12Zvw
        0JqKmVdYUD6ynvQeHtSq9nhS+f5HxnKhS/zwAE0V2i0m8fY34bOvKubLpEaBpdYGtWTCGs
        a6AcNCf6dPJZglrNwuGvw4zthRD9XHLGpRbfDwMKrg/MNm953XuT4356hWVgJzFokVcAlK
        oYVjGhGUVjZpAGgjztsw9Kz/RKlun6l1avb2DkNl8Vntn7b8js4bgNuUfmINi2HdnMpzr6
        Y4qNJAae14Ho0s4WiiR9yGUJk0ovgFOiocD1lqX4rgg/dvawO5Rw3JD4dciKJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1683152498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qS6Z0gpNfpvyhubK+TNPGYfmfNyo5Q+wVyCrg0Wv+y8=;
        b=HEUPaotMRuKXZ1yduILrLB7FvieV3nkdltat1LEUlAY1ufFRD1fd2AOg+ISY+nZtyVaMoy
        r9P20FvLhVrqkfvXp2ZOkCBL2gO5OzoV3uRTVLIC58EGvKZCurQd3jTg7TNXKrWasM6rRe
        njuQ2v+6qQU/UrF++6wNcjiGnV4gflgbN0CiNIy/QQ/ikJWGvH5Frbyo3PquFDsN0qQvc7
        piUA/XIrRR34OvTpmQW/zHGbwn67rMj/5O9/6FCW7tLI/EStFS+euUfuFBIeSeiqkep/uv
        nvPzdM4q+MsBvHs0hHMsnn91Kn9xk+OCPbECnMyGhyFLS4fMlnJU2wakFSMh7w==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1683152498; a=rsa-sha256;
        cv=none;
        b=q8vZypO6J1Y64hxHdULRiMoIJCSnY9L+mCbQ3crVSFcBFVYjkEpHpZsvSGzv87RmyG3I2a
        b6C2uh/qe3PlJclSlDAKJmVvfTMZkDHZClSwtjHCyAKb7x6d1UAbdXovjYtgxCnsggNZ55
        VMxatjHx9oIfJ+7jkHNDyWiCfRwXKE8Dds7E0dE0ptKKz+anorF/survPCItEaRCPVO4MF
        AD7yYptCRu8GehD5Kw8f0kao5+iwYJ192f18cWByu6Km0QJdos+D4HAy+wXbTbizlYwFjt
        BETbwZqbQjDaQK3PBWyOsVxFGYMBnwk8t6AfjXXJ2i4y4pKWzBh2ZpOESI4TLw==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 0/7] cifs.ko fixes
Date:   Wed,  3 May 2023 19:21:10 -0300
Message-Id: <20230503222117.7609-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

Follow a series of bugfixes that were mostly found by doing some
stress testing over the reconnect paths. I was able to find most of
the issues by hard-coding the DFS cache ttl to 10 seconds which made
it running several times on every reconnect test.

Please review and test.

Paulo Alcantara (7):
  cifs: fix potential race when tree connecting ipc
  cifs: fix potential use-after-free bugs in TCP_Server_Info::hostname
  cifs: protect session status check in smb2_reconnect()
  cifs: protect access of TCP_Server_Info::{origin,leaf}_fullpath
  cifs: print smb3_fs_context::source when mounting
  cifs: avoid potential races when handling multiple dfs tcons
  cifs: fix sharing of DFS connections

 fs/cifs/cifs_debug.c |   7 ++-
 fs/cifs/cifs_debug.h |  12 ++--
 fs/cifs/cifsfs.c     |  14 ++---
 fs/cifs/cifsglob.h   |  23 ++++---
 fs/cifs/cifsproto.h  |  44 ++++++++++++-
 fs/cifs/connect.c    | 145 ++++++++++++++++++++++++-------------------
 fs/cifs/dfs.c        | 137 ++++++++++++++++++++++++++++++----------
 fs/cifs/dfs.h        |  13 +++-
 fs/cifs/dfs_cache.c  | 137 ++++++++++++++++++----------------------
 fs/cifs/dfs_cache.h  |   9 +++
 fs/cifs/ioctl.c      |   2 +-
 fs/cifs/sess.c       |   7 ++-
 fs/cifs/smb2pdu.c    |  19 ++++--
 13 files changed, 360 insertions(+), 209 deletions(-)

-- 
2.40.1

