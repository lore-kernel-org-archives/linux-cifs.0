From: Wayne Walker <wwalker-7+hyfkrzchDWTcdHvfGLfFaTQe2KTcn/@public.gmane.org>
Subject: Re: Data corruption problem
Date: Thu, 10 Feb 2011 23:21:36 -0600
Message-ID: <20110211052136.GE27051@solid-constructs.com>
References: <20110211051458.GD27051@solid-constructs.com>
Reply-To: Wayne Walker <wwalker-7+hyfkrzchDWTcdHvfGLfFaTQe2KTcn/@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110211051458.GD27051-7+hyfkrzchDWTcdHvfGLfFaTQe2KTcn/@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Feb 10, 2011 at 11:14:59PM -0600, Wayne Walker wrote:
> first file:
> >>> 519995392 / 57344.
> 9068.0 # matching 56K blocks before the one null 56K block
> 
> second file is certainly on a 1 K boundary, but I mislaid the diff data
> for it and it's taking forever for cmp to run to find the offset and
> verify that it's on a 56K boundary.  I'll follow up to this email
> tomorrow with the result of the cmp.

>>> 7910088704/57344.
137941.0

the second file's error is also at a 56K boundary.

-- 

Wayne Walker
wwalker-7+hyfkrzchDWTcdHvfGLfFaTQe2KTcn/@public.gmane.org
(512) 633-8076
Senior Consultant
Solid Constructs, LLC

> A: Because it messes up the order in which people normally read text.
> > Q: Why is top-posting such a bad thing?
> > > A: Top-posting.
> > > > Q: What is the most annoying thing in e-mail?
