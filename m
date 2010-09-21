From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the bkl-vfs tree with the cifs tree
Date: Tue, 21 Sep 2010 16:10:31 +1000
Message-ID: <20100921161031.7745150e.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>,
	Steve French <smfrench@gmail.com>,
	<linux-cifs@vger.kernel.org>, Jan Blunck <jblunck@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi Arnd,

Today's linux-next merge of the bkl-vfs tree got a conflict in
fs/cifs/cifsfs.c between commit d090dbeacd3763845d83d5de4d85aad025a28677
("cifs: Allow binding to local IP address") from the cifs tree and commit
b8f05b0b9ea89cfaf6759b1eb47fff683e7016a5 ("BKL: Remove BKL from CifsFS")
from the bkl-vfs tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/cifs/cifsfs.c
index 52e89ea,4e273f7..0000000
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@@ -35,8 -35,6 +35,7 @@@
  #include <linux/delay.h>
  #include <linux/kthread.h>
  #include <linux/freezer.h>
- #include <linux/smp_lock.h>
 +#include <net/ipv6.h>
  #include "cifsfs.h"
  #include "cifspdu.h"
  #define DECLARE_GLOBALS_HERE
