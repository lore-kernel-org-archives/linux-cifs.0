Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ACA5C4167D
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Oct 2023 11:00:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbjJ3LAm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Oct 2023 07:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbjJ3LAl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Oct 2023 07:00:41 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4EAB3
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 04:00:39 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-6b3c2607d9bso3661466b3a.1
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 04:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698663639; x=1699268439; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N4I3xxzZQ/86tSmbPo/sbLx+lHeB8MIVUaivcbdB4X4=;
        b=BpX2YiHveN0dJnbo2nmp3e4jQ22Dz0uDCr7ZYAXFDkSNf9ofZPGbn+g0mmCCqEy13q
         wRqyJdRNG+ZcvMi/jAbXLZTOMJehbHsf1qy2oasaBlZXIo2cy9C6em1i7VMMmHOiiomZ
         lxWEjVl1EfLjFEIyPt6okVCX91a+NGiCjbRPNDCPpJ/96FrIk166hc/avNRHZgmMVtIf
         lWeD8mnpigd/Vur8MNnrddi+IYnjH04X7prnAnWSYd+jF9cCKyKgPS7HmHX2+rlaAnPO
         17eFs41jfSbBWiOr+ECf1jjc3s+eFo1cLBUDXD7FGFMA739xiF0MbqCErD3o/w3dOAKk
         cg8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698663639; x=1699268439;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N4I3xxzZQ/86tSmbPo/sbLx+lHeB8MIVUaivcbdB4X4=;
        b=QcQ+YdcFIyre0lGcwKQRSjGFOoyf+DDhIZNeGRAeIPAZwxOT6yWSTuAyYASFJNF84L
         qe6zShfIOU8Up152GBgycdO3mq8nGfjLlmZpLbs892pM4oAHF7W2XXm/Apqy9yae7yYn
         VC+Iz6idTMgMeCi4xOngFYPu7dmTWuBwfceApjOD3GsngkN6ZUGtWrCfvfpiXGNlisbd
         p3XeM7a2DC4U9jEZsCMpwUfN1zhHY7h33ymG6DUsennUwZUumJOdLdjrPBJscoke/Tcm
         AmYUH/7ZVQio2jSnttyhe1MFyl387mmMe6ildZAKmGXQ1XPDzpPUcWHB8bUkTzK/LSBW
         SNhw==
X-Gm-Message-State: AOJu0YwLiLm6p787SotAZVNdzzlU2m3ahYHh3eK+zjtICMTI8T47FVbD
        5DY0+U2HsqsvhhOnkj4Je+k=
X-Google-Smtp-Source: AGHT+IHtEct68+3DqrXwE1m0OWNEl4jXUfXhab//GkY5AIyZ5ojK0yh/Rprmx02R/U/snKxH8uQW0Q==
X-Received: by 2002:a05:6a20:8f03:b0:13d:5b8e:db83 with SMTP id b3-20020a056a208f0300b0013d5b8edb83mr9506948pzk.9.1698663639193;
        Mon, 30 Oct 2023 04:00:39 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id n3-20020a170902e54300b001c9cc44eb60sm6006034plf.201.2023.10.30.04.00.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 04:00:38 -0700 (PDT)
From:   nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To:     smfrench@gmail.com, pc@manguebit.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 05/14] cifs: force interface update before a fresh session setup
Date:   Mon, 30 Oct 2023 11:00:11 +0000
Message-Id: <20231030110020.45627-5-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231030110020.45627-1-sprasad@microsoft.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

During a session reconnect, it is possible that the
server moved to another physical server (happens in case
of Azure files). So at this time, force a query of server
interfaces again (in case of multichannel session), such
that the secondary channels connect to the right
IP addresses (possibly updated now).

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/connect.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index c993c7a3415a..97c9a32cff36 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3854,8 +3854,12 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	is_binding = !CIFS_ALL_CHANS_NEED_RECONNECT(ses);
 	spin_unlock(&ses->chan_lock);
 
-	if (!is_binding)
+	if (!is_binding) {
 		ses->ses_status = SES_IN_SETUP;
+
+		/* force iface_list refresh */
+		ses->iface_last_update = 0;
+	}
 	spin_unlock(&ses->ses_lock);
 
 	/* update ses ip_addr only for primary chan */
-- 
2.34.1

