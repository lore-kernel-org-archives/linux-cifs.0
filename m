From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: stable page writes: wait_on_page_writeback and packet signing
Date: Thu, 10 Mar 2011 02:34:54 -0500
Message-ID: <20110310073453.GA20224@infradead.org>
References: <AANLkTinFx9KGKDWSdUvFSvT4S6f9QjBzX=6Uo17oO89+@mail.gmail.com>
 <20110309215148.GW15097@dastard>
 <AANLkTinDmqah6pQnHugoVxh-gDq+6+MDMuh-TyVAQ7LP@mail.gmail.com>
 <1299721264.2976.3.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Mingming Cao <mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Trond Myklebust <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1299721264.2976.3.camel-rJ7iovZKK19ZJLDQqaL3InhyD016LWXt@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Mar 09, 2011 at 08:41:03PM -0500, Trond Myklebust wrote:
> So what if the server crashes, or you get some other transient error?

I don't think the CIFS world cares.  E.g. a Samba in default
configuration never even bothers to do a fsync on the underlying server,
which to me implies data integrity is not of concern for usual CIFS
setups.
