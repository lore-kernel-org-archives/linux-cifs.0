From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: should we propagate SMB error codes further?
Date: Wed, 20 Nov 2013 06:26:19 -0500
Message-ID: <20131120062619.312adee4@tlielax.poochiereds.net>
References: <20131120081334.GA21566@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131120081334.GA21566-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 20 Nov 2013 00:13:34 -0800
Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> I'm seeing same interesting errors running against a server from a big
> NAS vendor that shall remain unnamed:
> 
> p224160.955651] CIFS VFS: Unexpected lookup error -5
> [224161.298853] CIFS VFS: Unexpected lookup error -5
> [224161.643559] CIFS VFS: Unexpected lookup error -5
> [224161.992309] CIFS VFS: Unexpected lookup error -5
> [224162.333310] CIFS VFS: Unexpected lookup error -5
> [224162.677982] CIFS VFS: Unexpected lookup error -5
> 
> Unfortunately it seems like a EIO is the catchall for unknown SMB
> errors, so trying to debug this seems a bit hard.  Should we maybe look
> into propagating the SMB error codes further up the chain inside the
> cifs driver instead of converting them at a fairly low level?
>

That makes a lot of sense. We could also get rid of some nasty NT
error->DOS error conversion code that way too.

That said, if that NAS vendor is the one I'm thinking of, then
it's probable that it's just sending malformed responses and not sending
actual error codes at all.

You may be interested in this samba bug which has some details about
some of these problems:

    https://bugzilla.samba.org/show_bug.cgi?id=8914

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
