From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: CIFS VFS errors
Date: Wed, 22 Jun 2011 16:32:51 -0400
Message-ID: <20110622163251.16499f4b@tlielax.poochiereds.net>
References: <4BEC36376CA24EBFAA83C16B955BD9CC@dynamicsourcemfg.local>
	<20110608164415.5b8cbf4b@tlielax.poochiereds.net>
	<7A5FF1B06368450BAE39549CE3C621CF@dynamicsourcemfg.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "Shane McColman" <smccolman-WkVietXGWdS4IGBGpn4MSVaTQe2KTcn/@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7A5FF1B06368450BAE39549CE3C621CF-WkVietXGWdS4IGBGpn4MSbjjLBE8jN/0@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 22 Jun 2011 14:12:23 -0600
"Shane McColman" <smccolman-WkVietXGWdS4IGBGpn4MSVaTQe2KTcn/@public.gmane.org> wrote:

> Over the past two days the number of error messages stayed the same but now
> I'm getting the same problems as reported in 
> 
> Bug 36952 -  [2.6.39] CIFS write failures where 2.6.38 works  
> 
> I had to restart my software this morning, but I'm pretty sure I should be
> back to the same spot by Monday (if not sooner).  I can turn on debug
> logging (as suggested by Jeff in reply to Helge's email) if somebody is
> interested.  Just let me know.  I really need to get this fixed, so just let
> me know what I can do to help.
>

I suspect that the issue is with signed connections. Are you using
signed authentication? The patch that I posted earlier today should fix
this in mainline if so.

We'll need to do something different for 2.6.39 though. A possible
workaround in the meantime is to set the wsize to something smaller, eg
wsize=16384. Could you try that and let me know if it makes the problem
go away?

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
