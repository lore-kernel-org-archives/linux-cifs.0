From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix the conflict between rwpidforward and rw mount options
Date: Sat, 27 Aug 2011 14:41:36 +0400
Message-ID: <CAKywueTwKA38HxwCmmON-96gasPvoSR2HzPgHuU1iEXw_Q6a-w@mail.gmail.com>
References: <1314381783-5614-1-git-send-email-piastry@etersoft.ru>
	<20110827060011.55847806@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110827060011.55847806-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/8/27 Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>:
> On Fri, 26 Aug 2011 22:03:03 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Both these options are started with "rw" - that's why the first one
>> isn't switched on even if it is specified. Rename it to piforwardio
>> to avoid the wrong matching.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>
>
> This seems like the wrong way to fix this. Isn't this a problem in
> userspace code? It seems like fixing mount.cifs to handle this properly
> would be a better fix, and we wouldn't need to change a mount option
> (without warning) that's already in kernels that are in the field.
>
> NAK from my point of view...
>

In kernel code we have the section :

cifs_parse_mount_options:
...
} else if (strnicmp(data, "rw", 2) == 0) {
        /* ignore */
} else if (strnicmp(data, "ro", 2) == 0) {
...
} else if (strnicmp(data, "rwpidforward", 4) == 0) {
        vol->rwpidforward = 1;
} else
...

So, it is not only the userspace problem. Even if we fix it kernel
code doesn't handle it right too. So, the easier way to fix this is to
rename the option, I think.

-- 
Best regards,
Pavel Shilovsky.
