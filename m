From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 13/15] cifs: convert cifsFileInfo->count to non-atomic
 counter
Date: Thu, 7 Oct 2010 14:05:44 -0400
Message-ID: <20101007180544.GA18764@lst.de>
References: <1286394857-32541-1-git-send-email-jlayton@redhat.com>
 <1286394857-32541-14-git-send-email-jlayton@redhat.com>
 <4CAD8972.9090406@suse.de>
 <20101007071819.2446312b@barsoom.rdu.redhat.com>
 <4CADB949.2070205@suse.de>
 <20101007084334.0e03f586@barsoom.rdu.redhat.com>
 <AANLkTi=MMzU6nr6+19PKW=gPKTdk9e-O5pjrYWmbV4AJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTi=MMzU6nr6+19PKW=gPKTdk9e-O5pjrYWmbV4AJ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Oct 07, 2010 at 10:37:54AM -0500, Steve French wrote:
> 
> I doubt that a spinlock vs. a rwlock makes much difference,
> but a rwlock lock for list insertion/removal seems more intuitive
> and overloading it to also protect a counter adds complexity.
> Seems more natural to leave it as an atomic counter.

The rwlock here is rather non-sensical.  A shared/exclusie lock only
makes sense if the critical section is large enough to actually
benefit from concurrency.  With a short critical section like here
you still pay the same price in terms of cache line effects, and
operations on rwlocks actually are more expensive than on a normal
spinlock.  We don't actually hae a lot of places where the plain
rwlock makes any sense at all - if there's enough reason for concurreny
you're better off doing RCU locking anyway.
