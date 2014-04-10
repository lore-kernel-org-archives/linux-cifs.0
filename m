From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: mount.cifs question: mounting a cifs share located on an IBM
 z/OS mainframe to a linux machine
Date: Thu, 10 Apr 2014 13:47:44 -0400
Message-ID: <20140410134744.7fab7b0e@tlielax.poochiereds.net>
References: <CACERx8gmfuw+B7zkX+hfTOFrpTghEVkSEMxSK+TZ9QsrG9vFkA@mail.gmail.com>
	<20140409153807.05b587fa@tlielax.poochiereds.net>
	<CACERx8gGJQ6ykNp5XGVX_YZdOL9figHG-2v7y39Bs4_ha6f7Hg@mail.gmail.com>
	<20140409162739.65689422@tlielax.poochiereds.net>
	<CACERx8iEFmb+y+N4NAeqpcDtqZi+C-EWPuvA01E+1QpR4bKynw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nadezhda Ivanova <nivanova-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACERx8iEFmb+y+N4NAeqpcDtqZi+C-EWPuvA01E+1QpR4bKynw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 10 Apr 2014 20:41:02 +0300
Nadezhda Ivanova <nivanova-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> Hi Jeff,
> Thank you for the detailed explanation! The stricter checking makes
> sense to me now.
> Can you tell me what is wrong with the Protocol Negotiation response
> returned to the windows client (the win_cifs.cap)? I thought it was
> correct, as it has indeed 18 bytes after bcc, and you can see that the
> primary domain is WORKGROUP, obviously I am missing something...
> 
> Regards,
> Nadya
> 

Yeah, the lengths in the windows capture look fine and it's NULL
terminated properly. I'm not sure why wireshark is complaining, but I'd
suspect that it's because the server has set the unicode bit in the
capability bits, but isn't sending that string in unicode.

If the server sent a response that looked like that to the cifs client,
I suspect that it would accept it and move on.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
