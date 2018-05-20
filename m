From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCHv2][SMB3] Add kernel trace support
Date: Mon, 21 May 2018 09:17:44 +1000
Message-ID: <20180520231744.GM10363@dastard>
References: <CAH2r5muobq1gDbGcPE1AYeeKmdFx681=mpCyAZWfSPUa5wLjSQ@mail.gmail.com>
 <20180518184630.axfa7oq4pewb7foj@kazak>
 <CAH2r5muu0Hjx1SwMKm5aRLRa2Cwh6tQ7y0h33C07kkPbkhswFw@mail.gmail.com>
 <20180519232257.GL10363@dastard>
 <CAH2r5mtFtX4t9-xFRh62DRv=09TJjF2Z6JkbXXF3siaHqZuY2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Ralph =?iso-8859-1?Q?B=F6hme?= <slow@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5mtFtX4t9-xFRh62DRv=09TJjF2Z6JkbXXF3siaHqZuY2A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Sat, May 19, 2018 at 08:56:39PM -0500, Steve French wrote:
> On Sat, May 19, 2018 at 6:22 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, May 18, 2018 at 01:43:14PM -0700, Steve French wrote:
> >> On Fri, May 18, 2018 at 11:46 AM, Ralph Böhme <slow@samba.org> wrote:
> >> > On Thu, May 17, 2018 at 09:36:36PM -0500, Steve French via samba-technical wrote:
> >> >> Patch updated with additional tracepoint locations and some formatting
> >> >> improvements. There are some obvious additional tracepoints that could
> >> >> be added, but this should be a reasonable group to start with.
> >> >>
> >> >> From edc02d6f9dc24963d510c7ef59067428d3b082d3 Mon Sep 17 00:00:00 2001
> >> >> From: Steve French <stfrench@microsoft.com>
> >> >> Date: Thu, 17 May 2018 21:16:55 -0500
> >> >> Subject: [PATCH] smb3: Add ftrace tracepoints for improved SMB3 debugging
> >> >>
> >> >> Although dmesg logs and wireshark network traces can be
> >> >> helpful, being able to dynamically enable/disable tracepoints
> >> >> (in this case via the kernel ftrace mechanism) can also be
> >> >> helpful in more quickly debugging problems, and more
> >> >> selectively tracing the events related to the bug report.
> >> >>
> >> >> This patch adds 12 ftrace tracepoints to cifs.ko for SMB3 events
> >> >> in some obvious locations.  Subsequent patches will add more
> >> >> as needed.
> >> >>
> >> >> Example use:
> >> >>    trace-cmd record -e cifs
> >> >>    <run test case>
> >> >>    trace-cmd show
> >> >
> >> > pardon my ignorance, but are these tracepoints usable with other tracing
> >> > frameworks like Systemtap?
> >> >
> >> > Last time I checked, Systemtap looked like *the* tool.
> >
> > Systemtap is great when you have a need for custom tracing. But for
> > day-to-day kernel development, tracepoints are far more useful
> > because they are always there and can cover all the common
> > situations that you need to trace.
> >
> > And when it comes to debugging a one-off user problem when the user
> > knows nothing about systemtap?  Nothing beats asking the user
> > to run a trace on built-in tracepoints, reproduce the problem and
> > send the trace report back as per the above example.
> 
> Yep - it has already been helpful in debugging problems.
> 
> Main problem I hit using the new tracepoints over the past few days
> was entries being discarded from the buffer - I had a counter leak (now
> fixed) that xfstest showed ... but about 90% of the entries were dropped.
> Tried increasing buffer size but might have made things worse not better.
> Ideas how to force more entries to be saved?

The only tends to be a problem when you are generating events faster
than userspace can drain the kernel ring buffer. Generally speaking,
this happens when you try to trace too many events for userspace to
drain in the CPU time the kernel assigns it.

I'm guessing that tracing an interrupt driven workload like a
network protocol this is going to be more of a problem than
filesystems - it's the perennial "tcpdump/wireshark/etc cannot keep
up with the incoming packet rate" problem - increasing buffer sizes
never fixes that problem. :)

Storing the trace data output file on tmpfs can be helpful here, as
can reducing the number of events to just the layer you need info
from, filter the specific events you want to see (e.g. filter by
client/server connection, by process/CPU, etc), set up trigger
events so tracing doesn't start until you want it to, etc...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
