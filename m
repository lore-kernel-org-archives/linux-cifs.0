Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B28C7EE37
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Jun 2023 17:47:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbjFIRr5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Jun 2023 13:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbjFIRr4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Jun 2023 13:47:56 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299AD2D44
        for <linux-cifs@vger.kernel.org>; Fri,  9 Jun 2023 10:47:55 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 98e67ed59e1d1-2566e60cc5aso895567a91.3
        for <linux-cifs@vger.kernel.org>; Fri, 09 Jun 2023 10:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686332874; x=1688924874;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sQV9Mb9/pjPesEsESX+LtfOPLaBFiXKP4bha95yYAvk=;
        b=JnTSU+hzLOxaX/1Vu7x5bYR8/sGgCKI0LpsEWMScDQYE1xg5wN2RS/lnvF5bJJy0MN
         xm0gM2kq8KN4Kg0+sfbHKUQ2wcF9YoUVNFn4SUamJIkd4FnoRTNus+3FJQTrx7KlWwzc
         C69vx1WEF2VIgAy/16u63rI87d4vNzLCubHF0GbmhT+xU1khmn2z9fQ3Iq9RDKNodqar
         fpwVD+KGTWpqA56/LGCRqtKs4UF6pUc7RHVPve5O3yUE8nmTX5jdeTWswKsqkOo6tq6n
         65SBPR1N4/Cm/nIWJg0K2/FKqm3tkJV+BtxqUkPP6A81wDQk8VX4gdqT7Xwc8zHEEqEv
         XcyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686332874; x=1688924874;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sQV9Mb9/pjPesEsESX+LtfOPLaBFiXKP4bha95yYAvk=;
        b=c4J5k0/hbSzdIbUJVHQhWECrcXClFvOuyJ6ZWNL2azEjHi6FhW7uVxRsuw9UuctlSZ
         tmjukG7fYu9k0bldjSLLllC1WwsX0k6Io66riySDs/PvagNfp2WRDNJ7BPWdvBAxs7rx
         ReVQqTt3INgOln06Sv26OLC1KUxUs2hB0EaIW10RHiZHvlnFFuxmCJsJ+2gPt/H4/kVn
         jOGQv1yJZcVB4CpI4lXa2VIcnfKArFqeYvhsX6aBZfYt/SvfJ9dGeB/q4kNg6N3ntcrb
         msoQlfUWK68ci8AddEWE5SNcvZlU8Ppw0urWFZxZRpvtLSToZfq+bZOwVz/ssWAnyL4Y
         u1hQ==
X-Gm-Message-State: AC+VfDwkjuxYlgULdXm1v90BnCBmGQxQ2SNY0dXpslBU2ysuKraTzOy2
        UqRUXt2efYiNHaDhQTmXitgy008/avdjsDWZ
X-Google-Smtp-Source: ACHHUZ7o7phj5t8XMNDlhFL+9CjU6ejfqLaXrYVu6Fopfw1a4DTfYcZWb8yu54UY33LZdmN10Xl6HA==
X-Received: by 2002:a17:90a:6f46:b0:255:c061:9e5b with SMTP id d64-20020a17090a6f4600b00255c0619e5bmr2035740pjk.37.1686332874144;
        Fri, 09 Jun 2023 10:47:54 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id m4-20020a17090a71c400b0025671de4606sm5003064pjs.4.2023.06.09.10.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 10:47:53 -0700 (PDT)
From:   Shyam Prasad N <nspmangalore@gmail.com>
X-Google-Original-From: Shyam Prasad N <sprasad@microsoft.com>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        bharathsm.hsk@gmail.com, tom@talpey.com
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 5/6] cifs: fix max_credits implementation
Date:   Fri,  9 Jun 2023 17:46:58 +0000
Message-Id: <20230609174659.60327-5-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230609174659.60327-1-sprasad@microsoft.com>
References: <20230609174659.60327-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The current implementation of max_credits on the client does
not work because the CreditRequest logic for several commands
does not take max_credits into account.

