From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCHv2][SMB3] Add kernel trace support
Date: Fri, 18 May 2018 11:14:56 -0700
Message-ID: <CAH2r5muy_+dMNfW6dPg4U-66R4kFbGKGSDu-==uizGJfLYoA9w@mail.gmail.com>
References: <CAH2r5muobq1gDbGcPE1AYeeKmdFx681=mpCyAZWfSPUa5wLjSQ@mail.gmail.com>
 <1169121702.2774727.1526614091337.JavaMail.zimbra@redhat.com>
 <CAH2r5mvW50EzjoU2uXiUC1Z=ShbHpCyYh7GicmwtWOP8cGEXdA@mail.gmail.com> <CAN05THQsJd=go+KKgn2AXLq8XhTd6Gnb-SdpLgz11M+3usfoTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ronnie Sahlberg <lsahlber@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAN05THQsJd=go+KKgn2AXLq8XhTd6Gnb-SdpLgz11M+3usfoTQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, May 18, 2018 at 1:00 AM, ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
> Fair enough.
>
> Onto a second point then, for future patches.
>
> There are a lot of places where we do not (yet) pass a tcon as argument.
> Can we make a policy decision to mandate that every tracepoint MUST
> log tid, sid?
>
> And thus, if you need a new tracepoint in a function where tcon is not
> available you then first
> have to do the plumbing to pass the tcon all the way down to the tracepoint?

I think this can be relaxed in a few cases (not just session setup),
but is a good
general rule.  If only the parent function needs to be changed it is
easy decision,
but if changes more than two layers, perhaps not.

> Ideally we should pass tcon into any and every leaf function for
> tracepoints as well as debug logging.

We also have to
- log the tid and session id somewhere in human readable form
- perhaps allow an IOCtl to retrieve the UNC name from the tid, and similarly
something human readable for the session id (server and username)
(or add the tid and session id to what is displayed in
/proc/fs/cifs/DebugData so
we can extract it from the DebugData output)

> On Fri, May 18, 2018 at 4:19 PM, Steve French <smfrench@gmail.com> wrote:
>> On Thu, May 17, 2018 at 10:28 PM, Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>>> Very nice.
>>>
>>> Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
>>>
>>> Possibly change the output from
>>> pid=6633 tid=0x0 sid=0x0 cmd=0 mid=0
>>> to
>>> cmd=0 mid=0 pid=6633 tid=0x0 sid=0x0
>>>
>>> just to make it easier for human-searching. I think the cmd will be useful much more often than pid/tid/sid
>>> and this would make it easier to look for as all cmd= entries will be aligned to the same column.
>>
>> My instinct is to preserve the consistency by beginning with the the
>> fields that will be in 90% of the commands: tree id and session id
>> (tid and sid), which would cause pid to move after sid or after cmd,
>> but I would prefer to wait on reordering fields and fixing alignment
>> till we add another set of tracepoints (e.g. in FreeXid, and in
>> SMB2_open and in the caller of negprot/sessionsetup) - we should then
>> have a better idea what formatting would make it slightly more
>> consistent and readable.



-- 
Thanks,

Steve
