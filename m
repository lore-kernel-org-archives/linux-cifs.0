From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: The MID value 0xFFFF for CIFS ...
Date: Sun, 5 Aug 2012 21:09:55 -0500
Message-ID: <CAH2r5mtx_ccovybybsWiBwzziq338mm2A1ey4fdVJakEyMkCrA@mail.gmail.com>
References: <CACyXjPw4++WPF-UH-0LQHUQom0dA_dob6W_UP6=7B=0XVRy7Ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACyXjPw4++WPF-UH-0LQHUQom0dA_dob6W_UP6=7B=0XVRy7Ng-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Aug 5, 2012 at 2:54 PM, Richard Sharpe
<realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi folks,
>
> [MS-CIFS] in section 2.2.1.6.2 says, in part:
>
> ---------------
> The value 0xFFFF MUST NOT be used as a valid MID. All other possible
> values for MID, including
> zero (0x0000), are valid. The value 0xFFFF is used in an OpLock Break
> Notification request,
> which is an SMB_COM_LOCKING_ANDX Request (section 2.2.4.32.1) sent
> from the server.
> ---------------
>
> However, in smb1ops.c:cifs_get_next_mid I do not see where a MID value
> of 0xFFFF is skipped.
>
> Perhaps it is done somewhere else that I have not found, and if so,
> could someone point it out to me?

I don't see a place where this was checked, and cifs.ko has been doing
this presumably before MS-CIFS was published. Apparently has not been
causing problems having a mid of 0xFFFF from time to time, but might
as well fix it so we never send such a mid.



-- 
Thanks,

Steve
