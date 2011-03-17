From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] [CIFS] Allocating SMB2 mids (multiplex identifier
 structures)
Date: Thu, 17 Mar 2011 10:35:14 -0400
Message-ID: <20110317143514.GB3295@infradead.org>
References: <AANLkTi=oYKfaOP-oHbBKODddGkzAWg7bBsY2_ZT9e-W8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTi=oYKfaOP-oHbBKODddGkzAWg7bBsY2_ZT9e-W8-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Btw, what branch are these commits for?  I dearly hope you're not trying
to push half-assed code to mainline.  Please do your development on a
branch first, and once there is a useable implementation it can be
reviewed and synced over.  Take a look at pnfs development for example.
