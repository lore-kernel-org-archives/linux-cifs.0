From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH resubmit 1/1] Add additional error text for missing mount.cifs
Date: Sun, 11 May 2014 22:27:54 -0500
Message-ID: <CAH2r5mugir6RneoE1h2VBnyu0itsCSZLLXHF=L_27dQi1Z48tw@mail.gmail.com>
References: <20140423184055.GA18378@woodpecker.gentoo.org> <20140502155346.023f2170@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Mike Pagano <mpagano-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140502155346.023f2170-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, May 2, 2014 at 2:53 PM, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org> wrote:
> On Wed, 23 Apr 2014 14:40:56 -0400
> Mike Pagano <mpagano-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org> wrote:
>
>> If a cifs mount is attempted without mount.cifs present on the
>> system the following appears via dmesg:
>>
>> [   25.949378] CIFS VFS: No username specified
>>
>> The purpose of this patch is to better inform the user of the
>> possible cause of the error and show a potential solution.
>>
>> The output for this error condition will look approximately like this:
>>
>> [   11.183392] CIFS VFS: No username specified. Could not find
>> /sbin/mount.cifs. Please ensure your system has this userspace program
>> installed.
<snip>
> I dunno. This doesn't seem like it's fixing a real problem to me.
>
> While we highly recommend that people use the mount helper. It's not
> specifically *required* per-se. If you can roll up the right mount
> options and hand them to the kernel then there's no real problem.
>
> If you really want this sort of warning, why not put it
> into /bin/mount? Then you could even output the warning message to the
> terminal instead of the kernel's ring buffer.

I don't have a strong opinion on this, although the patch is probably
harmless.  I slightly prefer that it go in /bin/mount instead of
mount.cifs  but would reconsider if new arguments in favor of it going
in the kernel


-- 
Thanks,

Steve
