From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 0/7 cifs] ntlm authentication and signing
Date: Wed, 29 Sep 2010 15:42:47 -0400
Message-ID: <20100929154247.579508c0@tlielax.poochiereds.net>
References: <1285771338-23272-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1285771338-23272-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 29 Sep 2010 09:42:18 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> --
> Fix broken NTLMv2 (without extended security) authentication mechanism.
> 
> Enable cifs/smb signing
> 
> Use Crypto sync hash APIs instead of cifs crypto functions to genereate
> various hashes such as arc4/rc4, md5, and hmac-md5 used during authentication
> --
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 

Is this a new set of patches that's intended to be applied on top of
the set you already sent? Or a respin of the remaining patches from the
old set? It's not clear since there's no "version" on the patch posting.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
