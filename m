From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [CIFS] Query File System Alignment
Date: Wed, 9 Oct 2013 21:11:44 -0500
Message-ID: <CAH2r5mt0rg+mDktiLovQ43sRpXSx=wCGaXS7NZZ=+OzbkL0Zdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a11343f7efb5bdc04e8598542
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

--001a11343f7efb5bdc04e8598542
Content-Type: text/plain; charset=ISO-8859-1

In SMB3 it is now possible to query the file system
alignment info, and the preferred (for performance)
sector size and whether the underlying disk
has no seek penalty (like SSD).

Query this information at mount time for SMB3,
and make it visible in /proc/fs/cifs/DebugData
for debugging purposes.

This alignment information and preferred sector
size info will be helpful for the copy offload
patches to setup the right chunks in the CopyChunk
requests.   Presumably the knowledge that the
underlying disk is SSD could also help us
make better readahead and writebehind
decisions (something to look at in the future).

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsglob.h |    2 ++
 fs/cifs/smb2ops.c  |   44 +++++++++++++++++++++++++++++++++++++++++++-
 fs/cifs/smb2pdu.c  |   12 +++++++++++-
 fs/cifs/smb2pdu.h  |   22 ++++++++++++++++++++--
 4 files changed, 76 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 06e8947..de3e3e0 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -830,6 +830,8 @@ struct cifs_tcon {
     __u32 maximal_access;
     __u32 vol_serial_number;
     __le64 vol_create_time;
+    __u32 ss_flags;        /* sector size flags */
+    __u32 perf_sector_size; /* best sector size for perf */
 #endif /* CONFIG_CIFS_SMB2 */
 #ifdef CONFIG_CIFS_FSCACHE
     u64 resource_id;        /* server resource id */
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 79084d6..25759c8 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -210,6 +210,36 @@ smb2_negotiate_rsize(struct cifs_tcon *tcon,
struct smb_vol *volume_info)
 }

 static void
+smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon)
+{
+    int rc;
+    __le16 srch_path = 0; /* Null - open root of share */
+    u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
+    struct cifs_open_parms oparms;
+    struct cifs_fid fid;
+
+    oparms.tcon = tcon;
+    oparms.desired_access = FILE_READ_ATTRIBUTES;
+    oparms.disposition = FILE_OPEN;
+    oparms.create_options = 0;
+    oparms.fid = &fid;
+    oparms.reconnect = false;
+
+    rc = SMB2_open(xid, &oparms, &srch_path, &oplock, NULL, NULL);
+    if (rc)
+        return;
+
+    SMB2_QFS_attr(xid, tcon, fid.persistent_fid, fid.volatile_fid,
+            FS_ATTRIBUTE_INFORMATION);
+    SMB2_QFS_attr(xid, tcon, fid.persistent_fid, fid.volatile_fid,
+            FS_DEVICE_INFORMATION);
+    SMB2_QFS_attr(xid, tcon, fid.persistent_fid, fid.volatile_fid,
+            FS_SECTOR_SIZE_INFORMATION); /* SMB3 specific */
+    SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
+    return;
+}
+
+static void
 smb2_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon)
 {
     int rc;
@@ -332,7 +362,19 @@ smb2_dump_share_caps(struct seq_file *m, struct
cifs_tcon *tcon)
         seq_puts(m, " ASYMMETRIC,");
     if (tcon->capabilities == 0)
         seq_puts(m, " None");
+    if (tcon->ss_flags & SSINFO_FLAGS_ALIGNED_DEVICE)
+        seq_puts(m, " Aligned,");
+    if (tcon->ss_flags & SSINFO_FLAGS_PARTITION_ALIGNED_ON_DEVICE)
+        seq_puts(m, " Partition Aligned,");
+    if (tcon->ss_flags & SSINFO_FLAGS_NO_SEEK_PENALTY)
+        seq_puts(m, " SSD,");
+    if (tcon->ss_flags & SSINFO_FLAGS_TRIM_ENABLED)
+        seq_puts(m, " TRIM-support,");
+
     seq_printf(m, "\tShare Flags: 0x%x", tcon->share_flags);
+    if (tcon->perf_sector_size)
+        seq_printf(m, "\tOptimal sector size: 0x%x",
+               tcon->perf_sector_size);
 }

 static void
