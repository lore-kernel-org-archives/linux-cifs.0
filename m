From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: kernel:  CIFS VFS: Filldir for current dir failed
Date: Tue, 1 Mar 2011 11:33:10 -0500
Message-ID: <20110301113310.5eb89897@tlielax.poochiereds.net>
References: <4DF45E2A2AD923468B6688F16447BDE90508DB91@EX04.service.utwente.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: <a.sluik-HVpl4/oQiP/z+pZb47iToQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DF45E2A2AD923468B6688F16447BDE90508DB91-S4MjG6e2EGO+mPTwocfnKj0g50+Wg8sO@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 1 Mar 2011 16:25:26 +0100
<a.sluik-HVpl4/oQiP/z+pZb47iToQ@public.gmane.org> wrote:

> [pid 18120] getdents(5, 0x80975c4, 32768) = -1 ENOMEM (Cannot allocate memory)

That looks like the problem -- getdents is returning -ENOMEM. 1.61 is a
year and a half old, however (2.6.32 or so). Perhaps you could test
something more recent (something like 2.6.38 or so) and let us know
whether the problem persists?

Thanks,
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
