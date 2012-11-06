From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 6/9] cifs: avoid extra allocation for small
 cifs.idmap keys
Date: Tue, 6 Nov 2012 16:02:10 -0500
Message-ID: <20121106160210.0d1cc9cb@tlielax.poochiereds.net>
References: <1350649250-5343-1-git-send-email-jlayton@redhat.com>
	<1350649250-5343-7-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350649250-5343-7-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 19 Oct 2012 08:20:47 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> The cifs.idmap keytype always allocates memory to hold the payload from
> userspace. In the common case where we're translating a SID to a UID or
> GID, we're allocating memory to hold something that's less than or equal
> to the size of a pointer.
> 
> When the payload is the same size as a pointer or smaller, just store
> it in the payload.value union member instead. That saves us an extra
> allocation on the sid_to_id upcall.
> 
> Note that we have to take extra care to check the datalen when we
> go to dereference the .data pointer in the union, but the callers
> now check that as a matter of course anyway.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsacl.c | 23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index f4508ee..12d70ee 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -49,6 +49,20 @@ cifs_idmap_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
>  {
>  	char *payload;
>  
> +	/*
> +	 * If the payload is less than or equal to the size of a pointer, then
> +	 * an allocation here is wasteful. Just copy the data directly to the
> +	 * payload.value union member instead.
> +	 *
> +	 * With this however, you must check the datalen before trying to
> +	 * dereference payload.data!
> +	 */
> +	if (prep->datalen <= sizeof(void *)) {
> +		key->payload.value = 0;
> +		memcpy(&key->payload.value, prep->data, prep->datalen);
> +		key->datalen = prep->datalen;
> +		return 0;
> +	}
>  	payload = kmalloc(prep->datalen, GFP_KERNEL);
>  	if (!payload)
>  		return -ENOMEM;
> @@ -62,7 +76,8 @@ cifs_idmap_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
>  static inline void
>  cifs_idmap_key_destroy(struct key *key)
>  {
> -	kfree(key->payload.data);
> +	if (key->datalen > sizeof(void *))
> +		kfree(key->payload.data);
>  }
>  
>  static struct key_type cifs_idmap_key_type = {
> @@ -245,7 +260,7 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
>  	 * probably a safe assumption but might be better to check based on
>  	 * sidtype.
>  	 */
> -	if (sidkey->datalen < sizeof(uid_t)) {
> +	if (sidkey->datalen != sizeof(uid_t)) {
>  		rc = -EIO;
>  		cFYI(1, "%s: Downcall contained malformed key "
>  			"(datalen=%hu)", __func__, sidkey->datalen);
> @@ -253,9 +268,9 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
>  	}
>  
>  	if (sidtype == SIDOWNER)
> -		fuid = *(uid_t *)sidkey->payload.value;
> +		fuid = (uid_t)sidkey->payload.value;
>  	else
> -		fgid = *(gid_t *)sidkey->payload.value;
> +		fgid = (gid_t)sidkey->payload.value;
>  

Finally got a BE machine to test this stuff on, and figured out that
the above delta is wrong. We're memcpy'ing the payload (sizeof(uid_t),
which is same as unsigned int) into the payload.value (which is an
unsigned long)

The above block then tries to cast the result of that to a uid_t/gid_t,
which works fine on a little-endian machine. Not so much on a BE one...

I'll send a respin for this patch once I've done a bit more testing.

Thanks,
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
