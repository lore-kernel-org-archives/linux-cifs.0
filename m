From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH] freezer: revert 27920651fe "PM / Freezer: Make
 fake_signal_wake_up() wake TASK_KILLABLE tasks too"
Date: Mon, 31 Oct 2011 18:45:48 -0500
Message-ID: <CAH2r5msMiG8MjhYuVv8ehqkBLKc1Av3hi+2q6zwrrXdTTa_+YQ@mail.gmail.com>
References: <20111031221743.GA18855@google.com>
	<201111010024.16659.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>
To: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201111010024.16659.rjw-KKrjLPT3xs0@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Oct 31, 2011 at 6:24 PM, Rafael J. Wysocki <rjw-KKrjLPT3xs0@public.gmane.org> wrote:
> On Monday, October 31, 2011, Tejun Heo wrote:
>> Commit 27920651fe "PM / Freezer: Make fake_signal_wake_up() wake
>> TASK_KILLABLE tasks too" made freezer wake up tasks in TASK_KILLABLE
>> sleep too citing non-interruptible but killable sleeps in cifs and
>> nfs.
>>
>> I don't think we can do this. =A0We should not send spurious unsolic=
ited
>> non-interruptible wakeups. =A0Most synchornization constructs are bu=
ilt
>> to cope with spurious wakeups and any INTERRUPTIBLE sleep must be ab=
le
>> to handle spurious wakeups but that's not true for KILLABLE sleeps -
>> KILLABLE condition cannot be cancelled.
>>
>> This is probably okay for most cases but circumventing fundamental
>> wakeup condition like this is asking for trouble. =A0Furthermore, I'=
m
>> not sure the behavior change brought on by this change - breaking
>> nfs/cifs uninterruptible operation guarantee - is correct. =A0If suc=
h
>> behavior is desirable, the right thing to do is using intr mount
>> option, not circumventing it from PM layer.
>
> Do you have any specific examples of breakage, or is it just that you=
 _think_
> it's not quite right?
>
> One patch depending on that change has been merged already and I have=
 two
> more in the queue, so I'd like to clarify this ASAP. =A0Jeff, Steve?
>
>> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>> Neil, Steve, do the network filesystems need a way to indicate "I ca=
n
>> either be killed or enter freezer"?

Probably, yes, but I will defer to Jeff as he has looked
more recently at these issues.

I can explain cifs state, and disconnect/reconnection of sessions
(and smb2 is a little more feature rich in this regard), but will
let Jeff explain the more subtle points you are getting at.

--=20
Thanks,

Steve
