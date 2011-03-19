From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [CIFS] [PATCH] consistently use smb_buf_length as be32 for cifs
 (try 3)
Date: Sat, 19 Mar 2011 17:17:35 -0400
Message-ID: <20110319171735.429915b0@corrin.poochiereds.net>
References: <AANLkTimb8H=2hzNWUK_sQ=SMKhaQLrTQzA7ABiy_E4H5@mail.gmail.com>
	<20110317164446.GA26600@infradead.org>
	<AANLkTikqrGxG1RgUwFGNhoyyLc8ARiVvqQ8ULio8pz4f@mail.gmail.com>
	<20110318185154.GA8028@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110318185154.GA8028-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 18 Mar 2011 14:51:54 -0400
Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> On Thu, Mar 17, 2011 at 12:17:24PM -0500, Steve French wrote:
> > If others feel strongly about this, I don't mind changing it as
> > Christoph suggests but
> > - to samba people, "incrementing the rfc1001 length" would be more
> > recognizable (than opencoding the be32_add_cpu macro), and the
> > function name was
> > actually Jeff's suggestion which I liked.
> 
> I don't mind the rfc1001 length per se.  What's totally braindead about
> this is having an absolutely trivial wrapper for incrementing a field,
> which has a different name than the field it increments.
> 
> If you feel strongly about the rfc1001 length just rename the field.
> 

FWIW, the MS-SMB doc calls this value the "Stream Protocol Length". It
also mentions that this is actually a 24 bit field and the upper 8 bits
are supposed to be zeroed out.

Should this wrapper check for values that violate that? A little
defensive coding in this area wouldn't hurt.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
