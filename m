From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: silence compiler warnings showing up with gcc-4.7.0
Date: Mon, 26 Mar 2012 09:55:29 -0400
Message-ID: <1332770129-23118-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

gcc-4.7.0 has started throwing these warnings when building cifs.ko.

  CC [M]  fs/cifs/cifssmb.o
fs/cifs/cifssmb.c: In function =E2=80=98CIFSSMBSetCIFSACL=E2=80=99:
fs/cifs/cifssmb.c:3905:9: warning: array subscript is above array bound=
s [-Warray-bounds]
fs/cifs/cifssmb.c: In function =E2=80=98CIFSSMBSetFileInfo=E2=80=99:
fs/cifs/cifssmb.c:5711:8: warning: array subscript is above array bound=
s [-Warray-bounds]
fs/cifs/cifssmb.c: In function =E2=80=98CIFSSMBUnixSetFileInfo=E2=80=99=
:
fs/cifs/cifssmb.c:6001:25: warning: array subscript is above array boun=
ds [-Warray-bounds]

This patch cleans up the code a bit by using the offsetof macro instead
of the funky "&pSMB->hdr.Protocol" construct.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifssmb.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 8fecc99..f52c5ab 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3892,13 +3892,12 @@ CIFSSMBSetCIFSACL(const int xid, struct cifs_tc=
on *tcon, __u16 fid,
 	int rc =3D 0;
 	int bytes_returned =3D 0;
 	SET_SEC_DESC_REQ *pSMB =3D NULL;
-	NTRANSACT_RSP *pSMBr =3D NULL;
+	void *pSMBr;
=20
 setCifsAclRetry:
-	rc =3D smb_init(SMB_COM_NT_TRANSACT, 19, tcon, (void **) &pSMB,
-			(void **) &pSMBr);
+	rc =3D smb_init(SMB_COM_NT_TRANSACT, 19, tcon, (void **) &pSMB, &pSMB=
r);
 	if (rc)
-			return (rc);
+		return rc;
=20
 	pSMB->MaxSetupCount =3D 0;
 	pSMB->Reserved =3D 0;
@@ -3926,9 +3925,8 @@ setCifsAclRetry:
 	pSMB->AclFlags =3D cpu_to_le32(aclflag);
=20
 	if (pntsd && acllen) {
-		memcpy((char *) &pSMBr->hdr.Protocol + data_offset,
-			(char *) pntsd,
-			acllen);
+		memcpy((char *)pSMBr + offsetof(struct smb_hdr, Protocol) +
+				data_offset, pntsd, acllen);
 		inc_rfc1001_len(pSMB, byte_count + data_count);
 	} else
 		inc_rfc1001_len(pSMB, byte_count);
@@ -5708,7 +5706,8 @@ CIFSSMBSetFileInfo(const int xid, struct cifs_tco=
n *tcon,
 	param_offset =3D offsetof(struct smb_com_transaction2_sfi_req, Fid) -=
 4;
 	offset =3D param_offset + params;
=20
-	data_offset =3D (char *) (&pSMB->hdr.Protocol) + offset;
+	data_offset =3D (char *)pSMB +
+			offsetof(struct smb_hdr, Protocol) + offset;
=20
 	count =3D sizeof(FILE_BASIC_INFO);
 	pSMB->MaxParameterCount =3D cpu_to_le16(2);
@@ -5977,7 +5976,7 @@ CIFSSMBUnixSetFileInfo(const int xid, struct cifs=
_tcon *tcon,
 		       u16 fid, u32 pid_of_opener)
 {
 	struct smb_com_transaction2_sfi_req *pSMB  =3D NULL;
-	FILE_UNIX_BASIC_INFO *data_offset;
+	char *data_offset;
 	int rc =3D 0;
 	u16 params, param_offset, offset, byte_count, count;
=20
@@ -5999,8 +5998,9 @@ CIFSSMBUnixSetFileInfo(const int xid, struct cifs=
_tcon *tcon,
 	param_offset =3D offsetof(struct smb_com_transaction2_sfi_req, Fid) -=
 4;
 	offset =3D param_offset + params;
=20
-	data_offset =3D (FILE_UNIX_BASIC_INFO *)
-				((char *)(&pSMB->hdr.Protocol) + offset);
+	data_offset =3D (char *)pSMB +
+			offsetof(struct smb_hdr, Protocol) + offset;
+
 	count =3D sizeof(FILE_UNIX_BASIC_INFO);
=20
 	pSMB->MaxParameterCount =3D cpu_to_le16(2);
@@ -6022,7 +6022,7 @@ CIFSSMBUnixSetFileInfo(const int xid, struct cifs=
_tcon *tcon,
 	inc_rfc1001_len(pSMB, byte_count);
 	pSMB->ByteCount =3D cpu_to_le16(byte_count);
=20
-	cifs_fill_unix_set_info(data_offset, args);
+	cifs_fill_unix_set_info((FILE_UNIX_BASIC_INFO *)data_offset, args);
=20
 	rc =3D SendReceiveNoRsp(xid, tcon->ses, (char *) pSMB, 0);
 	if (rc)
--=20
1.7.7.6
