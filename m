From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 3/4] sunrpc: make rpc_wait_bit_killable handle freeze events
Date: Wed, 28 Sep 2011 07:52:40 -0400
Message-ID: <1317210761-11518-4-git-send-email-jlayton@redhat.com>
References: <1317210761-11518-1-git-send-email-jlayton@redhat.com>
Cc: linux-pm@lists.linux-foundation.org, linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org, john@Calva.COM,
	linux-kernel@vger.kernel.org
To: trond.myklebust@netapp.com, smfrench@gmail.com, pavel@ucw.cz,
	rjw@sisk.pl
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1317210761-11518-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Allow the wait_on_bit_killable sleeps in SUNRPC layer to respect the
freezer. This should allow suspend and hibernate events to occur, even
when there are RPC's pending on the wire.

Tested-by: John Hughes <john@Calva.COM>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 net/sunrpc/sched.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index d12ffa5..09bb64e 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -18,6 +18,7 @@
 #include <linux/smp.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
+#include <linux/freezer.h>
 
 #include <linux/sunrpc/clnt.h>
 
@@ -231,7 +232,8 @@ static int rpc_wait_bit_killable(void *word)
 {
 	if (fatal_signal_pending(current))
 		return -ERESTARTSYS;
-	schedule();
+	if (!try_to_freeze())
+		schedule();
 	return 0;
 }
 
-- 
1.7.6.2
