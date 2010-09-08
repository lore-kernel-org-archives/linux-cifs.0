From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cifs tree updated to back out crypto/ntlmv2/ntlmssp change to 2.6.37
 - but now has the cifsd fixes
Date: Wed, 8 Sep 2010 16:25:09 -0500
Message-ID: <AANLkTimraXF9gVC-o5qb2mfDfrq6=9-CTtyGeew27ne6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

CIFS tree updated to back out the crypto/ntlmv2/ntlmssp change
(included patch 2/8 because it was reviewed and independent).   Added
to the cifs tree the fixes to prevent premature exit to cifsd and to
prevent the possibly ip address memory corruption.

-- 
Thanks,

Steve
