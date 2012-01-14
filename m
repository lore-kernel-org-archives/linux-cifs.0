From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: file truncation on newer linux-cifs versions
Date: Sat, 14 Jan 2012 15:46:05 -0600
Message-ID: <CAH2r5ms9wfz_3dGeCLJ7bvXeKeerSEfFpbiTz6C_WdPbFk6WXA@mail.gmail.com>
References: <20120113230701.GA3100@gwdu05.gwdg.de>
	<CAOhYWN+dLLKXs6MU3W88oHzyFgi1KV+7oh1qPh61ZEqUA-Jw8w@mail.gmail.com>
	<20120114135057.GA4197@gwdu05.gwdg.de>
	<20120114093322.7e36221d@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: mscholz5-2/1ofaGcC4w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120114093322.7e36221d-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Can you experiment a little with setting different wsize values and see
if the server's bug starts at exactly 64K, or as we saw with another
server ~100K.  There is significant performance benefit in setting
the wsize to larger than 64K, but if we find a second server that
maxes at ~100K we may want to set it to that.  I still would
prefer to workaround buggy servers if it were possible to recognize
them because I hate to punish (with 20%+ or more worse write performanc=
e)
the vast majority of servers (Windows,Samba, NetApp) for the bug of a f=
ew.
Obviously if the problem with the server can not be recognized then
we may have to reset wsize - I still would generally prefer (at least
for the Solaris case where the server does report an error) to handle
the write error and alter the write size for subsequent writes - but
as Jeff noted in earlier discussion, although possible, it is a harder
patch to do.  I would be curious though if your server gives any
indication of write error or silently ignores the large write.

On Sat, Jan 14, 2012 at 8:33 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Sat, 14 Jan 2012 14:50:58 +0100
> Mirko Scholz <mscholz5-2/1ofaGcC4w@public.gmane.org> wrote:
>
>>
>> > Does the problem go away if you mount with wsize=3D65535? If so, I=
 guess we
>> > can add bluearc to the list of servers that can't handle writes la=
rger than
>> > windows sends.
>> yes it does. =A0Thanks for pointing it out, as it is clearly mention=
ed
>> in mount.cifs(8). =A0But it says, that this size is negotiated...?
>>
>
> To a degree...
>
> We attempt to set the wsize according to what the server supports, bu=
t
> there is no way for the server to say "I only support writes up to th=
is
> size". Currently, when the server says it supports large writes, we
> attempt to set the wsize as large as we can go -- ~127k or so.
>
> Windows servers support that just fine, but windows clients never sen=
d
> writes larger thank 64k. Unfortunately, some servers are not engineer=
ed
> to handle larger writes, and only handle up to what windows clients
> default to.
>
> I sent a patch a while back to set the default wsize to match what
> windows does, but Steve has so far refused to take it.
>
>> > Steve is right though that a capture would be helpful to confirm w=
hat's
>> > happening.
>>
>> You'll find it at http://www.gwdg.de/~mscholz5/cifs-problem/v3.1.0-1
>>
>> Thank you both for the quick reply. =A0I noticed this problem a whil=
e ago,
>> but hasitated to report it, since cifs is not officially supported
>> at my site.
>>
>> Steve, do you still need the bug-report?
>>
>
> Thanks -- there's probably no need for a bug report. I think I
> understand the problem. You can probably set wsize=3D65536, actually =
and
> it should still work.
>
> The server is responding to a 66560 byte write with a length of 65536=
=2E
> The current code treats a short write like an -ENOSPC error. It's not
> ideal, but the spec doesn't really spell out what a short write means=
,
> and it would be quite difficult to try to recover from this situation
> gracefully.
>
> Steve, the list of servers that do not support >64k writes is growing=
=2E
> Are you ready to take my patch to set the default wsize lower yet?
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>



--=20
Thanks,

Steve
