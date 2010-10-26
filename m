From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] [CIFS] [3/3 -v4] NTLM auth and sign - Use kernel crypto
 apis to calculate hashes and smb signatures
Date: Tue, 26 Oct 2010 10:11:26 -0400
Message-ID: <20101026101126.0abb6e13@tlielax.poochiereds.net>
References: <1287689117-3634-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1287689117-3634-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 21 Oct 2010 14:25:17 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Use kernel crypto sync hash apis insetead of cifs crypto functions.
> The calls typically corrospond one to one except that insead of
> key init, setkey is used.
> 
> Use crypto apis to generate smb signagtures also.
> Use hmac-md5 to genereate ntlmv2 hash, ntlmv2 response, and HMAC (CR1 of
> ntlmv2 auth blob.
> User crypto apis to genereate signature and to verify signature.
> md5 hash is used to calculate signature.
> Use secondary key to calculate signature in case of ntlmssp.
> 
> For ntlmv2 within ntlmssp, during signature calculation, only 16 bytes key
> (a nonce) stored within session key is used. during smb signature calculation.
> For ntlm and ntlmv2 without extended security, 16 bytes key
> as well as entire response (24 bytes in case of ntlm and variable length
> in case of ntlmv2) is used for smb signature calculation.
> For kerberos, there is no distinction between key and response.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Looks fine overall. Again, my expertise in the crypto/NTLMSSP area is
limited, so I'll just give an ack here.

Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
