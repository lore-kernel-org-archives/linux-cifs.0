From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH] cifs: Fix possible deadlock with cifs and work
 queues
Date: Thu, 20 Mar 2014 22:19:13 -0400
Message-ID: <20140320221913.104b275d@gandalf.local.home>
References: <20140319151252.16ed3ac6@gandalf.local.home>
	<20140320195346.0876e175@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org,
	Steve French <sfrench@samba.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Clark Williams <williams@redhat.com>,
	"Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Tejun Heo <tj@kernel.org>, uobergfe@redhat.com
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140320195346.0876e175@tlielax.poochiereds.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, 20 Mar 2014 19:53:46 -0400
Jeff Layton <jlayton@redhat.com> wrote:
 
> Wait...why does the work running on CPU1 end up blocked on down_read()?
> Is it really getting stuck on the down_write you mention?
> 

rwsems are fair locks. Readers will not block on a reader lock unless
there's a writer waiting. That's the key. As soon as a writer blocks on
a lock that is held by a reader (or multiple readers), new readers
coming in will also block to let the writer get a chance. Otherwise, it
is a unfair lock and the readers can starve the writer.

But people tend to forget that a waiting writer causes readers to block
on each other, and if the reader locks can deadlock each other, they
will deadlock with a writer waiting.

-- Steve
