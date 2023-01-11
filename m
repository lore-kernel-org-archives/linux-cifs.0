Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77413C46467
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Jan 2023 16:42:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238322AbjAKQmt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 Jan 2023 11:42:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbjAKQmW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 11 Jan 2023 11:42:22 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1905610059
        for <linux-cifs@vger.kernel.org>; Wed, 11 Jan 2023 08:41:15 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id p1-20020a05600c1d8100b003d8c9b191e0so13144786wms.4
        for <linux-cifs@vger.kernel.org>; Wed, 11 Jan 2023 08:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=d886Ubdy56v2P0dcusuTnnRxvc3Sovqp1uLtOKS3nOQ=;
        b=jhYwU/Vzk56rLzwGXo4Tq0mID0cymkBRoPUccHF1ibeltkjYPZaHSQyr+ZKqZtTXgg
         QnIU4BwWU6FLG+lTJjdCXj9iP7Rin+LXA0Oi1+18exa98ssU6AR6+zo+Hc4Sv6IR4bLQ
         BbbDKUKj+eEI/tA39lrrK9TPfQ28t9W2BbhFGupnasppTr8NCY85Fdp0RCqPBRd/B6z6
         EgKDh1PKc1mkAUKp5vM5irNnzunig4rB9oGHIELxs9ZtUO8DGjBGB1n8DiV8sFWsSkpt
         k918gj7cwn5aJRg9qJPUzzCEe+zvhF8TMXtxMQIlFv+98X3Zd0dFfDbQEyBhWJGp49rj
         Rbeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d886Ubdy56v2P0dcusuTnnRxvc3Sovqp1uLtOKS3nOQ=;
        b=jlEcNvfqrtYhfDPTDdPrubJAiQuQ10Qsg1vviA6IybmXBrAdu1FGrDd7P1XG4erv/9
         ootTXIthSsIkI0Yfb0cEf/vZeo98C9bwD6MMWabAnw4nnwj0OeT0Gwab1G1JjWxCR3u+
         yDW7zkHsPfq1DYXkb2C7/GUbdMBfEFBiYr8iG6E8AAhPp/fnpibFimQwcBvirmnm+slf
         2///HNkUdGwRg54jzX9kJLoojEiWJW2XArt8X4vwaDgRuHtwQRg1Z4Cx/XU3ELvLn7LZ
         u8XA6WJN8mQQ0yEhcF9LMvlSAMMWRhKeOJ9OXnK4pS+40dk43TH3Yp/wFXRVHthg1H9F
         16sg==
X-Gm-Message-State: AFqh2krQPRLCVzvILM1JUwDXiSf933ufMUyRhB8KSVg5ckfiIaOrPNf1
        hfKxG6bJ9Gr5NpoK+TJB4jR8wejyzBbaf+m0
X-Google-Smtp-Source: AMrXdXvTxd4Li0zcG9Y+FTzo4b9/pblSqIlWpkiRyX8p3Ocx+fK+OoVVXivAnN98t7hYzTweScPZ/Q==
X-Received: by 2002:a05:600c:1e8c:b0:3d6:2952:679b with SMTP id be12-20020a05600c1e8c00b003d62952679bmr52534544wmb.34.1673455273366;
        Wed, 11 Jan 2023 08:41:13 -0800 (PST)
Received: from marios-t5500.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id v10-20020a05600c444a00b003d998412db6sm25315727wmn.28.2023.01.11.08.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 08:41:12 -0800 (PST)
From:   Marios Makassikis <mmakassikis@freebox.fr>
To:     linux-cifs@vger.kernel.org
Cc:     Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH] ksmbd: do not sign response to session request for guest login
Date:   Wed, 11 Jan 2023 17:39:02 +0100
Message-Id: <20230111163901.2030281-1-mmakassikis@freebox.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If ksmbd.mountd is configured to assign unknown users to the guest account
("map to guest = bad user" in the config), ksmbd signs the response.

This is wrong according to MS-SMB2 3.3.5.5.3:
   12. If the SMB2_SESSION_FLAG_IS_GUEST bit is not set in the SessionFlags
   field, and Session.IsAnonymous is FALSE, the server MUST sign the
   final session setup response before sending it to the client, as
   follows:
    [...]

This fixes libsmb2 based applications failing to establish a session
("Wrong signature in received").

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
---
 fs/ksmbd/smb2pdu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 38fbda52e06f..d681f91947d9 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -8663,6 +8663,7 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 bool smb3_11_final_sess_setup_resp(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
+	struct ksmbd_session *sess = work->sess;
 	struct smb2_hdr *rsp = smb2_get_msg(work->response_buf);
 
 	if (conn->dialect < SMB30_PROT_ID)
@@ -8672,6 +8673,7 @@ bool smb3_11_final_sess_setup_resp(struct ksmbd_work *work)
 		rsp = ksmbd_resp_buf_next(work);
 
 	if (le16_to_cpu(rsp->Command) == SMB2_SESSION_SETUP_HE &&
+	    sess->user && !user_guest(sess->user) &&
 	    rsp->Status == STATUS_SUCCESS)
 		return true;
 	return false;
-- 
2.25.1

