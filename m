From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] NTLM auth and sign - Use appropriate server challenge
Date: Wed, 27 Oct 2010 16:56:19 -0400
Message-ID: <20101027165619.512b50e8@tlielax.poochiereds.net>
References: <1288210836-12380-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1288210836-12380-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 27 Oct 2010 15:20:36 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Need to have cryptkey or server challenge in smb connection
> (struct TCP_Server_Info) for ntlm and ntlmv2 auth types for which
> cryptkey (Encryption Key) is supplied just once in Negotiate Protocol
> response during an smb connection setup for all the smb sessions over
> that smb connection.
> 
> For ntlmssp, cryptkey or server challenge is provided for every
> smb session in type 2 packet of ntlmssp negotiation, the cryptkey
> provided during Negotiation Protocol response before smb connection
> does not count.
> 
> Rename cryptKey to cryptkey and related changes.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsencrypt.c |   10 +++++++---
>  fs/cifs/cifsglob.h    |    3 ++-
>  fs/cifs/cifssmb.c     |    4 ++--
>  fs/cifs/connect.c     |    4 ++--
>  fs/cifs/sess.c        |   12 ++++++++----
>  5 files changed, 21 insertions(+), 12 deletions(-)
> 

[...]

>  
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 67d6a22..b736951 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -196,6 +196,7 @@ struct TCP_Server_Info {
>  	int capabilities; /* allow selective disabling of caps by smb sess */
>  	int timeAdj;  /* Adjust for difference in server time zone in sec */
>  	__u16 CurrentMid;         /* multiplex id - rotating counter */
> +	char cryptkey[CIFS_CRYPTO_KEY_SIZE]; /* used by ntlm, ntlmv2 etc */
>  	/* 16th byte of RFC1001 workstation name is always null */
>  	char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
>  	__u32 sequence_number; /* needed for CIFS PDU signature */
> @@ -240,7 +241,7 @@ struct cifsSesInfo {
>  	char userName[MAX_USERNAME_SIZE + 1];
>  	char *domainName;
>  	char *password;
> -	char cryptKey[CIFS_CRYPTO_KEY_SIZE];
> +	char cryptkey[CIFS_CRYPTO_KEY_SIZE]; /* used by ntlmssp */

I'm trying to understand why we need ses->cryptkey at all. It holds the
cryptkey provided by the server only if we're using ntlmssp. It's
only used once, and essentially it just holds the key until we have a
auth_key.response field that we can stuff this in. Is that correct? If
so, wouldn't it make more sense to just allocate the auth_key.response
field earlier and put this directly in there?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
