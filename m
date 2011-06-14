From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] cifs: invalidate any mapped pages
	before turning cache off
Date: Tue, 14 Jun 2011 16:44:09 +0100
Message-ID: <14229.1308066249@redhat.com>
References: <4DF778F6.3040704@suse.de>
Reply-To: Linux filesystem caching discussion list <linux-cachefs@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench@gmail.com>, linux-cachefs@redhat.com,
        linux-cifs <linux-cifs@vger.kernel.org>
To: Suresh Jayaraman <sjayaraman@suse.de>
Return-path: <linux-cachefs-bounces@redhat.com>
In-Reply-To: <4DF778F6.3040704@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-cachefs>,
	<mailto:linux-cachefs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-cachefs>
List-Post: <mailto:linux-cachefs@redhat.com>
List-Help: <mailto:linux-cachefs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-cachefs>,
	<mailto:linux-cachefs-request@redhat.com?subject=subscribe>
Sender: linux-cachefs-bounces@redhat.com
Errors-To: linux-cachefs-bounces@redhat.com
List-Id: linux-cifs.vger.kernel.org

Suresh Jayaraman <sjayaraman@suse.de> wrote:

> When disabling inode cookie, we were returning the cookie and setting
> cifsi->fscache to NULL but failed to invalidate any previously mapped
> pages. This resulted in "Bad page state" errors and manifested in other
> kind of errors when running fsstress. Fix it by invalidating mapped
> pages when we disable the inode cookie.
> 
> Also make cifs_fscache_disable_inode_cookie() return error if
> invalidate_inode_pages2() fails

I think I see what's going on: you have to 'hand back' all the page-in-use
marks before calling fscache_relinquish_cookie().  One way to do that is to
call invalidate_inode_pages2() or similar; the other is to iterate over all
the pages attached to your inode and call cifs_fscache_invalidate_page() on
every page.  Note that this may sleep to achieve its aim of getting rid of the
mark.

Let me have a go at whipping up a patch to do this.  It looks like it belongs
in fscache really as a helper function.

FS-Cache assumes that *you* know where all your pages are, and so it would be
redundant for it to keep its own list and thus keep extra memory around that
isn't strictly necessary.

Note also that:

	void cifs_fscache_set_inode_cookie(struct inode *inode, struct file *filp)
	{
		if ((filp->f_flags & O_ACCMODE) != O_RDONLY)
			cifs_fscache_disable_inode_cookie(inode);
		else
			cifs_fscache_enable_inode_cookie(inode);
	}

doesn't actually work right (and should be fixed in NFS too).  Imagine you
have a file open for read-only and you open it again for read-write or vice
versa.  This really needs a counter of writers.

David
