From: Steve French <smfrench@gmail.com>
Subject: [PATCHv2][SMB3] Add kernel trace support
Date: Thu, 17 May 2018 21:36:36 -0500
Message-ID: <CAH2r5muobq1gDbGcPE1AYeeKmdFx681=mpCyAZWfSPUa5wLjSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="00000000000060bdea056c71d34a"
To: CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

--00000000000060bdea056c71d34a
Content-Type: text/plain; charset="UTF-8"

Patch updated with additional tracepoint locations and some formatting
improvements. There are some obvious additional tracepoints that could
be added, but this should be a reasonable group to start with.

>From edc02d6f9dc24963d510c7ef59067428d3b082d3 Mon Sep 17 00:00:00 2001
From: Steve French <stfrench@microsoft.com>
Date: Thu, 17 May 2018 21:16:55 -0500
Subject: [PATCH] smb3: Add ftrace tracepoints for improved SMB3 debugging

Although dmesg logs and wireshark network traces can be
helpful, being able to dynamically enable/disable tracepoints
(in this case via the kernel ftrace mechanism) can also be
helpful in more quickly debugging problems, and more
selectively tracing the events related to the bug report.

This patch adds 12 ftrace tracepoints to cifs.ko for SMB3 events
in some obvious locations.  Subsequent patches will add more
as needed.

Example use:
   trace-cmd record -e cifs
   <run test case>
   trace-cmd show

Various trace events can be filtered. See:
       trace-cmd list | grep cifs
for the current list of cifs tracepoints.

Sample output (from mount and writing to a file):

root@smf:/sys/kernel/debug/tracing/events/cifs# trace-cmd show
<snip>
      mount.cifs-6633  [006] ....  7246.936461: smb3_cmd_done:
pid=6633 tid=0x0 sid=0x0 cmd=0 mid=0
      mount.cifs-6633  [006] ....  7246.936701: smb3_cmd_err:
pid=6633 tid=0x0 sid=0x3d9cf8e5 cmd=1 mid=1 status=0xc0000016 rc=-5
      mount.cifs-6633  [006] ....  7246.943055: smb3_cmd_done:
pid=6633 tid=0x0 sid=0x3d9cf8e5 cmd=1 mid=2
      mount.cifs-6633  [006] ....  7246.943298: smb3_cmd_done:
pid=6633 tid=0xf9447636 sid=0x3d9cf8e5 cmd=3 mid=3
      mount.cifs-6633  [006] ....  7246.943446: smb3_cmd_done:
pid=6633 tid=0xf9447636 sid=0x3d9cf8e5 cmd=11 mid=4
      mount.cifs-6633  [006] ....  7246.943659: smb3_cmd_done:
pid=6633 tid=0xe1b781a sid=0x3d9cf8e5 cmd=3 mid=5
      mount.cifs-6633  [006] ....  7246.943766: smb3_cmd_done:
pid=6633 tid=0xe1b781a sid=0x3d9cf8e5 cmd=11 mid=6
      mount.cifs-6633  [006] ....  7246.943937: smb3_cmd_done:
pid=6633 tid=0xe1b781a sid=0x3d9cf8e5 cmd=5 mid=7
      mount.cifs-6633  [006] ....  7246.944020: smb3_cmd_done:
pid=6633 tid=0xe1b781a sid=0x3d9cf8e5 cmd=16 mid=8
      mount.cifs-6633  [006] ....  7246.944091: smb3_cmd_done:
pid=6633 tid=0xe1b781a sid=0x3d9cf8e5 cmd=16 mid=9
      mount.cifs-6633  [006] ....  7246.944163: smb3_cmd_done:
pid=6633 tid=0xe1b781a sid=0x3d9cf8e5 cmd=16 mid=10
      mount.cifs-6633  [006] ....  7246.944218: smb3_cmd_err:
pid=6633 tid=0xf9447636 sid=0x3d9cf8e5 cmd=11 mid=11 status=0xc0000225
rc=-2
      mount.cifs-6633  [006] ....  7246.944219: smb3_fsctl_err: xid=0
fid=0xffffffffffffffff tid=0xf9447636 sid=0x3d9cf8e5 class=0
type=393620 rc=-2
      mount.cifs-6633  [007] ....  7246.944353: smb3_cmd_done:
pid=6633 tid=0xe1b781a sid=0x3d9cf8e5 cmd=16 mid=12
            bash-2071  [000] ....  7256.903844: smb3_cmd_done:
pid=2071 tid=0xe1b781a sid=0x3d9cf8e5 cmd=5 mid=13
            bash-2071  [000] ....  7256.904172: smb3_cmd_done:
pid=2071 tid=0xe1b781a sid=0x3d9cf8e5 cmd=16 mid=14
            bash-2071  [000] ....  7256.904471: smb3_cmd_done:
pid=2071 tid=0xe1b781a sid=0x3d9cf8e5 cmd=17 mid=15
            bash-2071  [000] ....  7256.904950: smb3_cmd_done:
pid=2071 tid=0xe1b781a sid=0x3d9cf8e5 cmd=5 mid=16
            bash-2071  [000] ....  7256.905305: smb3_cmd_done:
pid=2071 tid=0xe1b781a sid=0x3d9cf8e5 cmd=17 mid=17
            bash-2071  [000] ....  7256.905688: smb3_cmd_done:
pid=2071 tid=0xe1b781a sid=0x3d9cf8e5 cmd=6 mid=18
            bash-2071  [000] ....  7256.905809: smb3_write_done: xid=0
fid=0xd628f511 tid=0xe1b781a sid=0x3d9cf8e5 offset=0x0 len=0x1b

Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/Makefile       |   7 +-
 fs/cifs/smb2maperror.c |  10 +-
 fs/cifs/smb2pdu.c      |  56 +++++++-
 fs/cifs/trace.c        |  18 +++
 fs/cifs/trace.h        | 298 +++++++++++++++++++++++++++++++++++++++++
 5 files changed, 379 insertions(+), 10 deletions(-)
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
diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index 3bfc9c990724..20185be4a93d 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -27,6 +27,7 @@
 #include "smb2proto.h"
 #include "smb2status.h"
 #include "smb2glob.h"
+#include "trace.h"

 struct status_to_posix_error {
     __le32 smb2_status;
@@ -2455,8 +2456,12 @@ map_smb2_to_linux_error(char *buf, bool log_err)
     int rc = -EIO;
     __le32 smb2err = shdr->Status;

-    if (smb2err == 0)
+    if (smb2err == 0) {
+        trace_smb3_cmd_done(le32_to_cpu(shdr->ProcessId), shdr->TreeId,
+            shdr->SessionId, le16_to_cpu(shdr->Command),
+            le64_to_cpu(shdr->MessageId));
         return 0;
+    }

     /* mask facility */
     if (log_err && (smb2err != STATUS_MORE_PROCESSING_REQUIRED) &&
@@ -2478,5 +2483,8 @@ map_smb2_to_linux_error(char *buf, bool log_err)
     cifs_dbg(FYI, "Mapping SMB2 status code 0x%08x to POSIX err %d\n",
          __le32_to_cpu(smb2err), rc);

+    trace_smb3_cmd_err(le32_to_cpu(shdr->ProcessId), shdr->TreeId,
+            shdr->SessionId, le16_to_cpu(shdr->Command),
+            le64_to_cpu(shdr->MessageId), le32_to_cpu(smb2err), rc);
     return rc;
 }
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 35350057fc23..47d53314fc7f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -49,6 +49,7 @@
 #include "cifspdu.h"
 #include "cifs_spnego.h"
 #include "smbdirect.h"
+#include "trace.h"

 /*
  *  The following table defines the expected "StructureSize" of SMB2 requests
@@ -2090,6 +2091,10 @@ SMB2_ioctl(const unsigned int xid, struct
cifs_tcon *tcon, u64 persistent_fid,
     cifs_small_buf_release(req);
     rsp = (struct smb2_ioctl_rsp *)rsp_iov.iov_base;

+    if (rc != 0)
+        trace_smb3_fsctl_err(xid, persistent_fid, tcon->tid,
+                ses->Suid, 0, opcode, rc);
+
     if ((rc != 0) && (rc != -EINVAL)) {
         cifs_stats_fail_inc(tcon, SMB2_IOCTL_HE);
         goto ioctl_exit;
@@ -2200,6 +2205,8 @@ SMB2_close_flags(const unsigned int xid, struct
cifs_tcon *tcon,

     if (rc != 0) {
         cifs_stats_fail_inc(tcon, SMB2_CLOSE_HE);
+        trace_smb3_close_err(xid, persistent_fid, tcon->tid, ses->Suid,
+                     rc);
         goto close_exit;
     }

@@ -2326,6 +2333,8 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,

     if (rc) {
         cifs_stats_fail_inc(tcon, SMB2_QUERY_INFO_HE);
+        trace_smb3_query_info_err(xid, persistent_fid, tcon->tid,
+                ses->Suid, info_class, (__u32)info_type, rc);
         goto qinf_exit;
     }

@@ -2556,8 +2565,11 @@ SMB2_flush(const unsigned int xid, struct
cifs_tcon *tcon, u64 persistent_fid,
     rc = smb2_send_recv(xid, ses, iov, 1, &resp_buftype, flags, &rsp_iov);
     cifs_small_buf_release(req);

-    if (rc != 0)
+    if (rc != 0) {
         cifs_stats_fail_inc(tcon, SMB2_FLUSH_HE);
+        trace_smb3_flush_err(xid, persistent_fid, tcon->tid, ses->Suid,
+                     rc);
+    }

     free_rsp_buf(resp_buftype, rsp_iov.iov_base);
     return rc;
@@ -2799,7 +2811,13 @@ smb2_async_readv(struct cifs_readdata *rdata)
     if (rc) {
         kref_put(&rdata->refcount, cifs_readdata_release);
         cifs_stats_fail_inc(io_parms.tcon, SMB2_READ_HE);
-    }
+        trace_smb3_read_err(rc, 0 /* xid */, io_parms.persistent_fid,
+                   io_parms.tcon->tid, io_parms.tcon->ses->Suid,
+                   io_parms.offset, io_parms.length);
+    } else
+        trace_smb3_read_done(0 /* xid */, io_parms.persistent_fid,
+                   io_parms.tcon->tid, io_parms.tcon->ses->Suid,
+                   io_parms.offset, io_parms.length);

     cifs_small_buf_release(buf);
     return rc;
@@ -2840,9 +2858,15 @@ SMB2_read(const unsigned int xid, struct
cifs_io_parms *io_parms,
             cifs_stats_fail_inc(io_parms->tcon, SMB2_READ_HE);
             cifs_dbg(VFS, "Send error in read = %d\n", rc);
         }
