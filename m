From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Rename cERROR and cFYI to cifs_dbg
Date: Sun, 24 Mar 2013 23:44:41 -0500
Message-ID: <CAH2r5mtOC149YigDxnHLfSU64jLk5bzGcMhpqTTQgS0Eyg3HqA@mail.gmail.com>
References: <1363128287.23052.21.camel@joe-AO722>
	<1363174614.2031.9.camel@joe-AO722>
	<20130313075155.7464a34a@tlielax.poochiereds.net>
	<1363178421.2031.29.camel@joe-AO722>
	<1363289077.2146.19.camel@joe-AO722>
	<20130315150136.7f7a262a@tlielax.poochiereds.net>
	<CAH2r5mvW29FV+stH5CsjY5S2FdaHn48TfiSEk_beC=NzHC7-MQ@mail.gmail.com>
	<1363380204.2433.12.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1363380204.2433.12.camel@joe-AO722>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Mar 15, 2013 at 3:43 PM, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org> wrote:
> On Fri, 2013-03-15 at 15:16 -0500, Steve French wrote:
>
>> I would like to merge the three we have (one still has to be put in
>> for-next - the one from Jeff) for for-next in the next three or fouir
>> days - but I can create another temporary branch for the ones for 3.10
>> - but ... I would like to simplify things by merging the other cleanup
>> patches we already have first.  I agree that we are going to have to
>> let people know to rebase everything for cifs for 3.10 on this big
>> cleanup patch.
>
> Another possibility is to extend the
> cifs_dbg(type, fmt. ...) types from
>
> VFS, FYI, NOISY
>
> so that the messages could be
> filtered/classified better.
>
> Also, perhaps it'd be better to use
> pr_debug instead of KERN_ERR for
> the VFS messages.

Although it required hand merging, this large patch is now merged into
cifs-2.6.git (for-next branch, destined for 3.10) but ... I only
merged three obvious other patches (destined for 3.10) before it

4521ba9ca4138f424769f17ae7166ff5ccf08805 fs: cifs: use kmemdup instead
of kmalloc + memcpy
41057e5a5d673015fc0d0e587e993d26f1818b1c cifs: replaced kmalloc +
memset with kzalloc
8f43465d17982767dd5b3f5d48216ef5c100c274 cifs: ignore the unc= and
prefixpath= mount options

and I merged one so far after it that Jeff had already rebased ontop
of Joe's large patch

457d2157ec2da6f9fa755e16ab740979f581e328 cifs: remove ENOSPC handling
in smb_sendv

So ... going forward for 3.10 make sure to fixup subsequent new cifs
patches ontop Joe's large "cifs: Rename cERROR and cFYI to cifs_dbg"
patch or else it will make merging a mess since Joe's patch changes
just about very cifs file due to the macro renaming.



-- 
Thanks,

Steve
