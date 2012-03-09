From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 06/11] CIFS: Respect MaxMpxCount field
Date: Fri, 9 Mar 2012 10:45:22 -0600
Message-ID: <CAH2r5mvzgnTcyhL-Rip9yHUEMsLOCFhfAoNdRyVqhNFin_A6mw@mail.gmail.com>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
	<1329895984-9251-7-git-send-email-piastry@etersoft.ru>
	<CAH2r5mvVToaHozN3=YgCCCWFFnjE9AP5xX_BF2JdxDj_JvKsbQ@mail.gmail.com>
	<CAKywueRwzdak2LfpfVkiX2ue0A-0a15J9kO8kgUYseRPXM8Tfw@mail.gmail.com>
	<20120303070921.5ce2bb10@tlielax.poochiereds.net>
	<CAH2r5mvGjzS73bhgG54Yzcqui9qxfv7e3yrxWZX+weSUQB4cHA@mail.gmail.com>
	<20120309073930.3a79fa10@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120309073930.3a79fa10-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Mar 9, 2012 at 6:39 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Sat, 3 Mar 2012 21:14:19 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>>
>> On the issue of why Samba didn't up maxmpx, I expect it is simply th=
at
>> until Jeff fixed async read/write, it was rare for a client to send =
50
>> requests in parallel.
>>
>
> Are windows clients hard capped at 50 outstanding calls or so?

No.   Windows can definitely go beyond 50.  And clients apparently do
sometimes go
beyond 50 )(even if server negotiates 50) as the following Microsoft
TechNote implies:

"Because the limit on outstanding requests is negotiated between the
client and and server and is enforced by the client, this value might
not be the actual maximum used. Increasing this value might improve
server performance, but it requires more receive buffers (also known
as work items ) on the server.  Note:  For Windows NT 4.0 Service Pack
3 and later, the valid values for this entry range from 1 to 65,535
requests, with a default value of 50 requests. Windows 2000 limits the
maximum value of this entry to 125 requests to assure that Windows 95
and Windows 98 clients can connect to the server."

Apparently IIS and Windows Terminal Server (as a client to NAS boxes)
need more than 50 - see this quote from NetApp server manual.

"cifs.max_mpx
This option controls how many simultaneous operations the filer
reports that it can process. An
"operation" is each I/O the client believes is pending on the filer
including outstanding change notify
operations. Clients such as Windows Terminal Server or IIS may require
that this number be increased
to avoid errors and performance delays."


Note that on the WIndows server side note that there is MaxMpxCt which
controls it
and a second parm maxworkitems which helps avoid hangs (as we found
out in testing).



>> On the SMB2 credits vs. CIFS maxmpx topic ... =A0more than once at t=
he
>> MS Plugfest I heard pushback on treating SMB2 credits and CIFS maxmp=
x
>> similarly - they are totally unrelated. =A0SMB2 credits are pretty
>> straightforward - we get them back on every request so they are
>> constantly changing, but the rules are easier to understand (and are
>> well documented, where the CIFS maxmpx behavior is only partially
>> documented).
>>
>
> I can understand their POV, and that may be correct. I think we ought
> to step back though and consider the fundamental problem that we're
> trying to solve. When we want to send a call on the wire, we need to
> know:
>
> "Is this particular call allowed to go out onto the wire at this time
> or does it need to wait for another event to occur?"
>
> Earlier, I suggested: "Let's treat SMB1 maxmpx handling as a trivial
> case of SMB2 credits." If that's not possible for some reason then we
> ought to consider something like this:
>
> "Let's build this out the transport layer so that it can accomodate
> both sets of protocols by allowing us to plug in different rules
> depending on the protocol."
>
> Now that we're looking more closely at this, I think you're correct
> that SMB1 maxmpx limits and SMB2 credits follow different "rules". Bu=
t
> I also think that it's best to engineer this in such a way that we ca=
n
> "plug in" the correct ruleset for answering the above question based =
on
> the protocol version in use.
>
> The trick is to do this in such a way that we only "plug in" what nee=
ds
> to be different. If treating SMB1 maxmpx limits as a trivial case of
> SMB2 credits is too difficult, then I would take that as a sign that =
we
> just need to expand how much of that decision making needs to be
> protocol specific.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>



--=20
Thanks,

Steve
