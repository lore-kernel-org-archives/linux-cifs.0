From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Cleanup and thus reduce smb session structure and
 fields used during authentication
Date: Thu, 28 Oct 2010 15:56:41 -0400
Message-ID: <20101028155641.67996dc2@tlielax.poochiereds.net>
References: <1288277587-9262-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1288277587-9262-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 28 Oct 2010 09:53:07 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Removed following fields from smb session structure
>  cryptkey, ntlmv2_hash, tilen, tiblob
> and ntlmssp_auth structure is allocated dynamically only if the auth mech
> in NTLMSSP.
> 
> response field within a session_key structure is used to initially store the
> target info (either plucked from type 2 challenge packet in case of NTLMSSP
> or fabricated in case of NTLMv2 without extended security) and then to store
> Message Authentication Key (mak) (session key + client response).
> 
> Server challenge or cryptkey needed during a NTLMSSP authentication
> is now part of ntlmssp_auth structure which gets allocated and freed
> once authenticaiton process is done.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Nice cleanup. Looks good.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
