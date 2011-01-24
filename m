From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: just ignore extra junk at the end of the SMB
Date: Mon, 24 Jan 2011 14:31:23 -0500
Message-ID: <20110124143123.5393dc2e@tlielax.poochiereds.net>
References: <1293025147-11338-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Marcus Schopen <marcus-dLPT46B32WUjnolme5KbmQ@public.gmane.org>,
	Burkhard Obergoeker <burkhard.obergoeker-VYBfkVvgaNUmRHQWxfeBDQ@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293025147-11338-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 22 Dec 2010 08:39:07 -0500
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> If the server sends us a RFC1001 length that's larger than the SMB,
> then there's no reason to get our panties in a bunch and spew printk's,
> and there's certainly no reason just ignore the response completely like
> we do today. Just ignore the extra stuff on the end.
> 
> This fixes:
> 
>     https://bugzilla.samba.org/show_bug.cgi?id=7860
> 
> Reported-by: Marcus Schopen <marcus-dLPT46B32WUjnolme5KbmQ@public.gmane.org>
> Tested-by: Burkhard Obergoeker <burkhard.obergoeker-VYBfkVvgaNUmRHQWxfeBDQ@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/misc.c |   25 ++++++-------------------
>  1 files changed, 6 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 43f1028..b3df037 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c

Self-NAK on this patch. It eliminates the check for a RFC header
that's too short to hold the calculated SMB lengths. After looking over
the captures, it appears that removing that check is what allowed this
to work against the server, which is sending SMB's with length fields
that go beyond the end of the response.

We'll need to rethink this approach. Steve suggested that we might be
able to "fix up" the BCC and trans2 data lengths, but we need to
consider whether that's reasonable to do in the general case.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
