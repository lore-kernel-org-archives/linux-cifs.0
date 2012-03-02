From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 06/11] CIFS: Respect MaxMpxCount field
Date: Fri, 2 Mar 2012 10:45:44 -0500
Message-ID: <20120302104544.1c574f34@tlielax.poochiereds.net>
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
	<20120301184823.GE1930@jeremy-laptop>
	<4F4FCB69.6060705@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F4FCB69.6060705-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 01 Mar 2012 11:18:01 -0800
"Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> On 03/01/2012 10:48 AM, Jeremy Allison wrote:
> > On Thu, Mar 01, 2012 at 01:37:47PM -0500, Jeff Layton wrote:
> >>
> >> (cc'ing Chris and Jeremy to make sure I understand)
> >>
> >> The description above is a good start but doesn't quite outline the
> >> clear concise "rules" for this that I was looking for.
> >>
> >> So if I understand what Steve wrote above, he's basically saying that
> >> we should enforce the maxmpx for everything but blocking locks and
> >> echoes? Is that correct? If so then I think that's wrong and won't fix
> >> any of the problems that people have reported with the existing code.
> >>
> >> It's all well and good that *some* servers allow you to exceed the
> >> maxmpx in *some* cases, but we can't code to that assumption. We know
> >> well that many servers do not handle exceeding the maxmpx gracefully at
> >> all. As always we have to code to the lowest common denominator by
> >> default, and then optionally allow people to exceed that if they choose
> >> to do so.
> >>
> >> I think this is a case where we need a good description in a human
> >> language (preferably english) of how this should work (aka a
> >> specification), and then write code to match that description (aka code
> >> to the spec).
> >>
> >> Anything else is going to send us down the rabbit hole where we are
> >> today with cifs.ko -- a bunch of ad-hoc, broken code that no one really
> >> understands.
> >>
> >> While we may not like it, a hard cap on the number of outstanding
> >> requests is required by the protocol docs that Chris helped write.
> >>
> >> Allow me to quote from MS-CIFS:
> >>
> >> MaxMpxCount (2 bytes): The maximum number of outstanding SMB operations
> >> that the server supports. This value includes existing OpLocks, the
> >> NT_TRANSACT_NOTIFY_CHANGE subcommand, and any other commands that are
> >> pending on the server.
> >>
> >> There's nothing in there that says anything about certain commands
> >> being excepted from that value.
> >
> > The only way to know this for sure is to put in a request
> > to Microsoft doc-help to ask if SMBecho and blocking SMB
> > locks are exempted from the maxmpx count.
> 
> I recall, from the code, that the SMBecho is handled "out of band".  I can't 
> speak to the blocking locks.
> 
> Internally, the system keeps a per-connection table keyed on [PID,MID].  The 
> MaxMpxCount indicates the fixed size of this table.  Outstanding commands, 
> including things like ChangeNotify and OpLocks (which are handled as if they 
> were incomplete commands, pending on the server) are kept in this table.
> 
> The doc talks about needing to disable OpLocks if the MaxMpxCount is less 
> than 2.  That's because clients can break their own OpLocks.  If a client 
> has an OpLock on a file, and then opens the file again (the same or 
> different process...it doesn't matter) there won't be enough slots in the 
> [PID,MID] table to allow the open to occur.  The client's second Open 
> request will not be able to be queued (it becomes a pending command since it 
> cannot be answered until the OpLock break either times out or completes) 
> because the pending command table is full.
> 
> Okay, so...  The question is this:  When are commands added to the server's 
> pending queue (the table indexed on [PID,MID].
> 
> The answer is scattered across section 3 of the [MS-CIFS] doc.  If the 
> command needs to be added to the pending queue, it'll say so in the doc.  It 
> should all be under section 3.3.5.
> 
> Look for information about the PendingRequestTable, starting at section 
> 3.3.5.2.1.
> 
> Chris -)-----
> 

Thanks -- that description of windows server behavior is interesting,
but it doesn't really help us much in this case. The question is more:
"Do windows _clients_ ever exceed the server's maxmpx and if so, under
what conditions?"

I'm not really worried about working against windows servers. It's the
3rd party server implementations that concern me. Because of that, I'm
less concerned with windows server behavior, but windows client
behavior is of interest here.

Presumably, most server vendors test their implementations with windows
clients, so we should be reasonably safe if we follow the same "rules"
that the windows redirector does.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
