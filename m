From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 30/45] CIFS: Enable signing in SMB2
Date: Tue, 21 Aug 2012 09:35:11 +0200
Message-ID: <k0vdnf$434$1@ger.gmane.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org> <1342626541-29872-31-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-31-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Pavel,

> Use hmac-sha256 and rather than hmac-md5 that is used for CIFS/SMB.
> 
> Signature field in SMB2 header is 16 bytes instead of 8 bytes.

Sorry for the late reply, I just found a reference to this patch...

To me it seems that this patch doesn't take care of the fact that
the signing key in SMB2/3 belongs to the session and not to the transport
connection.

Does the SMB2 code support multiuser mounts yet?

Why are you using some "BSRSPYL " magic? I only saw that from Windows
clients
using SMB1. (Note: that servers just echo the signature from the
request, if they don't do signing).

metze
