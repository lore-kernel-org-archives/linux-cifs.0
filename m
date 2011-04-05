From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Repeatable crash in 2.6.38 related to O_DIRECT
Date: Tue, 5 Apr 2011 16:38:02 -0700
Message-ID: <20110405163802.778b55b3@corrin.poochiereds.net>
References: <4D9B9BB0.3030604@candelatech.com>
	<20110405162609.6776e264@corrin.poochiereds.net>
	<4D9BA6F9.1050207@candelatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D9BA6F9.1050207-my8/4N5VtI7c+919tysfdA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 05 Apr 2011 16:34:17 -0700
Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> wrote:

> On 04/05/2011 04:26 PM, Jeff Layton wrote:
> 
> > Does the attached patch fix it? It's probably stable material if so...
> 
> I'll test your patch.  I verified that cifs_file is NULL in cifsFileInfo_put
> and protecting against that also solves the problem.
> 

I'd probably prefer the patch I'm suggesting. I worry that turning
cifsFileInfo_put into a no-op for NULL pointers might paper over future
bugs.

> >
> > FWIW, cifs doesn't handle O_DIRECT at all.
> 
> I know..and I warn my users when the open() call fails, but I still
> let them attempt the file open.  Seems a decent test case after all :)
> 

Definitely. It's a cifs bug for sure, just pointing out that it
probably isn't going to give you what you expect. As Steve points out
forcedirectio might give you something closer to this, but proper
O_DIRECT support is still on the to-do list.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
