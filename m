From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the workqueues tree with the cifs tree
Date: Fri, 23 Jul 2010 14:46:04 +1000
Message-ID: <20100723144604.fe57e4bd.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Suresh Jayaraman <sjayaraman@suse.de>,
	Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi Tejun,

Today's linux-next merge of the workqueues tree got a conflict in
fs/cifs/cifsglob.h between commit
1626bccfc79b354aa47cbfc5c8d39f7be8823eb4 ("cifs: guard cifsglob.h against
multiple inclusion") from the cifs tree and commit
9b646972467fb5fdc677f9e4251875db20bdbb64 ("cifs: use workqueue instead of
slow-work") from the workqueues tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/cifs/cifsglob.h
index 9b7cf9a,f5a1f9b..0000000
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@@ -727,6 -732,6 +727,8 @@@ GLOBAL_EXTERN unsigned int cifs_min_rcv
  GLOBAL_EXTERN unsigned int cifs_min_small;  /* min size of small buf pool */
  GLOBAL_EXTERN unsigned int cifs_max_pending; /* MAX requests at once to server*/
  
- extern const struct slow_work_ops cifs_oplock_break_ops;
+ void cifs_oplock_break(struct work_struct *work);
+ void cifs_oplock_break_get(struct cifsFileInfo *cfile);
+ void cifs_oplock_break_put(struct cifsFileInfo *cfile);
 +
 +#endif	/* _CIFS_GLOB_H */
