From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SMB3 Signing part 1
Date: Thu, 13 Jun 2013 18:10:37 -0500
Message-ID: <CAH2r5msG_o_oX+dTHy-1a6C9T8E0EdZzq_eynVH1ZnNabzcMmw@mail.gmail.com>
References: <CAH2r5mvtOFqcqcdbXxcK8Ci0bqzznRmEfDjfYM0RZPfemobdsw@mail.gmail.com>
	<CADT32eLVtj+Ld624og-fcvKfORd1WyxVqjnnxNvMd7-3_x3SBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eLVtj+Ld624og-fcvKfORd1WyxVqjnnxNvMd7-3_x3SBw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Jun 13, 2013 at 5:49 PM, Shirish Pargaonkar
<shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Steve, Thanks. But I think what we have here itself needed to
> changed as per Jeff Layton's comments.  He is suggesting
> and I do agree and was working on invoking respective crypto
> algorithms per smb, smb2.1, and smb3 signing instead of
> invoking all of them per any kind of signing.
>
> Changing signing for smb2.1 and smb3 from per smb connection
> to smb session is somewhat non-trivial but I do plan to work on that
> piece of code once I am back.

I actually don't think it looks that bad - Jeff's cifs auth rewrite, makes
this much easier.


-- 
Thanks,

Steve
