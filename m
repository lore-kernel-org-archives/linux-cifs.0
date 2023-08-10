Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D342CC001B0
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Aug 2023 07:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbjHJHVZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 10 Aug 2023 03:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjHJHVZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 10 Aug 2023 03:21:25 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E8C10C
        for <linux-cifs@vger.kernel.org>; Thu, 10 Aug 2023 00:21:24 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1bdaba98945so65305ad.2
        for <linux-cifs@vger.kernel.org>; Thu, 10 Aug 2023 00:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=har.mn; s=google; t=1691652084; x=1692256884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=88gUYIJkJYKMx1oOiBngjwpK9wFuxdelofupUObZAsc=;
        b=oHlU6zDG7r8Dmy5tCzhi1rfg/TsLidKHUsWMjb2OH2XC3F+FiORH+gRj2kw+44TLHz
         v+GzRntXPXEp/9RxvjXGbM0QFoMALZqecUjGsyaMyMrQsEPRv74P220R7G1dsnPxXXRx
         Q4yfSjIfbSQlWMqnaato60tMfK3GgguLXitNk6XlMFEniBjU/g4ctLD5zIYEdysO2kjE
         4WBHS9dzeEhuStyKkpIMNQ0UW8IFtg6dZzsx2CDr8oTN3nEFtdczD2NVkTRqS/2T+kV1
         BeKcS6LcNgF9QQmXovSbNudlAR4ABeJzMBCNvlXy3Rx0/wp1i0SVuoWQJtciTI29OrKT
         pKeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691652084; x=1692256884;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=88gUYIJkJYKMx1oOiBngjwpK9wFuxdelofupUObZAsc=;
        b=a46HLL6zaKgpDQmmuVO14Wpwzdc6ka/B+OZ5Z/+jvVVpNr5uv538Up3fer3zPrabhz
         DWGX+wRY51z0LlyoQwkjjE+FrTXJ6N9J6ItCf62SU6WhOcJzPhEuknKnW4JixtBPud7Y
         ip5EVmL0YD1S8cGB2PsCTPg7MiEGG4owtSIbVO/X/FEzYoTfKVPMvALBO2V7wIZXELYm
         Sf+xWKsz5yGsjN8cL3jYhPoO2kdMakkoLMun3BVp1AJw+lGBw+qcy9O/AnFruoCOzGar
         YFdYCUl4pEP24Pl6SLQYzqBVIKfSudpz8/ZPc+d0P005QbW5wa4CTjdGhqrZvn8WNp/y
         EClA==
X-Gm-Message-State: AOJu0YwDkBG5wrp+D36lX/hEiS3Kodi/jN5zeYXgAuqKkDlOfpPYZgSa
        94Urt1/l4GCm6nZ/btcdD22240Ej+ZwL7yCOV3Vw8A==
X-Google-Smtp-Source: AGHT+IFS3RdngNcQCLh5I4/mZEFhmcaVS6zrbm3tihvuBvrjaOP+7xhS1fOj2rm1KLVcY4g+Pf77Ug==
X-Received: by 2002:a17:902:8692:b0:1bb:a6de:8e49 with SMTP id g18-20020a170902869200b001bba6de8e49mr1171972plo.9.1691652084052;
        Thu, 10 Aug 2023 00:21:24 -0700 (PDT)
Received: from localhost.localdomain ([76.132.108.20])
        by smtp.gmail.com with ESMTPSA id g5-20020a170902868500b001bb9f104333sm880561plo.12.2023.08.10.00.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 00:21:23 -0700 (PDT)
From:   Russell Harmon <russ@har.mn>
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        Russell Harmon <russ@har.mn>
Subject: [PATCH v1 1/1] cifs: Release folio lock on fscache read hit.
Date:   Thu, 10 Aug 2023 00:19:22 -0700
Message-Id: <20230810071922.30229-2-russ@har.mn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230810071922.30229-1-russ@har.mn>
References: <20230810071922.30229-1-russ@har.mn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Under the current code, when cifs_readpage_worker is called, the call
contract is that the callee should unlock the page. This is documented
in the read_folio section of Documentation/filesystems/vfs.rst as:

> The filesystem should unlock the folio once the read has completed,
> whether it was successful or not.

Without this change, when fscache is in use and cache hit occurs during
a read, the page lock is leaked, producing the following stack on
subsequent reads (via mmap) to the page:

$ cat /proc/3890/task/12864/stack
[<0>] folio_wait_bit_common+0x124/0x350
[<0>] filemap_read_folio+0xad/0xf0
[<0>] filemap_fault+0x8b1/0xab0
[<0>] __do_fault+0x39/0x150
[<0>] do_fault+0x25c/0x3e0
[<0>] __handle_mm_fault+0x6ca/0xc70
[<0>] handle_mm_fault+0xe9/0x350
[<0>] do_user_addr_fault+0x225/0x6c0
[<0>] exc_page_fault+0x84/0x1b0
[<0>] asm_exc_page_fault+0x27/0x30

This requires a reboot to resolve; it is a deadlock.

Note however that the call to cifs_readpage_from_fscache does mark the
page clean, but does not free the folio lock. This happens in
__cifs_readpage_from_fscache on success. Releasing the lock at that
point however is not appropriate as cifs_readahead also calls
cifs_readpage_from_fscache and *does* unconditionally release the lock
after its return. This change therefore effectively makes
cifs_readpage_worker work like cifs_readahead.

Signed-off-by: Russell Harmon <russ@har.mn>
---
 fs/smb/client/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index fc5acc95cd13..767bcdd95b31 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -4681,9 +4681,9 @@ static int cifs_readpage_worker(struct file *file, struct page *page,
 
 io_error:
 	kunmap(page);
-	unlock_page(page);
 
 read_complete:
+	unlock_page(page);
 	return rc;
 }
 
-- 
2.34.1

