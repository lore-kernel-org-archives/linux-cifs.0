From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH -v2 0/6] ntlmv2 within ntlmssp - enable and sign using
 crypto apis
Date: Sun, 12 Sep 2010 20:27:01 -0400
Message-ID: <20100912202701.1cd7d8bf@corrin.poochiereds.net>
References: <1284056215-959-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1284056215-959-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu,  9 Sep 2010 13:16:55 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> Three major functionality changes
> 

Maybe this should be 3 separate patchsets then? It would be best if
these major functionality changes were bisectable. Also, these patches
mix a lot of trivial cleanup code in with the deltas that actually make
the major changes. Those should be separated.

IOW, more patches that are smaller and targeted would be ideal.

> 
> Make NTLMv2 as a default authentication mechanism within NTLMSSP
> 
> Enable cifs/smb signing
> 
> Use Crypto sync hash APIs instead of cifs crypto functions to genereate
> various hashes such as arc4/rc4, md5, and hmac-md5 used during authentication
> and smb/cifs signature generation
> 

It seems like this set should be a net reduction in code or at least
something closer to 0. This set should not be merged without an
accompanying patch to remove the unused crypto code after the
conversion to the kernel crypto APIs.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
