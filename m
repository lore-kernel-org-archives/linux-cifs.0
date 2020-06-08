Return-Path: <SRS0=+oFK=7W=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A7A4C433E0
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Jun 2020 00:40:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BF5220737
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Jun 2020 00:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591663240;
	bh=/NuFylKYNPyDDOeCa8iVy8iU0GGgtO7xiwTEGWdB8z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=jbngUz04niMP+cLFLzHXsYNxViSRIUOQ4rkuNtYRdb3/8eYC34ogXtXwmstqFNrTU
	 poWQCnIe2inGpobOmL1s2VzzFckMUVwUs6nlqvBjUPL4AEyHi8ZcwEuiWSJ5ZblXO9
	 QdZ5Ehs5gR+u9qQdhIaLFP5GUiRdbq+/CThnCoU4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730881AbgFIAkh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Jun 2020 20:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728809AbgFHXM7 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27AEC20B80;
        Mon,  8 Jun 2020 23:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657979;
        bh=/NuFylKYNPyDDOeCa8iVy8iU0GGgtO7xiwTEGWdB8z4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CreuCoCj2y3pUpno4G3ng1z3pVcCSHRW3TjL2IjmOTKovnMLYnA0VRKqVdrzuG/rU
         wzuD9Wen3Se/k90EAxhw3b5N69/uqPaFvfapjved/bTQLCKGBDaopH5Go2wm9cVt2u
         piCQUTb8YyY7wCHMMGFUAMk+GOAjYOulG+A5aQ7Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adam McCoy <adam@forsedomani.com>,
        Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.6 040/606] cifs: fix leaked reference on requeued write
Date:   Mon,  8 Jun 2020 19:02:45 -0400
Message-Id: <20200608231211.3363633-40-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Adam McCoy <adam@forsedomani.com>

commit a48137996063d22ffba77e077425f49873856ca5 upstream.

Failed async writes that are requeued may not clean up a refcount
on the file, which can result in a leaked open. This scenario arises
very reliably when using persistent handles and a reconnect occurs
while writing.

cifs_writev_requeue only releases the reference if the write fails
(rc != 0). The server->ops->async_writev operation will take its own
reference, so the initial reference can always be released.

Signed-off-by: Adam McCoy <adam@forsedomani.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Stable <stable@vger.kernel.org>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/cifssmb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 6f6fb3606a5d..a4545aa04efc 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2138,8 +2138,8 @@ cifs_writev_requeue(struct cifs_writedata *wdata)
 			}
 		}
 
+		kref_put(&wdata2->refcount, cifs_writedata_release);
 		if (rc) {
-			kref_put(&wdata2->refcount, cifs_writedata_release);
 			if (is_retryable_error(rc))
 				continue;
 			i += nr_pages;
-- 
2.25.1

