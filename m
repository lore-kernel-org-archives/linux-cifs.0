From: Jeff Layton <jlayton@samba.org>
Subject: Re: system_nrt_wq, system suspend, and the freezer
Date: Thu, 16 Feb 2012 13:59:45 -0500
Message-ID: <20120216135945.3dd3893a@samba.org>
References: <Pine.LNX.4.44L0.1202160930010.1268-100000@iolanthe.rowland.org>
	<20120216102728.230b99ba@poochiereds.net>
	<20120216162951.GF24986@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Alan Stern <stern@rowland.harvard.edu>,
	Steve French <sfrench@samba.org>, Chris Ball <cjb@laptop.org>,
	David Airlie <airlied@linux.ie>,
	David Howells <dhowells@redhat.com>,
	Linux-pm mailing list <linux-pm@vger.kernel.org>,
	linux-cifs@vger.kernel.org, linux-mmc@vger.kernel.org,
	dri-devel@lists.freedesktop.org, keyrings@linux-nfs.org
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <20120216162951.GF24986@google.com>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, 16 Feb 2012 08:29:51 -0800
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Thu, Feb 16, 2012 at 10:27:28AM -0500, Jeff Layton wrote:
> > These should  all be freezable and we might even be able to get away
> > with WQ_UNBOUND for some of these.
> 
> In general, I would recommend specifying as few special attribute as
> possible.  If WQ_UNBOUND is necessary (large amount of CPU cycles
> consumed, extremely high concurrency), sure, but I think we're
> generally better off using as default attributes as possible.  It just
> makes things much easier later when we need to implement new features
> or update the implementation.
> 

Ok, fair enough. Probably no need to make it unbound...

> > I think we put most of these in system_nrt_wq because Tejun put an
> > earlier job into that queue when he converted it from slow_work and we
> > just cargo-cult copied that...
> > 
> > I'll spend some time looking at this in the next day or two, but I
> > suspect that the right answer is to just move these off of the "public"
> > workqueues altogether.
> 
> If freezing & nrt is everything necessary, just create
> system_nrt_freezable_wq and use that.
> 

The other problem here is that we really ought to be submitting the
write completion handler to a workqueue that has WQ_MEM_RECLAIM set.
Since none of the public wq's have that then I guess we'll have to make
our own?

-- 
Jeff Layton <jlayton@samba.org>
