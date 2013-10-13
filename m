From: Tim Gardner <tim.gardner@canonical.com>
Subject: [PATCH 3.12-rc4] cifs: ntstatus_to_dos_map[] is not terminated
Date: Sun, 13 Oct 2013 13:29:03 -0600
Message-ID: <1381692543-41226-1-git-send-email-tim.gardner@canonical.com>
Cc: Tim Gardner <tim.gardner@canonical.com>,
	Steve French <sfrench@samba.org>
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Functions that walk the ntstatus_to_dos_map[] array could
run off the end. For example, ntstatus_to_dos() loops
while ntstatus_to_dos_map[].ntstatus is not 0. Granted,
this is mostly theoretical, but could be used as a DOS attack
if the error code in the SMB header is bogus.

Cc: Steve French <sfrench@samba.org>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 fs/cifs/netmisc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index af847e1..651a527 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -780,7 +780,9 @@ static const struct {
 	ERRDOS, ERRnoaccess, 0xc0000290}, {
 	ERRDOS, ERRbadfunc, 0xc000029c}, {
 	ERRDOS, ERRsymlink, NT_STATUS_STOPPED_ON_SYMLINK}, {
-	ERRDOS, ERRinvlevel, 0x007c0001}, };
+	ERRDOS, ERRinvlevel, 0x007c0001}, {
+	0, 0, 0 }
+};
 
 /*****************************************************************************
  Print an error message from the status code
-- 
1.7.9.5
