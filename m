From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Fix broken lanman (lm) auth code (try #3)
Date: Wed, 16 Feb 2011 14:53:50 -0600
Message-ID: <AANLkTimu6hEEVgDq9qwpivJR3mZEAwHuKxbzaTCGESM+@mail.gmail.com>
References: <1297888050-15736-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1297888050-15736-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Feb 16, 2011 at 2:27 PM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>
> Fix lanman (lm) authentication code.
>
> Change lm response length back to 24 from 16.
> Parse lanmani mount option.

lanman21 (and earlier dialects) did not support packet signing
(requires NTLM12 or later dialect.  I don't know what happens if
you try to set sec=lanmani with your patch
but I would not expect it to ever force signing and work.


We note this in our readme e.g.
 sign           Must use packet signing (helps avoid unwanted data modification
		by intermediate systems in the route).  Note that signing
		does not work with lanman or plaintext authentication.


-- 
Thanks,

Steve
