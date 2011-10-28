From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch] cifs: accidentally creating empty files
Date: Fri, 28 Oct 2011 10:27:04 -0500
Message-ID: <CAH2r5msb_+tenSg1kWCn_0xi2EZu6vboqvmbQ17vRBYoqHp2Eg@mail.gmail.com>
References: <20110927212810.GA12900@elgon.mountain>
	<20111013132755.6c5db87e@barsoom.rdu.redhat.com>
	<CAH2r5mtOF=Ja7_mTK576uEqgZqaVH+8YXtOqmZVknBC81sD=8Q@mail.gmail.com>
	<20111028072019.GA14900@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111028072019.GA14900-dZEljifmRObu9KfB+GxooP8+0UxHXcjY@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Oct 28, 2011 at 2:20 AM, Dan Carpenter <dan.carpenter-QHcLZuEGTsthl2p70BpVqQ@public.gmane.org=
m> wrote:
> On Wed, Oct 19, 2011 at 09:14:37PM -0500, Steve French wrote:
>> Doesn't this force the create to happen later - rather than
>> at lookup time where it belongs?
>>
>> if the issue is just noperm ... we should let this through if the us=
er
>> has local permissions. =A0Doubling the cost of a file create to Samb=
a
>> seems like a bad idea (ie doing aQueryPathInfo AND an NTCreateX
>> doubles the roundrip, doubles the load on the server etc.) - the who=
le
>> point of this is to let us do an "atomic" open or create operation
>> and not have to split it into multiple requests. =A0In any case why =
would
>> we do the open and then follow it with a create?
>>
>> Can we fix this to (at least) narrow the performance penalty.
>>
>
> Yes, it does add another back and forth to file create... =A0It's har=
d/
> impossible to check the permissions first and then decide whether to
> pass the O_CREAT flag. =A0Maybe we could add an if statement to check
> whether noperm was used and the noperm version could use the create
> on lookup.

Why is it hard to check local permissions? We have the local mode
for the parent.

Also note that the "intent" flags and the atomic create is not just
about performance, but also making it atomic reduces some of the weird
failure cases.



--=20
Thanks,

Steve
