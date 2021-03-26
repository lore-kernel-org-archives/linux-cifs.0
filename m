Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE67BC433DB
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Mar 2021 02:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95D6961A41
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Mar 2021 02:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhCZCLb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Mar 2021 22:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230411AbhCZCLU (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 25 Mar 2021 22:11:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E9B061A2B;
        Fri, 26 Mar 2021 02:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616724680;
        bh=L6FNDAlxyI+VHb0dFbN2zoboHKOrSkFgt+OL1GNZULo=;
        h=Date:From:To:Cc:Subject:From;
        b=CnmC9DqHLIpTf98be4JX/MPM+4bjm017hCZHneBvSFHKlpaGbAezWbaUwXIK+BjAC
         sHMjN0F9CjQoFCuHEO1bXq+hrzguZIGUi2sG7gvePwxb5gcx2NcEnW1JzZWKirOBym
         S2Z5Aa5IN6rQaUi7cZtc+ZvT+5b11jXbAunTlg+tjDqQatl2g5LVSM8HYt0p1NB0RG
         An3VqW1a6fKYiPKj+IAwMV545AETIxqRZ64ljlKReJ6YBjM4sAmau2r9Liqu6n6Gb/
         E+gmUw5b86zx4PMmXYLdovFbatYcqll0wLV5qiFkFG/PPyHPc3ZOIBWw1o8DCw6DU8
         PLwdD052wu1SQ==
Date:   Thu, 25 Mar 2021 20:11:17 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Steve French <sfrench@samba.org>
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] cifs: cifspdu.h: Replace one-element array with
 flexible-array member
Message-ID: <20210326011117.GA46303@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

There is a regular need in the kernel to provide a way to declare having
a dynamically sized set of trailing elements in a structure. Kernel code
should always use “flexible array members”[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

Also, this helps with the ongoing efforts to enable -Warray-bounds by
fixing the following warning:

  CC [M]  fs/cifs/cifssmb.o
fs/cifs/cifssmb.c: In function ‘CIFSFindNext’:
fs/cifs/cifssmb.c:4636:23: warning: array subscript 1 is above array bounds of ‘char[1]’ [-Warray-bounds]
 4636 |   pSMB->ResumeFileName[name_len+1] = 0;
      |   ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/109
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 fs/cifs/cifspdu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index 64fe5a47b5e8..475a517360e5 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -1898,7 +1898,7 @@ typedef struct smb_com_transaction2_fnext_req {
 	__le16 InformationLevel;
 	__u32 ResumeKey;
 	__le16 SearchFlags;
-	char ResumeFileName[1];
+	char ResumeFileName[];
 } __attribute__((packed)) TRANSACTION2_FNEXT_REQ;
 
 typedef struct smb_com_transaction2_fnext_rsp {
-- 
2.27.0

