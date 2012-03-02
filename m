From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 00/11 v2] Push file_update_time() into .page_mkwrite
Date: Fri, 2 Mar 2012 10:41:22 +0100
Message-ID: <20120302094122.GA1744@quack.suse.cz>
References: <1330602103-8851-1-git-send-email-jack@suse.cz>
 <20120301232942.GH32588@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	LKML <linux-kernel@vger.kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
	dchinner@redhat.com, Jaya Kumar <jayalk@intworks.biz>,
	Sage Weil <sage@newdream.net>, ceph-devel@vger.kernel.org,
	Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	Eric Van Hensbergen <ericvh@gmail.com>,
	Ron Minnich <rminnich@sandia.gov>,
	Latchesar Ionkov <lucho@ionkov.net>,
	v9fs-developer@lists.sourceforge.net,
	Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net,
	Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20120301232942.GH32588@thunk.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-cifs.vger.kernel.org

On Thu 01-03-12 18:29:42, Ted Tso wrote:
> On Thu, Mar 01, 2012 at 12:41:34PM +0100, Jan Kara wrote:
> > 
> > To fix the issue, this patch set changes page fault code to call
> > file_update_time() only when ->page_mkwrite() callback is not provided. If the
> > callback is provided, it is the responsibility of the filesystem to perform
> > update of i_mtime / i_ctime if needed. We also push file_update_time() call
> > to all existing ->page_mkwrite() implementations if the time update does not
> > obviously happen by other means. If you know your filesystem does not need
> > update of modification times in ->page_mkwrite() handler, please speak up and
> > I'll drop the patch for your filesystem.
> 
> I don't know if this introductory text is going to be saved anywhere
> permanent, such as the merge commit (since git now has the ability to
> have much more informative merge descriptions).  But if it is going to
> be preserved, it might be worth mentioning that if the filesystem uses
> block_page_mkpage(), it will handled automatically for them since the
> patch series does push the call to file_update_time(0 into
> __block_page_mkpage().
  Good point, added to description.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
