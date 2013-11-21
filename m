From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: should we propagate SMB error codes further?
Date: Thu, 21 Nov 2013 12:35:38 -0600
Message-ID: <CAH2r5msM0Qfe3AsfCB3T-kKo_eBhMfbEMUK4+ha83uJesLrVRQ@mail.gmail.com>
References: <20131120081334.GA21566@infradead.org>
	<20131120062619.312adee4@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131120062619.312adee4-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Nov 20, 2013 at 5:26 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, 20 Nov 2013 00:13:34 -0800
> Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>
>> I'm seeing same interesting errors running against a server from a big
>> NAS vendor that shall remain unnamed:
>>
>> p224160.955651] CIFS VFS: Unexpected lookup error -5
>> [224161.298853] CIFS VFS: Unexpected lookup error -5
>> [224161.643559] CIFS VFS: Unexpected lookup error -5
>> [224161.992309] CIFS VFS: Unexpected lookup error -5
>> [224162.333310] CIFS VFS: Unexpected lookup error -5
>> [224162.677982] CIFS VFS: Unexpected lookup error -5
>>
>> Unfortunately it seems like a EIO is the catchall for unknown SMB
>> errors, so trying to debug this seems a bit hard.  Should we maybe look
>> into propagating the SMB error codes further up the chain inside the
>> cifs driver instead of converting them at a fairly low level?
>>
>
> That makes a lot of sense. We could also get rid of some nasty NT
> error->DOS error conversion code that way too.

At least in the SMB2/SMB3 case it is more direct onestep conversion
which helps.

> That said, if that NAS vendor is the one I'm thinking of, then
> it's probable that it's just sending malformed responses and not sending
> actual error codes at all.
>
> You may be interested in this samba bug which has some details about
> some of these problems:
>
>     https://bugzilla.samba.org/show_bug.cgi?id=8914

I think generally with some of the NAS vendors we are better off mounting
with "vers=2.1" (or "vers=3.0" if more recent kernel) but probably not
till at least at 3.11 kernel.  With the big move to SMB2.1 (Windows 7
and Mac) and
SMB3, there is presumably a lot less testing going on with cifs in some
of the NAS boxes.

-- 
Thanks,

Steve
