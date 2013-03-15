From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] cifs: Rename cERROR and cFYI to cifs_dbg
Date: Fri, 15 Mar 2013 13:43:24 -0700
Message-ID: <1363380204.2433.12.camel@joe-AO722>
References: <1363128287.23052.21.camel@joe-AO722>
	 <1363174614.2031.9.camel@joe-AO722>
	 <20130313075155.7464a34a@tlielax.poochiereds.net>
	 <1363178421.2031.29.camel@joe-AO722> <1363289077.2146.19.camel@joe-AO722>
	 <20130315150136.7f7a262a@tlielax.poochiereds.net>
	 <CAH2r5mvW29FV+stH5CsjY5S2FdaHn48TfiSEk_beC=NzHC7-MQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvW29FV+stH5CsjY5S2FdaHn48TfiSEk_beC=NzHC7-MQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2013-03-15 at 15:16 -0500, Steve French wrote:

> I would like to merge the three we have (one still has to be put in
> for-next - the one from Jeff) for for-next in the next three or fouir
> days - but I can create another temporary branch for the ones for 3.10
> - but ... I would like to simplify things by merging the other cleanup
> patches we already have first.  I agree that we are going to have to
> let people know to rebase everything for cifs for 3.10 on this big
> cleanup patch.

Another possibility is to extend the
cifs_dbg(type, fmt. ...) types from

VFS, FYI, NOISY

so that the messages could be
filtered/classified better.

Also, perhaps it'd be better to use
pr_debug instead of KERN_ERR for
the VFS messages.
