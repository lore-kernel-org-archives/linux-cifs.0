From: Steve French <smfrench@gmail.com>
Subject: [PATCH][SMB3] Add ftrace support
Date: Wed, 16 May 2018 17:42:06 -0500
Message-ID: <CAH2r5mu9kiY7iKajieNNyVzmw=D5g_mTUizowpGbiKjU5-cLmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="000000000000e07e85056c5a6eab"
To: LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--000000000000e07e85056c5a6eab
Content-Type: text/plain; charset="UTF-8"

I plan to add various tracepoints to cifs.ko, but wanted to verify
that the initial patch looks ok (which only adds logging for one
event, write errors), before I start adding various other tracepoints.

Also I need to know ... is the size of log entries a problem? I have
to weight logging just the tree id (and relying on an ioctl or
proc/fs/cifs call to resolve the numeric tree id to a more readable
UNC name ie \\server\share for the mount)?

Generally I want to log these four things
tree id
session id
file id (for everything but open/tree connect/negprot/session setup
where it is not applicable) and/or file name (is logging file name
going to make log entries too big?)
xid (so we can correlate events from one syscall)


>From f190a0c82ce8c95db1c43b7b41115ffc7bb6fb2f Mon Sep 17 00:00:00 2001
From: Steve French <stfrench@microsoft.com>
Date: Wed, 16 May 2018 16:42:27 -0500
Subject: [PATCH] smb3: Add ftrace tracepoints for improved SMB3 debugging

Although dmesg logs and wireshark network traces can be
helpful, being able to dynamically enable/disable tracepoints
(in this case via the kernel ftrace mechanism) can also be
helpful in more quickly debugging problems, and more
selectively tracing the events related to the bug report.

Add various ftrace tracepoints to cifs.ko for SMB3 events.

Example use:
   trace-cmd record -e cifs
   <run test case>
   trace-cmd show

Various trace events can be filtered. See:
       trace-cmd list | grep cifs
for the current list of cifs tracepoints.

Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/Makefile  |  7 +++--
 fs/cifs/smb2pdu.c |  6 ++++
 fs/cifs/trace.c   | 18 ++++++++++++
 fs/cifs/trace.h   | 71 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 99 insertions(+), 3 deletions(-)
 create mode 100644 fs/cifs/trace.c
 create mode 100644 fs/cifs/trace.h

diff --git a/fs/cifs/Makefile b/fs/cifs/Makefile
index 7e4a1e2f0696..85817991ee68 100644
--- a/fs/cifs/Makefile
+++ b/fs/cifs/Makefile
@@ -1,11 +1,12 @@
 # SPDX-License-Identifier: GPL-2.0
 #
-# Makefile for Linux CIFS VFS client
+# Makefile for Linux CIFS/SMB2/SMB3 VFS client
 #
+ccflags-y += -I$(src)        # needed for trace events
 obj-$(CONFIG_CIFS) += cifs.o

-cifs-y := cifsfs.o cifssmb.o cifs_debug.o connect.o dir.o file.o inode.o \
-      link.o misc.o netmisc.o smbencrypt.o transport.o asn1.o \
+cifs-y := trace.o cifsfs.o cifssmb.o cifs_debug.o connect.o dir.o file.o \
+      inode.o link.o misc.o netmisc.o smbencrypt.o transport.o asn1.o \
       cifs_unicode.o nterr.o cifsencrypt.o \
       readdir.o ioctl.o sess.o export.o smb1ops.o winucase.o \
       smb2ops.o smb2maperror.o smb2transport.o \
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 35350057fc23..790d8faf8e1e 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -49,6 +49,7 @@
 #include "cifspdu.h"
 #include "cifs_spnego.h"
 #include "smbdirect.h"
+#include "trace.h"

 /*
  *  The following table defines the expected "StructureSize" of SMB2 requests
@@ -3058,6 +3059,8 @@ smb2_async_writev(struct cifs_writedata *wdata,
                  wdata, flags);

     if (rc) {
+        trace_smb3_write_err(rc, 0 /* no xid */, req->PersistentFileId,
+                     tcon->tid, wdata->offset, wdata->bytes);
         kref_put(&wdata->refcount, release);
         cifs_stats_fail_inc(tcon, SMB2_WRITE_HE);
     }