@@ -1048,7 +1090,7 @@ struct smb_version_operations smb30_operations = {
     .logoff = SMB2_logoff,
     .tree_connect = SMB2_tcon,
     .tree_disconnect = SMB2_tdis,
-    .qfs_tcon = smb2_qfs_tcon,
+    .qfs_tcon = smb3_qfs_tcon,
     .is_path_accessible = smb2_is_path_accessible,
     .can_echo = smb2_can_echo,
     .echo = SMB2_echo,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index f6449ba..31ac96c 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2362,8 +2362,11 @@ SMB2_QFS_attr(const unsigned int xid, struct
cifs_tcon *tcon,
     } else if (level == FS_ATTRIBUTE_INFORMATION) {
         max_len = sizeof(FILE_SYSTEM_ATTRIBUTE_INFO);
         min_len = MIN_FS_ATTR_INFO_SIZE;
+    } else if (level == FS_SECTOR_SIZE_INFORMATION) {
+        max_len = sizeof(struct smb3_fs_ss_info);
+        min_len = sizeof(struct smb3_fs_ss_info);
     } else {
-        cifs_dbg(FYI, "Invalid qfsinfo level %d", level);
+        cifs_dbg(FYI, "Invalid qfsinfo level %d\n", level);
         return -EINVAL;
     }

@@ -2392,6 +2395,13 @@ SMB2_QFS_attr(const unsigned int xid, struct
cifs_tcon *tcon,
     else if (level == FS_DEVICE_INFORMATION)
         memcpy(&tcon->fsDevInfo, 4 /* RFC1001 len */ + offset
             + (char *)&rsp->hdr, sizeof(FILE_SYSTEM_DEVICE_INFO));
+    else if (level == FS_SECTOR_SIZE_INFORMATION) {
+        struct smb3_fs_ss_info *ss_info = (struct smb3_fs_ss_info *)
+            (4 /* RFC1001 len */ + offset + (char *)&rsp->hdr);
+        tcon->ss_flags = le32_to_cpu(ss_info->Flags);
+        tcon->perf_sector_size =
+            le32_to_cpu(ss_info->PhysicalBytesPerSectorForPerf);
+    }

 qfsattr_exit:
     free_rsp_buf(resp_buftype, iov.iov_base);
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index c7c3c82..7e44f18 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -877,14 +877,16 @@ struct smb2_lease_ack {

 /* File System Information Classes */
 #define FS_VOLUME_INFORMATION        1 /* Query */
-#define FS_LABEL_INFORMATION        2 /* Set */
+#define FS_LABEL_INFORMATION        2 /* Local only */
 #define FS_SIZE_INFORMATION        3 /* Query */
 #define FS_DEVICE_INFORMATION        4 /* Query */
 #define FS_ATTRIBUTE_INFORMATION    5 /* Query */
 #define FS_CONTROL_INFORMATION        6 /* Query, Set */
 #define FS_FULL_SIZE_INFORMATION    7 /* Query */
 #define FS_OBJECT_ID_INFORMATION    8 /* Query, Set */
-#define FS_DRIVER_PATH_INFORMATION    9 /* Query */
+#define FS_DRIVER_PATH_INFORMATION    9 /* Local only */
+#define FS_VOLUME_FLAGS_INFORMATION    10 /* Local only */
+#define FS_SECTOR_SIZE_INFORMATION    11 /* SMB3 or later. Query */

 struct smb2_fs_full_size_info {
     __le64 TotalAllocationUnits;
@@ -894,6 +896,22 @@ struct smb2_fs_full_size_info {
     __le32 BytesPerSector;
 } __packed;

+#define SSINFO_FLAGS_ALIGNED_DEVICE        0x00000001
+#define SSINFO_FLAGS_PARTITION_ALIGNED_ON_DEVICE 0x00000002
+#define SSINFO_FLAGS_NO_SEEK_PENALTY        0x00000004
+#define SSINFO_FLAGS_TRIM_ENABLED        0x00000008
+
+/* sector size info struct */
+struct smb3_fs_ss_info {
+    __le32 LogicalBytesPerSector;
+    __le32 PhysicalBytesPerSectorForAtomicity;
+    __le32 PhysicalBytesPerSectorForPerf;
+    __le32 FileSystemEffectivePhysicalBytesPerSectorForAtomicity;
+    __le32 Flags;
+    __le32 ByteOffsetForSectorAlignment;
+    __le32 ByteOffsetForPartitionAlignment;
+} __packed;
+
 /* partial list of QUERY INFO levels */
 #define FILE_DIRECTORY_INFORMATION    1
 #define FILE_FULL_DIRECTORY_INFORMATION 2
-- 
1.7.10.4


-- 
Thanks,

Steve

--001a11343f7efb5bdc04e8598542
Content-Type: application/octet-stream;
	name="0001-CIFS-Query-File-System-Alignment.patch"
Content-Disposition: attachment;
	filename="0001-CIFS-Query-File-System-Alignment.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hmlco7it0

RnJvbSBlM2IxY2EwYWIwMjVjYzQwMjViZWVlMjkwZTU1NDNmMjU0YjJkM2IzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZW4gRnJlbmNoIDxzbWZyZW5jaEBnbWFpbC5jb20+CkRh
dGU6IFdlZCwgOSBPY3QgMjAxMyAyMDo1NTo1MyAtMDUwMApTdWJqZWN0OiBbUEFUQ0hdIFtDSUZT
XSBRdWVyeSBGaWxlIFN5c3RlbSBBbGlnbm1lbnQKCkluIFNNQjMgaXQgaXMgbm93IHBvc3NpYmxl
IHRvIHF1ZXJ5IHRoZSBmaWxlIHN5c3RlbQphbGlnbm1lbnQgaW5mbywgYW5kIHRoZSBwcmVmZXJy
ZWQgKGZvciBwZXJmb3JtYW5jZSkKc2VjdG9yIHNpemUgYW5kIHdoZXRoZXIgdGhlIHVuZGVybHlp
bmcgZGlzawpoYXMgbm8gc2VlayBwZW5hbHR5IChsaWtlIFNTRCkuCgpRdWVyeSB0aGlzIGluZm9y
bWF0aW9uIGF0IG1vdW50IHRpbWUgZm9yIFNNQjMsCmFuZCBtYWtlIGl0IHZpc2libGUgaW4gL3By
b2MvZnMvY2lmcy9EZWJ1Z0RhdGEKZm9yIGRlYnVnZ2luZyBwdXJwb3Nlcy4KClRoaXMgYWxpZ25t
ZW50IGluZm9ybWF0aW9uIGFuZCBwcmVmZXJyZWQgc2VjdG9yCnNpemUgaW5mbyB3aWxsIGJlIGhl
bHBmdWwgZm9yIHRoZSBjb3B5IG9mZmxvYWQKcGF0Y2hlcyB0byBzZXR1cCB0aGUgcmlnaHQgY2h1
bmtzIGluIHRoZSBDb3B5Q2h1bmsKcmVxdWVzdHMuICAgUHJlc3VtYWJseSB0aGUga25vd2xlZGdl
IHRoYXQgdGhlCnVuZGVybHlpbmcgZGlzayBpcyBTU0QgY291bGQgYWxzbyBoZWxwIHVzCm1ha2Ug
YmV0dGVyIHJlYWRhaGVhZCBhbmQgd3JpdGViZWhpbmQKZGVjaXNpb25zIChzb21ldGhpbmcgdG8g
bG9vayBhdCBpbiB0aGUgZnV0dXJlKS4KClNpZ25lZC1vZmYtYnk6IFN0ZXZlIEZyZW5jaCA8c21m
cmVuY2hAZ21haWwuY29tPgotLS0KIGZzL2NpZnMvY2lmc2dsb2IuaCB8ICAgIDIgKysKIGZzL2Np
ZnMvc21iMm9wcy5jICB8ICAgNDQgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKy0KIGZzL2NpZnMvc21iMnBkdS5jICB8ICAgMTIgKysrKysrKysrKystCiBmcy9jaWZz
L3NtYjJwZHUuaCAgfCAgIDIyICsrKysrKysrKysrKysrKysrKysrLS0KIDQgZmlsZXMgY2hhbmdl
ZCwgNzYgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9jaWZz
L2NpZnNnbG9iLmggYi9mcy9jaWZzL2NpZnNnbG9iLmgKaW5kZXggMDZlODk0Ny4uZGUzZTNlMCAx
MDA2NDQKLS0tIGEvZnMvY2lmcy9jaWZzZ2xvYi5oCisrKyBiL2ZzL2NpZnMvY2lmc2dsb2IuaApA
QCAtODMwLDYgKzgzMCw4IEBAIHN0cnVjdCBjaWZzX3Rjb24gewogCV9fdTMyIG1heGltYWxfYWNj
ZXNzOwogCV9fdTMyIHZvbF9zZXJpYWxfbnVtYmVyOwogCV9fbGU2NCB2b2xfY3JlYXRlX3RpbWU7
CisJX191MzIgc3NfZmxhZ3M7CQkvKiBzZWN0b3Igc2l6ZSBmbGFncyAqLworCV9fdTMyIHBlcmZf
c2VjdG9yX3NpemU7IC8qIGJlc3Qgc2VjdG9yIHNpemUgZm9yIHBlcmYgKi8KICNlbmRpZiAvKiBD
T05GSUdfQ0lGU19TTUIyICovCiAjaWZkZWYgQ09ORklHX0NJRlNfRlNDQUNIRQogCXU2NCByZXNv
dXJjZV9pZDsJCS8qIHNlcnZlciByZXNvdXJjZSBpZCAqLwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9z
bWIyb3BzLmMgYi9mcy9jaWZzL3NtYjJvcHMuYwppbmRleCA3OTA4NGQ2Li4yNTc1OWM4IDEwMDY0
NAotLS0gYS9mcy9jaWZzL3NtYjJvcHMuYworKysgYi9mcy9jaWZzL3NtYjJvcHMuYwpAQCAtMjEw
LDYgKzIxMCwzNiBAQCBzbWIyX25lZ290aWF0ZV9yc2l6ZShzdHJ1Y3QgY2lmc190Y29uICp0Y29u
LCBzdHJ1Y3Qgc21iX3ZvbCAqdm9sdW1lX2luZm8pCiB9CiAKIHN0YXRpYyB2b2lkCitzbWIzX3Fm
c190Y29uKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24pCit7
CisJaW50IHJjOworCV9fbGUxNiBzcmNoX3BhdGggPSAwOyAvKiBOdWxsIC0gb3BlbiByb290IG9m
IHNoYXJlICovCisJdTggb3Bsb2NrID0gU01CMl9PUExPQ0tfTEVWRUxfTk9ORTsKKwlzdHJ1Y3Qg
Y2lmc19vcGVuX3Bhcm1zIG9wYXJtczsKKwlzdHJ1Y3QgY2lmc19maWQgZmlkOworCisJb3Bhcm1z
LnRjb24gPSB0Y29uOworCW9wYXJtcy5kZXNpcmVkX2FjY2VzcyA9IEZJTEVfUkVBRF9BVFRSSUJV
VEVTOworCW9wYXJtcy5kaXNwb3NpdGlvbiA9IEZJTEVfT1BFTjsKKwlvcGFybXMuY3JlYXRlX29w
dGlvbnMgPSAwOworCW9wYXJtcy5maWQgPSAmZmlkOworCW9wYXJtcy5yZWNvbm5lY3QgPSBmYWxz
ZTsKKworCXJjID0gU01CMl9vcGVuKHhpZCwgJm9wYXJtcywgJnNyY2hfcGF0aCwgJm9wbG9jaywg
TlVMTCwgTlVMTCk7CisJaWYgKHJjKQorCQlyZXR1cm47CisKKwlTTUIyX1FGU19hdHRyKHhpZCwg
dGNvbiwgZmlkLnBlcnNpc3RlbnRfZmlkLCBmaWQudm9sYXRpbGVfZmlkLAorCQkJRlNfQVRUUklC
VVRFX0lORk9STUFUSU9OKTsKKwlTTUIyX1FGU19hdHRyKHhpZCwgdGNvbiwgZmlkLnBlcnNpc3Rl
bnRfZmlkLCBmaWQudm9sYXRpbGVfZmlkLAorCQkJRlNfREVWSUNFX0lORk9STUFUSU9OKTsKKwlT
TUIyX1FGU19hdHRyKHhpZCwgdGNvbiwgZmlkLnBlcnNpc3RlbnRfZmlkLCBmaWQudm9sYXRpbGVf
ZmlkLAorCQkJRlNfU0VDVE9SX1NJWkVfSU5GT1JNQVRJT04pOyAvKiBTTUIzIHNwZWNpZmljICov
CisJU01CMl9jbG9zZSh4aWQsIHRjb24sIGZpZC5wZXJzaXN0ZW50X2ZpZCwgZmlkLnZvbGF0aWxl
X2ZpZCk7CisJcmV0dXJuOworfQorCitzdGF0aWMgdm9pZAogc21iMl9xZnNfdGNvbihjb25zdCB1
bnNpZ25lZCBpbnQgeGlkLCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uKQogewogCWludCByYzsKQEAg
LTMzMiw3ICszNjIsMTkgQEAgc21iMl9kdW1wX3NoYXJlX2NhcHMoc3RydWN0IHNlcV9maWxlICpt
LCBzdHJ1Y3QgY2lmc190Y29uICp0Y29uKQogCQlzZXFfcHV0cyhtLCAiIEFTWU1NRVRSSUMsIik7
CiAJaWYgKHRjb24tPmNhcGFiaWxpdGllcyA9PSAwKQogCQlzZXFfcHV0cyhtLCAiIE5vbmUiKTsK
KwlpZiAodGNvbi0+c3NfZmxhZ3MgJiBTU0lORk9fRkxBR1NfQUxJR05FRF9ERVZJQ0UpCisJCXNl
cV9wdXRzKG0sICIgQWxpZ25lZCwiKTsKKwlpZiAodGNvbi0+c3NfZmxhZ3MgJiBTU0lORk9fRkxB
R1NfUEFSVElUSU9OX0FMSUdORURfT05fREVWSUNFKQorCQlzZXFfcHV0cyhtLCAiIFBhcnRpdGlv
biBBbGlnbmVkLCIpOworCWlmICh0Y29uLT5zc19mbGFncyAmIFNTSU5GT19GTEFHU19OT19TRUVL
X1BFTkFMVFkpCisJCXNlcV9wdXRzKG0sICIgU1NELCIpOworCWlmICh0Y29uLT5zc19mbGFncyAm
IFNTSU5GT19GTEFHU19UUklNX0VOQUJMRUQpCisJCXNlcV9wdXRzKG0sICIgVFJJTS1zdXBwb3J0
LCIpOworCiAJc2VxX3ByaW50ZihtLCAiXHRTaGFyZSBGbGFnczogMHgleCIsIHRjb24tPnNoYXJl
X2ZsYWdzKTsKKwlpZiAodGNvbi0+cGVyZl9zZWN0b3Jfc2l6ZSkKKwkJc2VxX3ByaW50ZihtLCAi
XHRPcHRpbWFsIHNlY3RvciBzaXplOiAweCV4IiwKKwkJCSAgIHRjb24tPnBlcmZfc2VjdG9yX3Np
emUpOwogfQogCiBzdGF0aWMgdm9pZApAQCAtMTA0OCw3ICsxMDkwLDcgQEAgc3RydWN0IHNtYl92
ZXJzaW9uX29wZXJhdGlvbnMgc21iMzBfb3BlcmF0aW9ucyA9IHsKIAkubG9nb2ZmID0gU01CMl9s
b2dvZmYsCiAJLnRyZWVfY29ubmVjdCA9IFNNQjJfdGNvbiwKIAkudHJlZV9kaXNjb25uZWN0ID0g
U01CMl90ZGlzLAotCS5xZnNfdGNvbiA9IHNtYjJfcWZzX3Rjb24sCisJLnFmc190Y29uID0gc21i
M19xZnNfdGNvbiwKIAkuaXNfcGF0aF9hY2Nlc3NpYmxlID0gc21iMl9pc19wYXRoX2FjY2Vzc2li
bGUsCiAJLmNhbl9lY2hvID0gc21iMl9jYW5fZWNobywKIAkuZWNobyA9IFNNQjJfZWNobywKZGlm
ZiAtLWdpdCBhL2ZzL2NpZnMvc21iMnBkdS5jIGIvZnMvY2lmcy9zbWIycGR1LmMKaW5kZXggZjY0
NDliYS4uMzFhYzk2YyAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycGR1LmMKKysrIGIvZnMvY2lm
cy9zbWIycGR1LmMKQEAgLTIzNjIsOCArMjM2MiwxMSBAQCBTTUIyX1FGU19hdHRyKGNvbnN0IHVu
c2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAJfSBlbHNlIGlmIChsZXZl
bCA9PSBGU19BVFRSSUJVVEVfSU5GT1JNQVRJT04pIHsKIAkJbWF4X2xlbiA9IHNpemVvZihGSUxF
X1NZU1RFTV9BVFRSSUJVVEVfSU5GTyk7CiAJCW1pbl9sZW4gPSBNSU5fRlNfQVRUUl9JTkZPX1NJ
WkU7CisJfSBlbHNlIGlmIChsZXZlbCA9PSBGU19TRUNUT1JfU0laRV9JTkZPUk1BVElPTikgewor
CQltYXhfbGVuID0gc2l6ZW9mKHN0cnVjdCBzbWIzX2ZzX3NzX2luZm8pOworCQltaW5fbGVuID0g
c2l6ZW9mKHN0cnVjdCBzbWIzX2ZzX3NzX2luZm8pOwogCX0gZWxzZSB7Ci0JCWNpZnNfZGJnKEZZ
SSwgIkludmFsaWQgcWZzaW5mbyBsZXZlbCAlZCIsIGxldmVsKTsKKwkJY2lmc19kYmcoRllJLCAi
SW52YWxpZCBxZnNpbmZvIGxldmVsICVkXG4iLCBsZXZlbCk7CiAJCXJldHVybiAtRUlOVkFMOwog
CX0KIApAQCAtMjM5Miw2ICsyMzk1LDEzIEBAIFNNQjJfUUZTX2F0dHIoY29uc3QgdW5zaWduZWQg
aW50IHhpZCwgc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwKIAllbHNlIGlmIChsZXZlbCA9PSBGU19E
RVZJQ0VfSU5GT1JNQVRJT04pCiAJCW1lbWNweSgmdGNvbi0+ZnNEZXZJbmZvLCA0IC8qIFJGQzEw
MDEgbGVuICovICsgb2Zmc2V0CiAJCQkrIChjaGFyICopJnJzcC0+aGRyLCBzaXplb2YoRklMRV9T
WVNURU1fREVWSUNFX0lORk8pKTsKKwllbHNlIGlmIChsZXZlbCA9PSBGU19TRUNUT1JfU0laRV9J
TkZPUk1BVElPTikgeworCQlzdHJ1Y3Qgc21iM19mc19zc19pbmZvICpzc19pbmZvID0gKHN0cnVj
dCBzbWIzX2ZzX3NzX2luZm8gKikKKwkJCSg0IC8qIFJGQzEwMDEgbGVuICovICsgb2Zmc2V0ICsg
KGNoYXIgKikmcnNwLT5oZHIpOworCQl0Y29uLT5zc19mbGFncyA9IGxlMzJfdG9fY3B1KHNzX2lu
Zm8tPkZsYWdzKTsKKwkJdGNvbi0+cGVyZl9zZWN0b3Jfc2l6ZSA9CisJCQlsZTMyX3RvX2NwdShz
c19pbmZvLT5QaHlzaWNhbEJ5dGVzUGVyU2VjdG9yRm9yUGVyZik7CisJfQogCiBxZnNhdHRyX2V4
aXQ6CiAJZnJlZV9yc3BfYnVmKHJlc3BfYnVmdHlwZSwgaW92Lmlvdl9iYXNlKTsKZGlmZiAtLWdp
dCBhL2ZzL2NpZnMvc21iMnBkdS5oIGIvZnMvY2lmcy9zbWIycGR1LmgKaW5kZXggYzdjM2M4Mi4u
N2U0NGYxOCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9zbWIycGR1LmgKKysrIGIvZnMvY2lmcy9zbWIy
cGR1LmgKQEAgLTg3NywxNCArODc3LDE2IEBAIHN0cnVjdCBzbWIyX2xlYXNlX2FjayB7CiAKIC8q
IEZpbGUgU3lzdGVtIEluZm9ybWF0aW9uIENsYXNzZXMgKi8KICNkZWZpbmUgRlNfVk9MVU1FX0lO
Rk9STUFUSU9OCQkxIC8qIFF1ZXJ5ICovCi0jZGVmaW5lIEZTX0xBQkVMX0lORk9STUFUSU9OCQky
IC8qIFNldCAqLworI2RlZmluZSBGU19MQUJFTF9JTkZPUk1BVElPTgkJMiAvKiBMb2NhbCBvbmx5
ICovCiAjZGVmaW5lIEZTX1NJWkVfSU5GT1JNQVRJT04JCTMgLyogUXVlcnkgKi8KICNkZWZpbmUg
RlNfREVWSUNFX0lORk9STUFUSU9OCQk0IC8qIFF1ZXJ5ICovCiAjZGVmaW5lIEZTX0FUVFJJQlVU
RV9JTkZPUk1BVElPTgk1IC8qIFF1ZXJ5ICovCiAjZGVmaW5lIEZTX0NPTlRST0xfSU5GT1JNQVRJ
T04JCTYgLyogUXVlcnksIFNldCAqLwogI2RlZmluZSBGU19GVUxMX1NJWkVfSU5GT1JNQVRJT04J
NyAvKiBRdWVyeSAqLwogI2RlZmluZSBGU19PQkpFQ1RfSURfSU5GT1JNQVRJT04JOCAvKiBRdWVy
eSwgU2V0ICovCi0jZGVmaW5lIEZTX0RSSVZFUl9QQVRIX0lORk9STUFUSU9OCTkgLyogUXVlcnkg
Ki8KKyNkZWZpbmUgRlNfRFJJVkVSX1BBVEhfSU5GT1JNQVRJT04JOSAvKiBMb2NhbCBvbmx5ICov
CisjZGVmaW5lIEZTX1ZPTFVNRV9GTEFHU19JTkZPUk1BVElPTgkxMCAvKiBMb2NhbCBvbmx5ICov
CisjZGVmaW5lIEZTX1NFQ1RPUl9TSVpFX0lORk9STUFUSU9OCTExIC8qIFNNQjMgb3IgbGF0ZXIu
IFF1ZXJ5ICovCiAKIHN0cnVjdCBzbWIyX2ZzX2Z1bGxfc2l6ZV9pbmZvIHsKIAlfX2xlNjQgVG90
YWxBbGxvY2F0aW9uVW5pdHM7CkBAIC04OTQsNiArODk2LDIyIEBAIHN0cnVjdCBzbWIyX2ZzX2Z1
bGxfc2l6ZV9pbmZvIHsKIAlfX2xlMzIgQnl0ZXNQZXJTZWN0b3I7CiB9IF9fcGFja2VkOwogCisj
ZGVmaW5lIFNTSU5GT19GTEFHU19BTElHTkVEX0RFVklDRQkJMHgwMDAwMDAwMQorI2RlZmluZSBT
U0lORk9fRkxBR1NfUEFSVElUSU9OX0FMSUdORURfT05fREVWSUNFIDB4MDAwMDAwMDIKKyNkZWZp
bmUgU1NJTkZPX0ZMQUdTX05PX1NFRUtfUEVOQUxUWQkJMHgwMDAwMDAwNAorI2RlZmluZSBTU0lO
Rk9fRkxBR1NfVFJJTV9FTkFCTEVECQkweDAwMDAwMDA4CisKKy8qIHNlY3RvciBzaXplIGluZm8g
c3RydWN0ICovCitzdHJ1Y3Qgc21iM19mc19zc19pbmZvIHsKKwlfX2xlMzIgTG9naWNhbEJ5dGVz
UGVyU2VjdG9yOworCV9fbGUzMiBQaHlzaWNhbEJ5dGVzUGVyU2VjdG9yRm9yQXRvbWljaXR5Owor
CV9fbGUzMiBQaHlzaWNhbEJ5dGVzUGVyU2VjdG9yRm9yUGVyZjsKKwlfX2xlMzIgRmlsZVN5c3Rl
bUVmZmVjdGl2ZVBoeXNpY2FsQnl0ZXNQZXJTZWN0b3JGb3JBdG9taWNpdHk7CisJX19sZTMyIEZs
YWdzOworCV9fbGUzMiBCeXRlT2Zmc2V0Rm9yU2VjdG9yQWxpZ25tZW50OworCV9fbGUzMiBCeXRl
T2Zmc2V0Rm9yUGFydGl0aW9uQWxpZ25tZW50OworfSBfX3BhY2tlZDsKKwogLyogcGFydGlhbCBs
aXN0IG9mIFFVRVJZIElORk8gbGV2ZWxzICovCiAjZGVmaW5lIEZJTEVfRElSRUNUT1JZX0lORk9S
TUFUSU9OCTEKICNkZWZpbmUgRklMRV9GVUxMX0RJUkVDVE9SWV9JTkZPUk1BVElPTiAyCi0tIAox
LjcuMTAuNAoK
--001a11343f7efb5bdc04e8598542--
