From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: sparse warning in cifsacl.c
Date: Fri, 27 May 2011 15:44:59 -0400
Message-ID: <20110527154459.1da9c523@tlielax.poochiereds.net>
References: <BANLkTinzZeiiOChBDDymhCsuOw57fTP2Ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTinzZeiiOChBDDymhCsuOw57fTP2Ng-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 26 May 2011 23:48:45 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Shirish - below is a patch to fix a sparse warning in the cifsacl
> code.  The change around line 458 is cosmetic (doesn't look like the
> original code caused a problem but at least this quiets sparse) but
> doesn't sid_authusers have an endian error.   How far back does this
> bug go - does it affect much?
> 
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index 076b69c..5f02b4e 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -38,7 +38,7 @@ static const struct cifs_sid sid_everyone = {
>  	1, 1, {0, 0, 0, 0, 0, 1}, {0} };
>  /* security id for Authenticated Users system group */
>  static const struct cifs_sid sid_authusers = {
> -	1, 1, {0, 0, 0, 0, 0, 5}, {11} };
> +	1, 1, {0, 0, 0, 0, 0, 5}, {cpu_to_le32(11)} };
					^^^^^^^^^
This will break on big-endian arches. You need to use
__constant_cpu_to_le32() instead.

>  /* group users */
>  static const struct cifs_sid sid_user = {1, 2 , {0, 0, 0, 0, 0, 5}, {} };
> 
> @@ -458,7 +458,8 @@ int compare_sids(const struct cifs_sid *ctsid,
> const struct cifs_sid *cwsid)
>  	if (num_subauth) {
>  		for (i = 0; i < num_subauth; ++i) {
>  			if (ctsid->sub_auth[i] != cwsid->sub_auth[i]) {
> -				if (ctsid->sub_auth[i] > cwsid->sub_auth[i])
> +				if (le32_to_cpu(ctsid->sub_auth[i]) >
> +					le32_to_cpu(cwsid->sub_auth[i]))
>  					return 1;
>  				else
>  					return -1;
> 
> 


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
