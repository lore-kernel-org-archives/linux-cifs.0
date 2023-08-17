Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA5EC3065D
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Aug 2023 15:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352322AbjHQPgP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Aug 2023 11:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352649AbjHQPft (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 17 Aug 2023 11:35:49 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19A630C5
        for <linux-cifs@vger.kernel.org>; Thu, 17 Aug 2023 08:35:47 -0700 (PDT)
From:   Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZFfThoOQW9o4qr0HUpa3Vb36F6/+z8NMM3fvFNNomg0=;
        b=LuJLNvMxedYVMA9FMRzZtR2Er4kxg/b2yttmz1XSR4B9zM4RQTP1uwfplZwkeK0hN6ei2k
        i5G4j88Sg1NguPqudOOy6czfO3JdAscpoGjKYi3dmc4Jit3YPnqurHDSRvUMbBsKogvD+Q
        QkGb2Lhj/v1ymAz5wN3WYLFxuylBw5o24Osgh2kz+uFBKgWlw5jWaB2ZN7Fe+O1rd3dFuE
        ESq6tVLkLeyzcld5S+xQQsF5swsAq8tR8xvHnLv9f/bwoebkY3oK6Nnjc8uW9gJJRNEifW
        awsP1t9NTMcA1ftVOm10fZ+RDJC0H6lZOvqNnIEXBMVxmEJt7N+s0bsxvONzLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1692286546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZFfThoOQW9o4qr0HUpa3Vb36F6/+z8NMM3fvFNNomg0=;
        b=ImXDQhPsaA/gKy6644vXCdH2+R55pzWPJqghBlXwld/cDcFRC8ENZORaPc2oPkOteqbE/F
        8LehhXikktp6e7ESWoArU+KUqCtgLMoTgmNDIgUBIFO+KJxmYYB4BEjzlMvpLaPkxbBKS9
        mlUNSNq6B1CoTAA0iZ+2Mu8NtHlcVV3SJTSPj5Ie+qYaCZ4TAf+svqFnhHNGS/8tATQjlV
        OLv6pIYxDeOJkGXNZJ5jHjAx4GCO+UBJnMTeu6c3lfOvkDuxUpIEyJ3u7A7Qo9QG8wtV1a
        FbqMgyX8dTzPTBDRRs6Ax3m7ZEaGq5X3GJXMm3fK77dSPDTO7Iik3lzjEML/bA==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1692286546; a=rsa-sha256;
        cv=none;
        b=JTy51eu5xE+uLL7Yd3g9tXuUirEnEl6g9X4qrr3nX2HUUhiRVURKD+r87FvlXLJYno+j2p
        vDGDGcgN83PawIYPuWlO1WBIQgCB6x1oY1WXhAWl0rXWnrpHj2sRIb8VJLr+R8i2eBfBhd
        sezOJ8lU7n7M7NjbyVMBK5kNhKGB9vo5lS5qDwEU2BVGUdh38dW7Aa08q7IOEHy6qkRZZx
        Tl/YYGI8yJYZqKcckRA6vWvLlT857OWksfnQ9YBaTF6MBxJlT/0AXnFTp8/W8jF1Yyld8M
        ykUrcvt/ICl7xWM8LfWnInWZ1IdebsLJqMEaIOz0zMDZaAb18fsfBV9uppJ2ZQ==
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 13/17] smb: client: reduce stack usage in cifs_demultiplex_thread()
Date:   Thu, 17 Aug 2023 12:34:11 -0300
Message-ID: <20230817153416.28083-14-pc@manguebit.com>
In-Reply-To: <20230817153416.28083-1-pc@manguebit.com>
References: <20230817153416.28083-1-pc@manguebit.com>
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
index b3461d5d0f7d..e19a9c81a5fa 100644
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

