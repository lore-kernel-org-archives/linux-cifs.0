From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 02/10] locks: have locks_release_file use
 flock_lock_file to release generic flock locks
Date: Fri, 9 Jan 2015 06:27:23 -0800
Message-ID: <20150109142723.GA30294@infradead.org>
References: <1420742065-28423-1-git-send-email-jlayton@primarydata.com>
 <1420742065-28423-3-git-send-email-jlayton@primarydata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
	ceph-devel@vger.kernel.org, hch@infradead.org
To: Jeff Layton <jlayton@primarydata.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1420742065-28423-3-git-send-email-jlayton@primarydata.com>
Sender: ceph-devel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, Jan 08, 2015 at 10:34:17AM -0800, Jeff Layton wrote:
> ...instead of open-coding it and removing flock locks directly. This
> simplifies some coming interim changes in the following patches when
> we have different file_lock types protected by different spinlocks.

It took me quite a while to figure out what's going on here, as this
adds a call to flock_lock_file, but it still keeps the old open coded
loop around, just with a slightly different WARN_ON.

I'd suggest keeping an open coded loop in locks_remove_flock, which
should both be more efficient and easier to review.

