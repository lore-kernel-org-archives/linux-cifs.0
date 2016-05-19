From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the vfs tree with the cifs tree
Date: Fri, 20 May 2016 09:41:35 +1000
Message-ID: <20160520094135.716833cb@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>,
	Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in:

  fs/cifs/cifsfs.c

between commit:

  56c1d814aadf ("CIFS: Remove some obsolete comments")

from the cifs tree and commit:

  51085a1f913a ("cifs: use C99 syntax for inode_operations initializer")

from the vfs tree.

This was entirely expected.  Al, if its easy, you could just drop that
patch from the vfs tree.

I fixed it up (I just used the version from the cifs tree) and can
carry the fix as necessary. This is now fixed as far as linux-next is
concerned, but any non trivial conflicts should be mentioned to your
upstream maintainer when your tree is submitted for merging.  You may
also want to consider cooperating with the maintainer of the conflicting
tree to minimise any particularly complex conflicts.

-- 
Cheers,
Stephen Rothwell
