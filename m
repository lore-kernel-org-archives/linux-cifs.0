From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: fix cifsConvertToUCS() for the mapchars case
Date: Fri, 13 May 2011 20:17:05 -0400
Message-ID: <20110513201705.7fe75309@tlielax.poochiereds.net>
References: <1305257555-20656-1-git-send-email-metze@samba.org>
	<1305257555-20656-2-git-send-email-metze@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1305257555-20656-2-git-send-email-metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 13 May 2011 05:32:35 +0200
Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> Commit "cifs: fix unaligned accesses in cifsConvertToUCS"
> (84cdf74e8096a10dd6acbb870dd404b92f07a756) does multiple steps
> in just one commit (moving the function and changing it without testing).
> 
> put_unaligned_le16(temp, &target[j]); is never called for any codepoint
> the goes via the 'default' switch statement. As a result we put
> just zero (or maybe uninitialized) bytes into the target buffer,
> 
> Signed-off-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/cifs_unicode.c |   20 ++++++++++----------
>  1 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
> index fc0fd4f..b1ff0bd 100644
> --- a/fs/cifs/cifs_unicode.c
> +++ b/fs/cifs/cifs_unicode.c
> @@ -276,6 +276,7 @@ cifsConvertToUCS(__le16 *target, const char *source, int maxlen,
>  		return cifs_strtoUCS(target, source, PATH_MAX, cp);
>  
>  	for (i = 0, j = 0; i < maxlen; j++) {
> +		charlen = 1;
>  		src_char = source[i];
>  		switch (src_char) {
>  		case 0:
> @@ -315,18 +316,17 @@ cifsConvertToUCS(__le16 *target, const char *source, int maxlen,
>  				temp = 0x003f;
>  				charlen = 1;
>  			}
> -			len_remaining -= charlen;
> -			/*
> -			 * character may take more than one byte in the source
> -			 * string, but will take exactly two bytes in the
> -			 * target string
> -			 */
> -			i += charlen;
> -			continue;
> +			break;
>  		}
> +		/*
> +		 * character may take more than one byte in the source
> +		 * string, but will take exactly two bytes in the
> +		 * target string
> +		 */
>  		put_unaligned_le16(temp, &target[j]);
> -		i++; /* move to next char in source string */
> -		len_remaining--;
> +		/* move to next char in source string */
> +		i += charlen;
> +		len_remaining -= charlen;
>  	}
>  
>  ctoUCS_out:

Oof. Yeah, I broke it alright -- good catch...

This patch probably won't apply to the current head of the tree,
however. Rather than have a special patch for 2.6.38 and .39, what may
be best is to go ahead and push 581ade4d in Steve's master branch to
stable, and then apply something like this untested patch on top of it.

I'll plan to test it out when I get a chance, but I think that's
probably the best approach.

Thoughts?

-----------------[snip]--------------------

cifs: fix cifsConvertToUCS() for the mapchars case

As Metze pointed out, commit 84cdf74e broke mapchars case:

    Commit "cifs: fix unaligned accesses in cifsConvertToUCS"
    (84cdf74e8096a10dd6acbb870dd404b92f07a756) does multiple steps
    in just one commit (moving the function and changing it without
    testing).

    put_unaligned_le16(temp, &target[j]); is never called for any
    codepoint the goes via the 'default' switch statement. As a result
    we put just zero (or maybe uninitialized) bytes into the target
    buffer.

His proposed patch looks correct, but doesn't apply to the current head
of the tree. This patch should also fix it.

Reported-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_unicode.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 23d43cd..1b2e180 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -277,6 +277,7 @@ cifsConvertToUCS(__le16 *target, const char *source, int srclen,
 
 	for (i = 0, j = 0; i < srclen; j++) {
 		src_char = source[i];
+		charlen = 1;
 		switch (src_char) {
 		case 0:
 			put_unaligned(0, &target[j]);
@@ -316,16 +317,13 @@ cifsConvertToUCS(__le16 *target, const char *source, int srclen,
 				dst_char = cpu_to_le16(0x003f);
 				charlen = 1;
 			}
-			/*
-			 * character may take more than one byte in the source
-			 * string, but will take exactly two bytes in the
-			 * target string
-			 */
-			i += charlen;
-			continue;
 		}
+		/*
+		 * character may take more than one byte in the source string,
+		 * but will take exactly two bytes in the target string
+		 */
+		i += charlen;
 		put_unaligned(dst_char, &target[j]);
-		i++; /* move to next char in source string */
 	}
 
 ctoUCS_out:
-- 
1.7.4.4
