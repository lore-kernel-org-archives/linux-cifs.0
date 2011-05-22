From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: mark CONFIG_CIFS_NFSD_EXPORT as BROKEN
Date: Sun, 22 May 2011 08:17:07 -0400
Message-ID: <20110522081707.72cce108@corrin.poochiereds.net>
References: <1306065324-24604-1-git-send-email-jlayton@redhat.com>
	<20110522115938.GA27941@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110522115938.GA27941-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 22 May 2011 07:59:38 -0400
Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> On Sun, May 22, 2011 at 07:55:24AM -0400, Jeff Layton wrote:
> > This will never work properly with CIFS, as the protocol has no ability
> > whatsoever for looking up files by filehandle. It *might* be possible to
> > eventually do this with SMB2, but that remains to be seen.
> > 
> > For now, it just plain doesn't work. Mark it BROKEN to discourage
> > distros from enabling it.
> 
> It's actually dead code at this point - fs/nfsd/vfs.c:check_export()
> refuses to export a filesystem that does not have a fh_to_dentry
> operation, which cifs doesn't provide.
> 
> IMHO it's best to just remove the option and all surrounding code.
> 

I agree and proposed a patch to do that a month or two ago. Steve
NAK'ed it for reasons that I don't quite understand. At this point,
I'm just trying to make sure distros don't ship with this enabled.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
