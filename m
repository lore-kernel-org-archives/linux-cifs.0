From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH][ntlmv2 in ntlmssp 0/8] - resend in small chunks
Date: Mon,  6 Sep 2010 22:30:18 -0500
Message-ID: <1283830218-24939-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Make NTLMv2 as a default authentication mechanism within NTLMSSP

Enable cifs/smb signing

Use Crypto sync hash APIs instead of cifs crypto functions to genereate
various hashes such as arc4/rc4, md5, and hmac-md5 used during authentication
and smb/cifs signature generation
