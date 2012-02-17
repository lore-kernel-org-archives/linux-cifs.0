From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Block: use a freezable workqueue for disk-event polling
Date: Fri, 17 Feb 2012 13:52:04 -0800
Message-ID: <20120217215204.GH29414@google.com>
References: <20120216102728.230b99ba@poochiereds.net>
 <Pine.LNX.4.44L0.1202171615550.1194-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
	Steve French <sfrench@samba.org>, Chris Ball <cjb@laptop.org>,
	Jeff Layton <jlayton@poochiereds.net>,
	David Airlie <airlied@linux.ie>,
	David Howells <dhowells@redhat.com>,
	Linux-pm mailing list <linux-pm@vger.kernel.org>,
	linux-cifs@vger.kernel.org, linux-mmc@vger.kernel.org,
	dri-devel@lists.freedesktop.org, keyrings@linux-nfs.org
To: Alan Stern <stern@rowland.harvard.edu>
Return-path: <linux-mmc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1202171615550.1194-100000@iolanthe.rowland.org>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, Feb 17, 2012 at 04:22:13PM -0500, Alan Stern wrote:
> This patch (as1519) fixes a bug in the block layer's disk-events
> polling.  The polling is done by a work routine queued on the
> system_nrt_wq workqueue.  Since that workqueue isn't freezable, the
> polling continues even in the middle of a system sleep transition.
> 
> Obviously, polling a suspended drive for media changes and such isn't
> a good thing to do; in the case of USB mass-storage devices it can
> lead to real problems requiring device resets and even re-enumeration.
> 
> The patch fixes things by creating a new system-wide, non-reentrant,
> freezable workqueue and using it for disk-events polling.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> CC: Tejun Heo <tj@kernel.org>
> CC: <stable@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks!

-- 
tejun
