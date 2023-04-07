Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 121E2C6FD1D
	for <linux-cifs@archiver.kernel.org>; Fri,  7 Apr 2023 05:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjDGFDW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 7 Apr 2023 01:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjDGFDW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 7 Apr 2023 01:03:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666669764
        for <linux-cifs@vger.kernel.org>; Thu,  6 Apr 2023 22:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680843754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=j74kAjbPlr0rqIPcWIV2rwREeg9ibA6qAlYA9oCBCbg=;
        b=drZhSbdZUqekeX0IUPGY6COPAnxcOYu5j20VJY3ytmY8sPGpWtg62tkW2QiMt5p/o0Q06j
        NiKWuTQZSWFadqt9sxhI6Wq3be8P6FHkHz54cSOj+GMGdlvwYBFV1tTpPeCgUKzT/sBRZy
        NqT9+9oeK2op4CfSkqXFKp2v8Ktvf8s=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-260-cSzn_oNPPgSjBkfnR5o2vQ-1; Fri, 07 Apr 2023 01:02:33 -0400
X-MC-Unique: cSzn_oNPPgSjBkfnR5o2vQ-1
Received: by mail-pj1-f72.google.com with SMTP id h1-20020a17090adb8100b002465a912f50so56478pjv.1
        for <linux-cifs@vger.kernel.org>; Thu, 06 Apr 2023 22:02:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680843752;
        h=content-transfer-encoding:cc:to:content-language:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=j74kAjbPlr0rqIPcWIV2rwREeg9ibA6qAlYA9oCBCbg=;
        b=Uo6doo2ZHMWfCsp1LY+PdYlPleIDnRXjdstz61G+mlkqffQLQbKplEB3u0wAMa6cru
         e4p31hv9ALdKXHvbjU2Ta2xkfni2jpSf4j6p0uu2w96XynKWWAO++7sWjfHfocYHOZId
         VfD/irqFlCzjR27CQ7+i/xbMqzzEsQOPrfKtbIDvqtStLa0bVNS7l5khPnzswiyazXC+
         HUenlT5CUhA37rC/DABW9CIPRcJ4x9e6ZxD/JGkqWlFrxiCYFvBZDwPNV3qBHdygbHFi
         xUvTFUYUapC7ZcO6o/A8Cxl/sBVo7opzo/SNEibfRGiGN4Eih8v52VKGk6UYK9lK+y4Z
         DKSQ==
X-Gm-Message-State: AAQBX9cy9Y5SCTG4Nh4Vn+u45STthlm7MPAq89QYo7gSPcO4Tj8xqGQ7
        pmBR5/RdDXhxRQpANXwgqNff2FiajxfxavNOBzshQxkZtJ94NG9G4+tEASU2gLIwr0RmypV86Gg
        UttqxK7JwIutlWELH4dtH3w==
X-Received: by 2002:a17:902:f9c4:b0:1a0:5bb1:3f0b with SMTP id kz4-20020a170902f9c400b001a05bb13f0bmr1292280plb.40.1680843752195;
        Thu, 06 Apr 2023 22:02:32 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZAWRrB8CUlOk9+whX+6XP2Ofa+7G0Vci0hWp/zbv1Xg5A0r5J7QQTYTZpAtzfMNl3yFdMwRw==
X-Received: by 2002:a17:902:f9c4:b0:1a0:5bb1:3f0b with SMTP id kz4-20020a170902f9c400b001a05bb13f0bmr1292262plb.40.1680843751782;
        Thu, 06 Apr 2023 22:02:31 -0700 (PDT)
Received: from [192.168.100.225] (221x248x148x155.ap221.ftth.ucom.ne.jp. [221.248.148.155])
        by smtp.gmail.com with ESMTPSA id j20-20020a170902759400b0019309be03e7sm2166113pll.66.2023.04.06.22.02.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 22:02:31 -0700 (PDT)
Message-ID: <1efcd842-b6a3-353a-0bf9-3ebf890eb712@redhat.com>
Date:   Fri, 7 Apr 2023 14:02:25 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
From:   Takayuki Nagata <tnagata@redhat.com>
Subject: [PATCH v2] cifs: reinstate original behavior again for
 forceuid/forcegid
Content-Language: en-US
To:     sfrench@samba.org
Cc:     pc@cjr.nz, lsahlber@redhat.com, sprasad@microsoft.com,
        tom@talpey.com, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, tnagata@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

forceuid/forcegid should be enabled by default when uid=/gid= options are
specified, but commit 24e0a1eff9e2 ("cifs: switch to new mount api")
changed the behavior. Due to the change, a mounted share does not show
intentional uid/gid for files and directories even though uid=/gid=
options are specified since forceuid/forcegid are not enabled.

This patch reinstates original behavior that overrides uid/gid with
specified uid/gid by the options.

Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
Signed-off-by: Takayuki Nagata <tnagata@redhat.com>
Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
Acked-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
V1 -> V2: Revised commit message to clarify "what breaks".

 fs/cifs/fs_context.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index ace11a1a7c8a..6f7c5ca3764f 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -972,6 +972,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 			goto cifs_parse_mount_err;
 		ctx->linux_uid = uid;
 		ctx->uid_specified = true;
+		ctx->override_uid = 1;
 		break;
 	case Opt_cruid:
 		uid = make_kuid(current_user_ns(), result.uint_32);
@@ -1000,6 +1001,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 			goto cifs_parse_mount_err;
 		ctx->linux_gid = gid;
 		ctx->gid_specified = true;
+		ctx->override_gid = 1;
 		break;
 	case Opt_port:
 		ctx->port = result.uint_32;
-- 
2.40.0

