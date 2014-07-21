From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
Subject: [PATCH linux-next] cifs: remove unused function cifs_oplock_break_wait
Date: Mon, 21 Jul 2014 23:47:36 +0200
Message-ID: <1405979256-8921-1-git-send-email-vincent.stehle@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	=?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
	Steve French <sfrench@samba.org>
To: linux-next@vger.kernel.org, linux-cifs@vger.kernel.org
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Commit 743162013d40 ("sched: Remove proliferation of wait_on_bit() acti=
on
functions") has removed the call to cifs_oplock_break_wait, making this
function unused; remove it.

This fixes the following compilation warning:

  fs/cifs/misc.c:578:1: warning: =E2=80=98cifs_oplock_break_wait=E2=80=99=
 defined but not used [-Wunused-function]

Signed-off-by: Vincent Stehl=C3=A9 <vincent.stehle@laposte.net>
Cc: Steve French <sfrench@samba.org>
---

Hi,

This can be seen with e.g. linux next-20140721 and arm allmodconfig.

Best regards,

V.

 fs/cifs/misc.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 9a70792..65c2682 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -574,13 +574,6 @@ void cifs_set_oplock_level(struct cifsInodeInfo *c=
inode, __u32 oplock)
 		cinode->oplock =3D 0;
 }
=20
-static int
-cifs_oplock_break_wait(void *unused)
-{
-	schedule();
-	return signal_pending(current) ? -ERESTARTSYS : 0;
-}
-
 /*
  * We wait for oplock breaks to be processed before we attempt to perf=
orm
  * writes.
--=20
2.0.1
