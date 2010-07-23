From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the workqueues tree with the Linus'
 tree
Date: Fri, 23 Jul 2010 14:46:00 +1000
Message-ID: <20100723144600.dd4da992.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi Tejun,

Today's linux-next merge of the workqueues tree got a conflict in
fs/cifs/cifsfs.c between commit 4c0c03ca54f72fdd5912516ad0a23ec5cf01bda7
("CIFS: Fix a malicious redirect problem in the DNS lookup code") from
Linus' tree and commit 9b646972467fb5fdc677f9e4251875db20bdbb64 ("cifs:
use workqueue instead of slow-work") from the workqueues tree.

I fixed it up (I think - I removed the call to cifs_exit_dns_resolver()
as there is no way to get to that code any more) and can carry the fix
for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
