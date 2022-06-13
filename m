Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB7E2C43334
	for <linux-cifs@archiver.kernel.org>; Mon, 13 Jun 2022 23:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbiFMXCL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 13 Jun 2022 19:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237654AbiFMXCG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 13 Jun 2022 19:02:06 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88F431DEF
        for <linux-cifs@vger.kernel.org>; Mon, 13 Jun 2022 16:02:04 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 3-20020a17090a174300b001e426a02ac5so10204211pjm.2
        for <linux-cifs@vger.kernel.org>; Mon, 13 Jun 2022 16:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pCL45IsiDyG8q1U2/B6kZtt/jXl5mrIpX69+TYhxyEM=;
        b=hYBy50wsPn5+3V+Mb8XOVXURtjfvu7Ald5Cwg4G3SQ8BkpxxoumTTgMa4vQNNEvEhg
         PMOKJt/vjqpBt7/Js/U24sYUtH0tawQFdirbodRYIwGi1IvAysGn7w8zaffCze4QQDDb
         DBreBX2C487oGIzI3DEEJBXMTjqBfXDU0WXE5z0nkg8zWiq30DiBXcYyZ3Sg2H3AgrmE
         LQ38QRMuqApsbV55la4jyEMAV9LPtbN8tYMqDeiTAlauWbgeF2cotKqeMreW3nBPQQ2i
         Og0iiCPwqHIRRpaldbmMdStfBukGOAodu1bCNLGzClrAkQXP3PqQLtE/NuIIHDAifLse
         T0Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pCL45IsiDyG8q1U2/B6kZtt/jXl5mrIpX69+TYhxyEM=;
        b=Jgz9ynDseNgHLN837BzdC7/2DXX3ANJD8wOoP0RnM+QEskBeeux2kr0LsO4sBj5L3g
         hkCwNk/ZtdkTpV5/GHy6kfqMWwRV+P4j02+b22mywzT1mqmLyAauxOb1jtUqO6n1hZm7
         K4CnmYGNq/3wY6bn+HK5rbVLnn0TqVER14xPzxrSSVC9QQurffQN4+P8Fp5ffpCAArXH
         Biw+SOopbODiFepVSt6CEEruZrSE1Txz/tIyM2bOzguM3Fpec2PSRbk1rskuRToM8Gzd
         x0Sp8jy6mAzfJ8BC7KHy5ZG1e9d6S+cMOI8a0ZGdaeOBVpjNJOaA9UBQk9ngGKkI7T3x
         c+5w==
X-Gm-Message-State: AJIora9DxCHlfH31Bb4fJvnI5IXjtImqSvMlc1Qd6kVog1R3zVG4ZFd/
        0kF3oEED7kO09Ms7nLPFo0IQtxTxU1w=
X-Google-Smtp-Source: AGRyM1s33bq11hLiar7k4LdS+qJqjdDKJ2oehlH0mrh7QdtVS0HlcFwETWOz52V+dDjCufuCFETXSQ==
X-Received: by 2002:a17:902:d509:b0:167:6ed8:afb5 with SMTP id b9-20020a170902d50900b001676ed8afb5mr1560624plg.137.1655161323620;
        Mon, 13 Jun 2022 16:02:03 -0700 (PDT)
Received: from localhost.localdomain ([210.217.8.148])
        by smtp.googlemail.com with ESMTPSA id o186-20020a62cdc3000000b0051c78a77702sm6097603pfg.176.2022.06.13.16.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 16:02:03 -0700 (PDT)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH 2/2] ksmbd: smbd: handle RDMA CM time wait event
Date:   Tue, 14 Jun 2022 08:01:19 +0900
Message-Id: <20220613230119.73475-2-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220613230119.73475-1-hyc.lee@gmail.com>
References: <20220613230119.73475-1-hyc.lee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

After a QP has been disconnected, it stays
in a timewait state for in flight packets.
After the state has completed,
RDMA_CM_EVENT_TIMEWAIT_EXIT is reported.
Disconnect on RDMA_CM_EVENT_TIMEWAIT_EXIT
so that ksmbd can restart.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
---
 fs/ksmbd/transport_rdma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index d035e060c2f0..4b1a471afcd0 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -1535,6 +1535,7 @@ static int smb_direct_cm_handler(struct rdma_cm_id *cm_id,
 		wake_up_interruptible(&t->wait_status);
 		break;
 	}
+	case RDMA_CM_EVENT_TIMEWAIT_EXIT:
 	case RDMA_CM_EVENT_DEVICE_REMOVAL:
 	case RDMA_CM_EVENT_DISCONNECTED: {
 		t->status = SMB_DIRECT_CS_DISCONNECTED;
-- 
2.25.1

