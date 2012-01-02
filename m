From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: SMB2 dev status
Date: Mon, 2 Jan 2012 06:42:10 -0500
Message-ID: <20120102064210.01751177@tlielax.poochiereds.net>
References: <CAKywueQx=bdMPD2Ws2W7NWCZz_X=36W8mFhL7+rQ9Rc5MUZRog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQx=bdMPD2Ws2W7NWCZz_X=36W8mFhL7+rQ9Rc5MUZRog-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 30 Dec 2011 01:50:24 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hi all!
> 
> I will be on holidays for about a week or a little more (will check
> email box). I pushed the last status of SMB2 patches into smb2-dev
> branch:
> http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=shortlog;h=refs/heads/smb2-dev
> 
> It's not the final variant - that's why I didn't posted them to the
> list. There is still some work to be done - I want to drop the first
> patch "CIFS: Add structure definitions for SMB2 PDUs" and add each PDU
> structure with it's first usage.
> 
> So, can you look and comment if possible on the approach and design of
> this version of the patch series, please?
> 

Looks ok overall, but I haven't looked in depth. Once you post the
patches I'll have more specific comments.

Again, it's difficult to review unposted patches since I can't easily
comment on them inline. In general I urge you to get rid of any patches
that add code or struct members that are not actually used by that
patch. Sometimes that's unavoidable, but in those cases, the patch
description should explain why and what the new things are for.

The first patch is mostly OK actually. Most of those structs are
protocol definitions, so it's pretty clear what they're for. Since they
describe the what goes over the wire, there's little to review there.
That said, it wouldn't hurt to add them as you need them since that
will make the patch series "flow" more nicely.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
