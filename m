From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] [CIFS] [2/4] NTLM authentication and signing - Make
 tiblob as part of session key (response)
Date: Fri, 15 Oct 2010 10:02:52 -0400
Message-ID: <20101015100252.3960b34d@tlielax.poochiereds.net>
References: <1286912719-22686-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286912719-22686-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 12 Oct 2010 14:45:19 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Have to move av_pair/ti blob to session key as part of ntlmv2 response.
> This entire blob is part of the response and is use to calculate
> signature for cases like ntlmv2 (without extended security) authentication.
> The size of the blob is hard coded to 1024 byte which should be
> sufficient to accomodate all 11 types of av pair types and their
> lenghts/values.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

[...]

>  	hmac_md5_final(v2_session_response, &context);
>  /*	cifs_dump_mem("v2_sess_rsp: ", v2_session_response, 32); */
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 7d834b1..5dd5659 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -105,6 +105,7 @@ struct session_key {
>  		struct {
>  			char key[16];
>  			struct ntlmv2_resp resp;
> +			unsigned char tiblob[CIFS_MAX_NTLMV2_AVPAIR_SIZE];

			^^^^^
Is this really the best way to do this? We're increasing the size of
this struct substantially, thereby increasing the size of every
TCP_Server_Info and cifsSesInfo struct by 1k.

Would it be better to keep the tiblob dynamically allocated, and hand
off the pointer to it? If it really is necessary to add this field to
the session_key struct in this way, would it be better to change how
session keys are managed? i.e. not embed them inside of TCP_Server_Info
and cifsSesInfo?

>  		} ntlmv2;
>  	} data;
>  };
> @@ -226,7 +227,6 @@ struct cifsSesInfo {
>  	struct session_key auth_key;
>  	char ntlmv2_hash[16];
>  	unsigned int tilen; /* length of the target info blob */
> -	unsigned char *tiblob; /* target info blob in challenge response */
>  	bool need_reconnect:1; /* connection reset, uid now invalid */
>  };
>  /* no more than one of the following three session flags may be set */
> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> index b0f4b56..e778165 100644
> --- a/fs/cifs/cifspdu.h
> +++ b/fs/cifs/cifspdu.h
> @@ -136,6 +136,11 @@
>  #define CIFS_SESS_KEY_SIZE (24)
>  
>  /*
> + * Max expected size of an av pair blob in ntlmv2 auth exchange
> + */
> +#define CIFS_MAX_NTLMV2_AVPAIR_SIZE (1024)
> +
> +/*

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
