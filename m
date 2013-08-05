From: "Damjan Dimitrov" <damjan.dimitrov-vkGj3nKBv86B+jHODAdFcQ@public.gmane.org>
Subject: RE: Backporting the CIFS module
Date: Mon, 5 Aug 2013 10:55:25 +0200 (CEST)
Message-ID: <0f1fe839.00001a70.0000000f@WS0031.netcetera.ch>
References: <loom.20130731T161003-507@post.gmane.org> <20130731111526.6cbf68de@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "'Jeff Layton'" <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130731111526.6cbf68de-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Content-Language: de-ch
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

>> Can anyone give a hint how can I backport for example the cifs module
from
>> CentOS6 (v. 1.68) to CentOS5, and if it's at all doable?
>
>Heh... *anything* is doable. The problem of course is that it's
>absolutely non-trivial. The VFS layer infrastructure is quite different
>between RHEL5 and RHEL6.
>
>I'm the person who wrote most of that code and I refrained from trying to
>backport any of it to RHEL5 mostly due to the huge amount of changes
>that it would have involved.
>

OK, thanks for the info. We have to do some OS upgrades now :)
And big thanks for the work on the module, the multiuser+kerberos mounts
work great on CentOS 6.4
