Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BD47C7EE2A
	for <linux-cifs@archiver.kernel.org>; Tue, 16 May 2023 15:03:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233549AbjEPPDU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 May 2023 11:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233671AbjEPPDS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 May 2023 11:03:18 -0400
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 16 May 2023 08:03:10 PDT
Received: from esa6.hc3370-68.iphmx.com (esa6.hc3370-68.iphmx.com [216.71.155.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19065FC2
        for <linux-cifs@vger.kernel.org>; Tue, 16 May 2023 08:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1684249390;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Usibt7HOG39eFagppgtGoZEoQBN4X29l/kT8CiHklkg=;
  b=YKz6AmnoPvg6l0JcS1pU/4j/0Y/exkdvnBE79MiCtoqBCmrivRD9wN5m
   enA7F/+RoTjnQOYizbOocZhPcNwFayC/5Fw8u8nfrZAu2O9JRSFO7jYEJ
   Hp3o7k330fgi5nEV4NC1geNzU6MjrbhEiRs9GRL/u0aOmJM5El6O+N/DL
   Q=;
Authentication-Results: esa6.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
X-SBRS: 4.0
X-MesageID: 108563747
X-Ironport-Server: esa6.hc3370-68.iphmx.com
X-Remote-IP: 162.221.156.123
X-Policy: $RELAYED
IronPort-Data: A9a23:OzkmFq54pLMd4ajNgRUhsAxRtOfHchMFZxGqfqrLsTDasY5as4F+v
 mQXXW3Xa/aDYTb8KIxxPIm3phwG65SByN5mGQdurilgHi5G8cbLO4+Ufxz6V8+wwm8vb2o8t
 plDNYOQRCwQZiWBzvt4GuG59RGQ7YnRGvynTraCYnsrLeNdYH9JoQp5nOIkiZJfj9G8Agec0
 fv/uMSaM1K+s9JOGjt8B5mr9VU+7ZwehBtC5gZlPa0S4geE/5UoJMl3yZ+ZfiOQrrZ8RoZWd
 86bpJml82XQ+QsaC9/Nut4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5iXBYoUm9Fii3hojxE4
 I4lWapc6+seFvakdOw1C3G0GszlVEFM0OevzXOX6aR/w6BaGpdFLjoH4EweZOUlFuhL7W5mq
 P4SMBsXPgi4lcmvx4uwE/luudQsBZy+VG8fkikIITDxCP8nRdbIQrnQ5M8e1zA17ixMNa+AP
 YxDM2MpNUmeJUQVYT/7C7pn9AusrmP4aCYerFuaqLAo6mzX5AdwzKLsIJzefdniqcB9xx7I+
 zydoDimav0cHIXEmROD6kqyuvTSsC7gU58oK7+Rx8c/1TV/wURMUUZLBDNXu8KRjk+4RsIaI
 E0a4QIwoqUosk+mVN/wW1u/unHslgUSQddWGO0S8wiIwKOS5ByWbkAcRRZKasZgst1ebTgx3
 1+Nld7zLSZivL2cVTSW8bL8hS+1PAAJJGsaaD5CRgwAi/H4uJs6lRvDZtNiG7Syldr7BXf7x
 DXihDI5h7QPjdUj0qSw51fchDyw4JPOS2YICh7/Bzz/qFkjPcj8OtLusAKAhRpdEGqHZgSDt
 mAvgZiG1/IlFJa0n3WdQtodE5j8sp5pLwbgqVJoGpAg8RGk9HiiYZ1c7VlCGat5DioXUWS3O
 RGO4Gu98LcWZSL3NvEvP+pdHuxwlcDd+cLZuuc4hzakSrx4b0e58S5nfiZ8NEi9wRF3wcnT1
 Xp2GPtA7Er264w9lFJapM9Hi9fHIxzSIkuNLa0XNzz9jdKjiIe9EN/pymemYOEj97+jqw7I6
 dtZPMbi40wBALGnPXSJoNdPcgpiwZ0H6Xfe+qRqmhOreFI6SAnN9deLqV/eR2CVt/sMzbqZl
 p1MckRZ1ED+lRX6FOl+UVg6MOmHdc8m/RoG0dkEYQ7AN44LPdz+s8/ytvIfIdEayQCU5aAkE
 KRVJ5rZWZyiiF3volwgUHU0l6Q6HDzDuO5EF3HNjOQXF3K4ezH0xw==
IronPort-HdrOrdr: A9a23:E7/Jc6tcE1p7szvWNUhDOYwu7skDjNV00zEX/kB9WHVpm6yj+v
 xGUs566faUskd0ZJhEo7q90ca7Lk80maQa3WBzB8bGYOCFghrKEGgK1+KLrwEIcxeUygc379
 YDT0ERMrzN5VgRt7eG3OG7eexQvOVuJsqT9JjjJ3QGd3AVV0l5hT0JbTpyiidNNXJ77ZxSLu
 v72uN34wCOVF4wdcqBCnwMT4H41qf2fMKPW29+O/Y/gjP+9Q+V1A==
X-Talos-CUID: 9a23:JidKCm/Y+QMYiaz69OSVvxMWENgOaC3F92X7OkiBAj95SoKFRnbFrQ==
X-Talos-MUID: =?us-ascii?q?9a23=3AC9tiEQ0L6gkcsXsNpoY9q2vDIjUjuv/+IUYVqYs?=
 =?us-ascii?q?6oNSpODd7Jg2ijh2Ge9py?=
X-IronPort-AV: E=Sophos;i="5.99,278,1677560400"; 
   d="scan'208";a="108563747"
From:   Ross Lagerwall <ross.lagerwall@citrix.com>
To:     <linux-cifs@vger.kernel.org>
CC:     Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        "Ronnie Sahlberg" <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        "Tom Talpey" <tom@talpey.com>,
        Rohith Surabattula <rohiths@microsoft.com>,
        "Ross Lagerwall" <ross.lagerwall@citrix.com>
Subject: [PATCH] cifs: Close deferred files that may be open via hard links
Date:   Tue, 16 May 2023 16:01:53 +0100
Message-ID: <20230516150153.1864023-1-ross.lagerwall@citrix.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Windows Server (tested with 2016) disallows opening the same inode via
two different hardlinks at the same time. With deferred closes, this can
result in unexpected behaviour as the following Python snippet shows:

    # Create file
    fd = os.open('test', os.O_WRONLY|os.O_CREAT)
    os.write(fd, b'foo')
    os.close(fd)

    # Open and close the file to leave a pending deferred close
    fd = os.open('test', os.O_RDONLY|os.O_DIRECT)
    os.close(fd)

    # Try to open the file via a hard link
    os.link('test', 'new')
    newfd = os.open('new', os.O_RDONLY|os.O_DIRECT)

The final open returns EINVAL due to the server returning
STATUS_INVALID_PARAMETER.

Fix this by closing any deferred closes that may be open via other hard
links if we haven't successfully reused a cached handle.

Fixes: c3f207ab29f7 ("cifs: Deferred close for files")
Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
---

This is kind of an RFC. Is the server doing the wrong thing? Is it
correct to work around this in the client?

 fs/cifs/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index c5fcefdfd797..723cbc060f57 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -749,6 +749,7 @@ int cifs_open(struct inode *inode, struct file *file)
 			_cifsFileInfo_put(cfile, true, false);
 		}
 	}
+	cifs_close_deferred_file(CIFS_I(inode));
 
 	if (server->oplocks)
 		oplock = REQ_OPLOCK;
-- 
2.31.1

