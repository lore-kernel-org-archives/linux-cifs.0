From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: reinstate the forcegid option
Date: Thu, 04 Oct 2012 15:50:57 +0100
Message-ID: <1349362257.3691.6.camel@localhost>
References: <1349294556-20656-1-git-send-email-jlayton@redhat.com>
	 <506D8C16.6070408@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <506D8C16.6070408-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2012-10-04 at 18:46 +0530, Suresh Jayaraman wrote:
> On 10/04/2012 01:32 AM, Jeff Layton wrote:
> > Apparently this was lost when we converted to the standard option
> > parser.
> > 
> > Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Reported-by: Gregory Lee Bartholomew <gregory.lee.bartholomew-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> 
> Oops, atleast a couple of options have been reported missing and fixed
> so far. Time to audit the new parsing code so that we fix them
> proactively before we get reports from users..?
> 

I am taking another look at the code to compare the options supported
against the old parser with the new parser. Some gotchas which tripped
me last time were checks for shortened options which also matched the
longer versions of the mount options.

We should also start thinking about paring down the number of mount
options which in my opinion are on the high side.

Sachin Prabhu
