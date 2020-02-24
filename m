Return-Path: <SRS0=Mxq5=4M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D4EBC35671
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:22:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1918B2080D
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 13:22:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ISogp1Lr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgBXNW6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Feb 2020 08:22:58 -0500
Received: from hr2.samba.org ([144.76.82.148]:44860 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgBXNW6 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 24 Feb 2020 08:22:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-Id:Date:Cc:To:From;
        bh=8xyxTXnB4JLroBAHsig7KjFotgKHhCnpIuL4l7TMiIA=; b=ISogp1Lrbke9utVdFcRc3tisFi
        zSSoRQCJstpuNrSUrI9smwmvgjjxw2dk93+NskjAiEtpEam9BjjRECi5LPLrFM8CL3T1CUnedLajv
        xD0louY/LjWO7msflA54huTQql5Roua/apYY/yC9T0UFCps9md7Rn2v1j1PsAtAMlUUx0sh69Gs57
        6txGI+IjMOCOG0WmsZtbDR+70ljPUiaTqEBp6MzwoLehORp1kz4bWeOcz4KoxnyMCrr6cw6hYZrpH
        isC94EZaxp0j2Y3E6DvwU5faxaEi0o+SylU6qoYVp2laWsNXQpwesXOE7Rv619wFvG2fOeGqHuSQ1
        MaZCJoNDXg1cTjQz+6wAZ3pqCukYvwO3FtkXIWEFU9iANQCVXBAyMw90oteqZQ0oCWwCREIPlCPUl
        zdr0HbDzXYiyBfVGy4n/oT+7VNZxn4W0xIAVa5cxIWFiBDlSbY0CHH35gBnnv4EDrXF5ErNmrfPOA
        EztcfSrqyBXKVJTpdlJxu/1X;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1j6DaT-00061e-0O; Mon, 24 Feb 2020 13:15:53 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH v1 12/13] cifs: map STATUS_ACCOUNT_LOCKED_OUT to -EACCES
Date:   Mon, 24 Feb 2020 14:15:09 +0100
Message-Id: <20200224131510.20608-13-metze@samba.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200224131510.20608-1-metze@samba.org>
References: <20200224131510.20608-1-metze@samba.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is basically the same as STATUS_LOGON_FAILURE,
but after the account is locked out.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/cifs/smb2maperror.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index 7fde3775cb57..91af7baed051 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -814,7 +814,7 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 	{STATUS_INVALID_VARIANT, -EIO, "STATUS_INVALID_VARIANT"},
 	{STATUS_DOMAIN_CONTROLLER_NOT_FOUND, -EIO,
 	"STATUS_DOMAIN_CONTROLLER_NOT_FOUND"},
-	{STATUS_ACCOUNT_LOCKED_OUT, -EIO, "STATUS_ACCOUNT_LOCKED_OUT"},
+	{STATUS_ACCOUNT_LOCKED_OUT, -EACCES, "STATUS_ACCOUNT_LOCKED_OUT"},
 	{STATUS_HANDLE_NOT_CLOSABLE, -EIO, "STATUS_HANDLE_NOT_CLOSABLE"},
 	{STATUS_CONNECTION_REFUSED, -EIO, "STATUS_CONNECTION_REFUSED"},
 	{STATUS_GRACEFUL_DISCONNECT, -EIO, "STATUS_GRACEFUL_DISCONNECT"},
-- 
2.17.1

