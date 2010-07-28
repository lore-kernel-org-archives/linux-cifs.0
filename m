From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 0/4] cifs-utils: add -Wextra to CFLAGS and fix up
 warnings
Date: Wed, 28 Jul 2010 07:08:51 -0400
Message-ID: <20100728070851.5d0d56b6@corrin.poochiereds.net>
References: <1280259427-14617-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280259427-14617-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 27 Jul 2010 15:37:03 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> This patchset adds the -Wextra flag to CFLAGS and fixes up some of the
> warnings that that generates. There are still some others that I'm
> not sure how best to fix yet.
> 
> Jeff Layton (4):
>   automake: add -Wextra to CFLAGS
>   mtab: add __attribute__((unused)) to unused variables
>   cifs.upcall: swap c99 initializers for memset calls
>   data_blob: change for loop indices to a unsigned int
> 
>  Makefile.am   |    2 +-
>  cifs.upcall.c |    8 ++++++--
>  data_blob.c   |    4 ++--
>  mtab.c        |    4 ++--
>  4 files changed, 11 insertions(+), 7 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Set pushed to cifs-utils repo.
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
