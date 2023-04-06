Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7DE3C76196
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Apr 2023 12:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237606AbjDFMFp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 Apr 2023 08:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237619AbjDFMF2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 Apr 2023 08:05:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F65493C7
        for <linux-cifs@vger.kernel.org>; Thu,  6 Apr 2023 05:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680782563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=n00mKCdV4rdOBgXkXCVylGLpwrX31Gf94p4L9PL3ul0=;
        b=JCrqu5/PUY3+2c03Yfusi8hPy/azBF5AsKLJXFaXwDrX8MSEPEHHjEDc9rFRAkGg0/Ar2h
        lWrdIzwyUflr5lsYvi6FH7joZsbvwNSa+QYObvAjpg8OpyVHTyGsYx80c1n2Gcpy1riG54
        h4iXkZMQT2F1tEHQ6qi4CS3Tiwgq/6s=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-xXAAzHc1OpuODDR4y1dfXg-1; Thu, 06 Apr 2023 08:02:32 -0400
X-MC-Unique: xXAAzHc1OpuODDR4y1dfXg-1
Received: by mail-pl1-f200.google.com with SMTP id o9-20020a170902d4c900b001a2bef29d53so6988960plg.7
        for <linux-cifs@vger.kernel.org>; Thu, 06 Apr 2023 05:02:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680782551;
        h=content-transfer-encoding:cc:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=n00mKCdV4rdOBgXkXCVylGLpwrX31Gf94p4L9PL3ul0=;
        b=6HilRPLiSXWCGjtQce3tP4pAzqbzvs1FKcCLuEufeyr6NiY3co/TdhbKKI4llheThd
         z1zMVBQUXfH6DukbvJjTt/EjOzp/+je0efnpZwA+6+cgzeGEabd+KXYBWCB4BEVFvoUX
         szAjMBw2v+4MQB3xfJ08cRf/pO8zvA0ewKdQ1YvhzxPbW9JNHRKmrAiTFtFTHbceUWOZ
         7k516+hUlUOd03ev0rdiwveiiMtLYkn+mrYN/GT4UinWVJivuXY3Yu0mUAZl5MmwwBVd
         8XdtGm5WlPSzYVln51ls/mmBdPjk8Dd81h66Lq3pGYmRIVjSWmEhsQyVJbvB2259H7fS
         sIbw==
X-Gm-Message-State: AAQBX9e/VSfb+7BxUiJzyVMOz2Pcw3v0fy1xJeFMlpPudEwPqftgeO2a
        AMfwtFspaCJY+b7ALt2+MRGaYGtD9DLFi5ZO9pzw/BbDKVH75g2o91VVHHD7zUR54VV0yQ+mTDV
        GlHLf13pqxV+wtow4Fuj8cg==
X-Received: by 2002:a62:5401:0:b0:62d:b4ae:b84a with SMTP id i1-20020a625401000000b0062db4aeb84amr5491943pfb.7.1680782550874;
        Thu, 06 Apr 2023 05:02:30 -0700 (PDT)
X-Google-Smtp-Source: AKy350bmWvToWKWs8tsXjHVlfJMBGC0NFhWq4zrQUmAgKl++tvX/YVQ9pNx6sN2nDyEgIQ2Ffxu4dA==
X-Received: by 2002:a62:5401:0:b0:62d:b4ae:b84a with SMTP id i1-20020a625401000000b0062db4aeb84amr5491909pfb.7.1680782550483;
        Thu, 06 Apr 2023 05:02:30 -0700 (PDT)
Received: from [192.168.100.225] (221x248x148x155.ap221.ftth.ucom.ne.jp. [221.248.148.155])
        by smtp.gmail.com with ESMTPSA id p21-20020a62ab15000000b00625616f59a1sm1236977pff.73.2023.04.06.05.02.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 05:02:29 -0700 (PDT)
Message-ID: <6cf163fe-a974-68ab-0edc-11ebc54314ef@redhat.com>
Date:   Thu, 6 Apr 2023 21:02:25 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
From:   Takayuki Nagata <tnagata@redhat.com>
Subject: [PATCH] cifs: reinstate original behavior again for forceuid/forcegid
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
changed the behavior. This patch reinstates original behavior to overriding
uid/gid with specified uid/gid.

Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
Signed-off-by: Takayuki Nagata <tnagata@redhat.com>
---
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

