Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E98E8C001DE
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Jul 2023 19:50:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbjG1Tum (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Jul 2023 15:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234973AbjG1Tul (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Jul 2023 15:50:41 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747B0448C
        for <linux-cifs@vger.kernel.org>; Fri, 28 Jul 2023 12:50:33 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1690573831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=95LJjiWvoxvT8lSZR4mlhxO1lfF8Gg4A/5jpnQs/5G0=;
        b=rvF6BUniGZ3tIR1thREVLXBTAnMVJCx4Q2FNTkzmH9NW/xLmCfUJ7QlzVNVgMoWHyy8ZD0
        1HCy6m/tBo9XF3cqNNE6qfjfBStjQHWw5VagaIZTGc3dtkA0NX5BUjzJqVue4uMWExZ9/z
        lxYVzgL3TgXVolwMs7Ix+j3kmMp59E3lA4dBPIjHL5tHKMBPNt0d/UtHMt0lC9VgsPDwqv
        LriegShOHKm/OECA+uzKUadSc/tb/0YPpEk4OW6Q8fEA0xXRzoiHh+RdtOEasXd/Ebx0OI
        2UPO9brEn86PJwyK86zcJjMgoJ3HGarnAVjtMLRbPE+Kv3g+9SUBvQe5gIWMqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1690573831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=95LJjiWvoxvT8lSZR4mlhxO1lfF8Gg4A/5jpnQs/5G0=;
        b=B+/6SAPueLgdu4acHkjNPQiQxOv27okMiF46fSQuZmSxNxe/VuIqF8fZHVrD4IeQw/yrMt
        JKS6uZVxAsTd2debIsvwcbNXzP7djPdGXcq9BiGPg8ojeI5v3gmQU6md+tLFHETA5L4m/i
        JfpXSyiKuI335ytJXWVzLt41cSH2tPoGZR7pJx0WA+Er0F+9ZPFx4gRHGnobl1XogDy8sa
        3AoM0AjyLhuMSix+SFMn57Py/ZogHopxSKps7yJIW/JeceHKuHBIoJqJzuclEnDgRz09a2
        RlKyHeBtxNl7kffgaAqryltI0TvUle+FLdqbAKCSa5iGJcovOm4P3moOO+suCA==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1690573831; a=rsa-sha256;
        cv=none;
        b=gDCOVj082BWSA57VMyND9uIkU9jYjnaAXxtIlc7i5AzkFzHRE4vrApcaE52BhFogKU8xG6
        QVGp79criCLOSm2Lmh8VBTBD4ddQu/xi+yzHrwCaD/VUPyYpA6oDgE1a0aaKbhGpACo8PD
        OjYSXjadGo2jGZc4Lzw4bTMUS1VKUxlFzNiIwajoRIYdEqHU4SDU5qll1mgmrQPCbWCqIW
        bfYFrkm7izIUtZ5cHZP8dsgPUm9B7yQbpAqjuHJKAxA4qJL3utG1W86HO8rXzXd1AQfIOD
        W70SFQgKwKhdtU7dLDXofgHbuIgBrh/rM03ZeVXf7MJsydQ33wtOrDwArWwT3Q==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 8/8] smb: client: reduce stack usage in cifs_demultiplex_thread()
Date:   Fri, 28 Jul 2023 16:50:10 -0300
Message-ID: <20230728195010.19122-8-pc@manguebit.com>
In-Reply-To: <20230728195010.19122-1-pc@manguebit.com>
References: <20230728195010.19122-1-pc@manguebit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Clang warns about exceeded stack frame size

  fs/smb/client/connect.c:1109:1: warning: stack frame size (1048)
  exceeds limit (1024) in 'cifs_demultiplex_thread'
  [-Wframe-larger-than]

It turns out that clean_demultiplex_info() got inlined into
cifs_demultiplex_thread(), so mark it as noinline_for_stack to save
some stack space.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/connect.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 238538dde4e3..ace1ec273364 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -911,8 +911,8 @@ cifs_enable_signing(struct TCP_Server_Info *server, bool mnt_sign_required)
 	return 0;
 }
 
-
-static void clean_demultiplex_info(struct TCP_Server_Info *server)
+static noinline_for_stack void
+clean_demultiplex_info(struct TCP_Server_Info *server)
 {
 	int length;
 
-- 
2.41.0

