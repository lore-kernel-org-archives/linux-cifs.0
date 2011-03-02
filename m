From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: kernel:  CIFS VFS: Filldir for current dir failed
Date: Wed, 2 Mar 2011 07:05:03 -0500
Message-ID: <20110302070503.02ce990d@tlielax.poochiereds.net>
References: <4DF45E2A2AD923468B6688F16447BDE90508DB91@EX04.service.utwente.nl>
	<20110301113310.5eb89897@tlielax.poochiereds.net>
	<4DF45E2A2AD923468B6688F16447BDE90508DD6E@EX04.service.utwente.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: <a.sluik-HVpl4/oQiP/z+pZb47iToQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DF45E2A2AD923468B6688F16447BDE90508DD6E-S4MjG6e2EGO+mPTwocfnKj0g50+Wg8sO@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2 Mar 2011 10:01:44 +0100
<a.sluik-HVpl4/oQiP/z+pZb47iToQ@public.gmane.org> wrote:

> Hi Jeff,
> 
> 
> Yes, but maybe there was a code change from v1.60 to v1.61 in the
> mount.cifs ?
> 
> Or do you know if the cifs kernel module in  2.6.38 is changed, has
> another version ?
> 
> It is from the Oracle Enterprise Linux (OEL5.6), we alse reported this
> issue to Oracle.
> Oracle delivers also the OEL6.0, but Oracle Database is not released yet
> for OEL6.0.
> 

Re-cc'ing linux-cifs...

This is almost certainly a kernel problem. The mount.cifs version is
unlikely to matter here. I guess you're using their 2.6.32 kernel on
RHEL5's userland?

In any case, this problem doesn't look familiar to me. You'll probably
need to work with Oracle to get a fix unless you can reproduce it on
something more recent.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
