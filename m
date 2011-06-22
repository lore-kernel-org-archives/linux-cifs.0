From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [2.6.39] CIFS write failures where 2.6.38 works
Date: Wed, 22 Jun 2011 16:36:12 -0400
Message-ID: <20110622163612.45744bc2@tlielax.poochiereds.net>
References: <4DE6103E.6010100@hist.no>
	<4DE8B449.2000008@suse.de>
	<4DE8F989.50208@hist.no>
	<20110609182845.1ebfc678@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Helge Hafting <helge.hafting-CND4fxrytsY@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110609182845.1ebfc678-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 9 Jun 2011 18:28:45 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Fri, 03 Jun 2011 17:11:05 +0200
> Helge Hafting <helge.hafting-CND4fxrytsY@public.gmane.org> wrote:
> 
> > On 03. juni 2011 12:15, Suresh Jayaraman wrote:
> > > [Cc linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org]
> > >
> > > On 06/01/2011 03:41 PM, Helge Hafting wrote:
> > >> At work I use cifs for accessing a windows server. This has worked fine
> > >> for a long time, up to and including Debian's 2.6.38-2.
> > >>
> > >> I just installed Debians's 2.6.39-1, and had to give up on it.
> > >> Mounting CIFS works, and I can see the files. But if I
> > >> try to make a new file (with cp), I get a long delay.
> > >
> > > What is the security mechanism you are using? If you seeing the problem
> > > with ntlm, could you try using ntlmv2 and see whether the problem is
> > > reproducible?
> > 
> > In the beginning, I did not specify the mechanism. So, whatever the 
> > default is.
> > 
> > The fstab entry was like this:
> > \\servername\resource /mountpoint cifs 
> > domain=MYDOMAIN,credentials=/etc/fstabcred,rw,noauto,iocharset=utf8,uid=username,gid=group,sockopt=TCP_NODELAY,users,file_mode=0640,dir_mode=0750,relatime 
> > 0 0
> > 
> > I looked at cifs options, and tried to add "sign" and "sec=ntlmv2i". It 
> > made no difference. Still failure with 2.6.39, and mounting with these 
> > new options works fine with 2.6.38
> > 
> 
> I think we need to understand what's happening on the wire. Are you
> still able to reproduce this? If so, can you turn up debug logging and
> reproduce this?. Instructions for how to do that are here:
> 
>     http://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Enabling_Debugging
> 
> Also, it looks like someone opened a bug at kernel.org too:
> 
>     https://bugzilla.kernel.org/show_bug.cgi?id=36952
> 
> ...so if you can attach the resulting log there, that would be great.
> 

I think that this is probably due to the change that added the
page_mkwrite function to cifs.ko. Prior to that, cifs did single-page
writes on signed connections. Now we do multi-page writes and windows
servers apparently reject large write calls on signed connections.

One way to test this theory would be to set the wsize to something
smaller when you mount. For instance:

    wsize=16384

...assuming that doesn't go over the server's MaxBufferSize, then that
should act as a workaround. Can you try that and let me know if it
helps?

Thanks,
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