Still, we can end up asking the server for more credits, depending
on the number of credits in flight. For this, we need to
limit the credits while parsing the responses too.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/smb2ops.c |  2 ++
 fs/smb/client/smb2pdu.c | 32 ++++++++++++++++++++++++++++----
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 43162915e03c..18faf267c54d 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -34,6 +34,8 @@ static int
 change_conf(struct TCP_Server_Info *server)
 {
 	server->credits += server->echo_credits + server->oplock_credits;
+	if (server->credits > server->max_credits)
+		server->credits = server->max_credits;
 	server->oplock_credits = server->echo_credits = 0;
 	switch (server->credits) {
 	case 0:
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 7063b395d22f..17fe212ab895 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1305,7 +1305,12 @@ SMB2_sess_alloc_buffer(struct SMB2_sess_data *sess_data)
 	}
 
 	/* enough to enable echos and oplocks and one max size write */
-	req->hdr.CreditRequest = cpu_to_le16(130);
+	if (server->credits >= server->max_credits)
+		req->hdr.CreditRequest = cpu_to_le16(0);
+	else
+		req->hdr.CreditRequest = cpu_to_le16(
+			min_t(int, server->max_credits -
+			      server->credits, 130));
 
 	/* only one of SMB2 signing flags may be set in SMB2 request */
 	if (server->sign)
@@ -1899,7 +1904,12 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	rqst.rq_nvec = 2;
 
 	/* Need 64 for max size write so ask for more in case not there yet */
-	req->hdr.CreditRequest = cpu_to_le16(64);
+	if (server->credits >= server->max_credits)
+		req->hdr.CreditRequest = cpu_to_le16(0);
+	else
+		req->hdr.CreditRequest = cpu_to_le16(
+			min_t(int, server->max_credits -
+			      server->credits, 64));
 
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
@@ -4227,6 +4237,7 @@ smb2_async_readv(struct cifs_readdata *rdata)
 	struct TCP_Server_Info *server;
 	struct cifs_tcon *tcon = tlink_tcon(rdata->cfile->tlink);
 	unsigned int total_len;
+	int credit_request;
 
 	cifs_dbg(FYI, "%s: offset=%llu bytes=%u\n",
 		 __func__, rdata->offset, rdata->bytes);
@@ -4258,7 +4269,13 @@ smb2_async_readv(struct cifs_readdata *rdata)
 	if (rdata->credits.value > 0) {
 		shdr->CreditCharge = cpu_to_le16(DIV_ROUND_UP(rdata->bytes,
 						SMB2_MAX_BUFFER_SIZE));
-		shdr->CreditRequest = cpu_to_le16(le16_to_cpu(shdr->CreditCharge) + 8);
+		credit_request = le16_to_cpu(shdr->CreditCharge) + 8;
+		if (server->credits >= server->max_credits)
+			shdr->CreditRequest = cpu_to_le16(0);
+		else
+			shdr->CreditRequest = cpu_to_le16(
+				min_t(int, server->max_credits -
+						server->credits, credit_request));
 
 		rc = adjust_credits(server, &rdata->credits, rdata->bytes);
 		if (rc)
@@ -4468,6 +4485,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	unsigned int total_len;
 	struct cifs_io_parms _io_parms;
 	struct cifs_io_parms *io_parms = NULL;
+	int credit_request;
 
 	if (!wdata->server)
 		server = wdata->server = cifs_pick_channel(tcon->ses);
@@ -4572,7 +4590,13 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	if (wdata->credits.value > 0) {
 		shdr->CreditCharge = cpu_to_le16(DIV_ROUND_UP(wdata->bytes,
 						    SMB2_MAX_BUFFER_SIZE));
-		shdr->CreditRequest = cpu_to_le16(le16_to_cpu(shdr->CreditCharge) + 8);
+		credit_request = le16_to_cpu(shdr->CreditCharge) + 8;
+		if (server->credits >= server->max_credits)
+			shdr->CreditRequest = cpu_to_le16(0);
+		else
+			shdr->CreditRequest = cpu_to_le16(
+				min_t(int, server->max_credits -
+						server->credits, credit_request));
 
 		rc = adjust_credits(server, &wdata->credits, io_parms->length);
 		if (rc)
-- 
2.34.1

