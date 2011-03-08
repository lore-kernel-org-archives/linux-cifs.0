From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: smb2pdu.c merged
Date: Tue, 8 Mar 2011 07:15:16 -0500
Message-ID: <20110308071516.3890d5bf@tlielax.poochiereds.net>
References: <AANLkTi=JhKhrS57TsWo9=wOSejDy4Hi6+i=PsjCShOP7@mail.gmail.com>
	<20110308112915.GA29380@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110308112915.GA29380-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 8 Mar 2011 06:29:15 -0500
Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> Sorry Steve,
> 
> first you need to explain why a totall different protocol is better
> suited stuffed into the fucking mess than the cifs module than a clean
> start.  Second you absolutely need to post patches for review before
> commiting them.  While others are cleaning up the mess you
> singlehandedly are making it worse constantly.  It can't go on that way
> much longer.
> 

SMB2 servers are also generally CIFS servers. There is a mechanism to
autonegotiate when talking to a sever to decide which protocol to use.
Making a completely separate fstype and module however will mean that
we can't effectively use that mechanism. Userspace will have to decide
"smb2" or "cifs" at mount time and tough luck if you get it wrong.

I'd like to avoid the same mistake made with "nfs" vs. "nfs4" fstypes.
That was a real pain to clean up after the fact and still isn't 100%
the way we'd really like (there's still a nfs4 fstype, for instance).

I think putting it in the same module and sharing the fstype is the
right thing to do. Much of the code between CIFS and SMB2 can be shared
and there's little value in putting that into a separate module. I
think we'll be far better served by abstracting out the existing code
where we can.

That said, I'm also not very happy with the how the SMB2 merge is
going. A lot of this code seems to be getting merged without any review
at all on the list. I really don't care how big they are -- I'd like to
see patchsets mailed out as anyone else would.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
