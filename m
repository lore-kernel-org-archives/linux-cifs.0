Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F6FC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Oct 2021 19:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DDC260524
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Oct 2021 19:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhJ1TEL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Oct 2021 15:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhJ1TEL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Oct 2021 15:04:11 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CE6C061570
        for <linux-cifs@vger.kernel.org>; Thu, 28 Oct 2021 12:01:43 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id p14so11872582wrd.10
        for <linux-cifs@vger.kernel.org>; Thu, 28 Oct 2021 12:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G7jTJSPqK7GcsLP1mWujIY+vR8W5851kmvgTfQoUVSI=;
        b=8PD2PaeOv70+0vnITFslX0F4o/DeUpkZPAoM8c5ybGptN9Y+jjwaAw3ph1dLFVXyG1
         1WEVrl0Y+hzU5Qj2f5XjZML9njoogO2OQou1HTHV/+Q8TdSdPaFM6lTvjja6D7VeV50A
         Y83GYuNdQzo2r66mk4na17ZZu7ji/dKQ88P84OmxEGN7K0d8v2Fn8PFvdWnpVZhKZLU8
         C5a2O0mo3WRKikjjLsKjrNaKnW7DpLspD02PcVEm5FurNE43Y0MgjVpTpnDFnWNaCMDN
         3EDe83Nuo+FYiCsY31viCt4CObTelrKomcxVxdMibXDYT1Vn7U+09QN/r/NE20kp6sFm
         tuhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G7jTJSPqK7GcsLP1mWujIY+vR8W5851kmvgTfQoUVSI=;
        b=wT50B33O2oOD/iitA6/CBHscFN8qeu3URil6Nf7bnRXfLPr91BknkaGiQA02uV0w9v
         SzlMy6MA0tCTwpiUFXcJkycMMKKhTFULFhLvYiayhnN7VDhAP7wGW4aPmUhe7zbbGQgn
         NQAl7hSNsbJJOrehB1lwyMElYycsbp0kejva1BeuhTOeEbFs6dnryOtU6jYq1cS8Tlag
         k67oR1y2qSu7+1myMVjxnwDkopXaKKlvpn6t1cuc7BaW7F200y2u2HTyS1viqQtgOtph
         3P+GGDgjqDtMJukrIChU2yC/l+aXZjzrgelz/ivkSrR0ndRK5n2mkY5/zencxtwVkZWJ
         Uz8w==
X-Gm-Message-State: AOAM5323cW66Z/Mk+zEvlE51dy4tT6B1UK30z6Wcz6vSp9i4+35WsOhc
        WtM9DxRVJZPPbd3f1HaneleBQcIu4e8Cig==
X-Google-Smtp-Source: ABdhPJzJZk4j2SEYmgCUMOJ90cJ5u7BN8OXPQzeEVTyjuhUNwjtJlGIsDNlI9rbA2TWb10DDh/l0aw==
X-Received: by 2002:adf:ee0c:: with SMTP id y12mr5340082wrn.82.1635447701896;
        Thu, 28 Oct 2021 12:01:41 -0700 (PDT)
Received: from localhost.localdomain (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id j20sm3017511wmp.27.2021.10.28.12.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 12:01:41 -0700 (PDT)
From:   Marios Makassikis <mmakassikis@freebox.fr>
To:     linux-cifs@vger.kernel.org
Cc:     Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH] ksmbd: Fix buffer length check in fsctl_validate_negotiate_info()
Date:   Thu, 28 Oct 2021 21:01:27 +0200
Message-Id: <20211028190125.391374-1-mmakassikis@freebox.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The validate_negotiate_info_req struct definition includes an extra
field to access the data coming after the header. This causes the check
in fsctl_validate_negotiate_info() to count the first element of the
array twice. This in turn makes some valid requests fail, depending on
whether they include padding or not.

Fixes: f7db8fd03a4b ("ksmbd: add validation in smb2_ioctl")
Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
---
This causes mounts to fail on older kernels (v4.19 on debian10) when
specifying vers=3.0.

 fs/ksmbd/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 7e448df3f847..a03b53df3f04 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7312,7 +7312,7 @@ static int fsctl_validate_negotiate_info(struct ksmbd_conn *conn,
 	int ret = 0;
 	int dialect;
 
-	if (in_buf_len < sizeof(struct validate_negotiate_info_req) +
+	if (in_buf_len < offsetof(struct validate_negotiate_info_req, Dialects) +
 			le16_to_cpu(neg_req->DialectCount) * sizeof(__le16))
 		return -EINVAL;
 
-- 
2.25.1

