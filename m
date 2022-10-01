Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC8B3C433F5
	for <linux-cifs@archiver.kernel.org>; Sat,  1 Oct 2022 23:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiJAXvH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 1 Oct 2022 19:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiJAXvH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 1 Oct 2022 19:51:07 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5C137199
        for <linux-cifs@vger.kernel.org>; Sat,  1 Oct 2022 16:51:06 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id n186so2406734vsc.9
        for <linux-cifs@vger.kernel.org>; Sat, 01 Oct 2022 16:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=mNlj1ar7MjAtt10PpJ5/PhVXSQp48TQeJStKYXUqZqM=;
        b=YRxnBcYn8lsbD640gx99JQcxyJ713Nt1LQbipREAPqcji3dRxHRvGSeIkckqbAuooN
         ihCxLgE7rsdTtBqZf3KBfy2nPgUJ3vkmfCNSjQ/caoav0gT95pPPmu3jjApcpJgqspCe
         tyPrMY2zC1RFv3XtfiybVkvP97tgBqKDJrB6VMEDOLL4LwL/gB1IH6J2Daoe/94msJo8
         XyD2IQE8idIa4egqh6TwrVTvMJEoFlCAppf6nvYdIUQezlgYZGYid8oSykiUC9XBMLzP
         stEXvc1JZ3CpKuj2dnkt+r3C6HrDdzlDK5xF0ZnVwWJ8qsK/uSKjYWbkQNOiZ7p6UDdo
         LkMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=mNlj1ar7MjAtt10PpJ5/PhVXSQp48TQeJStKYXUqZqM=;
        b=ZzZh1INf6FLgoOfdiToXHYeLkAXVn0LGsehWr9y2FqraeiubauuAw9mr7iYX2ENb2m
         9h+7WXOoZFD+RmNBOt11NLaFOMC16BhqHVnZZQqfFmh/wBWHeLOS2M5RmGR1MklIkkJ/
         OU1fPndXcEIlp0Sz/aZ/8wXtM2N3sH++AAwum4ElaZZEvCyfqdrM7K8REVYUWICvH4J7
         zFkDWYnTPJeqJL2A12dOaiyXyPlQ4S5Kiixh10zxJxr1SMDeJlu7GmGZEeIsTkCzpOkW
         F+qL38N/W36dm5+Q76ZWV2hHT86W6QDUVpWhlFE/ZvwE6oYWCXoI589UBqDCePE2iQ8b
         SyqQ==
X-Gm-Message-State: ACrzQf0+XZjJT2foVFGqadiQiEZiB/ydz3QpG4RUwfCn2OgxtzOSkDSg
        FpPJYJtPlzZNhv4bYcLvTqh/6JMyfLMucC+EoIeE19xgudY=
X-Google-Smtp-Source: AMsMyM5QU9kVSrhZ0eQqhgJS2wntE8tOsajoWmiTYQ9Nk8QiHLEfZsUSKeAnxFGg1jtFf1JrOFqEd9a8+6JuChFJn1Y=
X-Received: by 2002:a05:6102:3118:b0:3a6:5332:25c0 with SMTP id
 e24-20020a056102311800b003a6533225c0mr859459vsh.60.1664668265021; Sat, 01 Oct
 2022 16:51:05 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 1 Oct 2022 18:50:54 -0500
Message-ID: <CAH2r5mvM6a4dU3d7Mxer9jWP0xkA2hyF9PrkwreES5T11W9O9w@mail.gmail.com>
Subject: new SMB3.1.1 create contexts
To:     samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Noticed a few SMB3.1.1 create contexts missing from the Linux kernel
code.  Any more beyond these four that are still missing?

diff --git a/fs/smbfs_common/smb2pdu.h b/fs/smbfs_common/smb2pdu.h
index 2cab413fffee..7d605db3bb3b 100644
--- a/fs/smbfs_common/smb2pdu.h
+++ b/fs/smbfs_common/smb2pdu.h
@@ -1101,7 +1101,11 @@ struct smb2_change_notify_rsp {
 #define SMB2_CREATE_REQUEST_LEASE              "RqLs"
 #define SMB2_CREATE_DURABLE_HANDLE_REQUEST_V2  "DH2Q"
 #define SMB2_CREATE_DURABLE_HANDLE_RECONNECT_V2        "DH2C"
-#define SMB2_CREATE_TAG_POSIX
"\x93\xAD\x25\x50\x9C\xB4\x11\xE7\xB4\x23\x83\xDE\x96\x8B\xCD\x7C"
+#define SMB2_CREATE_TAG_POSIX
"\x93\xAD\x25\x50\x9C\xB4\x11\xE7\xB4\x23\x83\xDE\x96\x8B\xCD\x7C"
+#define SMB2_CREATE_APP_INSTANCE_ID
"\x45\xBC\xA6\x6A\xEF\xA7\xF7\x4A\x90\x08\xFA\x46\x2E\x14\x4D\x74"
+#define SMB2_CREATE_APP_INSTANCE_VERSION
"\xB9\x82\xD0\xB7\x3B\x56\x07\x4F\xA0\x7B\x52\x4A\x81\x16\xA0\x10"
+#define SVHDX_OPEN_DEVICE_CONTEXT
"\x9C\xCB\xCF\x9E\x04\xC1\xE6\x43\x98\x0E\x15\x8D\xA1\xF6\xEC\x83"
+#define SMB2_CREATE_TAG_AAPL                   "AAPL"


-- 
Thanks,

Steve
