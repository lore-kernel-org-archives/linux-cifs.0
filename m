From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH linux-next] cifs: Cleanup and clarify CalcNTLMv2_response()
Date: Sat, 19 Oct 2013 09:08:49 -0500
Message-ID: <CADT32eKY0roovoZtm5+fVHEVco1G3qawxk-KaBSV3pH95c6jrg@mail.gmail.com>
References: <1382115075-4386-1-git-send-email-timg@tpi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Tim Gardner <timg-l6nL5VImRDY@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382115075-4386-1-git-send-email-timg-l6nL5VImRDY@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Tim,

Since when a NTLMv2 response is sent, contains a
session key, hmac-md5 digest, and the blob,
the offset has  + 8 to include 16 bytes of hmac-md5 digest.
hmac-md5 digest is based on 8 bytes of server challenge
and the blob.
So hmac-md5 digest (output) overwrites total 16 bytes in overall
ntlmv2 response after session key and is followed by the blob.

At this point in time, we are dealing with the opaque data, so casting those
16 bytes (after session key and before the blob) as ntlmv2_response
structure does not appear correct and can be confusing.

Regards,

Shirish

On Fri, Oct 18, 2013 at 11:51 AM, Tim Gardner <timg-l6nL5VImRDY@public.gmane.org> wrote:
> Use of a structure aids in the understanding of this
> seemingly simple bit of code. The addition of a couple
> of comments also helps.
>
> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> Signed-off-by: Tim Gardner <timg-l6nL5VImRDY@public.gmane.org>
> ---
>
> I'd just like to be sure that the destructive copy is
> really what was intended. I can't tell from reading the MSDN
> section 3.3.2 NTLM v2 Authentication. It sort of makes
> my head hurt.
>
> rtg
>
>  fs/cifs/cifsencrypt.c |   21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index fc6f4f3..fecbfd0 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -548,7 +548,9 @@ static int
>  CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
>  {
>         int rc;
> -       unsigned int offset = CIFS_SESS_KEY_SIZE + 8;
> +       struct ntlmv2_resp *resp = (struct ntlmv2_resp *)
> +               (ses->auth_key.response + CIFS_SESS_KEY_SIZE);
> +       unsigned int hashed_len = ses->auth_key.len - (CIFS_SESS_KEY_SIZE + 8);
>
>         if (!ses->server->secmech.sdeschmacmd5) {
>                 cifs_dbg(VFS, "%s: can't generate ntlmv2 hash\n", __func__);
> @@ -569,21 +571,30 @@ CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
>                 return rc;
>         }
>
> +       /*
> +        * The cryptkey is part of the buffer that feeds the MD5 hash, but
> +        * gets over written later by the digest. See crypto_shash_final()
> +        * below.
> +        */
>         if (ses->server->negflavor == CIFS_NEGFLAVOR_EXTENDED)
> -               memcpy(ses->auth_key.response + offset,
> +               memcpy(&resp->ntlmv2_hash[CIFS_SERVER_CHALLENGE_SIZE],
>                         ses->ntlmssp->cryptkey, CIFS_SERVER_CHALLENGE_SIZE);
>         else
> -               memcpy(ses->auth_key.response + offset,
> +               memcpy(&resp->ntlmv2_hash[CIFS_SERVER_CHALLENGE_SIZE],
>                         ses->server->cryptkey, CIFS_SERVER_CHALLENGE_SIZE);
>         rc = crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
> -               ses->auth_key.response + offset, ses->auth_key.len - offset);
> +               &resp->ntlmv2_hash[8], hashed_len);
>         if (rc) {
>                 cifs_dbg(VFS, "%s: Could not update with response\n", __func__);
>                 return rc;
>         }
>
> +       /*
> +        * Yes - this is destructive. The 16 byte MD5 digest clobbers the
> +        * cryptkey that was just copied into &resp->ntlmv2_hash[8].
> +        */
>         rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
> -               ses->auth_key.response + CIFS_SESS_KEY_SIZE);
> +               resp->ntlmv2_hash);
>         if (rc)
>                 cifs_dbg(VFS, "%s: Could not generate md5 hash\n", __func__);
>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
