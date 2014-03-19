From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH] cifs: Fix possible deadlock with cifs and work
 queues
Date: Wed, 19 Mar 2014 15:43:39 -0400
Message-ID: <20140319154339.44c327e3@gandalf.local.home>
References: <20140319151252.16ed3ac6@gandalf.local.home>
	<20140319193407.GA11257@laptop.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org,
	Steve French <sfrench@samba.org>,
	Clark Williams <williams@redhat.com>,
	"Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Tejun Heo <tj@kernel.org>, uobergfe@redhat.com
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140319193407.GA11257@laptop.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Wed, 19 Mar 2014 20:34:07 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Mar 19, 2014 at 03:12:52PM -0400, Steven Rostedt wrote:
> > My question to Tejun is, if we create another workqueue, to add the
> > rdata->work to, would that prevent the above problem? Or what other
> > fixes can we do?
> 
> The way I understand workqueues is that we cannot guarantee concurrency
> like this. It tries, but there's no guarantee.
> 
> WQ_MAX_ACTIVE seems to be a hard upper limit of concurrent workers. So
> given 511 other blocked works, the described problem will always happen.
> 
> Creating another workqueue doesn't actually create more threads.

But I noticed this:

 Before patch:

# ps aux |grep cifs
root      3119  0.0  0.0      0     0 ?        S<   14:17   0:00 [cifsiod]

 After patch:

# ps aux |grep cifs
root      1109  0.0  0.0      0     0 ?        S<   15:11   0:00 [cifsiod]
root      1111  0.0  0.0      0     0 ?        S<   15:11   0:00 [cifsiord]

It looks to me that it does create new threads.

-- Steve


> 
> There is the kthread_work stuff for if you want a guaranteed worker
> thread.
