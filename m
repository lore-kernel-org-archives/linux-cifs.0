Return-Path: <SRS0=UtyP=X2=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13E3FC352AA
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Oct 2019 07:34:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D359E21783
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Oct 2019 07:34:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LLu0cSA+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732831AbfJAHeT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 1 Oct 2019 03:34:19 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44279 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730309AbfJAHeT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 1 Oct 2019 03:34:19 -0400
Received: by mail-pg1-f196.google.com with SMTP id i14so8967018pgt.11;
        Tue, 01 Oct 2019 00:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=ot/IGJhnaWxZvW9P2a340WNpW/yOACBbfoIURXC6g8I=;
        b=LLu0cSA+h6aDXfWGDV/crkX8ECQiZvi5lMd1c7CMaaQ/9FyqSo9nFRmJyz9l6jQp60
         V0R73T2ZQfQ7YkVQ105OcOZ5B9DzugkqKX9vH3FlP1AwH7AcJsE0rXm0yc0WvLF6jqO7
         nFIZAunvbZH2vsH5Qbc8rX2BZFYmwvJOT0QjexAG2353Qn+dm2TX0FL5G981lQYaZZtv
         c/ykKDwMhGyuZzKeL2WaLEnqp4Uwbv1Iqk2ugTzN7M7GR5U6C24cJkrzn5BKJnUA+guo
         WX/cfSCBcTQZBXwDshuV2jrP997QvPwx3ZkxY+NX1Tua5VLwgZX7/uM5Wgf8YA1njkWk
         oNZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=ot/IGJhnaWxZvW9P2a340WNpW/yOACBbfoIURXC6g8I=;
        b=HvLEHMKHUdrThkwaXqN65i9oGzcGe69wkdhj0uQCQnE/sBEjuGkwg1jSQIkeQ/vBK+
         yh4dTN7h2HlONXrAkZSEn4amCIMNup6t32hFhNulrPi+YRA3G5lXWpm1WSJBauDDGklg
         IkwqdF7iHP7UGbnHsmJ9I1VJhd1Ws2Y726+EuAmxcOYh6lSFDu6yvcEwQ1sigkVeltBL
         4rKkgV/uzHDPYaFZGAXbw1roR80Pqd2V8j3sBQf0ZieYeqYP76WcNK+cFsbpT7cPJFyX
         POPGmanvS4HNnW8hoxbZ/nLXHT2TEKZ+Pl7bZPG1wMz5ysFwjdPkhn3JeCSWh3tGZc4l
         YYzA==
X-Gm-Message-State: APjAAAWq6cO/ewkj85HJYuAKkKfWqH1peyiz+MUfGzh8l0SDEs0FwJmz
        GGCZVmaGZVKt5/163glgaHdRNJVFbtk=
X-Google-Smtp-Source: APXvYqwSlngMwUYdq4FHHWnJQxxhIwfYEmTldrjQed+J46b7UWAoekYeb4wUseZPMPj6vwYytsvdCw==
X-Received: by 2002:a62:4d45:: with SMTP id a66mr26442682pfb.24.1569915258432;
        Tue, 01 Oct 2019 00:34:18 -0700 (PDT)
Received: from LGEARND20B15 ([27.122.242.75])
        by smtp.gmail.com with ESMTPSA id u3sm13522535pfn.134.2019.10.01.00.34.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 00:34:17 -0700 (PDT)
Date:   Tue, 1 Oct 2019 16:34:13 +0900
From:   Austin Kim <austindh.kim@gmail.com>
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, austindh.kim@gmail.com
Subject: [PATCH] fs: cifs: mute -Wunused-const-variable message
Message-ID: <20191001073413.GA51148@LGEARND20B15>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

After 'Initial git repository build' commit,
'mapping_table_ERRHRD' variable has not been used.

So 'mapping_table_ERRHRD' const variable could be removed
to mute below warning message:

   fs/cifs/netmisc.c:120:40: warning: unused variable 'mapping_table_ERRHRD' [-Wunused-const-variable]
   static const struct smb_to_posix_error mapping_table_ERRHRD[] = {
                                           ^
Signed-off-by: Austin Kim <austindh.kim@gmail.com>
---
 fs/cifs/netmisc.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index 49c17ee1..9b41436 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -117,10 +117,6 @@ static const struct smb_to_posix_error mapping_table_ERRSRV[] = {
 	{0, 0}
 };
 
-static const struct smb_to_posix_error mapping_table_ERRHRD[] = {
-	{0, 0}
-};
-
 /*
  * Convert a string containing text IPv4 or IPv6 address to binary form.
  *
-- 
2.6.2

