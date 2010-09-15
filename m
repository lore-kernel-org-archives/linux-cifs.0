From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH -v5 0/4] cifs NTLMv2/NTLMSSP - enable and sign using crypto apis
Date: Wed, 15 Sep 2010 17:37:58 -0500
Message-ID: <1284590278-5667-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Three major functionality changes

--
Make NTLMv2 as a default authentication mechanism within NTLMSSP

Enable cifs/smb signing

Use Crypto sync hash APIs instead of cifs crypto functions to genereate
various hashes such as arc4/rc4, md5, and hmac-md5 used during authentication
and smb/cifs signature generation
--


These patches are split into mainly three pathes, roughly per functionality
as mentioned above.
These are intended to fix the broken ntlmv2 functionality, enable signing
and replace cifs crypto functions with kernel crypto fuctions.
There still remains some clean-up to do, especially since exising crypto 
functions are used by auth mechs like NTLM which still get used.
A follow-up patch should and would follow to do just that.

Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