@@ -3124,6 +3127,9 @@ SMB2_write(const unsigned int xid, struct
cifs_io_parms *io_parms,
     rsp = (struct smb2_write_rsp *)rsp_iov.iov_base;

     if (rc) {
+        trace_smb3_write_err(rc, xid, req->PersistentFileId,
+                     io_parms->tcon->tid, io_parms->offset,
+                     io_parms->length);
         cifs_stats_fail_inc(io_parms->tcon, SMB2_WRITE_HE);
         cifs_dbg(VFS, "Send error in write = %d\n", rc);
     } else
diff --git a/fs/cifs/trace.c b/fs/cifs/trace.c
new file mode 100644
index 000000000000..bd4a546feec1
--- /dev/null
+++ b/fs/cifs/trace.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *   Copyright (C) 2018, Microsoft Corporation.
+ *
+ *   Author(s): Steve French <stfrench@microsoft.com>
+ *
+ *   This program is free software;  you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU General Public License for more details.
+ */
+#define CREATE_TRACE_POINTS
+#include "trace.h"
diff --git a/fs/cifs/trace.h b/fs/cifs/trace.h
new file mode 100644
index 000000000000..1e7b38e2fa15
--- /dev/null
+++ b/fs/cifs/trace.h
@@ -0,0 +1,71 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *   Copyright (C) 2018, Microsoft Corporation.
+ *
+ *   Author(s): Steve French <stfrench@microsoft.com>
+ *
+ *   This program is free software;  you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU General Public License for more details.
+ */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM cifs
+
+#if !defined(_CIFS_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _CIFS_TRACE_H
+
+#include <linux/tracepoint.h>
+
+DECLARE_EVENT_CLASS(smb3_err_class,
+    TP_PROTO(unsigned int xid,
+        __u64    fid,
+        __u32    tid,
+        __u64    offset,
+        __u32    len,
+        int    rc),
+    TP_ARGS(xid, fid, tid, offset, len, rc),
+    TP_STRUCT__entry(
+        __field(unsigned int, xid)
+        __field(__u64, fid)
+        __field(__u32, tid)
+        __field(__u64, offset)
+        __field(__u32, len)
+        __field(int, rc)
+    ),
+    TP_fast_assign(
+        __entry->xid = xid;
+        __entry->fid = fid;
+        __entry->tid = tid;
+        __entry->offset = offset;
+        __entry->len = len;
+        __entry->rc = rc;
+    ),
+    TP_printk("xid=%u fid=%llu tid=%u offset=%llu len=%u rc=%d",
+        __entry->xid, __entry->fid, __entry->tid, __entry->offset,
+        __entry->len, __entry->rc)
+)
+
+#define DEFINE_SMB3_ERR_EVENT(name)             \
+DEFINE_EVENT(smb3_err_class, smb3_##name,       \
+    TP_PROTO(unsigned int xid,        \
+        __u64    fid,            \
+        __u32    tid,            \
+        __u64    offset,            \
+        __u32    len,            \
+        int    rc),            \
+    TP_ARGS(xid, fid, tid, offset, len, rc))
+
+DEFINE_SMB3_ERR_EVENT(write_err);
+
+#endif /* _CIFS_TRACE_H */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE trace
+#include <trace/define_trace.h>
-- 
2.17.0


-- 
Thanks,

Steve

--000000000000e07e85056c5a6eab
Content-Type: text/x-patch; charset="US-ASCII";
	name="0001-smb3-Add-ftrace-tracepoints-for-improved-SMB3-debugg.patch"
Content-Disposition: attachment;
	filename="0001-smb3-Add-ftrace-tracepoints-for-improved-SMB3-debugg.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jh9ox3910

RnJvbSBmMTkwYTBjODJjZThjOTVkYjFjNDNiN2I0MTExNWZmYzdiYjZmYjJmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFdlZCwgMTYgTWF5IDIwMTggMTY6NDI6MjcgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBBZGQgZnRyYWNlIHRyYWNlcG9pbnRzIGZvciBpbXByb3ZlZCBTTUIzIGRlYnVnZ2luZwoK
QWx0aG91Z2ggZG1lc2cgZXJyb3JzIGFuZCB3aXJlc2hhcmsgbmV0d29yayB0cmFjZXMgY2FuIGJl
CmhlbHBmdWwsIGJlaW5nIGFibGUgdG8gZHluYW1pY2FsbHkgZW5hYmxlL2Rpc2FibGUgdHJhY2Vw
b2ludHMKKGluIHRoaXMgY2FzZSB2aWEgdGhlIGtlcm5lbCBmdHJhY2UgbWVjaGFuaXNtKSBjYW4g
YWxzbyBiZQpoZWxwZnVsIGluIG1vcmUgcXVpY2tseSBkZWJ1Z2dpbmcgcHJvYmxlbXMsIGFuZCBt
b3JlCnNlbGVjdGl2ZWx5IHRyYWNpbmcgdGhlIGV2ZW50cyByZWxhdGVkIHRvIHRoZSBidWcgcmVw
b3J0LgoKQWRkIHZhcmlvdXMgZnRyYWNlIHRyYWNlcG9pbnRzIHRvIGNpZnMua28gZm9yIFNNQjMg
ZXZlbnRzLgoKRXhhbXBsZSB1c2U6CiAgIHRyYWNlLWNtZCByZWNvcmQgLWUgY2lmcwogICA8cnVu
IHRlc3QgY2FzZT4KICAgdHJhY2UtY21kIHNob3cKClZhcmlvdXMgdHJhY2UgZXZlbnRzIGNhbiBi
ZSBmaWx0ZXJlZC4gU2VlOgogICAgICAgdHJhY2UtY21kIGxpc3QgfCBncmVwIGNpZnMKZm9yIHRo
ZSBjdXJyZW50IGxpc3Qgb2YgY2lmcyB0cmFjZXBvaW50cy4KClNpZ25lZC1vZmYtYnk6IFN0ZXZl
IEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KLS0tCiBmcy9jaWZzL01ha2VmaWxlICB8
ICA3ICsrKy0tCiBmcy9jaWZzL3NtYjJwZHUuYyB8ICA2ICsrKysKIGZzL2NpZnMvdHJhY2UuYyAg
IHwgMTggKysrKysrKysrKysrCiBmcy9jaWZzL3RyYWNlLmggICB8IDcxICsrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCiA0IGZpbGVzIGNoYW5nZWQsIDk5IGlu
c2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCiBjcmVhdGUgbW9kZSAxMDA2NDQgZnMvY2lmcy90
cmFjZS5jCiBjcmVhdGUgbW9kZSAxMDA2NDQgZnMvY2lmcy90cmFjZS5oCgpkaWZmIC0tZ2l0IGEv
ZnMvY2lmcy9NYWtlZmlsZSBiL2ZzL2NpZnMvTWFrZWZpbGUKaW5kZXggN2U0YTFlMmYwNjk2Li44
NTgxNzk5MWVlNjggMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvTWFrZWZpbGUKKysrIGIvZnMvY2lmcy9N
YWtlZmlsZQpAQCAtMSwxMSArMSwxMiBAQAogIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BM
LTIuMAogIwotIyBNYWtlZmlsZSBmb3IgTGludXggQ0lGUyBWRlMgY2xpZW50IAorIyBNYWtlZmls
ZSBmb3IgTGludXggQ0lGUy9TTUIyL1NNQjMgVkZTIGNsaWVudAogIworY2NmbGFncy15ICs9IC1J
JChzcmMpCQkjIG5lZWRlZCBmb3IgdHJhY2UgZXZlbnRzCiBvYmotJChDT05GSUdfQ0lGUykgKz0g
Y2lmcy5vCiAKLWNpZnMteSA6PSBjaWZzZnMubyBjaWZzc21iLm8gY2lmc19kZWJ1Zy5vIGNvbm5l
Y3QubyBkaXIubyBmaWxlLm8gaW5vZGUubyBcCi0JICBsaW5rLm8gbWlzYy5vIG5ldG1pc2MubyBz
bWJlbmNyeXB0Lm8gdHJhbnNwb3J0Lm8gYXNuMS5vIFwKK2NpZnMteSA6PSB0cmFjZS5vIGNpZnNm
cy5vIGNpZnNzbWIubyBjaWZzX2RlYnVnLm8gY29ubmVjdC5vIGRpci5vIGZpbGUubyBcCisJICBp
bm9kZS5vIGxpbmsubyBtaXNjLm8gbmV0bWlzYy5vIHNtYmVuY3J5cHQubyB0cmFuc3BvcnQubyBh
c24xLm8gXAogCSAgY2lmc191bmljb2RlLm8gbnRlcnIubyBjaWZzZW5jcnlwdC5vIFwKIAkgIHJl
YWRkaXIubyBpb2N0bC5vIHNlc3MubyBleHBvcnQubyBzbWIxb3BzLm8gd2ludWNhc2UubyBcCiAJ
ICBzbWIyb3BzLm8gc21iMm1hcGVycm9yLm8gc21iMnRyYW5zcG9ydC5vIFwKZGlmZiAtLWdpdCBh
L2ZzL2NpZnMvc21iMnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1LmMKaW5kZXggMzUzNTAwNTdmYzIz
Li43OTBkOGZhZjhlMWUgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvc21iMnBkdS5jCisrKyBiL2ZzL2Np
ZnMvc21iMnBkdS5jCkBAIC00OSw2ICs0OSw3IEBACiAjaW5jbHVkZSAiY2lmc3BkdS5oIgogI2lu
Y2x1ZGUgImNpZnNfc3BuZWdvLmgiCiAjaW5jbHVkZSAic21iZGlyZWN0LmgiCisjaW5jbHVkZSAi
dHJhY2UuaCIKIAogLyoKICAqICBUaGUgZm9sbG93aW5nIHRhYmxlIGRlZmluZXMgdGhlIGV4cGVj
dGVkICJTdHJ1Y3R1cmVTaXplIiBvZiBTTUIyIHJlcXVlc3RzCkBAIC0zMDU4LDYgKzMwNTksOCBA
QCBzbWIyX2FzeW5jX3dyaXRldihzdHJ1Y3QgY2lmc193cml0ZWRhdGEgKndkYXRhLAogCQkJICAg
ICB3ZGF0YSwgZmxhZ3MpOwogCiAJaWYgKHJjKSB7CisJCXRyYWNlX3NtYjNfd3JpdGVfZXJyKHJj
LCAwIC8qIG5vIHhpZCAqLywgcmVxLT5QZXJzaXN0ZW50RmlsZUlkLAorCQkJCSAgICAgdGNvbi0+
dGlkLCB3ZGF0YS0+b2Zmc2V0LCB3ZGF0YS0+Ynl0ZXMpOwogCQlrcmVmX3B1dCgmd2RhdGEtPnJl
ZmNvdW50LCByZWxlYXNlKTsKIAkJY2lmc19zdGF0c19mYWlsX2luYyh0Y29uLCBTTUIyX1dSSVRF
X0hFKTsKIAl9CkBAIC0zMTI0LDYgKzMxMjcsOSBAQCBTTUIyX3dyaXRlKGNvbnN0IHVuc2lnbmVk
IGludCB4aWQsIHN0cnVjdCBjaWZzX2lvX3Bhcm1zICppb19wYXJtcywKIAlyc3AgPSAoc3RydWN0
IHNtYjJfd3JpdGVfcnNwICopcnNwX2lvdi5pb3ZfYmFzZTsKIAogCWlmIChyYykgeworCQl0cmFj
ZV9zbWIzX3dyaXRlX2VycihyYywgeGlkLCByZXEtPlBlcnNpc3RlbnRGaWxlSWQsCisJCQkJICAg
ICBpb19wYXJtcy0+dGNvbi0+dGlkLCBpb19wYXJtcy0+b2Zmc2V0LAorCQkJCSAgICAgaW9fcGFy
bXMtPmxlbmd0aCk7CiAJCWNpZnNfc3RhdHNfZmFpbF9pbmMoaW9fcGFybXMtPnRjb24sIFNNQjJf
V1JJVEVfSEUpOwogCQljaWZzX2RiZyhWRlMsICJTZW5kIGVycm9yIGluIHdyaXRlID0gJWRcbiIs
IHJjKTsKIAl9IGVsc2UKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvdHJhY2UuYyBiL2ZzL2NpZnMvdHJh
Y2UuYwpuZXcgZmlsZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwMDAwMDAuLmJkNGE1NDZmZWVj
MQotLS0gL2Rldi9udWxsCisrKyBiL2ZzL2NpZnMvdHJhY2UuYwpAQCAtMCwwICsxLDE4IEBACisv
LyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMAorLyoKKyAqICAgQ29weXJpZ2h0IChD
KSAyMDE4LCBNaWNyb3NvZnQgQ29ycG9yYXRpb24uCisgKgorICogICBBdXRob3Iocyk6IFN0ZXZl
IEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4KKyAqCisgKiAgIFRoaXMgcHJvZ3JhbSBp
cyBmcmVlIHNvZnR3YXJlOyAgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yIG1vZGlmeQor
ICogICBpdCB1bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNl
IGFzIHB1Ymxpc2hlZCBieQorICogICB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uOyBlaXRo
ZXIgdmVyc2lvbiAyIG9mIHRoZSBMaWNlbnNlLCBvcgorICogICAoYXQgeW91ciBvcHRpb24pIGFu
eSBsYXRlciB2ZXJzaW9uLgorICoKKyAqICAgVGhpcyBwcm9ncmFtIGlzIGRpc3RyaWJ1dGVkIGlu
IHRoZSBob3BlIHRoYXQgaXQgd2lsbCBiZSB1c2VmdWwsCisgKiAgIGJ1dCBXSVRIT1VUIEFOWSBX
QVJSQU5UWTsgIHdpdGhvdXQgZXZlbiB0aGUgaW1wbGllZCB3YXJyYW50eSBvZgorICogICBNRVJD
SEFOVEFCSUxJVFkgb3IgRklUTkVTUyBGT1IgQSBQQVJUSUNVTEFSIFBVUlBPU0UuICBTZWUKKyAq
ICAgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGZvciBtb3JlIGRldGFpbHMuCisgKi8K
KyNkZWZpbmUgQ1JFQVRFX1RSQUNFX1BPSU5UUworI2luY2x1ZGUgInRyYWNlLmgiCmRpZmYgLS1n
aXQgYS9mcy9jaWZzL3RyYWNlLmggYi9mcy9jaWZzL3RyYWNlLmgKbmV3IGZpbGUgbW9kZSAxMDA2
NDQKaW5kZXggMDAwMDAwMDAwMDAwLi4xZTdiMzhlMmZhMTUKLS0tIC9kZXYvbnVsbAorKysgYi9m
cy9jaWZzL3RyYWNlLmgKQEAgLTAsMCArMSw3MSBAQAorLyogU1BEWC1MaWNlbnNlLUlkZW50aWZp
ZXI6IEdQTC0yLjAgKi8KKy8qCisgKiAgIENvcHlyaWdodCAoQykgMjAxOCwgTWljcm9zb2Z0IENv
cnBvcmF0aW9uLgorICoKKyAqICAgQXV0aG9yKHMpOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1p
Y3Jvc29mdC5jb20+CisgKgorICogICBUaGlzIHByb2dyYW0gaXMgZnJlZSBzb2Z0d2FyZTsgIHlv
dSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vciBtb2RpZnkKKyAqICAgaXQgdW5kZXIgdGhlIHRl
cm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBhcyBwdWJsaXNoZWQgYnkKKyAq
ICAgdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbjsgZWl0aGVyIHZlcnNpb24gMiBvZiB0aGUg
TGljZW5zZSwgb3IKKyAqICAgKGF0IHlvdXIgb3B0aW9uKSBhbnkgbGF0ZXIgdmVyc2lvbi4KKyAq
CisgKiAgIFRoaXMgcHJvZ3JhbSBpcyBkaXN0cmlidXRlZCBpbiB0aGUgaG9wZSB0aGF0IGl0IHdp
bGwgYmUgdXNlZnVsLAorICogICBidXQgV0lUSE9VVCBBTlkgV0FSUkFOVFk7ICB3aXRob3V0IGV2
ZW4gdGhlIGltcGxpZWQgd2FycmFudHkgb2YKKyAqICAgTUVSQ0hBTlRBQklMSVRZIG9yIEZJVE5F
U1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQT1NFLiAgU2VlCisgKiAgIHRoZSBHTlUgR2VuZXJhbCBQ
dWJsaWMgTGljZW5zZSBmb3IgbW9yZSBkZXRhaWxzLgorICovCisjdW5kZWYgVFJBQ0VfU1lTVEVN
CisjZGVmaW5lIFRSQUNFX1NZU1RFTSBjaWZzCisKKyNpZiAhZGVmaW5lZChfQ0lGU19UUkFDRV9I
KSB8fCBkZWZpbmVkKFRSQUNFX0hFQURFUl9NVUxUSV9SRUFEKQorI2RlZmluZSBfQ0lGU19UUkFD
RV9ICisKKyNpbmNsdWRlIDxsaW51eC90cmFjZXBvaW50Lmg+CisKK0RFQ0xBUkVfRVZFTlRfQ0xB
U1Moc21iM19lcnJfY2xhc3MsCisJVFBfUFJPVE8odW5zaWduZWQgaW50IHhpZCwKKwkJX191NjQJ
ZmlkLAorCQlfX3UzMgl0aWQsCisJCV9fdTY0CW9mZnNldCwKKwkJX191MzIJbGVuLAorCQlpbnQJ
cmMpLAorCVRQX0FSR1MoeGlkLCBmaWQsIHRpZCwgb2Zmc2V0LCBsZW4sIHJjKSwKKwlUUF9TVFJV
Q1RfX2VudHJ5KAorCQlfX2ZpZWxkKHVuc2lnbmVkIGludCwgeGlkKQorCQlfX2ZpZWxkKF9fdTY0
LCBmaWQpCisJCV9fZmllbGQoX191MzIsIHRpZCkKKwkJX19maWVsZChfX3U2NCwgb2Zmc2V0KQor
CQlfX2ZpZWxkKF9fdTMyLCBsZW4pCisJCV9fZmllbGQoaW50LCByYykKKwkpLAorCVRQX2Zhc3Rf
YXNzaWduKAorCQlfX2VudHJ5LT54aWQgPSB4aWQ7CisJCV9fZW50cnktPmZpZCA9IGZpZDsKKwkJ
X19lbnRyeS0+dGlkID0gdGlkOworCQlfX2VudHJ5LT5vZmZzZXQgPSBvZmZzZXQ7CisJCV9fZW50
cnktPmxlbiA9IGxlbjsKKwkJX19lbnRyeS0+cmMgPSByYzsKKwkpLAorCVRQX3ByaW50aygieGlk
PSV1IGZpZD0lbGx1IHRpZD0ldSBvZmZzZXQ9JWxsdSBsZW49JXUgcmM9JWQiLAorCQlfX2VudHJ5
LT54aWQsIF9fZW50cnktPmZpZCwgX19lbnRyeS0+dGlkLCBfX2VudHJ5LT5vZmZzZXQsCisJCV9f
ZW50cnktPmxlbiwgX19lbnRyeS0+cmMpCispCisKKyNkZWZpbmUgREVGSU5FX1NNQjNfRVJSX0VW
RU5UKG5hbWUpICAgICAgICAgICAgIFwKK0RFRklORV9FVkVOVChzbWIzX2Vycl9jbGFzcywgc21i
M18jI25hbWUsICAgICAgIFwKKwlUUF9QUk9UTyh1bnNpZ25lZCBpbnQgeGlkLAkJXAorCQlfX3U2
NAlmaWQsCQkJXAorCQlfX3UzMgl0aWQsCQkJXAorCQlfX3U2NAlvZmZzZXQsCQkJXAorCQlfX3Uz
MglsZW4sCQkJXAorCQlpbnQJcmMpLAkJCVwKKwlUUF9BUkdTKHhpZCwgZmlkLCB0aWQsIG9mZnNl
dCwgbGVuLCByYykpCisKK0RFRklORV9TTUIzX0VSUl9FVkVOVCh3cml0ZV9lcnIpOworCisjZW5k
aWYgLyogX0NJRlNfVFJBQ0VfSCAqLworCisjdW5kZWYgVFJBQ0VfSU5DTFVERV9QQVRICisjZGVm
aW5lIFRSQUNFX0lOQ0xVREVfUEFUSCAuCisjZGVmaW5lIFRSQUNFX0lOQ0xVREVfRklMRSB0cmFj
ZQorI2luY2x1ZGUgPHRyYWNlL2RlZmluZV90cmFjZS5oPgotLSAKMi4xNy4wCgo=
--000000000000e07e85056c5a6eab--