+        trace_smb3_read_err(rc, xid, req->PersistentFileId,
+                    io_parms->tcon->tid, ses->Suid,
+                    io_parms->offset, io_parms->length);
         free_rsp_buf(resp_buftype, rsp_iov.iov_base);
         return rc == -ENODATA ? 0 : rc;
-    }
+    } else
+        trace_smb3_read_done(xid, req->PersistentFileId,
+                    io_parms->tcon->tid, ses->Suid,
+                    io_parms->offset, io_parms->length);

     *nbytes = le32_to_cpu(rsp->DataLength);
     if ((*nbytes > CIFS_MAX_MSGSIZE) ||
@@ -3058,9 +3082,15 @@ smb2_async_writev(struct cifs_writedata *wdata,
                  wdata, flags);

     if (rc) {
+        trace_smb3_write_err(0 /* no xid */, req->PersistentFileId,
+                     tcon->tid, tcon->ses->Suid, wdata->offset,
+                     wdata->bytes, rc);
         kref_put(&wdata->refcount, release);
         cifs_stats_fail_inc(tcon, SMB2_WRITE_HE);
-    }
+    } else
+        trace_smb3_write_done(0 /* no xid */, req->PersistentFileId,
+                     tcon->tid, tcon->ses->Suid, wdata->offset,
+                     wdata->bytes);

 async_writev_out:
     cifs_small_buf_release(req);
@@ -3124,10 +3154,19 @@ SMB2_write(const unsigned int xid, struct
cifs_io_parms *io_parms,
     rsp = (struct smb2_write_rsp *)rsp_iov.iov_base;

     if (rc) {
+        trace_smb3_write_err(xid, req->PersistentFileId,
+                     io_parms->tcon->tid,
+                     io_parms->tcon->ses->Suid,
+                     io_parms->offset, io_parms->length, rc);
         cifs_stats_fail_inc(io_parms->tcon, SMB2_WRITE_HE);
         cifs_dbg(VFS, "Send error in write = %d\n", rc);
-    } else
+    } else {
         *nbytes = le32_to_cpu(rsp->DataLength);
+        trace_smb3_write_done(xid, req->PersistentFileId,
+                     io_parms->tcon->tid,
+                     io_parms->tcon->ses->Suid,
+                     io_parms->offset, *nbytes);
+    }

     free_rsp_buf(resp_buftype, rsp);
     return rc;
