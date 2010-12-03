From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for December 3 (cifs)
Date: Fri, 3 Dec 2010 09:48:44 -0800
Message-ID: <20101203094844.68f2bc40.randy.dunlap@oracle.com>
References: <20101203130440.9f89dd31.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-cifs@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Steve French <sfrench@samba.org>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20101203130440.9f89dd31.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, 3 Dec 2010 13:04:40 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20101202:


When CIFS_EXPERIMENTAL is not enabled:

(.text+0xdf6c9): undefined reference to `get_cifs_acl'

from fs/cifs/xattr.c:cifs_getxattr()


CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
CONFIG_CIFS_FSCACHE=y
CONFIG_CIFS_ACL=y
# CONFIG_CIFS_EXPERIMENTAL is not set


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
