From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: use standard token parser for mount options
Date: Wed, 14 Mar 2012 15:43:31 -0400
Message-ID: <4F60F4E3.5010003@gmail.com>
References: <4F5A2CCD.6010808@gmail.com>	<24dc471d-42ca-45cf-89eb-26dc3117fa1a@zmail17.collab.prod.int.phx2.redhat.com>	<20120314151811.65838f6b@redhat.com> <CAH2r5muUm-E5n6Le4JPnBZmKNJ46OJ8dYZdS9b79=O3UGif4Rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muUm-E5n6Le4JPnBZmKNJ46OJ8dYZdS9b79=O3UGif4Rg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 3/14/2012 3:30 PM, Steve French wrote:
> I don't mind reviewing this, but it does appear to change behaviour
> significantly from existing code.  Does this fix a reported bug?
>
> The linux cifs kernel driver, like some other
> network clients, allows partial option matching to ease
> usability for users of other platforms (e.g. "pass" or
> "passwd" or "password" are intentionally all accepted
> since we match on the first four bytes of that keyword).
> Is there a way to get that to work with your patchset.
> I worry that some users will be confused that their
> mount options won't work if this is taken.
Unfortunately, that sometimes screws us up a bit on the userland side.  
(ref : http://patchwork.ozlabs.org/patch/54454/).

Some background: the original reason for this patch was to make it 
consistent with the NFS parsing code (and a few other file systems 
parsing).  This was on the tail end of me cleaning up the cifs-utils 
parsing because I thought it was a bit hard to read and scaled poorly 
for 80+ options.  That was the original intent (also, in my free time 
I'm kind of looking for a trophy patch to the kernel, it doesn't hurt 
the resume. :))

Does this make sense?  Does anyone else find the else/if tree a bit much 
to wade through?  Especially at the security parsing where you're a few 
level deep.
