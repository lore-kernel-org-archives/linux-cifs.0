From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: system_nrt_wq, system suspend, and the freezer
Date: Thu, 16 Feb 2012 11:58:21 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1202161155040.1268-100000@iolanthe.rowland.org>
References: <20120216164516.GJ24986@google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Steve French <sfrench@samba.org>, Chris Ball <cjb@laptop.org>,
	David Airlie <airlied@linux.ie>,
	David Howells <dhowells@redhat.com>,
	Linux-pm mailing list <linux-pm@vger.kernel.org>,
	<linux-cifs@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	<dri-devel@lists.freedesktop.org>, <keyrings@linux-nfs.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <20120216164516.GJ24986@google.com>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, 16 Feb 2012, Tejun Heo wrote:

> Hello,
> 
> On Thu, Feb 16, 2012 at 11:37:33AM -0500, Alan Stern wrote:
> > Um.  I don't think I can audit all the calls in the kernel that submit
> > block requests and determine which ones need to be allowed while a
> > system sleep is in progress.
> 
> ??? we need to do that anyway and the ones which should go through are
> much smaller than the ones which shouldn't go through.

Agreed.  I'm just saying that it's too big a job for me to handle by
myself.  And all the marking has to be done before you plug the
unmarked requests; otherwise you could break hibernation.


> > Well, there are some dedicated threads that exist for no other purpose
> > than to do I/O to devices and to handle hotplug/unplug events.  I don't
> > see any reason not allow such threads to be freezable.  It's a quick, 
> > convenient method for getting them out of the way.
> 
> Well, it's convenient to use incorrectly.  If you look at most of
> freezable kthreads, they're sadly broken.  I mean, a lot of kthread
> users don't even get kthread_should_stop() right.  With freezable()
> thrown into the mix, it seems hopeless.  With wq, it's better as
> freezing is handled by wq proper.  Even then, I don't know.  It just
> seems to lead people to think "ooh, I marked it freezable so I don't
> have to think about synchronization across PM events.  Freezer will
> magically solve this for me!".  :(

Certainly there are issues which need to be considered carefully.  That 
doesn't mean it should never be used.

Alan Stern

