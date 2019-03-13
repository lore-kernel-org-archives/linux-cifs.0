Return-Path: <SRS0=HHpq=RQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D14C43381
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Mar 2019 22:05:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A9852087C
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Mar 2019 22:05:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="llixkYcC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfCMWFb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Mar 2019 18:05:31 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:40765 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbfCMWFb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Mar 2019 18:05:31 -0400
Received: by mail-pg1-f171.google.com with SMTP id u9so2480729pgo.7
        for <linux-cifs@vger.kernel.org>; Wed, 13 Mar 2019 15:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=6JL2GoO4TltYxFSFRXLXB8VwfyHkqkxi54ZNtS8X50k=;
        b=llixkYcCT32WQlJ5ATa9/7xl8AhoyeR9LLDmw2lOnAyQsPG7D6yYUFmWXleuRTdEU3
         uUtMo8vlb0vCmVqyNecZqRTQDMGUsGA7YeSeTTDne8BVbAdtIN33q2jExdB1G8zcV1dY
         s+dBpYg2Nd0nkbGHl+SkpGQ5wvSx/Z3z1MOtfsQAF2HAHbd8hw0xGTY2xN03NXvbMr3j
         wbwYR2N7V4oRdZFxUP4kl7ZwKfRxePOzY/ma4TStQy1RT7GfSyAZNbl6WJ1oz5uNZ+dM
         Oen0bafHpdWuS+ug9MBkwpyF6yn2n+aafDRUfZdgu+wq0t91tW7yF+BcjFt5I7CzYBYN
         L3EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=6JL2GoO4TltYxFSFRXLXB8VwfyHkqkxi54ZNtS8X50k=;
        b=FFpdJztYSnbQoOXttBC0heabUZikR9Phfu87VUuPawV61umFkZq6WfOYftZkHfB8A7
         eWMOUps1FDww5SfFtKV/m4ZJDlTiQ65vALpPs8EJRUiIgndfeAZZ7zQWafGMq+FfwP9h
         oCT2gow3f1+O/6NAUqhUqzq5kCQt/5xy3uK4dJ7+VqWZktTmKufnoEse4rm08kWl/HKo
         5Kea6FV+65ALDBrVa5wXZ/y+cEeZo52ChVRwO59iOt6AgWsq1jXVyfa4ywNh9sUfZlPk
         UxzvlnE3tYZg6A95hEBlL/AJz803BViMk8b/v376zEaFXMVgV3Ui5zg60GMdDKuFOHX5
         Wbrg==
X-Gm-Message-State: APjAAAXUTF508MN7xMRzCd1Va6kFp0jXLESjmXIZrJcIDg23iUhXxAJN
        Xe4Ijxv5eWDbqZhqO8MCTSepK7wudnm2qoS4RVI=
X-Google-Smtp-Source: APXvYqwHxVY2ZtB2Uv/so5rYeUGcdPCAWPgN1d7FFdkYS/5RfP/e9M9bHS9xYU8ICrO2uHAkHiO6N8cK7Yr7RJ7ewaA=
X-Received: by 2002:a63:544f:: with SMTP id e15mr2475086pgm.344.1552514730218;
 Wed, 13 Mar 2019 15:05:30 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 13 Mar 2019 17:05:19 -0500
Message-ID: <CAH2r5ms0Q2UDyhVS9=c5JNSq9qbz_DRxohtQDGdokzyLtpbT5A@mail.gmail.com>
Subject: Coverity Warnings and RDMA logging
To:     Long Li <longli@microsoft.com>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

12 of the Coverity warnings against cifs.ko are related to RDMA
logging, and are harmless, but would be nice to remove.  "log_rdma" is
called from "log_rdma_mr" with level set to ERR (ie zero).   So it
confuses coverity who sees an always true statement not realizing that
it could be a little cleaner to call it this way than to remove the
error by calling "cifs_dbg(VFS, ....)" directly (which would remove
the warning.   Perhaps better would be to create a log_rdma_mr_err
which calls cifs_dbg correctly without the if statement.


#define log_rdma(level, class, fmt, args...)                            \
do {                                                                    \
        if (level <= smbd_logging_level || class & smbd_logging_class)  \
                cifs_dbg(VFS, "%s:%d " fmt, __func__, __LINE__, ##args);\
} while (0)

Thoughts?   This is not a bug but 12 coverity warnings are noisy
-- 
Thanks,

Steve
