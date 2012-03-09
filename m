From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 06/11] CIFS: Respect MaxMpxCount field
Date: Fri, 9 Mar 2012 07:39:30 -0500
Message-ID: <20120309073930.3a79fa10@redhat.com>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
	<1329895984-9251-7-git-send-email-piastry@etersoft.ru>
	<CAH2r5mvVToaHozN3=YgCCCWFFnjE9AP5xX_BF2JdxDj_JvKsbQ@mail.gmail.com>
	<CAKywueRwzdak2LfpfVkiX2ue0A-0a15J9kO8kgUYseRPXM8Tfw@mail.gmail.com>
	<20120303070921.5ce2bb10@tlielax.poochiereds.net>
	<CAH2r5mvGjzS73bhgG54Yzcqui9qxfv7e3yrxWZX+weSUQB4cHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvGjzS73bhgG54Yzcqui9qxfv7e3yrxWZX+weSUQB4cHA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 3 Mar 2012 21:14:19 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 
> On the issue of why Samba didn't up maxmpx, I expect it is simply that
> until Jeff fixed async read/write, it was rare for a client to send 50
> requests in parallel.
> 

Are windows clients hard capped at 50 outstanding calls or so?

> On the SMB2 credits vs. CIFS maxmpx topic ...  more than once at the
> MS Plugfest I heard pushback on treating SMB2 credits and CIFS maxmpx
> similarly - they are totally unrelated.  SMB2 credits are pretty
> straightforward - we get them back on every request so they are
> constantly changing, but the rules are easier to understand (and are
> well documented, where the CIFS maxmpx behavior is only partially
> documented).
> 

I can understand their POV, and that may be correct. I think we ought
to step back though and consider the fundamental problem that we're
trying to solve. When we want to send a call on the wire, we need to
know:

"Is this particular call allowed to go out onto the wire at this time
or does it need to wait for another event to occur?"

Earlier, I suggested: "Let's treat SMB1 maxmpx handling as a trivial
case of SMB2 credits." If that's not possible for some reason then we
ought to consider something like this:

"Let's build this out the transport layer so that it can accomodate
both sets of protocols by allowing us to plug in different rules
depending on the protocol."

Now that we're looking more closely at this, I think you're correct
that SMB1 maxmpx limits and SMB2 credits follow different "rules". But
I also think that it's best to engineer this in such a way that we can
"plug in" the correct ruleset for answering the above question based on
the protocol version in use.

The trick is to do this in such a way that we only "plug in" what needs
to be different. If treating SMB1 maxmpx limits as a trivial case of
SMB2 credits is too difficult, then I would take that as a sign that we
just need to expand how much of that decision making needs to be
protocol specific.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
