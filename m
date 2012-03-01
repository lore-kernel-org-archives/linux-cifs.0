From: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 06/11] CIFS: Respect MaxMpxCount field
Date: Thu, 1 Mar 2012 10:48:23 -0800
Message-ID: <20120301184823.GE1930@jeremy-laptop>
References: <1329895984-9251-1-git-send-email-piastry@etersoft.ru>
 <1329895984-9251-7-git-send-email-piastry@etersoft.ru>
 <CAH2r5mvVToaHozN3=YgCCCWFFnjE9AP5xX_BF2JdxDj_JvKsbQ@mail.gmail.com>
 <20120228114341.1629ed85@tlielax.poochiereds.net>
 <CAH2r5mvFyw8Cn8nXN9ZBZogBGVr5L5T9aX7Zs8DOiZgDUqGp1Q@mail.gmail.com>
 <20120228144736.18124fc3@tlielax.poochiereds.net>
 <CAH2r5mvJE+ACNVuv+HEQMuwvaMTzfOb7Msk4U1ZVnZ046AEi1Q@mail.gmail.com>
 <CAKywueSxe_wZwudx3UK14C94o53zjghsTJJSah=CQSqy0uhZRQ@mail.gmail.com>
 <CAH2r5mvFiwpVwcBgfuXvEGC1_8snLMAsp4fRVEDMqTWXDJdu9w@mail.gmail.com>
 <20120301133747.5fc891b5@samba.org>
Reply-To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120301133747.5fc891b5-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Mar 01, 2012 at 01:37:47PM -0500, Jeff Layton wrote:
> 
> (cc'ing Chris and Jeremy to make sure I understand)
> 
> The description above is a good start but doesn't quite outline the
> clear concise "rules" for this that I was looking for.
> 
> So if I understand what Steve wrote above, he's basically saying that
> we should enforce the maxmpx for everything but blocking locks and
> echoes? Is that correct? If so then I think that's wrong and won't fix
> any of the problems that people have reported with the existing code.
> 
> It's all well and good that *some* servers allow you to exceed the
> maxmpx in *some* cases, but we can't code to that assumption. We know
> well that many servers do not handle exceeding the maxmpx gracefully at
> all. As always we have to code to the lowest common denominator by
> default, and then optionally allow people to exceed that if they choose
> to do so.
> 
> I think this is a case where we need a good description in a human
> language (preferably english) of how this should work (aka a
> specification), and then write code to match that description (aka code
> to the spec).
> 
> Anything else is going to send us down the rabbit hole where we are
> today with cifs.ko -- a bunch of ad-hoc, broken code that no one really
> understands.
> 
> While we may not like it, a hard cap on the number of outstanding
> requests is required by the protocol docs that Chris helped write.
> 
> Allow me to quote from MS-CIFS:
> 
> MaxMpxCount (2 bytes): The maximum number of outstanding SMB operations
> that the server supports. This value includes existing OpLocks, the
> NT_TRANSACT_NOTIFY_CHANGE subcommand, and any other commands that are
> pending on the server.
> 
> There's nothing in there that says anything about certain commands
> being excepted from that value.

The only way to know this for sure is to put in a request
to Microsoft doc-help to ask if SMBecho and blocking SMB
locks are exempted from the maxmpx count.

Jeremy.
