From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH] cifs: Fix possible deadlock with cifs and work
 queues
Date: Fri, 21 Mar 2014 08:17:06 -0400
Message-ID: <20140321081706.271e390c@gandalf.local.home>
References: <20140319151252.16ed3ac6@gandalf.local.home>
	<20140320152833.216d81a0@tlielax.poochiereds.net>
	<20140320165703.522c7c5c@gandalf.local.home>
	<20140320170239.51d20a0e@tlielax.poochiereds.net>
	<20140320222343.4faaa137@gandalf.local.home>
	<CAKywueT4xRHZGomoPvnA9rob3FpzkPYuuUPe+vEDiOFvTbUiGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-cifs <linux-cifs@vger.kernel.org>,
	Steve French <sfrench@samba.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Clark Williams <williams@redhat.com>,
	"Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Tejun Heo <tj@kernel.org>, uobergfe@redhat.com
To: Pavel Shilovsky <piastry@etersoft.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKywueT4xRHZGomoPvnA9rob3FpzkPYuuUPe+vEDiOFvTbUiGA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, 21 Mar 2014 12:32:12 +0400
Pavel Shilovsky <piastry@etersoft.ru> wrote:


> Read and write codepaths both obtain lock_sem for read and then wait
> for cifsiod_wq to complete and release lock_sem. They don't do any
> lock_sem operations inside their work task queued to cifsiod_wq. But
> oplock code can obtain/release lock_sem in its work task. So, that's
> why I agree with Jeff and suggest to move the oplock code to a
> different work queue (cifsioopd_wq?) but leave read and write
> codepaths use cifsiod_wq.

OK, how about I submit a second patch that moves the reader and writer
to its own "safe" workqueue?

-- Steve
