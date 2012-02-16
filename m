From: Tejun Heo <tj@kernel.org>
Subject: Re: system_nrt_wq, system suspend, and the freezer
Date: Thu, 16 Feb 2012 08:25:29 -0800
Message-ID: <20120216162529.GD24986@google.com>
References: <Pine.LNX.4.44L0.1202160930010.1268-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <sfrench@samba.org>, Chris Ball <cjb@laptop.org>,
	David Airlie <airlied@linux.ie>,
	David Howells <dhowells@redhat.com>,
	Linux-pm mailing list <linux-pm@vger.kernel.org>,
	linux-cifs@vger.kernel.org, linux-mmc@vger.kernel.org,
	dri-devel@lists.freedesktop.org, keyrings@linux-nfs.org,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>
To: Alan Stern <stern@rowland.harvard.edu>
Return-path: <linux-mmc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1202160930010.1268-100000@iolanthe.rowland.org>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hello, (cc'ing Rafael and Jens)

On Thu, Feb 16, 2012 at 09:41:34AM -0500, Alan Stern wrote:
> My question to all of you: Should system_nrt_wq be made freezable, or 
> should I create a new workqueue that is both freezable and 
> non-reentrant?  And if I do, which of the usages above should be 
> converted to the new workqueue?

Let's make it explicit that the wq is freezable.  I'm a bit
uncomfortable with the way it's headed.  What we should be doing is
implementing plugging of request queue for all regular requests while
suspend is in progress and then annotate the ones which should go
through.  We're trying to do it the other way around.

Also, in general, I don't think using freezing widely for kernel
threads / wqs is a good idea.  Plugging device access at subsystem
layer should cover most cases and we have notifiers to implement such
support and to handle special cases.  There are even code paths which
try to determine whether system went through PM operation by looking
at whether %current went through the freezer.  IMHO, we'll be better
off with removing freezer support for kthreads.  :(

Thanks.

-- 
tejun