@@ -3374,8 +3413,11 @@ send_set_info(const unsigned int xid, struct
cifs_tcon *tcon,
     cifs_small_buf_release(req);
     rsp = (struct smb2_set_info_rsp *)rsp_iov.iov_base;

-    if (rc != 0)
+    if (rc != 0) {
         cifs_stats_fail_inc(tcon, SMB2_SET_INFO_HE);
+        trace_smb3_set_info_err(xid, persistent_fid, tcon->tid,
+                ses->Suid, info_class, (__u32)info_type, rc);
+    }

     free_rsp_buf(resp_buftype, rsp);
     kfree(iov);
@@ -3766,6 +3808,8 @@ smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
     if (rc) {
         cifs_dbg(FYI, "Send error in smb2_lockv = %d\n", rc);
         cifs_stats_fail_inc(tcon, SMB2_LOCK_HE);
+        trace_smb3_lock_err(xid, persist_fid, tcon->tid,
+                    tcon->ses->Suid, rc);
     }

     return rc;
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
index 000000000000..935a58979e1b
--- /dev/null
+++ b/fs/cifs/trace.h
@@ -0,0 +1,298 @@
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
+/* For logging errors in read or write */
+DECLARE_EVENT_CLASS(smb3_rw_err_class,
+    TP_PROTO(unsigned int xid,
+        __u64    fid,
+        __u32    tid,
+        __u64    sesid,
+        __u64    offset,
+        __u32    len,
+        int    rc),
+    TP_ARGS(xid, fid, tid, sesid, offset, len, rc),
+    TP_STRUCT__entry(
+        __field(unsigned int, xid)
+        __field(__u64, fid)
+        __field(__u32, tid)
+        __field(__u64, sesid)
+        __field(__u64, offset)
+        __field(__u32, len)
+        __field(int, rc)
+    ),
+    TP_fast_assign(
+        __entry->xid = xid;
+        __entry->fid = fid;
+        __entry->tid = tid;
+        __entry->sesid = sesid;
+        __entry->offset = offset;
+        __entry->len = len;
+        __entry->rc = rc;
+    ),
+    TP_printk("xid=%u fid=0x%llx tid=0x%x sid=0x%llx offset=0x%llx
len=0x%x rc=%d",
+        __entry->xid, __entry->fid, __entry->tid, __entry->sesid,
+        __entry->offset, __entry->len, __entry->rc)
+)
+
+#define DEFINE_SMB3_RW_ERR_EVENT(name)          \
+DEFINE_EVENT(smb3_rw_err_class, smb3_##name,    \
+    TP_PROTO(unsigned int xid,        \
+        __u64    fid,            \
+        __u32    tid,            \
+        __u64    sesid,            \
+        __u64    offset,            \
+        __u32    len,            \
+        int    rc),            \
+    TP_ARGS(xid, fid, tid, sesid, offset, len, rc))
+
+DEFINE_SMB3_RW_ERR_EVENT(write_err);
+DEFINE_SMB3_RW_ERR_EVENT(read_err);
+
+
+/* For logging successful read or write */
+DECLARE_EVENT_CLASS(smb3_rw_done_class,
+    TP_PROTO(unsigned int xid,
+        __u64    fid,
+        __u32    tid,
+        __u64    sesid,
+        __u64    offset,
+        __u32    len),
+    TP_ARGS(xid, fid, tid, sesid, offset, len),
+    TP_STRUCT__entry(
+        __field(unsigned int, xid)
+        __field(__u64, fid)
+        __field(__u32, tid)
+        __field(__u64, sesid)
+        __field(__u64, offset)
+        __field(__u32, len)
+    ),
+    TP_fast_assign(
+        __entry->xid = xid;
+        __entry->fid = fid;
+        __entry->tid = tid;
+        __entry->sesid = sesid;
+        __entry->offset = offset;
+        __entry->len = len;
+    ),
+    TP_printk("xid=%u fid=0x%llx tid=0x%x sid=0x%llx offset=0x%llx len=0x%x",
+        __entry->xid, __entry->fid, __entry->tid, __entry->sesid,
+        __entry->offset, __entry->len)
+)
+
+#define DEFINE_SMB3_RW_DONE_EVENT(name)         \
+DEFINE_EVENT(smb3_rw_done_class, smb3_##name,   \
+    TP_PROTO(unsigned int xid,        \
+        __u64    fid,            \
+        __u32    tid,            \
+        __u64    sesid,            \
+        __u64    offset,            \
+        __u32    len),            \
+    TP_ARGS(xid, fid, tid, sesid, offset, len))
+
+DEFINE_SMB3_RW_DONE_EVENT(write_done);
+DEFINE_SMB3_RW_DONE_EVENT(read_done);
+
+/*
+ * For handle based calls other than read and write, and get/set info
+ */
+DECLARE_EVENT_CLASS(smb3_fd_err_class,
+    TP_PROTO(unsigned int xid,
+        __u64    fid,
+        __u32    tid,
+        __u64    sesid,
+        int    rc),
+    TP_ARGS(xid, fid, tid, sesid, rc),
+    TP_STRUCT__entry(
+        __field(unsigned int, xid)
+        __field(__u64, fid)
+        __field(__u32, tid)
+        __field(__u64, sesid)
+        __field(int, rc)
+    ),
+    TP_fast_assign(
+        __entry->xid = xid;
+        __entry->fid = fid;
+        __entry->tid = tid;
+        __entry->sesid = sesid;
+        __entry->rc = rc;
+    ),
+    TP_printk("xid=%u fid=0x%llx tid=0x%x sid=0x%llx rc=%d",
+        __entry->xid, __entry->fid, __entry->tid, __entry->sesid,
+        __entry->rc)
+)
+
+#define DEFINE_SMB3_FD_ERR_EVENT(name)          \
+DEFINE_EVENT(smb3_fd_err_class, smb3_##name,    \
+    TP_PROTO(unsigned int xid,        \
+        __u64    fid,            \
+        __u32    tid,            \
+        __u64    sesid,            \
+        int    rc),            \
+    TP_ARGS(xid, fid, tid, sesid, rc))
+
+DEFINE_SMB3_FD_ERR_EVENT(flush_err);
+DEFINE_SMB3_FD_ERR_EVENT(lock_err);
+DEFINE_SMB3_FD_ERR_EVENT(close_err);
+
+/*
+ * For handle based query/set info calls
+ */
+DECLARE_EVENT_CLASS(smb3_inf_err_class,
+    TP_PROTO(unsigned int xid,
+        __u64    fid,
+        __u32    tid,
+        __u64    sesid,
+        __u8    infclass,
+        __u32    type,
+        int    rc),
+    TP_ARGS(xid, fid, tid, sesid, infclass, type, rc),
+    TP_STRUCT__entry(
+        __field(unsigned int, xid)
+        __field(__u64, fid)
+        __field(__u32, tid)
+        __field(__u64, sesid)
+        __field(__u8, infclass)
+        __field(__u32, type)
+        __field(int, rc)
+    ),
+    TP_fast_assign(
+        __entry->xid = xid;
+        __entry->fid = fid;
+        __entry->tid = tid;
+        __entry->sesid = sesid;
+        __entry->infclass = infclass;
+        __entry->type = type;
+        __entry->rc = rc;
+    ),
+    TP_printk("xid=%u fid=0x%llx tid=0x%x sid=0x%llx class=%u type=0x%x rc=%d",
+        __entry->xid, __entry->fid, __entry->tid, __entry->sesid,
+        __entry->infclass, __entry->type, __entry->rc)
+)
+
+#define DEFINE_SMB3_INF_ERR_EVENT(name)          \
+DEFINE_EVENT(smb3_inf_err_class, smb3_##name,    \
+    TP_PROTO(unsigned int xid,        \
+        __u64    fid,            \
+        __u32    tid,            \
+        __u64    sesid,            \
+        __u8    infclass,        \
+        __u32    type,            \
+        int    rc),            \
+    TP_ARGS(xid, fid, tid, sesid, infclass, type, rc))
+
+DEFINE_SMB3_INF_ERR_EVENT(query_info_err);
+DEFINE_SMB3_INF_ERR_EVENT(set_info_err);
+DEFINE_SMB3_INF_ERR_EVENT(fsctl_err);
+
+/*
+ * For logging SMB3 Status code and Command for responses which return errors
+ */
+DECLARE_EVENT_CLASS(smb3_cmd_err_class,
+    TP_PROTO(__u32    pid,
+        __u32    tid,
+        __u64    sesid,
+        __u16    cmd,
+        __u64    mid,
+        __u32    status,
+        int    rc),
+    TP_ARGS(pid, tid, sesid, cmd, mid, status, rc),
+    TP_STRUCT__entry(
+        __field(__u32, pid)
+        __field(__u32, tid)
+        __field(__u64, sesid)
+        __field(__u16, cmd)
+        __field(__u64, mid)
+        __field(__u32, status)
+        __field(int, rc)
+    ),
+    TP_fast_assign(
+        __entry->pid = pid;
+        __entry->tid = tid;
+        __entry->sesid = sesid;
+        __entry->cmd = cmd;
+        __entry->mid = mid;
+        __entry->status = status;
+        __entry->rc = rc;
+    ),
+    TP_printk(" pid=%u tid=0x%x sid=0x%llx cmd=%u mid=%llu status=0x%x rc=%d",
+        __entry->pid, __entry->tid, __entry->sesid,
+        __entry->cmd, __entry->mid, __entry->status, __entry->rc)
+)
+
+#define DEFINE_SMB3_CMD_ERR_EVENT(name)          \
+DEFINE_EVENT(smb3_cmd_err_class, smb3_##name,    \
+    TP_PROTO(unsigned int pid,        \
+        __u32    tid,            \
+        __u64    sesid,            \
+        __u16    cmd,            \
+        __u64    mid,            \
+        __u32    status,            \
+        int    rc),            \
+    TP_ARGS(pid, tid, sesid, cmd, mid, status, rc))
+
+DEFINE_SMB3_CMD_ERR_EVENT(cmd_err);
+
+DECLARE_EVENT_CLASS(smb3_cmd_done_class,
+    TP_PROTO(__u32    pid,
+        __u32    tid,
+        __u64    sesid,
+        __u16    cmd,
+        __u64    mid),
+    TP_ARGS(pid, tid, sesid, cmd, mid),
+    TP_STRUCT__entry(
+        __field(__u32, pid)
+        __field(__u32, tid)
+        __field(__u64, sesid)
+        __field(__u16, cmd)
+        __field(__u64, mid)
+    ),
+    TP_fast_assign(
+        __entry->pid = pid;
+        __entry->tid = tid;
+        __entry->sesid = sesid;
+        __entry->cmd = cmd;
+        __entry->mid = mid;
+    ),
+    TP_printk("pid=%u tid=0x%x sid=0x%llx cmd=%u mid=%llu",
+        __entry->pid, __entry->tid, __entry->sesid,
+        __entry->cmd, __entry->mid)
+)
+
+#define DEFINE_SMB3_CMD_DONE_EVENT(name)          \
+DEFINE_EVENT(smb3_cmd_done_class, smb3_##name,    \
+    TP_PROTO(unsigned int pid,        \
+        __u32    tid,            \
+        __u64    sesid,            \
+        __u16    cmd,            \
+        __u64    mid),            \
+    TP_ARGS(pid, tid, sesid, cmd, mid))
+
+DEFINE_SMB3_CMD_DONE_EVENT(cmd_done);
+
+#endif /* _CIFS_TRACE_H */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE trace
+#include <trace/define_trace.h>
-- 



-- 
Thanks,

Steve

--00000000000060bdea056c71d34a
Content-Type: text/x-patch; charset="US-ASCII";
	name="0001-smb3-Add-ftrace-tracepoints-for-improved-SMB3-debugg.patch"
Content-Disposition: attachment;
	filename="0001-smb3-Add-ftrace-tracepoints-for-improved-SMB3-debugg.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_jhbcp6bg0

RnJvbSBlZGMwMmQ2ZjlkYzI0OTYzZDUxMGM3ZWY1OTA2NzQyOGQzYjA4MmQzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFRodSwgMTcgTWF5IDIwMTggMjE6MTY6NTUgLTA1MDAKU3ViamVjdDogW1BBVENIXSBz
bWIzOiBBZGQgZnRyYWNlIHRyYWNlcG9pbnRzIGZvciBpbXByb3ZlZCBTTUIzIGRlYnVnZ2luZwoK
QWx0aG91Z2ggZG1lc2cgbG9ncyBhbmQgd2lyZXNoYXJrIG5ldHdvcmsgdHJhY2VzIGNhbiBiZQpo
ZWxwZnVsLCBiZWluZyBhYmxlIHRvIGR5bmFtaWNhbGx5IGVuYWJsZS9kaXNhYmxlIHRyYWNlcG9p
bnRzCihpbiB0aGlzIGNhc2UgdmlhIHRoZSBrZXJuZWwgZnRyYWNlIG1lY2hhbmlzbSkgY2FuIGFs
c28gYmUKaGVscGZ1bCBpbiBtb3JlIHF1aWNrbHkgZGVidWdnaW5nIHByb2JsZW1zLCBhbmQgbW9y
ZQpzZWxlY3RpdmVseSB0cmFjaW5nIHRoZSBldmVudHMgcmVsYXRlZCB0byB0aGUgYnVnIHJlcG9y
dC4KClRoaXMgcGF0Y2ggYWRkcyAxMiBmdHJhY2UgdHJhY2Vwb2ludHMgdG8gY2lmcy5rbyBmb3Ig
U01CMyBldmVudHMKaW4gc29tZSBvYnZpb3VzIGxvY2F0aW9ucy4gIFN1YnNlcXVlbnQgcGF0Y2hl
cyB3aWxsIGFkZCBtb3JlCmFzIG5lZWRlZC4KCkV4YW1wbGUgdXNlOgogICB0cmFjZS1jbWQgcmVj
b3JkIC1lIGNpZnMKICAgPHJ1biB0ZXN0IGNhc2U+CiAgIHRyYWNlLWNtZCBzaG93CgpWYXJpb3Vz
IHRyYWNlIGV2ZW50cyBjYW4gYmUgZmlsdGVyZWQuIFNlZToKICAgICAgIHRyYWNlLWNtZCBsaXN0
IHwgZ3JlcCBjaWZzCmZvciB0aGUgY3VycmVudCBsaXN0IG9mIGNpZnMgdHJhY2Vwb2ludHMuCgpT
YW1wbGUgb3V0cHV0IChmcm9tIG1vdW50IGFuZCB3cml0aW5nIHRvIGEgZmlsZSk6Cgpyb290QHNt
Zjovc3lzL2tlcm5lbC9kZWJ1Zy90cmFjaW5nL2V2ZW50cy9jaWZzIyB0cmFjZS1jbWQgc2hvdwo8
c25pcD4KICAgICAgbW91bnQuY2lmcy02NjMzICBbMDA2XSAuLi4uICA3MjQ2LjkzNjQ2MTogc21i
M19jbWRfZG9uZTogcGlkPTY2MzMgdGlkPTB4MCBzaWQ9MHgwIGNtZD0wIG1pZD0wCiAgICAgIG1v
dW50LmNpZnMtNjYzMyAgWzAwNl0gLi4uLiAgNzI0Ni45MzY3MDE6IHNtYjNfY21kX2VycjogIHBp
ZD02NjMzIHRpZD0weDAgc2lkPTB4M2Q5Y2Y4ZTUgY21kPTEgbWlkPTEgc3RhdHVzPTB4YzAwMDAw
MTYgcmM9LTUKICAgICAgbW91bnQuY2lmcy02NjMzICBbMDA2XSAuLi4uICA3MjQ2Ljk0MzA1NTog
c21iM19jbWRfZG9uZTogcGlkPTY2MzMgdGlkPTB4MCBzaWQ9MHgzZDljZjhlNSBjbWQ9MSBtaWQ9
MgogICAgICBtb3VudC5jaWZzLTY2MzMgIFswMDZdIC4uLi4gIDcyNDYuOTQzMjk4OiBzbWIzX2Nt
ZF9kb25lOiBwaWQ9NjYzMyB0aWQ9MHhmOTQ0NzYzNiBzaWQ9MHgzZDljZjhlNSBjbWQ9MyBtaWQ9
MwogICAgICBtb3VudC5jaWZzLTY2MzMgIFswMDZdIC4uLi4gIDcyNDYuOTQzNDQ2OiBzbWIzX2Nt
ZF9kb25lOiBwaWQ9NjYzMyB0aWQ9MHhmOTQ0NzYzNiBzaWQ9MHgzZDljZjhlNSBjbWQ9MTEgbWlk
PTQKICAgICAgbW91bnQuY2lmcy02NjMzICBbMDA2XSAuLi4uICA3MjQ2Ljk0MzY1OTogc21iM19j
bWRfZG9uZTogcGlkPTY2MzMgdGlkPTB4ZTFiNzgxYSBzaWQ9MHgzZDljZjhlNSBjbWQ9MyBtaWQ9
NQogICAgICBtb3VudC5jaWZzLTY2MzMgIFswMDZdIC4uLi4gIDcyNDYuOTQzNzY2OiBzbWIzX2Nt
ZF9kb25lOiBwaWQ9NjYzMyB0aWQ9MHhlMWI3ODFhIHNpZD0weDNkOWNmOGU1IGNtZD0xMSBtaWQ9
NgogICAgICBtb3VudC5jaWZzLTY2MzMgIFswMDZdIC4uLi4gIDcyNDYuOTQzOTM3OiBzbWIzX2Nt
ZF9kb25lOiBwaWQ9NjYzMyB0aWQ9MHhlMWI3ODFhIHNpZD0weDNkOWNmOGU1IGNtZD01IG1pZD03
CiAgICAgIG1vdW50LmNpZnMtNjYzMyAgWzAwNl0gLi4uLiAgNzI0Ni45NDQwMjA6IHNtYjNfY21k
X2RvbmU6IHBpZD02NjMzIHRpZD0weGUxYjc4MWEgc2lkPTB4M2Q5Y2Y4ZTUgY21kPTE2IG1pZD04
CiAgICAgIG1vdW50LmNpZnMtNjYzMyAgWzAwNl0gLi4uLiAgNzI0Ni45NDQwOTE6IHNtYjNfY21k
X2RvbmU6IHBpZD02NjMzIHRpZD0weGUxYjc4MWEgc2lkPTB4M2Q5Y2Y4ZTUgY21kPTE2IG1pZD05
CiAgICAgIG1vdW50LmNpZnMtNjYzMyAgWzAwNl0gLi4uLiAgNzI0Ni45NDQxNjM6IHNtYjNfY21k
X2RvbmU6IHBpZD02NjMzIHRpZD0weGUxYjc4MWEgc2lkPTB4M2Q5Y2Y4ZTUgY21kPTE2IG1pZD0x
MAogICAgICBtb3VudC5jaWZzLTY2MzMgIFswMDZdIC4uLi4gIDcyNDYuOTQ0MjE4OiBzbWIzX2Nt
ZF9lcnI6ICBwaWQ9NjYzMyB0aWQ9MHhmOTQ0NzYzNiBzaWQ9MHgzZDljZjhlNSBjbWQ9MTEgbWlk
PTExIHN0YXR1cz0weGMwMDAwMjI1IHJjPS0yCiAgICAgIG1vdW50LmNpZnMtNjYzMyAgWzAwNl0g
Li4uLiAgNzI0Ni45NDQyMTk6IHNtYjNfZnNjdGxfZXJyOiB4aWQ9MCBmaWQ9MHhmZmZmZmZmZmZm
ZmZmZmZmIHRpZD0weGY5NDQ3NjM2IHNpZD0weDNkOWNmOGU1IGNsYXNzPTAgdHlwZT0zOTM2MjAg
cmM9LTIKICAgICAgbW91bnQuY2lmcy02NjMzICBbMDA3XSAuLi4uICA3MjQ2Ljk0NDM1Mzogc21i
M19jbWRfZG9uZTogcGlkPTY2MzMgdGlkPTB4ZTFiNzgxYSBzaWQ9MHgzZDljZjhlNSBjbWQ9MTYg
bWlkPTEyCiAgICAgICAgICAgIGJhc2gtMjA3MSAgWzAwMF0gLi4uLiAgNzI1Ni45MDM4NDQ6IHNt
YjNfY21kX2RvbmU6IHBpZD0yMDcxIHRpZD0weGUxYjc4MWEgc2lkPTB4M2Q5Y2Y4ZTUgY21kPTUg
bWlkPTEzCiAgICAgICAgICAgIGJhc2gtMjA3MSAgWzAwMF0gLi4uLiAgNzI1Ni45MDQxNzI6IHNt
YjNfY21kX2RvbmU6IHBpZD0yMDcxIHRpZD0weGUxYjc4MWEgc2lkPTB4M2Q5Y2Y4ZTUgY21kPTE2
IG1pZD0xNAogICAgICAgICAgICBiYXNoLTIwNzEgIFswMDBdIC4uLi4gIDcyNTYuOTA0NDcxOiBz
bWIzX2NtZF9kb25lOiBwaWQ9MjA3MSB0aWQ9MHhlMWI3ODFhIHNpZD0weDNkOWNmOGU1IGNtZD0x
NyBtaWQ9MTUKICAgICAgICAgICAgYmFzaC0yMDcxICBbMDAwXSAuLi4uICA3MjU2LjkwNDk1MDog
c21iM19jbWRfZG9uZTogcGlkPTIwNzEgdGlkPTB4ZTFiNzgxYSBzaWQ9MHgzZDljZjhlNSBjbWQ9
NSBtaWQ9MTYKICAgICAgICAgICAgYmFzaC0yMDcxICBbMDAwXSAuLi4uICA3MjU2LjkwNTMwNTog
c21iM19jbWRfZG9uZTogcGlkPTIwNzEgdGlkPTB4ZTFiNzgxYSBzaWQ9MHgzZDljZjhlNSBjbWQ9
MTcgbWlkPTE3CiAgICAgICAgICAgIGJhc2gtMjA3MSAgWzAwMF0gLi4uLiAgNzI1Ni45MDU2ODg6
IHNtYjNfY21kX2RvbmU6IHBpZD0yMDcxIHRpZD0weGUxYjc4MWEgc2lkPTB4M2Q5Y2Y4ZTUgY21k
PTYgbWlkPTE4CiAgICAgICAgICAgIGJhc2gtMjA3MSAgWzAwMF0gLi4uLiAgNzI1Ni45MDU4MDk6
IHNtYjNfd3JpdGVfZG9uZTogeGlkPTAgZmlkPTB4ZDYyOGY1MTEgdGlkPTB4ZTFiNzgxYSBzaWQ9
MHgzZDljZjhlNSBvZmZzZXQ9MHgwIGxlbj0weDFiCgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVu
Y2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+Ci0tLQogZnMvY2lmcy9NYWtlZmlsZSAgICAgICB8
ICAgNyArLQogZnMvY2lmcy9zbWIybWFwZXJyb3IuYyB8ICAxMCArLQogZnMvY2lmcy9zbWIycGR1
LmMgICAgICB8ICA1NiArKysrKysrLQogZnMvY2lmcy90cmFjZS5jICAgICAgICB8ICAxOCArKysK
IGZzL2NpZnMvdHJhY2UuaCAgICAgICAgfCAyOTggKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysKIDUgZmlsZXMgY2hhbmdlZCwgMzc5IGluc2VydGlvbnMoKyksIDEwIGRl
bGV0aW9ucygtKQogY3JlYXRlIG1vZGUgMTAwNjQ0IGZzL2NpZnMvdHJhY2UuYwogY3JlYXRlIG1v
ZGUgMTAwNjQ0IGZzL2NpZnMvdHJhY2UuaAoKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvTWFrZWZpbGUg
Yi9mcy9jaWZzL01ha2VmaWxlCmluZGV4IDdlNGExZTJmMDY5Ni4uODU4MTc5OTFlZTY4IDEwMDY0
NAotLS0gYS9mcy9jaWZzL01ha2VmaWxlCisrKyBiL2ZzL2NpZnMvTWFrZWZpbGUKQEAgLTEsMTEg
KzEsMTIgQEAKICMgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAKICMKLSMgTWFrZWZp
bGUgZm9yIExpbnV4IENJRlMgVkZTIGNsaWVudCAKKyMgTWFrZWZpbGUgZm9yIExpbnV4IENJRlMv
U01CMi9TTUIzIFZGUyBjbGllbnQKICMKK2NjZmxhZ3MteSArPSAtSSQoc3JjKQkJIyBuZWVkZWQg
Zm9yIHRyYWNlIGV2ZW50cwogb2JqLSQoQ09ORklHX0NJRlMpICs9IGNpZnMubwogCi1jaWZzLXkg
Oj0gY2lmc2ZzLm8gY2lmc3NtYi5vIGNpZnNfZGVidWcubyBjb25uZWN0Lm8gZGlyLm8gZmlsZS5v
IGlub2RlLm8gXAotCSAgbGluay5vIG1pc2MubyBuZXRtaXNjLm8gc21iZW5jcnlwdC5vIHRyYW5z
cG9ydC5vIGFzbjEubyBcCitjaWZzLXkgOj0gdHJhY2UubyBjaWZzZnMubyBjaWZzc21iLm8gY2lm
c19kZWJ1Zy5vIGNvbm5lY3QubyBkaXIubyBmaWxlLm8gXAorCSAgaW5vZGUubyBsaW5rLm8gbWlz
Yy5vIG5ldG1pc2MubyBzbWJlbmNyeXB0Lm8gdHJhbnNwb3J0Lm8gYXNuMS5vIFwKIAkgIGNpZnNf
dW5pY29kZS5vIG50ZXJyLm8gY2lmc2VuY3J5cHQubyBcCiAJICByZWFkZGlyLm8gaW9jdGwubyBz
ZXNzLm8gZXhwb3J0Lm8gc21iMW9wcy5vIHdpbnVjYXNlLm8gXAogCSAgc21iMm9wcy5vIHNtYjJt
YXBlcnJvci5vIHNtYjJ0cmFuc3BvcnQubyBcCmRpZmYgLS1naXQgYS9mcy9jaWZzL3NtYjJtYXBl
cnJvci5jIGIvZnMvY2lmcy9zbWIybWFwZXJyb3IuYwppbmRleCAzYmZjOWM5OTA3MjQuLjIwMTg1
YmU0YTkzZCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIybWFwZXJyb3IuYworKysgYi9mcy9jaWZz
L3NtYjJtYXBlcnJvci5jCkBAIC0yNyw2ICsyNyw3IEBACiAjaW5jbHVkZSAic21iMnByb3RvLmgi
CiAjaW5jbHVkZSAic21iMnN0YXR1cy5oIgogI2luY2x1ZGUgInNtYjJnbG9iLmgiCisjaW5jbHVk
ZSAidHJhY2UuaCIKIAogc3RydWN0IHN0YXR1c190b19wb3NpeF9lcnJvciB7CiAJX19sZTMyIHNt
YjJfc3RhdHVzOwpAQCAtMjQ1NSw4ICsyNDU2LDEyIEBAIG1hcF9zbWIyX3RvX2xpbnV4X2Vycm9y
KGNoYXIgKmJ1ZiwgYm9vbCBsb2dfZXJyKQogCWludCByYyA9IC1FSU87CiAJX19sZTMyIHNtYjJl
cnIgPSBzaGRyLT5TdGF0dXM7CiAKLQlpZiAoc21iMmVyciA9PSAwKQorCWlmIChzbWIyZXJyID09
IDApIHsKKwkJdHJhY2Vfc21iM19jbWRfZG9uZShsZTMyX3RvX2NwdShzaGRyLT5Qcm9jZXNzSWQp
LCBzaGRyLT5UcmVlSWQsCisJCQlzaGRyLT5TZXNzaW9uSWQsIGxlMTZfdG9fY3B1KHNoZHItPkNv
bW1hbmQpLAorCQkJbGU2NF90b19jcHUoc2hkci0+TWVzc2FnZUlkKSk7CiAJCXJldHVybiAwOwor
CX0KIAogCS8qIG1hc2sgZmFjaWxpdHkgKi8KIAlpZiAobG9nX2VyciAmJiAoc21iMmVyciAhPSBT
VEFUVVNfTU9SRV9QUk9DRVNTSU5HX1JFUVVJUkVEKSAmJgpAQCAtMjQ3OCw1ICsyNDgzLDggQEAg
bWFwX3NtYjJfdG9fbGludXhfZXJyb3IoY2hhciAqYnVmLCBib29sIGxvZ19lcnIpCiAJY2lmc19k
YmcoRllJLCAiTWFwcGluZyBTTUIyIHN0YXR1cyBjb2RlIDB4JTA4eCB0byBQT1NJWCBlcnIgJWRc
biIsCiAJCSBfX2xlMzJfdG9fY3B1KHNtYjJlcnIpLCByYyk7CiAKKwl0cmFjZV9zbWIzX2NtZF9l
cnIobGUzMl90b19jcHUoc2hkci0+UHJvY2Vzc0lkKSwgc2hkci0+VHJlZUlkLAorCQkJc2hkci0+
U2Vzc2lvbklkLCBsZTE2X3RvX2NwdShzaGRyLT5Db21tYW5kKSwKKwkJCWxlNjRfdG9fY3B1KHNo
ZHItPk1lc3NhZ2VJZCksIGxlMzJfdG9fY3B1KHNtYjJlcnIpLCByYyk7CiAJcmV0dXJuIHJjOwog
fQpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWIycGR1LmMgYi9mcy9jaWZzL3NtYjJwZHUuYwppbmRl
eCAzNTM1MDA1N2ZjMjMuLjQ3ZDUzMzE0ZmM3ZiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycGR1
LmMKKysrIGIvZnMvY2lmcy9zbWIycGR1LmMKQEAgLTQ5LDYgKzQ5LDcgQEAKICNpbmNsdWRlICJj
aWZzcGR1LmgiCiAjaW5jbHVkZSAiY2lmc19zcG5lZ28uaCIKICNpbmNsdWRlICJzbWJkaXJlY3Qu
aCIKKyNpbmNsdWRlICJ0cmFjZS5oIgogCiAvKgogICogIFRoZSBmb2xsb3dpbmcgdGFibGUgZGVm
aW5lcyB0aGUgZXhwZWN0ZWQgIlN0cnVjdHVyZVNpemUiIG9mIFNNQjIgcmVxdWVzdHMKQEAgLTIw
OTAsNiArMjA5MSwxMCBAQCBTTUIyX2lvY3RsKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVj
dCBjaWZzX3Rjb24gKnRjb24sIHU2NCBwZXJzaXN0ZW50X2ZpZCwKIAljaWZzX3NtYWxsX2J1Zl9y
ZWxlYXNlKHJlcSk7CiAJcnNwID0gKHN0cnVjdCBzbWIyX2lvY3RsX3JzcCAqKXJzcF9pb3YuaW92
X2Jhc2U7CiAKKwlpZiAocmMgIT0gMCkKKwkJdHJhY2Vfc21iM19mc2N0bF9lcnIoeGlkLCBwZXJz
aXN0ZW50X2ZpZCwgdGNvbi0+dGlkLAorCQkJCXNlcy0+U3VpZCwgMCwgb3Bjb2RlLCByYyk7CisK
IAlpZiAoKHJjICE9IDApICYmIChyYyAhPSAtRUlOVkFMKSkgewogCQljaWZzX3N0YXRzX2ZhaWxf
aW5jKHRjb24sIFNNQjJfSU9DVExfSEUpOwogCQlnb3RvIGlvY3RsX2V4aXQ7CkBAIC0yMjAwLDYg
KzIyMDUsOCBAQCBTTUIyX2Nsb3NlX2ZsYWdzKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVj
dCBjaWZzX3Rjb24gKnRjb24sCiAKIAlpZiAocmMgIT0gMCkgewogCQljaWZzX3N0YXRzX2ZhaWxf
aW5jKHRjb24sIFNNQjJfQ0xPU0VfSEUpOworCQl0cmFjZV9zbWIzX2Nsb3NlX2Vycih4aWQsIHBl
cnNpc3RlbnRfZmlkLCB0Y29uLT50aWQsIHNlcy0+U3VpZCwKKwkJCQkgICAgIHJjKTsKIAkJZ290
byBjbG9zZV9leGl0OwogCX0KIApAQCAtMjMyNiw2ICsyMzMzLDggQEAgcXVlcnlfaW5mbyhjb25z
dCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uLAogCiAJaWYgKHJjKSB7
CiAJCWNpZnNfc3RhdHNfZmFpbF9pbmModGNvbiwgU01CMl9RVUVSWV9JTkZPX0hFKTsKKwkJdHJh
Y2Vfc21iM19xdWVyeV9pbmZvX2Vycih4aWQsIHBlcnNpc3RlbnRfZmlkLCB0Y29uLT50aWQsCisJ
CQkJc2VzLT5TdWlkLCBpbmZvX2NsYXNzLCAoX191MzIpaW5mb190eXBlLCByYyk7CiAJCWdvdG8g
cWluZl9leGl0OwogCX0KIApAQCAtMjU1Niw4ICsyNTY1LDExIEBAIFNNQjJfZmx1c2goY29uc3Qg
dW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwgdTY0IHBlcnNpc3RlbnRf
ZmlkLAogCXJjID0gc21iMl9zZW5kX3JlY3YoeGlkLCBzZXMsIGlvdiwgMSwgJnJlc3BfYnVmdHlw
ZSwgZmxhZ3MsICZyc3BfaW92KTsKIAljaWZzX3NtYWxsX2J1Zl9yZWxlYXNlKHJlcSk7CiAKLQlp
ZiAocmMgIT0gMCkKKwlpZiAocmMgIT0gMCkgewogCQljaWZzX3N0YXRzX2ZhaWxfaW5jKHRjb24s
IFNNQjJfRkxVU0hfSEUpOworCQl0cmFjZV9zbWIzX2ZsdXNoX2Vycih4aWQsIHBlcnNpc3RlbnRf
ZmlkLCB0Y29uLT50aWQsIHNlcy0+U3VpZCwKKwkJCQkgICAgIHJjKTsKKwl9CiAKIAlmcmVlX3Jz
cF9idWYocmVzcF9idWZ0eXBlLCByc3BfaW92Lmlvdl9iYXNlKTsKIAlyZXR1cm4gcmM7CkBAIC0y
Nzk5LDcgKzI4MTEsMTMgQEAgc21iMl9hc3luY19yZWFkdihzdHJ1Y3QgY2lmc19yZWFkZGF0YSAq
cmRhdGEpCiAJaWYgKHJjKSB7CiAJCWtyZWZfcHV0KCZyZGF0YS0+cmVmY291bnQsIGNpZnNfcmVh
ZGRhdGFfcmVsZWFzZSk7CiAJCWNpZnNfc3RhdHNfZmFpbF9pbmMoaW9fcGFybXMudGNvbiwgU01C
Ml9SRUFEX0hFKTsKLQl9CisJCXRyYWNlX3NtYjNfcmVhZF9lcnIocmMsIDAgLyogeGlkICovLCBp
b19wYXJtcy5wZXJzaXN0ZW50X2ZpZCwKKwkJCQkgICBpb19wYXJtcy50Y29uLT50aWQsIGlvX3Bh
cm1zLnRjb24tPnNlcy0+U3VpZCwKKwkJCQkgICBpb19wYXJtcy5vZmZzZXQsIGlvX3Bhcm1zLmxl
bmd0aCk7CisJfSBlbHNlCisJCXRyYWNlX3NtYjNfcmVhZF9kb25lKDAgLyogeGlkICovLCBpb19w
YXJtcy5wZXJzaXN0ZW50X2ZpZCwKKwkJCQkgICBpb19wYXJtcy50Y29uLT50aWQsIGlvX3Bhcm1z
LnRjb24tPnNlcy0+U3VpZCwKKwkJCQkgICBpb19wYXJtcy5vZmZzZXQsIGlvX3Bhcm1zLmxlbmd0
aCk7CiAKIAljaWZzX3NtYWxsX2J1Zl9yZWxlYXNlKGJ1Zik7CiAJcmV0dXJuIHJjOwpAQCAtMjg0
MCw5ICsyODU4LDE1IEBAIFNNQjJfcmVhZChjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3Qg
Y2lmc19pb19wYXJtcyAqaW9fcGFybXMsCiAJCQljaWZzX3N0YXRzX2ZhaWxfaW5jKGlvX3Bhcm1z
LT50Y29uLCBTTUIyX1JFQURfSEUpOwogCQkJY2lmc19kYmcoVkZTLCAiU2VuZCBlcnJvciBpbiBy
ZWFkID0gJWRcbiIsIHJjKTsKIAkJfQorCQl0cmFjZV9zbWIzX3JlYWRfZXJyKHJjLCB4aWQsIHJl
cS0+UGVyc2lzdGVudEZpbGVJZCwKKwkJCQkgICAgaW9fcGFybXMtPnRjb24tPnRpZCwgc2VzLT5T
dWlkLAorCQkJCSAgICBpb19wYXJtcy0+b2Zmc2V0LCBpb19wYXJtcy0+bGVuZ3RoKTsKIAkJZnJl
ZV9yc3BfYnVmKHJlc3BfYnVmdHlwZSwgcnNwX2lvdi5pb3ZfYmFzZSk7CiAJCXJldHVybiByYyA9
PSAtRU5PREFUQSA/IDAgOiByYzsKLQl9CisJfSBlbHNlCisJCXRyYWNlX3NtYjNfcmVhZF9kb25l
KHhpZCwgcmVxLT5QZXJzaXN0ZW50RmlsZUlkLAorCQkJCSAgICBpb19wYXJtcy0+dGNvbi0+dGlk
LCBzZXMtPlN1aWQsCisJCQkJICAgIGlvX3Bhcm1zLT5vZmZzZXQsIGlvX3Bhcm1zLT5sZW5ndGgp
OwogCiAJKm5ieXRlcyA9IGxlMzJfdG9fY3B1KHJzcC0+RGF0YUxlbmd0aCk7CiAJaWYgKCgqbmJ5
dGVzID4gQ0lGU19NQVhfTVNHU0laRSkgfHwKQEAgLTMwNTgsOSArMzA4MiwxNSBAQCBzbWIyX2Fz
eW5jX3dyaXRldihzdHJ1Y3QgY2lmc193cml0ZWRhdGEgKndkYXRhLAogCQkJICAgICB3ZGF0YSwg
ZmxhZ3MpOwogCiAJaWYgKHJjKSB7CisJCXRyYWNlX3NtYjNfd3JpdGVfZXJyKDAgLyogbm8geGlk
ICovLCByZXEtPlBlcnNpc3RlbnRGaWxlSWQsCisJCQkJICAgICB0Y29uLT50aWQsIHRjb24tPnNl
cy0+U3VpZCwgd2RhdGEtPm9mZnNldCwKKwkJCQkgICAgIHdkYXRhLT5ieXRlcywgcmMpOwogCQlr
cmVmX3B1dCgmd2RhdGEtPnJlZmNvdW50LCByZWxlYXNlKTsKIAkJY2lmc19zdGF0c19mYWlsX2lu
Yyh0Y29uLCBTTUIyX1dSSVRFX0hFKTsKLQl9CisJfSBlbHNlCisJCXRyYWNlX3NtYjNfd3JpdGVf
ZG9uZSgwIC8qIG5vIHhpZCAqLywgcmVxLT5QZXJzaXN0ZW50RmlsZUlkLAorCQkJCSAgICAgdGNv
bi0+dGlkLCB0Y29uLT5zZXMtPlN1aWQsIHdkYXRhLT5vZmZzZXQsCisJCQkJICAgICB3ZGF0YS0+
Ynl0ZXMpOwogCiBhc3luY193cml0ZXZfb3V0OgogCWNpZnNfc21hbGxfYnVmX3JlbGVhc2UocmVx
KTsKQEAgLTMxMjQsMTAgKzMxNTQsMTkgQEAgU01CMl93cml0ZShjb25zdCB1bnNpZ25lZCBpbnQg
eGlkLCBzdHJ1Y3QgY2lmc19pb19wYXJtcyAqaW9fcGFybXMsCiAJcnNwID0gKHN0cnVjdCBzbWIy
X3dyaXRlX3JzcCAqKXJzcF9pb3YuaW92X2Jhc2U7CiAKIAlpZiAocmMpIHsKKwkJdHJhY2Vfc21i
M193cml0ZV9lcnIoeGlkLCByZXEtPlBlcnNpc3RlbnRGaWxlSWQsCisJCQkJICAgICBpb19wYXJt
cy0+dGNvbi0+dGlkLAorCQkJCSAgICAgaW9fcGFybXMtPnRjb24tPnNlcy0+U3VpZCwKKwkJCQkg
ICAgIGlvX3Bhcm1zLT5vZmZzZXQsIGlvX3Bhcm1zLT5sZW5ndGgsIHJjKTsKIAkJY2lmc19zdGF0
c19mYWlsX2luYyhpb19wYXJtcy0+dGNvbiwgU01CMl9XUklURV9IRSk7CiAJCWNpZnNfZGJnKFZG
UywgIlNlbmQgZXJyb3IgaW4gd3JpdGUgPSAlZFxuIiwgcmMpOwotCX0gZWxzZQorCX0gZWxzZSB7
CiAJCSpuYnl0ZXMgPSBsZTMyX3RvX2NwdShyc3AtPkRhdGFMZW5ndGgpOworCQl0cmFjZV9zbWIz
X3dyaXRlX2RvbmUoeGlkLCByZXEtPlBlcnNpc3RlbnRGaWxlSWQsCisJCQkJICAgICBpb19wYXJt
cy0+dGNvbi0+dGlkLAorCQkJCSAgICAgaW9fcGFybXMtPnRjb24tPnNlcy0+U3VpZCwKKwkJCQkg
ICAgIGlvX3Bhcm1zLT5vZmZzZXQsICpuYnl0ZXMpOworCX0KIAogCWZyZWVfcnNwX2J1ZihyZXNw
X2J1ZnR5cGUsIHJzcCk7CiAJcmV0dXJuIHJjOwpAQCAtMzM3NCw4ICszNDEzLDExIEBAIHNlbmRf
c2V0X2luZm8oY29uc3QgdW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwK
IAljaWZzX3NtYWxsX2J1Zl9yZWxlYXNlKHJlcSk7CiAJcnNwID0gKHN0cnVjdCBzbWIyX3NldF9p
bmZvX3JzcCAqKXJzcF9pb3YuaW92X2Jhc2U7CiAKLQlpZiAocmMgIT0gMCkKKwlpZiAocmMgIT0g
MCkgewogCQljaWZzX3N0YXRzX2ZhaWxfaW5jKHRjb24sIFNNQjJfU0VUX0lORk9fSEUpOworCQl0
cmFjZV9zbWIzX3NldF9pbmZvX2Vycih4aWQsIHBlcnNpc3RlbnRfZmlkLCB0Y29uLT50aWQsCisJ
CQkJc2VzLT5TdWlkLCBpbmZvX2NsYXNzLCAoX191MzIpaW5mb190eXBlLCByYyk7CisJfQogCiAJ
ZnJlZV9yc3BfYnVmKHJlc3BfYnVmdHlwZSwgcnNwKTsKIAlrZnJlZShpb3YpOwpAQCAtMzc2Niw2
ICszODA4LDggQEAgc21iMl9sb2Nrdihjb25zdCB1bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lm
c190Y29uICp0Y29uLAogCWlmIChyYykgewogCQljaWZzX2RiZyhGWUksICJTZW5kIGVycm9yIGlu
IHNtYjJfbG9ja3YgPSAlZFxuIiwgcmMpOwogCQljaWZzX3N0YXRzX2ZhaWxfaW5jKHRjb24sIFNN
QjJfTE9DS19IRSk7CisJCXRyYWNlX3NtYjNfbG9ja19lcnIoeGlkLCBwZXJzaXN0X2ZpZCwgdGNv
bi0+dGlkLAorCQkJCSAgICB0Y29uLT5zZXMtPlN1aWQsIHJjKTsKIAl9CiAKIAlyZXR1cm4gcmM7
CmRpZmYgLS1naXQgYS9mcy9jaWZzL3RyYWNlLmMgYi9mcy9jaWZzL3RyYWNlLmMKbmV3IGZpbGUg
bW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMDAwMDAwLi5iZDRhNTQ2ZmVlYzEKLS0tIC9kZXYvbnVs
bAorKysgYi9mcy9jaWZzL3RyYWNlLmMKQEAgLTAsMCArMSwxOCBAQAorLy8gU1BEWC1MaWNlbnNl
LUlkZW50aWZpZXI6IEdQTC0yLjAKKy8qCisgKiAgIENvcHlyaWdodCAoQykgMjAxOCwgTWljcm9z
b2Z0IENvcnBvcmF0aW9uLgorICoKKyAqICAgQXV0aG9yKHMpOiBTdGV2ZSBGcmVuY2ggPHN0ZnJl
bmNoQG1pY3Jvc29mdC5jb20+CisgKgorICogICBUaGlzIHByb2dyYW0gaXMgZnJlZSBzb2Z0d2Fy
ZTsgIHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vciBtb2RpZnkKKyAqICAgaXQgdW5kZXIg
dGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBhcyBwdWJsaXNoZWQg
YnkKKyAqICAgdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbjsgZWl0aGVyIHZlcnNpb24gMiBv
ZiB0aGUgTGljZW5zZSwgb3IKKyAqICAgKGF0IHlvdXIgb3B0aW9uKSBhbnkgbGF0ZXIgdmVyc2lv
bi4KKyAqCisgKiAgIFRoaXMgcHJvZ3JhbSBpcyBkaXN0cmlidXRlZCBpbiB0aGUgaG9wZSB0aGF0
IGl0IHdpbGwgYmUgdXNlZnVsLAorICogICBidXQgV0lUSE9VVCBBTlkgV0FSUkFOVFk7ICB3aXRo
b3V0IGV2ZW4gdGhlIGltcGxpZWQgd2FycmFudHkgb2YKKyAqICAgTUVSQ0hBTlRBQklMSVRZIG9y
IEZJVE5FU1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQT1NFLiAgU2VlCisgKiAgIHRoZSBHTlUgR2Vu
ZXJhbCBQdWJsaWMgTGljZW5zZSBmb3IgbW9yZSBkZXRhaWxzLgorICovCisjZGVmaW5lIENSRUFU
RV9UUkFDRV9QT0lOVFMKKyNpbmNsdWRlICJ0cmFjZS5oIgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy90
cmFjZS5oIGIvZnMvY2lmcy90cmFjZS5oCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAw
MDAwMDAwMC4uOTM1YTU4OTc5ZTFiCi0tLSAvZGV2L251bGwKKysrIGIvZnMvY2lmcy90cmFjZS5o
CkBAIC0wLDAgKzEsMjk4IEBACisvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMCAq
LworLyoKKyAqICAgQ29weXJpZ2h0IChDKSAyMDE4LCBNaWNyb3NvZnQgQ29ycG9yYXRpb24uCisg
KgorICogICBBdXRob3Iocyk6IFN0ZXZlIEZyZW5jaCA8c3RmcmVuY2hAbWljcm9zb2Z0LmNvbT4K
KyAqCisgKiAgIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyAgeW91IGNhbiByZWRpc3Ry
aWJ1dGUgaXQgYW5kL29yIG1vZGlmeQorICogICBpdCB1bmRlciB0aGUgdGVybXMgb2YgdGhlIEdO
VSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGFzIHB1Ymxpc2hlZCBieQorICogICB0aGUgRnJlZSBT
b2Z0d2FyZSBGb3VuZGF0aW9uOyBlaXRoZXIgdmVyc2lvbiAyIG9mIHRoZSBMaWNlbnNlLCBvcgor
ICogICAoYXQgeW91ciBvcHRpb24pIGFueSBsYXRlciB2ZXJzaW9uLgorICoKKyAqICAgVGhpcyBw
cm9ncmFtIGlzIGRpc3RyaWJ1dGVkIGluIHRoZSBob3BlIHRoYXQgaXQgd2lsbCBiZSB1c2VmdWws
CisgKiAgIGJ1dCBXSVRIT1VUIEFOWSBXQVJSQU5UWTsgIHdpdGhvdXQgZXZlbiB0aGUgaW1wbGll
ZCB3YXJyYW50eSBvZgorICogICBNRVJDSEFOVEFCSUxJVFkgb3IgRklUTkVTUyBGT1IgQSBQQVJU
SUNVTEFSIFBVUlBPU0UuICBTZWUKKyAqICAgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNl
IGZvciBtb3JlIGRldGFpbHMuCisgKi8KKyN1bmRlZiBUUkFDRV9TWVNURU0KKyNkZWZpbmUgVFJB
Q0VfU1lTVEVNIGNpZnMKKworI2lmICFkZWZpbmVkKF9DSUZTX1RSQUNFX0gpIHx8IGRlZmluZWQo
VFJBQ0VfSEVBREVSX01VTFRJX1JFQUQpCisjZGVmaW5lIF9DSUZTX1RSQUNFX0gKKworI2luY2x1
ZGUgPGxpbnV4L3RyYWNlcG9pbnQuaD4KKworLyogRm9yIGxvZ2dpbmcgZXJyb3JzIGluIHJlYWQg
b3Igd3JpdGUgKi8KK0RFQ0xBUkVfRVZFTlRfQ0xBU1Moc21iM19yd19lcnJfY2xhc3MsCisJVFBf
UFJPVE8odW5zaWduZWQgaW50IHhpZCwKKwkJX191NjQJZmlkLAorCQlfX3UzMgl0aWQsCisJCV9f
dTY0CXNlc2lkLAorCQlfX3U2NAlvZmZzZXQsCisJCV9fdTMyCWxlbiwKKwkJaW50CXJjKSwKKwlU
UF9BUkdTKHhpZCwgZmlkLCB0aWQsIHNlc2lkLCBvZmZzZXQsIGxlbiwgcmMpLAorCVRQX1NUUlVD
VF9fZW50cnkoCisJCV9fZmllbGQodW5zaWduZWQgaW50LCB4aWQpCisJCV9fZmllbGQoX191NjQs
IGZpZCkKKwkJX19maWVsZChfX3UzMiwgdGlkKQorCQlfX2ZpZWxkKF9fdTY0LCBzZXNpZCkKKwkJ
X19maWVsZChfX3U2NCwgb2Zmc2V0KQorCQlfX2ZpZWxkKF9fdTMyLCBsZW4pCisJCV9fZmllbGQo
aW50LCByYykKKwkpLAorCVRQX2Zhc3RfYXNzaWduKAorCQlfX2VudHJ5LT54aWQgPSB4aWQ7CisJ
CV9fZW50cnktPmZpZCA9IGZpZDsKKwkJX19lbnRyeS0+dGlkID0gdGlkOworCQlfX2VudHJ5LT5z
ZXNpZCA9IHNlc2lkOworCQlfX2VudHJ5LT5vZmZzZXQgPSBvZmZzZXQ7CisJCV9fZW50cnktPmxl
biA9IGxlbjsKKwkJX19lbnRyeS0+cmMgPSByYzsKKwkpLAorCVRQX3ByaW50aygieGlkPSV1IGZp
ZD0weCVsbHggdGlkPTB4JXggc2lkPTB4JWxseCBvZmZzZXQ9MHglbGx4IGxlbj0weCV4IHJjPSVk
IiwKKwkJX19lbnRyeS0+eGlkLCBfX2VudHJ5LT5maWQsIF9fZW50cnktPnRpZCwgX19lbnRyeS0+
c2VzaWQsCisJCV9fZW50cnktPm9mZnNldCwgX19lbnRyeS0+bGVuLCBfX2VudHJ5LT5yYykKKykK
KworI2RlZmluZSBERUZJTkVfU01CM19SV19FUlJfRVZFTlQobmFtZSkgICAgICAgICAgXAorREVG
SU5FX0VWRU5UKHNtYjNfcndfZXJyX2NsYXNzLCBzbWIzXyMjbmFtZSwgICAgXAorCVRQX1BST1RP
KHVuc2lnbmVkIGludCB4aWQsCQlcCisJCV9fdTY0CWZpZCwJCQlcCisJCV9fdTMyCXRpZCwJCQlc
CisJCV9fdTY0CXNlc2lkLAkJCVwKKwkJX191NjQJb2Zmc2V0LAkJCVwKKwkJX191MzIJbGVuLAkJ
CVwKKwkJaW50CXJjKSwJCQlcCisJVFBfQVJHUyh4aWQsIGZpZCwgdGlkLCBzZXNpZCwgb2Zmc2V0
LCBsZW4sIHJjKSkKKworREVGSU5FX1NNQjNfUldfRVJSX0VWRU5UKHdyaXRlX2Vycik7CitERUZJ
TkVfU01CM19SV19FUlJfRVZFTlQocmVhZF9lcnIpOworCisKKy8qIEZvciBsb2dnaW5nIHN1Y2Nl
c3NmdWwgcmVhZCBvciB3cml0ZSAqLworREVDTEFSRV9FVkVOVF9DTEFTUyhzbWIzX3J3X2RvbmVf
Y2xhc3MsCisJVFBfUFJPVE8odW5zaWduZWQgaW50IHhpZCwKKwkJX191NjQJZmlkLAorCQlfX3Uz
Mgl0aWQsCisJCV9fdTY0CXNlc2lkLAorCQlfX3U2NAlvZmZzZXQsCisJCV9fdTMyCWxlbiksCisJ
VFBfQVJHUyh4aWQsIGZpZCwgdGlkLCBzZXNpZCwgb2Zmc2V0LCBsZW4pLAorCVRQX1NUUlVDVF9f
ZW50cnkoCisJCV9fZmllbGQodW5zaWduZWQgaW50LCB4aWQpCisJCV9fZmllbGQoX191NjQsIGZp
ZCkKKwkJX19maWVsZChfX3UzMiwgdGlkKQorCQlfX2ZpZWxkKF9fdTY0LCBzZXNpZCkKKwkJX19m
aWVsZChfX3U2NCwgb2Zmc2V0KQorCQlfX2ZpZWxkKF9fdTMyLCBsZW4pCisJKSwKKwlUUF9mYXN0
X2Fzc2lnbigKKwkJX19lbnRyeS0+eGlkID0geGlkOworCQlfX2VudHJ5LT5maWQgPSBmaWQ7CisJ
CV9fZW50cnktPnRpZCA9IHRpZDsKKwkJX19lbnRyeS0+c2VzaWQgPSBzZXNpZDsKKwkJX19lbnRy
eS0+b2Zmc2V0ID0gb2Zmc2V0OworCQlfX2VudHJ5LT5sZW4gPSBsZW47CisJKSwKKwlUUF9wcmlu
dGsoInhpZD0ldSBmaWQ9MHglbGx4IHRpZD0weCV4IHNpZD0weCVsbHggb2Zmc2V0PTB4JWxseCBs
ZW49MHgleCIsCisJCV9fZW50cnktPnhpZCwgX19lbnRyeS0+ZmlkLCBfX2VudHJ5LT50aWQsIF9f
ZW50cnktPnNlc2lkLAorCQlfX2VudHJ5LT5vZmZzZXQsIF9fZW50cnktPmxlbikKKykKKworI2Rl
ZmluZSBERUZJTkVfU01CM19SV19ET05FX0VWRU5UKG5hbWUpICAgICAgICAgXAorREVGSU5FX0VW
RU5UKHNtYjNfcndfZG9uZV9jbGFzcywgc21iM18jI25hbWUsICAgXAorCVRQX1BST1RPKHVuc2ln
bmVkIGludCB4aWQsCQlcCisJCV9fdTY0CWZpZCwJCQlcCisJCV9fdTMyCXRpZCwJCQlcCisJCV9f
dTY0CXNlc2lkLAkJCVwKKwkJX191NjQJb2Zmc2V0LAkJCVwKKwkJX191MzIJbGVuKSwJCQlcCisJ
VFBfQVJHUyh4aWQsIGZpZCwgdGlkLCBzZXNpZCwgb2Zmc2V0LCBsZW4pKQorCitERUZJTkVfU01C
M19SV19ET05FX0VWRU5UKHdyaXRlX2RvbmUpOworREVGSU5FX1NNQjNfUldfRE9ORV9FVkVOVChy
ZWFkX2RvbmUpOworCisvKgorICogRm9yIGhhbmRsZSBiYXNlZCBjYWxscyBvdGhlciB0aGFuIHJl
YWQgYW5kIHdyaXRlLCBhbmQgZ2V0L3NldCBpbmZvCisgKi8KK0RFQ0xBUkVfRVZFTlRfQ0xBU1Mo
c21iM19mZF9lcnJfY2xhc3MsCisJVFBfUFJPVE8odW5zaWduZWQgaW50IHhpZCwKKwkJX191NjQJ
ZmlkLAorCQlfX3UzMgl0aWQsCisJCV9fdTY0CXNlc2lkLAorCQlpbnQJcmMpLAorCVRQX0FSR1Mo
eGlkLCBmaWQsIHRpZCwgc2VzaWQsIHJjKSwKKwlUUF9TVFJVQ1RfX2VudHJ5KAorCQlfX2ZpZWxk
KHVuc2lnbmVkIGludCwgeGlkKQorCQlfX2ZpZWxkKF9fdTY0LCBmaWQpCisJCV9fZmllbGQoX191
MzIsIHRpZCkKKwkJX19maWVsZChfX3U2NCwgc2VzaWQpCisJCV9fZmllbGQoaW50LCByYykKKwkp
LAorCVRQX2Zhc3RfYXNzaWduKAorCQlfX2VudHJ5LT54aWQgPSB4aWQ7CisJCV9fZW50cnktPmZp
ZCA9IGZpZDsKKwkJX19lbnRyeS0+dGlkID0gdGlkOworCQlfX2VudHJ5LT5zZXNpZCA9IHNlc2lk
OworCQlfX2VudHJ5LT5yYyA9IHJjOworCSksCisJVFBfcHJpbnRrKCJ4aWQ9JXUgZmlkPTB4JWxs
eCB0aWQ9MHgleCBzaWQ9MHglbGx4IHJjPSVkIiwKKwkJX19lbnRyeS0+eGlkLCBfX2VudHJ5LT5m
aWQsIF9fZW50cnktPnRpZCwgX19lbnRyeS0+c2VzaWQsCisJCV9fZW50cnktPnJjKQorKQorCisj
ZGVmaW5lIERFRklORV9TTUIzX0ZEX0VSUl9FVkVOVChuYW1lKSAgICAgICAgICBcCitERUZJTkVf
RVZFTlQoc21iM19mZF9lcnJfY2xhc3MsIHNtYjNfIyNuYW1lLCAgICBcCisJVFBfUFJPVE8odW5z
aWduZWQgaW50IHhpZCwJCVwKKwkJX191NjQJZmlkLAkJCVwKKwkJX191MzIJdGlkLAkJCVwKKwkJ
X191NjQJc2VzaWQsCQkJXAorCQlpbnQJcmMpLAkJCVwKKwlUUF9BUkdTKHhpZCwgZmlkLCB0aWQs
IHNlc2lkLCByYykpCisKK0RFRklORV9TTUIzX0ZEX0VSUl9FVkVOVChmbHVzaF9lcnIpOworREVG
SU5FX1NNQjNfRkRfRVJSX0VWRU5UKGxvY2tfZXJyKTsKK0RFRklORV9TTUIzX0ZEX0VSUl9FVkVO
VChjbG9zZV9lcnIpOworCisvKgorICogRm9yIGhhbmRsZSBiYXNlZCBxdWVyeS9zZXQgaW5mbyBj
YWxscworICovCitERUNMQVJFX0VWRU5UX0NMQVNTKHNtYjNfaW5mX2Vycl9jbGFzcywKKwlUUF9Q
Uk9UTyh1bnNpZ25lZCBpbnQgeGlkLAorCQlfX3U2NAlmaWQsCisJCV9fdTMyCXRpZCwKKwkJX191
NjQJc2VzaWQsCisJCV9fdTgJaW5mY2xhc3MsCisJCV9fdTMyCXR5cGUsCisJCWludAlyYyksCisJ
VFBfQVJHUyh4aWQsIGZpZCwgdGlkLCBzZXNpZCwgaW5mY2xhc3MsIHR5cGUsIHJjKSwKKwlUUF9T
VFJVQ1RfX2VudHJ5KAorCQlfX2ZpZWxkKHVuc2lnbmVkIGludCwgeGlkKQorCQlfX2ZpZWxkKF9f
dTY0LCBmaWQpCisJCV9fZmllbGQoX191MzIsIHRpZCkKKwkJX19maWVsZChfX3U2NCwgc2VzaWQp
CisJCV9fZmllbGQoX191OCwgaW5mY2xhc3MpCisJCV9fZmllbGQoX191MzIsIHR5cGUpCisJCV9f
ZmllbGQoaW50LCByYykKKwkpLAorCVRQX2Zhc3RfYXNzaWduKAorCQlfX2VudHJ5LT54aWQgPSB4
aWQ7CisJCV9fZW50cnktPmZpZCA9IGZpZDsKKwkJX19lbnRyeS0+dGlkID0gdGlkOworCQlfX2Vu
dHJ5LT5zZXNpZCA9IHNlc2lkOworCQlfX2VudHJ5LT5pbmZjbGFzcyA9IGluZmNsYXNzOworCQlf
X2VudHJ5LT50eXBlID0gdHlwZTsKKwkJX19lbnRyeS0+cmMgPSByYzsKKwkpLAorCVRQX3ByaW50
aygieGlkPSV1IGZpZD0weCVsbHggdGlkPTB4JXggc2lkPTB4JWxseCBjbGFzcz0ldSB0eXBlPTB4
JXggcmM9JWQiLAorCQlfX2VudHJ5LT54aWQsIF9fZW50cnktPmZpZCwgX19lbnRyeS0+dGlkLCBf
X2VudHJ5LT5zZXNpZCwKKwkJX19lbnRyeS0+aW5mY2xhc3MsIF9fZW50cnktPnR5cGUsIF9fZW50
cnktPnJjKQorKQorCisjZGVmaW5lIERFRklORV9TTUIzX0lORl9FUlJfRVZFTlQobmFtZSkgICAg
ICAgICAgXAorREVGSU5FX0VWRU5UKHNtYjNfaW5mX2Vycl9jbGFzcywgc21iM18jI25hbWUsICAg
IFwKKwlUUF9QUk9UTyh1bnNpZ25lZCBpbnQgeGlkLAkJXAorCQlfX3U2NAlmaWQsCQkJXAorCQlf
X3UzMgl0aWQsCQkJXAorCQlfX3U2NAlzZXNpZCwJCQlcCisJCV9fdTgJaW5mY2xhc3MsCQlcCisJ
CV9fdTMyCXR5cGUsCQkJXAorCQlpbnQJcmMpLAkJCVwKKwlUUF9BUkdTKHhpZCwgZmlkLCB0aWQs
IHNlc2lkLCBpbmZjbGFzcywgdHlwZSwgcmMpKQorCitERUZJTkVfU01CM19JTkZfRVJSX0VWRU5U
KHF1ZXJ5X2luZm9fZXJyKTsKK0RFRklORV9TTUIzX0lORl9FUlJfRVZFTlQoc2V0X2luZm9fZXJy
KTsKK0RFRklORV9TTUIzX0lORl9FUlJfRVZFTlQoZnNjdGxfZXJyKTsKKworLyoKKyAqIEZvciBs
b2dnaW5nIFNNQjMgU3RhdHVzIGNvZGUgYW5kIENvbW1hbmQgZm9yIHJlc3BvbnNlcyB3aGljaCBy
ZXR1cm4gZXJyb3JzCisgKi8KK0RFQ0xBUkVfRVZFTlRfQ0xBU1Moc21iM19jbWRfZXJyX2NsYXNz
LAorCVRQX1BST1RPKF9fdTMyCXBpZCwKKwkJX191MzIJdGlkLAorCQlfX3U2NAlzZXNpZCwKKwkJ
X191MTYJY21kLAorCQlfX3U2NAltaWQsCisJCV9fdTMyCXN0YXR1cywKKwkJaW50CXJjKSwKKwlU
UF9BUkdTKHBpZCwgdGlkLCBzZXNpZCwgY21kLCBtaWQsIHN0YXR1cywgcmMpLAorCVRQX1NUUlVD
VF9fZW50cnkoCisJCV9fZmllbGQoX191MzIsIHBpZCkKKwkJX19maWVsZChfX3UzMiwgdGlkKQor
CQlfX2ZpZWxkKF9fdTY0LCBzZXNpZCkKKwkJX19maWVsZChfX3UxNiwgY21kKQorCQlfX2ZpZWxk
KF9fdTY0LCBtaWQpCisJCV9fZmllbGQoX191MzIsIHN0YXR1cykKKwkJX19maWVsZChpbnQsIHJj
KQorCSksCisJVFBfZmFzdF9hc3NpZ24oCisJCV9fZW50cnktPnBpZCA9IHBpZDsKKwkJX19lbnRy
eS0+dGlkID0gdGlkOworCQlfX2VudHJ5LT5zZXNpZCA9IHNlc2lkOworCQlfX2VudHJ5LT5jbWQg
PSBjbWQ7CisJCV9fZW50cnktPm1pZCA9IG1pZDsKKwkJX19lbnRyeS0+c3RhdHVzID0gc3RhdHVz
OworCQlfX2VudHJ5LT5yYyA9IHJjOworCSksCisJVFBfcHJpbnRrKCIgcGlkPSV1IHRpZD0weCV4
IHNpZD0weCVsbHggY21kPSV1IG1pZD0lbGx1IHN0YXR1cz0weCV4IHJjPSVkIiwKKwkJX19lbnRy
eS0+cGlkLCBfX2VudHJ5LT50aWQsIF9fZW50cnktPnNlc2lkLAorCQlfX2VudHJ5LT5jbWQsIF9f
ZW50cnktPm1pZCwgX19lbnRyeS0+c3RhdHVzLCBfX2VudHJ5LT5yYykKKykKKworI2RlZmluZSBE
RUZJTkVfU01CM19DTURfRVJSX0VWRU5UKG5hbWUpICAgICAgICAgIFwKK0RFRklORV9FVkVOVChz
bWIzX2NtZF9lcnJfY2xhc3MsIHNtYjNfIyNuYW1lLCAgICBcCisJVFBfUFJPVE8odW5zaWduZWQg
aW50IHBpZCwJCVwKKwkJX191MzIJdGlkLAkJCVwKKwkJX191NjQJc2VzaWQsCQkJXAorCQlfX3Ux
NgljbWQsCQkJXAorCQlfX3U2NAltaWQsCQkJXAorCQlfX3UzMglzdGF0dXMsCQkJXAorCQlpbnQJ
cmMpLAkJCVwKKwlUUF9BUkdTKHBpZCwgdGlkLCBzZXNpZCwgY21kLCBtaWQsIHN0YXR1cywgcmMp
KQorCitERUZJTkVfU01CM19DTURfRVJSX0VWRU5UKGNtZF9lcnIpOworCitERUNMQVJFX0VWRU5U
X0NMQVNTKHNtYjNfY21kX2RvbmVfY2xhc3MsCisJVFBfUFJPVE8oX191MzIJcGlkLAorCQlfX3Uz
Mgl0aWQsCisJCV9fdTY0CXNlc2lkLAorCQlfX3UxNgljbWQsCisJCV9fdTY0CW1pZCksCisJVFBf
QVJHUyhwaWQsIHRpZCwgc2VzaWQsIGNtZCwgbWlkKSwKKwlUUF9TVFJVQ1RfX2VudHJ5KAorCQlf
X2ZpZWxkKF9fdTMyLCBwaWQpCisJCV9fZmllbGQoX191MzIsIHRpZCkKKwkJX19maWVsZChfX3U2
NCwgc2VzaWQpCisJCV9fZmllbGQoX191MTYsIGNtZCkKKwkJX19maWVsZChfX3U2NCwgbWlkKQor
CSksCisJVFBfZmFzdF9hc3NpZ24oCisJCV9fZW50cnktPnBpZCA9IHBpZDsKKwkJX19lbnRyeS0+
dGlkID0gdGlkOworCQlfX2VudHJ5LT5zZXNpZCA9IHNlc2lkOworCQlfX2VudHJ5LT5jbWQgPSBj
bWQ7CisJCV9fZW50cnktPm1pZCA9IG1pZDsKKwkpLAorCVRQX3ByaW50aygicGlkPSV1IHRpZD0w
eCV4IHNpZD0weCVsbHggY21kPSV1IG1pZD0lbGx1IiwKKwkJX19lbnRyeS0+cGlkLCBfX2VudHJ5
LT50aWQsIF9fZW50cnktPnNlc2lkLAorCQlfX2VudHJ5LT5jbWQsIF9fZW50cnktPm1pZCkKKykK
KworI2RlZmluZSBERUZJTkVfU01CM19DTURfRE9ORV9FVkVOVChuYW1lKSAgICAgICAgICBcCitE
RUZJTkVfRVZFTlQoc21iM19jbWRfZG9uZV9jbGFzcywgc21iM18jI25hbWUsICAgIFwKKwlUUF9Q
Uk9UTyh1bnNpZ25lZCBpbnQgcGlkLAkJXAorCQlfX3UzMgl0aWQsCQkJXAorCQlfX3U2NAlzZXNp
ZCwJCQlcCisJCV9fdTE2CWNtZCwJCQlcCisJCV9fdTY0CW1pZCksCQkJXAorCVRQX0FSR1MocGlk
LCB0aWQsIHNlc2lkLCBjbWQsIG1pZCkpCisKK0RFRklORV9TTUIzX0NNRF9ET05FX0VWRU5UKGNt
ZF9kb25lKTsKKworI2VuZGlmIC8qIF9DSUZTX1RSQUNFX0ggKi8KKworI3VuZGVmIFRSQUNFX0lO
Q0xVREVfUEFUSAorI2RlZmluZSBUUkFDRV9JTkNMVURFX1BBVEggLgorI2RlZmluZSBUUkFDRV9J
TkNMVURFX0ZJTEUgdHJhY2UKKyNpbmNsdWRlIDx0cmFjZS9kZWZpbmVfdHJhY2UuaD4KLS0gCjIu
MTcuMAoK
--00000000000060bdea056c71d34a--
