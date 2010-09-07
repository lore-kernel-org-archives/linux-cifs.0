From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH][ntlmv2 in ntlmssp 0/8] - resend in small
 chunks
Date: Tue, 7 Sep 2010 09:34:45 -0400
Message-ID: <20100907093445.0d6ff4f5@corrin.poochiereds.net>
References: <1283830218-24939-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1283830218-24939-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon,  6 Sep 2010 22:30:18 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> Make NTLMv2 as a default authentication mechanism within NTLMSSP
> 
> Enable cifs/smb signing
> 
> Use Crypto sync hash APIs instead of cifs crypto functions to genereate
> various hashes such as arc4/rc4, md5, and hmac-md5 used during authentication
> and smb/cifs signature generation
> 

The patches almost all lack real descriptions. I'm not sure whether
that was intentional or not, but some of them could *really* use some
explanation.

Also, I don't think this patchset is really complete yet. The last
patch in this set should be "Remove old private CIFS crypto routines".
With the move to using the standard kernel crypto API, it seems like we
should have a net reduction in code or at least something closer to 0.
That would make it a lot easier to stomach taking in a large patchset
like this.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
