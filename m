From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] autoconf: work around broken wbclient.h file
Date: Fri, 26 Aug 2011 07:50:28 -0400
Message-ID: <20110826075028.3b0d7670@tlielax.poochiereds.net>
References: <1314304263-2153-1-git-send-email-jlayton@samba.org>
	<CADT32eKM_M1m+3o4B_d_0hTe5aJGek0pvj8DfX3a9-0naRfpqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eKM_M1m+3o4B_d_0hTe5aJGek0pvj8DfX3a9-0naRfpqA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 25 Aug 2011 15:55:14 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Thu, Aug 25, 2011 at 3:31 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> > Some versions of wbclient.h have function declarations with bool type
> 
> Jeff, did not understand this verbiage, did you mean winbind library
> or source files or something else?
> Other than that, looks fine.
> 

I meant the header, but I did screw up the verbiage here. That should read:

    autoconf: work around broken wbclient.h file
    
    Some versions of wbclient.h have function declarations with bool type
    args, but they don't include stdbool.h themselves. Make sure that
    we can deal with that by telling the autoconf test to include stdbool.h
    explicitly. In order to do that properly we need to move some of the
    standard header and type tests up in the file.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
