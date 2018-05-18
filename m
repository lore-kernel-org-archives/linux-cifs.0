From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCHv2][SMB3] Add kernel trace support
Date: Fri, 18 May 2018 13:43:14 -0700
Message-ID: <CAH2r5muu0Hjx1SwMKm5aRLRa2Cwh6tQ7y0h33C07kkPbkhswFw@mail.gmail.com>
References: <CAH2r5muobq1gDbGcPE1AYeeKmdFx681=mpCyAZWfSPUa5wLjSQ@mail.gmail.com>
 <20180518184630.axfa7oq4pewb7foj@kazak>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180518184630.axfa7oq4pewb7foj@kazak>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, May 18, 2018 at 11:46 AM, Ralph B=C3=B6hme <slow@samba.org> wrote:
> On Thu, May 17, 2018 at 09:36:36PM -0500, Steve French via samba-technica=
l wrote:
>> Patch updated with additional tracepoint locations and some formatting
>> improvements. There are some obvious additional tracepoints that could
>> be added, but this should be a reasonable group to start with.
>>
>> From edc02d6f9dc24963d510c7ef59067428d3b082d3 Mon Sep 17 00:00:00 2001
>> From: Steve French <stfrench@microsoft.com>
>> Date: Thu, 17 May 2018 21:16:55 -0500
>> Subject: [PATCH] smb3: Add ftrace tracepoints for improved SMB3 debuggin=
g
>>
>> Although dmesg logs and wireshark network traces can be
>> helpful, being able to dynamically enable/disable tracepoints
>> (in this case via the kernel ftrace mechanism) can also be
>> helpful in more quickly debugging problems, and more
>> selectively tracing the events related to the bug report.
>>
>> This patch adds 12 ftrace tracepoints to cifs.ko for SMB3 events
>> in some obvious locations.  Subsequent patches will add more
>> as needed.
>>
>> Example use:
>>    trace-cmd record -e cifs
>>    <run test case>
>>    trace-cmd show
>
> pardon my ignorance, but are these tracepoints usable with other tracing
> frameworks like Systemtap?
>
> Last time I checked, Systemtap looked like *the* tool. Is there a generic=
 trace
> point infrastructure that tracing tools can consume, so we're not tied to
> ftrace?

At the kernel filesystem/mm summit a few recommended using ftrace
(trace-cmd).  Don't know what
the thinking is about this vs. systemtap these days.  There was a nice
three part series
describing ftrace/trace-cmd on lwn
(https://old.lwn.net/Articles/365835/) a while ago.

In terms of useability "trace-cmd" looked good to me and much more
powerful than the
current dmesg based printk style debugging.

Since the most active file systems (except for cifs.ko) on Linux
btrfs, xfs, nfs and ext4 (and
even dax and ocfs2 and nfsd and fscache etc. and of course various
drivers) already use it, seems like
it is widely accepted still and overhead is small when not logging (default=
).

--=20
Thanks,

Steve
