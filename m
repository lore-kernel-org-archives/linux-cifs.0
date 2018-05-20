From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCHv2][SMB3] Add kernel trace support
Date: Sat, 19 May 2018 20:56:39 -0500
Message-ID: <CAH2r5mtFtX4t9-xFRh62DRv=09TJjF2Z6JkbXXF3siaHqZuY2A@mail.gmail.com>
References: <CAH2r5muobq1gDbGcPE1AYeeKmdFx681=mpCyAZWfSPUa5wLjSQ@mail.gmail.com>
 <20180518184630.axfa7oq4pewb7foj@kazak> <CAH2r5muu0Hjx1SwMKm5aRLRa2Cwh6tQ7y0h33C07kkPbkhswFw@mail.gmail.com>
 <20180519232257.GL10363@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180519232257.GL10363@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Sat, May 19, 2018 at 6:22 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, May 18, 2018 at 01:43:14PM -0700, Steve French wrote:
>> On Fri, May 18, 2018 at 11:46 AM, Ralph B=C3=B6hme <slow@samba.org> wrot=
e:
>> > On Thu, May 17, 2018 at 09:36:36PM -0500, Steve French via samba-techn=
ical wrote:
>> >> Patch updated with additional tracepoint locations and some formattin=
g
>> >> improvements. There are some obvious additional tracepoints that coul=
d
>> >> be added, but this should be a reasonable group to start with.
>> >>
>> >> From edc02d6f9dc24963d510c7ef59067428d3b082d3 Mon Sep 17 00:00:00 200=
1
>> >> From: Steve French <stfrench@microsoft.com>
>> >> Date: Thu, 17 May 2018 21:16:55 -0500
>> >> Subject: [PATCH] smb3: Add ftrace tracepoints for improved SMB3 debug=
ging
>> >>
>> >> Although dmesg logs and wireshark network traces can be
>> >> helpful, being able to dynamically enable/disable tracepoints
>> >> (in this case via the kernel ftrace mechanism) can also be
>> >> helpful in more quickly debugging problems, and more
>> >> selectively tracing the events related to the bug report.
>> >>
>> >> This patch adds 12 ftrace tracepoints to cifs.ko for SMB3 events
>> >> in some obvious locations.  Subsequent patches will add more
>> >> as needed.
>> >>
>> >> Example use:
>> >>    trace-cmd record -e cifs
>> >>    <run test case>
>> >>    trace-cmd show
>> >
>> > pardon my ignorance, but are these tracepoints usable with other traci=
ng
>> > frameworks like Systemtap?
>> >
>> > Last time I checked, Systemtap looked like *the* tool.
>
> Systemtap is great when you have a need for custom tracing. But for
> day-to-day kernel development, tracepoints are far more useful
> because they are always there and can cover all the common
> situations that you need to trace.
>
> And when it comes to debugging a one-off user problem when the user
> knows nothing about systemtap?  Nothing beats asking the user
> to run a trace on built-in tracepoints, reproduce the problem and
> send the trace report back as per the above example.

Yep - it has already been helpful in debugging problems.

Main problem I hit using the new tracepoints over the past few days
was entries being discarded from the buffer - I had a counter leak (now
fixed) that xfstest showed ... but about 90% of the entries were dropped.
Tried increasing buffer size but might have made things worse not better.
Ideas how to force more entries to be saved?

>> > Is there a generic trace
>> > point infrastructure that tracing tools can consume, so we're not tied=
 to
>> > ftrace?
>>
>> At the kernel filesystem/mm summit a few recommended using ftrace
>> (trace-cmd).  Don't know what
>> the thinking is about this vs. systemtap these days.  There was a nice
>> three part series
>> describing ftrace/trace-cmd on lwn
>> (https://old.lwn.net/Articles/365835/) a while ago.
>>
>> In terms of useability "trace-cmd" looked good to me and much more
>> powerful than the
>> current dmesg based printk style debugging.
>
> And then you learn about trace_printk() for putting custom one-off
> debug into the tracepoint stream and wonder why you didn't know
> about this years ago :P

Thanks for the pointers at the summit ...



--=20
Thanks,

Steve
