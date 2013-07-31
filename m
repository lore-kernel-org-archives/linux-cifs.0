From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Backporting the CIFS module
Date: Wed, 31 Jul 2013 11:15:26 -0400
Message-ID: <20130731111526.6cbf68de@tlielax.poochiereds.net>
References: <loom.20130731T161003-507@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dame Dimitrov <ddimitro-vkGj3nKBv85YqTQye2laTg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20130731T161003-507-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 31 Jul 2013 14:13:46 +0000 (UTC)
Dame Dimitrov <ddimitro-vkGj3nKBv85YqTQye2laTg@public.gmane.org> wrote:

> Hi,
> 
> We're planning to replace some NFS mounts with CIFS mounts,  with the help
> multiuser option of CIFS.
> But unfortunately we have some CentOS 5 machines, and the cifs.ko kernel
> module (v. 1.60) does not support the multiuser option,
> Can anyone give a hint how can I backport for example the cifs module from
> CentOS6 (v. 1.68) to CentOS5, and if it's at all doable?
> 
> Thanks and cheers,
> Dame.
> 

Heh... *anything* is doable. The problem of course is that it's
absolutely non-trivial. The VFS layer infrastructure is quite different
between RHEL5 and RHEL6.

I'm the person who wrote most of that code and I refrained from trying to
backport any of it to RHEL5 mostly due to the huge amount of changes
that it would have involved.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
