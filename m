Return-Path: <SRS0=4YGq=XT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CC96C432C1
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Sep 2019 04:56:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47DAA207FD
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Sep 2019 04:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390541AbfIXE4R (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Sep 2019 00:56:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59156 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388254AbfIXE4Q (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 24 Sep 2019 00:56:16 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 087B483F45;
        Tue, 24 Sep 2019 04:56:16 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.76.1.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 70F3F60852;
        Tue, 24 Sep 2019 04:56:14 +0000 (UTC)
From:   Kenneth D'souza <kdsouza@redhat.com>
To:     linux-cifs@vger.kernel.org, piastryyy@gmail.com, smfrench@gmail.com
Cc:     lsahlber@redhat.com
Subject: [PATCH] smb2quota.py: Userspace helper to display quota information for the Linux SMB client file system (CIFS)
Date:   Tue, 24 Sep 2019 10:26:11 +0530
Message-Id: <20190924045611.21689-1-kdsouza@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 24 Sep 2019 04:56:16 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 smb2quota.py | 172 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 172 insertions(+)
 create mode 100755 smb2quota.py

diff --git a/smb2quota.py b/smb2quota.py
new file mode 100755
index 0000000..11d98db
--- /dev/null
+++ b/smb2quota.py
@@ -0,0 +1,172 @@
+#!/usr/bin/env python
+# coding: utf-8
+#
+# smb2quota is a cmdline tool to display quota information for the
+# Linux SMB client file system (CIFS)
+#
+# Copyright (C) Ronnie Sahlberg (lsahlberg@redhat.com) 2019
+# Copyright (C) Kenneth D'souza (kdsouza@redhat.com) 2019
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+# GNU General Public License for more details.
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+
+
+import array
+import fcntl
+import os
+import struct
+import sys
+import argparse
+
+CIFS_QUERY_INFO = 0xc018cf07
+BBOLD = '\033[1;30;47m'   # Bold black text with white background.
+ENDC = '\033[m'   # Rest to defaults
+
+
+def usage():
+    print("Usage: %s [-h] <options>  <filename>" % sys.argv[0])
+    print("Try 'smb2quota -h' for more information")
+    sys.exit()
+
+
+class SID:
+    def __init__(self, buf):
+        self.sub_authority_count = buf[1]
+        self.buffer = buf[:8 + self.sub_authority_count * 4]
+        self.revision = self.buffer[0]
+        if self.revision != 1:
+            raise ValueError('SID Revision %d not supported' % self.revision)
+        self.identifier_authority = 0
+        for x in self.buffer[2:8]:
+            self.identifier_authority = self.identifier_authority * 256 + x
+        self.sub_authority = []
+        for i in range(self.sub_authority_count):
+            self.sub_authority.append(struct.unpack_from('<I', self.buffer, 8 + 4 * i)[0])
+
+    def __str__(self):
+        s = "S-%u-%u" % (self.revision, self.identifier_authority)
+        for x in self.sub_authority:
+            s += '-%u' % x
+        return s
+
+
+def convert(num):  # Convert bytes to closest human readable UNIT.
+    for unit in ['', 'kiB', 'MiB', 'GiB', 'TiB', 'PiB', 'EiB']:
+        if abs(num) < 1024.0:
+            return "%3.1f %s" % (num, unit)
+        num /= 1024.0
+
+
+class QuotaEntry:
+    def __init__(self, buf, flag):
+        sl = struct.unpack_from('<I', buf, 4)[0]
+        self.sid = SID(buf[40:40 + sl])
+        self.used = struct.unpack_from('<Q', buf, 16)[0]
+        self.thr = struct.unpack_from('<Q', buf, 24)[0]
+        self.lim = struct.unpack_from('<Q', buf, 32)[0]
+        self.a = (convert(self.used))
+        self.b = (convert(self.thr))
+        self.c = (convert(self.lim))
+        self.flag = flag
+
+    def __str__(self):
+        if self.flag == 0:
+            s = " %-11s | %-11s | %-13s | %s" % (self.a, self.c, self.b, self.sid)
+        elif self.flag == 1:
+            s = "%s,%d,%d,%d" % (self.sid, self.used, self.lim, self.thr)
+        else:
+            s = 'SID:%s\n' % self.sid
+            s += 'Quota Used:%d\n' % self.used
+            if self.thr == 0xffffffffffffffff:
+                s += 'Quota Threshold Limit:NO_WARNING_THRESHOLD\n'
+            else:
+                s += 'Quota Threshold Limit:%d\n' % self.thr
+            if self.lim == 0xffffffffffffffff:
+                s += 'Quota Limit:NO_LIMIT\n'
+            else:
+                s += 'Quota Limit:%d\n' % self.lim
+        return s
+
+
+class Quota:
+    def __init__(self, buf, flag):
+        self.quota = []
+        s = struct.unpack_from('<I', buf, 0)[0]
+        while s:
+            qe = QuotaEntry(buf[0:s], flag)
+            self.quota.append(qe)
+            buf = buf[s:]
+            a = s
+            s = struct.unpack_from('<I', buf, 0)[0]
+            if s == 0:
+                s = a   # Use the last value of s and process it.
+                qe = QuotaEntry(buf[0:s], flag)
+                self.quota.append(qe)
+                break
+
+    def __str__(self):
+        s = ''
+        for q in self.quota:
+            s += '%s\n' % q
+        return s
+
+
+def parser_check(path, flag):
+    titleused = "Amount Used"
+    titlelim = "Quota Limit"
+    titlethr = "Warning Level"
+    titlesid = "SID"
+    buf = array.array('B', [0] * 16384)
+    struct.pack_into('<I', buf, 0, 4)  # InfoType: Quota
+    struct.pack_into('<I', buf, 16, 16384)  # InputBufferLength
+    struct.pack_into('<I', buf, 20, 16)  # OutputBufferLength
+    struct.pack_into('b', buf, 24, 0)  # return single
+    struct.pack_into('b', buf, 25, 1)  # return single
+    try:
+        f = os.open(path, os.O_RDONLY)
+        fcntl.ioctl(f, CIFS_QUERY_INFO, buf, 1)
+        os.close(f)
+        if flag == 0:
+            print(BBOLD + " %-7s | %-7s | %-7s | %s " + ENDC) % (titleused, titlelim, titlethr, titlesid)
+        q = Quota(buf[24:24 + struct.unpack_from('<I', buf, 16)[0]], flag)
+        print(q)
+    except IOError as reason:
+        print("ioctl failed: %s" % reason)
+    except OSError as reason:
+        print("ioctl failed: %s" % reason)
+
+
+def main():
+    if len(sys.argv) < 2:
+        usage()
+
+    parser = argparse.ArgumentParser(description="Please specify an action to perform.", prog="smb2quota")
+    parser.add_argument("-tabular", "-t", metavar="", help="Print quota information in tabular format")
+    parser.add_argument("-csv", "-c", metavar="", help="Print quota information in csv format")
+    parser.add_argument("-list", "-l", metavar="", help="Print quota information in list format")
+    args = parser.parse_args()
+
+    if args.tabular:
+        path = args.tabular
+        parser_check(path, 0)
+
+    if args.csv:
+        path = args.csv
+        parser_check(path, 1)
+
+    if args.list:
+        path = args.list
+        parser_check(path, 2)
+
+
+if __name__ == "__main__":
+    main()
-- 
2.21.0

